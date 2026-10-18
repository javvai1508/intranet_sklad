-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_DokModify] ON [dbo].[TabDokladyZbozi]
FOR UPDATE, INSERT, DELETE
AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE
@Upd_RealizacniFak       BIT = 0,
@Upd_IDPosta             BIT = 0,
@Upd_DatPorizeni         BIT = 0,
@Upd_CisloOrg            BIT = 0,
@Upd_DruhPohybuZbo       BIT = 0,
@Upd_SamoVyDICDPH        BIT = 0,
@Upd_SazbaDPH            BIT = 0,
@Upd_ZemeDPH             BIT = 0,
@Upd_DUZP                BIT = 0,
@Upd_IDDanovyRezim       BIT = 0,
@Upd_BlokovaniEditoru    BIT = 0,
@Upd_StavRezervace       BIT = 0,
@Upd_SumaKc              BIT = 0,
@Upd_SumaVal             BIT = 0,
@Upd_SNCelkemDokl        BIT = 0,
@Upd_Splneno             BIT = 0,
@Upd_StavPrevodu         BIT = 0,
@Upd_NavaznyDoklad       BIT = 0,
@Upd_NavaznyDobropis     BIT = 0,
@Upd_DatRealizace        BIT = 0,
@Upd_DatUctovani         BIT = 0,
@Upd_AutorUctovani       BIT = 0,
@Upd_UKod                BIT = 0,
@Upd_Mena                BIT = 0,
@Upd_Kurz                BIT = 0,
@Upd_JednotkaMeny        BIT = 0,
@Upd_OpravnyDoklad       BIT = 0,
@Upd_FormaUhrady         BIT = 0,
@Upd_Obdobi              BIT = 0,
@Upd_KHDPHDoLimitu       BIT = 0,
@Upd_DIC                 BIT = 0,
@Upd_ZadanaCastkaZaoKc   BIT = 0,
@Upd_CastkaZaoValDoKc    BIT = 0,
@Upd_ZaokrouhleniFak     BIT = 0,
@Upd_NastavPreuctovaniSK BIT = 0,
@Upd_RezimMOSS           BIT = 0,
@Upd_StornoDoklad        BIT = 0,
@Upd_IDBankSpoj          BIT = 0,
@Upd_DatZmeny            BIT = 0,
@Upd_JeToZaloha          BIT = 0
IF UPDATE(RealizacniFak)       SET @Upd_RealizacniFak = 1
IF UPDATE(IDPosta)             SET @Upd_IDPosta = 1
IF UPDATE(DatPorizeni)         SET @Upd_DatPorizeni = 1
IF UPDATE(CisloOrg)            SET @Upd_CisloOrg = 1
IF UPDATE(DruhPohybuZbo)       SET @Upd_DruhPohybuZbo = 1
IF UPDATE(SamoVyDICDPH)        SET @Upd_SamoVyDICDPH = 1
IF UPDATE(SazbaDPH)            SET @Upd_SazbaDPH = 1
IF UPDATE(ZemeDPH)             SET @Upd_ZemeDPH = 1
IF UPDATE(DUZP)                SET @Upd_DUZP = 1
IF UPDATE(IDDanovyRezim)       SET @Upd_IDDanovyRezim = 1
IF UPDATE(BlokovaniEditoru)    SET @Upd_BlokovaniEditoru = 1
IF UPDATE(StavRezervace)       SET @Upd_StavRezervace = 1
IF UPDATE(SumaKc)              SET @Upd_SumaKc = 1
IF UPDATE(SumaVal)             SET @Upd_SumaVal = 1
IF UPDATE(SNCelkemDokl)        SET @Upd_SNCelkemDokl = 1
IF UPDATE(Splneno)             SET @Upd_Splneno = 1
IF UPDATE(StavPrevodu)         SET @Upd_StavPrevodu = 1
IF UPDATE(NavaznyDoklad)       SET @Upd_NavaznyDoklad = 1
IF UPDATE(NavaznyDobropis)     SET @Upd_NavaznyDobropis = 1
IF UPDATE(DatRealizace)        SET @Upd_DatRealizace = 1
IF UPDATE(DatUctovani)         SET @Upd_DatUctovani = 1
IF UPDATE(AutorUctovani)       SET @Upd_AutorUctovani = 1
IF UPDATE(UKod)                SET @Upd_UKod = 1
IF UPDATE(Mena)                SET @Upd_Mena = 1
IF UPDATE(Kurz)                SET @Upd_Kurz = 1
IF UPDATE(JednotkaMeny)        SET @Upd_JednotkaMeny = 1
IF UPDATE(OpravnyDoklad)       SET @Upd_OpravnyDoklad = 1
IF UPDATE(FormaUhrady)         SET @Upd_FormaUhrady = 1
IF UPDATE(Obdobi)              SET @Upd_Obdobi = 1
IF UPDATE(KHDPHDoLimitu)       SET @Upd_KHDPHDoLimitu = 1
IF UPDATE(DIC)                 SET @Upd_DIC = 1
IF UPDATE(ZadanaCastkaZaoKc)   SET @Upd_ZadanaCastkaZaoKc = 1
IF UPDATE(CastkaZaoValDoKc)    SET @Upd_CastkaZaoValDoKc = 1
IF UPDATE(ZaokrouhleniFak)     SET @Upd_ZaokrouhleniFak = 1
IF UPDATE(NastavPreuctovaniSK) SET @Upd_NastavPreuctovaniSK = 1
IF UPDATE(RezimMOSS)           SET @Upd_RezimMOSS = 1
IF UPDATE(StornoDoklad)        SET @Upd_StornoDoklad = 1
IF UPDATE(IDBankSpoj)          SET @Upd_IDBankSpoj = 1
IF UPDATE(DatZmeny)            SET @Upd_DatZmeny = 1
IF UPDATE(JeToZaloha)          SET @Upd_JeToZaloha = 1
DECLARE @INSERTED htyp_InsertedDeletedTriggerDokModify
INSERT @INSERTED (
ID, DruhPohybuZbo,IDPosta,
RealizacniFak, RadaDokladu, DatRealizace,
DatRealMnoz, PoradoveCislo, DatPorizeni,
CisloOrg, RezimMOSS, ZemeDPH,
SamoVyDICDPH, DUZP, DelkaPorCis,
Mena, FormaUhrady, OpravnyDoklad,
Obdobi, ZaokrouhleniFakVal, Kurz, KurzPripad,
JednotkaMeny, KurzEuro, Kurz_KorZal,
Splneno, HlidanyDoklad, IDBankSpoj,
DatZmeny, JeToZaloha, JeToDDPP,
ZaokrouhleniFak, BlokovaniEditoru, SumaKcPoZao,
KontaktZam, KontaktOsoba, AVAOutputFlag,
AVAReferenceID, DatPovinnostiFa, NavaznaObjednavka,
DatumDoruceni, DodFak, DatumKurzu, Poznamka,
Text1, Text2, Text3, StredNaklad,
NavaznyDobropis, CisloZakazky, DIC, SumaVal,
ZadanaCastkaZaoVal, ZaokrNaPadesat,
SumaValBezDPH, Splatnost, FormaDopravy
)
SELECT
ID, DruhPohybuZbo,IDPosta,
RealizacniFak, RadaDokladu, DatRealizace,
DatRealMnoz, PoradoveCislo, DatPorizeni,
CisloOrg, RezimMOSS, ZemeDPH,
SamoVyDICDPH, DUZP, DelkaPorCis,
Mena, FormaUhrady, OpravnyDoklad,
Obdobi, ZaokrouhleniFakVal, Kurz, KurzPripad,
JednotkaMeny, KurzEuro, Kurz_KorZal,
Splneno, HlidanyDoklad, IDBankSpoj,
DatZmeny, JeToZaloha, JeToDDPP,
ZaokrouhleniFak, BlokovaniEditoru, SumaKcPoZao,
KontaktZam, KontaktOsoba, AVAOutputFlag,
AVAReferenceID, DatPovinnostiFa, NavaznaObjednavka,
DatumDoruceni, DodFak, DatumKurzu, Poznamka,
Text1, Text2, Text3, StredNaklad,
NavaznyDobropis, CisloZakazky, DIC, SumaVal,
ZadanaCastkaZaoVal, ZaokrNaPadesat,
SumaValBezDPH, Splatnost, FormaDopravy
FROM INSERTED
DECLARE @DELETED  htyp_InsertedDeletedTriggerDokModify
INSERT @DELETED (
ID, DruhPohybuZbo,IDPosta,
RealizacniFak, RadaDokladu, DatRealizace,
DatRealMnoz, PoradoveCislo, DatPorizeni,
CisloOrg, RezimMOSS, ZemeDPH,
SamoVyDICDPH, DUZP, DelkaPorCis,
Mena, FormaUhrady, OpravnyDoklad,
Obdobi, ZaokrouhleniFakVal, Kurz, KurzPripad,
JednotkaMeny, KurzEuro, Kurz_KorZal,
Splneno, HlidanyDoklad, IDBankSpoj,
DatZmeny, JeToZaloha, JeToDDPP,
ZaokrouhleniFak, BlokovaniEditoru, SumaKcPoZao,
KontaktZam, KontaktOsoba, AVAOutputFlag,
AVAReferenceID, DatPovinnostiFa, NavaznaObjednavka,
DatumDoruceni, DodFak, DatumKurzu, Poznamka,
Text1, Text2, Text3, StredNaklad,
NavaznyDobropis, CisloZakazky, DIC, SumaVal,
ZadanaCastkaZaoVal, ZaokrNaPadesat,
SumaValBezDPH, Splatnost, FormaDopravy
)
SELECT
ID, DruhPohybuZbo,IDPosta,
RealizacniFak, RadaDokladu, DatRealizace,
DatRealMnoz, PoradoveCislo, DatPorizeni,
CisloOrg, RezimMOSS, ZemeDPH,
SamoVyDICDPH, DUZP, DelkaPorCis,
Mena, FormaUhrady, OpravnyDoklad,
Obdobi, ZaokrouhleniFakVal, Kurz, KurzPripad,
JednotkaMeny, KurzEuro, Kurz_KorZal,
Splneno, HlidanyDoklad, IDBankSpoj,
DatZmeny, JeToZaloha, JeToDDPP,
ZaokrouhleniFak, BlokovaniEditoru, SumaKcPoZao,
KontaktZam, KontaktOsoba, AVAOutputFlag,
AVAReferenceID, DatPovinnostiFa, NavaznaObjednavka,
DatumDoruceni, DodFak, DatumKurzu, Poznamka,
Text1, Text2, Text3, StredNaklad,
NavaznyDobropis, CisloZakazky, DIC, SumaVal,
ZadanaCastkaZaoVal, ZaokrNaPadesat,
SumaValBezDPH, Splatnost, FormaDopravy
FROM DELETED
EXEC hp_loguj 'checkpoint', '', 'EXEC dbo.hp_TriggerDokModify' 
EXEC dbo.hp_TriggerDokModify
@INSERTED,
@DELETED,
@Upd_RealizacniFak,
@Upd_IDPosta,
@Upd_DatPorizeni,
@Upd_CisloOrg,
@Upd_DruhPohybuZbo,
@Upd_SamoVyDICDPH,
@Upd_SazbaDPH,
@Upd_ZemeDPH,
@Upd_DUZP,
@Upd_IDDanovyRezim,
@Upd_BlokovaniEditoru,
@Upd_StavRezervace,
@Upd_SumaKc,
@Upd_SumaVal,
@Upd_SNCelkemDokl,
@Upd_Splneno,
@Upd_StavPrevodu,
@Upd_NavaznyDoklad,
@Upd_NavaznyDobropis,
@Upd_DatRealizace,
@Upd_DatUctovani,
@Upd_AutorUctovani,
@Upd_UKod,
@Upd_Mena,
@Upd_Kurz,
@Upd_JednotkaMeny,
@Upd_OpravnyDoklad,
@Upd_FormaUhrady,
@Upd_Obdobi,
@Upd_KHDPHDoLimitu,
@Upd_DIC,
@Upd_ZadanaCastkaZaoKc,
@Upd_CastkaZaoValDoKc,
@Upd_ZaokrouhleniFak,
@Upd_NastavPreuctovaniSK,
@Upd_RezimMOSS,
@Upd_StornoDoklad,
@Upd_IDBankSpoj,
@Upd_DatZmeny,
@Upd_JeToZaloha
IF EXISTS(
SELECT ModelId
FROM TabAVARegisteredModels
WHERE DataDirection IN (0,2)
)
EXEC hp_DokladyZbozi_AVAModel_Change
@INSERTED,
@DELETED,
@Upd_Mena,
@Upd_Kurz,
@Upd_JednotkaMeny,
@Upd_DatRealizace
GO
