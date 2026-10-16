<?php

namespace App\Presenters;

use App\Models\ProductionModel,
    App\Forms\ReadBarCodeFormFactory,
    Nette\Application\UI\Form;

class ProductionPresenter extends BasePresenter
{

    public function __construct(
        \Nette\Database\Explorer $database,
        private readonly ProductionModel $dataModel,
        private readonly ReadBarCodeFormFactory $readBarCodeFactory,
    )
    {
        parent::__construct($database);
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
            if ($barCodePref != '00' || !preg_match('/^00[0-9]+$/D', $values->BarCode)) {
                $this->flashMessage('Není číslo palety!');
                $this->redirect('Production:');

            }
            $barCode = substr($values->BarCode, 2, strlen($values->BarCode) - 2);

            $sn = $this->dataModel->checkProductionSN($barCode);

            if ($sn) {
                if ($sn->Odvedeno + $sn->OdvedenoNereal >= $sn->Zadane) {
                    $this->flashMessage('Už bylo jednou odvedeno!');
                } else {
                    $idPrijem = $this->warehouseAction(fn() => $this->dataModel->closeProduction($sn->IDVyrCis, $this->user->getIdentity()->getData()['cislozam']));
                    if ($idPrijem) { $this->flashMessage('Paleta byla odvedena na sklad.', 'success'); }
                }

            } else {
                $this->flashMessage('Chybné číslo palety!');
            }
            $this->redirect('Production:');

        };

        return $form;
    }

}
