<?php

namespace App\Models;

class MaterialModel extends BaseModel {

    private const TRANSFERS = [
        'toSchenker' => ['source' => '00100304', 'series' => '372', 'target' => '00100303', 'receiptSeries' => '351', 'title' => 'Do Schenkeru'],
        'fromLoukov' => ['source' => '00100308', 'series' => '381', 'target' => '00100304', 'receiptSeries' => '351', 'title' => 'Z Loukova'],
        'toLoukov' => ['source' => '00100304', 'series' => '384', 'target' => '00100308', 'receiptSeries' => '351', 'title' => 'Do Loukova'],
    ];

    public static function isOutgoingTransfer(?string $type): bool
    {
        return isset(self::TRANSFERS[$type ?? '']);
    }

    public static function getTransferSettings(string $type): array
    {
        return self::TRANSFERS[$type] ?? throw new \RuntimeException('Neznámý typ převodu.');
    }


    /** !!!
     * dohledání a dotažení výdejky
     * @param type $dispatchId
     */
    public function getDispatch($dispatchId) {
        return $this->db->query("SELECT do.ID, "
                        . "do.RadaDokladu, "
                        . "do.PoradoveCislo, "
                        . "do.DatPorizeni, "
                        . "do.ParovaciZnak, "
                        . "do.IDSklad, do.DruhPohybuZbo, do.IdSkladPrevodu, do.TypPrevodky, do.DruhPohybuPrevod, "
                        . "CONVERT(NVARCHAR(20), doe._exp_dat_uzavreno, 104) AS DatUzavrenoExp, "
                        . "CASE WHEN doe._exp_dat_uzavreno IS NOT NULL OR do.DatRealizace IS NOT NULL THEN 1 ELSE 0 END AS StavDispExp, "
                        . "cntvc.cnt AS PocetPalet, "
                        . "ISNULL(cntvc.priprava, 0) AS Priprava "
                        . "FROM TabDokladyZbozi do "
                        . "LEFT JOIN TabDokladyZbozi_EXT doe ON do.ID = doe.ID "
                        . "LEFT JOIN (SELECT po.IDDoklad AS IDDoklad, COUNT(vcp.ID) AS cnt, SUM(CASE WHEN ISNULL(vcpe._exp_mnoz_potvrz, 0) > 0 THEN 1 ELSE 0 END) AS priprava "
                        . "FROM TabVyrCP vcp "
                        . "LEFT JOIN TabVyrCP_EXT vcpe ON vcp.ID = vcpe.ID "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "GROUP BY po.IDDoklad) cntvc ON cntvc.IDDoklad = do.ID "
                        . "WHERE do.ID = ?", $dispatchId)->fetch();
    }

    /** !!!
     * dohledání a dotažení položek výdejky
     * @param type $dispatchId
     */
    public function getDispatchItems($dispatchId) {
        return $this->db->query("SELECT "
                        . "vy.ID AS DispatchItemID, "
                        . "vy.Nazev1 AS Nazev, "
                        . "vy.MJ AS MJ, "
                        . "vy.Mnozstvi AS Mnozstvi, "
                        . "cntvc.cnt AS PocetPalet, "
                        . "cntvc.pripravaMnoz AS PripravaMnoz, "
                        . "cntvc.priprava AS Priprava "
                        . "FROM TabPohybyZbozi vy "
                        . "LEFT JOIN TabPohybyZbozi_EXT vye ON vye.ID = vy.ID "
                        . "LEFT JOIN (SELECT po.ID AS IDPohyb, COUNT(vcp.ID) AS cnt, SUM(ISNULL(vcpe._exp_mnoz_potvrz, 0)) AS pripravaMnoz, SUM(CASE WHEN ISNULL(vcpe._exp_mnoz_potvrz, 0) > 0 THEN 1 ELSE 0 END) AS priprava "
                        . "FROM TabVyrCP vcp "
                        . "LEFT JOIN TabVyrCP_EXT vcpe ON vcp.ID = vcpe.ID "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "GROUP BY po.ID) cntvc ON cntvc.IDPohyb = vy.ID "
                        . "/*LEFT JOIN (SELECT po.ID AS IDPohyb, COUNT(vcp.ID) AS cnt "
                        . "FROM TabVyrCP vcp "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "GROUP BY po.ID) cntvc ON cntvc.IDPohyb = vy.ID */"
                        . "WHERE vy.IDDoklad = ?", $dispatchId)->fetchAll();
    }

    /**
     * dohledání položky výdejky
     * @param type $itemId
     */
    public function getDispatchItem($itemId) {
        return $this->db->query("SELECT "
                        . "pr.ID AS DispatchItemID, "
                        . "pr.Nazev1 AS Nazev, "
                        . "pr.MJ AS MJ, "
                        . "pr.Mnozstvi AS Mnozstvi, "
                        . "cntvc.cnt AS PocetPalet,  "
                        . "cntvc.pripravaMnoz AS PripravaMnoz, "
                        . "cntvc.priprava AS Priprava "
                        . "FROM TabPohybyZbozi pr "
                        . "LEFT JOIN TabPohybyZbozi_EXT pre ON pre.ID = pr.ID "
                        . "LEFT JOIN (SELECT po.ID AS IDPohyb, COUNT(vcp.ID) AS cnt, SUM(ISNULL(vcpe._exp_mnoz_potvrz, 0)) AS pripravaMnoz, SUM(CASE WHEN ISNULL(vcpe._exp_mnoz_potvrz, 0) > 0 THEN 1 ELSE 0 END) AS priprava "
                        . "FROM TabVyrCP vcp "
                        . "LEFT JOIN TabVyrCP_EXT vcpe ON vcp.ID = vcpe.ID "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "GROUP BY po.ID) cntvc ON cntvc.IDPohyb = pr.ID "
                        . "LEFT JOIN TabPohybyZbozi vo ON pr.IDOldPolozka = vo.ID "
                        . "LEFT JOIN TabDokladyZbozi vod ON vod.ID = vo.IDDoklad "
                        . "WHERE pr.ID = ?", $itemId)->fetch();

    }

    /**
     * dohledání a dotažení seriových čísel položek výdejky
     * @param type $itemId
     */
    public function getDispatchItemSN($itemId) {
        return $this->db->query("SELECT pr.ID AS DispatchItemID, "
                        . "vc.ID AS IDVyrCP, "
                        . "vcs.Nazev1 AS Nazev, "
                        . "vc.Mnozstvi AS Mnozstvi, "
                        . "ISNULL(vce._exp_mnoz_potvrz, 0) AS PripravaMnoz "
                        . "FROM TabVyrCP vc "
                        . "LEFT JOIN TabVyrCP_EXT vce ON vc.ID = vce.ID "
                        . "JOIN TabVyrCS vcs ON vcs.ID = vc.IDVyrCis "
                        . "JOIN TabPohybyZbozi pr ON vc.IDPolozkaDokladu = pr.ID "
                        . "WHERE pr.ID = ? ", $itemId)->fetchAll();
    }

    /** !!!
     * kontrola otevřené výdejky 
     * @return type
     */
    public function checkDispatchOpen($dispatchType) {
        $settings = self::getTransferSettings($dispatchType);
        // Both Loukov directions block a new dispatch until the destination check is completed,
        // including dispatches already closed or realised at the source warehouse.
        $openCondition = in_array($dispatchType, ['toLoukov', 'fromLoukov'], true)
            ? 'doe._exp_schenker_datzprac IS NULL'
            : 'do.DatRealizace IS NULL AND doe._exp_dat_uzavreno IS NULL';
        $res = $this->db->query("SELECT "
                        . "do.ID, "
                        . "do.ParovaciZnak, "
                        . "doe._skl_token "
                        . "FROM TabDokladyZbozi do "
                        . "JOIN TabDokladyZbozi_EXT doe ON do.ID = doe.ID "
                        . "WHERE do.DruhPohybuZbo = 4 AND do.RadaDokladu = ? AND do.IDSklad = ? AND " . $openCondition, $settings['series'], $settings['source'])->fetchAll();
        return $res;
    }

    /** !!!
     * založení výdejky mimo operace (vlastní spotřeba, zmetek, prodej)
     * @return type
     */
    private function openNewDispatchInternal($dispatchType) {
        $token = bin2hex(random_bytes(6));
        // založit pouze hlavičku
        $this->db->query("SET NOCOUNT ON; EXEC hpx_agrafa_sklad_zaloz_vydej_ost_hl_tablet @TypVydejky = ?, @Token = ?", $dispatchType, $token);
        $res["IDDoklad"] = $this->db->query("SELECT ID FROM TabDokladyZbozi_EXT WHERE _skl_token = ?", $token)->fetchField();
        return $res;

    }

    /** !!!
     * kontrola zadaného výrobního čísla kromě výdejek na operaci
     * @param type $dispatchId
     * @param type $serialNumber
     * @return type
     */
    public function checkSerialNumberOther($dispatchId, $serialNumber) {
        $idSklad = $this->db->query("SELECT IDSklad FROM TabDokladyZbozi WHERE ID = ?", $dispatchId)->fetchField();
        return $this->db->query("SELECT "
                        . "vc.ID AS IDVyrCis, "
                        . "vc.Nazev1 AS BarCode, "
                        . "CONVERT(INT, vc.Mnozstvi) AS Mnozstvi, "
                        . "CONVERT(INT, vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji) AS MnozstviPoPrijmuAVydeji, "
                        . "vc.IDStavSkladu AS IDZboSklad "
                        . "FROM TabVyrCS vc WITH (UPDLOCK, HOLDLOCK) "
                        . "JOIN TabStavSkladu skl ON skl.ID = vc.IDStavSkladu "
                        . "WHERE vc.Nazev1 = ? AND skl.IDSklad = ?", $serialNumber, $idSklad)->fetch();
    }

    /** !!!
     * doplní výrobní číslo do dokladu 
     * @param type $serialNumber
     * @param type $mnozstviPriprava
     * @return type
     */
    private function updateDispatchItemOtherInternal($barCode, $dispatchId) {
        $res = -9;
            // spustit akci na přidání položky do výdejky
            $itemId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_pridej_paletu @SSCC = ?, @IDDoklad = ? ", $barCode, $dispatchId);

            if ($res) {
                $res = $itemId;
            }
            return $res;
    }

    /** !!!
     * kontrola zadaného výrobního čísla - příprava - převod ze Schenkeru
     * @param type $dispatchId
     * @param type $serialNumber
     * @return type
     */
    public function checkSerialNumberPrepare($dispatchId, $serialNumber) {
        return $this->db->query("SELECT "
                        . "vc.ID AS IDVyrCis, "
                        . "vc.Nazev1 AS BarCode, "
                        . "CONVERT(INT, vc.Mnozstvi) AS Mnozstvi, "
                        . "CONVERT(INT, vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji) AS MnozstviPoPrijmuAVydeji, "
                        . "CONVERT(INT, ISNULL(vcpe._exp_mnoz_potvrz, 0)) AS MnozstviPotvrz, "
                        . "vc.IDStavSkladu AS IDZboSklad "
                        . "FROM TabVyrCP vcp "
                        . "LEFT JOIN TabVyrCP_EXT vcpe ON vcp.ID = vcpe.ID "
                        . "JOIN TabVyrCS vc ON vcp.IDVyrCis = vc.ID "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "JOIN TabStavSkladu skl ON skl.ID = vc.IDStavSkladu "
                        . "WHERE vc.Nazev1 = ? AND po.IDDoklad = ?", $serialNumber, $dispatchId)->fetch();
    }

    /** !!!
     * doplní přípravu výrobního číslo do dokladu - převod ze Schenkeru 
     * @param type $serialNumber
     * @param type $mnozstviPriprava
     * @return type
     */
    private function updateDispatchItemPrepareInternal($barCode, $dispatchId) {
        $res = -9;
            // spustit akci na přidání položky do výdejky
            $itemId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_priprav_paletu @SSCC = ?, @IDDoklad = ? ", $barCode, $dispatchId);

            if ($res) {
                $res = $itemId;
            }
            return $res;
    }

    /**
     * uzavření výdejky - převod do Schenkeru
     * @param type $dispatchId
     * @return boolean
     */
    private function closeDispatchInternal($dispatchId) {

        return $this->db->query("EXEC dbo.hpx_agrafa_sklad_uzavrit_vydej @ID = ?", $dispatchId);
    }

    /**
     * uzavření výdejky - mimo převod do Schenkeru
     * @param type $dispatchId
     * @return boolean
     */
    private function closeDispatchPrepareInternal($dispatchId) {

        return $this->db->query("EXEC dbo.hpx_agrafa_sklad_uzavrit_vydej_priprava @ID = ?", $dispatchId);
    }

    /**
     * 
     * @param type $itemId
     */
    private function removeDispatchItemInternal($itemId) {
            $res = $this->db->query("UPDATE TabPohybyZbozi "
                    . "SET Mnozstvi = 0 "
                    . "WHERE ID = ?", $itemId);
            if ($res) {
                $res = $this->db->query("DELETE FROM TabVyrCP WHERE IDPolozkaDokladu = ?", $itemId);
                // aktualizace TabPohybyZbozi.Mnozstvi
            }
            return $res;
    }

    /**
     * odebrání palety z dokladu - převod do Schenkeru
     * @param type $itemSNId
     */
    private function removeDispatchItemSNInternal($itemSNId) {
            $res = true;
            $itemSNRow = $this->db->query("SELECT "
                            . "IDPolozkaDokladu AS ItemId, "
                            . "Mnozstvi AS MnozstviSN "
                            . "FROM TabVyrCP "
                            . "WHERE ID = ?", $itemSNId)->fetch();

            if ($itemSNRow) {
                $res = $this->db->query("UPDATE TabPohybyZbozi "
                        . "SET Mnozstvi = Mnozstvi - ? "
                        . "WHERE ID = ?", $itemSNRow->MnozstviSN, $itemSNRow->ItemId);

                if ($res) {
                    $res = $this->db->query("DELETE FROM TabVyrCP WHERE ID = ?", $itemSNId);
                    if ($res) {
                        $mnozstvi = $this->db->query("SELECT Mnozstvi FROM TabPohybyZbozi WHERE ID = ?", $itemSNRow->ItemId)->fetchField();
                        if ($mnozstvi == 0) {
                            $res = $this->db->query("DELETE FROM TabPohybyZboziSD WHERE ID = ?", $itemSNRow->ItemId);
                            $res = $this->db->query("DELETE FROM TabPohybyZbozi WHERE ID = ?", $itemSNRow->ItemId);
                        }
                    }
                }

            } else {
                $res = false;
            }
            return $res;
    }

    /**
     * odebrání palety z dokladu - převod ze Schenkeru
     * @param type $itemSNId
     */
    private function removeDispatchItemSNPrepareInternal($itemSNId) {
            $res = $this->db->query("UPDATE TabVyrCP_EXT "
                        . "SET _exp_mnoz_potvrz = NULL "
                        . "WHERE ID = ?", $itemSNId);
            return $res;
    }

    /** !!!
     * kontrola zadaného výrobního čísla převod do prodejny
     * @param type $serialNumber
     * @return type
     */
    public function checkSerialNumberToShop($serialNumber, $idSklad) {
        return $this->db->query("SELECT "
                        . "vc.ID AS IDVyrCis, "
                        . "vc.Nazev1 AS BarCode, "
                        . "CONVERT(INT, vc.Mnozstvi) AS Mnozstvi, "
                        . "CONVERT(INT, vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji) AS MnozstviPoPrijmuAVydeji, "
                        . "vc.IDStavSkladu AS IDZboSklad "
                        . "FROM TabVyrCS vc WITH (UPDLOCK, HOLDLOCK) "
                        . "JOIN TabStavSkladu skl ON skl.ID = vc.IDStavSkladu "
                        . "WHERE vc.Nazev1 = ? AND skl.IDSklad = ?", $serialNumber, $idSklad)->fetch();
    }

    /** !!!
     * převod palety do prodejny
     * @param type $serialNumber
     * @return type
     */
    private function moveSerialNumberToShopInternal($barCode) {
        $res = -9;
            // spustit akci na přidání položky do výdejky
            $dispatchId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_prevod_do_prod @SSCC = ?", $barCode);

            if ($res) {
                $res = $dispatchId;
            }
            return $res;
    }

    public function removeDispatchItem($itemId, $documentId)
    {
        return $this->warehouseOperation(function () use ($itemId, $documentId) {
            $this->assertDocument($documentId, $itemId);
            $result = $this->removeDispatchItemInternal($itemId);

            return $result;
        });
    }

    public function removeDispatchItemSN($itemSNId, $documentId, $itemId)
    {
        return $this->warehouseOperation(function () use ($itemSNId, $documentId, $itemId) {
            $this->assertDocument($documentId, $itemId, $itemSNId);
            $result = $this->removeDispatchItemSNInternal($itemSNId);

            return $result;
        });
    }

    public function removeDispatchItemSNPrepare($itemSNId, $documentId, $itemId)
    {
        return $this->warehouseOperation(function () use ($itemSNId, $documentId, $itemId) {
            $this->assertDocument($documentId, $itemId, $itemSNId);
            $result = $this->removeDispatchItemSNPrepareInternal($itemSNId);

            return $result;
        });
    }

    public function removeDispatchItemPrepare($itemId, $documentId)
    {
        return $this->warehouseOperation(function () use ($itemId, $documentId) {
            $this->assertDocument($documentId, $itemId);
            $this->db->query('UPDATE e SET _exp_mnoz_potvrz = NULL FROM TabVyrCP_EXT e
                JOIN TabVyrCP vc ON vc.ID = e.ID WHERE vc.IDPolozkaDokladu = ?', $itemId);
            return true;
        });
    }

    public function closeDispatch($dispatchId)
    {
        return $this->warehouseOperation(function () use ($dispatchId) {
            $this->assertDocument($dispatchId);
            $result = $this->closeDispatchInternal($dispatchId);
            $row = $this->getDispatch($dispatchId);
            if (!$row || !(int) $row->StavDispExp) { throw new \RuntimeException('Výdejku se nepodařilo uzavřít.'); }
            return $result;
        });
    }

    public function closeDispatchPrepare($dispatchId)
    {
        return $this->warehouseOperation(function () use ($dispatchId) {
            $this->assertDocument($dispatchId);
            $result = $this->closeDispatchPrepareInternal($dispatchId);
            $row = $this->getDispatch($dispatchId);
            if (!$row || !(int) $row->StavDispExp) { throw new \RuntimeException('Výdejku se nepodařilo uzavřít.'); }
            return $result;
        });
    }

    public function updateDispatchItemOther($barCode, $dispatchId)
    {
        return $this->warehouseOperation(function () use ($barCode, $dispatchId) {
            $this->assertDocument($dispatchId);
            $row = $this->checkSerialNumberOther($dispatchId, $barCode);
            if (!$row || $row->Mnozstvi <= 0 || $row->MnozstviPoPrijmuAVydeji <= 0 || $this->db->query('SELECT vc.ID FROM TabVyrCP vc JOIN TabPohybyZbozi p ON p.ID = vc.IDPolozkaDokladu WHERE p.IDDoklad = ? AND vc.IDVyrCis = ?', $dispatchId, $row->IDVyrCis)->fetch()) { throw new \RuntimeException('Paletu nelze přidat nebo je již potvrzená.'); }
            $result = $this->updateDispatchItemOtherInternal($barCode, $dispatchId);
            if (!$this->db->query('SELECT vc.ID FROM TabVyrCP vc JOIN TabPohybyZbozi p ON p.ID = vc.IDPolozkaDokladu WHERE p.IDDoklad = ? AND vc.IDVyrCis = ?', $dispatchId, $row->IDVyrCis)->fetch()) {
                throw new \RuntimeException('Paletu se nepodařilo přidat do dokladu.');
            }

            return $result;
        });
    }

    public function updateDispatchItemPrepare($barCode, $dispatchId)
    {
        return $this->warehouseOperation(function () use ($barCode, $dispatchId) {
            $this->assertDocument($dispatchId);
            $row = $this->checkSerialNumberPrepare($dispatchId, $barCode);
            if (!$row || $row->MnozstviPotvrz > 0) { throw new \RuntimeException('Paletu nelze přidat nebo je již potvrzená.'); }
            $result = $this->updateDispatchItemPrepareInternal($barCode, $dispatchId);
            $updated = $this->checkSerialNumberPrepare($dispatchId, $barCode);
            if (!$updated || $updated->MnozstviPotvrz <= 0) { throw new \RuntimeException('Paletu se nepodařilo potvrdit.'); }

            return $result;
        });
    }

    public function moveSerialNumberToShop($barCode)
    {
        return $this->warehouseOperation(function () use ($barCode) {
            $row = $this->checkSerialNumberToShop($barCode, '00100304');
            if (!$row || $row->Mnozstvi <= 0 || $row->MnozstviPoPrijmuAVydeji <= 0) {
                throw new \RuntimeException('Paleta již není na skladu.');
            }
            $result = $this->moveSerialNumberToShopInternal($barCode);
            $updated = $this->checkSerialNumberToShop($barCode, '00100304');
            if ($updated && $updated->MnozstviPoPrijmuAVydeji >= $row->MnozstviPoPrijmuAVydeji) {
                throw new \RuntimeException('Převod palety nebyl potvrzen změnou skladového množství.');
            }

            return $result;
        });
    }

    public function openNewDispatch($dispatchType)
    {
        return $this->warehouseOperation(function () use ($dispatchType) {
            if ($this->checkDispatchOpen($dispatchType)) { throw new \RuntimeException('Otevřená výdejka již existuje. Vraťte se a otevřete ji.'); }
            $result = $this->openNewDispatchInternal($dispatchType);
            if (empty($result['IDDoklad'])) { throw new \RuntimeException('Výdejku se nepodařilo založit.'); }

            $settings = self::getTransferSettings($dispatchType);
            $document = $this->getDispatch($result['IDDoklad']);
            if (!$document || (int) $document->DruhPohybuZbo !== 4
                || (string) $document->IDSklad !== $settings['source']
                || (string) $document->RadaDokladu !== $settings['series']
                || (string) $document->IdSkladPrevodu !== $settings['target']
                || (string) $document->TypPrevodky !== $settings['receiptSeries']
                || (int) $document->DruhPohybuPrevod !== 0) {
                throw new \RuntimeException('Založený doklad neodpovídá převodu. Ověřte nasazení SQL procedury v Heliosu.');
            }

            return $result;
        });
    }
}
