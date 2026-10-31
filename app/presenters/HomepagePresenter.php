<?php

namespace App\Presenters;

class HomepagePresenter extends BasePresenter
{
    public function renderDefault()
    {
        $this->template->nadpis = 'Intranet';
    }
}
