<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();
function deviceCheck(bool $ok, string $message): void {
    if (!$ok) throw new RuntimeException($message);
}
$c = createTestContainer();
$db = $c->getByType(Nette\Database\Explorer::class);
$db->query("ATTACH DATABASE ':memory:' AS dbo");
$db->query('CREATE TABLE dbo.eTab_IntranetZarizeni (ID INT PRIMARY KEY, Kod TEXT, Nazev TEXT,
    Model TEXT, VyrobniCislo TEXT, Povoleno INT, TokenHash TEXT,
    DatumRegistrace TEXT, DatumPosledniAktivity TEXT)');
$db->query("INSERT INTO dbo.eTab_IntranetZarizeni (ID, Kod, Nazev, Model, Povoleno)
    VALUES (1, 'SKLAD-01', 'Čtečka 01', 'TC21', 1), (2, 'SKLAD-02', 'Čtečka 02', 'TC7', 0)");
$m = $c->getByType(App\Models\DeviceModel::class);
deviceCheck(count($m->getAvailableDevices()) === 1, 'Disabled device offered');
$token = $m->register(1, false);
deviceCheck(strlen($token) === 64 && $m->findByToken($token)->ID === 1, 'Registration cannot be resolved');
$stored = $db->query('SELECT * FROM dbo.eTab_IntranetZarizeni WHERE ID = 1')->fetch();
deviceCheck($stored->TokenHash === hash('sha256', $token) && $stored->TokenHash !== $token, 'Raw token stored');
deviceCheck($stored->DatumRegistrace !== null, 'Registration date missing');
foreach ([[1, false], [2, true], [999, true]] as [$id, $replace]) {
    try { $m->register($id, $replace); throw new LogicException('Invalid registration accepted'); }
    catch (RuntimeException $e) { deviceCheck(!$e instanceof LogicException, $e->getMessage()); }
}
$newToken = $m->register(1, true);
deviceCheck($m->findByToken($token) === null && $m->findByToken($newToken)->ID === 1, 'Old token still valid');
deviceCheck($m->findByToken('bad-token') === null, 'Malformed token accepted');
$db->query('UPDATE dbo.eTab_IntranetZarizeni SET Povoleno = 0 WHERE ID = 1');
deviceCheck($m->findByToken($newToken) === null, 'Disabled device still recognized');
$db->query('UPDATE dbo.eTab_IntranetZarizeni SET Povoleno = 1 WHERE ID = 1');
$request = new Nette\Http\Request(new Nette\Http\UrlScript('https://sklad.example/app/'), cookies: [App\Helpers\DeviceIdentity::COOKIE => $newToken]);
$identity = new App\Helpers\DeviceIdentity($m, $request, $c->getByType(Nette\Http\IResponse::class));
deviceCheck($identity->getDevice()->ID === 1, 'Cookie recognition failed');
$user = $c->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(42, ['admin'], ['authVersion' => 2, 'fullname' => 'Test']));
$user->logout(true);
deviceCheck($identity->getDevice()->ID === 1, 'Logout removed device identity');
$factory = $c->getByType(Nette\Application\IPresenterFactory::class);
foreach (['sklad', 'inventura', 'vyroba', 'admin'] as $role) {
    $user->login(new Nette\Security\SimpleIdentity(42, [$role], ['authVersion' => 2, 'fullname' => 'Test']));
    $p = $factory->createPresenter('Homepage');
    $p->autoCanonicalize = false;
    $response = $p->run(new Nette\Application\Request('Homepage', 'GET', ['action' => 'default']));
    $html = $response->getSource()->renderToString();
    deviceCheck(str_contains($html, 'Nastavení') === ($role === 'admin'), 'Settings menu rights');
    foreach (['GET', 'POST'] as $method) {
        $p = $factory->createPresenter('Settings');
        $p->autoCanonicalize = false;
        try {
            $response = $p->run(new Nette\Application\Request('Settings', $method, ['action' => 'default']));
            deviceCheck($role === 'admin', 'Non-admin reached settings');
            $html = $response->getSource()->renderToString();
            deviceCheck(str_contains($html, 'SKLAD-01') && !str_contains($html, 'SKLAD-02'), 'Device selection rendering');
            deviceCheck(str_contains($html, '_token_') && str_contains($html, 'name="replace"'), 'Protection or confirmation missing');
        } catch (Nette\Application\BadRequestException $e) {
            deviceCheck($role !== 'admin' && $e->getCode() === 403, 'Unexpected settings denial');
        }
    }
}
ob_end_clean();
echo "PASS: device registration, token replacement, blocking, cookie identity, logout, Admin access and Latte rendering\n";
