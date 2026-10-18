-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_dokl_prevod_do_prod]
@SSCC NVARCHAR(50)

AS

DECLARE @IDSkladPrij NVARCHAR(20)
DECLARE @DrPohPrij INT
DECLARE @RadaPrij NVARCHAR(3)
DECLARE @IDPrij INT
DECLARE @IDSkladVyd NVARCHAR(20)
DECLARE @DrPohVyd INT
DECLARE @RadaVyd NVARCHAR(3)
DECLARE @IDVyd INT

DECLARE @VstCena INT
DECLARE @CisloOrg INT
DECLARE @Mena NVARCHAR(3)
DECLARE @Kurz NUMERIC(19, 8)
DECLARE @MJEvidence NVARCHAR(20)

SET @IDSkladPrij = '00100305'
SET @DrPohPrij = 0
SET @RadaPrij = '351'
SET @IDSkladVyd = '00100304'
SET @DrPohVyd = 4
SET @RadaVyd = '372'
SET @VstCena = 0
SET @CisloOrg = 0
SET @Mena = 'CZK'
SET @Kurz = 1

DECLARE @IDKmen INT
DECLARE @IDVyrCK INT
DECLARE @IDVyrCSVyd INT
DECLARE @IDZboSkladVyd INT
DECLARE @IDPohVyd INT
DECLARE @IDPohPrij INT
DECLARE @IDVyrCSPrij INT
DECLARE @IDZboSkladPrij INT
DECLARE @SazbaDPH NUMERIC(19, 6)
DECLARE @Mnozstvi NUMERIC(19, 6)
DECLARE @JCbezDPH NUMERIC(19, 6)
DECLARE @BylaChyba INT

-- INSERT INTO #TabExtKom (Poznamka) VALUES (@SSCC)

SELECT
  @IDKmen = skl.IDKmenZbozi,
  @IDZboSkladVyd = skl.ID,
  @IDVyrCSVyd = vcs.ID,
  @IDVyrCK = vcs.IDVyrCK,
  @Mnozstvi = vcs.Mnozstvi + vcs.MnozstviKPrijmu - vcs.MnozstviKVydeji,
  @MJEvidence = km.MJEvidence
FROM TabVyrCS vcs
JOIN TabStavSkladu skl ON skl.ID = vcs.IDStavSkladu
JOIN TabKMenZbozi km ON km.ID = skl.IDKmenZbozi
WHERE vcs.Nazev1 = @SSCC AND skl.IDSklad = @IDSkladVyd 

-- INSERT INTO #TabExtKom (Poznamka) VALUES (@SSCC + ' - ' + CONVERT(NVARCHAR(20), @IDZboSkladVyd))

IF @IDVyrCSVyd IS NOT NULL AND @IDZboSkladVyd IS NOT NULL AND ISNULL(@Mnozstvi, 0) > 0
BEGIN
  -- vytvořit výdejku a realizovat
  EXEC hp_InsertHlavickyOZ
    @IDent = @IDVyd OUTPUT,
    @Sklad = @IDSkladVyd,
    @DruhPohybu = @DrPohVyd,
    @RadaDokladu = @RadaVyd,
    @CisloOrg = @CisloOrg

  IF @IDVyd IS NOT NULL
  BEGIN
  -- doplnit převodku
    IF @DrPohPrij IS NOT NULL
    BEGIN
      UPDATE TabDokladyZbozi
      SET
        DruhPohybuPrevod = @DrPohPrij,
        TypPrevodky = @RadaPrij,
        IdSkladPrevodu = @IDSkladPrij
      WHERE ID = @IDVyd
    END

    EXEC dbo.hpx_agrafa_insert_polozky_oz
      @IDent = @IDPohVyd OUTPUT,
      @IDDoklad = @IDVyd,
      @DruhPohybu = @DrPohVyd,
      @CisloOrg = @CisloOrg,
      @IDZboSklad = @IDZboSkladVyd,
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
      @MJ = @MJEvidence,
      @JCbezDaniKC = 0,
      @VstupniCenaProPrepocet = NULL,
      @DotahovatSazby = 1
  
    IF @IDPohVyd IS NOT NULL 
    BEGIN
      INSERT INTO TabVyrCP (IDPolozkaDokladu, IDVyrCis, Nazev, Mnozstvi)
      VALUES (@IDPohVyd, @IDVyrCSVyd, @SSCC, @Mnozstvi)

      UPDATE TabPohybyZbozi SET Mnozstvi = Mnozstvi + @Mnozstvi WHERE ID = @IDPohVyd

    END

    IF EXISTS(SELECT ID FROM TabDokladyZbozi_EXT WHERE ID = @IDVyd)
    BEGIN
      UPDATE TabDokladyZbozi_EXT 
      SET 
        _exp_dat_uzavreno = GETDATE(), 
        _exp_dat_ktisku = GETDATE(), 
        _exp_dat_tisku = NULL 
      WHERE ID = @IDVyd
    END 
    ELSE 
    BEGIN
      INSERT INTO TabDokladyZbozi_EXT (ID, _exp_dat_uzavreno, _exp_dat_ktisku, _exp_dat_tisku)
      VALUES (@IDVyd, GETDATE(), GETDATE(), NULL)
    END

    -- realizovat výdejku
    EXEC hp_Realizuj_Vydej @ID = @IDVyd, @DatumRealizace = NULL, @Uzivatel = 0, @Hlidat = 0, @BylaChyba = @BylaChyba OUT 

    SET @JCbezDPH = 0
    SELECT @JCbezDPH = CASE WHEN ISNULL(MnozstviReal, 0) > 0 THEN CCEvid / MnozstviReal ELSE 0 END FROM TabPohybyZbozi WHERE ID = @IDPohVyd
    IF @JCbezDPH = 0
    BEGIN
      SET @JCBezDPH = 1
    END

    -- generovat návazný doklad - nejdříve hlavičku a potom dál
    EXEC hp_InsertHlavickyOZ
      @IDent = @IDPrij OUTPUT,
      @Sklad = @IDSkladPrij,
      @DruhPohybu = @DrPohPrij,
      @RadaDokladu = @RadaPrij,
      @CisloOrg = @CisloOrg

    IF @IDPrij IS NOT NULL    
    BEGIN

      SELECT @IDZboSkladPrij = ID FROM TabStavSkladu WHERE IDSklad = @IDSkladPrij AND IDKmenZbozi = @IDKmen
      IF @IDZboSkladPrij IS NULL
      BEGIN
        INSERT INTO TabStavSkladu (IDKmenZbozi, IDSklad) VALUES (@IDKmen, @IDSkladPrij)
        SET @IDZboSkladPrij = SCOPE_IDENTITY()

      END

      IF @IDZboSkladPrij IS NOT NULL
      BEGIN
        SELECT 
          @IDVyrCSPrij = vcs.ID 
        FROM TabVyrCS vcs
        JOIN TabStavSkladu skl ON skl.ID = vcs.IDStavSkladu
        WHERE vcs.Nazev1 = @SSCC AND skl.IDSklad = @IDSkladPrij

        IF @IDVyrCSPrij IS NULL
        BEGIN
          INSERT INTO TabVyrCS (IDVyrCK, IDStavSkladu, Nazev1) VALUES (@IDVyrCK, @IDZboSkladPrij, @SSCC)
          SET @IDVyrCSPrij = SCOPE_IDENTITY()
        END

        IF @IDVyrCSPrij IS NOT NULL
        BEGIN

            EXEC dbo.hpx_agrafa_insert_polozky_oz
              @IDent = @IDPohPrij OUTPUT,
              @IDDoklad = @IDPrij,
              @DruhPohybu = @DrPohPrij,
              @CisloOrg = @CisloOrg,
              @IDZboSklad = @IDZboSkladPrij,
              @Mena = @Mena,
              @Kurz = @Kurz,
              @JednotkaMeny = 1,
              @KurzEuro = 0,
              @SazbaSD = 0,
              @SazbaDPH = @SazbaDPH,
              @ZakazanoDPH = 0,
              @VstupniCena = @VstCena,
              @PovolitDuplicitu = 1,
              @Mnozstvi = @Mnozstvi,
              @MJ = @MJEvidence,
              @JCbezDaniKC = @JCbezDPH,
              @VstupniCenaProPrepocet = 0,
              @DotahovatSazby = 1
  
            IF @IDPohPrij IS NOT NULL 
            BEGIN
              INSERT INTO TabVyrCP (IDPolozkaDokladu, IDVyrCis, Nazev, Mnozstvi)
              VALUES (@IDPohPrij, @IDVyrCSPrij, @SSCC, @Mnozstvi)

              UPDATE TabPohybyZbozi SET IDOldPolozka = @IDPohVyd WHERE ID = @IDPohPrij
            END

        END

        UPDATE TabDokladyZbozi SET StavPrevodu = 3 WHERE ID = @IDVyd

      END

    END

  END

END
/*
ELSE
BEGIN
  RAISERROR('Chyba hledání SSCC', 15, 1)

END
*/
RETURN @IDPrij
GO
