<?php

namespace App\Presenters;

use App\Models\DeliveryNoteModel,
    App\Forms\SetDeliveryNoteFormFactory,
    App\Forms\ReadBarCodeFormFactory,
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

    public function startup() {
        parent::startup();

        if (!$this->user->isInRole("sklad") && !$this->user->isInRole("expedice")) {
            $this->redirect("Homepage:");
        }
    }

    public function renderDefault() {
        if (isset($this->getSession('deliveryNote')->deliveryNoteId)) {
            $this->deliveryNoteId = $this->getSession('deliveryNote')->deliveryNoteId;

            $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
            if (!$deliveryNote) {
                $this->getSession('deliveryNote')->remove();
                $this->flashMessage('Vybraný dodací list neexistuje.', 'danger');
                $this->redirect('DeliveryNote:default');
            }
            $deliveryNoteItems = $this->dataModel->getDeliveryNoteItems($this->deliveryNoteId);

            $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
            $this->template->deliveryNote = $deliveryNote;
            $this->template->deliveryNoteItems = $deliveryNoteItems;
            $this->template->nadpis = 'Dodací list: ' . $deliveryNote->ParovaciZnak;

            if ($this["readBarCodeForm"]) {
                $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
                $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
            }

        }
        // když není deliveryNoteId zobrazit formulář pro výběr

    }

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

    /**
     * 
     * @param type $deliveryNoteId
     * @param type $serialNumber
     */
    private function processBarCode($deliveryNoteId, $serialNumber) {
        // kontrola existence VČ + kontrola existence v DL
        $barCodePref = substr($serialNumber, 0, 2);
        if ($barCodePref != '00' || !preg_match('/^00[0-9]+$/D', $serialNumber)) {
            $this->flashMessage('Není číslo palety!', 'error');
            $this->redirect('DeliveryNote:default');

        }

        $serialNumber = substr($serialNumber, 2, strlen($serialNumber) - 2);

        // nejdřív zkontrolovat, jestli se nejedná o skladovou položku
            $serialNumberRow = $this->dataModel->checkSerialNumber($deliveryNoteId, $serialNumber);

            // kontroly na množství na skladě
            if (!$serialNumberRow || !$serialNumberRow->IDVyrCis) {
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
                    $this->warehouseAction(fn() => $this->dataModel->updateDeliveryNoteItemFromStock($deliveryNoteId, $serialNumberRow->IDPohyb, $serialNumberRow->IDVyrCis, $serialNumber, $serialNumberRow->MnozstviPoPrijmuAVydeji));
                }
            }

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

        $form->onSuccess[] = function (Form $form, $values) {
            if ((string) $values->deliveryNoteId !== (string) $this->getSession('deliveryNote')->deliveryNoteId) {
                $this->flashMessage('Výběr dokladu se změnil. Obnovte stránku a načtěte paletu znovu.', 'danger');
                $this->redirect('this');
            }
// kontrola existence VČ + kontrola existence v DL
            $this->processBarCode($this->getSession('deliveryNote')->deliveryNoteId, $values->BarCode);
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

        $res = $this->warehouseAction(fn() => $this->dataModel->closeDeliveryNote($this->getSession('deliveryNote')->deliveryNoteId));
        if (!$res) {
            $this->flashMessage('Dodací list se nepodařilo uzavřít!', 'danger');
        } else {

            $this->getSession('deliveryNote')->remove();
            $this->redirect('Material:default');
        }
    }

    /**
     * smazání přípravy celé vybrané položky na dodacím listu
     * @param type $itemId
     */
    public function handleRemoveDeliveryNoteItem($itemId) {
        $this->warehouseAction(fn() => $this->dataModel->removeDeliveryNoteItem($itemId, $this->getSession('deliveryNote')->deliveryNoteId));

        $this->redirect('DeliveryNote:default');
    }

    /**
     * zobrazení detailu položky dodacího listu (rozpis výrobních čísel)
     * @param type $itemId
     */
    public function renderItemDetail($itemId) {
        $this->deliveryNoteId = $this->getSession('deliveryNote')->deliveryNoteId;
        $deliveryNote = $this->dataModel->getDeliveryNote($this->deliveryNoteId);
            if (!$deliveryNote) {
                $this->getSession('deliveryNote')->remove();
                $this->flashMessage('Vybraný dodací list neexistuje.', 'danger');
                $this->redirect('DeliveryNote:default');
            }

        if (!$this->warehouseAction(function () use ($itemId) { $this->dataModel->assertDocument($this->getSession('deliveryNote')->deliveryNoteId, $itemId, null, false); return true; })) { $this->redirect('default'); }
        $deliveryNoteItem = $this->dataModel->getDeliveryNoteItem($itemId);
        $deliveryNoteItemSN = $this->dataModel->getDeliveryNoteItemSN($itemId);

        $this->template->deliveryNoteNr = $deliveryNote->ParovaciZnak;
        $this->template->deliveryNote = $deliveryNote;
        $this->template->deliveryNoteItemId = $itemId;
        $this->template->deliveryNoteItem = $deliveryNoteItem;
        $this->template->deliveryNoteItemSNs = $deliveryNoteItemSN;

        if ($this["readBarCodeForm"]) {
            $readBarCodeDefaults = array('deliveryNoteId' => $this->deliveryNoteId);
            $this["readBarCodeForm"]->setDefaults($readBarCodeDefaults);
        }

    }

    /**
     * smazání přípravy vybraného výrobního čísla
     * @param type $itemId
     * @param type $itemSNId
     */
    public function handleRemoveDeliveryNoteItemSN($itemId, $itemSNId) {
        $this->warehouseAction(fn() => $this->dataModel->removeDeliveryNoteItemSN($itemSNId, $this->getSession('deliveryNote')->deliveryNoteId, $itemId));

        $this->redirect('DeliveryNote:itemDetail', $itemId);
    }

}
