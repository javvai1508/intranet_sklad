<?php
namespace App\Helpers;

trait RequireLoggedUser
{
    public function injectRequireLoggedUser(): void
    {
        $this->onStartup[] = function() {
            if (!$this->user->isLoggedIn() && $this->getPresenter()->name != 'Sign') {
                if ($this->getSession()->exists()) {
                    $this->getSession()->destroy();
                }
                $this->redirect('Sign:in');
            }
        };

    }
}