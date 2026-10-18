-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_insert_polozky_oz]
@IDENT      INT OUT,     -- 1. ID vytvorene polozky
@IDDoklad   INT,         -- 2. ID hlavicky
@DruhPohybu INT,         -- 3. druh pohybu zbozi
@CisloOrg   INT,         -- 4. organizace pro hlidani dokladu i cenotvorbu
@IDZboSklad INT,         -- 5. skladova karta
@Mena     NVARCHAR(3),   -- 6. mena dle hlavicky dokladu
@Kurz     NUMERIC(19,6), -- 7. kurz dle hlavicky
@JednotkaMeny INT,       -- 8. jednotka meny
@KurzEuro NUMERIC(19,6), -- 9. kurz euro
@SazbaSD  NUMERIC(19,6), -- 10. sazba spotrebni dane
@SazbaDPH NUMERIC(19,6), -- 11. sazba DPH
@ZakazanoDPH TINYINT,    -- 12. zakazane plneni DPH
@VstupniCena INT,        -- 13. druh vstupni ceny
@Kolik              INT = NULL, -- 14. mnozstvi dle skladu
@PovolitDuplicitu   BIT = 0,    -- 15. lze opakovany vyber polozky
@PovolitBlokovane   BIT = 0,    -- 16. lze blokovane zbozi
@Mnozstvi NUMERIC(19,6) = NULL, -- 17. mnozstvi polozky
@IDObalovanePolozky INT = NULL, -- 18. obalovana polozka
@Selectem           BIT = 0,    -- 19. provest INSERT ci vratit hodnoty SELECTem
@JCbezDaniKC NUMERIC(19,6) = 0, -- 20. stanovena cena
@VstupniCenaProPrepocet INT = NULL, -- 21. druh stanovene ceny
@DotahovatSazby         BIT = 1,    -- 22. dotahovat sazby DPH a SD ze kmene ci ceniku
@SlevaDokladu NUMERIC(19,6) = NULL, -- 23.
@Nabidka                INT = NULL, -- 24.
@DatPorizeni       DATETIME = NULL, -- 25.
@MJ            NVARCHAR(10) = NULL, -- 26.
@HlidanoProOrg BIT = 0,      -- 27. hlidat pro organizaci CisloOrg
@OrgProCeny INT = NULL,      -- 28. odlisna organizace pro cenotvorbu
@IDOZTxtPol INT = NULL,      -- 29. kolekce zbozi na dokladu
@DICDPH NVARCHAR(15) = NULL, -- 30. DIC vlastni organizace dle zalozky 7 na FaP
@DUZP      DATETIME  = NULL, -- 31. DUZP dle hlavicky dokladu
@IDDanKlic    INT    = NULL, -- 32. Danovy klic
@Nakup        BIT    = NULL, -- 33. Cenotvorba 0=vystup=prodej / 1=vstup=nakup
@IDOldPolozka INT    = NULL  -- 34. zdrojova polozka pri prevodech

AS

DECLARE @Hmotnost     NUMERIC(19,6)
DECLARE @SkupZbo      NVARCHAR(3)
DECLARE @RegCis       NVARCHAR(30)
DECLARE @Nazev1       NVARCHAR(100)
DECLARE @Nazev2       NVARCHAR(100)
DECLARE @Nazev3       NVARCHAR(100)
DECLARE @Nazev4       NVARCHAR(100)
DECLARE @NazevSozna1  NVARCHAR(100)
DECLARE @NazevSozna2  NVARCHAR(100)
DECLARE @NazevSozna3  NVARCHAR(100)
DECLARE @IDAkce       INT
DECLARE @IDKodPDP     INT
DECLARE @SKP          NVARCHAR(50)
DECLARE @MJCenik      NVARCHAR(10)  -- MJ pro hledani v ceniku
DECLARE @MJEvidence   NVARCHAR(10)  -- evidencni MJ dle kmene
DECLARE @MJOut        NVARCHAR(10)  -- vystupni ci evidencni MJ dle kmene
DECLARE @MJIn         NVARCHAR(10)  -- vstupni  ci evidencni MJ dle kmene
DECLARE @DPHPrenesPov BIT           -- prenesena danova povinnost-dle TabKmenZbozi
DECLARE @DPHPrenesNew BIT           -- prenesena danova povinnost-dle TabSazbyDPHZbo,Sku
DECLARE @Samovymereni BIT           -- samovymereni na rade dokladu
DECLARE @DPHproPDP    NUMERIC(19,6) -- sazba DPH pro PDP a samovymereni
DECLARE @JCsDPHKc     NUMERIC(19,6)
DECLARE @JCbezDaniVal NUMERIC(19,6)
DECLARE @JCsDPHVal    NUMERIC(19,6)
DECLARE @JCsSDKc      NUMERIC(19,6)
DECLARE @JCsSDVal     NUMERIC(19,6)
DECLARE @SmerMJ       INT -- smer pro urceni MJ          0=IN / 1=OUT / NULL=evidencni
DECLARE @Vystup       BIT -- je druh pohybu vystupni?    0=IN / 1=OUT
DECLARE @Vstup        BIT -- je druh pohybu vstupni?     1=IN / 0=OUT
DECLARE @Platna       BIT -- sazba DPH je platna pro zemi a datum
DECLARE @IDKmenZbozi  INT -- kmenova karta
DECLARE @Poradi       INT
DECLARE @CU           INT
DECLARE @Cena                 NUMERIC(19,6)
DECLARE @AltCena              NUMERIC(19,6)
DECLARE @Nalezeno             BIT
DECLARE @BarCode              NVARCHAR(50)
DECLARE @SazbaDPHNew          NUMERIC(5,2)
DECLARE @DruhSazbyDPH         TINYINT
DECLARE @IDDanRezim           INT
DECLARE @SmerPlneniDPH        TINYINT
DECLARE @Datum                DATETIME    -- datum k urceni DPH, tedy DUZP / datum pripadu
DECLARE @Zeme                 NVARCHAR(3) -- zeme DPH
DECLARE @ObvyklaZemePuvodu    NVARCHAR(2)
DECLARE @ObvyklyKodPreference NVARCHAR(3)
DECLARE @DotahovatHistorickeCeny BIT
DECLARE @ObvyklaCenavCM       NUMERIC(19,6)
DECLARE @TerminSleva_Nazev    NVARCHAR(50)
DECLARE @TerminSleva_Procento NUMERIC(19,6)
DECLARE @UplatnitSlevy        BIT
DECLARE @NastaveniSlev        SMALLINT
DECLARE @InsertCisloOrg       INT
DECLARE @ErrStr               NVARCHAR(2047)
DECLARE @IDUmisteni           INT
DECLARE @PlnitStandard        BIT  -- pole umisteni plnit standardni metodikou
DECLARE @Cit                  NUMERIC(19,6) --  citatel   pro stanoveni vztahu MJ
DECLARE @Jme                  NUMERIC(19,6) -- jmenovatel pro stanoveni vztahu MJ
DECLARE @EET_dic_poverujiciho NVARCHAR(12)
DECLARE @StavEET              TINYINT
DECLARE @DruhEET              TINYINT
DECLARE @DruhCU               TINYINT
SET @IDENT = NULL
IF @Selectem = 0
IF NOT EXISTS(SELECT * FROM TabJC WHERE IDStavSkladu = @IDZboSklad)
INSERT TabJC(IDStavSkladu, JCPrijem) VALUES(@IDZboSklad, 0)
IF @DruhPohybu IN(0,1,5,6,7,16,18,19,24,25)
SET @Vystup = 0 ELSE
SET @Vystup = 1
SET @SmerMJ  = @Vystup
IF (@DruhPohybu = 4 AND EXISTS(
SELECT * FROM TabHGlob WHERE MjVydejEvCena = 0))
SET @SmerMJ = NULL
SET @Vstup = 1 - @Vystup
SET @OrgProCeny = ISNULL (@OrgProCeny, @CisloOrg)
IF @DruhPohybu = 4 SET @VstupniCena = 0
SELECT @IDKmenZbozi = IDKmenZbozi FROM TabStavSkladu WHERE ID = @IDZboSklad
SELECT
@DPHPrenesPov = DPHPrenesPov,
@MJEvidence   = MJEvidence,
@IDKodPDP     = IDKodPDP,
@MJOut = ISNULL(MJVystup, MJEvidence),
@MJIn  = ISNULL(MJVstup,  MJEvidence)
FROM TabKmenZbozi
WHERE ID = @IDKmenZbozi
IF @PovolitBlokovane = 0 AND EXISTS(
SELECT * FROM TabStavSkladu AS S
JOIN TabKmenZbozi AS K ON K.ID = S.IDKmenZbozi
WHERE S.ID = @IDZboSklad
AND (S.Blokovano = 1 OR K.Blokovano = 1))
BEGIN
SET @ErrStr = dbo.hf_FormatError(70331, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF @PovolitDuplicitu = 0 AND EXISTS(
SELECT * FROM TabPohybyZbozi AS P
WHERE P.IDZboSklad = @IDZboSklad AND P.IDDoklad = @IDDoklad)
BEGIN
SET @ErrStr = dbo.hf_FormatError(70330, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF @Mnozstvi IS NULL
BEGIN
IF @Kolik IS NULL
SET @Mnozstvi = 0
ELSE
IF @Kolik = 0
SET @Mnozstvi = 1
ELSE
BEGIN
SELECT @Mnozstvi = (CASE WHEN @Kolik = 1 THEN MnozstviDispo ELSE Mnozstvi END)
FROM TabStavSkladu WHERE ID = @IDZboSklad
IF @Mnozstvi <= 0
BEGIN
IF @Kolik = 1
BEGIN
SET @ErrStr = dbo.hf_FormatError(70328, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
ELSE
BEGIN
SET @ErrStr = dbo.hf_FormatError(70329, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
END
END
SET @IDAkce = NULL
SET @UplatnitSlevy = 1
SET @NastaveniSlev = 4681
SELECT @DICDPH = ISNULL(@DICDPH, SamoVyDICDPH),
@Zeme   = ZemeDPH,
@Datum  = ISNULL(ISNULL(ISNULL(@DUZP, @DatPorizeni), DUZP), DatPorizeni),
@IDDanRezim = IDDanovyRezim,
@StavEET    = StavEET,
@DruhCU     = DruhCU
FROM TabDokladyZbozi
WHERE ID = @IDDoklad
IF @Nakup IS NULL
SET @Nakup = 1 - @DruhCU
EXEC dbo.hp_EET_Vrat_Druh_a_DicPoverujiciho
@StavEET, @IdZboSklad, @EET_dic_poverujiciho OUT, @DruhEET OUT
IF @DotahovatSazby = 1
BEGIN
SELECT
@SazbaDPH = CASE WHEN @Vystup = 1 THEN ISNULL(K.SazbaDPHVystup, @SazbaDPH)
ELSE CASE WHEN @Vystup = 0 THEN ISNULL(K.SazbaDPHVstup,  @SazbaDPH)
ELSE @SazbaDPH END END,
@SazbaSD  = K.SazbaSDVystup
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON S.IDKmenZbozi = K.ID
WHERE S.ID = @IDZboSklad
EXEC dbo.hp_GetSazbuDPH
@SazbaDPHNew OUT, @DruhSazbyDPH OUT, @DPHPrenesNew OUT,
@DruhPohybu, @IDKmenZbozi, NULL, @Zeme, @Datum, @DICDPH,
NULL, 0, @CisloOrg
IF @SazbaDPHNew IS NOT NULL
BEGIN
SET @SazbaDPH     = @SazbaDPHNew
SET @DPHPrenesPov = @DPHPrenesNew
END ELSE
BEGIN
SET @DruhSazbyDPH = NULL
IF @SazbaDPH IS NOT NULL
SELECT @DruhSazbyDPH = DruhSazbyDPH
FROM TabSazbyDPH
WHERE SazbaDPH = @SazbaDPH
AND ISOKodZeme = @Zeme
AND ISNULL(PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(PlatnostDo,  '99991231 23:59:59.997') >= @Datum
AND ISNULL(DatUkonceni, '99991231 23:59:59.997') >= @Datum
EXEC hp_TestSazbuDPH
@SazbaDPH, NULL, @Platna OUT, @Zeme, @Datum, @DICDPH
IF @Platna = 0
BEGIN
SET @SazbaDPH = NULL
SET @DruhSazbyDPH = NULL
END
END
END
IF NOT EXISTS(
SELECT *
FROM TabCisOrg AS O
JOIN TabDICOrg AS D ON D.CisloOrg = O.CisloOrg AND D.DIC = O.DIC
WHERE O.CisloOrg = @CisloOrg
AND D.AktualniDICNeplatce = 0)
SET @DPHPrenesPov = 0
SELECT
@Hmotnost = K.Hmotnost, @SkupZbo = K.SkupZbo, @RegCis = K.RegCis,
@Nazev1 = K.Nazev1, @Nazev2 = K.Nazev2,
@Nazev3 = K.Nazev3, @Nazev4 = K.Nazev4,
@SKP = K.SKP,
@MJ = ISNULL(@MJ, CASE WHEN @SmerMJ = 1 THEN @MJOut
ELSE CASE WHEN @SmerMJ = 0 THEN @MJIn
ELSE @MJEvidence END END)
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON S.IDKmenZbozi = K.ID
WHERE S.ID = @IDZboSklad
IF @VstupniCenaProPrepocet IS NULL
BEGIN
DECLARE @VC INT, @Cenik_SazbaSD NUMERIC(19,6), @Cenik_SazbaDPH NUMERIC(5,2)
SET @VC = @VstupniCena
EXEC dbo.hp_VratJC @VC OUT
SET @MJCenik = ISNULL(@MJ, @MJOut)
SET @Cenik_SazbaSD = @SazbaSD
SET @Cenik_SazbaDPH = @SazbaDPH
EXEC dbo.hp_HodnotyProPolozkuZCeniku
@IDDoklad, @DruhPohybu, @OrgProCeny, @IdZboSklad, @Nabidka,
@VC, @Mnozstvi, 0, @DatPorizeni, @IDAkce OUT, @UplatnitSlevy OUT, 0, @Nalezeno OUT,
@Cena OUT, @MJCenik OUT, @Cenik_SazbaDPH OUT, @Cenik_SazbaSD OUT, NULL, 0, @Nakup
IF @UplatnitSlevy = 0 SET @NastaveniSlev = 18724
IF @Nalezeno = 1
BEGIN
IF @DotahovatSazby = 1 AND @SazbaDPH IS NULL
SET @SazbaDPH = @Cenik_SazbaDPH
IF @DotahovatSazby = 1 OR @SazbaSD IS NULL
SET @SazbaSD = @Cenik_SazbaSD
IF @MJ IS NULL AND @MJCenik IS NOT NULL
SET @MJ = @MJCenik
IF @VC =  0 SET @JCbezDaniKC  = @Cena ELSE SET @JCbezDaniKC  = 0
IF @VC =  1 SET @JCsDPHKc     = @Cena ELSE SET @JCsDPHKc     = 0
IF @VC =  4 SET @JCbezDaniVal = @Cena ELSE SET @JCbezDaniVal = 0
IF @VC =  5 SET @JCsDPHVal    = @Cena ELSE SET @JCsDPHVal    = 0
IF @VC =  8 SET @JCsSDKc      = @Cena ELSE SET @JCsSDKc      = 0
IF @VC = 10 SET @JCsSDVal     = @Cena ELSE SET @JCsSDVal     = 0
SET @VstupniCenaProPrepocet = @VC
SET @DotahovatSazby = 0
END
ELSE
BEGIN
IF @SmerMJ = 1 SET @MJCenik = @MJOut ELSE
IF @SmerMJ = 0 SET @MJCenik = @MJIn  ELSE
SET @MJCenik = NULL
SET @DotahovatHistorickeCeny = 0
IF @SmerMJ = 1 AND EXISTS(
SELECT * FROM TabHGlob WHERE HistorickeCenyProdej = N'A')
SET @DotahovatHistorickeCeny = 1
IF @SmerMJ = 0 AND EXISTS(
SELECT * FROM TabHGlob WHERE HistorickeCenyNakup = N'A')
SET @DotahovatHistorickeCeny = 1
IF @SmerMJ IN(0,1)
EXEC dbo.hp_DotahniNabidkovouCenuNew NULL, @OrgProCeny, @IDZboSklad, @Mena,
@JCbezDaniKC  OUT, @JCsDPHKc  OUT,
@JCbezDaniVal OUT, @JCsDPHVal OUT,
@JCsSDKc      OUT, @JCsSDVal  OUT,
@VstupniCenaProPrepocet OUT, NULL, 0, @DotahovatHistorickeCeny,
DEFAULT, @AltCena OUT, @TerminSleva_Nazev OUT, @TerminSleva_Procento OUT,
DEFAULT, DEFAULT, @Nakup, @MJ
END
END
IF (@MJ IS NOT NULL) AND (@MJCenik IS NOT NULL) AND (@MJ <> @MJCenik)
BEGIN
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCbezDaniKC  OUT, 1, 0, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCsDPHKc     OUT, 1, 0, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCbezDaniVal OUT, 1, 0, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCsDPHVal    OUT, 1, 0, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCsSDKc      OUT, 1, 0, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @JCsSDVal     OUT, 1, 0, @IDKmenZbozi, @Vstup
END
SELECT
@IDAkce = ISNULL(@IDAkce, S.IDAkce),
@ObvyklaZemePuvodu    = K.ObvyklaZemePuvodu,
@ObvyklyKodPreference = K.ObvyklyKodPreference,
@ObvyklaCenavCM       = ObvyklaCenavCM
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON S.IDKmenZbozi = K.ID
WHERE S.ID = @IDZboSklad
IF @ZakazanoDPH = 1
BEGIN
SET @DPHproPDP = NULL
SET @SazbaDPH  = NULL
END
ELSE
IF @ZakazanoDPH = 2
BEGIN
SET @DPHproPDP = NULL
SET @SazbaDPH  = 0
END
ELSE
BEGIN
SET @DPHproPDP = NULL
SELECT @Samovymereni = CASE WHEN R.OsvobozenaPlneni = 3 THEN 1 ELSE 0 END
FROM TabDruhDokZbo   AS R
JOIN TabDokladyZbozi AS D ON R.RadaDokladu = D.RadaDokladu
AND R.DruhPohybuZbo = @DruhPohybu
WHERE D.ID = @IDDoklad
IF (@DPHPrenesPov = 1 OR @Samovymereni = 1) AND
@DruhPohybu IN (0,1,2,3,4,6,9,10,11,13,14,18,19)
BEGIN
SET @DPHproPDP = @SazbaDPH
IF @Vystup = 0 SET @SazbaDPH = NULL
IF @Vystup = 1 SET @SazbaDPH = 0
END
END
IF @Samovymereni = 1 SET @SmerPlneniDPH = 2 ELSE
IF @DPHprenesPov = 1 SET @SmerPlneniDPH = 3 ELSE
SET @SmerPlneniDPH = @Vystup
IF @IDDanKlic IS NULL
EXEC hp_OZGetDanKlicPolo
@IDDanKlic OUT, @SmerPlneniDPH, @IDDanRezim, @SazbaDPH, @Zeme, @Datum, @IDDoklad
EXEC dbo.hp_DotahniPopisy
@CisloOrg, @IDZboSklad, @NazevSozna1 OUT, @NazevSozna2 OUT, @NazevSozna3 OUT, 0
IF @VstupniCenaProPrepocet IS NULL
BEGIN
SET @VstupniCenaProPrepocet = @VstupniCena
EXEC dbo.hp_VratJC @VstupniCena OUT
END
IF @DruhPohybu = 24
BEGIN
IF ISNULL(@JCBezDaniVal, 0) = 0 AND ISNULL(@ObvyklaCenavCM, 0) <> 0
SET @JCBezDaniVal = @ObvyklaCenavCM
END
EXEC dbo.hp_ZjistiVztahMJ @MJEvidence, @MJ,
NULL, NULL, @IDKmenZbozi, @Vstup, @Cit OUT, @Jme OUT
IF @Cit IS NULL
BEGIN
SET @ErrStr = N'50229'+NCHAR(13)+@MJ+NCHAR(9)+
N'70216'+NCHAR(13)+@MJ+NCHAR(13)+@MJEvidence
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
SET @Hmotnost = ISNULL(@Mnozstvi * @Hmotnost, 0)
EXEC dbo.hp_PrepoctiDleMJ @MJ, @MJEvidence, @Hmotnost OUT, 1, 1, @IDKmenZbozi, @Vstup
IF @CisloOrg IS NOT NULL
SET @BarCode = (
SELECT TOP 1 B.BarCode
FROM TabBarCodeZbo AS B
JOIN TabStavSkladu AS S ON B.IDKmenZbo = S.IDKmenZbozi
WHERE S.ID = @IDZboSklad AND B.CisloOrg = @CisloOrg
ORDER BY B.Prednastaveno DESC, B.Porizeno DESC)
IF @BarCode IS NULL AND @CisloOrg IS NOT NULL
SET @BarCode = (
SELECT TOP 1 TabSozNa.BarCode
FROM TabSozNa
JOIN TabCisOrg ON TabCisOrg.IDSOZnazev = TabSozNa.IDSoz
JOIN TabStavSkladu ON TabStavSkladu.IDKmenZbozi = TabSozNa.IDKmenZbo
WHERE TabStavSkladu.ID = @IDZboSklad AND TabCisOrg.CisloOrg = @CisloOrg)
IF @BarCode IS NULL
SET @BarCode = (
SELECT TOP 1 B.BarCode
FROM TabBarCodeZbo AS B
JOIN TabStavSkladu AS S ON B.IDKmenZbo = S.IDKmenZbozi
WHERE S.ID = @IDZboSklad
ORDER BY B.Prednastaveno DESC, B.Porizeno DESC)
SET @IDUmisteni = NULL
SET @PlnitStandard = 1
IF OBJECT_ID(N'dbo.ep_OZGetUmistInsPol','P')IS NOT NULL
BEGIN
EXEC dbo.ep_OZGetUmistInsPol
@IDDoklad, @DruhPohybu, @IDZboSklad, @IDUmisteni OUT, @PlnitStandard OUT
END
IF @PlnitStandard = 1
BEGIN
IF @DruhPohybu IN (0,1,5,6,7,18,19,24,25)
SELECT @IDUmisteni = ID
FROM TabVStavUmisteni
WHERE Prednastaveno = 1 AND IDStav = @IDZboSklad
ELSE
IF @DruhPohybu IN (2,3,4,8,9,10,11,13,14,15,26,27)
SELECT TOP 1 @IDUmisteni = UP.IDUmisteni
FROM TabUmisteniPrijem AS UP
JOIN TabPohybyZbozi    AS PZ ON PZ.ID = UP.IDPohybu
WHERE PZ.IDZboSklad = @IDZboSklad AND UP.Mnozstvi > 0
ORDER BY UP.ID
END
IF NOT EXISTS(SELECT *
FROM TabCisKoduPDP
WHERE ID = @IDKodPDP
AND Zeme = @Zeme
AND ISNULL(DatumOd, @Datum) <= @Datum
AND ISNULL(DatumDo, @Datum) >= @Datum)
SET @IDKodPDP = NULL
SELECT @Poradi = ISNULL(MAX(Poradi) + 1, 1)
FROM TabPohybyZbozi
WHERE IDDoklad = @IDDoklad
AND ISNULL(IDOZTxtPol,0) = ISNULL(@IDOZTxtPol,0)
SET @SazbaSD = ISNULL(@SazbaSD, 0)
IF @Selectem = 0
BEGIN
IF @HlidanoProOrg = 1
SET @InsertCisloOrg = @CisloOrg
ELSE
SET @InsertCisloOrg = NULL
DECLARE @TrCount INT
SET @TrCount = @@TRANCOUNT
IF @TrCount = 0 BEGIN TRANSACTION
INSERT TabPohybyZbozi
(IDDoklad, Poradi, DruhPohybuZbo, CisloOrg, IDZboSklad,
Mena, Kurz, JednotkaMeny, KurzEuro,
SazbaSD, SazbaDPH, SazbaDPHproPDP, DruhSazbyDPH, VstupniCena,
SkupZbo, RegCis, Nazev1, Nazev2, Nazev3, Nazev4,
NazevSozna1, NazevSozna2, NazevSozna3, IDAkce, SKP, MJ, MJEvidence,
JCBezDaniKc, JCSDPHKc, JCBezDaniVal, JCSDPHVal, JCsSDKc, JCsSDVal,
NastaveniSlev, Mnozstvi, Obal,
Hmotnost, ZemePuvodu, ZemePreference, AltCena,
TerminSlevaNazev, TerminSlevaProc, BarCode, IDUmisteni, IDOZTxtPol,
IDKodPDP, IDDanovyKlic, IDOldPolozka, EET_dic_poverujiciho, DruhEET)
VALUES
(@IDDoklad, @Poradi, @DruhPohybu, @InsertCisloOrg, @IDZboSklad,
@Mena, @Kurz, @JednotkaMeny, @KurzEuro,
@SazbaSD, @SazbaDPH, @DPHproPDP, @DruhSazbyDPH, @VstupniCena,
@SkupZbo, @RegCis, @Nazev1, @Nazev2, @Nazev3, @Nazev4,
ISNULL(@NazevSozna1,''), ISNULL(@NazevSozna2,''), ISNULL(@NazevSozna3,''),
@IDAkce, @SKP, @MJ, @MJEvidence,
ISNULL(@JCBezDaniKc,0), ISNULL(@JCSDPHKc,0), ISNULL(@JCBezDaniVal,0), ISNULL(@JCSDPHVal,0),
ISNULL(@JCsSDKc,0), ISNULL(@JCsSDVal,0), @NastaveniSlev, @Mnozstvi, @IDObalovanePolozky,
@Hmotnost, @ObvyklaZemePuvodu, @ObvyklyKodPreference, ISNULL(@AltCena,0),
ISNULL(@TerminSleva_Nazev,''), ISNULL(@TerminSleva_Procento,0),
@BarCode, @IDUmisteni, @IDOZTxtPol,
@IDKodPDP, @IDDanKlic, @IDOldPolozka, @EET_dic_poverujiciho, @DruhEET)
IF @@ERROR <> 0
BEGIN
IF @TrCount = 0 ROLLBACK
RETURN
END
/* získání ID řádku
DECLARE @Exec NVARCHAR(500)
SET @Exec = N'SELECT @xIDENT = Scope_Identity FROM #TabTempUziv WHERE Tabulka = N''TabPohybyZbozi'''
EXEC sp_executesql @Exec, N'@xIDENT INT OUTPUT', @IDENT OUTPUT
*/
SET @IDENT = SCOPE_IDENTITY()

IF @@ERROR <> 0
BEGIN
IF @TrCount = 0 ROLLBACK
SET @IDENT = NULL
RETURN
END
EXEC dbo.hp_OsetriPohybySD @IDENT,0,0, @MJ
EXEC dbo.hp_VypCenOZPolozek_IDPolozky
@IDENT, 1, NULL, NULL, @VstupniCenaProPrepocet, @SlevaDokladu, @OrgProCeny
EXEC hp_CopyExtAtributy
@IDKmenZbozi, @IDENT, N'TabKmenZbozi', N'TabPohybyZbozi'
EXEC hp_CopyExtAtributy
@IDZboSklad, @IDENT, N'TabStavSkladu', N'TabPohybyZbozi'
IF @@ERROR<>0
BEGIN
IF @TrCount = 0 ROLLBACK
SET @IDENT = NULL
RETURN
END
IF @TrCount = 0 COMMIT
END
ELSE
SELECT
@SkupZbo                   AS SkupZbo,
@RegCis                    AS RegCis,
@Nazev1                    AS Nazev1,
@Nazev2                    AS Nazev2,
@Nazev3                    AS Nazev3,
@Nazev4                    AS Nazev4,
ISNULL(@NazevSozna1,'')  AS NazevSozna1,
ISNULL(@NazevSozna2,'')  AS NazevSozna2,
ISNULL(@NazevSozna3,'')  AS NazevSozna3,
@IDAkce                    AS IDAkce,
@SKP                       AS SKP,
@MJ                        AS MJ,
@MJEvidence                AS MJEvidence,
ISNULL(@JCBezDaniKc,0)     AS JCBezDaniKc,
ISNULL(@JCSDPHKc,0)        AS JCSDPHKc,
ISNULL(@JCBezDaniVal,0)    AS JCBezDaniVal,
ISNULL(@JCSDPHVal,0)       AS JCSDPHVal,
ISNULL(@JCsSDKc,0)         AS JCsSDKc,
ISNULL(@JCsSDVal,0)        AS JCsSDVal,
@VstupniCenaProPrepocet    AS VCProPrepocet,
@SazbaSD                   AS SazbaSD,
@SazbaDPH                  AS SazbaDPH,
@NastaveniSlev             AS NastaveniSlev,
@ObvyklaZemePuvodu         AS ObvyklaZemePuvodu,
@ObvyklyKodPreference      AS ObvyklyKodPreference,
@Mnozstvi                  AS Mnozstvi,
ISNULL(@AltCena,0)         AS AltCena,
@Hmotnost                  AS Hmotnost,
ISNULL(@TerminSleva_Nazev,'') AS TerminSlevaNazev,
ISNULL(@TerminSleva_Procento,0) AS TerminSlevaProc,
@BarCode                   AS BarCode,
@IDUmisteni                AS IDUmisteni,
@DPHproPDP                 AS SazbaDPHproPDP,
@Poradi                    AS Poradi,
@DruhSazbyDPH              AS DruhSazbyDPH,
@IDKodPDP                  AS IDKodPDP,
@IDDanKlic                 AS IDDanovyKlic,
@EET_dic_poverujiciho      AS EET_dic_poverujiciho,
@DruhEET                   AS DruhEET
GO
