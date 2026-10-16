<?php

declare(strict_types=1);

namespace App\Presenters;

use Nette;
use App\Helpers\RequireLoggedUser;

class BasePresenter extends Nette\Application\UI\Presenter {
    use RequireLoggedUser; // bez přihlášení

    public function __construct(protected readonly Nette\Database\Explorer $database)
    {
        parent::__construct();
    }

    public function startup() {
        Parent::startup();
        
        $this->template->dbInfo = $this->getDbInfo();

    }

    private function getDbInfo(): ?\Nette\Database\Row
    {
        try {
            return $this->database->query("
                SELECT
                    @@SERVERNAME AS serverName,
                    DB_NAME() AS databaseName,
                    SUSER_SNAME() AS loginName
            ")->fetch();
        } catch (\Nette\Database\DriverException $e) {
            \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            return null;
        }
    }

    protected function warehouseAction(callable $operation)
    {
        try {
            return $operation();
        } catch (\Nette\Database\DriverException $e) {
            \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            $this->flashMessage('Operace selhala. Ověřte stav dokladu před dalším pokusem.', 'danger');
        } catch (\RuntimeException $e) {
            $this->flashMessage($e->getMessage(), 'danger');
        }
        return false;
    }

    protected function beforeRender(): void
    {
        parent::beforeRender();
        $section = $this->getSession('requestProtection');
        if (!isset($section->token)) { $section->token = bin2hex(random_bytes(32)); }
        $this->template->requestToken = $section->token;
    }

    public function checkRequirements(\ReflectionClass|\ReflectionMethod $element): void
    {
        parent::checkRequirements($element);
        if ($element instanceof \ReflectionMethod && str_starts_with($element->getName(), 'handle')) {
            $token = $this->getHttpRequest()->getPost('_requestToken');
            $expected = $this->getSession('requestProtection')->token;
            if (!$this->getHttpRequest()->isMethod('POST') || !is_string($expected)
                || !is_string($token) || !hash_equals($expected, $token)) {
                $this->error('Neplatný požadavek. Obnovte stránku.', 403);
            }
        }
    }
}
