<?php

namespace App\Presenters;

use App\Models\DeliveryNoteModel,
    App\Forms\SetDeliveryNoteFormFactory,
    App\Forms\ReadBarCodeFormFactory,
    App\Forms\SetQuantityFormFactory,
    App\Forms\SetFinalOperationQuantityFormFactory,
    Nette\Application\UI\Form;

class DeliveryNotePresenter extends BasePresenter {

    /** @var DeliveryNoteModel @inject */
    public $dataModel;

    /** @var SetDeliveryNoteFormFactory @inject */
    public $setDeliveryNoteFactory;

    /** @var ReadBarCodeFormFactory @inject */
    public $readBarCodeFactory;

    /** @var DeliveryNoteId */
    private $deliveryNoteId;

    public function __construct() {
        parent::__construct();
    }

    public function startup() {
        parent::startup();

        if (!$this->user->isInRole("sklad")) {
            $this->redirect("Homepage:");
        }
    }

    public function renderDefault() {
        if (isset($this->getSession('deliveryNote')->deliveryNoteId)) {
            $this->deliveryNoteId = $this->getSession('deliveryNote')->deliveryNoteId;

            $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
            $deliveryNoteItems = $this->dataModel->getDeliveryNoteItems($this->deliveryNoteId);

            $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
            $this->template->deliveryNote = $deliveryNote;
            $this->template->deliveryNoteItems = $deliveryNoteItems;

            if ($this["readBarCodeForm"]) {
                $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
                $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
            }
            \Tracy\Debugger::barDump($this->template->deliveryNote);
        }
        // když není deliveryNoteId zobrazit formulář pro výběr

// \Tracy\Debugger::barDump($this->showSession());
    }

    /* ------------- vyhledat DL -------------------------------------- */

    /**
     * SetDeliveryNote form factory.
     * vyhledávní DL 
     * 
     * @return Nette\Application\UI\Form
     */
    protected function createComponentSetDeliveryNoteForm() {
        $form = $this->setDeliveryNoteFactory->create();
        $form->onSuccess[] = function (Form $form, $values) {

            $deliveryNoteId = $this->dataModel->checkDeliveryNote($values->ParovaciZnak);
            if (!$deliveryNoteId) {
                $this->flashMessage('Vybraný dodací list není v evidenci!', 'error');

                $this->redirect('DeliveryNote:default');
            } else {

                $deliveryNoteIdSess = $this->getSession('deliveryNote');
                $deliveryNoteIdSess->deliveryNoteId = $deliveryNoteId;

                $this->redirect('DeliveryNote:default');
            }
        };

        return $form;
    }

    /* ------------- čtení čárového kódu -------------------------------------- */

    /**
     * 
     * @param type $deliveryNoteId
     * @param type $serialNumber
     */
    private function processBarCode($deliveryNoteId, $serialNumber) {
        // kontrola existence VČ + kontrola existence v DL
        $barCodePref = substr($serialNumber, 0, 2);
        if ($barCodePref != '00') {
            $this->flashMessage('Není číslo palety!', 'error');
            $this->redirect('DeliveryNote:default');

        }

        $serialNumber = substr($serialNumber, 2, strlen($serialNumber) - 2);

        // nejdřív zkontrolovat, jestli se nejedná o skladovou položku
            $itemId = null;
            $serialNumberRow = $this->dataModel->checkSerialNumber($deliveryNoteId, $serialNumber);

            // kontroly na množství na skladě
            if (!($serialNumberRow["IDVyrCis"])) {
                // VČ neexistuje - výpis chyby
                $this->flashMessage('Paleta ' . $serialNumber . ' není v evidenci!', 'danger');
            } else {
                if (!isset($serialNumberRow->IDPohyb)) {
                    // VČ nepatří na aktuálním dodák
                    $this->flashMessage('Paleta ' . $serialNumber . ' nepatří na aktuální DL!', 'danger');
                } elseif ($serialNumberRow->IDVCP) {
                    $this->flashMessage('Paleta ' . $serialNumber . ' už je na dokladu!', 'danger');
                } elseif ($serialNumberRow->MnozstviPozadavek < $serialNumberRow->MnozstviPoPrijmuAVydeji + $serialNumberRow->MnozstviPriprava) {
                    $this->flashMessage('Paleta ' . $serialNumber . ' překročené množství na dokladu!', 'danger');
                } elseif ($serialNumberRow->Mnozstvi <= 0 || $serialNumberRow->MnozstviPoPrijmuAVydeji <= 0) {
                    $this->flashMessage('Paleta ' . $serialNumber . ' není na skladu!', 'danger');
                } else {
                    $this->dataModel->updateDeliveryNoteItemFromStock($deliveryNoteId, $serialNumberRow->IDPohyb, $serialNumberRow->IDVyrCis, $serialNumber, $serialNumberRow->MnozstviPoPrijmuAVydeji);
                }
            }

        \Tracy\Debugger::barDump($serialNumberRow);
        // \Tracy\Debugger::barDump($res);
        // $this->flashMessage($values->BarCode);
        $this->redirect('DeliveryNote:default');

    }

    /**
     * ReadBarCode form factory.
     * načtení výrobního čísla čárovým kódem a zpracování
     * přečte čárový kód
     * 
     * @return Nette\Application\UI\Form
     */
    protected function createComponentReadBarCodeForm() {
        $form = $this->readBarCodeFactory->create();
        /*
          $form->onValidate[] = function (Form $form) {
          $values = $form->values;

          };
         * 
         */
        $form->onSuccess[] = function (Form $form, $values) {
// kontrola existence VČ + kontrola existence v DL
            $this->processBarCode($values->deliveryNoteId, $values->BarCode);
        };

        return $form;
    }

    /**
     * nový výběr dodacího listu
     */
    public function handleChangeDeliveryNote() {
        $this->getSession('deliveryNote')->remove();
        $this->redirect('DeliveryNote:default');
    }

    /**
     * uzavření dodacího listu
     */
    public function handleCloseDeliveryNote() {
        $deliveryNote = $this->dataModel->getDeliveryNote($this->getSession('deliveryNote')->deliveryNoteId);
/*
        if ($deliveryNote->SkupinaTisk == 'nh') {
            $res = $this->dataModel->checkDeliveryNoteBeforeClosing($this->getSession('deliveryNote')->deliveryNoteId);
            // $this->flashMessage($res);
            // odeslání zprávy o nedodaném zboží
            if ($res > 0) {
                // generovat PDF
                $this->createDeliveryNoteErrorPDF($this->getSession('deliveryNote')->deliveryNoteId);
                // generovat soubor s mailem, kam to poslat
                $deliveryNote = $this->dataModel->getDeliveryNote($this->getSession('deliveryNote')->deliveryNoteId);
                $responsibleMail = $this->dataModel->getResponsibleMail($this->getSession('deliveryNote')->deliveryNoteId);
                $f = fopen("e:\\fs\\data_helios\\TBLT_EXPED_NH\\" . "dl" . $deliveryNote->ParovaciZnak . ".pdf.to", "w");
                fwrite($f, $responsibleMail);
                fclose($f);
            }
        }
        // \Tracy\Debugger::barDump($deliveryNote);
        // $this->redirect('DeliveryNote:default');
*/
        $res = $this->dataModel->closeDeliveryNote($this->getSession('deliveryNote')->deliveryNoteId);
        if (!$res) {
            $this->flashMessage('Dodací list se nepodařilo uzavřít!', 'danger');
        } else {
// vytvořit soubor v adresáři pro tisk DL
/*
            $f = fopen("c:\\inetpub\\wwwroot\\www\\batch_" . $deliveryNote->SkupinaTisk . "\\" . $this->getSession('deliveryNote')->deliveryNoteId . ".txt", "w");
            fwrite($f, $this->getSession('deliveryNote')->deliveryNoteId);
*/
            $this->getSession('deliveryNote')->remove();
            $this->getSession('package')->remove();
            $this->redirect('Material:default');
        }
    }

    /**
     * smazání přípravy celé vybrané položky na dodacím listu
     * @param type $itemId
     */
    public function handleRemoveDeliveryNoteItem($itemId) {
        $this->dataModel->removeDeliveryNoteItem($itemId);

        $this->redirect('DeliveryNote:default');
    }

    /**
     * zobrazení detailu položky dodacího listu (rozpis výrobních čísel)
     * @param type $itemId
     */
    public function renderItemDetail($itemId) {
        $this->deliveryNoteId = $this->getSession('deliveryNote')->deliveryNoteId;
        $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
// kontrola, kdy to můžu udělat (co musí být v DL vyplněné)

        $deliveryNoteItem = $this->dataModel->getDeliveryNoteItem($itemId);
        $deliveryNoteItemSN = $this->dataModel->getDeliveryNoteItemSN($itemId);
        $this->packageNr = $this->getSession('package')->number;
        $this->packageOpen = $this->getSession('package')->open;

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
        $this->template->deliveryNoteItemId = $itemId;
        $this->template->deliveryNoteItem = $deliveryNoteItem;
        $this->template->deliveryNoteItemSNs = $deliveryNoteItemSN;
        $this->template->packageOpen = $this->packageOpen;

        if ($this["readBarCodeForm"]) {
            $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
            $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
        }

        \Tracy\Debugger::barDump($deliveryNoteItem);
    }

    /**
     * smazání přípravy vybraného výrobního čísla
     * @param type $itemId
     * @param type $itemSNId
     */
    public function handleRemoveDeliveryNoteItemSN($itemId, $itemSNId) {
        $this->dataModel->removeDeliveryNoteItemSN($itemSNId);

        $this->redirect('DeliveryNote:itemDetail', $itemId);
    }

    /**
     * zobrazení detailu položky dodacího listu (rozpis výrobních čísel)
     * @param type $deliveryNoteId
     */
    public function renderPackages() {
        $this->deliveryNoteId = $this->getSession('deliveryNote')->deliveryNoteId;
        $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
// kontrola, kdy to můžu udělat (co musí být v DL vyplněné)
// $deliveryNoteItem = $this->dataModel->getDeliveryNoteItem($itemId);
        $deliveryNotePackages = $this->dataModel->getDeliveryNotePackages($this->deliveryNoteId);
        $this->packageNr = $this->getSession('package')->number;
        $this->packageOpen = $this->getSession('package')->open;

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
// $this->template->deliveryNoteItemId = $itemId;
// $this->template->deliveryNoteItem = $deliveryNoteItem;
        $this->template->packages = $deliveryNotePackages;
        $this->template->packageOpen = $this->packageOpen;

        if ($this["readBarCodeForm"]) {
            $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
            $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
        }

        \Tracy\Debugger::barDump($deliveryNotePackages);
    }

}
