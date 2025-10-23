<?php

namespace App\Forms;

use Nette,
    Nette\Application\UI\Form;
    
/**
 * formulář pro nový materiál zákazníka
 */
class SetStockDocFormFactory {

    /**
     * @return Form
     */
    public function create() {

        $form = new Form;
        
        $form->addText('ParovaciZnak')
                ->setAttribute('placeholder', 'Číslo dokladu')
                ->setAttribute('class', 'form-control form-control-sm')
                ->setRequired('Zadej číslo dokladu')
                ->setAttribute('autocomplete', false);

        $form->addSubmit('send', 'form.labels.select')
                ->setAttribute('class', 'btn btn-sm btn-secondary');

        return $form;
    }

}
