<?php

declare(strict_types=1);

namespace App\Presenters;

use App\Models\DeviceModel;
use Nette\Application\UI\Form;

final class SettingsPresenter extends BasePresenter
{
    public function __construct(\Nette\Database\Explorer $database, private readonly DeviceModel $devices)
    {
        parent::__construct($database);
    }

    public function startup()
    {
        parent::startup();
        if (!$this->hasAccess('admin')) {
            $this->error('Nastavení je přístupné pouze správci.', 403);
        }
    }

    public function renderDefault(): void
    {
        $this->template->nadpis = 'Nastavení';
    }

    protected function createComponentRegisterDeviceForm(): Form
    {
        $form = new Form;
        $form->addProtection();
        $options = [];
        try {
            foreach ($this->devices->getAvailableDevices() as $device) {
                $options[$device->ID] = $device->Kod . ' – ' . $device->Nazev
                    . ($device->Model ? ' (' . $device->Model . ')' : '')
                    . ($device->Registrovano ? ' – již registrováno' : '');
            }
        } catch (\Nette\Database\DriverException $e) {
            \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            $form->addError('Evidenci zařízení nelze načíst. Ověřte tabulku eTab_IntranetZarizeni a oprávnění aplikace.');
        }
        $form->addSelect('deviceId', 'Zařízení', $options)->setPrompt('Vyberte zařízení')
            ->setRequired('Vyberte zařízení.')->setHtmlAttribute('class', 'form-select');
        $form->addCheckbox('replace', 'Potvrzuji nahrazení původní registrace vybraného zařízení.');
        $form->addSubmit('register', 'Zaregistrovat tento přístroj')->setDisabled(!$options)
            ->setHtmlAttribute('class', 'btn btn-primary');
        $form->onSuccess[] = function (Form $form, $values): void {
            // Defense in depth for form callbacks as well as ordinary presenter requests.
            if (!$this->hasAccess('admin')) {
                $this->error('Nastavení je přístupné pouze správci.', 403);
            }
            try {
                $this->deviceIdentity->register((int) $values->deviceId, (bool) $values->replace);
            } catch (\Nette\Database\DriverException $e) {
                \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
                $form->addError('Registraci se nepodařilo uložit. Ověřte evidenci zařízení a opakujte akci.');
                return;
            } catch (\RuntimeException $e) {
                $form->addError($e->getMessage());
                return;
            }
            $this->flashMessage('Tento přístroj byl zaregistrován. Registrace zůstane zachována i po odhlášení.', 'success');
            $this->redirect('this');
        };
        return $form;
    }
}
