<?php

namespace App\Presenters;

use Nette;
use Nette\Application\UI\Form;
use App\forms\SignFormFactory;
use App\models\UserModel;

final class SignPresenter extends BasePresenter
{
    /** @var UserModel @inject */
    public $dataModel;

    /** @var SignFormFactory @inject */
    public $signFormFactory;

    public function renderIn()
    {
        if ($this->user->isLoggedIn()) {
            if ($this->user->isInRole('V')) {
                $this->redirect('AdminAttReports:default');
            } else {
                $this->redirect('Homepage:default');
            }
        }
    }

    public function renderReset()
    {

    }
    
    protected function createComponentSignInForm() : Form
    {
        $form = $this->signFormFactory->create();

        /*$form->onError[] = function ($form) {
            $values = $form->getValues();
            $this->blockedUsers = $this->blockingModel->getBlockedUser($values->username);

            if (!$this->blockedUsers) {
                $this->blockingModel->insertBlockedUser($values->username);
            } else if ($this->blockedUsers['lockedTo'] == NULL) {
                $this->blockingModel->increaseBlockedUser($this->blockedUsers);
            } else if ($this->blockedUsers['lockedTo'] != NULL) {
                $this->blockingModel->increaseBlockedUserTstamp($this->blockedUsers);
            }
        };*/

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