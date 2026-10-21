<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();

final class InventoryPageModel extends App\Models\InventoryModel
{
    public array $calls = [];
    public bool $open = true;
    public bool $checked = false;
    public bool $ambiguous = false;
    public function __construct() {}
    public function getInventories(): array {
        $this->calls[] = ['list'];
        return [Nette\Database\Row::from(['Id' => 42, 'IdSklad' => '00100308', 'Popis' => 'Test inventury'])];
    }
    public function getInventory(int $id, bool $lock = false) {
        $this->calls[] = ['header', $id];
        return $this->open && $id === 42 ? $this->getInventories()[0] : null;
    }
    public function getItems(int $id, ?string $serial = null, ?int $itemId = null, bool $lock = false): array {
        $this->calls[] = ['items', $id, $serial, $itemId];
        if ($id !== 42 || ($serial !== null && $serial !== '123') || ($itemId !== null && $itemId !== 7)) return [];
        $r = Nette\Database\Row::from(['Id' => 7, 'IdDoklad' => 42, 'IdSklad' => 80, 'IdVyrCS' => 10,
            'IDUmisteni' => null, 'LocationCode' => null, 'LocationName' => null, 'Uzav' => 0, 'SerialNumber' => '123', 'Nazev1' => 'Test výrobek', 'RegCis' => '100',
            'MJ' => 'bal', 'EvidenceUnit' => 'ks', 'StockQuantity' => '10.000000',
            'InventoryQuantity' => $this->checked ? '8.000000' : '0.000000',
            'UnitQuantity' => $this->checked ? '4.000000' : '0.000000', 'Conversion' => '2',
            'CheckId' => $this->checked ? 1 : null, 'Confirmed' => (int) $this->checked,
            'CheckedAt' => $this->checked ? '2026-10-21 10:00:00' : null, 'CheckedBy' => '1']);
        return $this->ambiguous ? [$r, Nette\Database\Row::from(array_merge((array) $r, ['Id' => 8, 'IDUmisteni' => 1234, 'LocationCode' => 'A-01', 'LocationName' => 'Regál A']))] : [$r];
    }
    public function locatePallet(string $serial): array {
        return $serial === '999' ? [Nette\Database\Row::from(['SerialNumber' => '999', 'IDSklad' => '00100304', 'Nazev1' => 'Jiný výrobek', 'Quantity' => '5.000000'])] : [];
    }
    public function getDiscrepancies(int $id): array { return []; }
    public function saveQuantity(int $id, int $itemId, string $quantity, string $version, bool $correction, bool $zeroConfirmed, string $user): bool {
        $this->calls[] = ['save', $id, $itemId, $quantity, $version, $correction, $zeroConfirmed, $user];
        $this->checked = true;
        return true;
    }
    public function reportUnknown(int $id, string $serial, string $note, string $user): bool {
        $this->calls[] = ['report', $id, $serial, $note, $user];
        return true;
    }
}
function hasInvCsrf(Nette\Application\UI\Form $form): bool {
    foreach ($form->getControls() as $control) {
        if ($control instanceof Nette\Forms\Controls\CsrfProtection) return true;
    }
    return false;
}
function invCheck(bool $ok, string $message): void { if (!$ok) throw new RuntimeException($message); }
function invRedirect(callable $action): void {
    try { $action(); } catch (Nette\Application\AbortException $e) { return; }
    throw new RuntimeException('Expected redirect');
}
$container = createTestContainer();
$name = $container->findByType(App\Models\InventoryModel::class)[0];
$container->removeService($name);
$model = new InventoryPageModel;
$container->addService($name, $model);
$user = $container->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(1, ['sklad'], ['fullname' => 'Test', 'vychozi' => 2]));
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
function invPage(string $action, array $params = []): array {
    global $factory;
    $p = $factory->createPresenter('Inventory');
    $p->autoCanonicalize = false;
    $response = $p->run(new Nette\Application\Request('Inventory', 'GET', ['action' => $action] + $params));
    invCheck($response instanceof Nette\Application\Responses\TextResponse, 'Expected inventory HTML');
    return [$p, $response->getSource()->renderToString()];
}
[, $html] = invPage('default');
invCheck(str_contains($html, '00100308') && str_contains($html, 'Test inventury'), 'Inventory selection missing');
[$p, $html] = invPage('show', ['id' => 42]);
invCheck(str_contains($html, 'scanForm') && str_contains($html, 'Test výrobek'), 'Scan/list UI missing');
$form = $p['scanForm'];
invCheck(hasInvCsrf($form), 'Scan lacks CSRF');
$callback = $form->onSuccess[0];
invRedirect(fn() => $callback($form, (object) ['barcode' => '00123']));
invCheck(end($model->calls) === ['items', 42, '123', null], 'Wrong inventory/pallet scan');
[$p, $html] = invPage('item', ['id' => 42, 'itemId' => 7]);
invCheck(str_contains($html, '10.000000') && str_contains($html, 'quantityForm'), 'Quantity default missing');
$form = $p['quantityForm'];
invCheck($form['quantity']->getValue() === '10.000000', 'Stock quantity not prefilled');
invCheck(hasInvCsrf($form), 'Quantity lacks CSRF');
$v = $form['version']->getValue();
$callback = $form->onSuccess[0];
invRedirect(fn() => $callback($form, (object) ['quantity' => '8', 'version' => $v, 'correction' => false, 'zero' => false]));
invCheck(end($model->calls) === ['save', 42, 7, '8', $v, false, false, '1'], 'Wrong quantity save/actor');
[$p, $html] = invPage('item', ['id' => 42, 'itemId' => 7]);
invCheck($p['quantityForm']['quantity']->getValue() === '8.000000' && str_contains($html, 'Opravit dříve'), 'Repeat scan hides correction');
$model->ambiguous = true;
[, $html] = invPage('show', ['id' => 42, 'code' => '123']);
invCheck(str_contains($html, 'A-01') && str_contains($html, 'Vyberte konkrétní'), 'Ambiguous row selection missing');
$model->ambiguous = false;
[$p, $html] = invPage('show', ['id' => 42, 'code' => '999']);
invCheck(str_contains($html, '00100304') && str_contains($html, 'discrepancyForm'), 'Unknown/other-warehouse handling missing');
$form = $p['discrepancyForm'];
invCheck(hasInvCsrf($form), 'Report lacks CSRF');
$callback = $form->onSuccess[0];
invRedirect(fn() => $callback($form, (object) ['note' => 'Prověřit']));
invCheck(end($model->calls) === ['report', 42, '999', 'Prověřit', '1'], 'Wrong discrepancy scope');
[, $html] = invPage('show', ['id' => 42, 'code' => '777']);
invCheck(str_contains($html, 'nebylo nalezeno ani'), 'Unregistered pallet not distinguished');
$user->login(new Nette\Security\SimpleIdentity(2, ['vyroba']));
$before = count($model->calls);
$p = $factory->createPresenter('Inventory');
$p->autoCanonicalize = false;
$response = $p->run(new Nette\Application\Request('Inventory', 'GET', ['action' => 'default']));
invCheck($response instanceof Nette\Application\Responses\RedirectResponse && count($model->calls) === $before, 'Non-warehouse user reached inventory');
ob_end_clean();
echo "PASS: inventory pages, scan routing, quantity form, correction, ambiguity, unknown pallets, role and CSRF\n";
