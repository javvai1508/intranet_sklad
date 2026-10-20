<?php
// Reuse the deterministic database double and baseline warehouse regressions.
require __DIR__ . '/warehouse.php';
require __DIR__ . '/../app/models/LoukovReceiptModel.php';

function receptionFixture(array $changes = []): array {
    $state = (object) array_merge([
        'exists' => true, 'ready' => 1, 'completed' => null,
        'pallets' => [(object) ['ID' => 7, 'SerialNumber' => '123', 'Quantity' => '1.250000',
            'ReceivedQuantity' => null, 'ScannedAt' => null, 'Confirmed' => 0]],
        'inconsistent' => false, 'extExists' => true, 'failInsert' => false, 'failFinish' => false,
    ], $changes);
    $db = new TestDatabase(function ($sql, $params) use ($state) {
        if (str_contains($sql, 'sp_getapplock')) return 0;
        if (str_contains($sql, ' AS CompletedAt')) {
            expect(array_slice($params, 0, 4) === ['00100304', '384', '00100308', '351'], 'Wrong transfer scope');
            expect(str_contains($sql, 'WITH (UPDLOCK, HOLDLOCK)'), 'Mutation must lock document');
            return $state->exists ? (object) ['Ready' => $state->ready, 'CompletedAt' => $state->completed] : null;
        }
        if (str_contains($sql, ' AS ReceivedQuantity')) {
            expect(str_contains($sql, 'WITH (UPDLOCK, HOLDLOCK)'), 'Mutation must lock pallets');
            foreach ($state->pallets as $p) {
                $p->Confirmed = (int) ($p->ScannedAt !== null && $p->Quantity > 0 && $p->ReceivedQuantity === $p->Quantity);
            }
            return $state->pallets;
        }
        if (str_contains($sql, 'UPDATE e SET _exp_schenker_datcas')) {
            expect(str_contains($sql, '_exp_schenker_mnoz = cp.Mnozstvi') && $params === [7], 'Quantity must be copied from selected SQL row');
            if ($state->extExists) {
                $state->pallets[0]->ScannedAt = '2026-10-20 18:45:00';
                $state->pallets[0]->ReceivedQuantity = $state->pallets[0]->Quantity;
            }
            return true;
        }
        if (str_contains($sql, 'INSERT INTO TabVyrCP_EXT')) {
            if ($state->failInsert) throw new RuntimeException('SQL failure');
            if (!$state->extExists) {
                $state->extExists = true;
                $state->pallets[0]->ScannedAt = '2026-10-20 18:45:00';
                $state->pallets[0]->ReceivedQuantity = $state->pallets[0]->Quantity;
            }
            return true;
        }
        if (str_contains($sql, 'AS InconsistentItem')) return $state->inconsistent ? (object) ['ID' => 5] : null;
        if (str_contains($sql, 'UPDATE TabDokladyZbozi_EXT SET _exp_schenker_datzprac')) {
            if (!$state->failFinish) $state->completed = '2026-10-20 18:46:00';
            return true;
        }
        throw new Exception('Unexpected receipt SQL: ' . $sql);
    });
    return [model(App\Models\LoukovReceiptModel::class, $db), $db, $state];
}
foreach ([true, false] as $extExists) {
    [$m, $db, $state] = receptionFixture(['extExists' => $extExists]);
    expect($m->confirmPallet(42, '123'), 'Confirmation failed');
    expect($state->pallets[0]->ReceivedQuantity === '1.250000' && $db->commits === 1, 'Decimal quantity lost');
    rejects(fn() => $m->confirmPallet(42, '123'));
    expect($db->rollbacks === 1, 'Duplicate scan not rejected');
    expect($m->finish(42) && $state->completed !== null, 'Complete receipt did not close');
    rejects(fn() => $m->finish(42));
    rejects(fn() => $m->confirmPallet(42, '123'));
}
foreach ([['exists' => false], ['ready' => 0], ['completed' => '2026-10-20']] as $invalid) {
    [$m, $db] = receptionFixture($invalid);
    rejects(fn() => $m->confirmPallet(42, '123'));
    expect(count($db->queries) === 2 && $db->commits === 0, 'Invalid header reached write');
}
[$m, $db] = receptionFixture();
rejects(fn() => $m->confirmPallet(42, '999'));
expect(count($db->queries) === 3, 'Foreign pallet reached write');
[$m, $db, $state] = receptionFixture();
$state->pallets[] = clone $state->pallets[0];
rejects(fn() => $m->confirmPallet(42, '123'));
expect(count($db->queries) === 3, 'Ambiguous pallet reached write');
[$m, $db, $state] = receptionFixture();
$state->pallets[0]->Quantity = '0.000000';
rejects(fn() => $m->confirmPallet(42, '123'));
expect(count($db->queries) === 3, 'Zero quantity reached write');
[$m, $db] = receptionFixture(['failInsert' => true, 'extExists' => false]);
rejects(fn() => $m->confirmPallet(42, '123'));
expect($db->rollbacks === 1 && $db->commits === 0, 'Failed scan not rolled back');
foreach ([[], ['pallets' => []]] as $invalid) {
    [$m, $db] = receptionFixture($invalid);
    rejects(fn() => $m->finish(42));
    expect($db->commits === 0, 'Incomplete or empty receipt closed');
}
[$m, $db, $state] = receptionFixture();
$m->confirmPallet(42, '123');
$state->pallets[0]->Quantity = '2.500000';
rejects(fn() => $m->finish(42));
expect($state->completed === null, 'Changed quantity closed');
[$m, $db, $state] = receptionFixture(['inconsistent' => true]);
$m->confirmPallet(42, '123');
rejects(fn() => $m->finish(42));
expect($state->completed === null, 'Item without matching pallets closed');
[$m, $db, $state] = receptionFixture(['failFinish' => true]);
$m->confirmPallet(42, '123');
rejects(fn() => $m->finish(42));
expect($db->rollbacks === 1, 'Unconfirmed completion committed');

// Loukov remains pending after source close/realisation until destination completion.
$db = new TestDatabase(function ($sql, $params) {
    if ($params[0] === '384') {
        expect(str_contains($sql, 'doe._exp_schenker_datzprac IS NULL'), 'Destination completion ignored');
        expect(!str_contains($sql, 'do.DatRealizace IS NULL') && !str_contains($sql, 'doe._exp_dat_uzavreno IS NULL'), 'Source close hides pending reception');
    } else {
        expect(str_contains($sql, 'do.DatRealizace IS NULL') && str_contains($sql, 'doe._exp_dat_uzavreno IS NULL'), 'Schenker lookup changed');
    }
    return [];
});
$m = model(App\Models\MaterialModel::class, $db);
$m->checkDispatchOpen('toLoukov');
$m->checkDispatchOpen('toSchenker');
echo "PASS: Loukov receipt scope, decimal confirmation, duplicates, missing EXT, completeness, rollback and lifecycle\n";
