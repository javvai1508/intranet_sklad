<?php

declare(strict_types=1);

namespace App\Models;

class InventoryModel extends BaseModel
{
    private const OPEN_SQL = 'h.DatumClose IS NULL AND h.TypInv = 0 AND h.VC = 1 AND h.Stav = 0
        AND h.DatumDoklady IS NULL AND h.IdPrijem IS NULL AND h.IdVydej IS NULL';

    public function getInventories(): array
    {
        return $this->db->query('SELECT h.Id, h.IdSklad, h.Popis FROM TabInvHead h
            WHERE ' . self::OPEN_SQL . ' ORDER BY h.IdSklad, h.Id DESC')->fetchAll();
    }

    public function getInventory(int $id, bool $lock = false)
    {
        return $this->db->query('SELECT h.Id, h.IdSklad, h.Popis FROM TabInvHead h'
            . ($lock ? ' WITH (UPDLOCK, HOLDLOCK)' : '') . '
            WHERE h.Id = ? AND ' . self::OPEN_SQL, $id)->fetch();
    }

    private function requireInventory(int $id): void
    {
        if (!$this->getInventory($id, true)) {
            throw new \RuntimeException('Inventura již není otevřená pro kontrolu palet.');
        }
    }

    public static function normalizeBarcode(string $barcode): string
    {
        $barcode = trim($barcode);
        if (!preg_match('/^00[0-9]{1,100}$/D', $barcode)) {
            throw new \RuntimeException('Načtěte kód palety začínající 00.');
        }
        return substr($barcode, 2);
    }

    public static function normalizeQuantity(string $quantity): string
    {
        $quantity = str_replace(',', '.', trim($quantity));
        if (!preg_match('/^[0-9]{1,13}(?:\.[0-9]{1,6})?$/D', $quantity)) {
            throw new \RuntimeException('Zadejte nezáporné množství, nejvýše 13 číslic a 6 desetinných míst.');
        }
        [$whole, $fraction] = array_pad(explode('.', $quantity), 2, '');
        return (ltrim($whole, '0') ?: '0') . '.' . str_pad($fraction, 6, '0');
    }

    // Explicit text casts prevent loss of NUMERIC(19,6) precision in the PHP driver.
    public function getItems(int $id, ?string $serial = null, ?int $itemId = null, bool $lock = false): array
    {
        $parameters = [$id];
        $filter = '';
        if ($serial !== null) { $filter .= ' AND v.Nazev1 = ?'; $parameters[] = $serial; }
        if ($itemId !== null) { $filter .= ' AND i.Id = ?'; $parameters[] = $itemId; }
        return $this->db->query('SELECT i.Id, i.IdDoklad, i.IdSklad, i.IdVyrCS, i.IDUmisteni,
            i.Nazev1, i.RegCis, i.Uzav, v.Nazev1 AS SerialNumber, i.MJ,
            k.MJEvidence AS EvidenceUnit, u.Kod AS LocationCode, u.Nazev AS LocationName,
            CONVERT(varchar(40), i.MnozstviSklad) AS StockQuantity,
            CONVERT(varchar(40), i.MnozstviInv) AS InventoryQuantity,
            CONVERT(varchar(40), i.MnozstviMJ) AS UnitQuantity,
            CONVERT(varchar(50), i.PrepMnozstvi, 3) AS Conversion,
            a.ID AS CheckId, a.CheckedAt, a.CheckedBy,
            CASE WHEN a.ID IS NOT NULL AND a.InventoryQuantity = i.MnozstviInv
                AND a.UnitQuantity = i.MnozstviMJ AND a.StockQuantity = i.MnozstviSklad
                AND a.Conversion = i.PrepMnozstvi AND ISNULL(a.Unit, N\'\') = ISNULL(i.MJ, N\'\')
                THEN 1 ELSE 0 END AS Confirmed
            FROM TabInvItem i' . ($lock ? ' WITH (UPDLOCK, HOLDLOCK)' : '') . '
            JOIN TabInvHead h ON h.Id = i.IdDoklad
            JOIN TabStavSkladu s ON s.ID = i.IdSklad AND s.IDSklad = h.IdSklad
            JOIN TabVyrCS v ON v.ID = i.IdVyrCS
            JOIN TabKmenZbozi k ON k.ID = s.IDKmenZbozi
            LEFT JOIN TabVStavUmisteni su ON su.Id = i.IDUmisteni
            LEFT JOIN TabUmisteni u ON u.ID = su.IdUmisteni
            OUTER APPLY (SELECT TOP (1) c.* FROM dbo.eTab_IntranetInvCheck c
                WHERE c.ItemId = i.Id ORDER BY c.ID DESC) a
            WHERE i.IdDoklad = ?' . $filter . ' ORDER BY v.Nazev1, i.IDUmisteni, i.Id', ...$parameters)->fetchAll();
    }

    public static function version($row): string
    {
        return hash('sha256', json_encode(array_map(fn($key) => (string) ($row->$key ?? ''),
            ['Id', 'IdDoklad', 'IdSklad', 'IdVyrCS', 'IDUmisteni', 'Uzav', 'StockQuantity',
                'InventoryQuantity', 'UnitQuantity', 'Conversion', 'MJ', 'EvidenceUnit', 'SerialNumber', 'CheckId']), JSON_THROW_ON_ERROR));
    }

    public function saveQuantity(int $id, int $itemId, string $quantity, string $version,
        bool $correction, bool $zeroConfirmed, string $user): bool
    {
        $quantity = self::normalizeQuantity($quantity);
        if ($quantity === '0.000000' && !$zeroConfirmed) {
            throw new \RuntimeException('Potvrďte, že jste na paletě zjistili nulové množství.');
        }
        return $this->warehouseOperation(function () use ($id, $itemId, $quantity, $version, $correction, $user) {
            $this->requireInventory($id);
            $rows = $this->getItems($id, null, $itemId, true);
            $row = $rows[0] ?? null;
            if (!$row || (int) $row->Uzav || !hash_equals(self::version($row), $version)) {
                throw new \RuntimeException('Položka se změnila, je uzavřená nebo nepatří do inventury. Načtěte ji znovu.');
            }
            if ($row->CheckId !== null && !$correction) {
                throw new \RuntimeException('Paleta již byla kontrolována. Použijte opravu množství.');
            }
            // Reject invalid conversions before division; all decimal arithmetic stays in SQL.
            if (!is_numeric($row->Conversion) || (float) $row->Conversion <= 0) {
                throw new \RuntimeException('Položka nemá platný převod jednotek. Opravte ji v Heliosu.');
            }
            $this->db->query('UPDATE TabInvItem SET MnozstviInv = CAST(? AS numeric(19,6)),
                MnozstviMJ = CAST(CAST(? AS numeric(19,6)) / PrepMnozstvi AS numeric(19,6)),
                Zmenil = ?, DatZmeny = GETDATE() WHERE Id = ? AND IdDoklad = ? AND Uzav = 0',
                $quantity, $quantity, $user, $itemId, $id);
            $this->db->query('INSERT INTO dbo.eTab_IntranetInvCheck
                (InventoryId, ItemId, CheckedBy, InventoryQuantity, UnitQuantity, StockQuantity,
                 Conversion, Unit, PreviousInventoryQuantity, PreviousUnitQuantity)
                SELECT IdDoklad, Id, ?, MnozstviInv, MnozstviMJ, MnozstviSklad, PrepMnozstvi, MJ,
                    CAST(? AS numeric(19,6)), CAST(? AS numeric(19,6))
                FROM TabInvItem WHERE Id = ? AND IdDoklad = ?',
                $user, $row->InventoryQuantity, $row->UnitQuantity, $itemId, $id);
            $updated = $this->getItems($id, null, $itemId)[0] ?? null;
            if (!$updated || !(int) $updated->Confirmed || (string) $updated->InventoryQuantity !== $quantity
                || (string) $updated->CheckId === (string) $row->CheckId) {
                throw new \RuntimeException('Uložení kontroly se nepodařilo ověřit.');
            }
            return true;
        });
    }

    public function locatePallet(string $serial): array
    {
        return $this->db->query('SELECT v.Nazev1 AS SerialNumber, s.IDSklad, k.Nazev1,
            CONVERT(varchar(40), v.Mnozstvi) AS Quantity
            FROM TabVyrCS v JOIN TabStavSkladu s ON s.ID = v.IDStavSkladu
            JOIN TabKmenZbozi k ON k.ID = s.IDKmenZbozi
            WHERE v.Nazev1 = ? ORDER BY s.IDSklad, v.ID', $serial)->fetchAll();
    }

    public function getDiscrepancies(int $id): array
    {
        return $this->db->query('SELECT ID, SerialNumber, Note, ReportedAt, ReportedBy
            FROM dbo.eTab_IntranetInvDiscrepancy WHERE InventoryId = ? ORDER BY ID DESC', $id)->fetchAll();
    }

    public function reportUnknown(int $id, string $serial, string $note, string $user): bool
    {
        if (!preg_match('/^[0-9]{1,100}$/D', $serial) || mb_strlen($note) > 1000) {
            throw new \RuntimeException('Neplatné číslo palety nebo příliš dlouhá poznámka.');
        }
        return $this->warehouseOperation(function () use ($id, $serial, $note, $user) {
            $this->requireInventory($id);
            if ($this->getItems($id, $serial, null, true)) {
                throw new \RuntimeException('Paleta už je součástí inventury. Načtěte ji znovu.');
            }
            // A retry after an uncertain response must not duplicate the report.
            $this->db->query('INSERT INTO dbo.eTab_IntranetInvDiscrepancy
                (InventoryId, SerialNumber, Note, ReportedBy)
                SELECT ?, ?, ?, ? WHERE NOT EXISTS (SELECT 1 FROM dbo.eTab_IntranetInvDiscrepancy
                    WITH (UPDLOCK, HOLDLOCK) WHERE InventoryId = ? AND SerialNumber = ?)',
                $id, $serial, trim($note), $user, $id, $serial);
            return true;
        });
    }
}
