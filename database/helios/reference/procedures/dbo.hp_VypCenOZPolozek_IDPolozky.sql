-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_VypCenOZPolozek_IDPolozky]
@IDPolozky          INT,
@AktualizaceSlev    BIT,
@Pozice             INT = NULL,
@Hranice            INT = NULL,
@VstupniCena        INT = NULL,
@SlevaDokladu       NUMERIC(19,6) = NULL,
@CisloOrg           INT     = NULL,
@ZaokrDPHValuty     TINYINT = NULL,
@ZaokrDPHMalaCisla  TINYINT = NULL,
@ZpusobKurzu        TINYINT = NULL,
@DoTempTab          BIT = 0,
@SamoVyMenaDPH      NVARCHAR(3)   = '',
@SamoVyMenaDPHHM    NVARCHAR(3)   = '',
@SamoVyMnoKurzDPH   NUMERIC(19,6) = NULL,
@SamoVyKurzDPH      NUMERIC(19,6) = NULL,
@SamoVyMnoKurzDPHHM NUMERIC(19,6) = NULL,
@SamoVyKurzDPHHM    NUMERIC(19,6) = NULL,
@SlevyBezRecykl     BIT = NULL -- aplikuj vypocet slev na ceny bez recyklacniho prispevku
AS
SET NOCOUNT ON
DECLARE @IDDoklad INT
DECLARE @CenyDle TINYINT
DECLARE @JCBezDaniKc       NUMERIC(19,6) -- ceny pred slevou
DECLARE @JCSSDKc           NUMERIC(19,6)
DECLARE @JCSDPHKc          NUMERIC(19,6)
DECLARE @JCZadaneDPHKc     NUMERIC(19,6)
DECLARE @CCBezDaniKc       NUMERIC(19,6)
DECLARE @CCSSDKc           NUMERIC(19,6)
DECLARE @CCSDPHKc          NUMERIC(19,6)
DECLARE @CCZadaneDPHKc     NUMERIC(19,6)
DECLARE @JCBezDaniVal      NUMERIC(19,6)
DECLARE @JCSSDVal          NUMERIC(19,6)
DECLARE @JCSDPHVal         NUMERIC(19,6)
DECLARE @JCZadaneDPHVal    NUMERIC(19,6)
DECLARE @CCBezDaniVal      NUMERIC(19,6)
DECLARE @CCSSDVal          NUMERIC(19,6)
DECLARE @CCSDPHVal         NUMERIC(19,6)
DECLARE @CCZadaneDPHVal    NUMERIC(19,6)
DECLARE @JCBezDaniKcPoS    NUMERIC(19,6) -- ceny po sleve
DECLARE @JCSSDKcPoS        NUMERIC(19,6)
DECLARE @JCSDPHKcPoS       NUMERIC(19,6)
DECLARE @JCZadaneDPHKcPoS  NUMERIC(19,6)
DECLARE @CCBezDaniKcPoS    NUMERIC(19,6)
DECLARE @CCSSDKcPoS        NUMERIC(19,6)
DECLARE @CCSDPHKcPoS       NUMERIC(19,6)
DECLARE @CCZadaneDPHKcPoS  NUMERIC(19,6)
DECLARE @JCBezDaniValPoS   NUMERIC(19,6)
DECLARE @JCSSDValPoS       NUMERIC(19,6)
DECLARE @JCSDPHValPoS      NUMERIC(19,6)
DECLARE @JCZadaneDPHValPoS NUMERIC(19,6)
DECLARE @CCBezDaniValPoS   NUMERIC(19,6)
DECLARE @CCSSDValPoS       NUMERIC(19,6)
DECLARE @CCSDPHValPoS      NUMERIC(19,6)
DECLARE @CCZadaneDPHValPoS NUMERIC(19,6)
DECLARE @SlevaSkupZbo      NUMERIC(19,6) -- slevy
DECLARE @SlevaZboKmen      NUMERIC(19,6)
DECLARE @SlevaZboSklad     NUMERIC(19,6)
DECLARE @SlevaOrg          NUMERIC(19,6)
DECLARE @SlevaSozNa        NUMERIC(19,6)
DECLARE @IDZboSklad        INT
DECLARE @NastaveniSlev     INT
DECLARE @DruhPohybuZbo     TINYINT
DECLARE @Nakup             BIT
DECLARE @DruhCU            TINYINT
DECLARE @ZadavaneDPH       BIT
DECLARE @HodZadavaneDPH    NUMERIC(19,6)
DECLARE @SazbaSD           NUMERIC(19,6)
DECLARE @SkutSazbaDPH      NUMERIC(19,6)
DECLARE @Mnozstvi          NUMERIC(19,6)
DECLARE @Mena              NVARCHAR(3)
DECLARE @Kurz              NUMERIC(19,6)
DECLARE @JednotkaMeny      INT
DECLARE @KurzEuro          NUMERIC(19,6)
DECLARE @PrepocetMJSD      NUMERIC(19,6)
DECLARE @PrepMnozstvi      FLOAT
DECLARE @SlevaTermin       NUMERIC(19,6)
DECLARE @SlevaCastka       NUMERIC(19,6)
DECLARE @KoefDPH           BIT           -- zaokrouhlit koeficient DPH
DECLARE @DatumZrusKoefDPH  DATETIME      -- datum zruseni koeficientu DPH
DECLARE @DatumRozhodne     DATETIME      -- rozhodne datum na dokladu
DECLARE @ZemeDPH           NVARCHAR(3)   -- zeme DPH dle hlavicky dokladu
DECLARE @CastkaRecyk       NUMERIC(19,6) -- souhrnna castka recyklacniho prispevku (historicky+garancni)
DECLARE @SamoVySazbaDPH       NUMERIC(5,2)
DECLARE @SamoVyDPHZaklad      NUMERIC(19,6)
DECLARE @SamoVyDPHCastka      NUMERIC(19,6)
DECLARE @SamoVyDPHZakladHM    NUMERIC(19,6)
DECLARE @SamoVyDPHCastkaHM    NUMERIC(19,6)
DECLARE @SamoVyDPHRucneZadano BIT
DECLARE @RezimKurzuDPHFaktur  INT
SELECT
@IDDoklad             = P.IDDoklad,
@VstupniCena          = ISNULL(@VstupniCena, P.VstupniCena),
@JCBezDaniKc          = P.JCBezDaniKc,
@JCSSDKc              = P.JCSSDKc,
@JCSDPHKc             = P.JCSDPHKc,
@JCZadaneDPHKc        = P.JCZadaneDPHKc,
@CCBezDaniKc          = P.CCBezDaniKc,
@CCSSDKc              = P.CCSSDKc,
@CCSDPHKc             = P.CCSDPHKc,
@CCZadaneDPHKc        = P.CCZadaneDPHKc,
@JCBezDaniVal         = P.JCBezDaniVal,
@JCSSDVal             = P.JCSSDVal,
@JCSDPHVal            = P.JCSDPHVal,
@JCZadaneDPHVal       = P.JCZadaneDPHVal,
@CCBezDaniVal         = P.CCBezDaniVal,
@CCSSDVal             = P.CCSSDVal,
@CCSDPHVal            = P.CCSDPHVal,
@CCZadaneDPHVal       = P.CCZadaneDPHVal,
@JCBezDaniKcPoS       = P.JCBezDaniKcPoS,
@JCSSDKcPoS           = P.JCSSDKcPoS,
@JCSDPHKcPoS          = P.JCSDPHKcPoS,
@JCZadaneDPHKcPoS     = P.JCZadaneDPHKcPoS,
@CCBezDaniKcPoS       = P.CCBezDaniKcPoS,
@CCSSDKcPoS           = P.CCSSDKcPoS,
@CCSDPHKcPoS          = P.CCSDPHKcPoS,
@CCZadaneDPHKcPoS     = P.CCZadaneDPHKcPoS,
@JCBezDaniValPoS      = P.JCBezDaniValPoS,
@JCSSDValPoS          = P.JCSSDValPoS,
@JCSDPHValPoS         = P.JCSDPHValPoS,
@JCZadaneDPHValPoS    = P.JCZadaneDPHValPoS,
@CCBezDaniValPoS      = P.CCBezDaniValPoS,
@CCSSDValPoS          = P.CCSSDValPoS,
@CCSDPHValPoS         = P.CCSDPHValPoS,
@CCZadaneDPHValPoS    = P.CCZadaneDPHValPoS,
@SlevaSkupZbo         = P.SlevaSkupZbo,
@SlevaZboKmen         = P.SlevaZboKmen,
@SlevaZboSklad        = P.SlevaZboSklad,
@SlevaOrg             = P.SlevaOrg,
@SlevaSozNa           = P.SlevaSozNa,
@IDZboSklad           = P.IDZboSklad,
@NastaveniSlev        = P.NastaveniSlev,
@DruhPohybuZbo        = P.DruhPohybuZbo,
@SazbaSD              = P.SazbaSD,
@SkutSazbaDPH         = P.SazbaDPH,
@Mnozstvi             = P.Mnozstvi,
@Mena                 = P.Mena,
@Kurz                 = P.Kurz,
@JednotkaMeny         = P.JednotkaMeny,
@KurzEuro             = P.KurzEuro,
@PrepocetMJSD         = PSD.PrepocetMJSD,
@CastkaRecyk          = PSD.CastkaRecyk,
@PrepMnozstvi         = P.PrepMnozstvi,
@SlevaTermin          = P.TerminSlevaProc,
@SlevaCastka          = P.SlevaCastka,
@SamoVySazbaDPH       = P.SazbaDPHproPDP,
@SamoVyDPHZaklad      = P.SamoVyDPHZaklad,
@SamoVyDPHCastka      = P.SamoVyDPHCastka,
@SamoVyDPHZakladHM    = P.SamoVyDPHZakladHM,
@SamoVyDPHCastkaHM    = P.SamoVyDPHCastkaHM,
@SamoVyDPHRucneZadano = P.SamoVyDPHRucneZadano
FROM TabPohybyZbozi        AS P
LEFT JOIN TabPohybyZboziSD AS PSD ON PSD.ID = P.ID
WHERE P.ID = @IDPolozky
SELECT
@DruhCU = D.DruhCU,
@SlevyBezRecykl = ISNULL(@SlevyBezRecykl, D.SlevyBezRecykl)
FROM TabPohybyZbozi  AS P
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE P.ID = @IDPolozky
SELECT
@Pozice              = ISNULL(@Pozice,  PoziceZaokrDPH),
@Hranice             = ISNULL(@Hranice, HraniceZaokrDPH),
@RezimKurzuDPHFaktur = OZRezimKurzuDPHFaktur,
@CenyDle             = DohledatCenyDle,
@KoefDPH             = FakKoeficientDPH,
@DatumZrusKoefDPH    = DatumZrusKoefDPH
FROM TabHGlob
SET @Nakup = 1 - @DruhCU
EXEC dbo.hp_ObehZbozi_JeZadavaneDPH @IDDoklad, @ZadavaneDPH OUT
IF @ZadavaneDPH = 0
SET @SamoVyDPHRucneZadano = 0
SELECT @HodZadavaneDPH =
CASE @VstupniCena WHEN  0 THEN @JCZadaneDPHKc
WHEN  1 THEN @JCZadaneDPHKc
WHEN  2 THEN @CCZadaneDPHKc
WHEN  3 THEN @CCZadaneDPHKc
WHEN  4 THEN @JCZadaneDPHVal
WHEN  5 THEN @JCZadaneDPHVal
WHEN  6 THEN @CCZadaneDPHVal
WHEN  7 THEN @CCZadaneDPHVal
WHEN  8 THEN @JCZadaneDPHKc
WHEN  9 THEN @CCZadaneDPHKc
WHEN 10 THEN @JCZadaneDPHVal
WHEN 11 THEN @CCZadaneDPHVal
ELSE NULL END
SELECT
@CisloOrg = ISNULL(@CisloOrg,
CASE WHEN ((@CenyDle = 2) AND Prijemce IS NOT NULL) 
THEN Prijemce
ELSE (CASE WHEN ((@CenyDle = 1) AND MistoUrceni IS NOT NULL) THEN MistoUrceni ELSE CisloOrg END) END),
@SlevaDokladu       = ISNULL(@SlevaDokladu,      -Sleva),
@ZaokrDPHValuty     = ISNULL(@ZaokrDPHValuty,     ZaokrDPHValuty),
@ZaokrDPHMalaCisla  = ISNULL(@ZaokrDPHMalaCisla,  ZaokrDPHMalaCisla),
@SamoVyMnoKurzDPH   = ISNULL(@SamoVyMnoKurzDPH,   SamoVyMnoKurzDPH),
@SamoVyKurzDPH      = ISNULL(@SamoVyKurzDPH,      SamoVyKurzDPH),
@SamoVyMnoKurzDPHHM = ISNULL(@SamoVyMnoKurzDPHHM, SamoVyMnoKurzDPHHM),
@SamoVyKurzDPHHM    = ISNULL(@SamoVyKurzDPHHM,    SamoVyKurzDPHHM),
@SamoVyMenaDPH   = CASE WHEN @SamoVyMenaDPH   = '' THEN SamoVyMenaDPH   ELSE @SamoVyMenaDPH END,
@SamoVyMenaDPHHM = CASE WHEN @SamoVyMenaDPHHM = '' THEN SamoVyMenaDPHHM ELSE @SamoVyMenaDPHHM END,
@DatumRozhodne   = ISNULL(DUZP, DatPorizeni),
@ZemeDPH         = ZemeDPH
FROM TabDokladyZbozi WHERE ID = @IDDoklad
IF EXISTS(SELECT * FROM TabDokZboDodatek WHERE IDHlavicky = @IDDoklad)
SELECT
@KoefDPH = KoeficientDPH,
@RezimKurzuDPHFaktur = RezimKurzuDPHFaktur
FROM TabDokZboDodatek
WHERE IDHlavicky = @IDDoklad
IF @KoefDPH = 1 AND
(@DatumRozhodne IS NULL OR @DatumRozhodne >= @DatumZrusKoefDPH)
SET @KoefDPH = 0
IF ABS(@PrepMnozstvi) < 1E-12
SET @PrepMnozstvi = 1 ELSE
SET @PrepMnozstvi = 1 / @PrepMnozstvi
EXEC dbo.hp_VypCenOZPolozek @VstupniCena,
@JCBezDaniKc     OUT, @JCSSDKc     OUT, @JCSDPHKc     OUT, @JCZadaneDPHKc     OUT,
@CCBezDaniKc     OUT, @CCSSDKc     OUT, @CCSDPHKc     OUT, @CCZadaneDPHKc     OUT,
@JCBezDaniVal    OUT, @JCSSDVal    OUT, @JCSDPHVal    OUT, @JCZadaneDPHVal    OUT,
@CCBezDaniVal    OUT, @CCSSDVal    OUT, @CCSDPHVal    OUT, @CCZadaneDPHVal    OUT,
@JCBezDaniKcPoS  OUT, @JCSSDKcPoS  OUT, @JCSDPHKcPoS  OUT, @JCZadaneDPHKcPoS  OUT,
@CCBezDaniKcPoS  OUT, @CCSSDKcPoS  OUT, @CCSDPHKcPoS  OUT, @CCZadaneDPHKcPoS  OUT,
@JCBezDaniValPoS OUT, @JCSSDValPoS OUT, @JCSDPHValPoS OUT, @JCZadaneDPHValPoS OUT,
@CCBezDaniValPoS OUT, @CCSSDValPoS OUT, @CCSDPHValPoS OUT, @CCZadaneDPHValPoS OUT,
@SlevaSkupZbo OUT, @SlevaZboKmen OUT, @SlevaZboSklad OUT, @SlevaOrg OUT, @SlevaSozNa OUT, @SlevaDokladu,
@CisloOrg, @IDZboSklad, @NastaveniSlev, @DruhPohybuZbo,
@SazbaSD, @SkutSazbaDPH, @Mnozstvi,
@Mena, @Kurz, @JednotkaMeny, @KurzEuro, @AktualizaceSlev, @ZadavaneDPH, 0, @Pozice, @Hranice, @ZaokrDPHvaluty,
@PrepocetMJSD, @PrepMnozstvi, @SlevaTermin, @SlevaCastka, @ZaokrDPHMalaCisla, @ZpusobKurzu,
@SamoVyMnoKurzDPH, @SamoVyKurzDPH,
@SamoVyMnoKurzDPHHM, @SamoVyKurzDPHHM,
@SamoVySazbaDPH, @SamoVyMenaDPH, @SamoVyMenaDPHHM,
@SamoVyDPHZaklad OUT, @SamoVyDPHCastka OUT,
@SamoVyDPHZakladHM OUT, @SamoVyDPHCastkaHM OUT, @KoefDPH,
@SamoVyDPHRucneZadano OUT, @RezimKurzuDPHFaktur, @Nakup,
@DatumZrusKoefDPH, @DatumRozhodne, @ZemeDPH, DEFAULT, @SlevyBezRecykl, @CastkaRecyk
IF @HodZadavaneDPH IS NULL
SELECT
@JCZadaneDPHKc     = NULL,
@CCZadaneDPHKc     = NULL,
@JCZadaneDPHVal    = NULL,
@CCZadaneDPHVal    = NULL,
@JCZadaneDPHKcPoS  = NULL,
@CCZadaneDPHKcPoS  = NULL,
@JCZadaneDPHValPoS = NULL,
@CCZadaneDPHValPoS = NULL
IF (@DoTempTab = 1) AND (OBJECT_ID(N'tempdb..#TabPolozkyOZ') IS NOT NULL)
INSERT INTO #TabPolozkyOZ
(ID, JCBezDaniKc,     JCSSDKc,     JCSDPHKc,     CCBezDaniKc,     CCSSDKc,     CCSDPHKc,
JCBezDaniVal,    JCSSDVal,    JCSDPHVal,    CCBezDaniVal,    CCSSDVal,    CCSDPHVal,
JCBezDaniKcPoS,  JCSSDKcPoS,  JCSDPHKcPoS,  CCBezDaniKcPoS,  CCSSDKcPoS,  CCSDPHKcPoS,
JCBezDaniValPoS, JCSSDValPoS, JCSDPHValPoS, CCBezDaniValPoS, CCSSDValPoS, CCSDPHValPoS,
JCZadaneDPHKc,    CCZadaneDPHKc,    JCZadaneDPHVal,    CCZadaneDPHVal,
JCZadaneDPHKcPoS, CCZadaneDPHKcPoS, JCZadaneDPHValPoS, CCZadaneDPHValPoS,
SlevaSkupZbo, SlevaZboKmen, SlevaZboSklad, SlevaOrg, SlevaSozNa, SazbaDPHproPDP,
SamoVyDPHRucneZadano, SamoVyDPHZaklad, SamoVyDPHCastka,
SamoVyDPHZakladHM, SamoVyDPHCastkaHM)
SELECT
@IDPolozky,
@JCBezDaniKc,     @JCSSDKc,     @JCSDPHKc,     @CCBezDaniKc,     @CCSSDKc,     @CCSDPHKc,
@JCBezDaniVal,    @JCSSDVal,    @JCSDPHVal,    @CCBezDaniVal,    @CCSSDVal,    @CCSDPHVal,
@JCBezDaniKcPoS,  @JCSSDKcPoS,  @JCSDPHKcPoS,  @CCBezDaniKcPoS,  @CCSSDKcPoS,  @CCSDPHKcPoS,
@JCBezDaniValPoS, @JCSSDValPoS, @JCSDPHValPoS, @CCBezDaniValPoS, @CCSSDValPoS, @CCSDPHValPoS,
@JCZadaneDPHKc,    @CCZadaneDPHKc,    @JCZadaneDPHVal,    @CCZadaneDPHVal,
@JCZadaneDPHKcPoS, @CCZadaneDPHKcPoS, @JCZadaneDPHValPoS, @CCZadaneDPHValPoS,
@SlevaSkupZbo, @SlevaZboKmen, @SlevaZboSklad, @SlevaOrg, @SlevaSozNa, @SamoVySazbaDPH,
@SamoVyDPHRucneZadano, @SamoVyDPHZaklad, @SamoVyDPHCastka,
@SamoVyDPHZakladHM, @SamoVyDPHCastkaHM
ELSE
UPDATE TabPohybyZbozi SET
JCBezDaniKc          = @JCBezDaniKc,
JCSSDKc              = @JCSSDKc,
JCSDPHKc             = @JCSDPHKc,
JCZadaneDPHKc        = @JCZadaneDPHKc,
CCBezDaniKc          = @CCBezDaniKc,
CCSSDKc              = @CCSSDKc,
CCSDPHKc             = @CCSDPHKc,
CCZadaneDPHKc        = @CCZadaneDPHKc,
JCBezDaniVal         = @JCBezDaniVal,
JCSSDVal             = @JCSSDVal,
JCSDPHVal            = @JCSDPHVal,
JCZadaneDPHVal       = @JCZadaneDPHVal,
CCBezDaniVal         = @CCBezDaniVal,
CCSSDVal             = @CCSSDVal,
CCSDPHVal            = @CCSDPHVal,
CCZadaneDPHVal       = @CCZadaneDPHVal,
JCBezDaniKcPoS       = @JCBezDaniKcPoS,
JCSSDKcPoS           = @JCSSDKcPoS,
JCSDPHKcPoS          = @JCSDPHKcPoS,
JCZadaneDPHKcPoS     = @JCZadaneDPHKcPoS,
CCBezDaniKcPoS       = @CCBezDaniKcPoS,
CCSSDKcPoS           = @CCSSDKcPoS,
CCSDPHKcPoS          = @CCSDPHKcPoS,
CCZadaneDPHKcPoS     = @CCZadaneDPHKcPoS,
JCBezDaniValPoS      = @JCBezDaniValPoS,
JCSSDValPoS          = @JCSSDValPoS,
JCSDPHValPoS         = @JCSDPHValPoS,
JCZadaneDPHValPoS    = @JCZadaneDPHValPoS,
CCBezDaniValPoS      = @CCBezDaniValPoS,
CCSSDValPoS          = @CCSSDValPoS,
CCSDPHValPoS         = @CCSDPHValPoS,
CCZadaneDPHValPoS    = @CCZadaneDPHValPoS,
SlevaSkupZbo         = @SlevaSkupZbo,
SlevaZboKmen         = @SlevaZboKmen,
SlevaZboSklad        = @SlevaZboSklad,
SlevaOrg             = @SlevaOrg,
SlevaSozNa           = @SlevaSozNa,
SazbaDPHproPDP       = @SamoVySazbaDPH,
SamoVyDPHRucneZadano = @SamoVyDPHRucneZadano,
SamoVyDPHZaklad      = @SamoVyDPHZaklad,
SamoVyDPHCastka      = @SamoVyDPHCastka,
SamoVyDPHZakladHM    = @SamoVyDPHZakladHM,
SamoVyDPHCastkaHM    = @SamoVyDPHCastkaHM
WHERE ID = @IDPolozky
GO
