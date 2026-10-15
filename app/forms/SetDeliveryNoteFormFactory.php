<?php

namespace App\Forms;

use Nette,
    Nette\Application\UI\Form;
    
/**
 * formulář pro vyhledávání DL
 */
class SetDeliveryNoteFormFactory {

    /**
     * @return Form
     */
    public function create() {

        $form = new Form;
        $form->addProtection('Platnost formuláře vypršela. Obnovte stránku.');
        
        $form->addText('ParovaciZnak', 'Číslo dodacího listu')
                ->setHtmlAttribute('placeholder', 'Číslo dodacího listu')
                ->setHtmlAttribute('class', 'form-control form-control-lg')
                ->setHtmlType('text')
                ->setRequired('Zadej číslo dodacího listu')
                ->setHtmlAttribute('autocomplete', false);

        $form->addSubmit('send', 'Vyber')
                ->setHtmlAttribute('class', 'btn btn-lg btn-secondary');

        return $form;
    }

}
