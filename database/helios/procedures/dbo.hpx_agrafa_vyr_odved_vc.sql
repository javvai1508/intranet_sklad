-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_vyr_odved_vc]
@CisloZam INT,
@IDVyrCis INT,
@IDPrijem INT OUTPUT,
@Msg NVARCHAR(2000) OUTPUT

AS

DECLARE @IDPrikaz INT
DECLARE @RadaPrikazu NVARCHAR(3)
DECLARE @SkladPrij NVARCHAR(20)
DECLARE @DruhPohybuZbo INT
DECLARE @Doklad INT
DECLARE @Kusy_odv NUMERIC(19, 6)
DECLARE @Kusy_zmet_neopr NUMERIC(19, 6)
DECLARE @DatumOperace DATETIME
DECLARE @IDPracoviste INT
DECLARE @Dilec INT
DECLARE @VyrCislo NVARCHAR(100)
DECLARE @ZamestnanecID INT
-- DECLARE @IDPrijem INT
DECLARE @BylaChyba INT
-- DECLARE @Msg NVARCHAR(2000)

DECLARE @IDEvidOp INT

DECLARE @DatExpirace DATETIME
DECLARE @DatVstup DATETIME
DECLARE @Sarze NVARCHAR(50)
DECLARE @Karton INT
DECLARE @MU INT
DECLARE @TypPalety INT
DECLARE @Zeme NVARCHAR(3)
DECLARE @IDVyrCK INT

SET @Msg = N''
SET @Kusy_zmet_neopr = 0
SET @DatumOperace = GETDATE()
SET @ZamestnanecID = (SELECT ID FROM TabCisZam WHERE Cislo = @CisloZam)

-- transakce
BEGIN TRY
BEGIN TRANSACTION

SELECT 
  @IDPrikaz = vcpr.IDPrikaz,
  @RadaPrikazu = pr.Rada,
  @VyrCislo = vcpr.VyrCislo,
  @Kusy_odv = vcpr.Mnozstvi,
  @Dilec = pr.IDTabKmen,
  @DatExpirace = pre._vyr_pr_datexpirace,
  @DatVstup = pre._vyr_pr_dat_vyroby,
  @Sarze = pre._vyr_pr_sarze,
  @Karton = pre._vyr_pr_karton,
  @MU = pre._vyr_pr_odberatel_mu,
  @TypPalety = pre._vyr_pr_typ_palety,
  @Zeme = pre._vyr_pr_zeme_urceni
FROM TabVyrCisPrikaz vcpr
JOIN TabPrikaz pr ON pr.ID = vcpr.IDPrikaz
LEFT JOIN TabPrikaz_EXT pre ON pre.ID = pr.ID
WHERE vcpr.ID = @IDVyrCis

IF @IDPrikaz IS NOT NULL
BEGIN
  SELECT 
    @Doklad = Doklad,
    @IDPracoviste = Pracoviste
  FROM TabPrPostup
  WHERE TabPrPostup.IDPrikaz = @IDPrikaz AND ISNULL(Odvadeci, 0) = 1

  IF @Doklad IS NOT NULL
  BEGIN
-- odvedení operace
    EXEC @IDEvidOp = dbo.hp_EvidenceOperace
      @IDPrikaz = @IDPrikaz,
      @Doklad = @Doklad,
      @Alt = NULL,
      @Kusy_odv = @Kusy_odv,
      @kusy_zmet_opr = 0,
      @kusy_zmet_opr_IO = 0,
      @kusy_zmet_neopr = @Kusy_zmet_neopr,
      @IDVyrCis = @IDVyrCis,
      @DatumZahajeniOp = @DatumOperace,
      @DatumUkonceniOp = @DatumOperace,
      @Sk_Cas_S = 0,
      @Sk_Cas_Obsluhy_S = 0,
      @IDZam = @ZamestnanecID,
      @IDPracoviste = @IDPracoviste OUT,
      @KodZavady = NULL

-- výdej materiálu podle TabPrKVazby
    DECLARE @IDPrKVazby INT
    DECLARE @IDSkladVyd NVARCHAR(20)
    DECLARE @RadaVyd NVARCHAR(3)
    DECLARE @MnozstviZad NUMERIC(19, 6)
    DECLARE @IDPrKVazbyGen INT
    DECLARE @PrKVazbyDok INT
    DECLARE @IDVydej INT

    SELECT @IDSkladVyd = TabRadyPrikazu.VydejMatPol_SkladProGenHlavDZ, @RadaVyd = TabRadyPrikazu.RadaDokl_GenerRezVyd_Mat
    FROM TabRadyPrikazu WHERE Rada = @RadaPrikazu

    SET @DruhPohybuZbo = 4

    CREATE TABLE #TabGenRezVyd(
	ID int) --zde uloženka zapíše IDčka nového záznamu z TabDokladyZbozi

    CREATE TABLE #TabPrKVazbyGen(
	ID int IDENTITY(1,1) NOT NULL, 
	Generuj bit NOT NULL, --1=tento záznam zahrň do generování
	IDPrKV int NOT NULL, --ID z TabPrKVazby
	Sklad nvarchar(30) COLLATE database_default NOT NULL, 
	MnozstviPoz numeric(19,6) NOT NULL, 
	Dodavatel int NULL, --ID organizace pro generování objednávek
	IDPohZbo int NULL, --zde uloženka zapíše IDčko nového záznamu z TabPohybyZbozi
	PRIMARY KEY (ID)) 

    CREATE TABLE #TabPrKVazbyGenVC(
 	ID int IDENTITY(1,1) NOT NULL, 
	IDPolozky int NOT NULL, --ID z #TabPrKVazbyGen
	VyrCislo nvarchar(25) COLLATE database_default NOT NULL, 
	Mnozstvi numeric(19,6) NOT NULL, 
	IDVyrCP int NULL) --zde uloženka zapíše IDčko nového záznamu z TabVyrCP

    CREATE TABLE #TabPrKVazbyGen_IDMzdy(
	IDPrikaz int, --ID z TabPrikaz
	Doklad int,   --Doklad z TabPrKVazby
	IDMzdy int)   --ID z TabPrikazMzdyAZmetky

    DECLARE crm CURSOR LOCAL FAST_FORWARD FOR
    SELECT
      pkv.ID,
      pkv.Mnozstvi * @Kusy_odv,
      pkv.Doklad
    FROM TabPrKVazby pkv
    WHERE pkv.IDPrikaz = @IDPrikaz

    OPEN crm
    FETCH NEXT FROM crm INTO @IDPrKVazby, @MnozstviZad, @PrKVazbyDok
    WHILE @@FETCH_STATUS = 0
    BEGIN

      INSERT INTO #TabPrKVazbyGen (Generuj, IDPrKV, Sklad, MnozstviPoz)
      VALUES (1, @IDPrKVazby, @IDSkladVyd, ROUND(@MnozstviZad, 2))

      SET @IDPrKVazbyGen = SCOPE_IDENTITY()

      INSERT INTO #TabPrKVazbyGenVC (IDPolozky, VyrCislo, Mnozstvi)
      VALUES (@IDPrKVazbyGen, '', ROUND(@MnozstviZad, 2))

      INSERT INTO #TabPrKVazbyGen_IDMzdy (IDPrikaz, Doklad, IDMzdy)
      VALUES (@IDPrikaz, @PrKVazbyDok, @IDEvidOp)

      FETCH NEXT FROM crm INTO @IDPrKVazby, @MnozstviZad, @PrKVazbyDok

    END
/* bez výdejek
    IF (SELECT COUNT(Generuj) FROM #TabPrKVazbyGen) > 0
    BEGIN
--      EXEC hp_generujRezVyd @RadaDokladu = @RadaVyd, @DruhPohybuZbo = @DruhPohybuZbo
      EXEC dbo.hpx_agrafa_generujRezVydNew @RadaDokladu = @RadaVyd, @DruhPohybuZbo = @DruhPohybuZbo

    END

    DECLARE cvyd CURSOR LOCAL FAST_FORWARD FOR
    SELECT ID FROM #TabGenRezVyd

    OPEN cvyd
    FETCH NEXT FROM cvyd INTO @IDVydej
    WHILE @@FETCH_STATUS = 0
    BEGIN

      -- EXEC hp_Realizuj_Vydej @ID = @IDVydej, @DatumRealizace = NULL, @Uzivatel = 0, @Hlidat = 0, @BylaChyba = @BylaChyba OUT 

      FETCH NEXT FROM cvyd INTO @IDVydej

    END
*/
-- příjem na sklad
    IF @IDEvidOP IS NOT NULL
    BEGIN
      DECLARE @IDSkladPrij nvarchar(30),
                       @RadaPrij nvarchar(3),
	    @IDPrij int,
	    @CisloOrg int,
	    @IDOdvod INT

      SELECT @IDSkladPrij = PrijemVyrDil_SkladProGenHlavDZ, @RadaPrij = RadaDokl_OdvedeniPrikazu 
      FROM TabRadyPrikazu WHERE Rada = @RadaPrikazu

      SET @CisloOrg = 0
      SET @DruhPohybuZbo = 0

      -- standardní postup procedurou Gatema
      CREATE TABLE #TabGenPrijem(
        ID int) --zde uloženka zapíše IDčka nového záznamu z TabDokladyZbozi
      CREATE TABLE #TabOdved(
        ID int IDENTITY(1,1) NOT NULL, 
        IDPrikaz int NOT NULL, --ID z TabPrikaz
        IDDilec int NOT NULL, --ID dílce z TabKmenZbozi
        IDZakazModif int NULL, --ID zakáz. modifikace z TabZakazModif
        Sklad nvarchar(30) COLLATE database_default NOT NULL, 
        mnozstvi numeric(19,6) NOT NULL, 
        KodUmisteni nvarchar(15) COLLATE database_default NULL, 
        IDZakazka int NULL, --ID z TabZakazka
        IDPohZbo int NULL, --zde uloženka zapíše IDčko nového záznamu z TabPohybyZbozi
        PRIMARY KEY (ID)) 

      CREATE TABLE #TabVyrCisProGenOdv(
        ID int IDENTITY(1,1) NOT NULL, 
        IDOdvedeni int NOT NULL, --ID z #TabOdved
        IDPrikaz int NOT NULL, --ID z TabPrikaz
        VyrCislo nvarchar(25) COLLATE database_default NOT NULL, 
        Mnozstvi numeric(19,6) NOT NULL, 
        MaxMnozstvi numeric(19,6) NULL,
        IDVyrCP int NULL, --zde uloženka zapíše IDčko nového záznamu z TabVyrCP
        PRIMARY KEY (ID)) 

      CREATE TABLE #TabOdved_IDMzdy(
        IDPrikaz int, --ID z TabPrikaz
        IDMzdy int) -- ID z TabPrikazMzdyAZmetky

      INSERT INTO #TabOdved (IDPrikaz, IDDilec, Sklad, mnozstvi)
      VALUES (@IDPrikaz, @Dilec, @IDSkladPrij, @Kusy_odv)

      SET @IDOdvod = SCOPE_IDENTITY()

      INSERT INTO #TabVyrCisProGenOdv (IDOdvedeni, IDPrikaz, VyrCislo, Mnozstvi)
      VALUES (@IDOdvod, @IDPrikaz, @VyrCislo, @Kusy_odv)

      INSERT INTO #TabOdved_IDMzdy (IDPrikaz, IDMzdy)
      VALUES (@IDPrikaz, @IDEvidOp)

      EXEC hp_OdvedeniPrikazuNew @RadaDokladu = @RadaPrij
      -- EXEC dbo.hpx_agrafa_OdvedeniPrikazuNew @RadaDokladu = @RadaPrij

      DECLARE cr CURSOR LOCAL FAST_FORWARD FOR
      SELECT
        po.IDDoklad
      FROM #TabOdved odv
      JOIN TabPohybyZbozi po ON po.ID = odv.IDPohZbo

      OPEN cr
      FETCH NEXT FROM cr INTO @IDPrijem
      WHILE @@FETCH_STATUS = 0
      BEGIN
        SET @IDVyrCK = (SELECT ID FROM TabVyrCK WHERE Nazev1 = @VyrCislo AND IDKmenZbozi = @Dilec)

        IF @IDVyrCK IS NOT NULL
        BEGIN
          UPDATE TabVyrCK
          SET 
            DatExpirace = @DatExpirace,
            DatVstup = @DatVstup
          WHERE ID = @IDVyrCK

          IF EXISTS(SELECT ID FROM TabVyrCK_EXT WHERE ID = @IDVyrCK)
            UPDATE TabVyrCK_EXT
            SET
              _sarze_km = @Sarze,
              _vyr_vck_karton = @Karton,
              _vyr_vck_odberatel_mu = @MU,
              _vyr_vck_typ_palety = @TypPalety,
              _vyr_vck_zeme_urceni = @Zeme
            WHERE ID = @IDVyrCK
          ELSE
            INSERT INTO TabVyrCK_EXT (ID, _sarze_km, _vyr_vck_karton, _vyr_vck_odberatel_mu, _vyr_vck_typ_palety, _vyr_vck_zeme_urceni)
            VALUES (@IDVyrCK, @Sarze, @Karton, @MU, @TypPalety, @Zeme)
        END

        -- upravit data ve TabVyrCS, TabVyrCP
        UPDATE TabVyrCS
        SET 
          DatVstup = TabVyrCK.DatVstup,
          DatExpirace = TabVyrCK.DatExpirace
        FROM TabVyrCK
        WHERE TabVyrCK.ID = @IDVyrCK AND TabVyrCK.ID = TabVyrCS.IDVyrCK

        UPDATE TabVyrCP
        SET 
          DatVstup = TabVyrCK.DatVstup,
          DatExpirace = TabVyrCK.DatExpirace
        FROM TabVyrCS, TabVyrCK
        WHERE TabVyrCK.ID = @IDVyrCK AND TabVyrCK.ID = TabVyrCS.IDVyrCK AND TabVyrCS.ID = TabVyrCP.IDVyrCis

        EXEC dbo.hpx_agrafa_skl_prepoc_doklad @IDDoklad = @IDPrijem
        EXEC hp_Realizuj_Prijem @ID = @IDPrijem, @DatumRealizace = NULL, @Uzivatel = 0, @BylaChyba = @BylaChyba OUT

        FETCH NEXT FROM cr INTO @IDPrijem

      END

    END


  END

END
-- konec transakce
  COMMIT TRANSACTION
END TRY

BEGIN CATCH
	
  IF (XACT_STATE()) = -1 ROLLBACK TRANSACTION
  IF (XACT_STATE()) = 1 COMMIT TRANSACTION

/*  INSERT INTO #TabExtKom(Poznamka)VALUES(N'Chyba:')
  IF ISNULL(@Msg, '') <> ''
    INSERT INTO #TabExtKom(Poznamka)VALUES(@Msg)
  DECLARE @ErrMsg NVARCHAR(2000)*/
  SET @Msg = ERROR_MESSAGE()
  IF CHARINDEX('|', @Msg) > 0
    SET @Msg = ISNULL(SUBSTRING(@Msg, 1, CHARINDEX('|', @Msg) -1), '') + '| ' + REPLACE(ISNULL((SELECT SUBSTRING(REPLACE(CONVERT(NVARCHAR(MAX), Hlaska), (NCHAR(13) + NCHAR(10)), NCHAR(32)), 1, 255) FROM TabInterniHlasky WHERE Cislo = CONVERT(INT, ISNULL(SUBSTRING(@Msg, 1, CHARINDEX('|', @Msg) -1), -1))), '???'), '%s', TRIM(SUBSTRING(@Msg, CHARINDEX('|', @Msg) + 1, LEN(@Msg) - CHARINDEX('|', @Msg))))
  /*INSERT INTO #TabExtKom(Poznamka)VALUES(ERROR_MESSAGE())
  INSERT INTO #TabExtKom(Poznamka)VALUES(@ErrMsg)*/
  
			
END CATCH

/*IF @IDPrijem IS NOT NULL
  RETURN @IDPrijem*/
GO
