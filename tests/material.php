<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();

final class TransferPageModel extends App\Models\MaterialModel
{
    public array $open = [];
    public array $calls = [];
    public bool $closed = false;
    public function __construct() {}
    public function checkDispatchOpen($type) { $this->calls[] = ['lookup', $type]; return $this->open; }
    public function openNewDispatch($type) { $this->calls[] = ['new', $type]; return ['IDDoklad' => 42]; }
    public function getDispatch($id) {
        return Nette\Database\Row::from(['ID' => $id, 'ParovaciZnak' => 'TEST-TRANSFER',
            'PocetPalet' => 1, 'Priprava' => 0, 'StavDispExp' => (int) $this->closed, 'DatUzavrenoExp' => '20.10.2026']);
    }
    public function getDispatchItems($id) {
        return [Nette\Database\Row::from(['DispatchItemID' => 5, 'Nazev' => 'Test výrobek',
            'Mnozstvi' => 10, 'PocetPalet' => 1])];
    }
    public function getDispatchItem($id) { return $this->getDispatchItems(42)[0]; }
    public function getDispatchItemSN($id) {
        return [Nette\Database\Row::from(['IDVyrCP' => 7, 'Nazev' => 'PAL-TEST', 'Mnozstvi' => 10])];
    }
    public function assertDocument($documentId, $itemId = null, $serialId = null, bool $open = true): void {}
    public function checkSerialNumberOther($id, $sn) {
        return (object) ['Mnozstvi' => 10, 'MnozstviPoPrijmuAVydeji' => 10];
    }
    public function updateDispatchItemOther($sn, $id) { $this->calls[] = ['scan', $sn, $id]; return true; }
    public function removeDispatchItemSN($sn, $id, $item) { $this->calls[] = ['removeSN', $sn, $id, $item]; return true; }
    public function removeDispatchItem($item, $id) { $this->calls[] = ['removeItem', $item, $id]; return true; }
    public function closeDispatch($id) { $this->calls[] = ['close', $id]; return true; }
    // Falling into a preparation method is an error; those methods would access the real DB.
}
function transferCheck(bool $ok, string $message): void {
    if (!$ok) throw new RuntimeException($message);
}
$container = createTestContainer();
$name = $container->findByType(App\Models\MaterialModel::class)[0];
$container->removeService($name);
$model = new TransferPageModel;
$container->addService($name, $model);
$container->getByType(Nette\Security\User::class)->login(new Nette\Security\SimpleIdentity(1, ['sklad'], ['fullname' => 'Test', 'vychozi' => 2]));
$session = $container->getByType(Nette\Http\Session::class)->getSection('dispatch');
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
function transferPage(string $action, array $params = []): array {
    global $factory;
    $presenter = $factory->createPresenter('Material');
    $presenter->autoCanonicalize = false;
    $response = $presenter->run(new Nette\Application\Request('Material', 'GET', ['action' => $action] + $params));
    transferCheck($response instanceof Nette\Application\Responses\TextResponse, 'Expected HTML');
    return [$presenter, $response->getSource()->renderToString()];
}
function transferRedirect(callable $action): void {
    try { $action(); } catch (Nette\Application\AbortException $e) { return; }
    throw new RuntimeException('Expected redirect');
}
[, $html] = transferPage('default');
transferCheck(str_contains($html, 'newTransferToLoukov') && str_contains($html, 'Převod do Loukova'), 'Missing Loukov choice');

foreach (['toLoukov' => ['handleNewTransferToLoukov', 'Do Loukova'], 'toSchenker' => ['handleNewTransferToSchenker', 'Do Schenkeru']] as $type => [$handler, $title]) {
    foreach ([0, 1, 2] as $count) {
        $session->remove();
        $model->calls = [];
        $model->open = array_fill(0, $count, (object) ['ID' => 99]);
        [$presenter] = transferPage('default');
        transferRedirect(fn() => $presenter->$handler());
        transferCheck($model->calls[0] === ['lookup', $type], 'Wrong transfer lookup');
        if ($count > 1) {
            transferCheck(!isset($session->dispatchId) && count($model->calls) === 1, 'Ambiguous transfer opened');
        } else {
            transferCheck($session->dispatchType === $type && $session->dispatchId === ($count ? 99 : 42), 'Wrong transfer session');
            transferCheck(count($model->calls) === ($count ? 1 : 2), 'Existing document duplicated');
        }
    }
    $session->dispatchType = $type;
    $session->dispatchId = 42;
    [, $html] = transferPage('showDispatch');
    transferCheck(str_contains($html, $title) && str_contains($html, 'Test výrobek'), 'Wrong transfer overview');
    [$presenter, $html] = transferPage('dispatchItemDetail', ['itemId' => 5]);
    transferCheck(str_contains($html, $title) && str_contains($html, 'PAL-TEST') && str_contains($html, 'removeDispatchItemSN'), 'Wrong transfer detail');
    $form = $presenter['readBarCodeForm'];
    foreach ($form->onSuccess as $callback) {
        transferRedirect(fn() => $callback($form, (object) ['dispatchId' => 42, 'BarCode' => '00123']));
    }
    transferCheck(end($model->calls) === ['scan', '123', 42], 'Scan routed to preparation');
    transferRedirect(fn() => $presenter->handleRemoveDispatchItemSN(5, 7));
    transferCheck(end($model->calls) === ['removeSN', 7, 42, 5], 'Wrong pallet removal');
    transferRedirect(fn() => $presenter->handleRemoveDispatchItem(5));
    transferCheck(end($model->calls) === ['removeItem', 5, 42], 'Wrong item removal');
    $model->closed = true;
    [, $html] = transferPage('dispatchItemDetail', ['itemId' => 5]);
    transferCheck(!str_contains($html, 'removeDispatchItemSN'), 'Closed transfer is writable');
    $model->closed = false;
    transferRedirect(fn() => $presenter->handleCloseDispatch());
    transferCheck(end($model->calls) === ['close', 42] && !isset($session->dispatchId), 'Wrong close or session not cleared');
}
ob_end_clean();
echo "PASS: Loukov and Schenker creation, resume, ambiguity, rendering, scans, removal and close\n";
