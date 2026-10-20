<?php
require __DIR__ . '/bootstrap.php';
ob_start();
ini_set('session.save_path', sys_get_temp_dir());
Tracy\Debugger::$logDirectory = sys_get_temp_dir();

// Only document data is stubbed. Requests, DI, session, form creation, links and Latte are real.
final class PageDeliveryNoteModel extends App\Models\DeliveryNoteModel
{
    public bool $closed = false;
    public bool $empty = false;
    public function __construct() {}
    public function getDeliveryNote($id) {
        return Nette\Database\Row::from(['ID' => 1, 'ParovaciZnak' => 'DL-TEST', 'Odberatel' => 'Test odběratel',
            'DatDodavky' => '2026-10-16', 'DatUzavrenoExp' => '16.10.2026', 'StavDLExp' => (int) $this->closed,
            'MnozstviVC' => 10, 'MnozstviPozad' => 20]);
    }
    public function getDeliveryNoteItems($id) {
        return [Nette\Database\Row::from(['ID' => 5, 'RegCis' => 'TEST-001', 'Nazev' => 'Test výrobek',
            'Mnozstvi' => 20, 'MnozstviVC' => 10, 'PocetVC' => $this->empty ? 0 : 1])];
    }
    public function getDeliveryNoteItem($id) { return $this->getDeliveryNoteItems(1)[0]; }
    public function getDeliveryNoteItemSN($id) {
        return $this->empty ? [] : [Nette\Database\Row::from(['IDVyrCP' => 7, 'Nazev' => 'PAL-TEST',
            'MnozstviPoPrijmuAVydeji' => 10, 'MnozstviCP' => 10])];
    }
    public function assertDocument($documentId, $itemId = null, $serialId = null, bool $open = true): void {
        if ((int) $documentId !== 1 || ($itemId !== null && (int) $itemId !== 5)) {
            throw new RuntimeException('Foreign fixture item');
        }
    }
}
function checkPage(bool $condition, string $message): void {
    if (!$condition) { throw new RuntimeException($message); }
}
$container = createTestContainer();
$name = $container->findByType(App\Models\DeliveryNoteModel::class)[0];
$container->removeService($name);
$model = new PageDeliveryNoteModel;
$container->addService($name, $model);
$container->getByType(Nette\Security\User::class)->login(new Nette\Security\SimpleIdentity(1, ['sklad'], ['fullname' => 'Test', 'vychozi' => 2]));
$container->getByType(Nette\Http\Session::class)->getSection('deliveryNote')->deliveryNoteId = 1;
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
function page(string $action, array $params = []): string {
    global $factory;
    $presenter = $factory->createPresenter('DeliveryNote');
    $presenter->autoCanonicalize = false;
    $response = $presenter->run(new Nette\Application\Request('DeliveryNote', 'GET', ['action' => $action] + $params));
    checkPage($response instanceof Nette\Application\Responses\TextResponse, 'Expected an HTML response');
    return $response->getSource()->renderToString();
}
// A manually constructed signal must not permit removing a whole delivery-note item.
$presenter = $factory->createPresenter('DeliveryNote');
try {
    $presenter->signalReceived('removeDeliveryNoteItem');
    throw new RuntimeException('Whole delivery-note item removal must not be available');
} catch (Nette\Application\UI\BadSignalException $e) {
    // Removed signal is rejected by Nette before any database write.
}
$html = page('default');
checkPage(str_contains($html, 'TEST-001') && (bool) preg_match('~<tr[^>]*class="clickable-row"[^>]*data-href="[^"]+"~', $html), 'Overview needs a clickable row leading to pallet detail');
$html = page('itemDetail', ['itemId' => 5]);
checkPage(str_contains($html, 'PAL-TEST') && str_contains($html, 'Test výrobek'), 'Detail must render without UmisteniKod');
checkPage(str_contains($html, 'removeDeliveryNoteItemSN') && str_contains($html, 'Opravdu chcete odebrat tuto paletu'), 'Missing pallet removal');
checkPage(substr_count($html, 'id="menuButton"') === 1, 'Duplicate navigation menus');
checkPage(str_contains($html, 'data-bs-toggle="dropdown"') && !str_contains($html, 'data-toggle="dropdown"'), 'Wrong Bootstrap dropdown attribute');
$model->closed = true;
$html = page('itemDetail', ['itemId' => 5]);
checkPage(str_contains($html, 'PAL-TEST') && !str_contains($html, 'removeDeliveryNoteItemSN'), 'Closed document must be read-only');
$model->closed = false;
$model->empty = true;
$html = page('itemDetail', ['itemId' => 5]);
checkPage(str_contains($html, 'Na položce nejsou žádné palety.'), 'Missing empty state');
ob_end_clean();
echo "PASS: real Nette overview and detail rendering, open/closed document, empty pallets, Bootstrap navigation\n";
