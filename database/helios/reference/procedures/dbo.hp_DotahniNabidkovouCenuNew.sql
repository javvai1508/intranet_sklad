-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_DotahniNabidkovouCenuNew]
@ACU                    INT,
@CisOrg                 INT,
@IDZboSklad             INT,
@Mena                   NVARCHAR(3),
@JCBezDaniKc            NUMERIC(19,6) OUT,
@JCsDPHKc               NUMERIC(19,6) OUT,
@JCBezDaniVal           NUMERIC(19,6) OUT,
@JCsDPHVal              NUMERIC(19,6) OUT,
@JCsSDKc                NUMERIC(19,6) OUT,
@JCsSDVal               NUMERIC(19,6) OUT,
@VstupniCena            INT OUT,
@Nalezeno               BIT OUT,
@Selectem               BIT = 1,
@DotahniPosledni        BIT = 1,
@IDKmen                 INT = NULL,
@AltCena                NUMERIC(19,6) = 0 OUT,
@TerminSleva_Nazev      NVARCHAR(50) = '' OUT,
@TerminSleva_Procento   NUMERIC(19,6) = 0 OUT,
@PoklProdej             BIT = 0,
@PoklProdejRada         NVARCHAR(3) = NULL,
@Prijem                 BIT = 0,             -- smer pohybu prijem/vydej
@MJ                     NVARCHAR(10) = NULL, -- merna jednotka
@Datum                  DATETIME     = NULL, -- rozhodne datum
@ZdrojCeny              BIT = 0,             -- zapis do tabulky zdroj ceny
@HistorickaCenaNalezena BIT = 0 OUT,
@IDPolozky              INT = NULL -- negativni filtrace hist. cen na aktualni polozku
AS
SET NOCOUNT ON
DECLARE @CU            INT           -- cenova uroven
DECLARE @IDNC          INT           -- TabNC.ID
DECLARE @HlMena        NVARCHAR(3)   -- hlavni mena
DECLARE @NCKc          NUMERIC(19,6) -- cena v HM dle TabNC
DECLARE @NCAltCena     NUMERIC(19,6) -- alt. cena dle TabNC
DECLARE @NCBezDPH      NCHAR         -- druh ceny dle TabNC bezDani/sDPH/seSD
DECLARE @EtalonJC      NUMERIC(19,6) -- zvolena cena nactena z TabNC
DECLARE @NCMJ          NVARCHAR(10)  -- MJ dle TabNC
DECLARE @NCVal1        NUMERIC(19,6) -- valutove ceny 1-5
DECLARE @NCVal2        NUMERIC(19,6)
DECLARE @NCVal3        NUMERIC(19,6)
DECLARE @NCVal4        NUMERIC(19,6)
DECLARE @NCVal5        NUMERIC(19,6)
DECLARE @NCMena1       NVARCHAR(3)   -- valuty 1-5
DECLARE @NCMena2       NVARCHAR(3)
DECLARE @NCMena3       NVARCHAR(3)
DECLARE @NCMena4       NVARCHAR(3)
DECLARE @NCMena5       NVARCHAR(3)
DECLARE @FazeEuro      TINYINT      -- faze  prechodu na euro
DECLARE @DatumEuro     DATETIME     -- datum prechodu na euro
DECLARE @PouzitGlobCU  TINYINT      -- pouzit prednastavenou CU
DECLARE @OZNCDleMJ     BIT          -- nabidkove ceny dle MJ
DECLARE @PrepMJStanJC  BIT          -- prepocet JC dle MJ
DECLARE @PlatNC        BIT          -- platnost NC 0=sklad 1=kmen
DECLARE @IDZdrojCeny   INT          -- ID v tabulce #TabZdrojCeny
DECLARE @Krok          INT          -- od ktereho kroku zacit hledat CU v hp_DotahniCU
DECLARE @CUZdrojCeny   INT
DECLARE @IDNCZdrojCeny INT
DECLARE @ByloDNCN      BIT          -- uz se spoustela hp_DotahniNakupniCenuNew
DECLARE @MJEvid        NVARCHAR(10) -- evidencni MJ
DECLARE @MJOut         NVARCHAR(10) -- vystupni MJ
DECLARE @MJIn          NVARCHAR(10) -- vstupni MJ
DECLARE @MJSmer        NVARCHAR(10) -- MJ pro dany smer
DECLARE @MJPrep        NVARCHAR(10) -- MJ pro prepocet ceny
IF @Datum IS NULL
SET @Datum = CONVERT(DATETIME,CONVERT(INT,CONVERT(FLOAT,GETDATE())))
IF @IDKmen IS NULL
SELECT @IDKmen = IDKmenZbozi
FROM TabStavSkladu
WHERE ID = @IDZboSklad
IF OBJECT_ID(N'tempdb..#TabZdrojCeny', N'U') IS NULL
SET @ZdrojCeny = 0
SELECT
@FazeEuro     = FazeEuro,
@DatumEuro    = DatumPrechoduNaEuro,
@OZNCDleMJ    = OZNCDleMJ,
@PrepMJStanJC = OZPrepMJStanJC,
@PlatNC       = PlatnostNabCen,
@PouzitGlobCU = CASE WHEN @Prijem = 0
THEN PouzitPrednastavenouCU
ELSE PouzitPrednastaCUNakup END
FROM TabHGlob
SELECT
@MJEvid = MJEvidence,
@MJOut  = ISNULL(MJVystup, MJEvidence),
@MJIn   = ISNULL(MJVstup,  MJEvidence)
FROM TabKmenZbozi
WHERE ID = @IDKmen
SET @MJSmer =
CASE WHEN @Prijem = 0
THEN @MJOut
ELSE @MJIn END
IF @FazeEuro NOT IN (2,3)
SET @DatumEuro = NULL
SET @Nalezeno = 0
SET @ByloDNCN = 0
IF @ACU = 0 SET @ACU = NULL
SET @Krok = 1
IF @ACU IS NULL
EXEC dbo.hp_DotahniCU @CU OUT, @CisOrg, @IDZboSklad,
@PoklProdej, @PoklProdejRada, @Prijem, @Datum, @ZdrojCeny, @Krok OUT
ELSE
SET @CU = @ACU
IF @CU IS NULL
BEGIN
IF @DotahniPosledni = 1
BEGIN
EXEC dbo.hp_DotahniNakupniCenuNew
@CisOrg, @IDZboSklad, @IDKmen,
@JCBezDaniKc  OUT, @JCsDPHKc  OUT,
@JCBezDaniVal OUT, @JCsDPHVal OUT,
@JCsSDKc      OUT, @JCsSDVal  OUT,
0, 0, @Prijem, @DatumEuro, @Mena, @ZdrojCeny, @MJ, @IDPolozky
SET @ByloDNCN = 1
END
END
ELSE
BEGIN
EXEC hp_DotahniIDNCDleCU
@IDNC OUT, @CU, @IDZboSklad, @IDKmen, @MJ, @PlatNC, @OZNCDleMJ, @Datum
IF @IDNC IS NULL AND @CU IS NOT NULL AND @ACU IS NULL AND @PouzitGlobCU IN (2,3)
WHILE 1 = 1
BEGIN
SET @Krok = @Krok + 1
EXEC dbo.hp_DotahniCU @CU OUT, @CisOrg, @IDZboSklad,
@PoklProdej, @PoklProdejRada, @Prijem, @Datum, @ZdrojCeny, @Krok OUT
IF @CU IS NULL BREAK
EXEC hp_DotahniIDNCDleCU
@IDNC OUT, @CU, @IDZboSklad, @IDKmen, @MJ, @PlatNC, @OZNCDleMJ, @Datum
IF @IDNC IS NOT NULL BREAK
END
IF @IDNC IS NULL AND @PouzitGlobCU IN (1,3)
BEGIN
IF @PoklProdej = 0
SELECT @CU =
CASE WHEN @Prijem = 0
THEN CenovaUroven
ELSE CenovaUrovenNakup END
FROM TabHGlob
ELSE
BEGIN
IF @PoklProdejRada IS NOT NULL
SELECT @CU = CenovaUroven FROM TabUctenkaRada
WHERE Cislo = @PoklProdejRada
IF @CU IS NULL
SELECT @CU = PoklProdCenUrovenProdej FROM TabHGlob
END
EXEC hp_DotahniIDNCDleCU
@IDNC OUT, @CU, @IDZboSklad, @IDKmen, @MJ, @PlatNC, @OZNCDleMJ, @Datum
END
IF @ZdrojCeny = 1
BEGIN
UPDATE #TabZdrojCeny SET IDNC = @IDNC
WHERE CenovaUroven = @CU
IF EXISTS(SELECT * FROM #TabZdrojCeny WHERE CenovaUroven IS NOT NULL AND IDNC IS NULL)
BEGIN
DECLARE cZdrojCeny CURSOR FAST_FORWARD LOCAL FOR
SELECT ID, CenovaUroven FROM #TabZdrojCeny
WHERE CenovaUroven IS NOT NULL
AND IDNC IS NULL
OPEN cZdrojCeny
WHILE 1=1
BEGIN
FETCH NEXT FROM cZdrojCeny INTO @IDZdrojCeny, @CUZdrojCeny
IF @@fetch_status<>0 BREAK
EXEC hp_DotahniIDNCDleCU
@IDNCZdrojCeny OUT, @CUZdrojCeny, @IDZboSklad, @IDKmen, @MJ, @PlatNC, @OZNCDleMJ, @Datum
UPDATE #TabZdrojCeny SET IDNC = @IDNCZdrojCeny
WHERE CenovaUroven = @CUZdrojCeny
END
CLOSE cZdrojCeny
DEALLOCATE cZdrojCeny
END
END
SET @HlMena = (SELECT Kod FROM TabKodMen WHERE HlavniMena = 1)
SELECT
@TerminSleva_Nazev    = TS.Nazev,
@TerminSleva_Procento = TS.UpravaCeny
FROM TabNCTermin    AS T
JOIN TabTerminSlevy AS TS ON T.IdTS = TS.ID
WHERE T.IdNC = @IdNC
AND GETDATE() BETWEEN TS.PlatnostOd AND TS.PlatnostDo
AND ISNULL(T.Mena, @HlMena) = ISNULL(@Mena, @HlMena)
ORDER BY TS.PlatnostOd DESC
IF @ZdrojCeny = 1
IF EXISTS(SELECT * FROM #TabZdrojCeny WHERE IDNC IS NOT NULL)
BEGIN
UPDATE T SET
T.VstupniCena =
CASE WHEN @Mena IS NOT NULL AND @Mena <> @HlMena AND
(@Mena = NC.Mena1 OR
@Mena = NC.Mena2 OR
@Mena = NC.Mena3 OR
@Mena = NC.Mena4 OR
@Mena = NC.Mena5)
THEN CASE NC.BezDPH
WHEN N'A' THEN 4
WHEN N'S' THEN 10
WHEN N'N' THEN 5 ELSE 4 END
ELSE CASE NC.BezDPH
WHEN N'A' THEN 0
WHEN N'S' THEN 8
WHEN N'N' THEN 1 ELSE 0 END END,
T.Cena = NC.CenaKC,
T.NCbezDPH = NC.BezDPH,
T.NCVal1 = NC.CenaVal1, T.NCMena1 = NC.Mena1,
T.NCVal2 = NC.CenaVal2, T.NCMena2 = NC.Mena2,
T.NCVal3 = NC.CenaVal3, T.NCMena3 = NC.Mena3,
T.NCVal4 = NC.CenaVal4, T.NCMena4 = NC.Mena4,
T.NCVal5 = NC.CenaVal5, T.NCMena5 = NC.Mena5,
T.JeNC = 1
FROM #TabZdrojCeny AS T
JOIN TabNC         AS NC ON NC.ID = T.IDNC
DECLARE cZdrojCeny CURSOR FAST_FORWARD LOCAL FOR
SELECT ID, Cena, NCBezDPH,
NCVal1, NCVal2, NCVal3, NCVal4, NCVal5,
NCMena1, NCMena2, NCMena3, NCMena4, NCMena5
FROM #TabZdrojCeny
WHERE JeNC = 1
OPEN cZdrojCeny
WHILE 1=1
BEGIN
FETCH NEXT FROM cZdrojCeny
INTO @IDZdrojCeny, @NCKc, @NCBezDPH,
@NCVal1, @NCVal2, @NCVal3, @NCVal4, @NCVal5,
@NCMena1, @NCMena2, @NCMena3, @NCMena4, @NCMena5
IF @@fetch_status<>0 BREAK
IF @NCBezDPH = N'A' SET @VstupniCena = 4 ELSE
IF @NCBezDPH = N'N' SET @VstupniCena = 5 ELSE
SET @VstupniCena = 10
IF @Mena = @NCMena1 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal1 ELSE
IF @Mena = @NCMena2 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal2 ELSE
IF @Mena = @NCMena3 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal3 ELSE
IF @Mena = @NCMena4 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal4 ELSE
IF @Mena = @NCMena5 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal5 ELSE
BEGIN
SET @EtalonJC = @NCKc
IF @NCBezDPH = N'A' SET @VstupniCena = 0 ELSE
IF @NCBezDPH = N'N' SET @VstupniCena = 1 ELSE
SET @VstupniCena = 8
END
SET @EtalonJC = ISNULL(@EtalonJC, 0)
SET @JCbezDaniKC = NULL
SET @JCsDPHKc    = NULL
SET @JCbezDaniVal= NULL
SET @JCsDPHVal   = NULL
SET @JCsSDKc     = NULL
SET @JCsSDVal    = NULL
IF @VstupniCena =  0 SET @JCbezDaniKC  = @EtalonJC ELSE
IF @VstupniCena =  1 SET @JCsDPHKc     = @EtalonJC ELSE
IF @VstupniCena =  4 SET @JCbezDaniVal = @EtalonJC ELSE
IF @VstupniCena =  5 SET @JCsDPHVal    = @EtalonJC ELSE
IF @VstupniCena =  8 SET @JCsSDKc      = @EtalonJC ELSE
IF @VstupniCena = 10 SET @JCsSDVal     = @EtalonJC
UPDATE #TabZdrojCeny SET
JCbezDaniKC = ISNULL(@JCbezDaniKC,0),
JCsDPHKc    = ISNULL(@JCsDPHKc,0),
JCbezDaniVal= ISNULL(@JCbezDaniVal,0),
JCsDPHVal   = ISNULL(@JCsDPHVal,0),
JCsSDKc     = ISNULL(@JCsSDKc,0),
JCsSDVal    = ISNULL(@JCsSDVal,0),
Mena        = @Mena
WHERE ID = @IDZdrojCeny
END
CLOSE cZdrojCeny
DEALLOCATE cZdrojCeny
END
SELECT
@NCKc      = CenaKC,
@NCAltCena = AltCena,
@NCBezDPH  = BezDPH,
@NCMJ      = MJ,
@NCVal1 = CenaVal1, @NCMena1 = Mena1,
@NCVal2 = CenaVal2, @NCMena2 = Mena2,
@NCVal3 = CenaVal3, @NCMena3 = Mena3,
@NCVal4 = CenaVal4, @NCMena4 = Mena4,
@NCVal5 = CenaVal5, @NCMena5 = Mena5
FROM TabNC WHERE ID = @IDNC
IF @@ROWCOUNT = 0
BEGIN
IF @DotahniPosledni = 1
BEGIN
EXEC dbo.hp_DotahniNakupniCenuNew
@CisOrg, @IDZboSklad, @IDKmen,
@JCBezDaniKc  OUT, @JCSDPHKc  OUT,
@JCBezDaniVal OUT, @JCSDPHVal OUT,
@JCsSDKc OUT, @JCsSDVal OUT,
0, 0, @Prijem, @DatumEuro, @Mena, @ZdrojCeny, @MJ, @IDPolozky
SET @ByloDNCN = 1
END
END
ELSE
BEGIN
IF @NCBezDPH = N'A' SET @VstupniCena = 4 ELSE
IF @NCBezDPH = N'N' SET @VstupniCena = 5 ELSE
SET @VstupniCena = 10
IF @Mena = @NCMena1 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal1 ELSE
IF @Mena = @NCMena2 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal2 ELSE
IF @Mena = @NCMena3 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal3 ELSE
IF @Mena = @NCMena4 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal4 ELSE
IF @Mena = @NCMena5 AND @Mena IS NOT NULL SET @EtalonJC = @NCVal5 ELSE
BEGIN
SET @EtalonJC = @NCKc
IF @NCBezDPH = N'A' SET @VstupniCena = 0 ELSE
IF @NCBezDPH = N'N' SET @VstupniCena = 1 ELSE
SET @VstupniCena = 8
END
SET @EtalonJC = ISNULL(@EtalonJC, 0)
SET @NCMJ   = ISNULL(@NCMJ, @MJSmer)
SET @MJPrep = ISNULL(@MJ,   @MJSMer)
IF @NCMJ   IS NOT NULL AND
@MJPrep IS NOT NULL AND
@PrepMJStanJC = 1 AND
@NCMJ <> @MJPrep
EXEC hp_PrepoctiDleMJ @NCMJ, @MJPrep, @EtalonJC OUT, 1, 0, @IDKmen, @Prijem
IF @VstupniCena =  0 SET @JCbezDaniKC  = @EtalonJC ELSE
IF @VstupniCena =  1 SET @JCsDPHKc     = @EtalonJC ELSE
IF @VstupniCena =  4 SET @JCbezDaniVal = @EtalonJC ELSE
IF @VstupniCena =  5 SET @JCsDPHVal    = @EtalonJC ELSE
IF @VstupniCena =  8 SET @JCsSDKc      = @EtalonJC ELSE
IF @VstupniCena = 10 SET @JCsSDVal     = @EtalonJC
SET @AltCena = @NCAltCena
SET @Nalezeno = 1
END
END
IF @ZdrojCeny = 1 AND @DotahniPosledni = 1 AND @ByloDNCN = 0
BEGIN
EXEC dbo.hp_DotahniNakupniCenuNew
@CisOrg, @IDZboSklad, @IDKmen,
@JCBezDaniKc, @JCSDPHKc,
@JCBezDaniVal, @JCSDPHVal,
@JCsSDKc, @JCsSDVal,
0, 0, @Prijem, @DatumEuro, @Mena, @ZdrojCeny, @MJ, @IDPolozky
SET @ByloDNCN = 1
END
SET @HistorickaCenaNalezena = @ByloDNCN
IF @Selectem = 1
SELECT
@JCBezDaniKc  AS JCBezDaniKc,  @JCsDPHKc  AS JCsDPHKc,
@JCBezDaniVal AS JCBezDaniVal, @JCsDPHVal AS JCsDPHVal,
@JCsSDKc      AS JCsSDKc,      @JCsSDVal  AS JCsSDVal,
@Nalezeno     AS Nalezeno,
@VstupniCena  AS VstupniCena,
@AltCena      AS AltCena,
@TerminSleva_Procento AS TerminSlevaProc,
@TerminSleva_Nazev    AS TerminSlevaNazev
GO
