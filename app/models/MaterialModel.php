<?php

namespace App\Models;

use Nette;

class MaterialModel extends BaseModel {

    /**
     * dohledání a dotažení skladového dokladu podle čísla (ParovaciZnak)
     * @param type $parovaciZnak
     */
    public function getStockDocPZ($parovaciZnak) {
        // převod ze Schenkeru
        $row = $this->db->query("SELECT do.ID, "
                        . "do.RadaDokladu, "
                        . "do.PoradoveCislo, "
                        . "do.CisloOrg, "
                        . "do.DatPorizeni, "
                        . "do.ParovaciZnak, "
                        . "do.DruhPohybuZbo, "
                        . "do.IDSklad, "
                        . "CASE WHEN doe._exp_dat_uzavreno IS NOT NULL THEN 1 ELSE 0 END AS StavDLExp, "
                        . "CASE WHEN do.DruhPohybuZbo = 4 AND do.IDSklad = '00100303' THEN 'fromSchenker' WHEN do.IDSklad = '00100304' AND do.DruhPohybuZbo = 2 THEN 'delivery' WHEN do.DruhPohybuZbo = 4 AND do.IDSklad = '00100304' THEN 'toSchenker' WHEN do.DruhPohybuZbo = 0 /*AND do.IDSklad = '00100304'*/ THEN 'receipt' ELSE 'undefined' END AS DispatchType "
                        . "FROM TabDokladyZbozi do "
                        . "LEFT JOIN TabDokladyZbozi_EXT doe ON do.ID = doe.ID "
                        . "WHERE do.ParovaciZnak = %s AND do.IDSklad IN ('00100303', '00100304')", $parovaciZnak)->fetch();
        return $row;
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
                        . "do.IDSklad, "
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
                        . "WHERE do.ID = %i", $dispatchId)->fetch();
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
                        . "WHERE vy.IDDoklad = %i", $dispatchId)->fetchAll();
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
                        . "/*LEFT JOIN (SELECT po.ID AS IDPohyb, COUNT(vcp.ID) AS cnt "
                        . "FROM TabVyrCP vcp "
                        . "JOIN TabPohybyZbozi po ON po.ID = vcp.IDPolozkaDokladu "
                        . "GROUP BY po.ID) cntvc ON cntvc.IDPohyb = pr.ID */"
                        . "WHERE pr.ID = %i", $itemId)->fetch();
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
                        . "WHERE pr.ID = %i ", $itemId)->fetchAll();
    }

    /** !!!
     * kontrola otevřené výdejky 
     * @return type
     */
    public function checkDispatchOpen($dispatchType) {
        switch ($dispatchType) {
            case 'toSchenker': 
                $idSklad = '00100304';
                break;
            case 'toShop': 
                $idSklad = '00100304';
                break;
            default: 
                $idSklad = '';
        }
        $res = $this->db->query("SELECT "
                        . "do.ID, "
                        . "do.ParovaciZnak, "
                        . "doe._skl_token "
                        . "FROM TabDokladyZbozi do "
                        . "JOIN TabDokladyZbozi_EXT doe ON do.ID = doe.ID "
                        . "WHERE do.DruhPohybuZbo = 4 AND do.RadaDokladu = '372' AND do.IDSklad = %s AND doe._exp_dat_uzavreno IS NULL", $idSklad)->fetchAll();
        return $res;
    }

    /** !!!
     * založení výdejky mimo operace (vlastní spotřeba, zmetek, prodej)
     * @return type
     */
    public function openNewDispatch($dispatchType) {
        $token = uniqid();
        // založit pouze hlavičku
        $this->db->query("SET NOCOUNT ON "
                . "EXEC hpx_agrafa_sklad_zaloz_vydej_ost_hl_tablet @TypVydejky = %s, @Token = %s ", $dispatchType, $token);
        $res["IDDoklad"] = $this->db->query("SELECT ID FROM TabDokladyZbozi_EXT WHERE _skl_token = %s", $token)->fetchSingle();
        return $res;
    }

    /** !!!
     * kontrola zadaného výrobního čísla kromě výdejek na operaci
     * @param type $dispatchId
     * @param type $serialNumber
     * @return type
     */
    public function checkSerialNumberOther($dispatchId, $serialNumber) {
        $idSklad = $this->db->query("SELECT IDSklad FROM TabDokladyZbozi WHERE ID = %i", $dispatchId)->fetchSingle();
        return $this->db->query("SELECT "
                        . "vc.ID AS IDVyrCis, "
                        . "vc.Nazev1 AS BarCode, "
                        . "CONVERT(INT, vc.Mnozstvi) AS Mnozstvi, "
                        . "CONVERT(INT, vc.Mnozstvi + vc.MnozstviKPrijmu - vc.MnozstviKVydeji) AS MnozstviPoPrijmuAVydeji, "
                        . "vc.IDStavSkladu AS IDZboSklad "
                        . "FROM TabVyrCS vc "
                        . "JOIN TabStavSkladu skl ON skl.ID = vc.IDStavSkladu "
                        . "WHERE vc.Nazev1 = %s AND skl.IDSklad = %s", $serialNumber, $idSklad)->fetch();
    }

    /** !!!
     * doplní výrobní číslo do dokladu 
     * @param type $serialNumber
     * @param type $mnozstviPriprava
     * @return type
     */
    public function updateDispatchItemOther($barCode, $dispatchId) {
        // transakce
        $res = -9;
        $this->db->begin();
        try {
            // spustit akci na přidání položky do výdejky
            $itemId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_pridej_paletu @SSCC = %s, @IDDoklad = %i ", $barCode, $dispatchId);

            $this->db->commit();
            if ($res) {
                $res = $itemId;
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
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
                        . "WHERE vc.Nazev1 = %s AND po.IDDoklad = %i", $serialNumber, $dispatchId)->fetch();
    }

    /** !!!
     * doplní přípravu výrobního číslo do dokladu - převod ze Schenkeru 
     * @param type $serialNumber
     * @param type $mnozstviPriprava
     * @return type
     */
    public function updateDispatchItemPrepare($barCode, $dispatchId) {
        // transakce
        $res = -9;
        $this->db->begin();
        try {
            // spustit akci na přidání položky do výdejky
            $itemId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_priprav_paletu @SSCC = %s, @IDDoklad = %i ", $barCode, $dispatchId);

            $this->db->commit();
            if ($res) {
                $res = $itemId;
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
    }

    /**
     * uzavření výdejky - převod do Schenkeru
     * @param type $dispatchId
     * @return boolean
     */
    public function closeDispatch($dispatchId) {

        return $this->db->query("EXEC dbo.hpx_agrafa_sklad_uzavrit_vydej @ID = %i", $dispatchId);
    }

    /**
     * uzavření výdejky - mimo převod do Schenkeru
     * @param type $dispatchId
     * @return boolean
     */
    public function closeDispatchPrepare($dispatchId) {

        return $this->db->query("EXEC dbo.hpx_agrafa_sklad_uzavrit_vydej_priprava @ID = %i", $dispatchId);
    }

    /**
     * 
     * @param type $itemId
     */
    public function removeDispatchItem($itemId) {
        // transakce
        $this->db->begin();
        try {
            $res = $this->db->query("UPDATE TabPohybyZbozi "
                    . "SET Mnozstvi = 0 "
                    . "WHERE ID = %i", $itemId);
            if ($res) {
                $res = $this->db->query("DELETE FROM TabVyrCP WHERE IDPolozkaDokladu = %i", $itemId);
                // aktualizace TabPohybyZbozi.Mnozstvi
            }
            if ($res) {
                $this->db->commit();
            } else {
                $this->db->rollback();
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
    }

    /**
     * odebrání palety z dokladu - převod do Schenkeru
     * @param type $itemSNId
     */
    public function removeDispatchItemSN($itemSNId) {
        // transakce 
        $this->db->begin();
        try {
            $res = true;
            $itemSNRow = $this->db->query("SELECT "
                            . "IDPolozkaDokladu AS ItemId, "
                            . "Mnozstvi AS MnozstviSN "
                            . "FROM TabVyrCP "
                            . "WHERE ID = %i", $itemSNId)->fetch();

            if ($itemSNRow) {
                $res = $this->db->query("UPDATE TabPohybyZbozi "
                        . "SET Mnozstvi = Mnozstvi - %f "
                        . "WHERE ID = %i", $itemSNRow->MnozstviSN, $itemSNRow->ItemId);

                if ($res) {
                    $res = $this->db->query("DELETE FROM TabVyrCP WHERE ID = %i", $itemSNId);
                    if ($res) {
                        $mnozstvi = $this->db->query("SELECT Mnozstvi FROM TabPohybyZbozi WHERE ID = %i", $itemSNRow->ItemId)->fetchSingle();
                        if ($mnozstvi == 0) {
                            $res = $this->db->query("DELETE FROM TabPohybyZboziSD WHERE ID = %i", $itemSNRow->ItemId);
                            $res = $this->db->query("DELETE FROM TabPohybyZbozi WHERE ID = %i", $itemSNRow->ItemId);
                        }
                    }
                }

            } else {
                $res = false;
            }
            if ($res) {
                $this->db->commit();
            } else {
                $this->db->rollback();
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
    }

    /**
     * odebrání palety z dokladu - převod ze Schenkeru
     * @param type $itemSNId
     */
    public function removeDispatchItemSNPrepare($itemSNId) {
        // transakce 
        $this->db->begin();
        try {
            $res = $this->db->query("UPDATE TabVyrCP_EXT "
                        . "SET _exp_mnoz_potvrz = NULL "
                        . "WHERE ID = %i", $itemSNId);
            if ($res) {
                $this->db->commit();
            } else {
                $this->db->rollback();
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
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
                        . "FROM TabVyrCS vc "
                        . "JOIN TabStavSkladu skl ON skl.ID = vc.IDStavSkladu "
                        . "WHERE vc.Nazev1 = %s AND skl.IDSklad = %s", $serialNumber, $idSklad)->fetch();
    }

    /** !!!
     * převod palety do prodejny
     * @param type $serialNumber
     * @return type
     */
    public function moveSerialNumberToShop($barCode) {
        // transakce
        $res = -9;
        $this->db->begin();
        try {
            // spustit akci na přidání položky do výdejky
            $dispatchId = $this->db->query("SET NOCOUNT ON "
            . "EXEC hpx_agrafa_skl_dokl_prevod_do_prod @SSCC = %s ", $barCode);

            $this->db->commit();
            if ($res) {
                $res = $dispatchId;
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }
    }

}
