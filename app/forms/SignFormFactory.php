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
        $form->addText('username', 'Jméno')
                ->setRequired('Zadejte jméno')
                ->setHtmlAttribute('class', 'form-control')
                ->setHtmlAttribute('placeholder', 'Jméno');
/*        $form->addPassword('password', 'Heslo')
                ->setRequired('Zadejte heslo')
                ->setHtmlAttribute('class', 'form-control')
                ->setHtmlAttribute('placeholder', 'Heslo');

        $form->addCheckbox('remember', 'Zapamatuj si mě');*/
        
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
            $this->user->login($values->username, '');
        } catch (Nette\Security\AuthenticationException $e) {
            $form->addError($e->getMessage());
        }
    }

}
