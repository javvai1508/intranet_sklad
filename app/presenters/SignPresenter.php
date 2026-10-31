<?php

namespace App\Presenters;

use Nette;
use Nette\Application\UI\Form;
use App\Forms\SignFormFactory;

final class SignPresenter extends BasePresenter
{

    public function __construct(
        \Nette\Database\Explorer $database,
        private readonly SignFormFactory $signFormFactory,
    ) {
        parent::__construct($database);
    }

    public function renderIn()
    {
        if ($this->user->isLoggedIn()) {
            $this->redirect('Homepage:default');
        }
    }

    protected function createComponentSignInForm() : Form
    {
        $form = $this->signFormFactory->create();

        return $form;
    }

    public function actionOut()
    {
        $this->audit->complete();
        $this->getUser()->logout(true);
        $session = $this->getSession();
        $session->destroy();
        $this->redirect('in');
    }

}
