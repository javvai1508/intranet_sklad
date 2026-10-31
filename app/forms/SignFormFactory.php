<?php

namespace App\Forms;

use Nette,
    Nette\Application\UI\Form,
    Nette\Security\User;

class SignFormFactory
{

    /** @var User */
    private $user;

    public function __construct(User $user) 
    {
        $this->user = $user;
    }

    public function create(): Form
    {
        $form = new Form;
        $form->addProtection('Platnost formuláře vypršela. Obnovte stránku.');
        $form->addPassword('pin', 'PIN')
                ->setRequired('Zadejte PIN')
                ->addRule(Form::Pattern, 'PIN musí obsahovat přesně čtyři číslice.', '[0-9]{4}')
                ->setHtmlAttribute('inputmode', 'numeric')
                ->setHtmlAttribute('maxlength', 4)
                ->setHtmlAttribute('autocomplete', 'off')
                ->setHtmlAttribute('autofocus', true)
                ->setHtmlAttribute('class', 'form-control')
                ->setHtmlAttribute('placeholder', 'PIN');

        $form->addSubmit('send', 'Přihlásit')
                ->setHtmlAttribute('class', 'btn btn-lg btn-primary col-xs-12');

        $form->onSuccess[] = [$this, 'formSucceeded'];
        return $form;
    }
    
    /**
     * @param type $form
     * @param type $values
     */
    public function formSucceeded($form, $values) {
        $this->user->setExpiration('12 hours', TRUE);

        try {
            $this->user->login($values->pin, '');
        } catch (Nette\Security\AuthenticationException $e) {
            $form->addError($e->getMessage());
        }
    }

}
