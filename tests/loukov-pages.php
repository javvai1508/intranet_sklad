<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();

final class ReceiptPageModel extends App\Models\TransferReceiptModel
{
    public int $documentId = 42;
    public bool $closed = false;
    public bool $confirmed = false;
    public array $calls = [];
    public function __construct() {}
    public function getPendingDocuments(string $target = ''): array {
        $this->calls[] = ['list', $target];
        $rows = [
            Nette\Database\Row::from(['ID' => 42, 'ParovaciZnak' => '384-TEST', 'DatPorizeni' => '2026-10-20', 'Direction' => 'Do Loukova', 'SourceWarehouse' => '00100304', 'TargetWarehouse' => '00100308']),
            Nette\Database\Row::from(['ID' => 43, 'ParovaciZnak' => '381-TEST', 'DatPorizeni' => '2026-10-20', 'Direction' => 'Z Loukova', 'SourceWarehouse' => '00100308', 'TargetWarehouse' => '00100304']),
        ];
        return array_values(array_filter($rows, fn($r) => $target === '' || $r->TargetWarehouse === $target));
    }
    public function getDocument($id, bool $lock = false) {
        return (int) $id === $this->documentId ? Nette\Database\Row::from([
            'ID' => $this->documentId, 'ParovaciZnak' => $this->documentId === 42 ? '384-TEST' : '381-TEST',
            'SourceWarehouse' => $this->documentId === 42 ? '00100304' : '00100308',
            'TargetWarehouse' => $this->documentId === 42 ? '00100308' : '00100304',
            'Direction' => $this->documentId === 42 ? 'Do Loukova' : 'Z Loukova',
            'Ready' => 1, 'CompletedAt' => $this->closed ? '2026-10-20 18:40:00' : null]) : null;
    }
    public function findDocument(string $number) {
        $this->calls[] = ['find', $number];
        return $number === ($this->documentId === 42 ? '384-TEST' : '381-TEST') ? $this->getDocument($this->documentId) : null;
    }
    public function getPallets($id, bool $lock = false): array {
        return [Nette\Database\Row::from(['ID' => 7, 'SerialNumber' => '123', 'ProductName' => 'Test výrobek',
            'MJ' => 'kg', 'Quantity' => '1.250000', 'ReceivedQuantity' => $this->confirmed ? '1.250000' : null,
            'ScannedAt' => $this->confirmed ? '2026-10-20 18:39:00' : null, 'Confirmed' => (int) $this->confirmed])];
    }
    public function confirmPallet($id, string $number): bool {
        $this->calls[] = ['scan', $id, $number];
        if ($this->closed || $this->confirmed || $number !== '123') throw new RuntimeException('Rejected scan');
        $this->confirmed = true;
        return true;
    }
    public function finish($id): bool {
        $this->calls[] = ['finish', $id];
        if ($this->closed || !$this->confirmed) throw new RuntimeException('Rejected completion');
        $this->closed = true;
        return true;
    }
}
function receiptCheck(bool $ok, string $message): void {
    if (!$ok) throw new RuntimeException($message);
}
$container = createTestContainer();
$name = $container->findByType(App\Models\TransferReceiptModel::class)[0];
$container->removeService($name);
$model = new ReceiptPageModel;
$container->addService($name, $model);
$user = $container->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(1, ['sklad'], ['authVersion' => 2, 'fullname' => 'Test', 'vychozi' => 2]));
$session = $container->getByType(Nette\Http\Session::class)->getSection('loukovReceipt');
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
function receiptPage(string $action, array $params = []): array {
    global $factory;
    $p = $factory->createPresenter('TransferReceipt');
    $p->autoCanonicalize = false;
    $response = $p->run(new Nette\Application\Request('TransferReceipt', 'GET', ['action' => $action] + $params));
    receiptCheck($response instanceof Nette\Application\Responses\TextResponse, 'Expected receipt HTML');
    return [$p, $response->getSource()->renderToString()];
}
function receiptRedirect(callable $action): void {
    try { $action(); } catch (Nette\Application\AbortException $e) { return; }
    throw new RuntimeException('Expected receipt redirect');
}
[$p, $html] = receiptPage('default');
receiptCheck(str_contains($html, '384-TEST') && str_contains($html, 'selectReceipt') && str_contains($html, 'selectDocumentForm'), 'Missing receipt selection');
receiptRedirect(fn() => $p->handleSelectReceipt(42));
receiptCheck($session->documentId === 42, 'Selection not saved');
[$p, $html] = receiptPage('showReceipt');
receiptCheck(str_contains($html, 'Test výrobek') && str_contains($html, 'readBarCodeForm') && !str_contains($html, 'finishReceipt'), 'Incomplete receipt UI');
$form = $p['readBarCodeForm'];
$callback = $form->onSuccess[0];
$before = count($model->calls);
receiptRedirect(fn() => $callback($form, (object) ['dispatchId' => 99, 'BarCode' => '00123']));
receiptCheck(count($model->calls) === $before, 'Stale tab confirmed a pallet');
receiptRedirect(fn() => $callback($form, (object) ['dispatchId' => 42, 'BarCode' => 'bad']));
receiptCheck(count($model->calls) === $before, 'Invalid barcode reached model');
receiptRedirect(fn() => $callback($form, (object) ['dispatchId' => 42, 'BarCode' => '00123']));
receiptCheck(end($model->calls) === ['scan', 42, '123'] && $model->confirmed, 'Barcode not normalized or persisted');
[$p, $html] = receiptPage('showReceipt');
receiptCheck(str_contains($html, 'finishReceipt') && str_contains($html, '20.10.2026 18:39:00'), 'Confirmed receipt cannot close');
$before = count($model->calls);
receiptRedirect(fn() => $p->handleFinishReceipt(99));
receiptCheck(count($model->calls) === $before && !$model->closed, 'Stale close reached model');
receiptRedirect(fn() => $p->handleFinishReceipt(42));
receiptCheck($model->closed, 'Receipt did not close');
[, $html] = receiptPage('showReceipt');
receiptCheck(str_contains($html, 'Kontrola uzavřena') && !str_contains($html, 'readBarCodeForm') && !str_contains($html, 'finishReceipt'), 'Closed receipt not read-only');

// Number selection is independent from the outgoing-transfer session.
[$p] = receiptPage('default');
$form = $p['selectDocumentForm'];
$callback = $form->onSuccess[0];
receiptRedirect(fn() => $callback($form, (object) ['number' => ' 384-TEST ']));
receiptCheck(end($model->calls) === ['find', '384-TEST'] && $session->documentId === 42, 'Number selection failed');

// A single list and destination filter cover both directions.
[, $html] = receiptPage('default');
receiptCheck(str_contains($html, '384-TEST') && str_contains($html, '381-TEST'), 'Both directions missing from list');
[, $html] = receiptPage('default', ['target' => '00100304']);
receiptCheck(str_contains($html, '381-TEST') && !str_contains($html, '384-TEST'), 'Return destination filter failed');
[, $html] = receiptPage('default', ['target' => '00100308']);
receiptCheck(str_contains($html, '384-TEST') && !str_contains($html, '381-TEST'), 'Loukov destination filter failed');
$model->documentId = 43;
$model->closed = false;
$model->confirmed = false;
[$p] = receiptPage('default');
receiptRedirect(fn() => $p->handleSelectReceipt(43));
[$p, $html] = receiptPage('showReceipt');
receiptCheck(str_contains($html, 'Z Loukova') && str_contains($html, '00100304'), 'Return receipt direction missing');
$form = $p['readBarCodeForm'];
$callback = $form->onSuccess[0];
receiptRedirect(fn() => $callback($form, (object) ['dispatchId' => 43, 'BarCode' => '00123']));
receiptCheck(end($model->calls) === ['scan', 43, '123'], 'Return scan routed to another document');
receiptRedirect(fn() => $p->handleFinishReceipt(43));
receiptCheck($model->closed, 'Return receipt did not close');

// Bookmarked Loukov-only URLs continue to the shared screen.
$legacy = $factory->createPresenter('LoukovReceipt');
$legacy->autoCanonicalize = false;
$response = $legacy->run(new Nette\Application\Request('LoukovReceipt', 'GET', ['action' => 'showReceipt']));
receiptCheck($response instanceof Nette\Application\Responses\RedirectResponse, 'Legacy receipt URL broken');

$user->login(new Nette\Security\SimpleIdentity(2, ['vyroba']));
$before = count($model->calls);
$p = $factory->createPresenter('TransferReceipt');
$p->autoCanonicalize = false;
$response = $p->run(new Nette\Application\Request('TransferReceipt', 'GET', ['action' => 'default']));
receiptCheck($response instanceof Nette\Application\Responses\RedirectResponse && count($model->calls) === $before, 'Non-warehouse user can access receipt');
ob_end_clean();
echo "PASS: receipt selection, barcode routing, stale tabs, completion, read-only state and role\n";
