<?php

namespace App\Presenters;

use App\Models\ProductionModel,
    App\Forms\ReadBarCodeFormFactory,
    Nette\Application\UI\Form;

class ProductionPresenter extends BasePresenter
{

    /** @var ProductionModel @inject */
    public $dataModel;

    /** @var ReadBarCodeFormFactory @inject */
    public $readBarCodeFactory;

    public function __construct()
    {
        parent::__construct();
    }

    public function startup()
    {
        parent::startup();

        if (!$this->user->isInRole("vyroba")) {
            $this->redirect("Homepage:");
        }
    }

    public function renderDefault()
    {
        // \Tracy\Debugger::barDump($this->showSession());
    }

    /**
     * formulář pro načtení palety - načtení VČ, odvedení na sklad
     * @return type
     */
    protected function createComponentReadBarCodeForm()
    {
        $form = $this->readBarCodeFactory->create();
        $form->onSuccess[] = function (Form $form, $values) { 
            /**
             * kontrola stavu VČ ve výrobních příkazech
             * kontrola na uzavřený příkaz a možná ještě něco dalšího
             * 
             * odvedení procedurou 
             */
            $barCodePref = substr($values->BarCode, 0, 2);
            if ($barCodePref != '00') {
                $this->flashMessage('Není číslo palety!');
                $this->redirect('Production:');

            }
            $barCode = substr($values->BarCode, 2, strlen($values->BarCode) - 2);

            $sn = $this->dataModel->checkProductionSN($barCode);

            if ($sn) {
                if ($sn->Odvedeno + $sn->OdvedenoNereal >= $sn->Zadane) {
                    $this->flashMessage('Už bylo jednou odvedeno!');
                } else {
                    $idPrijem = $this->dataModel->closeProduction($sn->IDVyrCis, $this->user->getIdentity()->username);
                    // $this->flashMessage($idPrijem);
                }

            } else {
                $this->flashMessage('Chybné číslo palety!');
            }
            $this->redirect('Production:');
/*            
            $idZboSklad = $this->dataModel->checkStdInventorySN($values->VyrCislo);

            if (isset($idZboSklad) && $this->getSession('invHd')->invSkupZbo == '151') {
                $res = $this->dataModel->processStdInventorySN($this->getSession('invHd')->invHdId, $values->VyrCislo, $idZboSklad, 1, false);

                if ($res == 1) {
                    $this->flashMessage('Není zadané výrobní číslo!', 'danger');
                } elseif ($res == 2) {
                    $this->flashMessage('Chybně zadaná skladová karta!', 'danger');
                } elseif ($res == 3) {
                    $this->flashMessage('Vybraná inventura je již uzavřená!', 'danger');
                } elseif ($res == 4) {
                    $this->flashMessage('Chybně zadaný sklad!', 'danger');
                } elseif ($res == 5) {
                    $this->flashMessage('Výrobní číslo ' . $values->VyrCislo . ' je už zaevidované!', 'danger');
                } elseif ($res == 99) {
                    $this->flashMessage('Chyba při úpravě položky inventury!', 'danger');
                } else {
                    // $this->flashMessage('Výrobní číslo bylo zaevidováno!', 'info');
                }
    
                $this->redirect('Material:StdInventory');
    
            } else {
                $this->redirect('Material:StdInventoryQty', $values->VyrCislo, $idZboSklad, $values->TisknoutStitek);
            }
*/
            \Tracy\Debugger::barDump($values);
        };

        return $form;
    }

    /**
     * formulář pro inventuru - zpracování dat po načtení VČ - dohledání v kmeni, doplnění množství
     * @return type
     */
 /*   protected function createComponentStdInventoryForm()
    {
        $prumerZao = $this->dataModel->getPrumer1Zao();
        $nazevLaminatu = $this->dataModel->getLaminat();
        $form = $this->stdInventoryFactory->create();
        $form->onSuccess[] = function (Form $form, $values) {
            if ($values->NewSN == 1) {
                // generování VČ
                $sn = $this->dataModel->generateSNSklad($values->IDZboSklad);
                if (isset($sn) && $sn != '') {
                    $values->VyrCislo = $sn;
                }
                \Tracy\Debugger::barDump($sn);
            }

            $res = $this->dataModel->processStdInventorySN($this->getSession('invHd')->invHdId, $values->VyrCislo, $values->IDZboSklad, $values->Mnozstvi, $values->NewSN);

            if ($res == 1) {
                $this->flashMessage('Není zadané výrobní číslo!', 'danger');
            } elseif ($res == 2) {
                $this->flashMessage('Chybně zadaná skladová karta!', 'danger');
            } elseif ($res == 3) {
                $this->flashMessage('Vybraná inventura je již uzavřená!', 'danger');
            } elseif ($res == 4) {
                $this->flashMessage('Chybně zadaný sklad!', 'danger');
            } elseif ($res == 99) {
                $this->flashMessage('Chyba při úpravě položky inventury!', 'danger');
            } else {
                $this->flashMessage('Výrobní číslo bylo zaevidováno!', 'info');
            }

            \Tracy\Debugger::barDump($values);

            $this->redirect('Material:StdInventory');
        };

        return $form;
    }
    */
}
