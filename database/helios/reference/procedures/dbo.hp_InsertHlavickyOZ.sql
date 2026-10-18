-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_InsertHlavickyOZ]
@Ident         INT OUT,         -- ID vytvorene hlavicky
@Sklad         NVARCHAR(30),    -- pro Fa a Do je sklad ignorovan a nastaven NULL
@DruhPohybu    TINYINT,
@RadaDokladu   NVARCHAR(3),
@Insert        BIT      = 1,    -- 1: Insertem  /  0: Selectem
@IDPosta       INT      = NULL,
@Mena       NVARCHAR(3) = NULL, -- je-li NULL, dotahne se dle rady, nebo hlavni mena
@CisloOrg      INT      = NULL, -- je-li NULL, dotahne se z posty
@PC            INT      = NULL, -- poradove cislo, je-li NULL, dotahne se prvni volne
@DatumPorizeni DATETIME = NULL, -- je-li NULL, dotahne se z posty, nebo GetDate
@VstupniCena   TINYINT  = NULL  -- je-li NULL, dotahne se dle rady
AS
SET NOCOUNT ON
DECLARE @PosledniPC              INT
DECLARE @Ukod                    INT
DECLARE @IDDruhDokZbo            INT
DECLARE @RealizacniFak           BIT
DECLARE @JeToZaloha              BIT
DECLARE @JeToDDPP                BIT
DECLARE @FlagRealizacni          BIT
DECLARE @TiskovyForm             INT
DECLARE @TiskovyFormOrg          INT
DECLARE @ZdrojCisKV              TINYINT
DECLARE @ZaoFak                  SMALLINT
DECLARE @ZaoFakVal               SMALLINT
DECLARE @Kurz                    NUMERIC(19,6)
DECLARE @KurzEuro                NUMERIC(19,6)
DECLARE @JednotkaMeny            INT
DECLARE @Obdobi                  INT
DECLARE @Where                   NVARCHAR(200)
DECLARE @ZaokrDPHvaluty          SMALLINT
DECLARE @IDObdobiStavu           INT
DECLARE @LhutaSplatnosti         INT
DECLARE @FormaUhrady             NVARCHAR(30)
DECLARE @DUZP                    DATETIME
DECLARE @Splatnost               DATETIME
DECLARE @KontaktZam              INT
DECLARE @IDBankSp                INT
DECLARE @KonstSym                NVARCHAR(10)
DECLARE @Poznamka                NVARCHAR(MAX)
DECLARE @StredNaklad             NVARCHAR(30)
DECLARE @NOkruh                  NVARCHAR(13)
DECLARE @IDVozidlo               INT
DECLARE @CisZam                  INT
DECLARE @IDDanRezim              INT
DECLARE @DICOrg                  NVARCHAR(15)
DECLARE @ZaokrNaPadesat          INT = 0
DECLARE @PoziceZaokrDPH          SMALLINT
DECLARE @HraniceZaokrDPH         SMALLINT
DECLARE @ZaokrDPHMalaCisla       TINYINT
DECLARE @FormaDopravy            NVARCHAR(30)
DECLARE @CisloZakazky            NVARCHAR(13)
DECLARE @DatPovinnostiFa         DATETIME
DECLARE @SazbaDPH                NUMERIC(19,6)
DECLARE @ZemeDPH                 NVARCHAR(3)
DECLARE @ZpusobKurzZal           TINYINT
DECLARE @Nehradit                TINYINT
DECLARE @MetodaDSN               TINYINT
DECLARE @OsvobozenaPlneni        TINYINT
DECLARE @OpravDanDoklad          BIT
DECLARE @PotvrDoruceni           BIT
DECLARE @ErrStr                  NVARCHAR(2047)
DECLARE @HMena                   NVARCHAR(3)
DECLARE @DatumDoruceni           DATETIME
DECLARE @DatumKurzu              DATETIME
DECLARE @SplatnoPocitatOd        TINYINT
DECLARE @SamoDan_DICDPH          NVARCHAR(15)
DECLARE @SamoDan_ZdrojKurzu      INT
DECLARE @SamoDan_MenaDPH         NVARCHAR(3)
DECLARE @SamoDan_DatumKurzuDPH   DATETIME
DECLARE @SamoDan_KurzDPH         NUMERIC(19,6)
DECLARE @SamoDan_JednotkaMenyDPH INT
DECLARE @SamoDan_MenaHM          NVARCHAR(3)
DECLARE @SamoDan_DatumKurzuHM    DATETIME
DECLARE @SamoDan_KurzHM          NUMERIC(19,6)
DECLARE @SamoDan_JednotkaMenyHM  INT
DECLARE @RezimKurzuDPHFaktur     INT
DECLARE @SlevyBezRecykl          BIT
DECLARE @MetodaSD                BIT
DECLARE @KHDPHDoLimitu           TINYINT
DECLARE @DruhCU                  TINYINT
DECLARE @StavEET                 TINYINT
DECLARE @PZ2                     NVARCHAR(20)
DECLARE @DatumProMasku           NVARCHAR(8)
DECLARE @Rada_Q                  NVARCHAR(100)
DECLARE @Sklad_Q                 NVARCHAR(100)
DECLARE @RezimMOSS               TINYINT = 0 -- Rezim OSS ciloveho dokladu - One stop shop
DECLARE @PovolenMOSS             BIT
DECLARE @PovolenOSS              BIT
DECLARE @PovolenIOSS             BIT
DECLARE @PrednastaveniRezimuOSS  TINYINT
DECLARE @ZboziSluzba             TINYINT -- 0=neurceno 1=zbozi 2=sluzba
DECLARE @ZeFA                    BIT
DECLARE @ZeFATypDokladu          NVARCHAR(3)
IF @IDPosta IS NOT NULL
SELECT
@CisloOrg      = ISNULL(@CisloOrg, CisOrg),
@DatumPorizeni = ISNULL(@DatumPorizeni, Datum),
@Poznamka = Poznamka
FROM TabPosta WHERE ID = @IDPosta
SET @DatumPorizeni = ISNULL(@DatumPorizeni, GETDATE())
EXEC dbo.hp_NastavDatum_DatPovinnostiFa
@DruhPohybu, @RadaDokladu, @DatumPorizeni, @DatPovinnostiFa OUTPUT
SELECT TOP 1 @Obdobi = ID FROM TabObdobi
WHERE @DatumPorizeni BETWEEN DatumOd AND DatumDo
SELECT
@PosledniPC       = O.PosledniPC + 1,
@Ukod             = R.Ukod,
@IDDruhDokZbo     = R.ID,
@TiskovyForm      = R.TiskovyForm,
@VstupniCena      = ISNULL(@VstupniCena, R.VstupniCena),
@ZdrojCisKV       = R.ZdrojCisKV,
@RealizacniFak    = R.VyrZaplZaloh,
@JeToZaloha       = R.JeToZaloha,
@JeToDDPP         = R.JeToDDPP,
@FlagRealizacni   = R.VyrZaplZaloh,
@SamoDan_DICDPH   = R.SamoVyDICDPH,
@OpravDanDoklad   = R.OpravDanDoklad,
@OsvobozenaPlneni = R.OsvobozenaPlneni,
@ZpusobKurzZal    = R.ZpusobKurzZal,
@Nehradit         = R.Nehradit,
@MetodaDSN        = R.MetodaDSN,
@PotvrDoruceni    = R.PotvrDoruceni,
@StredNaklad      = R.StredNaklad,
@NOkruh           = R.NOkruh,
@IDVozidlo        = R.IDVozidlo,
@CisloZakazky     = R.CisloZakazky,
@CisZam           = R.CisZam,
@KHDPHDoLimitu    = R.KHDPHDoLimitu,
@DruhCU           = R.DruhCU,
@StavEET          = R.StavEET,
@PovolenMOSS      = RezimMOSS,
@PovolenOSS       = RezimOSS,
@PovolenIOSS      = RezimIOSS,
@PrednastaveniRezimuOSS = PrednastaveniRezimuOSS,
@Mena             = ISNULL(@Mena, R.DruhMeny),
@SazbaDPH         = CASE R.OsvobozenaPlneni
WHEN 1 THEN NULL
WHEN 2 THEN 0
ELSE R.SazbaDPH END,
@SamoDan_ZdrojKurzu = R.SamoVyZdrojKurzu,
@ZboziSluzba      = R.ZboziSluzba,
@ZeFA             = R.ZeFA,
@ZeFATypDokladu   = R.ZeFATypDokladu
FROM TabDruhDokZbo    AS R
JOIN TabDruhDokZboDef AS O ON O.IDDruhDZ = R.ID AND O.IDObdobi = @Obdobi
WHERE R.RadaDokladu   = @RadaDokladu
AND   R.DruhPohybuZbo = @DruhPohybu
IF @@ROWCOUNT < 1
BEGIN
SET @ErrStr = dbo.hf_FormatError(71113, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
SET @TiskovyFormOrg = NULL
IF @CisloOrg IS NOT NULL
SELECT @TiskovyFormOrg =
CASE
WHEN @DruhPohybu =  0 THEN J.TiskovyFormPrijem
WHEN @DruhPohybu =  1 THEN J.TiskovyFormPriSt
WHEN @DruhPohybu =  2 THEN J.TiskovyFormVydej
WHEN @DruhPohybu =  3 THEN J.TiskovyFormVydSt
WHEN @DruhPohybu =  4 THEN J.TiskovyFormVydEC
WHEN @DruhPohybu =  6 THEN J.TiskovyFormObjed
WHEN @DruhPohybu =  9 THEN J.TiskovyFormExped
WHEN @DruhPohybu = 10 THEN J.TiskovyFormRezer
WHEN @DruhPohybu = 11 THEN J.TiskovyFormNabid
WHEN @DruhPohybu = 13 THEN CASE
WHEN @FlagRealizacni = 1 THEN ISNULL(J.TiskovyFormFaVRealizacni, J.TiskovyFormFaV)
WHEN @JeToZaloha     = 1 THEN ISNULL(J.TiskovyFormFaVZaloha, J.TiskovyFormFaV)
WHEN @JeToDDPP       = 1 THEN ISNULL(J.TiskovyFormFaVDDPP, J.TiskovyFormFaV)
ELSE J.TiskovyFormFaV
END
WHEN @DruhPohybu = 14 THEN J.TiskovyFormDobV
WHEN @DruhPohybu = 18 THEN J.TiskovyFormFaP
WHEN @DruhPohybu = 19 THEN J.TiskovyFormDobP
END
FROM TabJazyky AS J WHERE J.Jazyk =
(SELECT C.Jazyk
FROM TabCisOrg AS C
WHERE C.CisloOrg = @CisloOrg)
IF @TiskovyFormOrg IS NOT NULL
SET @TiskovyForm = @TiskovyFormOrg
EXEC hp_OZGetDanRezDleRady @IDDruhDokZbo, @IDDanRezim OUT
EXEC hp_OZGetZemeDleDICDPH @SamoDan_DICDPH, NULL, @ZemeDPH OUT, 0
SELECT TOP 1
@HMena = Kod,
@Mena = ISNULL(@Mena, Kod),
@ZaoFak = ZaokrouhleniFaktury
FROM TabKodMen WHERE HlavniMena = 1
SELECT @ZaoFakVal = ZaokrouhleniFaktury
FROM TabKodMen WHERE Kod = @Mena
IF @Mena <> @HMena SET @ZaoFak = 2
SET @DatumKurzu = @DatumPorizeni
EXEC dbo.hp_EUR_NajdiKurz -3, @Mena, @DatumKurzu OUT,
@Kurz OUT, @KurzEuro OUT, @JednotkaMeny OUT
EXEC dbo.hp_NastavDatum_DatumDoruceni
@DruhPohybu, @RadaDokladu, @DatumPorizeni, @DatPovinnostiFa, @DatumDoruceni OUTPUT
IF @DruhPohybu IN(13,14,18,19)
BEGIN
SET @Sklad = NULL
EXEC dbo.hp_NastavDatum_DUZP
@DruhPohybu, @RadaDokladu, @DatumPorizeni, @DatPovinnostiFa, @DUZP OUTPUT
IF @DruhPohybu IN(13,19)
BEGIN
EXEC dbo.hp_DotahniBSProFaV_a_DoP
@CisloOrg, @RadaDokladu, @DruhPohybu, @IDBankSp OUT, @KonstSym OUT, @Mena
SELECT @FormaDopravy = FormaDopravy
FROM TabDruhDokZbo
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybu
END ELSE
BEGIN
EXEC dbo.hp_ZkusDotahnoutBankSpoj
@CisloOrg, @DruhPohybu, @IDBankSp OUT, @KonstSym OUT
SELECT
@FormaDopravy = FormaDopravy,
@IDBankSp = ISNULL(@IDBankSp, IDBankSpoj),
@KonstSym = ISNULL(@KonstSym, KonstSymbol)
FROM TabDruhDokZbo
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybu
END
EXEC dbo.hp_NastavDatum_Splatnost
@DruhPohybu, @RadaDokladu, @CisloOrg,
@DatumPorizeni, @DatPovinnostiFa, @DUZP,
@Splatnost OUTPUT, @LhutaSplatnosti OUTPUT, @FormaUhrady OUTPUT,
1, 0, NULL, @DatumDoruceni
END
EXEC dbo.hp_DotahniSplatnoPocitatOd
@DruhPohybu, @RadaDokladu, @SplatnoPocitatOd OUT, @CisloOrg
EXEC dbo.hp_NastavDatum_Obdobi
@DruhPohybu, @RadaDokladu, @DatumPorizeni,
@DUZP, @DatumDoruceni, @Obdobi, @IDObdobiStavu OUTPUT
IF @CisloOrg IS NOT NULL
EXEC dbo.hp_VratDICDleOrganizace @CisloOrg, @DICOrg OUTPUT
EXEC hp_ValidaceOSSCheckboxu @PovolenMOSS OUT, @PovolenOSS OUT, @PovolenIOSS OUT,
@DUZP, @CisloOrg, NULL, NULL
IF @PrednastaveniRezimuOSS > 0
BEGIN
IF ((@PovolenMOSS = 1 AND @PrednastaveniRezimuOSS = 1) OR
(@PovolenOSS  = 1 AND @PrednastaveniRezimuOSS = 2) OR
(@PovolenIOSS = 1 AND @PrednastaveniRezimuOSS = 3))
BEGIN
SET @RezimMOSS = @PrednastaveniRezimuOSS
EXEC hp_OSSGetZemeDICDPHDokZbo @ZemeDPH OUT, @SamoDan_DICDPH OUT, @DruhPohybu, @RadaDokladu,
0, NULL, NULL, @CisloOrg, NULL
END
END
IF (SELECT COUNT(*) FROM TabCisZam WHERE LoginID = SUSER_SNAME()) = 1
SELECT TOP 1 @KontaktZam = ID FROM TabCisZam WHERE LoginID = SUSER_SNAME()
SELECT @ZaokrNaPadesat = ZaokrNaPadesat
FROM TabFormaUhrady WHERE FormaUhrady = @FormaUhrady
SELECT
@RezimKurzuDPHFaktur = OZRezimKurzuDPHFaktur,
@SlevyBezRecykl      = OZSlevyBezRecykl,
@MetodaSD            = OZMetodaSD,
@PoziceZaokrDPH      = PoziceZaokrDPH,
@HraniceZaokrDPH     = HraniceZaokrDPH,
@ZaokrDPHvaluty      = ZaokrDPHvaluty,
@ZaokrDPHMalaCisla   = ZaokrDPHMalaCisla
FROM TabHGlob
IF @ZaokrNaPadesat = 4 AND
@Mena    = 'CZK' AND
@ZemeDPH = 'CZ'
BEGIN
IF @ZaoFak    IN(1,2) SET @ZaoFak    = 0
IF @ZaoFakVal IN(1,2) SET @ZaoFakVal = 0
END
IF @ZaokrNaPadesat = 5
IF @DatumPorizeni < '20220701' SET @ZaokrNaPadesat = 0 ELSE
IF ISNULL(@Mena, @HMena) <> N'EUR' SET @ZaokrNaPadesat = 0 ELSE
IF @HMena = N'EUR'
SET @ZaokrNaPadesat = 6 ELSE
SET @ZaokrNaPadesat = 7
EXEC dbo.hp_ObehZbozi_HodnotyProSamoDan
@DruhPohybu,
@RezimKurzuDPHFaktur,
@SamoDan_DICDPH, @DatumPorizeni, @DUZP,
@Mena, @DatumKurzu, @Kurz, @JednotkaMeny,
@SamoDan_ZdrojKurzu OUT,
@SamoDan_MenaDPH OUT,
@SamoDan_DatumKurzuDPH OUT,
@SamoDan_KurzDPH OUT,
@SamoDan_JednotkaMenyDPH OUT,
@SamoDan_MenaHM OUT,
@SamoDan_DatumKurzuHM OUT,
@SamoDan_KurzHM OUT,
@SamoDan_JednotkaMenyHM OUT
SET @DatumProMasku = ISNULL((
CONVERT(NVARCHAR(8),
CASE WHEN @Splatnost IS NULL THEN @DatumPorizeni ELSE @Splatnost END, 112)),
CONVERT(NVarchar(8),GETDATE(),112))
IF (@PC IS NOT NULL)
EXEC dbo.hp_PZ2_VratPZ2zOZ
@DruhPohybu, @PC, @RadaDokladu, @CisloOrg, @DatumProMasku, @PZ2 OUT
IF @ZpusobKurzZal IS NOT NULL AND @ZpusobKurzZal=2
SELECT @ZpusobKurzZal=FakZalohyDleVal FROM TabHGlob
IF @Insert = 1
BEGIN
DECLARE @PocetPokusuDotazeniPoradCisla TINYINT = 10
DECLARE @PocetPokusu TINYINT = 1
WHILE @PocetPokusu <= @PocetPokusuDotazeniPoradCisla
BEGIN
BEGIN TRY
IF (@PC IS NULL) OR (EXISTS(
SELECT * FROM TabDokladyZbozi
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybu
AND PoradoveCislo = @PC
AND Obdobi = @Obdobi
AND (IDSklad = @Sklad OR (IDSklad IS NULL) AND (@Sklad IS NULL))))
BEGIN
EXEC dbo.hp_NQuotedStr @RadaDokladu, @Rada_Q OUT
EXEC dbo.hp_NQuotedStr @Sklad, @Sklad_Q OUT
SET @Where =
N'Obdobi = ' + CAST(@Obdobi AS NVARCHAR) +
N' AND RadaDokladu = ' + @Rada_Q +
N' AND DruhPohybuZbo = ' + CAST(@DruhPohybu AS NVARCHAR) +
N' AND IDSklad'
IF @DruhPohybu IN (13,14,18,19)
SET @Where = @Where + N' IS NULL'
ELSE
SET @Where = @Where + N' = ' + @Sklad_Q
EXEC @PC = dbo.hp_NajdiPrvniVolny
N'TabDokladyZbozi', N'PoradoveCislo', @PosledniPC, 9999999, @Where, 1, 1, @Obdobi
EXEC dbo.hp_PZ2_VratPZ2zOZ
@DruhPohybu, @PC, @RadaDokladu, @CisloOrg, @DatumProMasku, @PZ2 OUT
END
INSERT INTO TabDokladyZbozi
(PoradoveCislo, Ukod, TiskovyForm, VstupniCena, ZdrojCisKV,
ZaokrouhleniFak, OpravDanDoklad, OsvobozenaPlneni, ZpusobKurzZal, Nehradit, MetodaDSN,
PotvrDoruceni, ZaokrouhleniFakVal, Kurz, KurzEuro, JednotkaMeny, Mena, DatPorizeni,
Obdobi, IDObdobiStavu, Splatnost, FormaUhrady, DUZP, KontaktZam,
CisloOrg, IDBankSpoj, KonstSymbol, Poznamka, StredNaklad, NOkruhCislo, CisloZam,
IDVozidlo, FormaDopravy, CisloZakazky, IDSklad, DruhPohybuZbo, RadaDokladu,
DatPovinnostiFa, DatumDoruceni, DIC, PoziceZaokrDPH, HraniceZaokrDPH,
ZaokrDPHvaluty, ZaokrDPHMalaCisla, RealizacniFak, SazbaDPH, ZemeDPH, DatumKurzu,
JeToZaloha, SplatnoPocitatOd, SamoVyDICDPH, SamoVyZdrojKurzu,
SamoVyMenaDPH, SamoVyDatumKurzuDPH, SamoVyKurzDPH, SamoVyMnoKurzDPH,
SamoVyMenaDPHHM, SamoVyDatumKurzuDPHHM, SamoVyKurzDPHHM, SamoVyMnoKurzDPHHM,
KHDPHDoLimitu, DruhCU, IDDanovyRezim, ZboziSluzba, StavEET, PZ2, JeToDDPP,
RezimMOSS, SlevyBezRecykl, MetodaSD, ZaokrNaPadesat, ZeFA, ZeFATypDokladu
)
VALUES
(@PC, @Ukod, @TiskovyForm, @VstupniCena, @ZdrojCisKV,
@ZaoFak, @OpravDanDoklad, @OsvobozenaPlneni, @ZpusobKurzZal, @Nehradit, @MetodaDSN,
@PotvrDoruceni, @ZaoFakVal, ISNULL(@Kurz,1), ISNULL(@KurzEuro,0), ISNULL(@JednotkaMeny,1),
@Mena, @DatumPorizeni, @Obdobi, @IDObdobiStavu, @Splatnost, @FormaUhrady, @DUZP,
@KontaktZam, @CisloOrg, @IDBankSp, @KonstSym, @Poznamka, @StredNaklad, @NOkruh, @CisZam,
@IDVozidlo, @FormaDopravy, @CisloZakazky, @Sklad, @DruhPohybu, @RadaDokladu,
@DatPovinnostiFa, @DatumDoruceni, @DICOrg, @PoziceZaokrDPH, @HraniceZaokrDPH,
@ZaokrDPHvaluty, @ZaokrDPHMalaCisla, @RealizacniFak, @SazbaDPH, @ZemeDPH, @DatumKurzu,
@JeToZaloha, @SplatnoPocitatOd, @SamoDan_DICDPH, @SamoDan_ZdrojKurzu,
@SamoDan_MenaDPH, @SamoDan_DatumKurzuDPH, ISNULL(@SamoDan_KurzDPH,1), ISNULL(@SamoDan_JednotkaMenyDPH,1),
@SamoDan_MenaHM, @SamoDan_DatumKurzuHM, ISNULL(@SamoDan_KurzHM,1), ISNULL(@SamoDan_JednotkaMenyHM,1),
@KHDPHDoLimitu, @DruhCU, @IDDanRezim, @ZboziSluzba, @StavEET, @PZ2, @JeToDDPP,
@RezimMOSS, @SlevyBezRecykl, @MetodaSD, @ZaokrNaPadesat, @ZeFA, @ZeFATypDokladu
)
SET @Ident = SCOPE_IDENTITY()
RETURN
END TRY
BEGIN CATCH
SELECT @ErrStr = ERROR_MESSAGE()
IF ERROR_NUMBER() = 2627 
BEGIN
SET @ErrStr = dbo.hf_FormatError(74050, '')
SET @PocetPokusu = @PocetPokusu + 1
CONTINUE
END
ELSE
BREAK
END CATCH
END
BEGIN
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
ELSE
BEGIN
IF (@PC IS NULL) OR (EXISTS(
SELECT * FROM TabDokladyZbozi
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybu
AND PoradoveCislo = @PC
AND Obdobi = @Obdobi
AND (IDSklad = @Sklad OR (IDSklad IS NULL) AND (@Sklad IS NULL))))
BEGIN
EXEC dbo.hp_NQuotedStr @RadaDokladu, @Rada_Q OUT
EXEC dbo.hp_NQuotedStr @Sklad, @Sklad_Q OUT
SET @Where =
N'Obdobi = ' + CAST(@Obdobi AS NVARCHAR) +
N' AND RadaDokladu = ' + @Rada_Q +
N' AND DruhPohybuZbo = ' + CAST(@DruhPohybu AS NVARCHAR) +
N' AND IDSklad'
IF @DruhPohybu IN (13,14,18,19)
SET @Where = @Where + N' IS NULL'
ELSE
SET @Where = @Where + N' = ' + @Sklad_Q
EXEC @PC = dbo.hp_NajdiPrvniVolny
N'TabDokladyZbozi', N'PoradoveCislo', @PosledniPC, 9999999, @Where, 1, 1, @Obdobi
EXEC dbo.hp_PZ2_VratPZ2zOZ
@DruhPohybu, @PC, @RadaDokladu, @CisloOrg, @DatumProMasku, @PZ2 OUT
END
SELECT
@PC AS PoradoveCislo, @Ukod AS Ukod, @TiskovyForm AS TiskovyForm,
@VstupniCena AS VstupniCena, @ZdrojCisKV AS ZdrojCisKV, @ZaoFak AS ZaokrouhleniFak,
@ZaoFakVal AS ZaokrouhleniFakVal, ISNULL(@Kurz,1) AS Kurz, ISNULL(@KurzEuro,0) AS KurzEuro,
ISNULL(@JednotkaMeny,1) AS JednotkaMeny, @Mena AS Mena, @DatumPorizeni AS DatPorizeni,
@Obdobi AS Obdobi, @IDObdobiStavu AS IDObdobiStavu, @Splatnost AS Splatnost,
@FormaUhrady AS FormaUhrady, @DUZP AS DUZP, @KontaktZam AS KontaktZam,
@CisloOrg AS CisloOrg, @IDBankSp AS IDBankSpoj, @KonstSym AS KonstSymbol,
@Poznamka AS Poznamka, @StredNaklad AS StredNaklad, @NOkruh AS NOkruhCislo,
@IDVozidlo AS IDVozidlo, @FormaDopravy AS FormaDopravy, @CisloZakazky AS CisloZakazky,
@Sklad AS IDSklad, @DruhPohybu AS DruhPohybuZbo, @RadaDokladu AS RadaDokladu,
@DICOrg AS DIC, @PoziceZaokrDPH AS PoziceZaokrDPH, @HraniceZaokrDPH AS HraniceZaokrDPH,
@ZaokrDPHvaluty AS ZaokrDPHvaluty, @ZaokrDPHMalaCisla AS ZaokrDPHMalaCisla,
@CisZam AS CisloZam, @RealizacniFak AS RealizacniFak, @SazbaDPH AS SazbaDPH,
@ZemeDPH AS ZemeDPH, @OpravDanDoklad AS OpravDanDoklad,
@OsvobozenaPlneni AS OsvobozenaPlneni, @ZpusobKurzZal AS ZpusobKurzZal,
@Nehradit AS Nehradit, @MetodaDSN AS MetodaDSN, @PotvrDoruceni AS PotvrDoruceni,
@DatumDoruceni AS DatumDoruceni, @DatumKurzu AS DatumKurzu, @JeToZaloha AS JeToZaloha,
@SamoDan_DICDPH AS SamoVyDICDPH, @SamoDan_ZdrojKurzu AS SamoVyZdrojKurzu,
@SamoDan_MenaDPH AS SamoVyMenaDPH, @SamoDan_DatumKurzuDPH AS SamoVyDatumKurzuDPH,
ISNULL(@SamoDan_KurzDPH,1) AS SamoVyKurzDPH, ISNULL(@SamoDan_JednotkaMenyDPH,1) AS SamoVyMnoKurzDPH,
@SamoDan_MenaHM AS SamoVyMenaDPHHM, @SamoDan_DatumKurzuHM AS SamoVyDatumKurzuDPHHM,
ISNULL(@SamoDan_KurzHM,1) AS SamoVyKurzDPHHM, ISNULL(@SamoDan_JednotkaMenyHM,1) AS SamoVyMnoKurzDPHHM,
@KHDPHDoLimitu AS KHDPHDoLimitu, @DruhCU AS DruhCU,
@IDDanRezim AS IDDanovyRezim, @StavEET AS StavEET, @PZ2 AS PZ2, @JeToDDPP AS JeToDDPP,
@RezimMOSS AS RezimMOSS, @SlevyBezRecykl AS SlevyBezRecykl, @MetodaSD AS MetodaSD,
@ZaokrNaPadesat AS ZaokrNaPadesat, @DatPovinnostiFa AS DatPovinnostiFa,
@SplatnoPocitatOd AS SplatnoPocitatOd
END
GO
