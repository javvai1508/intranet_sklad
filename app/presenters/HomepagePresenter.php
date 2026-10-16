<?php

namespace App\Presenters;

class HomepagePresenter extends BasePresenter
{
    public function renderDefault()
    {
        // Výchozí modul zaměstnance: 0 = expedice, 1 = výroba, 2 = sklad.
        $default = $this->user->getIdentity()->getData()['vychozi'];
        if ($default === null) {
            return;
        }
        if ($default == 0 && $this->user->isInRole('expedice')) {
            $this->redirect('DeliveryNote:default');
        } elseif ($default == 1 && $this->user->isInRole('vyroba')) {
            $this->redirect('Production:default');
        } elseif ($default == 2 && $this->user->isInRole('sklad')) {
            $this->redirect('Material:default');
        }
    }
}
