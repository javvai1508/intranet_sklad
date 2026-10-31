<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();
function verifyPin(bool $ok, string $message): void {
    if (!$ok) throw new RuntimeException($message);
}
$c = createTestContainer();
$db = $c->getByType(Nette\Database\Explorer::class);
$db->query("ATTACH DATABASE ':memory:' AS dbo");
$db->query('CREATE TABLE dbo.TabCisZam (ID INT, Cislo INT, Jmeno TEXT, Prijmeni TEXT)');
$db->query('CREATE TABLE dbo.eTab_IntranetUziv (ID INT, ZamestnanecId INT, JmenoPrijmeni TEXT, PIN TEXT, Stav INT, PravaAdmin INT, PravaSklad INT, PravaInventura INT, PravaVyroba INT)');
$db->query("INSERT INTO dbo.TabCisZam VALUES (7, 123, 'Jan', 'Novák')");
$db->query("INSERT INTO dbo.eTab_IntranetUziv VALUES (42, 7, 'Test', '0012', 0, 0, 1, 0, 0)");
$m = $c->getByType(App\Models\UserModel::class);
$id = $m->authenticate('0012', '');
verifyPin($id->getId() === 42 && $id->getRoles() === ['sklad'] && $id->getData()['cislozam'] === 123, 'PIN / identity / employee mapping');
verifyPin(!array_key_exists('PIN', $id->getData()), 'PIN leaked to session');
foreach (['12', 'abcd', '00123', '9999'] as $pin) {
    try { $m->authenticate($pin, ''); throw new RuntimeException('Invalid PIN accepted'); }
    catch (Nette\Security\AuthenticationException $e) {}
}
foreach ([1, null] as $state) {
    $db->query('UPDATE dbo.eTab_IntranetUziv SET Stav = ?', $state);
    try { $m->authenticate('0012', ''); throw new RuntimeException('Inactive account accepted'); }
    catch (Nette\Security\AuthenticationException $e) {}
}
$db->query('UPDATE dbo.eTab_IntranetUziv SET Stav = 0, PravaSklad = 0');
try { $m->authenticate('0012', ''); throw new RuntimeException('No rights accepted'); }
catch (Nette\Security\AuthenticationException $e) {}
foreach (['PravaSklad' => 'sklad', 'PravaInventura' => 'inventura', 'PravaVyroba' => 'vyroba', 'PravaAdmin' => 'admin'] as $column => $role) {
    $db->query('UPDATE dbo.eTab_IntranetUziv SET PravaAdmin = 0, PravaSklad = 0, PravaInventura = 0, PravaVyroba = 0');
    $db->query('UPDATE dbo.eTab_IntranetUziv SET ' . $column . ' = 1');
    verifyPin($m->authenticate('0012', '')->getRoles() === [$role], 'Permission column mapping: ' . $column);
}
$db->query('UPDATE dbo.eTab_IntranetUziv SET PravaAdmin = 1');
verifyPin($m->authenticate('0012', '')->getRoles() === ['admin'], 'Admin mapping');
$db->query("INSERT INTO dbo.eTab_IntranetUziv VALUES (43, NULL, 'Duplicate', '0012', 1, 0, 1, 0, 0)");
try { $m->authenticate('0012', ''); throw new RuntimeException('Duplicate accepted'); }
catch (Nette\Security\AuthenticationException $e) {}
$user = $c->getByType(Nette\Security\User::class);
$factory = $c->getByType(Nette\Application\IPresenterFactory::class);
foreach ([['sklad'], ['inventura'], ['vyroba'], ['admin'], ['sklad', 'inventura']] as $roles) {
    $user->login(new Nette\Security\SimpleIdentity(42, $roles, ['authVersion' => 2, 'fullname' => 'Test']));
    $admin = in_array('admin', $roles, true);
    $warehouse = $admin || in_array('sklad', $roles, true);
    $inventory = $admin || in_array('inventura', $roles, true);
    $p = $factory->createPresenter('Material');
    verifyPin($p->hasAccess('sklad') === $warehouse && $p->hasAccess('inventura') === $inventory
        && $p->hasAccess('vyroba') === ($admin || in_array('vyroba', $roles, true)), 'Role combination');
    $p->autoCanonicalize = false;
    try {
        $response = $p->run(new Nette\Application\Request('Material', 'GET', ['action' => 'default']));
        verifyPin($warehouse || $inventory, 'Production account reached warehouse');
        $html = $response->getSource()->renderToString();
        verifyPin(str_contains($html, 'Inventura</span>') === $inventory, 'Inventory menu rights');
        verifyPin(str_contains($html, 'Převod do Schenkeru') === $warehouse, 'Warehouse menu rights');
    } catch (Nette\Application\BadRequestException $e) {
        verifyPin(!$warehouse && !$inventory && $e->getCode() === 403, 'Unexpected denial');
    }
    if (!$warehouse) {
        foreach ([['action' => 'showDispatch'], ['action' => 'default', 'do' => 'newTransferToLoukov'],
            ['action' => 'default', 'do' => 'readBarCodeToShopForm-submit']] as $params) {
            $p = $factory->createPresenter('Material');
            $p->autoCanonicalize = false;
            try {
                $p->run(new Nette\Application\Request('Material', 'POST', $params));
                throw new RuntimeException('Warehouse operation accessible without rights');
            } catch (Nette\Application\BadRequestException $e) {
                verifyPin($e->getCode() === 403, 'Wrong operation denial');
            }
        }
    }
    if (!$inventory) {
        $p = $factory->createPresenter('Inventory');
        $response = $p->run(new Nette\Application\Request('Inventory', 'GET', ['action' => 'default']));
        verifyPin($response instanceof Nette\Application\Responses\RedirectResponse, 'Inventory must reject warehouse-only / production users');
    }
}
$user->logout(true);
$p = $factory->createPresenter('Sign');
$p->autoCanonicalize = false;
$response = $p->run(new Nette\Application\Request('Sign', 'GET', ['action' => 'in']));
$html = $response->getSource()->renderToString();
verifyPin(str_contains($html, 'type="password"') && str_contains($html, 'inputmode="numeric"'), 'PIN form rendering');
$form = $p['signInForm'];
$form->setValues(['pin' => 'abc']);
$form->validate();
verifyPin($form->hasErrors(), 'Invalid PIN form accepted');
$user->login(new Nette\Security\SimpleIdentity(7, ['sklad'], ['fullname' => 'Legacy']));
$p = $factory->createPresenter('Homepage');
$response = $p->run(new Nette\Application\Request('Homepage', 'GET', ['action' => 'default']));
verifyPin(!$user->isLoggedIn() && $response instanceof Nette\Application\Responses\RedirectResponse, 'Legacy session still authorized');
echo "PIN authentication and permission checks passed\n";
