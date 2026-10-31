<?php

namespace App\Presenters;

use App\Models\MaterialModel,
    App\Forms\ReadBarCodeFormFactory,
    Nette\Application\UI\Form;

class MaterialPresenter extends BasePresenter
{

    /** @var DispatchId */
    private $dispatchId;

    public function __construct(
        \Nette\Database\Explorer $database,
        private readonly MaterialModel $dataModel,
        private readonly ReadBarCodeFormFactory $readBarCodeFactory,
    ) {
        parent::__construct($database);
    }

    public function startup()
    {
        parent::startup();

        if (!$this->hasAccess('skladMenu') || (!$this->hasAccess('sklad')
            && ($this->getAction() !== 'default' || $this->getSignal() !== null))) {
            $this->error('Pro tuto část aplikace nemáte oprávnění.', 403);
        }
    }

    public function renderDefault()
    {

        $this->template->nadpis = 'Sklad';
    }

    public function handleNewTransferToSchenker(): void
    {
        $this->startTransfer('toSchenker');
    }

    public function handleNewTransferToLoukov(): void
    {
        $this->startTransfer('toLoukov');
    }

    public function handleNewTransferFromLoukov(): void
    {
        $this->startTransfer('fromLoukov');
    }

    private function startTransfer(string $type): void
    {
        $dispatches = $this->warehouseAction(fn() => $this->dataModel->checkDispatchOpen($type));
        if ($dispatches === false) {
            $this->redirect('Material:default');
        }
        if (count($dispatches) > 1) {
            $this->flashMessage('Otevřeno více výdejek, nelze pokračovat!', 'danger');
            $this->redirect('Material:default');
        }
        if (count($dispatches) === 1) {
            $this->audit->setAction(\App\Audit\Action::TRANSFER_RESUME);
            $id = reset($dispatches)->ID;
            $document = in_array($type, ['toLoukov', 'fromLoukov'], true) ? $this->dataModel->getDispatch($id) : null;
            $this->flashMessage($document && (int) $document->StavDispExp === 1
                ? 'Výdejka čeká na dokončení kontroly příjmu v cílovém skladu.'
                : 'Otevřená výdejka - nutno uzavřít!');
        } else {
            $result = $this->warehouseAction(fn() => $this->dataModel->openNewDispatch($type));
            if (!$result || empty($result['IDDoklad'])) {
                $this->flashMessage('Výdejku se nepodařilo založit.', 'danger');
                $this->redirect('Material:default');
            }
            $id = $result['IDDoklad'];
        }
        $this->audit->enrich(['IDDoklad' => $id]);
        $this->audit->complete();
        $session = $this->getSession('dispatch');
        $session->dispatchId = $id;
        $session->dispatchType = $type;
        $this->redirect('Material:showDispatch');
    }

    private function setTransferTemplate(?string $type): void
    {
        $this->template->isOutgoingTransfer = MaterialModel::isOutgoingTransfer($type);
        $this->template->transferTitle = MaterialModel::isOutgoingTransfer($type)
            ? MaterialModel::getTransferSettings($type)['title'] : '';
    }

    /** !!!
     * převod do prodejny
     */
    public function renderNewTransferToShop()
    { 
        // načíst paletu a udělat převodu do prodejny
        $this->template->nadpis = "Převod do prodejny";
    }

    /** !!!
     * ReadBarCode form factory.
     * načtení výrobního čísla materiálu pro převod do prodejny
     * přečte čárový kód
     * 
     * @return Nette\Application\UI\Form
     */
    protected function createComponentReadBarCodeToShopForm()
    {
        $form = $this->readBarCodeFactory->create();
        $form->onSuccess[] = function (Form $form, $values) {
            $barCodePref = substr($values->BarCode, 0, 2);
            if ($barCodePref != '00' || !preg_match('/^00[0-9]+$/D', $values->BarCode)) {
                $this->flashMessage('Není číslo palety!', 'error');
                $this->redirect('Material:newTransferToShop');

            }
            $serialNumber = substr($values->BarCode, 2, strlen($values->BarCode) - 2);
            $idSklad = "00100304"; // vždy sklad mlýn garáže

            $serialNumberRow = $this->dataModel->checkSerialNumberToShop($serialNumber, $idSklad);
            // kontroly na množství na skladě
            if (!$serialNumberRow) {
                // VČ neexistuje - výpis chyby
                $this->flashMessage('Paleta ' . $values->BarCode . ' není v evidenci!', 'error');
            } else {
                if ($serialNumberRow->Mnozstvi <= 0 || $serialNumberRow->MnozstviPoPrijmuAVydeji <= 0) {
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není na skladu!', 'error');
                } else {
                    $res = $this->warehouseAction(fn() => $this->dataModel->moveSerialNumberToShop($serialNumber));
                    if ($res) {
                        $this->flashMessage('Paleta ' . $serialNumber . ' byla převedena do prodejny!', 'info');
                    } else {
                        $this->flashMessage('Paletu ' . $serialNumber . ' se nepodařilo převést!', 'error');
                    }
                }
            }

            $this->redirect('Material:newTransferToShop');
        };

        return $form;
    }

    /** !!!
     * zobrazení výdejky
     */
    public function renderShowDispatch()
    {
        if (!$this->getSession('dispatch')->dispatchId) { $this->redirect('Material:default'); }
        if (isset($this->getSession('dispatch')->dispatchId)) {
            $this->dispatchId = $this->getSession('dispatch')->dispatchId;
            $dispatchType = $this->getSession('dispatch')->dispatchType;
            $dispatch = $this->dataModel->getDispatch($this->dispatchId);
            if (!$dispatch) {
                $this->getSession('dispatch')->remove();
                $this->flashMessage('Vybraný doklad neexistuje.', 'danger');
                $this->redirect('Material:default');
            }
            $dispatchItems = $this->dataModel->getDispatchItems($this->dispatchId);
            // spočítat množství požadované v hlavičce podle součtu z řádků 

            $this->template->dispatchNr = $dispatch->ParovaciZnak;
            $this->template->dispatchType = $dispatchType;
        $this->setTransferTemplate($dispatchType);
            $this->template->dispatch = $dispatch;
            $this->template->dispatchItems = $dispatchItems;

            if ($this["readBarCodeForm"]) {
                $readBarCodeDefaults = array('dispatchId' => $this->dispatchId);
                $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
            }

            $this->template->nadpis = 'Převodka: ' . $dispatch->ParovaciZnak;

        }

    }

    /** !!!
     * ReadBarCode form factory.
     * načtení výrobního čísla materiálu
     * přečte čárový kód
     * 
     * @return Nette\Application\UI\Form
     */
    protected function createComponentReadBarCodeForm()
    {
        $form = $this->readBarCodeFactory->create();
        $form->onSuccess[] = function (Form $form, $values) {
            if ((string) $values->dispatchId !== (string) $this->getSession('dispatch')->dispatchId) {
                $this->flashMessage('Výběr dokladu se změnil. Obnovte stránku a načtěte paletu znovu.', 'danger');
                $this->redirect('this');
            }
            $dispatchType = $this->getSession('dispatch')->dispatchType;

            $barCodePref = substr($values->BarCode, 0, 2);
            if ($barCodePref != '00' || !preg_match('/^00[0-9]+$/D', $values->BarCode)) {
                $this->flashMessage('Není číslo palety!', 'error');
                $this->redirect('Material:showDispatch');

            }
            $serialNumber = substr($values->BarCode, 2, strlen($values->BarCode) - 2);

            if (MaterialModel::isOutgoingTransfer($dispatchType)) {

                $serialNumberRow = $this->dataModel->checkSerialNumberOther($this->getSession('dispatch')->dispatchId, $serialNumber);
                // kontroly na množství na skladě
                if (!$serialNumberRow) {
                    // VČ neexistuje - výpis chyby
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není v evidenci!', 'error');
                } else {
                    if ($serialNumberRow->Mnozstvi <= 0 || $serialNumberRow->MnozstviPoPrijmuAVydeji <= 0) {
                        $this->flashMessage('Paleta ' . $values->BarCode . ' není na skladu!', 'error');
                    } else {
                        $res = $this->warehouseAction(fn() => $this->dataModel->updateDispatchItemOther($serialNumber, $this->getSession('dispatch')->dispatchId));
                    }
                }
            } else {
                // převodky ze Schenkeru a dodací listy - kontrola na dokladu TabVyrCP_EXT._exp_mnoz_potvrz
                $serialNumberRow = $this->dataModel->checkSerialNumberPrepare($this->getSession('dispatch')->dispatchId, $serialNumber);
                // kontroly na množství na skladě
                if (!$serialNumberRow) {
                    // VČ není na dokladu - výpis chyby
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není na dokladu!', 'error');
                } elseif ($serialNumberRow->MnozstviPotvrz > 0) {
                    $this->flashMessage('Paleta ' . $values->BarCode . ' je už potvrzená!', 'error');
                } else {
                    $res = $this->warehouseAction(fn() => $this->dataModel->updateDispatchItemPrepare($serialNumber, $this->getSession('dispatch')->dispatchId));
                }
            }

            $this->redirect('Material:showDispatch');
        };

        return $form;
    }

    /**
     * zobrazení detailu položky výdejky
     * @param type $itemId
     */
    public function renderDispatchItemDetail($itemId)
    {
        $this->dispatchId = $this->getSession('dispatch')->dispatchId;
        $dispatch = $this->dataModel->getDispatch($this->dispatchId);
            if (!$dispatch) {
                $this->getSession('dispatch')->remove();
                $this->flashMessage('Vybraný doklad neexistuje.', 'danger');
                $this->redirect('Material:default');
            }
        if (!$this->warehouseAction(function () use ($itemId) { $this->dataModel->assertDocument($this->getSession('dispatch')->dispatchId, $itemId, null, false); return true; })) { $this->redirect('default'); }
        $dispatchItem = $this->dataModel->getDispatchItem($itemId);
        $dispatchType = $this->getSession('dispatch')->dispatchType;

        if (!$dispatchItem) {
            $this->redirect('Material:showDispatch');
        }
        $dispatchItemSNs = $this->dataModel->getDispatchItemSN($itemId);

        // kontrola, kdy to můžu udělat 
        $this->template->dispatchNr = $dispatch->ParovaciZnak;
        $this->template->dispatch = $dispatch;
        $this->template->dispatchItem = $dispatchItem;
        $this->template->dispatchItemSNs = $dispatchItemSNs;
        $this->template->dispatchType = $dispatchType;
        $this->setTransferTemplate($dispatchType);

        $this->template->nadpis = 'Převodka: ' . $dispatch->ParovaciZnak;
        
        if ($this["readBarCodeForm"]) {
            $readBarCodeDefaults = array('dispatchId' => $this->dispatchId);
            $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
        }

    }

    public function handleRemoveDispatchItemSN($itemId, $itemSNId)
    {
        $dispatchType = $this->getSession('dispatch')->dispatchType;
        if (MaterialModel::isOutgoingTransfer($dispatchType)) {
            $this->warehouseAction(fn() => $this->dataModel->removeDispatchItemSN($itemSNId, $this->getSession('dispatch')->dispatchId, $itemId));
        } else {
            $this->warehouseAction(fn() => $this->dataModel->removeDispatchItemSNPrepare($itemSNId, $this->getSession('dispatch')->dispatchId, $itemId));
        }

        $this->redirect('Material:dispatchItemDetail', $itemId);
    }

    /** !!!
     * uzavření výdejky
     */
    public function handleCloseDispatch()
    {
        $this->dispatchId = $this->getSession('dispatch')->dispatchId;
        $dispatchType = $this->getSession('dispatch')->dispatchType;
        if (MaterialModel::isOutgoingTransfer($dispatchType)) {
            $res = $this->warehouseAction(fn() => $this->dataModel->closeDispatch($this->dispatchId));
        } else {
            $res = $this->warehouseAction(fn() => $this->dataModel->closeDispatchPrepare($this->dispatchId));
        }
        
        if (!$res) {
            $this->flashMessage('Výdejku se nepodařilo uzavřít!', 'danger');
        } else {
            // generovat PDF štítky podle počtu kusů - pouze u příkazů s VČ
            $dispatch = $this->dataModel->getDispatch($this->dispatchId);
            if (!$dispatch) {
                $this->getSession('dispatch')->remove();
                $this->flashMessage('Vybraný doklad neexistuje.', 'danger');
                $this->redirect('Material:default');
            }

            $this->getSession('dispatch')->remove();
            $this->redirect('Material:default');
        }
    }

    public function handleRemoveDispatchItem($itemId)
    {
        $id = $this->getSession('dispatch')->dispatchId;
        $this->warehouseAction(fn() => MaterialModel::isOutgoingTransfer($this->getSession('dispatch')->dispatchType)
            ? $this->dataModel->removeDispatchItem($itemId, $id)
            : $this->dataModel->removeDispatchItemPrepare($itemId, $id));
        $this->redirect('Material:showDispatch');
    }
}
