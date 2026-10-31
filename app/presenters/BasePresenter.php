<?php

declare(strict_types=1);

namespace App\Presenters;

use Nette;
use App\Helpers\RequireLoggedUser;

class BasePresenter extends Nette\Application\UI\Presenter {
    use RequireLoggedUser; // bez přihlášení

    protected \App\Audit\AuditLog $audit;

    protected \App\Helpers\HeliosErrorMessages $heliosErrors;

    public function injectHeliosErrorMessages(\App\Helpers\HeliosErrorMessages $messages): void
    {
        $this->heliosErrors = $messages;
    }

    public function injectAuditLog(\App\Audit\AuditLog $audit): void
    {
        $this->audit = $audit;
    }

    protected \App\Helpers\DeviceIdentity $deviceIdentity;

    public function injectDeviceIdentity(\App\Helpers\DeviceIdentity $deviceIdentity): void
    {
        $this->deviceIdentity = $deviceIdentity;
    }

    public function __construct(protected readonly Nette\Database\Explorer $database)
    {
        parent::__construct();
    }

    public function run(Nette\Application\Request $request): Nette\Application\Response
    {
        try {
            return parent::run($request);
        } catch (\Throwable $e) {
            $this->audit->failure($e instanceof Nette\Database\DriverException
                ? 'Databázová chyba při zpracování požadavku.' : 'Neočekávaná chyba při zpracování požadavku.', 3);
            throw $e;
        }
    }

    public function startup() {
        \App\Audit\RequestAudit::start($this, $this->audit);
        Parent::startup();
        
        $this->template->dbInfo = $this->getDbInfo();

    }

    public function hasAccess(string $role): bool
    {
        return $this->user->isLoggedIn() && ($this->user->isInRole('admin')
            || $this->user->isInRole($role)
            || ($role === 'skladMenu' && ($this->user->isInRole('sklad') || $this->user->isInRole('inventura'))));
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
            $translated = $this->heliosErrors->translate($e);
            if ($translated !== null) {
                \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
                $this->audit->enrich([], ['cisloHlaskyHelios' => $translated->messageNumber]);
                $this->audit->failure($translated->getMessage());
                $this->flashMessage($translated->getMessage(), 'warning');
                return false;
            }
            $this->audit->failure('Databázová chyba při zpracování operace.', 3);
            \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            $this->flashMessage('Operace selhala. Ověřte stav dokladu před dalším pokusem.', 'danger');
        } catch (\RuntimeException $e) {
            $this->audit->failure($e->getMessage());
            $this->flashMessage($e->getMessage(), 'danger');
        }
        return false;
    }

    public function flashMessage(string|\stdClass|\Stringable $message, string $type = 'info'): \stdClass
    {
        if (in_array($type, ['danger', 'error', 'warning'], true) && is_string($message)) {
            $this->audit->failure($message);
        }
        return parent::flashMessage($message, $type);
    }

    public function error(string $message = '', int $httpCode = 404): void
    {
        if ($httpCode === 403) {
            if (!$this->audit->pending()) {
                $this->audit->begin(\App\Audit\Action::ACCESS_DENIED, [], ['stranka' => $this->getName()]);
            }
            $this->audit->failure($message);
        }
        parent::error($message, $httpCode);
    }

    protected function shutdown(Nette\Application\Response $response): void
    {
        parent::shutdown($response);
        // A pending mutation never becomes a success just because its request redirected.
        $this->audit->failure('Požadavek nebyl dokončen nebo neprošel kontrolou formuláře.');
    }

    protected function beforeRender(): void
    {
        parent::beforeRender();
        $this->template->currentDevice = $this->user->isLoggedIn() ? $this->deviceIdentity->getDevice() : null;
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
