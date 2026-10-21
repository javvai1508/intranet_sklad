<?php

declare(strict_types=1);

namespace App\Presenters;

use App\Models\InventoryModel;
use Nette\Application\UI\Form;

class InventoryPresenter extends BasePresenter
{
    public function __construct(\Nette\Database\Explorer $database, private readonly InventoryModel $dataModel)
    {
        parent::__construct($database);
    }

    public function startup()
    {
        parent::startup();
        if (!$this->user->isInRole('sklad')) { $this->redirect('Homepage:'); }
    }

    public function renderDefault(): void
    {
        $this->template->nadpis = 'Inventura';
        $this->template->inventories = $this->warehouseAction(fn() => $this->dataModel->getInventories()) ?: [];
    }

    private function inventory(int $id)
    {
        $inventory = $this->warehouseAction(fn() => $this->dataModel->getInventory($id));
        if (!$inventory) {
            $this->flashMessage('Inventura není dostupná pro kontrolu palet.', 'warning');
            $this->redirect('default');
        }
        $this->template->inventory = $inventory;
        $this->template->nadpis = 'Inventura ' . $inventory->Id . ' – sklad ' . $inventory->IdSklad;
        return $inventory;
    }

    private function actor(): string
    {
        // The identity is the numeric TabCisZam ID, so byte truncation is sufficient.
        return substr((string) $this->user->getId(), 0, 128);
    }

    public function renderShow(int $id, string $code = ''): void
    {
        $this->inventory($id);
        $items = $this->warehouseAction(fn() => $this->dataModel->getItems($id)) ?: [];
        $this->template->items = $items;
        $this->template->confirmed = count(array_filter($items, fn($r) => (int) $r->Confirmed === 1));
        $this->template->code = $code;
        $matches = $code === '' ? [] : array_values(array_filter($items, fn($r) => (string) $r->SerialNumber === $code));
        $this->template->matches = $matches;
        $this->template->locations = $code !== '' && !$matches
            ? ($this->warehouseAction(fn() => $this->dataModel->locatePallet($code)) ?: []) : [];
        $this->template->discrepancies = $this->warehouseAction(fn() => $this->dataModel->getDiscrepancies($id)) ?: [];
    }

    protected function createComponentScanForm(): Form
    {
        $form = new Form;
        $form->addProtection();
        $form->addText('barcode', 'Kód palety')->setRequired('Načtěte kód palety.')
            ->setMaxLength(102)->setHtmlAttribute('autofocus', true)
            ->setHtmlAttribute('autocomplete', 'off')->setHtmlAttribute('class', 'form-control');
        $form->addSubmit('scan', 'Načíst paletu')->setHtmlAttribute('class', 'btn btn-primary');
        $form->onSuccess[] = function (Form $form, $values): void {
            $id = (int) $this->getParameter('id');
            $this->inventory($id);
            $serial = $this->warehouseAction(fn() => InventoryModel::normalizeBarcode($values->barcode));
            if ($serial === false) { $this->redirect('show', ['id' => $id]); }
            $rows = $this->warehouseAction(fn() => $this->dataModel->getItems($id, $serial));
            if ($rows !== false && count($rows) === 1) {
                $this->redirect('item', ['id' => $id, 'itemId' => $rows[0]->Id]);
            }
            $this->redirect('show', ['id' => $id, 'code' => $serial]);
        };
        return $form;
    }

    public function renderItem(int $id, int $itemId): void
    {
        $this->inventory($id);
        $rows = $this->warehouseAction(fn() => $this->dataModel->getItems($id, null, $itemId));
        if (!$rows || (int) $rows[0]->Uzav) {
            $this->flashMessage('Položka není dostupná nebo je uzavřená.', 'warning');
            $this->redirect('show', ['id' => $id]);
        }
        $item = $rows[0];
        $this->template->item = $item;
        $this['quantityForm']->setDefaults([
            'quantity' => $item->CheckId === null ? $item->StockQuantity : $item->InventoryQuantity,
            'version' => InventoryModel::version($item),
        ]);
    }

    protected function createComponentQuantityForm(): Form
    {
        $form = new Form;
        $form->addProtection();
        $form->addHidden('version')->setRequired();
        $form->addText('quantity', 'Zjištěné množství v evidenční jednotce')->setRequired('Zadejte množství.')
            ->setMaxLength(20)->setHtmlAttribute('inputmode', 'decimal')
            ->setHtmlAttribute('autofocus', true)->setHtmlAttribute('class', 'form-control');
        $form->addCheckbox('zero', 'Potvrzuji zjištěné nulové množství');
        $form->addCheckbox('correction', 'Opravit dříve potvrzené množství');
        $form->addSubmit('save', 'Potvrdit množství')->setHtmlAttribute('class', 'btn btn-success');
        $form->onSuccess[] = function (Form $form, $values): void {
            $id = (int) $this->getParameter('id');
            $saved = $this->warehouseAction(fn() => $this->dataModel->saveQuantity($id,
                (int) $this->getParameter('itemId'), $values->quantity, $values->version,
                (bool) $values->correction, (bool) $values->zero, $this->actor()));
            if ($saved) {
                $this->flashMessage('Množství bylo uloženo. Načtěte další paletu.', 'success');
                $this->redirect('show', ['id' => $id]);
            }
            // Reload the row after a conflict; never silently reuse a stale version.
            $this->redirect('item', ['id' => $id, 'itemId' => (int) $this->getParameter('itemId')]);
        };
        return $form;
    }

    protected function createComponentDiscrepancyForm(): Form
    {
        $form = new Form;
        $form->addProtection();
        $form->addTextArea('note', 'Poznámka')->setMaxLength(1000)->setHtmlAttribute('class', 'form-control');
        $form->addSubmit('report', 'Zapsat nesrovnalost')->setHtmlAttribute('class', 'btn btn-warning');
        $form->onSuccess[] = function (Form $form, $values): void {
            $id = (int) $this->getParameter('id');
            if ($this->warehouseAction(fn() => $this->dataModel->reportUnknown($id,
                (string) $this->getParameter('code'), (string) $values->note, $this->actor()))) {
                $this->flashMessage('Nesrovnalost byla zapsána. Doplnění položky vyřešte v Heliosu.', 'success');
            }
            $this->redirect('show', ['id' => $id]);
        };
        return $form;
    }
}
