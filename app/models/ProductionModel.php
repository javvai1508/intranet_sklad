<?php

namespace App\Models;

use Nette;

class ProductionModel extends BaseModel {

    /**
     * kontrola VČ ve výrobních příkazech
     * @param type $values
     * @return type
     */
    public function checkProductionSN($barCode) {
        return $this->db->query("SELECT "
                        . "vcp.ID AS IDVyrCis, "
                        . "vcp.IDPrikaz AS IDPrikaz,"
                        . "vcp.Mnozstvi AS Zadane, "
                        . "CONVERT(NUMERIC(19,6), (SELECT ISNULL(SUM(CP.Mnozstvi * PZ.PrepMnozstvi),0.0) FROM TabPohybyZbozi PZ INNER JOIN TabVyrCP CP ON (CP.IDPolozkaDokladu = PZ.ID) INNER JOIN TabVyrCS CS ON (CS.ID = CP.IDVyrCis AND CS.Nazev1 = vcp.VyrCislo) WHERE PZ.TypVyrobnihoDokladu=0 AND PZ.IDPrikaz = vcp.IDPrikaz AND PZ.DruhPohybuZbo=0 AND PZ.SkutecneDatReal IS NULL)) AS OdvedenoNereal, "
                        . "vcp.Odvedeno AS Odvedeno "
                        . "FROM TabVyrCisPrikaz vcp "
                        . "WHERE vcp.VyrCislo = %s", $barCode)->fetch();
    }

    /**
     * odvedení výroby
     * @param type $idVyrCis
     * @param type $mnozstvi
     * @param type $cisloZam
     * @return type
     */
    public function closeProduction($idVyrCis, $cisloZam) {
        // transakce

        $res = -9;
        $this->db->begin();
        try {
            // spustit akci na přidání položky do výdejky
            $prijemId = $this->db->query("SET NOCOUNT ON "
            . "DECLARE @IDPrijem INT "
            . "EXEC dbo.hpx_agrafa_vyr_odvedeni_vc_tablet @IDPrijem = @IDPrijem OUTPUT, @IDVyrCis = %i, @CisloZam = %i "
            . "SELECT @IDPrijem ", $idVyrCis, $cisloZam);
            $this->db->commit();
            if ($res) {
                $res = $prijemId;
            }
            return $res;
        } catch (DibiException $e) {
            $this->db->rollback();
            return false;
        }

    }

}
