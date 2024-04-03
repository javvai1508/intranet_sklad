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

    /** @var SetQuantityFormFactory @inject */
    public $setQuantityFactory;

    /** @var SetFinalOperationQuantityFormFactory @inject */
    public $setFinalOperationQuantityFactory;

    /** @var DeliveryNoteId */
    private $deliveryNoteId;

    /** @var PackageNr */
    private $packageNr;

    /** @var packageOpen */
    private $packageOpen;

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
        if (isset($this->getSession('dispatch')->dispatchId)) {
            $this->deliveryNoteId = $this->getSession('dispatch')->dispatchId;

            $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
            $deliveryNoteItems = $this->dataModel->getDeliveryNoteItems($this->deliveryNoteId);

            $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
            $this->template->deliveryNote = $deliveryNote;
            $this->template->deliveryNoteItems = $deliveryNoteItems;
            $this->template->packageOpen = $this->packageOpen;

            if ($this["readBarCodeForm"]) {
                $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
                $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
            }
            \Tracy\Debugger::barDump($this->template->deliveryNote);
        }

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

                $dispatchIdSess = $this->getSession('dispatch');
                $dispatchIdSess->deliveryNoteId = $dispatchIdSess->dispatchId;

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
     * evidence odváděcí operace
     * @param type $serialNumber
     */
    public function actionFinalizeOperation($deliveryNoteId, $serialNumber) {
        $res = $this->dataModel->finalizeOperation($this->user->getIdentity()->getData()['username'], $serialNumber);
        if ($res <> "") {
            $this->flashMessage($res, 'error');
        } else {
// znovu pustit zpracování výrobního čísla
            $this->processBarCode($deliveryNoteId, $serialNumber);
        }
    }

    /**
     * úprava množství výrobního čísla při odvádění operace se šarží
     * @param int $deliveryNoteId
     * @param string $serialNumber
     */
    public function renderSetFinalOperationQuantity($deliveryNoteId, $serialNumber, $availableQty) {
        $deliveryNote = $this->dataModel->getDeliveryNote($deliveryNoteId);
// kontrola, kdy to můžu udělat (co musí být v DL vyplněné)

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
        $this->packageNr = $this->getSession('package')->number;
        $this->packageOpen = $this->getSession('package')->open;

        $serialNumberRow = $this->dataModel->checkSerialNumber($deliveryNoteId, $serialNumber);
        $this->template->deliveryNoteId = $deliveryNoteId;
        $this->template->serialNumberRow = $serialNumberRow;
        $this->template->packageOpen = $this->packageOpen;
        $this->template->serialNumber = $serialNumber;

        \Tracy\Debugger::barDump($serialNumberRow);

        $setQuantityDefaults = array('deliveryNoteId' => $deliveryNote->ID, 'serialNumber' => $serialNumber, 'quantity' => $availableQty);
        $this["setFinalOperationQuantityForm"]->setDefaults($setQuantityDefaults);
    }

    /**
     * formulář pro úpravu množství při odvádění operace se šarží
     * @return type
     */
    public function createComponentSetFinalOperationQuantityForm() {
        $form = $this->setFinalOperationQuantityFactory->create();

// $form->onValidate[] = array($this, "validateEditQuantityForm");

        $form->onSuccess[] = function (Form $form, $values) {

            if ($form['send']->isSubmittedBy()) {
                $this->actionFinalizeOperation($values->deliveryNoteId, $values->serialNumber);
            }


            $this->redirect('DeliveryNote:default');
        };

        return $form;
    }

    /**
     * úprava množství výrobního čísla při zadání čárovým kódem
     * @param type $serialNumberRow
     */
    public function renderSetQuantity($deliveryNoteId, $serialNumber) {
        $deliveryNote = $this->dataModel->getDeliveryNote($deliveryNoteId);
// kontrola, kdy to můžu udělat (co musí být v DL vyplněné)

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
        $this->packageNr = $this->getSession('package')->number;
        $this->packageOpen = $this->getSession('package')->open;

        $serialNumberRow = $this->dataModel->checkSerialNumber($deliveryNoteId, $serialNumber);
        $this->template->deliveryNoteId = $deliveryNoteId;
        $this->template->serialNumberRow = $serialNumberRow;
        $this->template->packageOpen = $this->packageOpen;

        \Tracy\Debugger::barDump($serialNumberRow);

        $setQuantityDefaults = array('deliveryNoteId' => $deliveryNote->ID, 'idPohyb' => $serialNumberRow->IDPohyb, 'idVyrCis' => $serialNumberRow->IDVyrCis, 'quantity' => ($serialNumberRow->MnozstviPoPrijmuAVydeji > ($serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava)) ? $serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava : $serialNumberRow->MnozstviPoPrijmuAVydeji);
        $this["setQuantityForm"]->setDefaults($setQuantityDefaults);
    }

    /**
     * formulář pro úpravu množství při zadání čárovým kódem
     * @return type
     */
    public function createComponentSetQuantityForm() {
        $form = $this->setQuantityFactory->create();

// $form->onValidate[] = array($this, "validateEditQuantityForm");

        $form->onSuccess[] = function (Form $form, $values) {

            $packageSess = $this->getSession('package');
            $packageOpen = $packageSess->open;
            $packageNr = $packageSess->number;

            $packageNr = $this->dataModel->updateDeliveryNoteItem($values->deliveryNoteId, $values->idPohyb, $values->idVyrCis, $values->quantity, $packageOpen, $packageNr);
            $packageSess->number = $packageNr;

            $this->redirect('DeliveryNote:itemDetail', $values->idPohyb);
        };

        return $form;
    }

    /**
     * úprava množství výrobního čísla při zadání skladové položky (serviety)
     * @param type $serialNumberRow
     */
    public function renderSetQuantityFromStock($deliveryNoteId, $serialNumber) {
        $deliveryNote = $this->dataModel->getDeliveryNote($deliveryNoteId);
// kontrola, kdy to můžu udělat (co musí být v DL vyplněné)

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
        $this->packageNr = $this->getSession('package')->number;
        $this->packageOpen = $this->getSession('package')->open;

        $serialNumberRow = $this->dataModel->checkSerialNumber($deliveryNoteId, $serialNumber);
        $this->template->deliveryNoteId = $deliveryNoteId;
        $this->template->serialNumberRow = $serialNumberRow;
        $this->template->packageOpen = $this->packageOpen;

        \Tracy\Debugger::barDump($serialNumberRow);

        $setQuantityDefaults = array('deliveryNoteId' => $deliveryNote->ID, 'idPohyb' => $serialNumberRow->IDPohyb, 'idVyrCis' => $serialNumberRow->IDVyrCis, 'quantity' => ($serialNumberRow->MnozstviPoPrijmuAVydeji > ($serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava)) ? $serialNumberRow->MnozstviPozadavek - $serialNumberRow->MnozstviPriprava : $serialNumberRow->MnozstviPoPrijmuAVydeji);
        $this["setQuantityForm"]->setDefaults($setQuantityDefaults);
    }

    /**
     * formulář pro úpravu množství při zadání skladové položky
     * @return type
     */
    public function createComponentSetQuantityFromStockForm() {
        $form = $this->setQuantityFactory->create();

// $form->onValidate[] = array($this, "validateEditQuantityForm");

        $form->onSuccess[] = function (Form $form, $values) {

            $packageSess = $this->getSession('package');
            $packageOpen = $packageSess->open;
            $packageNr = $packageSess->number;

            $res = $this->dataModel->processDeliveryNoteFromStock($values->deliveryNoteId, $values->IDPohyb, $values->quantity, $packageOpen, $packageNr);
            if ($res["res"] > 0) {
                $this->flashMessage('Položka je již splněná, případně není co vydávat!', 'error');
            } else {
                $packageSess->number = $res["packageNr"];
                if ($res["mnozstviPriprava"] <> 0) {
                    $this->flashMessage('Všechny požadované kusy nejsou k dipozici, zbylo ještě ' . $res["mnozstviPriprava"], 'info');
                }
                
            }
            
            $this->redirect('DeliveryNote:itemDetail', $values->idPohyb);
        };

        return $form;
    }

    /**
     * nový výběr dodacího listu
     */
    public function handleChangeDeliveryNote() {
        $this->getSession('dispatch')->remove();
        $this->redirect('Material:default');
    }

    /**
     * generování PDF s rozdíly v DL - neodeslané zboží
     */
    public function createDeliveryNoteErrorPDF($deliveryNoteId) {
        $template = $this->createTemplate();
        $template->setFile(__DIR__ . "/templates/DeliveryNote/deliveryNoteErrorPDF.latte");
        $deliveryNote = $this->dataModel->getDeliveryNote($deliveryNoteId);
        $deliveryNoteItems = $this->dataModel->getDeliveryNoteDiffItems($deliveryNoteId);
        $template->deliveryNote = $deliveryNote;
        $template->deliveryNoteItems = $deliveryNoteItems;
        
        $pdf = new \Joseki\Application\Responses\PdfResponse($template);

        $pdf->pageFormat = "A4";
        $pdf->setPageMargins("10, 10, 10, 10, 1, 1");
        $pdf->styles = file_get_contents("c:\\inetpub\\wwwroot\\www\\css\\pdf-style.css");
        $pdf->getMPDF()->setFooter("Ligum Intranet");

        /* server */
        $pdf->save("e:\\fs\\data_helios\\TBLT_EXPED_NH\\",  "dl" . $deliveryNote->ParovaciZnak);        
        // \Tracy\Debugger::barDump($printCmd);

    }

    /**
     * uzavření dodacího listu
     */
    public function handleCloseDeliveryNote() {
        $deliveryNote = $this->dataModel->getDeliveryNote($this->getSession('dispatch')->dispatchId);
/*
        if ($deliveryNote->SkupinaTisk == 'nh') {
            $res = $this->dataModel->checkDeliveryNoteBeforeClosing($this->getSession('dispatch')->dispatchId);
            // $this->flashMessage($res);
            // odeslání zprávy o nedodaném zboží
            if ($res > 0) {
                // generovat PDF
                $this->createDeliveryNoteErrorPDF($this->getSession('dispatch')->dispatchId);
                // generovat soubor s mailem, kam to poslat
                $deliveryNote = $this->dataModel->getDeliveryNote($this->getSession('dispatch')->dispatchId);
                $responsibleMail = $this->dataModel->getResponsibleMail($this->getSession('dispatch')->dispatchId);
                $f = fopen("e:\\fs\\data_helios\\TBLT_EXPED_NH\\" . "dl" . $deliveryNote->ParovaciZnak . ".pdf.to", "w");
                fwrite($f, $responsibleMail);
                fclose($f);
            }
        }
        // \Tracy\Debugger::barDump($deliveryNote);
        // $this->redirect('DeliveryNote:default');
*/
        $res = $this->dataModel->closeDeliveryNote($this->getSession('dispatch')->dispatchId);
        if (!$res) {
            $this->flashMessage('Dodací list se nepodařilo uzavřít!', 'danger');
        } else {
// vytvořit soubor v adresáři pro tisk DL
/*
            $f = fopen("c:\\inetpub\\wwwroot\\www\\batch_" . $deliveryNote->SkupinaTisk . "\\" . $this->getSession('dispatch')->dispatchId . ".txt", "w");
            fwrite($f, $this->getSession('dispatch')->dispatchId);
*/
            $this->getSession('dispatch')->remove();
            $this->getSession('package')->remove();
            $this->redirect('Material:default');
        }
    }

    /**
     * otevření nového balíku
     */
    public function handleOpenPackage() {
// $deliveryNoteId = $this->getSession('deliveryNoteId')->deliveryNoteId;
        $packageSess = $this->getSession('package');
        if ($packageSess->open == true) {
            $packageSess->number = $this->dataModel->getNextPackage($this->getSession('deliveryNoteId')->deliveryNoteId);
        }
        $packageSess->open = true;

        $this->redirect('DeliveryNote:default');
    }

    /**
     * uzavření balíku
     */
    public function handleClosePackage() {
        $packageSess = $this->getSession('package');
        if ($packageSess->open == true) {
            $packageSess->number = $this->dataModel->getNextPackage($this->getSession('deliveryNoteId')->deliveryNoteId);
            $packageSess->open = false;
        }

        \Tracy\Debugger::barDump($packageSess->packageNr);
        $this->redirect('DeliveryNote:default');
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
        $this->deliveryNoteId = $this->getSession('dispatch')->dispatchId;
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
     * úprava množství na výrobním čísle - inline v přehledu
     * @return \Nette\Application\UI\Multiplier
     */
    protected function createComponentEditQuantityForm() {
        return new \Nette\Application\UI\Multiplier(function($id) {
            $form = new Form;
            $form->addHidden('itemSNId', $id);
            $form->addText('quantity')
                    ->setType('number')
                    ->setAttribute('class', 'form-control form-control-lg text-center ajax quantity-form-input');

            $form->onValidate[] = array($this, "validateEditQuantityForm");

            return $form;
        });
    }

    /**
     * validace změny množství na výrobním čísle
     * @param type $form
     * @param type $values
     */
    public function validateEditQuantityForm($form, $values) {
// $values = $form->getHttpData();
        \Tracy\Debugger::barDump($values);

        $res = $this->dataModel->updateQuantitySN($values);

        switch ($res) {
            case 0:
                break;
            case 1:
                $form->addError('Neplatný kód výrobního čísla!');
                $this->flashMessage('Neplatný kód výrobního čísla!');
                break;
            case 2:
                $form->addError('Nedostatek výrobního čísla skladem. Nelze vydat!');
                $this->flashMessage('Nedostatek výrobního čísla skladem. Nelze vydat!');
                break;
            case 3:
                $form->addError('Překročeno požadované množství. Nelze vydat!');
                $this->flashMessage('Překročeno požadované množství. Nelze vydat!');
                break;
            case 9:
                $form->addError('Chyba SQL');
                $this->flashMessage('Chyba SQL');
                break;
            default:
                $form->addError('Chyba?');
                $this->flashMessage('Chyba?');
                break;
        }

        $this->redirect('DeliveryNote:itemDetail', $this->presenter->getParameter("itemId"));
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
        $this->deliveryNoteId = $this->getSession('dispatch')->dispatchId;
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

    /**
     * smazání položky z balíku
     * @param type $packageId
     */
    public function handleRemoveFromPackage($packageId) {
        $this->dataModel->removeFromPackage($packageId);

        $this->redirect('DeliveryNote:packages');
    }

}
