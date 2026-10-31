<?php

namespace App\Models;

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
                        . "ISNULL(vcp.Odvedeno, 0) AS Odvedeno "
                        . "FROM TabVyrCisPrikaz vcp WITH (UPDLOCK, HOLDLOCK) "
                        . "WHERE vcp.VyrCislo = ?", $barCode)->fetch();
    }

    /**
     * odvedení výroby
     * @param type $idVyrCis
     * @param type $mnozstvi
     * @param type $cisloZam
     * @return type
     */
    private function closeProductionInternal($idVyrCis, $cisloZam) {

            // spustit akci na přidání položky do výdejky

            $res = $this->db->query("SET NOCOUNT ON; "
            . "DECLARE @IDPrijem INT; "
            . "DECLARE @Msg NVARCHAR(2000); "
            . "EXEC dbo.hpx_agrafa_vyr_odvedeni_vc_tablet @IDPrijem = @IDPrijem OUTPUT, @Msg = @Msg OUTPUT, @IDVyrCis = ?, @CisloZam = ?; "
            . "SELECT @IDPrijem AS IDPrijem, @Msg AS Msg", $idVyrCis, $cisloZam)->fetch();

            return $res;

    }

    public function closeProduction($idVyrCis, $cisloZam)
    {
        return $this->warehouseOperation(function () use ($idVyrCis, $cisloZam) {
            $row = $this->db->query('SELECT VyrCislo FROM TabVyrCisPrikaz WHERE ID = ?', $idVyrCis)->fetch();
            $state = $row ? $this->checkProductionSN($row->VyrCislo) : null;
            if (!$state || $state->IDVyrCis != $idVyrCis || $state->Odvedeno + $state->OdvedenoNereal >= $state->Zadane) {
                throw new \RuntimeException('Paleta neexistuje nebo již byla odvedena.');
            }
            $this->audit?->enrich(['IDVyrCisPrikaz' => $idVyrCis, 'IDPrikaz' => $state->IDPrikaz, 'SSCC' => $row->VyrCislo]);
            $result = $this->closeProductionInternal($idVyrCis, $cisloZam);
            if (!$result || !$result->IDPrijem) { throw new \RuntimeException($result->Msg ?? 'Výrobu se nepodařilo odvést.'); }
            $this->audit?->enrich(['IDDoklad' => $result->IDPrijem]);
            return $result;
        });
    }
}
