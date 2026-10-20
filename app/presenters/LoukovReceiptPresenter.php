<?php

namespace App\Presenters;

/** Compatibility redirects for bookmarked URLs of the former Loukov-only screen. */
class LoukovReceiptPresenter extends BasePresenter
{
    public function actionDefault(): void
    {
        $this->redirect('TransferReceipt:default');
    }

    public function actionShowReceipt(): void
    {
        $this->redirect('TransferReceipt:showReceipt');
    }
}
