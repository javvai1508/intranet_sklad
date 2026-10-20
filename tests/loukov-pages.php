<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();

final class ReceiptPageModel extends App\Models\LoukovReceiptModel
{
    public bool $closed = false;
    public bool $confirmed = false;
    public array $calls = [];
    public function __construct() {}
    public function getPendingDocuments(): array {
        $this->calls[] = ['list'];
        return [Nette\Database\Row::from(['ID' => 42, 'ParovaciZnak' => '384-TEST', 'DatPorizeni' => '2026-10-20'])];
    }
    public function getDocument($id, bool $lock = false) {
        return (int) $id === 42 ? Nette\Database\Row::from(['ID' => 42, 'ParovaciZnak' => '384-TEST',
            'Ready' => 1, 'CompletedAt' => $this->closed ? '2026-10-20 18:40:00' : null]) : null;
    }
    public function findDocument(string $number) {
        $this->calls[] = ['find', $number];
        return $number === '384-TEST' ? $this->getDocument(42) : null;
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
$name = $container->findByType(App\Models\LoukovReceiptModel::class)[0];
$container->removeService($name);
$model = new ReceiptPageModel;
$container->addService($name, $model);
$user = $container->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(1, ['sklad'], ['fullname' => 'Test', 'vychozi' => 2]));
$session = $container->getByType(Nette\Http\Session::class)->getSection('loukovReceipt');
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
function receiptPage(string $action): array {
    global $factory;
    $p = $factory->createPresenter('LoukovReceipt');
    $p->autoCanonicalize = false;
    $response = $p->run(new Nette\Application\Request('LoukovReceipt', 'GET', ['action' => $action]));
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

$user->login(new Nette\Security\SimpleIdentity(2, ['vyroba']));
$before = count($model->calls);
$p = $factory->createPresenter('LoukovReceipt');
$p->autoCanonicalize = false;
$response = $p->run(new Nette\Application\Request('LoukovReceipt', 'GET', ['action' => 'default']));
receiptCheck($response instanceof Nette\Application\Responses\RedirectResponse && count($model->calls) === $before, 'Non-warehouse user can access receipt');
ob_end_clean();
echo "PASS: receipt selection, barcode routing, stale tabs, completion, read-only state and role\n";
