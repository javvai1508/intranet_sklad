-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_PohybyZbozi_Modify] ON [dbo].[TabPohybyZbozi]
FOR INSERT, UPDATE, DELETE
AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @Upd_IDOldPolozka      BIT = 0
DECLARE @Upd_Mnozstvi          BIT = 0
DECLARE @Upd_MJ                BIT = 0
DECLARE @Upd_SazbaDPH          BIT = 0
DECLARE @Upd_SazbaDPHproPDP    BIT = 0
DECLARE @Upd_IDDanovyKlic      BIT = 0
DECLARE @Upd_IDZboSklad        BIT = 0
DECLARE @Upd_IDDoklad          BIT = 0
DECLARE @Upd_MnOdebrane        BIT = 0
DECLARE @Upd_MnFakOdebrane     BIT = 0
DECLARE @Upd_MnozstviReal      BIT = 0
DECLARE @Upd_SplnenoPol        BIT = 0
DECLARE @Upd_CCEvid            BIT = 0
DECLARE @Upd_VraceneMnozstvi   BIT = 0
DECLARE @Upd_SkutDatRealMnoz   BIT = 0
DECLARE @Upd_CCbezDaniKcPoS    BIT = 0
DECLARE @Upd_Hmotnost          BIT = 0
DECLARE @Upd_IDUmisteni        BIT = 0
DECLARE @Upd_NastaveniSlev     BIT = 0
DECLARE @Upd_SlevaZboKmen      BIT = 0
DECLARE @Upd_JCbezDaniKc       BIT = 0
DECLARE @Upd_CCbezDaniKc       BIT = 0
DECLARE @Upd_JCbezDaniVal      BIT = 0
DECLARE @Upd_CCbezDaniVal      BIT = 0
DECLARE @Upd_JCsDPHKc          BIT = 0
DECLARE @Upd_CCsDPHKc          BIT = 0
DECLARE @Upd_JCsDPHVal         BIT = 0
DECLARE @Upd_CCsDPHVal         BIT = 0
DECLARE @Upd_JCsSDKC           BIT = 0
DECLARE @Upd_CCsSDKC           BIT = 0
DECLARE @Upd_JCsSDVal          BIT = 0
DECLARE @Upd_CCsSDVal          BIT = 0
DECLARE @Upd_CCSSDKcPoS        BIT = 0
DECLARE @Upd_CCsDPHKcPoS       BIT = 0
DECLARE @Upd_CCSSDValPoS       BIT = 0
DECLARE @Upd_CCsDPHValPoS      BIT = 0
DECLARE @Upd_SamoVyDPHZaklad   BIT = 0
DECLARE @Upd_SamoVyDPHCastka   BIT = 0
DECLARE @Upd_SamoVyDPHZakladHM BIT = 0
DECLARE @Upd_SamoVyDPHCastkaHM BIT = 0
DECLARE @Upd_IDPrikaz          BIT = 0
DECLARE @Upd_Mena              BIT = 0
DECLARE @Upd_DruhPohybuZbo     BIT = 0
DECLARE @Upd_StredNaklad       BIT = 0
DECLARE @Upd_CisloZakazky      BIT = 0
DECLARE @Upd_IDKodPDP          BIT = 0
DECLARE @Upd_Poznamka          BIT = 0
DECLARE @Upd_SkupZbo           BIT = 0
DECLARE @Upd_Nazev1            BIT = 0
DECLARE @Upd_RegCis            BIT = 0
DECLARE @Upd_BarCode           BIT = 0
IF UPDATE(IDOldPolozka)      SET @Upd_IDOldPolozka = 1
IF UPDATE(Mnozstvi)          SET @Upd_Mnozstvi = 1
IF UPDATE(MJ)                SET @Upd_MJ = 1
IF UPDATE(SazbaDPH)          SET @Upd_SazbaDPH = 1
IF UPDATE(SazbaDPHproPDP)    SET @Upd_SazbaDPHproPDP = 1
IF UPDATE(IDDanovyKlic)      SET @Upd_IDDanovyKlic = 1
IF UPDATE(IDZboSklad)        SET @Upd_IDZboSklad = 1
IF UPDATE(IDDoklad)          SET @Upd_IDDoklad = 1
IF UPDATE(MnOdebrane)        SET @Upd_MnOdebrane = 1
IF UPDATE(MnFakOdebrane)     SET @Upd_MnFakOdebrane = 1
IF UPDATE(MnozstviReal)      SET @Upd_MnozstviReal = 1
IF UPDATE(SplnenoPol)        SET @Upd_SplnenoPol = 1
IF UPDATE(CCEvid)            SET @Upd_CCEvid = 1
IF UPDATE(VraceneMnozstvi)   SET @Upd_VraceneMnozstvi = 1
IF UPDATE(SkutDatRealMnoz)   SET @Upd_SkutDatRealMnoz = 1
IF UPDATE(CCbezDaniKcPoS)    SET @Upd_CCbezDaniKcPoS = 1
IF UPDATE(Hmotnost)          SET @Upd_Hmotnost = 1
IF UPDATE(IDUmisteni)        SET @Upd_IDUmisteni = 1
IF UPDATE(NastaveniSlev)     SET @Upd_NastaveniSlev = 1
IF UPDATE(SlevaZboKmen)      SET @Upd_SlevaZboKmen = 1
IF UPDATE(JCbezDaniKc)       SET @Upd_JCbezDaniKc = 1
IF UPDATE(CCbezDaniKc)       SET @Upd_CCbezDaniKc = 1
IF UPDATE(JCbezDaniVal)      SET @Upd_JCbezDaniVal = 1
IF UPDATE(CCbezDaniVal)      SET @Upd_CCbezDaniVal = 1
IF UPDATE(JCsDPHKc)          SET @Upd_JCsDPHKc = 1
IF UPDATE(CCsDPHKc)          SET @Upd_CCsDPHKc = 1
IF UPDATE(JCsDPHVal)         SET @Upd_JCsDPHVal = 1
IF UPDATE(CCsDPHVal)         SET @Upd_CCsDPHVal = 1
IF UPDATE(JCsSDKC)           SET @Upd_JCsSDKC = 1
IF UPDATE(CCsSDKC)           SET @Upd_CCsSDKC = 1
IF UPDATE(JCsSDVal)          SET @Upd_JCsSDVal = 1
IF UPDATE(CCsSDVal)          SET @Upd_CCsSDVal = 1
IF UPDATE(CCSSDKcPoS)        SET @Upd_CCSSDKcPoS = 1
IF UPDATE(CCsDPHKcPoS)       SET @Upd_CCsDPHKcPoS = 1
IF UPDATE(CCSSDValPoS)       SET @Upd_CCSSDValPoS = 1
IF UPDATE(CCsDPHValPoS)      SET @Upd_CCsDPHValPoS = 1
IF UPDATE(SamoVyDPHZaklad)   SET @Upd_SamoVyDPHZaklad = 1
IF UPDATE(SamoVyDPHCastka)   SET @Upd_SamoVyDPHCastka = 1
IF UPDATE(SamoVyDPHZakladHM) SET @Upd_SamoVyDPHZakladHM = 1
IF UPDATE(SamoVyDPHCastkaHM) SET @Upd_SamoVyDPHCastkaHM = 1
IF UPDATE(IDPrikaz)          SET @Upd_IDPrikaz = 1
IF UPDATE(Mena)              SET @Upd_Mena = 1
IF UPDATE(DruhPohybuZbo)     SET @Upd_DruhPohybuZbo = 1
IF UPDATE(StredNaklad)       SET @Upd_StredNaklad = 1
IF UPDATE(CisloZakazky)      SET @Upd_CisloZakazky = 1
IF UPDATE(IDKodPDP)          SET @Upd_IDKodPDP = 1
IF UPDATE(Poznamka)          SET @Upd_Poznamka = 1
IF UPDATE(SkupZbo)           SET @Upd_SkupZbo = 1
IF UPDATE(Nazev1)            SET @Upd_Nazev1 = 1
IF UPDATE(RegCis)            SET @Upd_RegCis = 1
IF UPDATE(BarCode)           SET @Upd_BarCode = 1
DECLARE @INSERTED htyp_InsertedDeletedTriggerPohybyZboziModify
INSERT @INSERTED (
ID, IDZboSklad, IDOldPolozka,
DruhPohybuZbo, IDDoklad, MJ,
Mnozstvi, MnOdebrane, MnozOdebrane,
PrepMnozstvi, MnozstviReal, SplnenoPol,
MnozstviStorno, SazbaSD, VraceneMnozstvi,
SkutDatRealMnoz, AVAReferenceID, Mena,
CCsDPHVal, CCsDPHValPoS, CCsSDValPoS,
CCsSDVal, JCsDPHVal, JCsSDVal,
StredNaklad, CisloZakazky, IDKodPDP,
Poznamka, SazbaDPH, SazbaDPHproPDP,
SkupZbo, Nazev1, RegCis,
BarCode, IdUmisteni,
CisloOrg, Poradi, NastaveniSlev,
SlevaZboKmen, JCbezDaniKc, CCbezDaniKc,
JCbezDaniVal, CCbezDaniVal, JCsDPHKc,
CCsDPHKc, JCsSDKC, CCsSDKC,
CCEvid, DokladPrikazu, IDPrikaz,
TypVyrobnihoDokladu
)
SELECT
ID, IDZboSklad, IDOldPolozka,
DruhPohybuZbo, IDDoklad, MJ,
Mnozstvi, MnOdebrane, MnozOdebrane,
PrepMnozstvi, MnozstviReal, SplnenoPol,
MnozstviStorno, SazbaSD, VraceneMnozstvi,
SkutDatRealMnoz, AVAReferenceID, Mena,
CCsDPHVal, CCsDPHValPoS, CCsSDValPoS,
CCsSDVal, JCsDPHVal, JCsSDVal,
StredNaklad, CisloZakazky, IDKodPDP,
Poznamka, SazbaDPH, SazbaDPHproPDP,
SkupZbo, Nazev1, RegCis,
BarCode, IdUmisteni,
CisloOrg, Poradi, NastaveniSlev,
SlevaZboKmen, JCbezDaniKc, CCbezDaniKc,
JCbezDaniVal, CCbezDaniVal, JCsDPHKc,
CCsDPHKc, JCsSDKC, CCsSDKC,
CCEvid, DokladPrikazu, IDPrikaz,
TypVyrobnihoDokladu
FROM INSERTED
DECLARE @DELETED htyp_InsertedDeletedTriggerPohybyZboziModify
INSERT @DELETED (
ID, IDZboSklad, IDOldPolozka,
DruhPohybuZbo, IDDoklad, MJ,
Mnozstvi, MnOdebrane, MnozOdebrane,
PrepMnozstvi, MnozstviReal, SplnenoPol,
MnozstviStorno, SazbaSD, VraceneMnozstvi,
SkutDatRealMnoz, AVAReferenceID, Mena,
CCsDPHVal, CCsDPHValPoS, CCsSDValPoS,
CCsSDVal, JCsDPHVal, JCsSDVal,
StredNaklad, CisloZakazky, IDKodPDP,
Poznamka, SazbaDPH, SazbaDPHproPDP,
SkupZbo, Nazev1, RegCis,
BarCode, IdUmisteni,
CisloOrg, Poradi, NastaveniSlev,
SlevaZboKmen, JCbezDaniKc, CCbezDaniKc,
JCbezDaniVal, CCbezDaniVal, JCsDPHKc,
CCsDPHKc, JCsSDKC, CCsSDKC,
CCEvid, DokladPrikazu, IDPrikaz,
TypVyrobnihoDokladu
)
SELECT
ID, IDZboSklad, IDOldPolozka,
DruhPohybuZbo, IDDoklad, MJ,
Mnozstvi, MnOdebrane, MnozOdebrane,
PrepMnozstvi, MnozstviReal, SplnenoPol,
MnozstviStorno, SazbaSD, VraceneMnozstvi,
SkutDatRealMnoz, AVAReferenceID, Mena,
CCsDPHVal, CCsDPHValPoS, CCsSDValPoS,
CCsSDVal, JCsDPHVal, JCsSDVal,
StredNaklad, CisloZakazky, IDKodPDP,
Poznamka, SazbaDPH, SazbaDPHproPDP,
SkupZbo, Nazev1, RegCis,
BarCode, IdUmisteni,
CisloOrg, Poradi, NastaveniSlev,
SlevaZboKmen, JCbezDaniKc, CCbezDaniKc,
JCbezDaniVal, CCbezDaniVal, JCsDPHKc,
CCsDPHKc, JCsSDKC, CCsSDKC,
CCEvid, DokladPrikazu, IDPrikaz,
TypVyrobnihoDokladu
FROM DELETED
EXEC dbo.hp_TriggerPohybyZboziModify
@INSERTED,
@DELETED,
@Upd_IDOldPolozka,
@Upd_Mnozstvi,
@Upd_MJ,
@Upd_SazbaDPH,
@Upd_SazbaDPHproPDP,
@Upd_IDDanovyKlic,
@Upd_IDZboSklad,
@Upd_IDDoklad,
@Upd_MnOdebrane,
@Upd_MnFakOdebrane,
@Upd_MnozstviReal,
@Upd_SplnenoPol,
@Upd_CCEvid,
@Upd_VraceneMnozstvi,
@Upd_SkutDatRealMnoz,
@Upd_CCbezDaniKcPoS,
@Upd_Hmotnost,
@Upd_IDUmisteni,
@Upd_NastaveniSlev,
@Upd_SlevaZboKmen,
@Upd_JCbezDaniKc,
@Upd_CCbezDaniKc,
@Upd_JCbezDaniVal,
@Upd_CCbezDaniVal,
@Upd_JCsDPHKc,
@Upd_CCsDPHKc,
@Upd_JCsDPHVal,
@Upd_CCsDPHVal,
@Upd_JCsSDKC,
@Upd_CCsSDKC,
@Upd_JCsSDVal,
@Upd_CCsSDVal,
@Upd_CCSSDKcPoS,
@Upd_CCsDPHKcPoS,
@Upd_CCSSDValPoS,
@Upd_CCsDPHValPoS,
@Upd_SamoVyDPHZaklad,
@Upd_SamoVyDPHCastka,
@Upd_SamoVyDPHZakladHM,
@Upd_SamoVyDPHCastkaHM,
@Upd_IDPrikaz
IF EXISTS(
SELECT ModelId
FROM TabAVARegisteredModels
WHERE DataDirection IN (0,2)
)
EXEC dbo.hp_PohybyZbozi_AVAModel_Change
@INSERTED,
@DELETED,
@Upd_Mena,
@Upd_CCsDPHVal,
@Upd_CCsDPHValPoS,
@Upd_CCsSDValPoS,
@Upd_CCsSDVal,
@Upd_DruhPohybuZbo,
@Upd_JCsDPHVal,
@Upd_JCsSDVal,
@Upd_StredNaklad,
@Upd_CisloZakazky,
@Upd_IDKodPDP,
@Upd_Poznamka,
@Upd_Mnozstvi,
@Upd_MJ,
@Upd_SazbaDPH,
@Upd_SazbaDPHproPDP,
@Upd_IDZboSklad,
@Upd_SkupZbo,
@Upd_Nazev1,
@Upd_RegCis,
@Upd_BarCode,
@Upd_IdUmisteni
GO
