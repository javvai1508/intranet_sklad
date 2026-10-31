<?php

declare(strict_types=1);

namespace App\Audit;

/** Shared action IDs. Never renumber or reuse an existing value. */
final class Action
{
    public const LOGIN = 100;
    public const LOGOUT = 101;
    public const ACCESS_DENIED = 102;
    public const DEVICE_REGISTER = 200;
    public const DEVICE_REPLACE = 201;
    public const DELIVERY_SELECT = 300;
    public const DELIVERY_CHANGE = 301;
    public const DELIVERY_ADD = 310;
    public const DELIVERY_REMOVE = 311;
    public const DELIVERY_CLOSE = 320;
    public const TRANSFER_CREATE = 400;
    public const TRANSFER_RESUME = 401;
    public const TRANSFER_ADD = 410;
    public const TRANSFER_REMOVE = 411;
    public const TRANSFER_REMOVE_ITEM = 412;
    public const TRANSFER_CONFIRM = 413;
    public const TRANSFER_UNCONFIRM = 414;
    public const TRANSFER_UNCONFIRM_ITEM = 415;
    public const TRANSFER_CLOSE = 420;
    public const SHOP_TRANSFER = 430;
    public const RECEIPT_SELECT = 500;
    public const RECEIPT_CONFIRM = 510;
    public const RECEIPT_CLOSE = 520;
    public const INVENTORY_SELECT = 600;
    public const INVENTORY_SCAN = 601;
    public const INVENTORY_QUANTITY = 610;
    public const INVENTORY_CORRECTION = 611;
    public const INVENTORY_UNKNOWN = 620;
    public const PRODUCTION_COMPLETE = 700;
}
