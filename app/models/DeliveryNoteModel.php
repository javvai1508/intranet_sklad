<?php

namespace App\Models;

class DeliveryNoteModel extends BaseModel {

    /**
     * kontrola vybraného DL, vrací ID
     * @param type $deliveryNoteNr
     * @return int
     */
    public function checkDeliveryNote($deliveryNoteNr) {

        $deliveryNote = $this->db->query("SELECT "
                        . "do.ID AS ID, "
                        . "do.ParovaciZnak AS ParovaciZnak, "
                        . "CONVERT(NVARCHAR(20), do.DatPovinnostiFa, 104) AS DatVystaveni, "
                        . "CONVERT(NVARCHAR(20), do.Splatnost, 104) AS DatDodavky "
                        . "FROM TabDokladyZbozi do "
                        . "WHERE do.ParovaciZnak = ? AND do.DruhPohybuZbo = 2", $deliveryNoteNr)->fetch();

        // kontrola existence DL (pozor na prázdné pole)
        if ($deliveryNote) {
            $deliveryNoteId = $deliveryNote->ID;
        } else {
            $deliveryNoteId = false;
        }

        return $deliveryNoteId;
    }

    /**
     * vybraný DL
     * @param type $deliveryNoteId
     * @return type
     */
    public function getDeliveryNote($deliveryNoteId) {
        return $this->db->query("SELECT 
                                    do.ID AS ID, 
                                    do.ParovaciZnak AS ParovaciZnak, 
                                    CONVERT(NVARCHAR(20), do.DatPovinnostiFa, 104) AS DatVystaveni, 
                                    CONVERT(NVARCHAR(20), ISNULL(do.Splatnost, do.DatPorizeni), 104) AS DatDodavky, 
                                    co.CisloOrg AS CisloOrg, 
                                    mu.CisloOrg AS CisloMU, 
                                    COALESCE(mu.CisloOrg, co.CisloOrg) AS CisloOdb,
                                    CONCAT(co.Firma, ', ', co.Misto) AS Organizace, 
                                    CONCAT(mu.Firma, ', ', mu.Misto) AS MistoUrceni,
                                    COALESCE(CONCAT(mu.Firma, ', ', mu.Misto), CONCAT(co.Firma, ', ', co.Misto)) AS Odberatel,
                                    CONVERT(NVARCHAR(20), doe._exp_dat_uzavreno, 104) AS DatUzavrenoExp, 
                                    -- 0 AS StavDLExp, 
                                    CASE WHEN do.DatRealizace IS NOT NULL THEN 1 WHEN do.StavPrevodu IN (1, 2, 3, 4, 5) THEN 1 WHEN EXISTS(SELECT IDDok FROM TabDokumVazba WHERE IdentVazby = 9 AND IDTab = do.ID) THEN 1 WHEN doe._exp_dat_uzavreno IS NOT NULL THEN 1 ELSE 0 END AS StavDLExp,
                                    posumy.PocetPozad AS PocetPozad, 
                                    CONVERT(INT, ISNULL(posumy.MnozstviPozad, 0)) AS MnozstviPozad, 
                                    vcsumy.PocetVC AS PocetVC, 
                                    CONVERT(INT, ISNULL(vcsumy.MnozstviVC, 0)) AS MnozstviVC 
                                FROM TabDokladyZbozi do 
                                LEFT JOIN TabDokladyZbozi_EXT doe ON do.ID = doe.ID 
                                LEFT JOIN TabCisOrg co ON do.CisloOrg = co.CisloOrg 
                                LEFT JOIN TabCisOrg mu ON do.MistoUrceni = mu.CisloOrg 
                                LEFT JOIN (SELECT 
                                                po.IDDoklad, 
                                                COUNT(po.ID) AS PocetPozad, 
                                                SUM(ISNULL(po.Mnozstvi, 0)) AS MnozstviPozad
                                            FROM TabPohybyZbozi po 
                                            GROUP BY po.IDDoklad) posumy ON do.ID = posumy.IDDoklad 
                                LEFT JOIN (SELECT 
                                                po.IDDoklad, 
                                                COUNT(vcp.ID) AS PocetVC, 
                                                SUM(vcp.Mnozstvi) AS MnozstviVC 
                                            FROM TabPohybyZbozi po 
                                            LEFT JOIN TabVyrCP vcp ON po.ID = vcp.IDPolozkaDokladu 
                                            GROUP BY po.IDDoklad) vcsumy ON do.ID = vcsumy.IDDoklad 
                                WHERE do.ID = ?", $deliveryNoteId)->fetch();
    }

    /**
     * výběr položek DL
     * @param type $deliveryNoteId
     * @return type
     */
    public function getDeliveryNoteItems($deliveryNoteId) {
        return $this->db->query("SELECT "
                        . "po.ID AS ID, "
                        . "po.RegCis AS RegCis, "
                        . "po.Nazev1 AS Nazev, "
                        . "ISNULL(CONVERT(INT, po.Mnozstvi), 0) AS Mnozstvi, "
                        . "ISNULL(CONVERT(INT, sumy.MnozstviVC), 0) AS MnozstviVC, "
                        . "ISNULL(CONVERT(INT, sumy.PocetVC), 0) AS PocetVC "
                        . "FROM TabPohybyZbozi po "
                        . "LEFT JOIN TabStavSkladu skl ON po.IDZboSklad = skl.ID "
                        . "LEFT JOIN TabKmenZbozi km ON skl.IDKmenZbozi = km.ID "
                        . "LEFT JOIN TabKmenZbozi_EXT kme ON kme.ID = km.ID "
                        . "LEFT JOIN (SELECT "
                        . "vcp.IDPolozkaDokladu AS ID, "
                        . "COUNT(vcp.ID) AS PocetVC, "
                        . "SUM(vcp.Mnozstvi) AS MnozstviVC "
                        . "FROM TabVyrCP vcp "
                        . "GROUP BY vcp.IDpolozkaDokladu) sumy ON po.ID = sumy.ID "
                        . "WHERE po.IDDoklad = ? "
                        . "ORDER BY po.Poradi", $deliveryNoteId)->fetchAll();
    }

    /**
     * kontrola zadaného výrobního čísla
     * @param type $deliveryNoteId
     * @param type $serialNumber
     * @return type
     */
    public function checkSerialNumber($deliveryNoteId, $serialNumber) {
        return $this->db->query("SELECT "
                        . "vc.ID AS IDVyrCis, "
                        . "vc.IDStavSkladu AS IDSZboSklad, "
                        . "vc.Nazev1 AS BarCode, "
                        . "podl.ID AS IDPohyb, "
                        . "vcp.ID AS IDVCP, "
                        . "CONVERT(INT, vc.Mnozstvi / podl.PrepMnozstvi) AS Mnozstvi, "
                        . "CONVERT(INT, (vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji)  / podl.PrepMnozstvi) AS MnozstviPoPrijmuAVydeji, "
                        . "podl.Mnozstvi AS MnozstviPozadavek, "
                        . "ISNULL(sumy.MnozstviVC, 0) AS MnozstviPriprava "
                        . "FROM TabVyrCS vc WITH (UPDLOCK, HOLDLOCK) "
                        . "LEFT JOIN TabPohybyZbozi podl ON vc.IDStavSkladu = podl.IDZboSklad AND podl.IDDoklad = ? "
                        . "LEFT JOIN TabVyrCP vcp ON vcp.IDVyrCis = vc.ID AND podl.ID = vcp.IDPolozkaDokladu "
                        . "LEFT JOIN (SELECT "
                        . "vcp.IDPolozkaDokladu AS ID, "
                        . "COUNT(vcp.ID) AS PocetVC, "
                        . "SUM(vcp.Mnozstvi) AS MnozstviVC "
                        . "FROM TabVyrCP vcp "
                        . "GROUP BY vcp.IDpolozkaDokladu) sumy ON podl.ID = sumy.ID "
                        . "WHERE vc.Nazev1 = ?", $deliveryNoteId, $serialNumber)->fetch();
    }

    private function updateDeliveryNoteItemQuantity($itemId) {
        // aktualizace TabPohybyZbozi.Mnozstvi
        $this->db->query("UPDATE TabPohybyZbozi "
                . "SET Mnozstvi = ISNULL(poe._exp_mnozstvi_vc, 0) "
                . "FROM TabPohybyZbozi_EXT poe "
                . "WHERE TabPohybyZbozi.ID = poe.ID AND TabPohybyZbozi.ID = ? AND SUBSTRING(TabPohybyZbozi.SkupZbo, 1, 1) = '5'", $itemId);

        $deliveryNoteId = $this->db->query("SELECT IDDoklad FROM TabPohybyZbozi WHERE ID = ?", $itemId)->fetch()->IDDoklad;
        $this->db->query("EXEC dbo.hp_VypCenOZPolozek_IDDokladu @IDDoklad = ?, @AktualizaceSlev = 0", $deliveryNoteId);
        $this->db->query("EXEC dbo.hpx_agrafa_exp_aktualizuj_odebrane_mnozstvi_dl_ep @ID = ?", $deliveryNoteId);
    }

    /**
     * doplní výrobní číslo do dokladu - při expedici ze skladu
     * @param type $itemId
     * @param type $vyrCisloId
     * @param type $mnozstviPriprava
     * @return type
     */
    private function updateDeliveryNoteItemFromStockInternal($deliveryNoteId, $pohybId, $vyrCisloId, $serialNumber, $mnozstviPriprava) {
        $res = -1;
            $itemRow = $this->db->query("SELECT "
                            . "po.ID AS ItemId,"
                            . "CONVERT(INT, po.Mnozstvi) AS MnozstviPozadavek, "
                            . "vcp.ID AS IDVyrCP "
                            . "FROM TabPohybyZbozi po "
                            . "LEFT JOIN TabVyrCP vcp ON po.ID = vcp.IDPolozkaDokladu "
                            . "WHERE po.ID = ? AND vcp.IDVyrCis = ? "
                            . "ORDER BY po.Poradi", $pohybId, $vyrCisloId)->fetch();

            if ($itemRow) {

                $itemId = $itemRow["ItemId"];
                $this->db->query("UPDATE TabVyrCP "
                        . "SET Mnozstvi = Mnozstvi + ? "
                        . "WHERE ID = ?", $mnozstviPriprava, $itemRow["IDVyrCP"]);

                // aktualizace TabPohybyZbozi.Mnozstvi

            } else {
                    $this->db->query("INSERT INTO TabVyrCP (IDPolozkaDokladu, IDVyrCis, Nazev, Mnozstvi) "
                    . "VALUES (?, ?, ?, ?)", $pohybId, $vyrCisloId, $serialNumber, $mnozstviPriprava);
            
            }
            if ($res) {
                $res = 1;
            }
            return $res;
    }

    private function removeDeliveryNoteItemInternal($itemId)
    {
        $this->db->query('UPDATE TabPohybyZbozi_EXT SET _exp_mnozstvi_vc = 0 WHERE ID = ?', $itemId);
        $this->db->query('DELETE FROM TabVyrCP WHERE IDPolozkaDokladu = ?
            AND NOT EXISTS(SELECT ID FROM TabVyrCP_EXT WHERE ID = TabVyrCP.ID
                AND ISNULL(_exp_mnozstvi_vc_pozad, 0) > 0)', $itemId);
        $this->db->query('UPDATE TabVyrCP SET Mnozstvi = 0 WHERE IDPolozkaDokladu = ?
            AND EXISTS(SELECT ID FROM TabVyrCP_EXT WHERE ID = TabVyrCP.ID
                AND ISNULL(_exp_mnozstvi_vc_pozad, 0) > 0)', $itemId);
        $this->updateDeliveryNoteItemQuantity($itemId);
        return true;
    }

    /**
     * výběr položky DL
     * @param type $itemId
     * @return type
     */
    public function getDeliveryNoteItem($itemId) {
        return $this->db->query("SELECT "
                        . "po.ID AS ID, "
                        . "CASE WHEN ISNULL(po.Popis4, '') = '' THEN po.Nazev1 ELSE po.POpis4 END AS Vykres, "
                        . "CASE WHEN SUBSTRING(km.SkupZbo, 1, 2) = '51' THEN ISNULL(CONVERT(NVARCHAR(20), kme._SPrumerJadra), '-') + '/U' + ISNULL(CONVERT(NVARCHAR(20), kme._STiskovyObvod), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._SPracovniDelkaSleeve), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._SCelkovaDelkaSleeve), '-') WHEN SUBSTRING(km.SkupZbo, 1, 2) = '55' THEN ISNULL(CONVERT(NVARCHAR(20), kme._VPrumerJadra), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._VPrumerPogumu), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._VDelkaPogumu), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._VPracDelka), '-') + '/' + ISNULL(CONVERT(NVARCHAR(20), kme._VDelkaValce), '-') ELSE '' END AS Rozmery, "
                        . "CONCAT(CONVERT(NVARCHAR(10), kme._VPrumerJadra), '/', CONVERT(NVARCHAR(10), kme._VPrumerPogumu), '/', CONVERT(NVARCHAR(10), kme._VPracDelka), '/', CONVERT(NVARCHAR(10), kme._VDelkaValce)) AS VRozmery, "
                        . "CONVERT(INT, poe._exp_mnozstvi_pozad_puvodni) AS Mnozstvi, "
                        . "ISNULL(CONVERT(INT, poe._exp_mnozstvi_vc), 0) AS MnozstviVC,"
                        . "dox.RadaDokladu + CONVERT(NVARCHAR(6), dox.PoradoveCislo) + '/' +CONVERT(NVARCHAR(10), pox.Poradi) AS Zakazka "
                        . "FROM TabPohybyZbozi po "
                        . "LEFT JOIN TabPohybyZbozi_EXT poe ON po.ID = poe.ID "
                        . "LEFT JOIN TabStavSkladu skl ON po.IDZboSklad = skl.ID "
                        . "LEFT JOIN TabKmenZbozi km ON skl.IDKmenZbozi = km.ID "
                        . "LEFT JOIN TabKmenZbozi_EXT kme ON kme.ID = km.ID "
                        . "LEFT JOIN TabPohybyZbozi pox ON po.IDOldPolozka = pox.ID "
                        . "LEFT JOIN TabDokladyZbozi dox ON pox.IDDoklad = dox.ID "
                        . "WHERE po.ID = ?", $itemId)->fetch();
    }

    /**
     * výběr výrobních čísel k položce DL
     * @param type $itemId
     * @return type
     */
    public function getDeliveryNoteItemSN($itemId) {
        return $this->db->query("SELECT "
                        . "cp.ID AS IDVyrCP, "
                        . "vc.ID AS IDVyrCS, "
                        . "vc.Nazev1 AS Nazev, "
                        . "CONVERT(INT, ISNULL(vc.Mnozstvi, 0)) AS Mnozstvi, "
                        . "CONVERT(INT, ISNULL(vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji, 0)) AS MnozstviPoPrijmuAVydeji, "
                        . "vc.IDStavSkladu AS IDSZboSklad, "
                        . "CONVERT(INT, ISNULL(cp.Mnozstvi, 0)) AS MnozstviCP "
                        . "FROM TabVyrCP cp "
                        . "LEFT JOIN TabVyrCS vc ON cp.IDVyrCis = vc.ID "
                        . "WHERE cp.IDPolozkaDokladu = ?", $itemId)->fetchAll();
    }

    private function removeDeliveryNoteItemSNInternal($itemSNId)
    {
        $item = $this->db->query('SELECT IDPolozkaDokladu AS ItemId, Mnozstvi AS MnozstviSN
            FROM TabVyrCP WHERE ID = ?', $itemSNId)->fetch();
        if (!$item) {
            return false;
        }
        $this->db->query('UPDATE TabPohybyZbozi_EXT
            SET _exp_mnozstvi_vc = ISNULL(_exp_mnozstvi_vc, 0) - ? WHERE ID = ?', $item->MnozstviSN, $item->ItemId);
        $this->db->query('DELETE FROM TabVyrCP WHERE ID = ?
            AND NOT EXISTS(SELECT ID FROM TabVyrCP_EXT WHERE ID = TabVyrCP.ID
                AND ISNULL(_exp_mnozstvi_vc_pozad, 0) > 0)', $itemSNId);
        $this->db->query('UPDATE TabVyrCP SET Mnozstvi = 0 WHERE ID = ?
            AND EXISTS(SELECT ID FROM TabVyrCP_EXT WHERE ID = TabVyrCP.ID
                AND ISNULL(_exp_mnozstvi_vc_pozad, 0) > 0)', $itemSNId);
        $this->updateDeliveryNoteItemQuantity($item->ItemId);
        return true;
    }

    /**
     * uzavření dodacího listu
     * @param type $deliveryNoteId
     * @return boolean
     */
    private function closeDeliveryNoteInternal($deliveryNoteId) {
        $this->db->query("EXEC dbo.hpx_agrafa_sklad_uzavrit_vydej_priprava @ID = ?", $deliveryNoteId);
        return true;
    }

    public function removeDeliveryNoteItem($itemId, $documentId)
    {
        return $this->warehouseOperation(function () use ($itemId, $documentId) {
            $this->assertDocument($documentId, $itemId);
            $result = $this->removeDeliveryNoteItemInternal($itemId);

            return $result;
        });
    }

    public function removeDeliveryNoteItemSN($itemSNId, $documentId, $itemId)
    {
        return $this->warehouseOperation(function () use ($itemSNId, $documentId, $itemId) {
            $this->assertDocument($documentId, $itemId, $itemSNId);
            $result = $this->removeDeliveryNoteItemSNInternal($itemSNId);

            return $result;
        });
    }

    public function updateDeliveryNoteItemFromStock($deliveryNoteId, $pohybId, $vyrCisloId, $serialNumber, $mnozstviPriprava)
    {
        return $this->warehouseOperation(function () use ($deliveryNoteId, $pohybId, $vyrCisloId, $serialNumber, $mnozstviPriprava) {
            $this->assertDocument($deliveryNoteId, $pohybId);
            $row = $this->checkSerialNumber($deliveryNoteId, $serialNumber);
            if (!$row || !$row->IDPohyb || $row->IDVCP || $row->IDPohyb != $pohybId || $row->IDVyrCis != $vyrCisloId
                || $row->Mnozstvi <= 0 || $row->MnozstviPoPrijmuAVydeji <= 0
                || $row->MnozstviPoPrijmuAVydeji != $mnozstviPriprava
                || $row->MnozstviPozadavek < $row->MnozstviPoPrijmuAVydeji + $row->MnozstviPriprava) {
                throw new \RuntimeException('Paletu nelze přidat. Stav se změnil, načtěte ji znovu.');
            }
            $result = $this->updateDeliveryNoteItemFromStockInternal($deliveryNoteId, $pohybId, $vyrCisloId, $serialNumber, $mnozstviPriprava);

            return $result;
        });
    }

    public function closeDeliveryNote($deliveryNoteId)
    {
        return $this->warehouseOperation(function () use ($deliveryNoteId) {
            $this->assertDocument($deliveryNoteId);
            $result = $this->closeDeliveryNoteInternal($deliveryNoteId);
            $row = $this->getDeliveryNote($deliveryNoteId);
            if (!$row || !(int) $row->StavDLExp) { throw new \RuntimeException('Dodací list se nepodařilo uzavřít.'); }
            return $result;
        });
    }
}
