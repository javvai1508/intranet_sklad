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
                        . "WHERE vcp.VyrCislo = ?", $barCode)->fetch();
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

            // spustit akci na přidání položky do výdejky
            /* 
            * doplnit ošetření výjimek - interní hlášky
            * zkontrolovat rychlost - realizace dokladu (zatím se nerealizuje)
            */
            // $res = $this->db->query("EXEC dbo.hpx_agrafa_vyr_odvedeni_vc_tablet @IDPrijem = NULL, @IDVyrCis = ?, @CisloZam = ?; ", $idVyrCis, $cisloZam)->fetch();

            $res = $this->db->query("SET NOCOUNT ON; "
            . "DECLARE @IDPrijem INT; "
            . "DECLARE @Msg NVARCHAR(2000); "
            . "EXEC dbo.hpx_agrafa_vyr_odvedeni_vc_tablet @IDPrijem = @IDPrijem OUTPUT, @Msg = @Msg OUTPUT, @IDVyrCis = ?, @CisloZam = ?; "
            . "SELECT @IDPrijem AS IDPrijem, @Msg AS Msg", $idVyrCis, $cisloZam)->fetch();

            return $res;

    }

}
