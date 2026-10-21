<?php
require __DIR__ . '/warehouse.php';
require __DIR__ . '/../app/models/InventoryModel.php';

use App\Models\InventoryModel;

expect(InventoryModel::normalizeBarcode(' 0000123 ') === '00123', 'Significant zeros lost');
foreach (['123', '00', '00x', '00' . str_repeat('1', 101)] as $bad) {
    rejects(fn() => InventoryModel::normalizeBarcode($bad));
}
foreach (['0' => '0.000000', '1,25' => '1.250000', '9999999999999.999999' => '9999999999999.999999'] as $in => $out) {
    expect(InventoryModel::normalizeQuantity((string) $in) === $out, 'Decimal precision lost');
}
foreach (['-1', '1e2', 'NaN', '', '1.0000001', '10000000000000', '1 000', '1,2.3'] as $bad) {
    rejects(fn() => InventoryModel::normalizeQuantity($bad));
}
function inventoryFixture(array $overrides = []): array {
    $row = (object) array_merge([
        'Id' => 7, 'IdDoklad' => 42, 'IdSklad' => 80, 'IdVyrCS' => 10, 'IDUmisteni' => null,
        'Uzav' => 0, 'SerialNumber' => '123', 'StockQuantity' => '10.000000',
        'InventoryQuantity' => '0.000000', 'UnitQuantity' => '0.000000',
        'Conversion' => '2', 'MJ' => 'bal', 'EvidenceUnit' => 'ks', 'CheckId' => null, 'Confirmed' => 0,
    ], $overrides);
    $state = (object) ['row' => $row, 'open' => true, 'found' => true, 'auditFailure' => false];
    $db = new TestDatabase(function ($sql, $params, $db) use ($state) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, 'SELECT h.Id, h.IdSklad')) {
            expect(str_contains($sql, 'UPDLOCK, HOLDLOCK'), 'Missing inventory lock');
            expect(str_contains($sql, 'h.VC = 1') && str_contains($sql, 'h.DatumClose IS NULL')
                && str_contains($sql, 'h.Stav = 0') && str_contains($sql, 'h.IdVydej IS NULL'), 'Invalid inventory scope');
            return $state->open ? (object) ['Id' => 42] : null;
        }
        if (str_contains($sql, 'SELECT i.Id,')) {
            expect($params[0] === 42, 'Wrong inventory bound');
            if (str_contains($sql, 'AND i.Id = ?')) expect($params[1] === 7, 'Wrong item bound');
            return $state->found ? [clone $state->row] : [];
        }
        if (str_contains($sql, 'UPDATE TabInvItem')) {
            expect(str_contains($sql, '/ PrepMnozstvi') && str_contains($sql, 'numeric(19,6)')
                && str_contains($sql, 'Uzav = 0'), 'Conversion or closed item protection missing');
            expect($params[0] === $params[1] && $params[3] === 7 && $params[4] === 42, 'Wrong update scope');
            $state->row->InventoryQuantity = $params[0];
            $state->row->UnitQuantity = number_format((float) $params[0] / (float) $state->row->Conversion, 6, '.', '');
            $db->quantity = 99;
            return true;
        }
        if (str_contains($sql, 'INSERT INTO dbo.eTab_IntranetInvCheck')) {
            if ($state->auditFailure) throw new RuntimeException('Audit failed');
            $state->row->CheckId = (int) $state->row->CheckId + 1;
            $state->row->Confirmed = 1;
            return true;
        }
        if (str_contains($sql, 'INSERT INTO dbo.eTab_IntranetInvDiscrepancy')) {
            expect($params === [42, '999', 'poznámka', '1', 42, '999'], 'Unknown pallet not scoped');
            expect(str_contains($sql, 'NOT EXISTS') && str_contains($sql, 'UPDLOCK, HOLDLOCK'), 'Duplicate report protection missing');
            return true;
        }
        throw new Exception('Unexpected inventory SQL: ' . $sql);
    });
    return [model(InventoryModel::class, $db), $db, $state];
}
[$m, $db, $s] = inventoryFixture();
$version = InventoryModel::version($s->row);
expect($m->saveQuantity(42, 7, '12,5', $version, false, false, '1'), 'Save failed');
expect($s->row->InventoryQuantity === '12.500000' && $s->row->UnitQuantity === '6.250000'
    && $db->commits === 1, 'Inventory conversion/commit failed');
rejects(fn() => $m->saveQuantity(42, 7, '12,5', $version, false, false, '1'));
rejects(fn() => $m->saveQuantity(42, 7, '8', InventoryModel::version($s->row), false, false, '1'));
expect($m->saveQuantity(42, 7, '8', InventoryModel::version($s->row), true, false, '1'), 'Explicit correction failed');
expect($s->row->InventoryQuantity === '8.000000' && $s->row->CheckId === 2, 'Correction added instead of replacing');

[$m, $db, $s] = inventoryFixture();
$v = InventoryModel::version($s->row);
rejects(fn() => $m->saveQuantity(42, 7, '0', $v, false, false, '1'));
expect(count($db->queries) === 0, 'Unconfirmed zero reached DB');
expect($m->saveQuantity(42, 7, '0', $v, false, true, '1') && $s->row->Confirmed === 1, 'Confirmed zero indistinguishable from unchecked');

foreach (['closedInventory', 'missingItem', 'lockedItem', 'staleQuantity', 'staleConversion', 'badConversion', 'staleRevision'] as $case) {
    [$m, $db, $s] = inventoryFixture();
    $v = InventoryModel::version($s->row);
    if ($case === 'closedInventory') $s->open = false;
    if ($case === 'missingItem') $s->found = false;
    if ($case === 'lockedItem') $s->row->Uzav = 1;
    if ($case === 'staleQuantity') $s->row->InventoryQuantity = '4.000000';
    if ($case === 'staleConversion') $s->row->Conversion = '4';
    if ($case === 'staleRevision') $s->row->CheckId = 1;
    if ($case === 'badConversion') { $s->row->Conversion = '0'; $v = InventoryModel::version($s->row); }
    rejects(fn() => $m->saveQuantity(42, 7, '5', $v, true, false, '1'));
    expect($db->commits === 0 && $db->rollbacks === 1 && $db->quantity === 10, 'Invalid state wrote quantity: ' . $case);
}
[$m, $db, $s] = inventoryFixture();
$s->auditFailure = true;
rejects(fn() => $m->saveQuantity(42, 7, '5', InventoryModel::version($s->row), false, false, '1'));
expect($db->rollbacks === 1 && $db->quantity === 10, 'Audit failure did not roll back quantity');

[$m, $db, $s] = inventoryFixture();
rejects(fn() => $m->reportUnknown(42, '999', 'poznámka', '1'));
$s->found = false;
expect($m->reportUnknown(42, '999', 'poznámka', '1'), 'Unknown report failed');
rejects(fn() => $m->reportUnknown(42, 'not a pallet', '', '1'));
rejects(fn() => $m->reportUnknown(42, '999', str_repeat('ž', 1001), '1'));
rejects(fn() => $m->reportUnknown(42, '999', chr(255), '1'));
echo "PASS: inventory decimals, conversion, zero, duplicate scans, correction, stale forms, locks, rollback and unknown pallets\n";
