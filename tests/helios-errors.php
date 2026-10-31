<?php
require __DIR__ . '/bootstrap.php';
require __DIR__ . '/audit-fixture.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();
function heliosCheck(bool $ok, string $message): void { if (!$ok) throw new RuntimeException($message); }
function sqlError(int $number, string $text): Nette\Database\DriverException {
    $e = new Nette\Database\DriverException('SQLSTATE[42000]: [Microsoft][ODBC Driver 17 for SQL Server][SQL Server]' . $text);
    $e->errorInfo = ['42000', $number, $text];
    return $e;
}
$c = createTestContainer();
$db = $c->getByType(Nette\Database\Explorer::class);
createAuditFixture($db);
$db->query('CREATE TABLE dbo.TabInterniHlasky (Cislo INT, Hlaska TEXT)');
$db->query("INSERT INTO dbo.TabInterniHlasky VALUES (75001, 'Výrobní příkaz je uzavřený.'),
    (75002, 'Paleta %s již byla odvedena.'), (75003, 'Hodnota %d není platná.'), (75004, '')");
$messages = $c->getByType(App\Helpers\HeliosErrorMessages::class);
$original = sqlError(75001, 'Internal message');
$translated = $messages->translate($original);
heliosCheck($translated instanceof App\Helpers\HeliosException && $translated->getMessage() === 'Výrobní příkaz je uzavřený.'
    && $translated->getPrevious() === $original, 'Native error translation / original exception');
heliosCheck($messages->translate(sqlError(50000, '75002|001234'))->getMessage() === 'Paleta 001234 již byla odvedena.', 'Serialized Helios error');
heliosCheck($messages->translate(sqlError(75002, 'No argument')) === null, 'Unresolved placeholder displayed');
heliosCheck($messages->translate(sqlError(75003, 'No argument')) === null, 'Unsupported placeholder displayed');
heliosCheck($messages->translate(sqlError(75004, 'Empty')) === null, 'Empty message accepted');
heliosCheck($messages->translate(sqlError(102, 'Incorrect syntax near SECRET_SQL')) === null, 'Unknown SQL diagnostic exposed');
// Exercise the real transaction wrapper and the real logger together.
class HeliosTransactionModel extends App\Models\BaseModel {
    public function execute(callable $operation) { return $this->auditedTransaction($operation); }
}
$db->query('CREATE TABLE changes (ID INT)');
$user = $c->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(42, ['admin'], ['authVersion' => 2, 'fullname' => 'Test']));
$audit = $c->getByType(App\Audit\AuditLog::class);
$model = new HeliosTransactionModel($db); $model->setAuditLog($audit); $model->setHeliosErrorMessages($messages);
$db->getConnection()->onQuery[] = function ($connection, $result) use ($db): void {
    if ($result instanceof Nette\Database\ResultSet && str_contains($result->getQueryString(), 'SELECT Hlaska')) {
        heliosCheck(!$db->getConnection()->getPdo()->inTransaction(), 'Lookup happened inside failed transaction');
    }
};
$audit->begin(App\Audit\Action::PRODUCTION_COMPLETE);
try {
    $model->execute(function () use ($db) { $db->query('INSERT INTO changes VALUES (1)'); throw sqlError(75001, 'SQL diagnostic'); });
    throw new LogicException('Expected Helios rejection');
} catch (App\Helpers\HeliosException $e) {
    heliosCheck($e->getMessage() === 'Výrobní příkaz je uzavřený.', 'Wrong user message');
}
heliosCheck($db->query('SELECT COUNT(*) FROM changes')->fetchField() === 0, 'Failed operation committed');
$row = $db->query('SELECT * FROM dbo.eTab_IntranetLog ORDER BY ID DESC')->fetch();
heliosCheck($row->Vysledek === 2 && $row->Popis === 'Výrobní příkaz je uzavřený.'
    && json_decode($row->Detail, true)['cisloHlaskyHelios'] === 75001, 'Known Helios failure logged as SQL error');
$db->query('DROP TABLE dbo.TabInterniHlasky');
heliosCheck($messages->translate(sqlError(75001, 'diagnostic')) === null, 'Lookup failure replaced original failure');
ob_end_clean();
echo "PASS: Helios native/serialized codes, safe fallbacks, post-rollback lookup and business-rejection audit\n";
