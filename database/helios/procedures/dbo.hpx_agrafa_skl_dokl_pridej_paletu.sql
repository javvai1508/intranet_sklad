-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_dokl_pridej_paletu]
@SSCC NVARCHAR(50),
@IDDoklad INT

AS

DECLARE @IDVyrCS INT
DECLARE @IDVyrCK INT
DECLARE @IDZboSklad INT
DECLARE @IDPohyb INT
DECLARE @IDSklad NVARCHAR(30)
DECLARE @DrPoh INT
DECLARE @VstCena INT
DECLARE @CisloOrg INT
DECLARE @Mena NVARCHAR(3)
DECLARE @Kurz NUMERIC(19, 8)
DECLARE @SazbaDPH NUMERIC(19, 6)
DECLARE @Mnozstvi NUMERIC(19, 6)
DECLARE @JCbezDPH NUMERIC(19, 6)

-- INSERT INTO #TabExtKom (Poznamka) VALUES (@SSCC)

SELECT
  @IDSklad = do.IDSklad,
  @DrPoh = do.DruhPohybuZbo,
  @VstCena = do.VstupniCena,
  @CisloOrg = do.CisloOrg,
  @Mena = do.Mena,
  @Kurz = do.Kurz
FROM TabDokladyZbozi do 
WHERE do.ID = @IDDoklad

SELECT
  @IDZboSklad = skl.ID,
  @IDVyrCS = vcs.ID,
  @Mnozstvi = vcs.Mnozstvi + vcs.MnozstviKPrijmu - vcs.MnozstviKVydeji,
  @IDVyrCK = vcs.IDVyrCK,
  @IDPohyb = po.ID
FROM TabVyrCS vcs
JOIN TabStavSkladu skl ON skl.ID = vcs.IDStavSkladu
LEFT JOIN TabPohybyZbozi po ON po.IDZboSklad = skl.ID AND po.IDDoklad = @IDDoklad
WHERE vcs.Nazev1 = @SSCC AND skl.IDSklad = @IDSklad 

-- INSERT INTO #TabExtKom (Poznamka) VALUES (@SSCC + ' - ' + CONVERT(NVARCHAR(20), @IDZboSklad))

IF @IDVyrCS IS NOT NULL AND ISNULL(@Mnozstvi, 0) > 0
BEGIN
  IF @IDPohyb IS NULL
  BEGIN
    EXEC dbo.hpx_agrafa_insert_polozky_oz
      @IDent = @IDPohyb OUTPUT,
      @IDDoklad = @IDDoklad,
      @DruhPohybu = @DrPoh,
      @CisloOrg = @CisloOrg,
      @IDZboSklad = @IDZboSklad,
      @Mena = @Mena,
      @Kurz = @Kurz,
      @JednotkaMeny = 1,
      @KurzEuro = 0,
      @SazbaSD = 0,
      @SazbaDPH = @SazbaDPH,
      @ZakazanoDPH = 0,
      @VstupniCena = @VstCena,
      @PovolitDuplicitu = 1,
      @Mnozstvi = 0,
      @JCbezDaniKC = @JCbezDPH,
      @VstupniCenaProPrepocet = NULL,
      @DotahovatSazby = 1
  
  END

  IF @IDPohyb IS NOT NULL 
  BEGIN
    INSERT INTO TabVyrCP (IDPolozkaDokladu, IDVyrCis, Nazev, Mnozstvi)
    VALUES (@IDPohyb, @IDVyrCS, @SSCC, @Mnozstvi)

    UPDATE TabPohybyZbozi SET Mnozstvi = Mnozstvi + @Mnozstvi WHERE ID = @IDPohyb

  END

END
GO
