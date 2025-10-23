<?php

namespace App\Forms;

use Nette,
    Nette\Application\UI\Form;
    
/**
 * formulář pro vyhledávání DL
 */
class ReadBarCodeFormFactory {

    /**
     * @return Form
     */
    public function create() {

        $form = new Form;
        
        $form->addHidden('deliveryNoteId');
        $form->addHidden('dispatchId');
        $form->addHidden('receiptId');
        $form->addHidden('itemId');
        $form->addText('BarCode')
                ->setAttribute('placeholder', 'Čárový kód')
                ->setAttribute('class', 'form-control form-control-sm')
                ->setType('text')
                ->setRequired('Zadej kód výrobku')
                ->setAttribute('autocomplete', false);

        /*
        $form->addCheckbox('AddOne', 'Po jednom kusu?')
                ->setAttribute('class', 'form-control form-control-lg checkbox-large');
         * 
         */
        
        return $form;
    }

}
