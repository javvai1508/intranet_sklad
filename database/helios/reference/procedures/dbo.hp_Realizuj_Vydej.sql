-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_Realizuj_Vydej]
@ID             INT,      -- ID hlavicky realizovaneho dokladu
@DatumRealizace DATETIME, -- je-li NULL, doplni se GETDATE
@Uzivatel       SMALLINT, -- vyuzit pro BlokovaniEditoru
@Hlidat         BIT,      -- umoznit globalne Zap/Vyp kontrolu hlidani mnozstvi pro organizaci
@BylaChyba      BIT OUT,  -- je-li 0, pak realizace radne probehla
@RealMnoz       BIT = 1,  -- vykonat procesy mnozstevni realizace
@RealFin        BIT = 1   -- vykonat procesy financni realizace
AS
SET NOCOUNT ON
DECLARE @ShodaZakazek   NCHAR(1)      -- povinna shoda zakazek hlavicky a polozky
DECLARE @PrepMJnaVC     BIT           -- prepocet MJ take na VC
DECLARE @OZMarze        BIT           -- zapnuto vyhodnoceni marze
DECLARE @NZB            BIT           -- zapnuto nove zajistovani a blokovani zbozi
DECLARE @DruhSkladuG    TINYINT       -- druh skladu    2=FIFO  3=prumery
DECLARE @DruhSkladSN    TINYINT       -- druh skladu SN 2=FIFO  3=prumery
DECLARE @StoPEdiSN      BIT           -- rucne zadane SN na stornu prijmu
DECLARE @KonStorPrij    TINYINT       -- kontrola storna prijmu  0=na JC  1=na stav skladu
DECLARE @NeaktEvSlo     TINYINT       -- metoda prace se sloupci EvMnozstvi a EvStav
DECLARE @MetodaSkladu   TINYINT       -- metoda skladove evidence: TabJC / TabSkladPrijmy
DECLARE @MetodaEvidCeny TINYINT       -- metoda oceneni: pro IDZboSklad / IDVyrCS
DECLARE @MetodaVCRealKD TINYINT       -- metoda mnozstevních kontrol stavu VC k datu
DECLARE @MnoRealTestMno TINYINT       -- volitelna kontrola dle TabHGlob
DECLARE @UmistMetVyd    BIT           -- metoda vydeje zbozi z umisteni
DECLARE @MakePosun      BIT           -- provest posun casu u data realizace
DECLARE @ZpusobKurzu    TINYINT       -- zpusob chapani kurzu  0=dle CNB  1=dle ECB
DECLARE @DatumSkut      DATETIME      -- skutecne datum realizace pohybu
DECLARE @ZakazkaHlav    NVARCHAR(15)  -- zakazka dle hlavicky dokladu
DECLARE @DruhPohybuZbo  TINYINT       -- druh pohybu zbozi 1=storno prijmu 2,4=vydejky
DECLARE @RadaDokladu    NVARCHAR(3)   -- udaje dle hlavicky
DECLARE @MetodaSD       BIT           -- metoda SD pro vydeje v evidencni cene
DECLARE @IDPohyb        INT           -- ID polozky
DECLARE @IDZboSklad     INT           -- ID skladove karty
DECLARE @IDKmen         INT           -- ID kmenove karty
DECLARE @MJ             NVARCHAR(10)  -- merna jednotka polozky
DECLARE @MJEvid         NVARCHAR(10)  -- evidencni merna jednotka
DECLARE @PrepMnozstvi   FLOAT         -- prepocet mnozstvi na evidencni MJ
DECLARE @Citatel        NUMERIC(19,6) -- vztah jako presny zlomek
DECLARE @Jmenovatel     NUMERIC(19,6) -- vztah jako presny zlomek
DECLARE @KontrolaVC     BIT           -- kontrola VC na kmenove ci skladove karte
DECLARE @InvDoklad      BIT           -- jde o inventurni doklad
DECLARE @Mnozstvi       NUMERIC(19,6) -- mnozstvi na polozce
DECLARE @CCbezDani      NUMERIC(19,6) -- celkova cena na polozce
DECLARE @CCEvidPoz      NUMERIC(19,6) -- pozadovana evidencni cena u storna
DECLARE @CisloZakazky   NVARCHAR(15)  -- cislo zakazky na polozce
DECLARE @CisloOrg       INT           -- hlidana polozka ma vyplnenu organizaci na pohybu
DECLARE @IDUmisteni     INT           -- preferovane umisteni na polozce
DECLARE @StavSkladu     NUMERIC(19,6) -- financni stav skladu pred realizaci
DECLARE @SMnozstvi      NUMERIC(19,6) --   mnozstvi    na sklade pred realizaci
DECLARE @SMnozFinReal   NUMERIC(19,6) -- mnoz fin real na sklade pred realizaci
DECLARE @MnozstviReal   NUMERIC(19,6) -- realizovane mnozstvi v evidencni MJ
DECLARE @DruhSkladu     TINYINT       -- dle priority 1.kmen 2.strom 3.global
DECLARE @CenaC          NUMERIC(19,6) -- vypoctem urcena budouci CCEvid
DECLARE @Hlidano        NUMERIC(19,6) -- hlidane mnozstvi
DECLARE @HlidanoDObj    NUMERIC(19,6) -- hlidane mnozstvi
DECLARE @TrCount        INT           -- pocet transakci
DECLARE @ChybHlaska     NVARCHAR(2000)-- text chyboveho hlaseni
DECLARE @ErrStr         NVARCHAR(2000)-- text chyboveho hlaseni
DECLARE @VysledekProc   INT           -- vysledek kontroly vydeje do minulosti dle stavu k datu
DECLARE @DruMnozstvi    NUMERIC(19,6) -- druhove mnozstvi pro prepocti_pohyb_stav
DECLARE @DruCena        NUMERIC(19,6) -- druhova cena     pro prepocti_pohyb_stav
DECLARE @SSCCMnozstvi   NUMERIC(19,6) -- mnozstvi pro palety
DECLARE @SN1            NUMERIC(19,6) -- souvisejici naklady polozky
DECLARE @SN2            NUMERIC(19,6)
DECLARE @SN3            NUMERIC(19,6)
DECLARE @SN4            NUMERIC(19,6)
DECLARE @SN5            NUMERIC(19,6)
DECLARE @SN6            NUMERIC(19,6)
DECLARE @SN7            NUMERIC(19,6)
DECLARE @Ret            INT           -- navratova hodnota
DECLARE @IDInv          INT           -- ID hlavicky inventury
DECLARE @CisloChyby     INT           -- priznak chyby v procedure pro stanoveni EC
DECLARE @IDPohybuF      INT           -- ID pohybu navazne faktury
DECLARE @NapocitavatDatPoslPrijem BIT   --napocitavat datum posledniho prijmu
DECLARE @NapocitavatDatPoslVydej  BIT   --napocitavat datum posledniho vydaje
DECLARE @UmistNaVydejceOK         BIT
DECLARE @VraceneMnozstvi          NUMERIC(19,6)
DECLARE @HlidatReVydej            BIT   -- globalni nastaveni Kontroluj hlidane mnozstvi pro organizaci pri realizaci 
SET @BylaChyba = 0
EXEC hp_loguj 'checkpoint', '', 'start hp_Realizuj_Vydej' 
EXEC hp_loguj 'checkpoint', '', 'nacteni globalni konfigurace' 
SELECT
@ShodaZakazek   = ShodaZakazek,
@DruhSkladuG    = DruhSkladu,
@DruhSkladSN    = DruhSkladuSN,
@StoPEdiSN      = OZStoPBezEdiSN,
@KonStorPrij    = KontrolaStornaPrijmu,
@NeaktEvSlo     = NeaktEvMnozstviEvStav,
@MetodaSkladu   = MetodaSkladu,
@MetodaEvidCeny = MetodaEvidCeny,
@MetodaVCRealKD = OZMetodaVCRealKD,
@MnoRealTestMno = OZMnoRealTestMnozstvi,
@UmistMetVyd    = OZRozUmiDleVC,
@PrepMJnaVC     = OZPrepMJnaVC,
@OZMarze        = OZMarze,
@NZB            = NZB, 
@HlidatReVydej  = OZHlidatRealizujVydej 
FROM TabHGlob
EXEC hp_loguj 'checkpoint', '', 'nacteni hlavni meny' 
SELECT @ZpusobKurzu = ZpusobKurzu
FROM TabKodMen WHERE HlavniMena = 1
EXEC hp_loguj 'checkpoint', '', 'nacteme hlavickove udaje' 
SELECT
@DruhPohybuZbo = DruhPohybuZbo,
@RadaDokladu   = RadaDokladu,
@MetodaSD      = MetodaSD,
@ZakazkaHlav   = CisloZakazky
FROM TabDokladyZbozi WHERE ID = @ID
SET @Hlidat = @Hlidat & @HlidatReVydej 
DECLARE @dropTmpOZTrigPolBlokNapocetHla BIT = 0
EXEC hp_loguj 'checkpoint', '', 'nacteme udaje z rady dokladu' 
SELECT @NapocitavatDatPoslPrijem = NapocitavatDatPoslPrijem,
@NapocitavatDatPoslVydej  = NapocitavatDatPoslVydej
FROM TabDruhDokZbo
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybuZbo
SET @InvDoklad = 0
IF @DruhPohybuZbo = 4 AND EXISTS(SELECT * FROM TabInvHead WHERE IDVydej = @ID)
SET @InvDoklad = 1
IF @DatumRealizace IS NULL
SET @DatumRealizace = GETDATE()
EXEC hp_loguj 'checkpoint', '', 'hp_OZMakePosunCas' 
EXEC hp_OZMakePosunCas @ID, @MakePosun OUT
IF @MakePosun = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZPosunCasReal' 
EXEC dbo.hp_OZPosunCasReal @ID, @DatumRealizace OUT
END
EXEC hp_loguj 'checkpoint', '', 'hp_RealVydejKontroly' 
EXEC hp_RealVydejKontroly
@ID, @DatumRealizace, @BylaChyba OUT, @RealMnoz, @RealFin
IF @BylaChyba = 1
RETURN
SELECT @TrCount = @@TRANCOUNT
IF @TrCount = 0 BEGIN TRAN
EXEC hp_loguj 'checkpoint', '', 'nastav blokovani' 
UPDATE TabDokladyZbozi SET BlokovaniEditoru = @Uzivatel
WHERE ID = @ID AND BlokovaniEditoru IS NULL
IF @@ROWCOUNT <> 1 OR @@ERROR <> 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(50029, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaRollBack
END
IF OBJECT_ID(N'dbo.ep_V03','P') IS NOT NULL
BEGIN
IF @RealMnoz = 0 OR @RealFin = 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(72132, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaRollBack
END ELSE
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_V03 - start - OZ - realizace - na začátku transakce v průběhu procesu realizace výdejů.',1
EXEC dbo.ep_V03 @ID
IF @@ERROR <> 0
GOTO ChybaRollBack
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_V03 - stop',1
END
END
IF OBJECT_ID(N'tempdb..#TmpOZTrigPolBlokNapocetHla') IS NULL
BEGIN
CREATE TABLE #TmpOZTrigPolBlokNapocetHla(ID INT)
SET @dropTmpOZTrigPolBlokNapocetHla = 1
END
CREATE TABLE #tmpFlag_RealizaceVydeje(ID INT)
INSERT #tmpFlag_RealizaceVydeje(ID) VALUES(@ID)
EXEC hp_loguj 'checkpoint', '', 'kurzorovy cyklus - vybira pohyby, ktere nejsou realizovane' 
DECLARE CurPol CURSOR FAST_FORWARD LOCAL FOR
SELECT
P.ID, S.ID, K.ID, P.MJ, K.MJEvidence, P.PrepMnozstvi,
P.Mnozstvi, P.CCbezDaniKcPoS, P.CCEvidPozadovana,
CASE WHEN K.DruhSkladu <> 1 THEN K.DruhSkladu ELSE
CASE WHEN T.DruhSkladu <> 1 THEN T.DruhSkladu ELSE @DruhSkladuG END END,
P.CisloZakazky, P.CisloOrg, P.IDUmisteni,
CASE WHEN (K.KontrolaVyrC IN (N'A', N'B', N'D') AND S.KontrolaVC   = N'C') OR
S.KontrolaVC   IN (N'A', N'B', N'D') THEN 1 ELSE 0 END, P.VraceneMnozstvi
FROM TabPohybyZbozi AS P
JOIN TabStavSkladu  AS S ON P.IDZboSklad = S.ID
JOIN TabStrom       AS T ON T.Cislo = S.IDSklad  AND T.DruhSkladu <> 0
JOIN TabKmenZbozi   AS K ON S.IDKmenZbozi = K.ID AND K.DruhSkladu <> 0
WHERE P.IDDoklad = @ID AND P.JCevid = 0 AND P.CCevid = 0
ORDER BY P.ID ASC
OPEN CurPol
WHILE 1=1
BEGIN
FETCH NEXT FROM CurPol INTO
@IDPohyb, @IDZboSklad, @IDKmen, @MJ, @MJEvid, @PrepMnozstvi,
@Mnozstvi, @CCbezDani, @CCEvidPoz, @DruhSkladu,
@CisloZakazky, @CisloOrg, @IDUmisteni, @KontrolaVC, @VraceneMnozstvi
IF @@FETCH_STATUS <> 0 BREAK
SELECT
@StavSkladu   = StavSkladu,
@SMnozstvi    = Mnozstvi,
@SMnozFinReal = MnozFinReal
FROM TabStavSkladu
WHERE ID = @IDZboSklad
EXEC hp_loguj 'checkpoint', '', 'hp_RealVydejPolKontroly' 
EXEC hp_RealVydejPolKontroly
@ID, @IDPohyb, @IDZboSklad, @IDUmisteni, @Mnozstvi,
@KontrolaVC, @InvDoklad, @MetodaEvidCeny, @BylaChyba OUT,
@CCBezDani, @CCEvidPoz, @StavSkladu, @KonStorPrij, @DruhPohybuZbo,
@RealMnoz, @RealFin, @VraceneMnozstvi
IF @BylaChyba = 1
GOTO ChybaCurPol
SET @DatumSkut = GETDATE()
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujPriVyMJ' 
EXEC hp_OZRealizujPriVyMJ
@IDPohyb, @IDKmen, 0, @MJ, @MJEvid, @Mnozstvi, @SMnozstvi, @MnozstviReal OUT,
@Citatel OUT, @Jmenovatel OUT, @PrepMnozstvi OUT, @BylaChyba OUT,
@SMnozFinReal, @RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO ChybaCurPol
EXEC hp_loguj 'checkpoint', '', 'hp_RealVydejPolVolKontroly' 
EXEC hp_RealVydejPolVolKontroly
@IDPohyb, @Mnozstvi, @MnozstviReal, @SMnozstvi,
@MnoRealTestMno, @BylaChyba OUT, @RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO ChybaCurPol
EXEC hp_loguj 'checkpoint', '', 'UPDATE TabPohybyZbozi' 
UPDATE TabPohybyZbozi SET
SkutecneDatReal = CASE WHEN @RealFin  = 1 THEN @DatumSkut    ELSE SkutecneDatReal END,
SkutDatRealMnoz = CASE WHEN @RealMnoz = 1 THEN @DatumSkut    ELSE SkutDatRealMnoz END,
MJEvidence      = CASE WHEN @RealMnoz = 1 THEN @MJEvid       ELSE MJEvidence END,
PrepMnozstvi    = CASE WHEN @RealMnoz = 1 THEN @PrepMnozstvi ELSE PrepMnozstvi END,
MnozstviReal    = CASE WHEN @RealMnoz = 1 THEN @MnozstviReal ELSE MnozstviReal END,
VstupniCena     = CASE WHEN @RealFin  = 1 THEN
CASE WHEN @DruhPohybuZbo = 4 THEN 0 ELSE VstupniCena END ELSE VstupniCena END,
CisloZakazky    = CASE WHEN @RealFin  = 1 THEN
CASE WHEN @ShodaZakazek = N'A' OR @CisloZakazky IS NULL
THEN @ZakazkaHlav ELSE @CisloZakazky END ELSE CisloZakazky END
WHERE ID = @IDPohyb
IF @@ERROR <> 0 GOTO ChybaCurPol
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejVC' 
EXEC hp_OZRealizujVydejVC
@IDPohyb, @PrepMJnaVC, @Citatel, @Jmenovatel,
@Mnozstvi, @MnozstviReal, @BylaChyba OUT, @RealMnoz, @RealFin
IF @BylaChyba <> 0
GOTO ChybaCurPol
IF @RealMnoz = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejHlidej' 
EXEC hp_OZRealizujVydejHlidej
@Hlidat, @DruhPohybuZbo, @ID, @IDPohyb, @IDZboSklad,
@CisloOrg, @DatumRealizace, @SMnozstvi, @MnozstviReal, @BylaChyba OUT
IF @BylaChyba = 1
GOTO ChybaCurPol
END
IF @RealFin = 1
BEGIN
IF @MetodaSkladu >= 3
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejNEC' 
EXEC hp_OZRealizujVydejNEC
@IDPohyb, @IDZboSklad, @DruhPohybuZbo, @StavSkladu, @SMnozFinReal,
@MnozstviReal, @CCbezDani, @CCEvidPoz, @DatumSkut, @KonStorPrij,
@MetodaEvidCeny, @DruhSkladu, @DruhSkladSN, @CisloChyby OUT, @CenaC OUT,
@SN1 OUT, @SN2 OUT, @SN3 OUT, @SN4 OUT, @SN5 OUT, @SN6 OUT, @SN7 OUT
END
ELSE
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejEC' 
EXEC dbo.hp_OZRealizujVydejEC
@IDZboSklad, @DruhPohybuZbo, @StavSkladu, @SMnozstvi,
@MnozstviReal, @CCbezDani, @CCEvidPoz, @KonStorPrij,
@DruhSkladu, @CisloChyby OUT, @CenaC OUT
END
IF @CisloChyby > 0
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(@CisloChyby, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
IF @RealMnoz = 1
BEGIN
IF (EXISTS(SELECT * FROM TabPaletySSCCPolozky WHERE IDPolozky = @IDPohyb))
BEGIN
EXEC hp_loguj 'checkpoint', '', 'kontrola mnozstvi na paletach pri realizaci mnozstevni' 
SELECT @SSCCMnozstvi = SUM(p.MnozstviBezVC + p.MnozstviVC)
FROM TabPaletySSCCPolozky AS p
WHERE p.IDPolozky = @IDPohyb
IF (@MJ IS NULL OR @MJEvid IS NULL OR @MJ = @MJEvid) AND
@SSCCMnozstvi > @MnozstviReal
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(88107, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
END
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'zapiseme CC evidencni na polozku' 
UPDATE TabPohybyZbozi
SET CCevid = @CenaC WHERE ID = @IDPohyb
IF @@ERROR <> 0 GOTO ChybaCurPol
END
EXEC hp_loguj 'checkpoint', '', 'VYROBNI CISLA - zapis stavu vsech VC dle pohybu VC na polozce' 
UPDATE CS SET
Mnozstvi        = CASE WHEN @RealMnoz = 1 THEN CS.Mnozstvi        - CP.MnozstviReal ELSE CS.Mnozstvi END,
MnozFinReal     = CASE WHEN @RealFin  = 1 THEN CS.MnozFinReal     - CP.MnozstviReal ELSE CS.MnozFinReal END,
MnozstviDispo   = CASE WHEN @RealMnoz = 1 THEN CS.MnozstviDispo   - CP.MnozstviReal ELSE CS.MnozstviDispo END,
MnozstviKVydeji = CASE WHEN @RealMnoz = 1 THEN CS.MnozstviKVydeji - CP.MnozstviReal ELSE CS.MnozstviKPrijmu END,
MnozstviHlidano = CASE WHEN @RealMnoz = 1 THEN CS.MnozstviHlidano - CP.MnozstviReal ELSE CS.MnozstviHlidano END,
FinStav         = CASE WHEN @RealFin  = 1 THEN CS.FinStav         - CP.CCEvid       ELSE CS.FinStav END,
Prumer = CASE WHEN @RealFin = 1 AND (@DruhPohybuZbo = 1 OR @DruhSkladu <> 3)
THEN CASE WHEN CS.MnozFinReal = CP.MnozstviReal THEN Prumer
ELSE (CS.FinStav - CP.CCEvid) / (CS.MnozFinReal - CP.MnozstviReal) END
ELSE Prumer END
FROM TabVyrCS AS CS
JOIN TabVyrCP AS CP ON CS.ID = CP.IDVyrCis
WHERE CP.IDPolozkaDokladu = @IDPohyb
IF @@ERROR <> 0 GOTO ChybaCurPol
IF @RealMnoz = 1
BEGIN
IF EXISTS(
SELECT *
FROM TabVyrCS AS CS
JOIN TabVyrCP AS CP ON CS.ID = CP.IDVyrCis
WHERE CP.IDPolozkaDokladu = @IDPohyb
AND CS.Mnozstvi < 0)
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(50230, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
EXEC hp_loguj 'checkpoint', '', 'ZAPIS REALIZOVANEHO POHYBU DO STAVU SKLADU' 
UPDATE TabStavSkladu SET
StavSkladu      = CASE WHEN @RealFin  = 1 THEN StavSkladu      - @CenaC        ELSE StavSkladu END,
Mnozstvi        = CASE WHEN @RealMnoz = 1 THEN Mnozstvi        - @MnozstviReal ELSE Mnozstvi END,
MnozFinReal     = CASE WHEN @RealFin  = 1 THEN MnozFinReal     - @MnozstviReal ELSE MnozFinReal END,
MnozstviKVydeji = CASE WHEN @RealMnoz = 1 THEN MnozstviKVydeji - @MnozstviReal ELSE MnozstviKVydeji END,
MnozstviDispo   = CASE WHEN @RealMnoz = 1 THEN MnozstviDispo   - @MnozstviReal ELSE MnozstviDispo END,
PoslPrijem      = CASE WHEN @RealMnoz = 1 AND @NapocitavatDatPoslPrijem = 1 THEN @DatumSkut ELSE PoslPrijem END,
PoslVydej       = CASE WHEN @RealMnoz = 1 AND @NapocitavatDatPoslVydej  = 1 THEN @DatumSkut ELSE PoslVydej END,
Prumer = CASE WHEN @RealFin = 1 AND (@DruhPohybuZbo = 1 OR @DruhSkladu <> 3 OR @MetodaEvidCeny = 1)
THEN CASE WHEN MnozFinReal = @MnozstviReal THEN Prumer
ELSE (StavSkladu - @CenaC) / (MnozFinReal - @MnozstviReal) END
ELSE Prumer END
WHERE ID = @IDZboSklad
IF @@ERROR <> 0 GOTO ChybaCurPol
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejSN' 
EXEC hp_OZRealizujVydejSN
@ID, @IDPohyb, @IDZboSklad,
@StavSkladu, @SMnozstvi, @MnozstviReal, @CenaC,
@DruhPohybuZbo, @DruhSkladSN, @NeaktEvSlo, @StoPEdiSN,
@BylaChyba OUT, @SN1, @SN2, @SN3, @SN4, @SN5, @SN6, @SN7,
@RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO ChybaCurPol
IF @RealFin = 1 AND @DruhPohybuZbo = 4
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejVEC' 
EXEC hp_OZRealizujVydejVEC
@IDPohyb, @ZpusobKurzu, @MetodaSD, @BylaChyba OUT
IF @BylaChyba = 1
GOTO ChybaCurPol
END
IF @RealFin = 1 AND @OZMarze = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_VypocitejMarziNaPolozce' 
EXEC dbo.hp_VypocitejMarziNaPolozce 1, 0, @IDpohyb, @MnozstviReal
EXEC hp_loguj 'checkpoint', '', 'cursor pro vsechny navazne polozky proved doplneni' 
DECLARE cZMO CURSOR FAST_FORWARD LOCAL FOR
SELECT Fak.ID
FROM TabPohybyZbozi AS Fak
JOIN TabPohybyZbozi AS Vyd ON Fak.IDOldPolozka = Vyd.ID
WHERE Vyd.ID = @IDPohyb
AND Fak.DruhPohybuZbo =
CASE WHEN Vyd.DruhPohybuZbo IN (2,4) THEN 13
WHEN Vyd.DruhPohybuZbo      = 3 THEN 14 ELSE -1 END
OPEN cZMO
WHILE 1=1
BEGIN
FETCH NEXT FROM cZMO INTO @IDPohybuF
IF @@fetch_status<>0 BREAK
EXEC dbo.hp_VypocitejMarziNaPolozce 1, 0, @IDPohybuF, @MnozstviReal
IF @@ERROR<>0 GOTO CHYBAROLLBACK
END
CLOSE cZMO
DEALLOCATE cZMO
END
IF @RealMnoz = 1
BEGIN
SET @UmistNaVydejceOK = 1
IF @UmistMetVyd = 0
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZ_ZapisSkutecneUmisteni' 
EXEC dbo.hp_OZ_ZapisSkutecneUmisteni
@IDZboSklad, @IDpohyb, @IDUmisteni, @MnozstviReal, 0, @UmistNaVydejceOK OUT, 1
END
ELSE
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZ_ZapisSkutecneUmiDleVC' 
EXEC dbo.hp_OZ_ZapisSkutecneUmiDleVC
@IDZboSklad, @IDpohyb, @IDUmisteni, @MnozstviReal, 0, 0, 1, @UmistNaVydejceOK OUT, 1
END
IF @UmistNaVydejceOK = 0
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(77137, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
IF
(SELECT Mnozstvi FROM TabStavSkladu WHERE ID = @IDZboSklad) <
(SELECT ISNULL(SUM(MnozstviUmisteni), 0)
FROM TabVStavUmisteni WHERE IDStav = @IDZboSklad)
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(70986, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
SET @DruMnozstvi = -@MnozstviReal
SET @DruCena     = -@CenaC
EXEC hp_loguj 'checkpoint', '', 'Prepocti_Pohyb_Stav' 
EXEC dbo.Prepocti_Pohyb_Stav
@DatumRealizace, @IDpohyb, @IDZboSklad,
@DruMnozstvi, @DruCena, @VysledekProc OUT,
@RealMnoz, @RealFin
IF @VysledekProc = 0 GOTO ChybaCurPol
IF @VysledekProc = -1
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(70217, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
IF @VysledekProc = -2
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(70218, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
IF @RealMnoz = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejStavKDVC' 
EXEC dbo.hp_OZRealizujVydejStavKDVC
@DatumRealizace, @IDPohyb, @IDZboSklad, @MetodaVCRealKD, @VysledekProc OUT
IF @VysledekProc = -1
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(72085, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
IF @VysledekProc = -2
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(72086, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
IF @RealMnoz = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujVydejStavKDVCBlokace' 
EXEC dbo.hp_OZRealizujVydejStavKDVCBlokace
@DatumRealizace, @IDPohyb, @IDZboSklad, @MetodaVCRealKD, @VysledekProc OUT
IF @VysledekProc = -3
BEGIN
SELECT @ChybHlaska = SkupZbo +N'-'+ RegCis +N' '+
CAST(@Mnozstvi AS NVARCHAR) +N' '+ ISNULL(@MJ,'') +N' - '+ Nazev1
FROM TabPohybyZbozi WHERE ID = @IDPohyb
SET @ErrStr = dbo.hf_FormatError(88967, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaCurPol
END
END
DECLARE @MnozstviPrEv NUMERIC(19,6)
IF (@RealMnoz = 1) AND EXISTS(SELECT*FROM TabHGlob WHERE NZB=1)
BEGIN
SELECT @MnozstviPrEv = Mnozstvi * PrepMnozstvi
FROM TabPohybyZbozi WHERE ID = @IDPohyb
EXEC hp_loguj 'checkpoint', '', 'hp_NZB_PrKVaz_UpravyPoRealizaci_Vydej' 
EXEC @ret = dbo.hp_NZB_PrKVaz_UpravyPoRealizaci_Vydej2
@IDPohyb,
@DruhPohybuZbo,
@IDZboSklad,
@MnozstviPrEv
IF @@error<>0 OR @ret<>0 GOTO ChybaCurPol
END
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_realizace_prijem_vydej_CEA' 
EXEC @Ret = dbo.hp_realizace_prijem_vydej_CEA @IDpohyb, @DatumRealizace
IF @@error<>0 OR @Ret<>0 GOTO ChybaCurPol
END
IF @RealMnoz = 1
BEGIN
IF @NZB = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_NZB_UpravyPoRealizaci' 
EXEC @Ret = dbo.hp_NZB_UpravyPoRealizaci @IDPohyb
END
ELSE
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_DosleObj_UpravyPoRealizaci' 
EXEC @Ret = dbo.hp_DosleObj_UpravyPoRealizaci @IDPohyb
END
IF @@ERROR <> 0 OR @Ret <> 0 GOTO ChybaCurPol
END
END
CLOSE CurPol
DEALLOCATE CurPol
IF @RealFin = 1 AND @OZMarze = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'kurzorovy cyklus - vybira pohyby sluzbovych polozek, kde doklad neni realizovany' 
DECLARE CurSluzPol CURSOR FAST_FORWARD LOCAL FOR
SELECT P.ID, P.Mnozstvi
FROM TabPohybyZbozi  AS P
JOIN TabStavSkladu   AS S ON P.IDZboSklad = S.ID
JOIN TabKmenZbozi    AS K ON S.IDKmenZbozi = K.ID AND K.DruhSkladu = 0
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad AND D.DatRealizace IS NULL
WHERE P.IDDoklad = @ID AND P.Mnozstvi > 0
ORDER BY P.ID ASC
OPEN CurSluzPol
WHILE 1=1
BEGIN
FETCH NEXT FROM CurSluzPol INTO @IDPohyb, @MnozstviReal
IF @@FETCH_STATUS <> 0 BREAK
EXEC hp_loguj 'checkpoint', '', 'hp_VypocitejMarziNaPolozce' 
EXEC dbo.hp_VypocitejMarziNaPolozce 1, 0, @IDpohyb, @MnozstviReal
EXEC hp_loguj 'checkpoint', '', 'cursor pro vsechny navazne polozky proved doplneni' 
DECLARE cZMO CURSOR FAST_FORWARD LOCAL FOR
SELECT Fak.ID
FROM TabPohybyZbozi AS Fak
JOIN TabPohybyZbozi AS Vyd ON Fak.IDOldPolozka = Vyd.ID
WHERE Vyd.ID = @IDPohyb
AND Fak.DruhPohybuZbo =
CASE WHEN Vyd.DruhPohybuZbo IN (2,4) THEN 13
WHEN Vyd.DruhPohybuZbo      = 3 THEN 14 ELSE -1 END
OPEN cZMO
WHILE 1=1
BEGIN
FETCH NEXT FROM cZMO INTO @IDPohybuF
IF @@fetch_status<>0 BREAK
EXEC hp_loguj 'checkpoint', '', 'hp_VypocitejMarziNaPolozce' 
EXEC dbo.hp_VypocitejMarziNaPolozce 1, 0, @IDPohybuF, @MnozstviReal
IF @@ERROR<>0 GOTO CHYBAROLLBACK
END
CLOSE cZMO
DEALLOCATE cZMO
EXEC hp_loguj 'checkpoint', '', 'konec kurzoru pro vsechny navazne polozky proved doplneni' 
END
CLOSE CurSluzPol
DEALLOCATE CurSluzPol
EXEC hp_loguj 'checkpoint', '', 'konec kurzoru vybira pohyby sluzbovych polozek, kde doklad neni realizovan' 
END
IF @dropTmpOZTrigPolBlokNapocetHla = 1 AND
OBJECT_ID(N'tempdb..#TmpOZTrigPolBlokNapocetHla') IS NOT NULL
DROP TABLE #TmpOZTrigPolBlokNapocetHla
EXEC hp_loguj 'checkpoint', '', 'hp_ObehZbozi_NapocitejSumaciCen' 
EXEC dbo.hp_ObehZbozi_NapocitejSumaciCen @ID
IF @@ERROR <> 0 GOTO ChybaRollBack
IF @RealFin = 1
INSERT INTO TabOZRealHist (IDDoklad) VALUES (@ID)
EXEC hp_loguj 'checkpoint', '', 'UPDATE TabDokladyZbozi zapis datum realizace a shod blokovani' 
UPDATE TabDokladyZbozi SET
BlokovaniEditoru = NULL,
AutorRealMno     = CASE WHEN @RealMnoz= 1 THEN SUSER_SNAME() ELSE AutorRealMno END,
AutorRealFin     = CASE WHEN @RealFin = 1 THEN SUSER_SNAME() ELSE AutorRealFin END,
DatRealizace     = CASE WHEN @RealFin = 1 THEN @DatumRealizace ELSE DatRealizace END,
DatRealMnoz      = CASE WHEN @RealMnoz= 1 THEN @DatumRealizace ELSE DatRealMnoz END,
ECCelkemDokl     = CASE WHEN @RealFin = 1 THEN (SELECT SUM(CCEvid)     FROM TabPohybyZbozi WHERE IDDoklad = @ID) ELSE ECCelkemDokl END,
ECCelkemDoklUcto = CASE WHEN @RealFin = 1 THEN (SELECT SUM(CCEvidUcto) FROM TabPohybyZbozi WHERE IDDoklad = @ID) ELSE ECCelkemDoklUcto END,
SNCelkemDokl     = CASE WHEN @RealFin = 1 THEN (SELECT ISNULL(SUM(KcCelkem),0) FROM TabSouvNakladyPol WHERE IDDokladu = @ID) ELSE SNCelkemDokl END
WHERE ID = @ID
IF @@ERROR <> 0 GOTO ChybaRollBack
IF @RealMnoz = 1 AND @DruhPohybuZbo = 4
BEGIN
SET @IDInv = NULL
SELECT @IDInv = ID FROM TabInvHead WHERE IDVydej = @ID AND TypInv = 0
IF @IDInv IS NOT NULL
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZInvDokReal' 
EXEC dbo.hp_OZInvDokReal @ID, @IDInv
END
END
IF OBJECT_ID(N'dbo.ep_V01','P')IS NOT NULL
BEGIN
IF @RealMnoz = 0 OR @RealFin = 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(72132, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaRollBack
END ELSE
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_V01 - start OZ - realizace - na konci procesu realizace výdejů.',1
EXEC dbo.ep_V01 @ID
IF @@ERROR <> 0 GOTO ChybaRollBack
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_V01 - stop',1
END
END
IF @RealMnoz = 1 AND
OBJECT_ID(N'dbo.ep_Ekokom2021_PV','P')IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_Ekokom2021_PV - start',1
EXEC dbo.ep_Ekokom2021_PV @ID, @DruhPohybuZbo
IF @@ERROR <> 0 GOTO ChybaRollBack
EXEC hp_loguj 'stop','User_Ep_procedure','' ,1,0,'ep_Ekokom2021_PV - stop',1
END
IF @TrCount = 0
COMMIT TRANSACTION
GOTO Konec
ChybaCurPol:
CLOSE CurPol
DEALLOCATE CurPol
ChybaRollBack:
IF @TrCount = 0 ROLLBACK
SET @BylaChyba = 1
EXEC hp_loguj 'checkpoint', '', 'stop s chybou hp_Realizuj_Vydej' 
RETURN
Konec:
EXEC hp_loguj 'checkpoint', '', 'stop hp_Realizuj_Vydej'
GO
