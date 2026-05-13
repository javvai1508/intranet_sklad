<?php

declare(strict_types=1);

namespace App\Presenters;

use Nette;
use App\Helpers\RequireLoggedUser;

class BasePresenter extends Nette\Application\UI\Presenter {
    use RequireLoggedUser; // bez přihlášení

    /** @var Nette\Database\Explorer @inject */
    public Nette\Database\Explorer $database;

    public function startup() {
        Parent::startup();
        
        $this->template->dbInfo = $this->getDbInfo();

    }

    private function getDbInfo(): ?\stdClass
    {
        try {
            return $this->database->query("
                SELECT
                    @@SERVERNAME AS serverName,
                    DB_NAME() AS databaseName,
                    SUSER_SNAME() AS loginName
            ")->fetch();
        } catch (\Throwable $e) {
            return null;
        }
    }

}
