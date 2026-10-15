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
        $form->addProtection('Platnost formuláře vypršela. Obnovte stránku.');
        
        $form->addHidden('deliveryNoteId');
        $form->addHidden('dispatchId');
        $form->addHidden('receiptId');
        $form->addHidden('itemId');
        $form->addText('BarCode')
                ->setHtmlAttribute('placeholder', 'Čárový kód')
                ->setHtmlAttribute('class', 'form-control form-control-sm')
                ->setHtmlType('text')
                ->setRequired('Zadej kód výrobku')
                ->setHtmlAttribute('inputmode', 'none')
                ->setHtmlAttribute('autofocus', true)
                ->setHtmlAttribute('autocomplete', false);

        /*
        $form->addCheckbox('AddOne', 'Po jednom kusu?')
                ->setAttribute('class', 'form-control form-control-lg checkbox-large');
         * 
         */
        
        return $form;
    }

}
