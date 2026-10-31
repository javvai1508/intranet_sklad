<?php

namespace App\Presenters;

use App\Forms\ReadBarCodeFormFactory;
use App\Models\TransferReceiptModel;
use Nette\Application\UI\Form;

class TransferReceiptPresenter extends BasePresenter
{
    public function __construct(
        \Nette\Database\Explorer $database,
        private readonly TransferReceiptModel $dataModel,
        private readonly ReadBarCodeFormFactory $readBarCodeFactory,
    ) {
        parent::__construct($database);
    }

    public function startup()
    {
        parent::startup();
        if (!$this->hasAccess('sklad')) {
            $this->audit->begin(\App\Audit\Action::ACCESS_DENIED, [], ['stranka' => $this->getName()]);
            $this->audit->failure('Uživatel nemá oprávnění pro tuto část aplikace.');
            $this->redirect('Homepage:');
        }
    }

    public function renderDefault(string $target = ''): void
    {
        $this->template->nadpis = 'Kontrola příjmu převodů';
        $this->template->target = $target;
        $this->template->documents = $this->warehouseAction(fn() => $this->dataModel->getPendingDocuments($target)) ?: [];
    }

    private function selectDocument($document): void
    {
        if (!$document || !(int) $document->Ready) {
            $this->flashMessage('Výdejka není připravená ke kontrole příjmu převodu.', 'danger');
            $this->redirect('default');
        }
        $this->audit->enrich(['IDDoklad' => $document->ID], ['zdrojovySklad' => $document->SourceWarehouse, 'cilovySklad' => $document->TargetWarehouse]);
        $this->audit->complete();
        $this->getSession('loukovReceipt')->documentId = $document->ID;
        $this->redirect('showReceipt');
    }

    public function handleSelectReceipt(int $documentId): void
    {
        $this->selectDocument($this->warehouseAction(fn() => $this->dataModel->getDocument($documentId)));
    }

    protected function createComponentSelectDocumentForm(): Form
    {
        $form = new Form;
        $form->addProtection('Platnost formuláře vypršela. Obnovte stránku.');
        $form->addText('number', 'Číslo výdejky')
            ->setRequired('Zadejte číslo výdejky.')
            ->setMaxLength(50)
            ->setHtmlAttribute('class', 'form-control')
            ->setHtmlAttribute('autocomplete', 'off')
            ->setHtmlAttribute('autofocus', true);
        $form->addSubmit('select', 'Vybrat výdejku')->setHtmlAttribute('class', 'btn btn-primary');
        $form->onSuccess[] = function (Form $form, $values): void {
            $document = $this->warehouseAction(fn() => $this->dataModel->findDocument(trim($values->number)));
            if (!$document) {
                $this->redirect('default');
            }
            $this->selectDocument($document);
        };
        return $form;
    }

    public function renderShowReceipt(): void
    {
        $id = $this->getSession('loukovReceipt')->documentId;
        if (!$id) {
            $this->redirect('default');
        }
        $document = $this->warehouseAction(fn() => $this->dataModel->getDocument($id));
        if (!$document || !(int) $document->Ready) {
            $this->getSession('loukovReceipt')->remove();
            $this->flashMessage('Vybraná výdejka již není dostupná pro příjem v Loukově.', 'danger');
            $this->redirect('default');
        }
        $pallets = $this->warehouseAction(fn() => $this->dataModel->getPallets($id));
        if ($pallets === false) {
            $this->redirect('default');
        }
        $confirmed = count(array_filter($pallets, fn($p) => (int) $p->Confirmed === 1));
        $this->template->nadpis = 'Kontrola příjmu: ' . $document->ParovaciZnak;
        $this->template->receipt = $document;
        $this->template->pallets = $pallets;
        $this->template->confirmed = $confirmed;
        $this->template->canFinish = count($pallets) > 0 && $confirmed === count($pallets);
        $this['readBarCodeForm']->setDefaults(['dispatchId' => $id]);
    }

    protected function createComponentReadBarCodeForm(): Form
    {
        $form = $this->readBarCodeFactory->create();
        $form->onSuccess[] = function (Form $form, $values): void {
            $id = $this->getSession('loukovReceipt')->documentId;
            if (!$id || (string) $values->dispatchId !== (string) $id) {
                $this->flashMessage('Výběr výdejky se změnil. Obnovte stránku a načtěte paletu znovu.', 'danger');
                $this->redirect('default');
            }
            $barcode = trim((string) $values->BarCode);
            if (!preg_match('/^00[0-9]+$/D', $barcode)) {
                $this->flashMessage('Není číslo palety!', 'danger');
                $this->redirect('showReceipt');
            }
            if ($this->warehouseAction(fn() => $this->dataModel->confirmPallet($id, substr($barcode, 2)))) {
                $this->flashMessage('Paleta byla potvrzena.', 'success');
            }
            $this->redirect('showReceipt');
        };
        return $form;
    }

    public function handleFinishReceipt(int $documentId): void
    {
        if ((string) $documentId !== (string) $this->getSession('loukovReceipt')->documentId) {
            $this->flashMessage('Výběr výdejky se změnil. Obnovte stránku.', 'danger');
            $this->redirect('default');
        }
        if ($this->warehouseAction(fn() => $this->dataModel->finish($documentId))) {
            $this->flashMessage('Kontrola příjmu převodu byla uzavřena.', 'success');
        }
        $this->redirect('showReceipt');
    }
}
