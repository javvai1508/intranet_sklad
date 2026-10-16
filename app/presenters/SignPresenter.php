<?php

namespace App\Presenters;

use Nette;
use Nette\Application\UI\Form;
use App\forms\SignFormFactory;

final class SignPresenter extends BasePresenter
{

    /** @var SignFormFactory @inject */
    public $signFormFactory;

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
        $this->getUser()->logout(true);
        $session = $this->getSession();
        $session->destroy();
        $this->redirect('in');
    }

}
