<?php

namespace App\Presenters;

use App\Models\MaterialModel,
    App\Forms\SetStockDocFormFactory,
    App\Forms\ReadBarCodeFormFactory,
    Nette\Application\UI\Form,
    Joseki\Application\Responses\PdfResponse;

class MaterialPresenter extends BasePresenter
{

    /** @var MaterialModel @inject */
    public $dataModel;

    /** @var SetStockDocFormFactory @inject */
    public $setStockDocFactory;

    /** @var ReadBarCodeFormFactory @inject */
    public $readBarCodeFactory;

    /** @var DispatchId */
    private $dispatchId;

    public function __construct()
    {
        parent::__construct();
    }

    public function startup()
    {
        parent::startup();

        if (!$this->user->isInRole("sklad")) {
            $this->redirect("Homepage:");
        }
    }

    public function renderDefault()
    {
        // \Tracy\Debugger::barDump($this->showSession());
    }

    /* ------------- změna - vyhledání dokladu - příjemka i výdejka ------------------------------ */

    /**
     * 
     */
    public function actionChangeStockDoc()
    {
        $this->getSession('dispatch')->remove();
        $this->redirect("Material:default");
    }

    /**
     * SetStockDoc form factory.
     * vyhledání skladového dokladu - dodací list nebo převodka ze Schenkeru
     * 
     * @return Nette\Application\UI\Form
     */
    protected function createComponentSetStockDocForm()
    {
        $this->getSession('dispatch')->remove();
        $form = $this->setStockDocFactory->create();
        $form->onSuccess[] = function (Form $form, $values) {

            $doc = $this->dataModel->getStockDocPZ($values->ParovaciZnak);
            if (!$doc) {
                $this->flashMessage('Vybraný doklad není v evidenci!', 'error');

                $this->redirect('Material:default');
            } else {

                // podle typu dokladu pokračovat jako převodka ze Schenkeru nebo dodací list ze mlýna - kontrola!!!
                if ($doc->DispatchType == 'fromSchenker' || $doc->DispatchType == 'receipt') {
                    $dispatchIdSess = $this->getSession('dispatch');
                    $dispatchIdSess->dispatchId = $doc->ID;
                    $dispatchIdSess->dispatchType = $doc->DispatchType;

                    if (isset($dispatchIdSess)) {
                        $this->redirect('Material:showDispatch');
                    }
                } elseif ($doc->DispatchType == 'delivery') {
                    $dispatchIdSess = $this->getSession('dispatch');
                    $dispatchIdSess->dispatchId = $doc->ID;
                    $dispatchIdSess->dispatchType = $doc->DispatchType;
/*                    $deliveryNoteIdSess = $this->getSession('deliveryNoteId');
                    $deliveryNoteIdSess->deliveryNoteId = $doc->ID;
                    $deliveryNoteIdSess->dispatchType = $doc->DispatchType;*/
    
                    $this->redirect('DeliveryNote:default');
/*                    $dispatchIdSess = $this->getSession('dispatch');
                    $dispatchIdSess->dispatchId = $doc->ID;
                    $dispatchIdSess->dispatchType = $doc->DispatchType;

                    if (isset($dispatchIdSess)) {
                        $this->redirect('Material:showDispatch');
                    }*/
                } else {
                    $this->flashMessage("Doklad nelze takto zpracovat!");
                    $this->redirect('Material:default');
                }
            }
        };

        return $form;
    }

    /* ============================= VÝDEJKA =================================== */

    /** !!!
     * nová výdejka - převod do Schenkeru
     */
    public function handleNewTransferToSchenker()
    { 
        // kontrola, jestli tam výdejka už není
        $dispatchsOpen = $this->dataModel->checkDispatchOpen('toSchenker');
        if ($dispatchsOpen) {
            if (count($dispatchsOpen) > 1) {
                \Tracy\Debugger::barDump($dispatchsOpen);
                $this->flashMessage("Otevřeno více výdejek, nelze pokračovat!");
                $this->redirect("Material:default");
            } elseif (count($dispatchsOpen) == 1) {
                $dispatchIdSess = $this->getSession('dispatch');
                foreach ($dispatchsOpen as $dispatchOpen) {
                    $dispatchIdSess->dispatchId = $dispatchOpen->ID;
                }
                $dispatchIdSess->dispatchType = 'toSchenker';
                $this->flashMessage("Otevřená výdejka - nutno uzavřít!");
                $this->redirect("Material:showDispatch");
            }
        }
        $res = $this->dataModel->openNewDispatch('toSchenker');
        if ($res["IDDoklad"]) {
            $dispatchId = $res["IDDoklad"];

            if ($dispatchId) {
                // založit novou výdejku  a doplnit řádky
                $dispatchIdSess = $this->getSession('dispatch');
                $dispatchIdSess->dispatchId = $dispatchId;
                $dispatchIdSess->dispatchType = 'toSchenker';

                $this->redirect("Material:showDispatch");
            } else {
                $this->flashMessage("Chyba při založení výdejky");
                $this->redirect("Material:default");
            }
        }         
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
            if ($barCodePref != '00') {
                $this->flashMessage('Není číslo palety!', 'error');
                $this->redirect('Material:newTransferToShop');

            }
            $serialNumber = substr($values->BarCode, 2, strlen($values->BarCode) - 2);
            $idSklad = "00100304"; // vždy sklad mlýn garáže

            $serialNumberRow = $this->dataModel->checkSerialNumberToShop($serialNumber, $idSklad);
            // kontroly na množství na skladě
            if (!($serialNumberRow["IDVyrCis"])) {
                // VČ neexistuje - výpis chyby
                $this->flashMessage('Paleta ' . $values->BarCode . ' není v evidenci!', 'error');
            } else {
                if ($serialNumberRow->Mnozstvi <= 0 || $serialNumberRow->MnozstviPoPrijmuAVydeji <= 0) {
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není na skladu!', 'error');
                } else {
                    $res = $this->dataModel->moveSerialNumberToShop($serialNumber);
                    if ($res) {
                        $this->flashMessage('Paleta ' . $serialNumber . ' byla převedena do prodejny!', 'info');
                    } else {
                        $this->flashMessage('Paletu ' . $serialNumber . ' se nepodařilo převést!', 'error');
                    }
                }
            }
/*
            //\Tracy\Debugger::barDump($serialNumberRow);
            // $this->flashMessage($values->BarCode);
*/
            $this->redirect('Material:newTransferToShop');
        };

        return $form;
    }

    /** !!!
     * zobrazení výdejky
     */
    public function renderShowDispatch()
    {
        if (isset($this->getSession('dispatch')->dispatchId)) {
            $this->dispatchId = $this->getSession('dispatch')->dispatchId;
            $dispatchType = $this->getSession('dispatch')->dispatchType;
            $dispatch = $this->dataModel->getDispatch($this->dispatchId);
            $dispatchItems = $this->dataModel->getDispatchItems($this->dispatchId);
            // spočítat množství požadované v hlavičce podle součtu z řádků 

            $this->template->dispatchNr = $dispatch->ParovaciZnak;
            $this->template->dispatchType = $dispatchType;
            $this->template->dispatch = $dispatch;
            $this->template->dispatchItems = $dispatchItems;

            if ($this["readBarCodeForm"]) {
                $readBarCodeDefaults = array('dispatchId' => $this->dispatchId);
                $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
            }

            \Tracy\Debugger::barDump($dispatch);
        }
        \Tracy\Debugger::barDump($this->getSession('dispatch')->dispatchId);
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
            $dispatchType = $this->getSession('dispatch')->dispatchType;

            $barCodePref = substr($values->BarCode, 0, 2);
            if ($barCodePref != '00') {
                $this->flashMessage('Není číslo palety!', 'error');
                $this->redirect('Material:showDispatch');

            }
            $serialNumber = substr($values->BarCode, 2, strlen($values->BarCode) - 2);

            if ($dispatchType == 'toSchenker') {

                $serialNumberRow = $this->dataModel->checkSerialNumberOther($values->dispatchId, $serialNumber);
                // kontroly na množství na skladě
                if (!($serialNumberRow["IDVyrCis"])) {
                    // VČ neexistuje - výpis chyby
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není v evidenci!', 'error');
                } else {
                    if ($serialNumberRow->Mnozstvi <= 0 || $serialNumberRow->MnozstviPoPrijmuAVydeji <= 0) {
                        $this->flashMessage('Paleta ' . $values->BarCode . ' není na skladu!', 'error');
                    } else {
                        $res = $this->dataModel->updateDispatchItemOther($serialNumber, $values->dispatchId);
                    }
                }
            } else {
                // převodky ze Schenkeru a dodací listy - kontrola na dokladu TabVyrCP_EXT._exp_mnoz_potvrz
                $serialNumberRow = $this->dataModel->checkSerialNumberPrepare($values->dispatchId, $serialNumber);
                // kontroly na množství na skladě
                if (!($serialNumberRow["IDVyrCis"])) {
                    // VČ není na dokladu - výpis chyby
                    $this->flashMessage('Paleta ' . $values->BarCode . ' není na dokladu!', 'error');
                } elseif ($serialNumberRow->MnozstviPotvrz > 0) {
                    $this->flashMessage('Paleta ' . $values->BarCode . ' je už potvrzená!', 'error');
                } else {
                    $res = $this->dataModel->updateDispatchItemPrepare($serialNumber, $values->dispatchId);
                }
            }

            //\Tracy\Debugger::barDump($serialNumberRow);
            // $this->flashMessage($values->BarCode);

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

        if ($this["readBarCodeForm"]) {
            $readBarCodeDefaults = array('dispatchId' => $this->dispatchId);
            $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
        }

        \Tracy\Debugger::barDump($dispatchItem);
    }

    /**
     * úprava množství výrobního čísla při zadání čárovým kódem
     * @param type $serialNumberRow
     */
    public function renderSetQuantity($dispatchId, $serialNumber)
    {
        $dispatch = $this->dataModel->getDispatch($dispatchId);
        // kontrola, kdy to můžu udělat (co musí být v DL vyplněné)

        $this->template->dispatchNr = $dispatch->ParovaciZnak;
        $this->template->dispatch = $dispatch;

        $serialNumberRow = $this->dataModel->checkSerialNumber($dispatchId, $serialNumber);
        $this->template->dispatchId = $dispatchId;
        $this->template->serialNumberRow = $serialNumberRow;

        \Tracy\Debugger::barDump($serialNumberRow);

        $setQuantityDefaults = array('dispatchId' => $dispatch->ID, 'idZboSklad' => $serialNumberRow->IDZboSklad, 'idVyrCis' => $serialNumberRow["IDVyrCis"], 'quantity' => ($serialNumberRow->MnozstviPoPrijmuAVydeji > ($serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava)) ? $serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava : $serialNumberRow->MnozstviPoPrijmuAVydeji);
        $this["setQuantityForm"]->setDefaults($setQuantityDefaults);
    }

    /**
     * formulář pro úpravu množství při zadání čárovým kódem
     * @return type
     */
    public function createComponentSetQuantityForm()
    {
        $form = $this->setQuantityFactory->create();

        // $form->onValidate[] = array($this, "validateEditQuantityForm");

        $form->onSuccess[] = function (Form $form, $values) {

            $itemId = $this->dataModel->updateDispatchItem($values->dispatchId, $values->idZboSklad, $values->idVyrCis, $values->quantity);

            $this->redirect('Material:showDispatch');
        };

        return $form;
    }

    public function handleRemoveDispatchItem($itemId)
    {
        $this->dataModel->removeDispatchItem($itemId);

        $this->redirect('Material:showDispatch');
    }

    public function handleRemoveDispatchItemSN($itemId, $itemSNId)
    {
        $dispatchType = $this->getSession('dispatch')->dispatchType;
        if ($dispatchType == 'toSchenker') {
            $this->dataModel->removeDispatchItemSN($itemSNId);
        } else {
            $this->dataModel->removeDispatchItemSNPrepare($itemSNId);
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
        if ($dispatchType == 'toSchenker') {
            $res = $this->dataModel->closeDispatch($this->dispatchId);
        } else {
            $res = $this->dataModel->closeDispatchPrepare($this->dispatchId);
        }
        
        if (!$res) {
            $this->flashMessage('Výdejku se nepodařilo uzavřít!', 'danger');
        } else {
            // generovat PDF štítky podle počtu kusů - pouze u příkazů s VČ
            $dispatch = $this->dataModel->getDispatch($this->dispatchId);

            $this->getSession('dispatch')->remove();
            $this->redirect('Material:default');
        }
    }

}
