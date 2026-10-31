<?php

declare(strict_types=1);

namespace App\Audit;

use Nette\Application\UI\Presenter;

/** Explicit allowlist: never serialize request bodies, PINs, cookies or registration tokens. */
final class RequestAudit
{
    public static function start(Presenter $p, AuditLog $log): void
    {
        $request = $p->getRequest();
        $post = $request->getPost();
        $signal = $p->getParameter('do');
        $name = $p->getName();
        $action = null;
        $fields = [];
        $detail = [];
        $barcode = $post['BarCode'] ?? $post['barcode'] ?? '';
        $sscc = is_string($barcode) && preg_match('/^00[0-9]{1,100}$/D', trim($barcode)) ? substr(trim($barcode), 2) : null;
        if ($name === 'Sign' && $signal === 'signInForm-submit') $action = Action::LOGIN;
        if ($name === 'Sign' && $p->getAction() === 'out') $action = Action::LOGOUT;
        if ($name === 'Settings' && $signal === 'registerDeviceForm-submit') {
            $action = Action::DEVICE_REGISTER;
            // The target device is distinct from the device from which the admin works.
            $detail['ciloveZarizeni'] = filter_var($post['deviceId'] ?? null, FILTER_VALIDATE_INT) ?: null;
        }
        if ($name === 'DeliveryNote') {
            $fields = ['IDDoklad' => $p->getSession('deliveryNote')->deliveryNoteId,
                'IDPolozkaDokladu' => $p->getParameter('itemId'), 'IDVyrCP' => $p->getParameter('itemSNId'), 'SSCC' => $sscc];
            $action = match ($signal) {
                'setDeliveryNoteForm-submit' => Action::DELIVERY_SELECT,
                'changeDeliveryNote' => Action::DELIVERY_CHANGE,
                'readBarCodeForm-submit' => Action::DELIVERY_ADD,
                'removeDeliveryNoteItemSN' => Action::DELIVERY_REMOVE,
                'closeDeliveryNote' => Action::DELIVERY_CLOSE,
                default => null,
            };
        }
        if ($name === 'Material') {
            $type = $p->getSession('dispatch')->dispatchType;
            $outgoing = \App\Models\MaterialModel::isOutgoingTransfer($type);
            $fields = ['IDDoklad' => $p->getSession('dispatch')->dispatchId,
                'IDPolozkaDokladu' => $p->getParameter('itemId'), 'IDVyrCP' => $p->getParameter('itemSNId'), 'SSCC' => $sscc];
            $action = match ($signal) {
                'newTransferToSchenker', 'newTransferToLoukov', 'newTransferFromLoukov' => Action::TRANSFER_CREATE,
                'readBarCodeToShopForm-submit' => Action::SHOP_TRANSFER,
                'readBarCodeForm-submit' => $outgoing ? Action::TRANSFER_ADD : Action::TRANSFER_CONFIRM,
                'removeDispatchItemSN' => $outgoing ? Action::TRANSFER_REMOVE : Action::TRANSFER_UNCONFIRM,
                'removeDispatchItem' => $outgoing ? Action::TRANSFER_REMOVE_ITEM : Action::TRANSFER_UNCONFIRM_ITEM,
                'closeDispatch' => Action::TRANSFER_CLOSE,
                default => null,
            };
            if (in_array($action, [Action::SHOP_TRANSFER, Action::TRANSFER_CREATE], true)) $fields['IDDoklad'] = null;
            $detail['smer'] = match ($signal) {
                'newTransferToSchenker' => 'toSchenker', 'newTransferToLoukov' => 'toLoukov',
                'newTransferFromLoukov' => 'fromLoukov', default => $type,
            };
        }
        if ($name === 'TransferReceipt') {
            $fields = ['IDDoklad' => $p->getSession('loukovReceipt')->documentId, 'SSCC' => $sscc];
            $action = match ($signal) {
                'selectReceipt', 'selectDocumentForm-submit' => Action::RECEIPT_SELECT,
                'readBarCodeForm-submit' => Action::RECEIPT_CONFIRM,
                'finishReceipt' => Action::RECEIPT_CLOSE,
                default => null,
            };
        }
        if ($name === 'Inventory') {
            $fields = ['IDInventura' => $p->getParameter('id'), 'IDPolozkaInventury' => $p->getParameter('itemId'), 'SSCC' => $sscc];
            $action = match ($signal) {
                'scanForm-submit' => Action::INVENTORY_SCAN,
                'quantityForm-submit' => !empty($post['correction']) ? Action::INVENTORY_CORRECTION : Action::INVENTORY_QUANTITY,
                'discrepancyForm-submit' => Action::INVENTORY_UNKNOWN,
                default => null,
            };
            if ($action === Action::INVENTORY_UNKNOWN) $fields['SSCC'] = $p->getParameter('code');
        }
        if ($name === 'Production' && $signal === 'readBarCodeForm-submit') {
            $action = Action::PRODUCTION_COMPLETE;
            $fields['SSCC'] = $sscc;
        }
        if (in_array($action, [Action::DELIVERY_SELECT, Action::RECEIPT_SELECT], true)) {
            $number = $post['ParovaciZnak'] ?? $post['number'] ?? null;
            if (is_string($number)) $detail['hledaneCisloDokladu'] = \Nette\Utils\Strings::substring($number, 0, 50);
        }
        if ($action === Action::DELIVERY_SELECT) $fields['IDDoklad'] = null;
        if ($action === Action::RECEIPT_SELECT) $fields['IDDoklad'] = $signal === 'selectReceipt' ? $p->getParameter('documentId') : null;
        if ($action !== null) $log->begin($action, $fields, $detail);
    }
}
