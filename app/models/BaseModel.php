<?php

namespace App\Models;

use Nette;

class BaseModel
{
    /** @var Nette\Database\Explorer */
    public $db;

    protected ?\App\Audit\AuditLog $audit = null;

    public function __construct(Nette\Database\Explorer $database)
    {
        $this->db = $database;
    }

    public function setAuditLog(\App\Audit\AuditLog $audit): void
    {
        $this->audit = $audit;
    }

    public function warehouseOperation(callable $operation)
    {
        return $this->auditedTransaction($operation, true);
    }

    protected function auditedTransaction(callable $operation, bool $warehouseLock = false)
    {
        try {
            $result = $this->db->getConnection()->transaction(function () use ($operation, $warehouseLock) {
                if ($warehouseLock) {
                    $lock = $this->db->query("SET NOCOUNT ON; DECLARE @result INT;
                        EXEC @result = sys.sp_getapplock @Resource = N'intranet_sklad:write',
                            @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
                        SELECT @result AS result;")->fetchField();
                    if ($lock === null || (int) $lock < 0) {
                        throw new \RuntimeException('Sklad právě zpracovává jiný požadavek. Opakujte akci.');
                    }
                }
                $this->audit?->capturePallets();
                $result = $operation();
                if ($result === false) {
                    throw new \RuntimeException('Operace neprovedla požadovanou změnu.');
                }
                $this->audit?->capturePallets();
                $this->audit?->writeSuccess();
                return $result;
            });
            $this->audit?->accept();
            return $result;
        } catch (\Throwable $e) {
            $this->audit?->failure($e instanceof Nette\Database\DriverException
                ? 'Databázová chyba při zpracování operace.' : $e->getMessage(),
                $e instanceof Nette\Database\DriverException || !$e instanceof \RuntimeException ? 3 : 2);
            throw $e;
        }
    }

    public function assertDocument($documentId, $itemId = null, $serialId = null, bool $open = true): void
    {
        if (!filter_var($documentId, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]])) {
            throw new \RuntimeException('Nejprve vyberte doklad.');
        }
        $document = $this->db->query("SELECT d.ID, d.DatRealizace, d.StavPrevodu,
            e._exp_dat_uzavreno AS Closed,
            CASE WHEN EXISTS(SELECT 1 FROM TabDokumVazba WHERE IdentVazby = 9 AND IDTab = d.ID)
                THEN 1 ELSE 0 END AS Linked
            FROM TabDokladyZbozi d WITH (UPDLOCK, HOLDLOCK)
            LEFT JOIN TabDokladyZbozi_EXT e WITH (UPDLOCK, HOLDLOCK) ON e.ID = d.ID
            WHERE d.ID = ?", $documentId)->fetch();
        if (!$document || ($open && ($document->Closed !== null || $document->DatRealizace !== null
            || in_array((int) $document->StavPrevodu, [1, 2, 3, 4, 5], true) || $document->Linked))) {
            throw new \RuntimeException('Doklad neexistuje nebo je již uzavřený.');
        }
        if ($itemId !== null && !$this->db->query(
            'SELECT ID FROM TabPohybyZbozi WHERE ID = ? AND IDDoklad = ?', $itemId, $documentId)->fetch()) {
            throw new \RuntimeException('Položka nepatří na vybraný doklad.');
        }
        if ($serialId !== null && !$this->db->query('SELECT vc.ID FROM TabVyrCP vc
            JOIN TabPohybyZbozi p ON p.ID = vc.IDPolozkaDokladu
            WHERE vc.ID = ? AND p.IDDoklad = ? AND p.ID = ?', $serialId, $documentId, $itemId)->fetch()) {
            throw new \RuntimeException('Paleta nepatří k vybrané položce.');
        }
    }
}
