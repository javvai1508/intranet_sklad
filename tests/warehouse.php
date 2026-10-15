<?php
set_error_handler(function ($severity, $message, $file, $line) { throw new ErrorException($message, 0, $severity, $file, $line); });

// Dependency-free regression tests: execute production model code with a deterministic DB double.
require __DIR__ . '/../app/models/BaseModel.php';
require __DIR__ . '/../app/models/MaterialModel.php';
require __DIR__ . '/../app/models/DeliveryNoteModel.php';
require __DIR__ . '/../app/models/ProductionModel.php';

final class TestResult
{
    public function __construct(private mixed $value = null) {}
    public function fetch() { return $this->value; }
    public function fetchField() { return $this->value; }
}
final class TestDatabase
{
    public array $queries = [];
    public int $commits = 0;
    public int $rollbacks = 0;
    public int $quantity = 10;
    public function __construct(public Closure $handler) {}
    public function getConnection() { return $this; }
    public function transaction(callable $callback) {
        $before = $this->quantity;
        try { $result = $callback(); $this->commits++; return $result; }
        catch (Throwable $e) { $this->quantity = $before; $this->rollbacks++; throw $e; }
    }
    public function query(string $sql, ...$parameters) {
        $this->queries[] = [$sql, $parameters];
        return new TestResult(($this->handler)($sql, $parameters, $this));
    }
}
function model(string $class, TestDatabase $db) {
    $model = (new ReflectionClass($class))->newInstanceWithoutConstructor();
    $model->db = $db;
    return $model;
}
function expect(bool $condition, string $message): void {
    if (!$condition) { throw new Exception($message); }
}
function rejects(callable $action): void {
    try { $action(); } catch (RuntimeException $e) { return; }
    throw new Exception('Expected the operation to be rejected');
}
function headerRow(array $overrides = []): object {
    return (object) array_merge(['ID' => 1, 'DatRealizace' => null, 'StavPrevodu' => 0, 'Closed' => null, 'Linked' => 0], $overrides);
}
$tests = [];
$tests['lock failure prevents writes'] = function () {
    $db = new TestDatabase(fn() => -1);
    $m = model(App\Models\BaseModel::class, $db);
    rejects(fn() => $m->warehouseOperation(function () { throw new Exception('Must not run'); }));
    expect($db->rollbacks === 1 && count($db->queries) === 1, 'Lock failure must roll back');
};
$tests['closed documents reject deletion'] = function () {
    foreach ([['Closed' => '2026-10-15'], ['DatRealizace' => '2026-10-15'], ['StavPrevodu' => 1], ['Linked' => 1]] as $state) {
        $db = new TestDatabase(fn($sql) => str_contains($sql, 'sp_getapplock') ? 0 : headerRow($state));
        $m = model(App\Models\MaterialModel::class, $db);
        rejects(fn() => $m->removeDispatchItem(5, 1));
        expect(count($db->queries) === 2 && $db->rollbacks === 1, 'Closed document changed');
    }
};
$tests['foreign item rejects deletion'] = function () {
    $db = new TestDatabase(fn($sql) => str_contains($sql, 'sp_getapplock') ? 0 : (str_contains($sql, 'UPDLOCK') ? headerRow() : null));
    $m = model(App\Models\MaterialModel::class, $db);
    rejects(fn() => $m->removeDispatchItem(999, 1));
    expect(count($db->queries) === 3 && $db->rollbacks === 1, 'Foreign item changed');
};
$tests['foreign serial rejects deletion'] = function () {
    $db = new TestDatabase(function ($sql) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'FROM TabDokladyZbozi d WITH')) return headerRow();
        if (str_contains($sql, 'SELECT ID FROM TabPohybyZbozi')) return (object) ['ID' => 5];
        return null;
    });
    $m = model(App\Models\MaterialModel::class, $db);
    rejects(fn() => $m->removeDispatchItemSN(999, 1, 5));
    expect(count($db->queries) === 4 && $db->rollbacks === 1, 'Foreign serial changed');
};
$tests['failed delete rolls quantity back'] = function () {
    $db = new TestDatabase(function ($sql, $params, $db) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'FROM TabDokladyZbozi d WITH')) return headerRow();
        if (str_contains($sql, 'SELECT ID FROM TabPohybyZbozi') || str_contains($sql, 'SELECT vc.ID')) return (object) ['ID' => 5];
        if (str_contains($sql, 'AS MnozstviSN')) return (object) ['ItemId' => 5, 'MnozstviSN' => 4];
        if (str_contains($sql, 'UPDATE TabPohybyZbozi')) { $db->quantity -= $params[0]; return true; }
        if (str_contains($sql, 'DELETE FROM TabVyrCP')) throw new RuntimeException('Simulated SQL failure');
        throw new Exception('Unexpected query: ' . $sql);
    });
    $m = model(App\Models\MaterialModel::class, $db);
    rejects(fn() => $m->removeDispatchItemSN(7, 1, 5));
    expect($db->quantity === 10 && $db->commits === 0 && $db->rollbacks === 1, 'Partial write committed');
};
$tests['close without state change rolls back'] = function () {
    $db = new TestDatabase(function ($sql) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'FROM TabDokladyZbozi d WITH')) return headerRow();
        if (str_contains($sql, 'EXEC dbo.')) return true;
        return (object) ['StavDLExp' => 0];
    });
    $m = model(App\Models\DeliveryNoteModel::class, $db);
    rejects(fn() => $m->closeDeliveryNote(1));
    expect($db->rollbacks === 1, 'Unconfirmed close committed');
};
$tests['successful close commits'] = function () {
    $db = new TestDatabase(function ($sql) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'FROM TabDokladyZbozi d WITH')) return headerRow();
        if (str_contains($sql, 'EXEC dbo.')) return true;
        return (object) ['StavDLExp' => 1];
    });
    expect(model(App\Models\DeliveryNoteModel::class, $db)->closeDeliveryNote(1) === true, 'Close failed');
    expect($db->commits === 1 && $db->rollbacks === 0, 'Close not committed');
};
$tests['repeat scan rejected before insert'] = function () {
    $db = new TestDatabase(function ($sql) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'FROM TabDokladyZbozi d WITH')) return headerRow();
        if (str_contains($sql, 'SELECT ID FROM TabPohybyZbozi')) return (object) ['ID' => 5];
        if (str_contains($sql, 'IDVCP')) return (object) ['IDPohyb' => 5, 'IDVCP' => 7];
        throw new Exception('Unexpected query');
    });
    $m = model(App\Models\DeliveryNoteModel::class, $db);
    rejects(fn() => $m->updateDeliveryNoteItemFromStock(1, 5, 7, '123', 10));
    expect($db->rollbacks === 1, 'Repeated scan committed');
};
$tests['production failure rolls back'] = function () {
    $db = new TestDatabase(function ($sql) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'SELECT VyrCislo')) return (object) ['VyrCislo' => '123'];
        if (str_contains($sql, 'AS Zadane')) return (object) ['IDVyrCis' => 7, 'Zadane' => 10, 'Odvedeno' => 0, 'OdvedenoNereal' => 0];
        return (object) ['IDPrijem' => null, 'Msg' => 'Failed'];
    });
    rejects(fn() => model(App\Models\ProductionModel::class, $db)->closeProduction(7, 123));
    expect($db->rollbacks === 1 && $db->commits === 0, 'Production failure committed');
};
foreach ($tests as $name => $test) { $test(); echo "PASS: $name\n"; }
