<?php

declare(strict_types=1);

namespace App\Presenters;

use Nette;
use App\Helpers\RequireLoggedUser;

class BasePresenter extends Nette\Application\UI\Presenter {
    use RequireLoggedUser; // bez přihlášení

    public function startup() {
        Parent::startup();
        
    }

}
