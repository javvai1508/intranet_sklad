<?php
require __DIR__ . '/bootstrap.php';
require __DIR__ . '/audit-fixture.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();
use App\Audit\Action;
use App\Audit\AuditLog;
function auditCheck(bool $condition, string $message): void {
    if (!$condition) throw new RuntimeException($message);
}
$c = createTestContainer();
$db = $c->getByType(Nette\Database\Explorer::class);
createAuditFixture($db);
$db->query('CREATE TABLE dbo.eTab_IntranetZarizeni (ID INT PRIMARY KEY, Povoleno INT, TokenHash TEXT, DatRegistrace TEXT, DatPosledniAktivity TEXT)');
$db->query('CREATE TABLE TabPohybyZbozi (ID INT, IDDoklad INT)');
$db->query('CREATE TABLE TabVyrCS (ID INT, Nazev1 TEXT)');
$db->query('CREATE TABLE TabVyrCP (ID INT, IDPolozkaDokladu INT, IDVyrCis INT, Mnozstvi TEXT)');
$db->query("INSERT INTO TabPohybyZbozi VALUES (5, 10)");
$db->query("INSERT INTO TabVyrCS VALUES (8, '001234')");
$db->query("INSERT INTO TabVyrCP VALUES (7, 5, 8, '12.500000')");
$token = bin2hex(random_bytes(32));
$db->query('INSERT INTO dbo.eTab_IntranetZarizeni (ID, Povoleno, TokenHash) VALUES (3, 1, ?)', hash('sha256', $token));
$user = $c->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(42, ['admin'], ['authVersion' => 2, 'fullname' => 'Test']));
$http = new Nette\Http\Request(new Nette\Http\UrlScript('https://test.example/'), cookies: ['intranet_device' => $token]);
$audit = new AuditLog($db, $user, $http);
class AuditTransactionModel extends App\Models\BaseModel {
    public function run(callable $operation) { return $this->auditedTransaction($operation); }
}
$model = new AuditTransactionModel($db);
$model->setAuditLog($audit);
$audit->begin(Action::DELIVERY_REMOVE, ['IDDoklad' => 10, 'IDVyrCP' => 7]);
$model->run(function () use ($db) { $db->query('DELETE FROM TabVyrCP WHERE ID = 7'); return true; });
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
auditCheck($row->Vysledek === 1 && $row->IDUzivatel === 42 && $row->IDZarizeni === 3, 'Actor/device missing');
auditCheck($row->Autor === 'sql-test-login' && $row->DatPorizeni !== null && $row->Zmenil === null, 'Helios columns');
auditCheck($row->SSCC === '001234' && $row->IDVyrCP === 7, 'Deleted pallet identity lost');
auditCheck(json_decode($row->Detail, true)['palety'][0]['Mnozstvi'] === '12.500000', 'Decimal snapshot lost');
auditCheck((bool) preg_match('/^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-8[a-f0-9]{3}-[a-f0-9]{12}$/D', $row->IDOperace), 'Invalid operation UUID');
$audit->failure('Must not duplicate success');
auditCheck($db->query('SELECT COUNT(*) FROM dbo.eTab_IntranetLog')->fetchField() === 1, 'Duplicate event');
// Failed operation rolls back its data and logs only the rejection after rollback.
$audit->begin(Action::TRANSFER_CREATE);
try {
    $model->run(function () use ($db) {
        $db->query('INSERT INTO TabPohybyZbozi VALUES (6, 11)');
        throw new RuntimeException('Doklad je uzavřený.');
    });
    throw new LogicException('Expected failure');
} catch (RuntimeException $e) {}
auditCheck(!$db->query('SELECT ID FROM TabPohybyZbozi WHERE ID = 6')->fetch(), 'Business rollback failed');
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
auditCheck($row->Vysledek === 2 && $row->Popis === 'Doklad je uzavřený.', 'Rejection lost after rollback');
// An audit INSERT failure must roll back an otherwise successful mutation.
$db->query("CREATE TRIGGER dbo.reject_audit BEFORE INSERT ON eTab_IntranetLog BEGIN SELECT RAISE(FAIL, 'log unavailable'); END");
$audit->begin(Action::TRANSFER_CREATE);
try { $model->run(function () use ($db) { $db->query('INSERT INTO TabPohybyZbozi VALUES (9, 99)'); return true; }); }
catch (Nette\Database\DriverException $e) {}
auditCheck(!$db->query('SELECT ID FROM TabPohybyZbozi WHERE ID = 9')->fetch(), 'Unlogged mutation committed');
$db->query('DROP TRIGGER dbo.reject_audit');
// Login never attributes a failed attempt to a previously authenticated user.
$audit->begin(Action::LOGIN);
$audit->failure('Neplatný PIN.');
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
auditCheck($row->IDUzivatel === null && !str_contains($row->Detail ?? '', $token), 'Credential / actor leakage');
$audit->begin(Action::LOGIN); $audit->complete();
auditCheck($db->query('SELECT IDUzivatel FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetchField() === 42, 'Login actor missing');
// Device token change and its success log commit atomically; the token itself is never logged.
$devices = $c->getByType(App\Models\DeviceModel::class);
$devices->setAuditLog($audit);
$audit->begin(Action::DEVICE_REGISTER, [], ['ciloveZarizeni' => 3]);
$registeredToken = $devices->register(3, true);
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
auditCheck($row->IDAkce === Action::DEVICE_REPLACE && $row->IDZarizeni === 3 && $row->Vysledek === 1, 'Device event classification');
auditCheck(!str_contains($row->Detail, $registeredToken) && !str_contains($row->Detail, hash('sha256', $registeredToken)), 'Registration token leaked');
// Real presenter request routing starts the correct scope, including early barcode rejection.
$name = $c->findByType(AuditLog::class)[0]; $c->removeService($name); $c->addService($name, $audit);
$p = $c->getByType(Nette\Application\IPresenterFactory::class)->createPresenter('Production');
$p->autoCanonicalize = false;
$response = $p->run(new Nette\Application\Request('Production', 'POST',
    ['action' => 'default', 'do' => 'readBarCodeForm-submit'], ['BarCode' => 'not-a-pallet']));
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
auditCheck($row->IDAkce === Action::PRODUCTION_COMPLETE && $row->Vysledek === 2, 'Request scope / rejected form not logged');
// Ordinary refresh is not an event.
$count = $db->query('SELECT COUNT(*) FROM dbo.eTab_IntranetLog')->fetchField();
$p = $c->getByType(Nette\Application\IPresenterFactory::class)->createPresenter('Homepage');
$p->autoCanonicalize = false;
$p->run(new Nette\Application\Request('Homepage', 'GET', ['action' => 'default']));
auditCheck($db->query('SELECT COUNT(*) FROM dbo.eTab_IntranetLog')->fetchField() === $count, 'Refresh logged');
ob_end_clean();
echo "PASS: audit actors, Helios columns, deleted pallets, decimals, UUID, rollback, failed audit, login privacy and request routing\n";
