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
        $this->template->nadpis = 'Odvádění z výroby';
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
                    $idPrijem = $this->dataModel->closeProduction($sn->IDVyrCis, $this->user->getIdentity()->getData()['cislozam']);
                    // $this->flashMessage($idPrijem);
                }

            } else {
                $this->flashMessage('Chybné číslo palety!');
            }
            $this->redirect('Production:');
            \Tracy\Debugger::barDump($values);
        };

        return $form;
    }

}
