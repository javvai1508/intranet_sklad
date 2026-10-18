-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_Realizuj_Prijem]
@ID             INT,
@DatumRealizace DATETIME,
@Uzivatel       SMALLINT,
@BylaChyba      BIT OUT,
@RealMnoz       BIT = 1,
@RealFin        BIT = 1,
@VypnoutUpozorneniPriZajistovani BIT = 0
AS
SET NOCOUNT ON
DECLARE @ShodaZakazek     NCHAR(1)      -- povinna shoda zakazky polozky s hlavickou
DECLARE @PrepMJnaVC       BIT           -- prepocet MJ take na VC
DECLARE @NZB              BIT           -- zapnuto nove zajistovani a blokovani zbozi
DECLARE @DruhSkladuG      TINYINT       -- druh skladu    2=FIFO  3=prumery
DECLARE @DruhSkladSN      TINYINT       -- druh skladu SN 2=FIFO  3=prumery
DECLARE @DruhSkladu       TINYINT       -- dle priority 1.kmen 2.strom 3.global
DECLARE @ZakazkaHlavicka  NVARCHAR(15)  -- zakazka dle hlavicky
DECLARE @DruhPohybuZbo    TINYINT       -- udaj dle hlavicky
DECLARE @RadaDokladu      NVARCHAR(3)   -- udaj dle hlavicky
DECLARE @KontrolaVC       BIT           -- kontrola VC dle kmene a stavu skladu
DECLARE @InvDoklad        BIT           -- jde o inventurni doklad
DECLARE @TrCount          INT           -- vychozi pocet otevrenych transakci
DECLARE @IDKmen           INT           -- ID kmenove karty
DECLARE @MjEvid           NVARCHAR(10)  -- evidencni merna jednotka ze kmene
DECLARE @PrepMnozstvi     FLOAT         -- prepocet mnozstvi na evidencni MJ
DECLARE @Citatel          NUMERIC(19,6) -- vztah jako presny zlomek
DECLARE @Jmenovatel       NUMERIC(19,6) -- vztah jako presny zlomek
DECLARE @MnozstviReal     NUMERIC(19,6) -- mnozstvi v evidencni MJ
DECLARE @VysledekProc     INT           -- vysledek proc PrepoctiPohybStav
DECLARE @ErrStr           NVARCHAR(2047)-- chybova hlaska
DECLARE @IDPohyb          INT           -- ID aktualni polozky
DECLARE @IDZboSklad       INT           -- ID skladove karty
DECLARE @Metoda           TINYINT       -- metoda EC dle skladove karty
DECLARE @CisloZakazky     NVARCHAR(15)  -- zakazka na polozce
DECLARE @MJ               NVARCHAR(10)  -- MJ polozky
DECLARE @Mnozstvi         NUMERIC(19,6) -- mnozstvi polozky
DECLARE @CCbezDaniKcPoS   NUMERIC(19,6) -- nakupni cena celkem
DECLARE @CCevidPozadovana NUMERIC(19,6) -- pozadovana evid cena storna/prevodu
DECLARE @CCRozhodna       NUMERIC(19,6) -- cena, ktera se stane cenou evidencni
DECLARE @KmenOdhadZvysNC  NUMERIC(19,6)
DECLARE @Kc1              NUMERIC(19,6) -- souvisejici naklady polozky
DECLARE @Kc2              NUMERIC(19,6)
DECLARE @Kc3              NUMERIC(19,6)
DECLARE @Kc4              NUMERIC(19,6)
DECLARE @Kc5              NUMERIC(19,6)
DECLARE @Kc6              NUMERIC(19,6)
DECLARE @Kc7              NUMERIC(19,6)
DECLARE @JsouSN           BIT           -- nektery SN je nenulovy
DECLARE @OZPrevDrziCCEvid BIT           -- prevodka pouziva CCEvidPozadovana
DECLARE @OZDSNMetodaStoV  BIT           -- rekurzivni zpracovani DSN u storen vydeje
DECLARE @OZDSNNavDok      TINYINT       -- zpracovani DSN u navaznych dokladu
DECLARE @OZDSNAutoReal    TINYINT       -- realizace generovaneho dokladu DSN
DECLARE @MakePosun        BIT           -- provest posun casu u data realizace
DECLARE @IDUmisteni       INT           -- preferovane umisteni
DECLARE @PouzitOdhad      NVARCHAR(1)   -- odhad zvyseni nakupni ceny
DECLARE @NapocitavatDatPoslPrijem BIT   -- napocitavat datum posledniho prijmu
DECLARE @NapocitavatDatPoslVydej BIT    -- napocitavat datum posledniho vydaje
DECLARE @IDInv            INT           -- ID hlavicky inventury
DECLARE @IDNewDokladDSN   INT = NULL    -- novy doklad DSN pro dozatizeni
DECLARE @MetodaSkladu     TINYINT       -- metoda skladove evidence
DECLARE @MetodaEvidCeny   TINYINT       -- evidencni ceny souhrnne / dle VC
DECLARE @NeaktEvMnEvStav  TINYINT       -- metoda kontroly stavu skladu
DECLARE @DatumSkut        DATETIME      -- skutecne datum realizace
DECLARE @OZMarze          BIT           -- zapnuto vyhodnoceni marze
DECLARE @IDPohybuF        INT           -- ID pohybu navazne faktury
SET @BylaChyba = 0
EXEC hp_loguj 'checkpoint', '', 'start hp_Realizuj_Prijem' 
IF OBJECT_ID(N'dbo.ep_P03','P')IS NOT NULL
BEGIN
IF @RealMnoz = 0 OR @RealFin = 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(72132, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaMimo
END ELSE
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'dbo.ep_P03 - start - OZ - realizace - na začátku procesu realizace příjmů.',1
EXEC dbo.ep_P03 @ID
IF @@ERROR <> 0
GOTO ChybaMimo
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'dbo.ep_P03 - stop',1
END
END
CREATE TABLE #tmpFlag_RealizacePrijmu(ID INT)
INSERT #tmpFlag_RealizacePrijmu(ID) VALUES(@ID)
EXEC hp_loguj 'checkpoint', '', 'nacteme udaje z globalni konfigurace' 
SELECT
@ShodaZakazek      = ShodaZakazek,
@DruhSkladuG       = DruhSkladu,
@DruhSkladSN       = DruhSkladuSN,
@PrepMJnaVC        = OZPrepMJnaVC,
@MetodaSkladu      = MetodaSkladu,
@MetodaEvidCeny    = MetodaEvidCeny,
@OZDSNMetodaStoV   = OZDSNMetodaStoV,
@OZDSNNavDok       = OZDSNNavDok,
@OZDSNAutoReal     = OZDSNAutoReal,
@OZPrevDrziCCEvid  = OZPrevDrziCCEvid,
@NeaktEvMnEvStav   = NeaktEvMnozstviEvStav,
@OZMarze           = OZMarze,
@NZB               = NZB
FROM TabHGlob
EXEC hp_loguj 'checkpoint', '', 'nacteme udaje z hlavicky' 
SELECT
@DruhPohybuZbo   = DruhPohybuZbo,
@RadaDokladu     = RadaDokladu,
@ZakazkaHlavicka = CisloZakazky
FROM TabDokladyZbozi WHERE ID = @ID
EXEC hp_loguj 'checkpoint', '', 'nacteme udaje z rady dokladu' 
SELECT @PouzitOdhad = PouzitOdhadZvyseniNC,
@NapocitavatDatPoslPrijem = NapocitavatDatPoslPrijem,
@NapocitavatDatPoslVydej  = NapocitavatDatPoslVydej
FROM TabDruhDokZbo
WHERE RadaDokladu = @RadaDokladu
AND DruhPohybuZbo = @DruhPohybuZbo
SET @InvDoklad = 0
IF @DruhPohybuZbo = 0 AND EXISTS(SELECT * FROM TabInvHead WHERE IDPrijem = @ID)
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
EXEC hp_loguj 'checkpoint', '', 'hp_RealPrijemKontroly' 
EXEC hp_RealPrijemKontroly
@ID, @DatumRealizace, @BylaChyba OUT, @DruhPohybuZbo, @RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO ChybaMimo
SELECT @TrCount = @@TRANCOUNT
IF @TrCount = 0 BEGIN TRAN
EXEC hp_loguj 'checkpoint', '', 'blokovani editoru na hlavicce' 
UPDATE TabDokladyZbozi
SET BlokovaniEditoru = @Uzivatel
WHERE ID = @ID
AND BlokovaniEditoru IS NULL
IF @@ROWCOUNT <> 1 OR @@ERROR <> 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(50007, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaTran
END
EXEC hp_loguj 'checkpoint', '', 'kurzor pres vsechny pohyby, ktere jeste nejsou realizovane' 
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT
P.ID, S.ID, K.ID, S.Metoda, P.CisloZakazky,
P.MJ, K.MJEvidence, P.Mnozstvi, P.PrepMnozstvi,
P.CCbezDaniKcPoS, P.CCevidPozadovana, K.OdhadZvysNakupniCeny,
CASE WHEN K.DruhSkladu <> 1 THEN K.DruhSkladu ELSE
CASE WHEN T.DruhSkladu <> 1 THEN T.DruhSkladu ELSE @DruhSkladuG END END,
ISNULL(SNP.Kc1,0), ISNULL(SNP.Kc2,0), ISNULL(SNP.Kc3,0),
ISNULL(SNP.Kc4,0), ISNULL(SNP.Kc5,0),
ISNULL(SNP.Kc6,0), ISNULL(SNP.Kc7,0),
CASE WHEN (K.KontrolaVyrC IN (N'A', N'B', N'D') AND S.KontrolaVC = N'C') OR
S.KontrolaVC   IN (N'A', N'B', N'D') THEN 1 ELSE 0 END,
P.IDUmisteni
FROM TabPohybyZbozi AS P
JOIN TabStavSkladu  AS S ON P.IDZboSklad = S.ID
JOIN TabStrom       AS T ON S.IDSklad  = T.Cislo AND T.DruhSkladu <> 0
JOIN TabKmenZbozi   AS K ON S.IDKmenZbozi = K.ID AND K.DruhSkladu <> 0
LEFT OUTER JOIN TabSouvNakladyPol AS SNP ON P.ID = SNP.IDPohybu
WHERE P.IDDoklad = @ID
AND P.JCevid = 0 AND P.CCevid = 0
ORDER BY P.ID ASC
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO
@IDPohyb, @IDZboSklad, @IDKmen, @Metoda, @CisloZakazky,
@MJ, @MJEvid, @Mnozstvi, @PrepMnozstvi,
@CCbezDaniKcPoS, @CCevidPozadovana, @KmenOdhadZvysNC, @DruhSkladu,
@Kc1, @Kc2, @Kc3, @Kc4, @Kc5, @Kc6, @Kc7, @KontrolaVC, @IDUmisteni
IF @@FETCH_STATUS <> 0 BREAK
SET @DatumSkut = GETDATE()
EXEC hp_loguj 'checkpoint', '', 'hp_RealPrijemPolKontroly' 
EXEC hp_RealPrijemPolKontroly
@ID, @IDPohyb, @IDZboSklad, @IDUmisteni, @Mnozstvi,
@KontrolaVC, @InvDoklad, @MetodaEvidCeny, @BylaChyba OUT,
@RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO Chyba
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujPriVyMJ' 
EXEC hp_OZRealizujPriVyMJ
@IDPohyb, @IDKmen, 1, @MJ, @MJEvid, @Mnozstvi, 0, @MnozstviReal OUT,
@Citatel OUT, @Jmenovatel OUT, @PrepMnozstvi OUT, @BylaChyba OUT,
0, @RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO Chyba
IF @RealFin = 1 AND
@PouzitOdhad = N'A'
SET @CCbezDaniKcPoS =
@CCbezDaniKcPoS + ROUND((@CCbezDaniKcPoS * @KmenOdhadZvysNC / 100), 2)
IF @RealFin = 1
IF @DruhPohybuZbo = 3 OR
(@CCEvidPozadovana > 0 AND @DruhPohybuZbo = 0 AND @OZPrevDrziCCEvid = 1)
IF @Metoda NOT IN(5,7,9,11)
SET @CCRozhodna = @CCevidPozadovana
ELSE
SELECT @CCRozhodna = ISNULL(SUM(CCEvidPozadovana),0)
FROM TabVyrCP
WHERE IDPolozkaDokladu = @IDPohyb
ELSE
SET @CCRozhodna = @CCbezDaniKcPoS
EXEC hp_loguj 'checkpoint', '', 'zapiseme hodnoty na polozku dokladu' 
UPDATE TabPohybyZbozi SET
SkutecneDatReal = CASE WHEN @RealFin  = 1 THEN @DatumSkut    ELSE SkutecneDatReal END,
SkutDatRealMnoz = CASE WHEN @RealMnoz = 1 THEN @DatumSkut    ELSE SkutDatRealMnoz END,
MJEvidence      = CASE WHEN @RealMnoz = 1 THEN @MJEvid       ELSE MJEvidence END,
PrepMnozstvi    = CASE WHEN @RealMnoz = 1 THEN @PrepMnozstvi ELSE PrepMnozstvi END,
MnozstviReal    = CASE WHEN @RealMnoz = 1 THEN @MnozstviReal ELSE MnozstviReal END,
CCevid          = CASE WHEN @RealFin  = 1 THEN @CCRozhodna   ELSE CCEvid END,
CisloZakazky    = CASE WHEN @RealFin  = 1 THEN
CASE WHEN @ShodaZakazek = N'A' OR @CisloZakazky IS NULL
THEN @ZakazkaHlavicka ELSE @CisloZakazky END ELSE CisloZakazky END
WHERE ID = @IDPohyb
IF @@ERROR <> 0 GOTO Chyba
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujPrijemVC' 
EXEC hp_OZRealizujPrijemVC
@IDPohyb, @KontrolaVC, @PrepMJnaVC, @Mnozstvi, @MnozstviReal,
@CCRozhodna, @Citatel, @Jmenovatel, @BylaChyba OUT,
@RealMnoz, @RealFin
IF @BylaChyba = 1
GOTO Chyba
EXEC hp_loguj 'checkpoint', '', 'aktualiace stavu skladu' 
UPDATE TabStavSkladu SET
Mnozstvi        = CASE WHEN @RealMnoz = 1 THEN Mnozstvi        + @MnozstviReal ELSE Mnozstvi END,
MnozFinReal     = CASE WHEN @RealFin  = 1 THEN MnozFinReal     + @MnozstviReal ELSE MnozFinReal END,
MnozstviKPrijmu = CASE WHEN @RealMnoz = 1 THEN MnozstviKPrijmu - @MnozstviReal ELSE MnozstviKPrijmu END,
MnozstviDispo   = CASE WHEN @RealMnoz = 1 THEN MnozstviDispo   + @MnozstviReal ELSE MnozstviDispo END,
StavSkladu      = CASE WHEN @RealFin  = 1 THEN StavSkladu      + @CCRozhodna   ELSE StavSkladu END,
PoslPrijem      = CASE WHEN @RealMnoz = 1 AND @NapocitavatDatPoslPrijem = 1 THEN @DatumSkut ELSE PoslPrijem END,
PoslVydej       = CASE WHEN @RealMnoz = 1 AND @NapocitavatDatPoslVydej  = 1 THEN @DatumSkut ELSE PoslVydej END
WHERE TabStavSkladu.ID = @IDZboSklad
IF @@ERROR <> 0 GOTO Chyba
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'na sklad zapiseme soucasne souhrnne SN' 
UPDATE TabStavSkladu SET
Prumer = CASE WHEN MnozFinReal > 0
THEN StavSkladu / MnozFinReal
ELSE 0 END,
StavSkladuSouvis = StavSkladuSouvis+@Kc1+@Kc2+@Kc3+@Kc4+@Kc5+@Kc6+@Kc7
WHERE TabStavSkladu.ID = @IDZboSklad
IF @@ERROR <> 0 GOTO Chyba
END
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujPrijemSN' 
EXEC hp_OZRealizujPrijemSN
@IDPohyb, @IDZboSklad, @MnozstviReal, @DatumRealizace, @DruhSkladSN, @MetodaSkladu,
@Kc1, @Kc2, @Kc3, @Kc4, @Kc5, @Kc6, @Kc7, @JsouSN OUT
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealizujPrijemSP' 
EXEC hp_OZRealizujPrijemSP
@IDPohyb, @IDZboSklad, @MnozstviReal, @CCRozhodna, @DatumSkut,
@DruhSkladu, @DruhSkladSN, @MetodaSkladu, @MetodaEvidCeny,
@Kc1, @Kc2, @Kc3, @Kc4, @Kc5, @Kc6, @Kc7, @JsouSN, @BylaChyba OUT
IF @BylaChyba = 1
GOTO Chyba
END
IF @RealMnoz = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZUmistZalozPrijmy' 
EXEC dbo.hp_OZUmistZalozPrijmy
@IDPohyb, @IDUmisteni, @Mnozstvi, @MnozstviReal, @PrepMnozstvi
END
IF @NeaktEvMnEvStav = 0
BEGIN
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'na pohyb zapiseme stavove sloupce' 
UPDATE P SET
EvMnozstvi = S.Mnozstvi,
EvStav     = S.StavSkladu,
CCEvidSN   = P.CCEvid + @Kc1 + @Kc2 + @Kc3 + @Kc4 + @Kc5 + @Kc6 + @Kc7
FROM TabPohybyZbozi AS P
JOIN TabStavSkladu  AS S ON P.IDZboSklad = S.ID
WHERE P.ID = @IDpohyb
IF @@ERROR <> 0 GOTO Chyba
EXEC hp_loguj 'checkpoint', '', 'Prepocti_Pohyb_Stav' 
EXEC Prepocti_Pohyb_Stav
@DatumRealizace, @IDpohyb, @IDZboSklad, @MnozstviReal, @CCRozhodna, @VysledekProc OUT
IF @VysledekProc = 0 GOTO Chyba
END
END ELSE
BEGIN
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'UPDATE TabPohybyZbozi' 
UPDATE P
SET CCEvidSN = P.CCEvid + @Kc1 + @Kc2 + @Kc3 + @Kc4 + @Kc5 + @Kc6 + @Kc7
FROM TabPohybyZbozi AS P
JOIN TabStavSkladu  AS S ON P.IDZboSklad = S.ID
WHERE P.ID = @IDpohyb
IF @@ERROR <> 0 GOTO Chyba
END
END
IF @RealFin = 1
BEGIN
IF @OZDSNNavDok = 0
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealDSNPrijem' 
EXEC hp_OZRealDSNPrijem @IDPohyb, @DatumRealizace, @OZDSNMetodaStoV
END
IF @OZDSNNavDok = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealDSNPrijemNew' 
EXEC hp_OZRealDSNPrijemNew
@IDPohyb, @IDNewDokladDSN OUT, @OZDSNMetodaStoV
END
END
IF @RealFin = 1 AND @OZMarze = 1 AND @DruhPohybuZbo = 3
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_VypocitejMarziNaPolozce' 
EXEC dbo.hp_VypocitejMarziNaPolozce 1, 0, @IDpohyb, @MnozstviReal
EXEC hp_loguj 'checkpoint', '', 'kurzor pro vsechny navazne polozky proved doplneni' 
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
IF @@ERROR<>0
BEGIN
CLOSE cZMO
DEALLOCATE cZMO
GOTO Chyba
END
END
CLOSE cZMO
DEALLOCATE cZMO
END
DECLARE @ret INT
IF @RealFin = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_realizace_prijem_vydej_CEA' 
EXEC @ret = dbo.hp_realizace_prijem_vydej_CEA @IDpohyb, @DatumRealizace
IF @@ERROR <> 0 OR @ret <> 0 GOTO Chyba
END
IF @RealMnoz = 1
BEGIN
IF @NZB = 1
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_NZB_UpravyPoRealizaci' 
EXEC @ret = dbo.hp_NZB_UpravyPoRealizaci @IDPohyb
END
ELSE
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_DosleObj_UpravyPoRealizaci' 
EXEC @ret = dbo.hp_DosleObj_UpravyPoRealizaci @IDPohyb, 1
END
IF @@ERROR <> 0 OR @ret <> 0 GOTO Chyba
END
END
CLOSE Cur
DEALLOCATE Cur
EXEC hp_loguj 'checkpoint', '', 'konec kurzoru pres vsechny pohyby, ktere jeste nejsou realizovane' 
IF @OZDSNNavDok = 1 AND
@IDNewDokladDSN IS NOT NULL
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZRealDSNPrijemEnd' 
EXEC hp_OZRealDSNPrijemEnd
@IDNewDokladDSN, @DatumRealizace, @OZDSNAutoReal, @BylaChyba OUT
IF @BylaChyba = 1
GOTO ChybaTran
END
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
EXEC hp_loguj 'checkpoint', '', 'kurzor pro vsechny navazne polozky proved doplneni' 
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
IF @@ERROR<>0
BEGIN
CLOSE cZMO
DEALLOCATE cZMO
CLOSE CurSluzPol
DEALLOCATE CurSluzPol
GOTO ChybaTran
END
END
CLOSE cZMO
DEALLOCATE cZMO
EXEC hp_loguj 'checkpoint', '', 'konec kurzoru pro vsechny navazne polozky proved doplneni' 
END
CLOSE CurSluzPol
DEALLOCATE CurSluzPol
EXEC hp_loguj 'checkpoint', '', 'konec kurzoru - vybira pohyby sluzbovych polozek, kde doklad neni realizovany' 
END
IF @RealFin = 1
INSERT INTO TabOZRealHist (IDDoklad) VALUES (@ID)
EXEC hp_loguj 'checkpoint', '', 'nastav datum realizace a shod blokovani' 
UPDATE TabDokladyZbozi SET
DatRealizace = CASE WHEN @RealFin  = 1 THEN @DatumRealizace ELSE DatRealizace END,
DatRealMnoz  = CASE WHEN @RealMnoz = 1 THEN @DatumRealizace ELSE DatRealMnoz END,
BlokovaniEditoru = NULL,
AutorRealMno     = CASE WHEN @RealMnoz= 1 THEN SUSER_SNAME() ELSE AutorRealMno END,
AutorRealFin     = CASE WHEN @RealFin = 1 THEN SUSER_SNAME() ELSE AutorRealFin END,
ECCelkemDokl     = CASE WHEN @RealFin = 1 THEN(SELECT SUM(CCEvid)     FROM TabPohybyZbozi WHERE IDDoklad = @ID) ELSE ECCelkemDokl END,
ECCelkemDoklUcto = CASE WHEN @RealFin = 1 THEN(SELECT SUM(CCEvidUcto) FROM TabPohybyZbozi WHERE IDDoklad = @ID) ELSE ECCelkemDoklUcto END,
SNCelkemDokl     = CASE WHEN @RealFin = 1 THEN(SELECT ISNULL(SUM(KcCelkem),0) FROM TabSouvNakladyPol WHERE IDDokladu = @ID) ELSE SNCelkemDokl END
WHERE ID = @ID
IF @@ERROR <> 0 GOTO ChybaTran
IF @RealMnoz = 1 AND @DruhPohybuZbo = 0
BEGIN
SET @IDInv = NULL
SELECT @IDInv = ID
FROM TabInvHead
WHERE IDPrijem = @ID
AND TypInv = 0
IF @IDInv IS NOT NULL
BEGIN
EXEC hp_loguj 'checkpoint', '', 'hp_OZInvDokReal' 
EXEC dbo.hp_OZInvDokReal @ID, @IDInv
END
END
IF OBJECT_ID(N'dbo.ep_P01','P')IS NOT NULL
BEGIN
IF @RealMnoz = 0 OR @RealFin = 0
BEGIN
SET @ErrStr = dbo.hf_FormatError(72132, '')
RAISERROR(@ErrStr, 16, 1)
GOTO ChybaTran
END ELSE
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_P01 - start - OZ - realizace - na konci procesu realizace příjmů.',1
EXEC dbo.ep_P01 @ID
IF @@ERROR <> 0
GOTO ChybaTran
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_P01 - stop',1
END
END
IF @RealMnoz = 1 AND
OBJECT_ID(N'dbo.ep_Ekokom2021_PV','P') IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_Ekokom2021_PV - start',1
EXEC dbo.ep_Ekokom2021_PV @ID, @DruhPohybuZbo
IF @@ERROR <> 0 GOTO ChybaTran
EXEC hp_loguj 'stop','User_Ep_procedure','' ,1,0,'ep_Ekokom2021_PV - stop',1
END
IF @TrCount = 0
COMMIT TRANSACTION
GOTO Konec
Chyba:
CLOSE Cur
DEALLOCATE Cur
ChybaTran:
IF @TrCount = 0 ROLLBACK
ChybaMimo:
SET @BylaChyba = 1
EXEC hp_loguj 'checkpoint', '', 'stop hp_Realizuj_Prijem' 
RETURN
Konec:
EXEC hp_loguj 'checkpoint', '', 'stop hp_Realizuj_Prijem'
GO
