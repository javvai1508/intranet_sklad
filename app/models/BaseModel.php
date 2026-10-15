<?php

namespace App\Models;

use Nette;
use Nette\Security\Passwords;

class BaseModel
{

    /** @var Nette\Security\Passwords */
    public $passwords;

    /** @var Nette\Database\Explorer */
    public $db;

    // pass Nette\Database\Explorer to work with the Database Explorer layer
	public function __construct(
		private Nette\Database\Explorer $database,
		private Nette\Security\Passwords $password,
	) {
        $this->db = $database;
        $this->passwords = $password;
	}


    public function warehouseOperation(callable $operation)
    {
        return $this->db->getConnection()->transaction(function () use ($operation) {
            $lock = $this->db->query("SET NOCOUNT ON; DECLARE @result INT;
                EXEC @result = sys.sp_getapplock @Resource = N'intranet_sklad:write',
                    @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
                SELECT @result AS result;")->fetchField();
            if ($lock === null || (int) $lock < 0) {
                throw new \RuntimeException('Sklad právě zpracovává jiný požadavek. Opakujte akci.');
            }
            return $operation();
        });
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