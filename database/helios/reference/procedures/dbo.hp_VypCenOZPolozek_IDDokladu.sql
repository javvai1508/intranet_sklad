-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_VypCenOZPolozek_IDDokladu]
@IDDoklad        INT,
@AktualizaceSlev BIT,
@AktualizovatMarzi BIT = 1  -- provest aktualizaci marze
AS
SET NOCOUNT ON
DECLARE @IDPolozka          INT
DECLARE @Pozice             INT     -- pozice  zaokrouhleni DPH
DECLARE @Hranice            INT     -- hranice zaokrouhleni DPH
DECLARE @ZaokrDPHvaluty     TINYINT -- zaokrouhlit DPH ve valutach
DECLARE @ZaokrDPHMalaCisla  TINYINT -- zaokrouhlit DPH i pro male castky
DECLARE @DohledatCenyDle    TINYINT -- ocenit dle organizace / mista urceni
DECLARE @CisloOrg           INT     -- cislo organizace
DECLARE @CisloOrgProCenu    INT     -- cislo organizace urcene pro cenu
DECLARE @ZpusobKurzu        TINYINT -- zpusob chapani kurzu
DECLARE @SlevyBezRecykl     BIT     -- aplikuj vypocet slev na ceny bez recyklacniho prispevku
DECLARE @SamoVyMnoKurzDPH   NUMERIC(19,6)
DECLARE @SamoVyKurzDPH      NUMERIC(19,6)
DECLARE @SamoVyMnoKurzDPHHM NUMERIC(19,6)
DECLARE @SamoVyKurzDPHHM    NUMERIC(19,6)
DECLARE @SamoVyMenaDPH      NVARCHAR(3)
DECLARE @SamoVyMenaDPHHM    NVARCHAR(3)
SELECT
@Pozice             = PoziceZaokrDPH,
@Hranice            = HraniceZaokrDPH,
@ZaokrDPHvaluty     = ZaokrDPHvaluty,
@ZaokrDPHMalaCisla  = ZaokrDPHMalaCisla,
@SlevyBezRecykl     = SlevyBezRecykl,
@SamoVyMenaDPH      = SamoVyMenaDPH,
@SamoVyMenaDPHHM    = SamoVyMenaDPHHM,
@SamoVyMnoKurzDPH   = SamoVyMnoKurzDPH,
@SamoVyKurzDPH      = SamoVyKurzDPH,
@SamoVyMnoKurzDPHHM = SamoVyMnoKurzDPHHM,
@SamoVyKurzDPHHM    = SamoVyKurzDPHHM
FROM TabDokladyZbozi
WHERE ID = @IDDoklad
SELECT @DohledatCenyDle = DohledatCenyDle FROM TabHGlob
SET @CisloOrg = NULL
SELECT @CisloOrg = CisloOrg,
@CisloOrgProCenu = CASE WHEN @DohledatCenyDle = 2 THEN Prijemce ELSE
(CASE WHEN @DohledatCenyDle = 1 THEN MistoUrceni ELSE CisloOrg END) END
FROM TabDokladyZbozi WHERE ID = @IDDoklad
EXEC dbo.hp_OZEurGetZpusobKurzu @IDDoklad, 0, @ZpusobKurzu OUT
IF (OBJECT_ID(N'tempdb..#TabPolozkyOZ') IS NOT NULL) DROP TABLE #TabPolozkyOZ
CREATE TABLE #TabPolozkyOZ(
Id INT,
JCBezDaniKc     NUMERIC(19,6), JCSSDKc     NUMERIC(19,6), JCSDPHKc     NUMERIC(19,6),
CCBezDaniKc     NUMERIC(19,6), CCSSDKc     NUMERIC(19,6), CCSDPHKc     NUMERIC(19,6),
JCBezDaniVal    NUMERIC(19,6), JCSSDVal    NUMERIC(19,6), JCSDPHVal    NUMERIC(19,6),
CCBezDaniVal    NUMERIC(19,6), CCSSDVal    NUMERIC(19,6), CCSDPHVal    NUMERIC(19,6),
JCBezDaniKcPoS  NUMERIC(19,6), JCSSDKcPoS  NUMERIC(19,6), JCSDPHKcPoS  NUMERIC(19,6),
CCBezDaniKcPoS  NUMERIC(19,6), CCSSDKcPoS  NUMERIC(19,6), CCSDPHKcPoS  NUMERIC(19,6),
JCBezDaniValPoS NUMERIC(19,6), JCSSDValPoS NUMERIC(19,6), JCSDPHValPoS NUMERIC(19,6),
CCBezDaniValPoS NUMERIC(19,6), CCSSDValPoS NUMERIC(19,6), CCSDPHValPoS NUMERIC(19,6),
JCZadaneDPHKc     NUMERIC(19,6), CCZadaneDPHKc     NUMERIC(19,6),
JCZadaneDPHVal    NUMERIC(19,6), CCZadaneDPHVal    NUMERIC(19,6),
JCZadaneDPHKcPoS  NUMERIC(19,6), CCZadaneDPHKcPoS  NUMERIC(19,6),
JCZadaneDPHValPoS NUMERIC(19,6), CCZadaneDPHValPoS NUMERIC(19,6),
SlevaSkupZbo NUMERIC(5,2), SlevaZboKmen NUMERIC(5,2), SlevaZboSklad NUMERIC(5,2),
SlevaOrg NUMERIC(5,2), SlevaSozNa NUMERIC(5,2), SazbaDPHproPDP NUMERIC(5,2),
SamoVyDPHRucneZadano BIT,
SamoVyDPHZaklad NUMERIC(19,6), SamoVyDPHCastka NUMERIC(19,6),
SamoVyDPHZakladHM NUMERIC(19,6), SamoVyDPHCastkaHM NUMERIC(19,6)
)
IF (OBJECT_ID(N'tempdb..#TabPolozkyOZTXT') IS NOT NULL) DROP TABLE #TabPolozkyOZTXT
CREATE TABLE #TabPolozkyOZTXT(
Id INT,
JCBezDaniKc NUMERIC(19,6), JCSDPHKc NUMERIC(19,6),
CCBezDaniKc NUMERIC(19,6), CCSDPHKc NUMERIC(19,6),
JCBezDaniVal NUMERIC(19,6), JCSDPHVal NUMERIC(19,6),
CCBezDaniVal NUMERIC(19,6), CCSDPHVal NUMERIC(19,6),
JCBezDaniKcPoS NUMERIC(19,6), JCSDPHKcPoS NUMERIC(19,6),
CCBezDaniKcPoS NUMERIC(19,6), CCSDPHKcPoS NUMERIC(19,6),
JCBezDaniValPoS NUMERIC(19,6), JCSDPHValPoS NUMERIC(19,6),
CCBezDaniValPoS NUMERIC(19,6), CCSDPHValPoS NUMERIC(19,6),
SlevaProcentni NUMERIC(5,2),
SazbaDPHproPDP NUMERIC(5,2),
SamoVyDPHRucneZadano BIT,
SamoVyDPHZaklad NUMERIC(19,6), SamoVyDPHCastka NUMERIC(19,6),
SamoVyDPHZakladHM NUMERIC(19,6), SamoVyDPHCastkaHM NUMERIC(19,6)
)
DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
SELECT ID FROM TabPohybyZbozi WHERE IDDoklad = @IDDoklad
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDPolozka
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_VypCenOZPolozek_IDPolozky
@IDPolozky          = @IDPolozka,
@AktualizaceSlev    = @AktualizaceSlev,
@Pozice             = @Pozice,
@Hranice            = @Hranice,
@ZaokrDPHvaluty     = @ZaokrDPHvaluty,
@ZaokrDPHMalaCisla  = @ZaokrDPHMalaCisla,
@CisloOrg           = @CisloOrgProCenu,
@ZpusobKurzu        = @ZpusobKurzu,
@DoTempTab          = 1,
@SamoVyMenaDPH      = @SamoVyMenaDPH,
@SamoVyMenaDPHHM    = @SamoVyMenaDPHHM,
@SamoVyMnoKurzDPH   = @SamoVyMnoKurzDPH,
@SamoVyKurzDPH      = @SamoVyKurzDPH,
@SamoVyMnoKurzDPHHM = @SamoVyMnoKurzDPHHM,
@SamoVyKurzDPHHM    = @SamoVyKurzDPHHM,
@SlevyBezRecykl     = @SlevyBezRecykl
END
CLOSE Cur
DEALLOCATE Cur
DECLARE c CURSOR FAST_FORWARD LOCAL FOR
SELECT ID FROM TabOZTxtPol WHERE IDDoklad = @IDDoklad
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c INTO @IDPolozka
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_VypCenOZPolozekTXT_IDPolozky
@IDPolozka, @ZpusobKurzu, @DoTempTab = 1,
@SamoVyMenaDPH      = @SamoVyMenaDPH,
@SamoVyMenaDPHHM    = @SamoVyMenaDPHHM,
@SamoVyMnoKurzDPH   = @SamoVyMnoKurzDPH,
@SamoVyKurzDPH      = @SamoVyKurzDPH,
@SamoVyMnoKurzDPHHM = @SamoVyMnoKurzDPHHM,
@SamoVyKurzDPHHM    = @SamoVyKurzDPHHM
END
CLOSE c
DEALLOCATE c
IF EXISTS(SELECT * FROM #TabPolozkyOZ)
UPDATE TabPohybyZbozi SET
JCBezDaniKc     = T.JCBezDaniKc,     JCSSDKc     = T.JCSSDKc,     JCSDPHKc     = T.JCSDPHKc,
CCBezDaniKc     = T.CCBezDaniKc,     CCSSDKc     = T.CCSSDKc,     CCSDPHKc     = T.CCSDPHKc,
JCBezDaniVal    = T.JCBezDaniVal,    JCSSDVal    = T.JCSSDVal,    JCSDPHVal    = T.JCSDPHVal,
CCBezDaniVal    = T.CCBezDaniVal,    CCSSDVal    = T.CCSSDVal,    CCSDPHVal    = T.CCSDPHVal,
JCBezDaniKcPoS  = T.JCBezDaniKcPoS,  JCSSDKcPoS  = T.JCSSDKcPoS,  JCSDPHKcPoS  = T.JCSDPHKcPoS,
CCBezDaniKcPoS  = T.CCBezDaniKcPoS,  CCSSDKcPoS  = T.CCSSDKcPoS,  CCSDPHKcPoS  = T.CCSDPHKcPoS,
JCBezDaniValPoS = T.JCBezDaniValPoS, JCSSDValPoS = T.JCSSDValPoS, JCSDPHValPoS = T.JCSDPHValPoS,
CCBezDaniValPoS = T.CCBezDaniValPoS, CCSSDValPoS = T.CCSSDValPoS, CCSDPHValPoS = T.CCSDPHValPoS,
JCZadaneDPHKc     = T.JCZadaneDPHKc,     CCZadaneDPHKc     = T.CCZadaneDPHKc,
JCZadaneDPHVal    = T.JCZadaneDPHVal,    CCZadaneDPHVal    = T.CCZadaneDPHVal,
JCZadaneDPHKcPoS  = T.JCZadaneDPHKcPoS,  CCZadaneDPHKcPoS  = T.CCZadaneDPHKcPoS,
JCZadaneDPHValPoS = T.JCZadaneDPHValPoS, CCZadaneDPHValPoS = T.CCZadaneDPHValPoS,
SlevaSkupZbo=T.SlevaSkupZbo, SlevaZboKmen=T.SlevaZboKmen, SlevaZboSklad=T.SlevaZboSklad,
SlevaOrg=T.SlevaOrg, SlevaSozNa=T.SlevaSozNa, SazbaDPHproPDP = T.SazbaDPHproPDP,
SamoVyDPHZaklad = T.SamoVyDPHZaklad, SamoVyDPHCastka = T.SamoVyDPHCastka,
SamoVyDPHZakladHM = T.SamoVyDPHZakladHM, SamoVyDPHCastkaHM = T.SamoVyDPHCastkaHM
,SamoVyDPHRucneZadano = T.SamoVyDPHRucneZadano
FROM TabPohybyZbozi
JOIN #TabPolozkyOZ T ON TabPohybyZbozi.Id = T.Id
IF EXISTS(SELECT * FROM #TabPolozkyOZTXT)
UPDATE TabOZTxtPol SET
JCBezDaniKc=T.JCBezDaniKc, JCSDPHKc=T.JCSDPHKc,
CCBezDaniKc=T.CCBezDaniKc, CCSDPHKc=T.CCSDPHKc,
JCBezDaniVal=T.JCBezDaniVal, JCSDPHVal=T.JCSDPHVal,
CCBezDaniVal=T.CCBezDaniVal, CCSDPHVal=T.CCSDPHVal,
JCBezDaniKcPoS=T.JCBezDaniKcPoS, JCSDPHKcPoS=T.JCSDPHKcPoS,
CCBezDaniKcPoS=T.CCBezDaniKcPoS, CCSDPHKcPoS=T.CCSDPHKcPoS,
JCBezDaniValPoS=T.JCBezDaniValPoS, JCSDPHValPoS=T.JCSDPHValPoS,
CCBezDaniValPoS=T.CCBezDaniValPoS, CCSDPHValPoS=T.CCSDPHValPoS,
JCbezDaniSlevaKc  = T.JCbezDaniKc - T.JCbezDaniKcPoS,
JCsDPHSlevaKc     = T.JCsDPHKc - T.JCsDPHKcPoS,
CCbezDaniSlevaKc  = T.CCbezDaniKc - T.CCbezDaniKcPoS,
CCsDPHSlevaKc     = T.CCsDPHKc - T.CCsDPHKcPoS,
JCbezDaniSlevaVal = T.JCbezDaniVal - T.JCbezDaniValPoS,
JCsDPHSlevaVal    = T.JCsDPHVal - T.JCsDPHValPoS,
CCbezDaniSlevaVal = T.CCbezDaniVal - T.CCbezDaniValPoS,
CCsDPHSlevaVal    = T.CCsDPHVal - T.CCsDPHValPoS,
SlevaProcentni    = T.SlevaProcentni,
SamoVyDPHZaklad = T.SamoVyDPHZaklad, SamoVyDPHCastka = T.SamoVyDPHCastka,
SamoVyDPHZakladHM = T.SamoVyDPHZakladHM, SamoVyDPHCastkaHM = T.SamoVyDPHCastkaHM
,SamoVyDPHRucneZadano = T.SamoVyDPHRucneZadano
FROM TabOZTxtPol
JOIN #TabPolozkyOZTXT T ON TabOZTxtPol.Id = T.Id
IF @AktualizovatMarzi = 1 AND EXISTS(SELECT*FROM TabHGlob WHERE OZMarze=1)
EXEC dbo.hp_VypocitejMarziNaDokladu 1, 0, @IDDoklad, @CisloOrg
IF (OBJECT_ID(N'tempdb..#TabPolozkyOZ') IS NOT NULL) DROP TABLE #TabPolozkyOZ
IF (OBJECT_ID(N'tempdb..#TabPolozkyOZTXT') IS NOT NULL) DROP TABLE #TabPolozkyOZTXT
UPDATE TabDokladyZbozi SET KHDPHDoLimitu = KHDPHDoLimitu WHERE ID = @IDDoklad
GO
