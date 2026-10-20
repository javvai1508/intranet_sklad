<?php

namespace App\Models;

/**
 * Destination check on the original inter-warehouse dispatch, not an accounting receipt.
 * Source dispatches may already be realised; BaseModel::assertDocument therefore
 * cannot be used because it deliberately rejects realised source documents.
 */
class TransferReceiptModel extends BaseModel
{
    private function scope(): array
    {
        $parameters = [];
        foreach (['toLoukov', 'fromLoukov'] as $type) {
            $s = MaterialModel::getTransferSettings($type);
            array_push($parameters, $s['source'], $s['series'], $s['target'], $s['receiptSeries']);
        }
        return $parameters;
    }

    private const SCOPE_SQL = 'd.DruhPohybuZbo = 4 AND d.DruhPohybuPrevod = 0 AND (
        (d.IDSklad = ? AND d.RadaDokladu = ? AND d.IdSkladPrevodu = ? AND d.TypPrevodky = ?)
        OR (d.IDSklad = ? AND d.RadaDokladu = ? AND d.IdSkladPrevodu = ? AND d.TypPrevodky = ?))';

    private const DIRECTION_SQL = "d.IDSklad AS SourceWarehouse, d.IdSkladPrevodu AS TargetWarehouse,
        CASE WHEN d.IdSkladPrevodu = '00100308' THEN N'Do Loukova' ELSE N'Z Loukova' END AS Direction";


    public function getPendingDocuments(string $target = ''): array
    {
        if (!in_array($target, ['', '00100308', '00100304'], true)) {
            throw new \RuntimeException('Neznámý cílový sklad.');
        }
        $filter = $target === '' ? '' : ' AND d.IdSkladPrevodu = ?';
        $parameters = $target === '' ? $this->scope() : array_merge($this->scope(), [$target]);
        return $this->db->query('SELECT d.ID, d.ParovaciZnak, d.DatPorizeni, ' . self::DIRECTION_SQL . '
            FROM TabDokladyZbozi d
            LEFT JOIN TabDokladyZbozi_EXT e ON e.ID = d.ID
            WHERE ' . self::SCOPE_SQL . ' AND e._exp_schenker_datzprac IS NULL
            AND (e._exp_dat_uzavreno IS NOT NULL OR d.DatRealizace IS NOT NULL)
            ' . $filter . ' ORDER BY d.DatPorizeni, d.ID', ...$parameters)->fetchAll();
    }

    public function findDocument(string $number)
    {
        $rows = $this->db->query('SELECT d.ID FROM TabDokladyZbozi d
            WHERE ' . self::SCOPE_SQL . ' AND d.ParovaciZnak = ?',
            ...array_merge($this->scope(), [trim($number)]))->fetchAll();
        if (count($rows) !== 1) {
            throw new \RuntimeException('Převodka nebyla jednoznačně nalezena. Vyberte ji z přehledu.');
        }
        return $this->getDocument($rows[0]->ID);
    }

    public function getDocument($documentId, bool $lock = false)
    {
        $hint = $lock ? ' WITH (UPDLOCK, HOLDLOCK)' : '';
        return $this->db->query('SELECT d.ID, d.ParovaciZnak, d.DatPorizeni, ' . self::DIRECTION_SQL . ',
            e._exp_schenker_datzprac AS CompletedAt,
            CASE WHEN e._exp_dat_uzavreno IS NOT NULL OR d.DatRealizace IS NOT NULL
                THEN 1 ELSE 0 END AS Ready
            FROM TabDokladyZbozi d' . $hint . '
            LEFT JOIN TabDokladyZbozi_EXT e' . $hint . ' ON e.ID = d.ID
            WHERE ' . self::SCOPE_SQL . ' AND d.ID = ?',
            ...array_merge($this->scope(), [$documentId]))->fetch();
    }

    public function getPallets($documentId, bool $lock = false): array
    {
        $hint = $lock ? ' WITH (UPDLOCK, HOLDLOCK)' : '';
        return $this->db->query('SELECT cp.ID, cp.IDPolozkaDokladu AS ItemId,
            vc.Nazev1 AS SerialNumber, p.Nazev1 AS ProductName, p.MJ,
            cp.Mnozstvi AS Quantity, e._exp_schenker_mnoz AS ReceivedQuantity,
            e._exp_schenker_datcas AS ScannedAt,
            CASE WHEN cp.Mnozstvi > 0 AND e._exp_schenker_datcas IS NOT NULL
                AND e._exp_schenker_mnoz = cp.Mnozstvi THEN 1 ELSE 0 END AS Confirmed
            FROM TabPohybyZbozi p' . $hint . '
            JOIN TabVyrCP cp' . $hint . ' ON cp.IDPolozkaDokladu = p.ID
            JOIN TabVyrCS vc ON vc.ID = cp.IDVyrCis
            LEFT JOIN TabVyrCP_EXT e' . $hint . ' ON e.ID = cp.ID
            WHERE p.IDDoklad = ? ORDER BY p.Poradi, cp.ID', $documentId)->fetchAll();
    }

    private function requireOpenDocument($documentId): void
    {
        if (!filter_var($documentId, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]])) {
            throw new \RuntimeException('Nejprve vyberte výdejku.');
        }
        $doc = $this->getDocument($documentId, true);
        if (!$doc || !(int) $doc->Ready) {
            throw new \RuntimeException('Výdejka není podporovaným převodem nebo dosud není uzavřená ve zdrojovém skladu.');
        }
        if ($doc->CompletedAt !== null) {
            throw new \RuntimeException('Kontrola příjmu již byla uzavřena.');
        }
    }

    public function confirmPallet($documentId, string $serialNumber): bool
    {
        return $this->warehouseOperation(function () use ($documentId, $serialNumber) {
            $this->requireOpenDocument($documentId);
            $matches = array_values(array_filter($this->getPallets($documentId, true),
                fn($p) => (string) $p->SerialNumber === $serialNumber));
            if (count($matches) !== 1) {
                throw new \RuntimeException('Paleta není na vybrané výdejce nebo je na ní uvedena vícekrát.');
            }
            $pallet = $matches[0];
            if ($pallet->ScannedAt !== null) {
                throw new \RuntimeException('Paleta již byla načtena. Zkontrolujte její stav v přehledu.');
            }
            if ($pallet->Quantity <= 0) {
                throw new \RuntimeException('Paleta nemá na výdejce kladné množství.');
            }
            // Copy the exact decimal quantity in SQL; never take quantity from the client.
            $this->db->query('UPDATE e SET _exp_schenker_datcas = GETDATE(),
                    _exp_schenker_mnoz = cp.Mnozstvi
                FROM TabVyrCP_EXT e JOIN TabVyrCP cp ON cp.ID = e.ID
                WHERE cp.ID = ?', $pallet->ID);
            $this->db->query('INSERT INTO TabVyrCP_EXT (ID, _exp_schenker_datcas, _exp_schenker_mnoz)
                SELECT cp.ID, GETDATE(), cp.Mnozstvi FROM TabVyrCP cp
                WHERE cp.ID = ? AND NOT EXISTS (SELECT 1 FROM TabVyrCP_EXT e WHERE e.ID = cp.ID)', $pallet->ID);
            foreach ($this->getPallets($documentId, true) as $updated) {
                if ((int) $updated->ID === (int) $pallet->ID && (int) $updated->Confirmed === 1) {
                    return true;
                }
            }
            throw new \RuntimeException('Potvrzení palety se nepodařilo uložit.');
        });
    }

    public function finish($documentId): bool
    {
        return $this->warehouseOperation(function () use ($documentId) {
            $this->requireOpenDocument($documentId);
            $pallets = $this->getPallets($documentId, true);
            if (!$pallets) {
                throw new \RuntimeException('Prázdnou výdejku nelze potvrdit.');
            }
            foreach ($pallets as $pallet) {
                if ((int) $pallet->Confirmed !== 1) {
                    throw new \RuntimeException('Nejsou potvrzené všechny palety nebo se změnilo jejich množství.');
                }
            }
            // A document item without pallets or with an inconsistent total must not be closed.
            if ($this->db->query('SELECT TOP (1) p.ID AS InconsistentItem
                FROM TabPohybyZbozi p WITH (UPDLOCK, HOLDLOCK)
                WHERE p.IDDoklad = ? AND (p.Mnozstvi <= 0
                    OR NOT EXISTS (SELECT 1 FROM TabVyrCP cp WHERE cp.IDPolozkaDokladu = p.ID)
                    OR p.Mnozstvi <> (SELECT SUM(cp.Mnozstvi) FROM TabVyrCP cp WHERE cp.IDPolozkaDokladu = p.ID))',
                $documentId)->fetch()) {
                throw new \RuntimeException('Množství položek neodpovídá rozpisu palet. Opravte doklad v Heliosu.');
            }
            $this->db->query('UPDATE TabDokladyZbozi_EXT SET _exp_schenker_datzprac = GETDATE()
                WHERE ID = ? AND _exp_schenker_datzprac IS NULL', $documentId);
            $doc = $this->getDocument($documentId, true);
            if (!$doc || $doc->CompletedAt === null) {
                throw new \RuntimeException('Uzavření kontroly se nepodařilo uložit.');
            }
            return true;
        });
    }
}
