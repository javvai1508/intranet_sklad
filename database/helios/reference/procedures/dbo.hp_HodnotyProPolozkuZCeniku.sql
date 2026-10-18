-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_HodnotyProPolozkuZCeniku]
@IDDoklad              INT,            -- 1. ID hlavicky ciloveho dokladu (Obeh, UctenkaH, DObj)
@DruhPohybu            INT,            -- 2. druh pohybu zbozi ciloveho dokladu
@CisloOrg              INT,            -- 3. cislo organizace
@IDZboSklad            INT,            -- 4. ID skladove karty
@IDDokladCenik         INT,            -- 5. ID hlavicky nabidkove sestavy
@VstupniCena           INT,            -- 6. druh vstupni ceny ciloveho dokladu
@Mnozstvi    NUMERIC(19,6),            -- 7. mnozstvi na cilovem dokladu
@CoMamDelat            INT,            -- 8. pozadovana akce
@DatPorizeni           DATETIME,       -- 9. rozhodne datum pro hledani akce
@IDAkce                INT OUT,        -- 10. pro @CoMamDelat=0,2 OUTem vraci nalezenou akci,
@UplatnitSlevy         BIT OUT,        -- 11. zda uplatnit slevy dle akce, pripadne dle TabSozNa
@Selectem              BIT,            -- 12. vratit vysledek selectem
@Nalezeno              BIT = 0 OUT,    -- 13. hodnota byla nalezena
@Cena        NUMERIC(19,6) = 0 OUT,    -- 14. zjistena cena (JC ci CC dle VstupniCeny)
@MJ          NVARCHAR(10)  = NULL OUT, -- 15. MJ ciloveho dokladu
@SazbaDPH    NUMERIC(5,2)  = NULL OUT, -- 16. Sazba DPH
@SazbaSD     NUMERIC(19,6) = 0 OUT,    -- 17. Sazba SD
@RadaUctenek NVARCHAR(3)   = NULL,     -- 18. rada uctenek
@CisloTabulkyDObj      INT = 0,        -- 19. tabulka DObj 123
@Vstup                 BIT = NULL,     -- 20. 0=vystup=prodej / 1=vstup=nakup
@ZdrojCeny             BIT = 0,        -- 21. zapis do tabulky zdroj ceny
@SlevaMnozstviAbsolutne BIT = 0,       -- 22. Aplikuj vypocet slevy pro mnozstvi v absolutni hodnote
@VstupCenaNC           INT = NULL OUT, -- 23. druh vstupni ceny dle TabSoznaCeny
@VysledekHledaniAkceCenik TINYINT = 2 OUT, -- 24. vysledek ze slepice ep_VyberZVicePlatnychAkci
@PouzitaMenaAkce       NVARCHAR(3)  = NULL -- 25. pouzita mena pro hledani akce, jinak se dohledava z hlavicky dokladu
AS
SET NOCOUNT ON
DECLARE @HMena         NVARCHAR(3)   -- hlavni mena dle TabKodMen
DECLARE @CMena         NVARCHAR(3)   -- mena na hlavicce ceniku
DECLARE @Mena          NVARCHAR(3)   -- mena           na hlavicce ciloveho dokladu
DECLARE @Kurz          NUMERIC(19,6) -- kurz           na hlavicce ciloveho dokladu
DECLARE @KurzEuro      NUMERIC(19,6) -- kurz euro      na hlavicce ciloveho dokladu
DECLARE @JednotkaMeny  INT           -- jednotka meny  na hlavicce ciloveho dokladu
DECLARE @IDPohybu      INT           -- ID prislusne polozky z nabidkove sestavy typu cenik
DECLARE @MJCenik       NVARCHAR(10)  -- merna jednotka ceniku
DECLARE @MnozstviCenik NUMERIC(19,6) -- mnozstvi ciloveho dokladu prepoctene na MJ ceniku
DECLARE @IDKmenZbozi   INT           -- ID prislusne kmenove karty
DECLARE @IDAkceCenik   INT           -- ID hlavicky nabidkove sestavy dle akce
DECLARE @NCBezDPH      NCHAR         -- cena je A=bezDPH  / N=sDPH  / S=seSD
DECLARE @PomUplatnitSlevy BIT
DECLARE @JCbezDaniKC       NUMERIC(19,6)
DECLARE @JCsDPHKc          NUMERIC(19,6)
DECLARE @JCbezDaniSlevaKc  NUMERIC(19,6)
DECLARE @JCsDPHSlevaKc     NUMERIC(19,6)
DECLARE @JCbezDaniVal      NUMERIC(19,6)
DECLARE @JCsDPHVal         NUMERIC(19,6)
DECLARE @JCbezDaniSlevaVal NUMERIC(19,6)
DECLARE @JCsDPHSlevaVal    NUMERIC(19,6)
DECLARE @CCbezDaniKC       NUMERIC(19,6)
DECLARE @CCsDPHKc          NUMERIC(19,6)
DECLARE @CCbezDaniSlevaKc  NUMERIC(19,6)
DECLARE @CCsDPHSlevaKc     NUMERIC(19,6)
DECLARE @CCbezDaniVal      NUMERIC(19,6)
DECLARE @CCsDPHVal         NUMERIC(19,6)
DECLARE @CCbezDaniSlevaVal NUMERIC(19,6)
DECLARE @CCsDPHSlevaVal    NUMERIC(19,6)
DECLARE @JCSSDKc           NUMERIC(19,6)
DECLARE @CCSSDKc           NUMERIC(19,6)
DECLARE @JCSSDVal          NUMERIC(19,6)
DECLARE @CCSSDVal          NUMERIC(19,6)
DECLARE @In_MJ             NVARCHAR(10)  -- puvodni hodnota MJ
DECLARE @In_SazbaSD        NUMERIC(19,6) -- puvodni hodnota sazby
DECLARE @In_SazbaDPH       NUMERIC(5,2)  -- puvodni hodnota sazby
DECLARE @AktDatum          DATETIME
DECLARE @PlatiOd           DATETIME
DECLARE @PlatiDo           DATETIME
DECLARE @IDDokladCenikOld  INT
DECLARE @PocetRadek        INT
DECLARE @Skryt             BIT
DECLARE @DatPorizeniCur    DATETIME
IF @Vstup IS NULL
IF @DruhPohybu IN (2,3,4,5,9,10,11,13,14,15,30,53,67)
SET @Vstup = 0 ELSE
SET @Vstup = 1
SELECT @IDKmenZbozi = IDKmenZbozi
FROM TabStavSkladu
WHERE ID = @IDZboSklad
IF OBJECT_ID(N'tempdb..#TabZdrojCeny', N'U') IS NULL
SET @ZdrojCeny = 0
EXEC hp_HodPolDotahniZHlav @IDDoklad, @DruhPohybu, @CisloTabulkyDObj, @HMena OUT,
@DatPorizeni OUT, @Mena OUT, @JednotkaMeny OUT, @Kurz OUT, @KurzEuro OUT
IF @PouzitaMenaAkce IS NOT NULL
SET @Mena = @PouzitaMenaAkce
SET @AktDatum = GETDATE()
SET @DatPorizeni = CONVERT(DATETIME,CONVERT(INT,CONVERT(FLOAT,ISNULL(@DatPorizeni,@AktDatum))))
SET @In_MJ         = @MJ
SET @In_SazbaSD    = @SazbaSD
SET @In_SazbaDPH   = @SazbaDPH
SET @UplatnitSlevy = 1
IF @DruhPohybu <> 4
BEGIN
SET @IDAkceCenik = NULL
IF OBJECT_ID(N'tempdb..#TabPlatneAkce', N'U') IS NOT NULL
TRUNCATE TABLE #TabPlatneAkce
ELSE
CREATE TABLE #TabPlatneAkce(IDAkceCenik INT, IDAkce INT, UplatnitSlevy BIT, DatPorizeni DATETIME)
IF @CoMamDelat IN(0,2)
BEGIN
IF EXISTS(
SELECT * FROM TabAkce
WHERE IDCenik IS NOT NULL)
BEGIN
INSERT INTO #TabPlatneAkce
SELECT
D.ID,
A.ID,
A.UplatnitSlevy,
D.DatPorizeni
FROM TabAkce         AS A
JOIN TabDokladyZbozi AS D ON D.ID = A.IDCenik
JOIN TabPohybyZbozi  AS P ON P.IDDoklad = D.ID
WHERE P.IDZboSklad = @IDZboSklad
AND A.StavAkce = 1
AND D.DruhCU = 1 - @Vstup
AND ((ISNULL(D.TerminDodavkyDat_X, '19000101') <= @DatPorizeni) OR (@ZdrojCeny = 1))
AND ((ISNULL(D.DatUhrady_X,        '30000101') >= @DatPorizeni) OR (@ZdrojCeny = 1))
AND (@Mena  = ISNULL(D.Mena, @HMena) OR
@Hmena = ISNULL(D.Mena, @HMena))
AND ((A.TypZakazOrg = 0 AND (NOT EXISTS(
SELECT * FROM TabAkceZakazOrg
WHERE IDAkce = A.ID AND CisloOrg = ISNULL(@CisloOrg, -999)))) OR
(A.TypZakazOrg = 1 AND EXISTS(
SELECT * FROM TabAkceZakazOrg
WHERE IDAkce = A.ID AND CisloOrg = ISNULL(@CisloOrg, -999))))
AND (@RadaUctenek IS NULL OR
(@RadaUctenek IS NOT NULL AND
((A.TypZakazRadaUct = 0 AND (NOT EXISTS(
SELECT * FROM TabAkceZakazRadaU
WHERE IDAkce = A.ID AND RadaUctenek = @RadaUctenek))) OR
(A.TypZakazRadaUct = 1 AND EXISTS(
SELECT * FROM TabAkceZakazRadaU
WHERE IDAkce = A.ID AND RadaUctenek = @RadaUctenek)))))
ORDER BY
CASE WHEN @Mena = ISNULL(D.Mena, @HMena) THEN 0 ELSE
CASE WHEN @HMena= ISNULL(D.Mena, @HMena) THEN 1 ELSE 2 END END,
CASE WHEN @ZdrojCeny = 1 AND(
(@DatPorizeni >= D.TerminDodavkyDat_X OR D.TerminDodavkyDat_X IS NULL) AND
(@DatPorizeni <= D.DatUhrady_X        OR D.DatUhrady_X IS NULL)) THEN 0 ELSE 1 END,
D.DatPorizeni DESC, D.ID DESC
END
IF @@ROWCOUNT > 1
BEGIN
IF OBJECT_ID('dbo.ep_VyberZVicePlatnychAkci','P') IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_VyberZVicePlatnychAkci - start -  Ceníkové akce',1
EXEC dbo.ep_VyberZVicePlatnychAkci @DatPorizeni, @CisloOrg, @IDZboSklad,
@IDAkceCenik OUT, @IDAkce OUT, @UplatnitSlevy OUT, @VysledekHledaniAkceCenik OUT
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_VyberZVicePlatnychAkci - stop',1
END
IF @VysledekHledaniAkceCenik = 0
BEGIN
SET @IDAkceCenik = NULL
SET @UplatnitSlevy = 1
SET @IDAkce = NULL
GOTO konecStandartniHledaniAkce
END
ELSE
IF @VysledekHledaniAkceCenik = 1
BEGIN
DECLARE @IDAkceZeSlepice INT = @IDAkce
GOTO konecStandartniHledaniAkce
END
ELSE
IF @VysledekHledaniAkceCenik = 2 GOTO zacatekStandartniHledaniAkce
END
ELSE
zacatekStandartniHledaniAkce:
BEGIN
SELECT TOP 1
@IDAkceCenik   = IDAkceCenik,
@IDAkce        = IDAkce,
@UplatnitSlevy = UplatnitSlevy
FROM
#TabPlatneAkce
ORDER BY
DatPorizeni DESC,
IDAkceCenik DESC
IF @@ROWCOUNT = 0
BEGIN
SET @IDAkceCenik   = NULL
SET @UplatnitSlevy = 1
SELECT @IDAkce = IDAkce
FROM TabStavSkladu WHERE ID = @IDZboSklad
END
END
konecStandartniHledaniAkce:
END ELSE
BEGIN
IF @IDAkce IS NOT NULL
BEGIN
SELECT @IDAkceCenik = IDCenik, @UplatnitSlevy = UplatnitSlevy
FROM TabAkce WHERE ID = @IDAkce
INSERT INTO #TabPlatneAkce (IDAkceCenik, IDAkce, UplatnitSlevy, DatPorizeni)
VALUES (@IDAkceCenik, @IDAkce, @UplatnitSlevy, @DatPorizeni)
END
END
IF @IDDokladCenik IS NOT NULL AND @IDDokladCenik <> 0
SET @IDDokladCenikOld = @IDDokladCenik
IF @IDAkceCenik IS NOT NULL
BEGIN
SET @IDDokladCenik = @IDAkceCenik
END
IF @SlevaMnozstviAbsolutne = 1
SET @Mnozstvi = ABS(@Mnozstvi)
IF @CoMamDelat = 2 AND @ZdrojCeny = 0
RETURN
END
IF @DruhPohybu = 67
SET @DruhPohybu=CASE WHEN @Vstup=0 THEN 2 ELSE 0 END
SET @Nalezeno = 0
IF @IDDokladCenik IS NOT NULL AND @VysledekHledaniAkceCenik <> 0
BEGIN
DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
SELECT IDAkceCenik, IDAkce, UplatnitSlevy, DatPorizeni FROM #TabPlatneAkce
UNION
SELECT @IDDokladCenikOld AS IDAkceCenik, NULL, 1, '19000101' AS DatPorizeni WHERE @IDDokladCenikOld IS NOT NULL AND @IDDokladCenikOld <> 0
ORDER BY DatPorizeni DESC, IDAkceCenik DESC
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDDokladCenik, @IDAkce, @UplatnitSlevy, @DatPorizeniCur
IF @@fetch_status<>0 BREAK
IF @VysledekHledaniAkceCenik = 1 AND @IDAkceZeSlepice IS NOT NULL
BEGIN
SELECT
@IDDokladCenik  = IDAkceCenik,
@IDAkce         = IDAkce,
@UplatnitSlevy  = UplatnitSlevy,
@DatPorizeniCur = DatPorizeni
FROM
#TabPlatneAkce
WHERE
IDAkce = @IDAkceZeSlepice
END
SET @Nalezeno = 0
IF @IDDokladCenik IS NOT NULL AND EXISTS(
SELECT * FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad)
BEGIN
SET @IDPohybu = NULL
IF @MJ IS NULL
SELECT TOP 1 @IDPohybu = ID FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad
AND Mnozstvi  <= @Mnozstvi
ORDER BY Mnozstvi DESC, CCbezDaniKC DESC
ELSE
IF EXISTS(
SELECT * FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad AND MJ = @MJ)
SELECT TOP 1 @IDPohybu = ID FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad AND MJ = @MJ
AND Mnozstvi  <= @Mnozstvi
ORDER BY Mnozstvi DESC, CCbezDaniKC DESC
ELSE
BEGIN
SELECT TOP 1 @MJCenik = MJ FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad AND MJ IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
SELECT TOP 1 @IDPohybu = ID FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad
AND Mnozstvi  <= @Mnozstvi
ORDER BY Mnozstvi DESC, CCbezDaniKC DESC
IF @@ROWCOUNT <> 0 AND @ZdrojCeny = 0 SET @MJ = NULL
END
ELSE
BEGIN
SET @MnozstviCenik = @Mnozstvi
EXEC dbo.hp_PrepoctiDleMJ @MJ, @MJCenik, @MnozstviCenik OUT, 1, 1, @IDKmenZbozi, 0
SELECT TOP 1 @Cena = CHOOSE(@VstupniCena + 1,
JCbezDaniKc,  JCsDPHKc,  JCbezDaniKc,  JCsDPHKc,
JCbezDaniVal, JCsDPHVal, JCbezDaniVal, JCsDPHVal,
JCsSDKc,      JCsSDKc,   JCsSDVal,     JCsSDVal),
@SazbaDPH = SazbaDPH,
@SazbaSD  = SazbaSD
FROM TabPohybyZbozi
WHERE IDDoklad = @IDDokladCenik
AND IDZboSklad = @IDZboSklad
AND MJ = @MJCenik AND Mnozstvi <= @MnozstviCenik
ORDER BY Mnozstvi DESC, CCbezDaniKC DESC
IF @@ROWCOUNT = 1
BEGIN
SET @Nalezeno = 1
EXEC dbo.hp_PrepoctiDleMJ @MJCenik, @MJ, @Cena OUT, 1, 0, @IDKmenZbozi, 0
IF @VstupniCena IN(2,3,6,7,9,11)
SET @Cena = @Cena * @Mnozstvi
END
SET @IDPohybu = NULL
END
END
IF @IDPohybu IS NOT NULL
BEGIN
SET @Nalezeno = 1
SELECT @Cena = CHOOSE(@VstupniCena + 1,
JCbezDaniKc,  JCsDPHKc,  JCbezDaniKc  * @Mnozstvi, JCsDPHKc  * @Mnozstvi,
JCbezDaniVal, JCsDPHVal, JCbezDaniVal * @Mnozstvi, JCsDPHVal * @Mnozstvi,
JCsSDKc,   JCsSDKc      * @Mnozstvi,
JCsSDVal,  JCsSDVal     * @Mnozstvi),
@MJ = ISNULL(@MJ, MJ),
@SazbaDPH = SazbaDPH,
@SazbaSD  = SazbaSD
FROM TabPohybyZbozi
WHERE ID = @IDPohybu
END
IF @Nalezeno = 1
BEGIN
SELECT @CMena = ISNULL(Mena, @HMena) FROM TabDokladyZbozi
WHERE ID = @IDDokladCenik
IF @VstupniCena IN (4,5,6,7,10,11) AND @CMena = @HMena
BEGIN
EXEC dbo.hp_VypCenOZPolozek_Prepocet_Kc_Val_a_Val_Kc
@Cena, @Cena OUT, 0, @Kurz, @KurzEuro, @JednotkaMeny, @Mena
END
IF @ZdrojCeny = 1
BEGIN
SELECT @PlatiOd = TerminDodavkyDat_X, @PlatiDo = DatUhrady_X
FROM TabDokladyZbozi WHERE ID = @IDDokladCenik
SET @Skryt = CASE WHEN (@DatPorizeni>=@PlatiOd OR @PlatiOd IS NULL) AND
(@DatPorizeni<=@PlatiDo OR @PlatiDo IS NULL) THEN 0 ELSE 1 END
INSERT #TabZdrojCeny(ZdrojCeny, ZdrojCU, CenovaUroven, Priorita, Cena,
JCBezDaniKc, JCSSDKc, JCSDPHKc, JCBezDaniVal, JCSSDVal, JCSDPHVal,
Aktivni, PlatiOd, PlatiDo, Skryt, Mena, Kurz, JednotkaMeny)
SELECT
CASE WHEN @IDAkceCenik IS NOT NULL THEN 1  ELSE 2  END, NULL, NULL,
CASE WHEN @IDAkceCenik IS NOT NULL THEN 50 ELSE 40 END, @Cena,
ISNULL(@JCBezDaniKc,0),  ISNULL(@JCSSDKc,0),  ISNULL(@JCSDPHKc,0),
ISNULL(@JCBezDaniVal,0), ISNULL(@JCSSDVal,0), ISNULL(@JCSDPHVal,0),
CASE WHEN EXISTS(SELECT * FROM #TabZdrojCeny WHERE Aktivni = 1) THEN 0 ELSE 1 END,
@PlatiOd, @PlatiDo, @Skryt, @Mena, ISNULL(@Kurz,1), ISNULL(@JednotkaMeny,1)
END
END
END
IF @ZdrojCeny = 0 OR @VysledekHledaniAkceCenik = 1 BREAK
END
CLOSE Cur
DEALLOCATE Cur
END
IF @Nalezeno = 0 OR @ZdrojCeny = 1
BEGIN
SELECT TOP 1
@Cena     = C.SozCena,
@NCBezDPH = C.BezDPH,
@PomUplatnitSlevy = K.UplatnitSlevy,
@PlatiOd = C.PlatiOd,
@PlatiDo = C.PlatiDo
FROM TabSozNaCeny AS C
JOIN TabSozNa     AS K ON K.ID = C.IDSozNa
JOIN TabSoz       AS S ON S.ID = K.IDSoz
JOIN TabCisOrg    AS O ON O.IDSozSleva = S.ID AND O.CisloOrg = @CisloOrg
WHERE K.IDKmenZbo = @IDKmenZbozi
AND (ISNULL(C.PlatiDo, @DatPorizeni) >= @DatPorizeni)
AND (ISNULL(C.PlatiOd, @DatPorizeni) <= @DatPorizeni)
AND ISNULL(C.Mena, @HMena) = ISNULL(@Mena, @Hmena)
AND ISNULL(C.MJ, '')       = ISNULL(@MJ, '')
AND C.OdMnozstvi <= @Mnozstvi
AND (C.DruhCU = 2 OR C.DruhCU = (1-@Vstup))
ORDER BY
C.OdMnozstvi DESC,
ISNULL(C.PlatiDo, '99991231 23:59:59.000'),
ISNULL(C.PlatiOd, '19000101 00:00:00.000')
SET @PocetRadek  = @@ROWCOUNT
IF @PocetRadek = 0 AND (@ZdrojCeny = 1)
BEGIN
SELECT TOP 1
@Cena     = C.SozCena,
@NCBezDPH = C.BezDPH,
@PomUplatnitSlevy = K.UplatnitSlevy,
@PlatiOd = C.PlatiOd,
@PlatiDo = C.PlatiDo
FROM TabSozNaCeny AS C
JOIN TabSozNa     AS K ON K.ID = C.IDSozNa
JOIN TabSoz       AS S ON S.ID = K.IDSoz
JOIN TabCisOrg    AS O ON O.IDSozSleva = S.ID AND O.CisloOrg = @CisloOrg
WHERE K.IDKmenZbo = @IDKmenZbozi
AND ISNULL(C.Mena, @HMena) = ISNULL(@Mena, @Hmena)
AND ISNULL(C.MJ, '')       = ISNULL(@MJ, '')
AND C.OdMnozstvi <= @Mnozstvi
AND (C.DruhCU = 2 OR C.DruhCU = (1-@Vstup))
ORDER BY
C.ID DESC,
C.OdMnozstvi DESC,
ISNULL(C.PlatiDo, '99991231 23:59:59.000'),
ISNULL(C.PlatiOd, '19000101 00:00:00.000')
SET @PocetRadek  = @@ROWCOUNT
END
IF @PocetRadek = 1
BEGIN
SET @Nalezeno = 1
SET @UplatnitSlevy = @PomUplatnitSlevy
IF ISNULL(@Mena, @Hmena) = @HMena
BEGIN
IF @NCBezDPH = N'A' SET @VstupCenaNC = 0 ELSE
IF @NCBezDPH = N'N' SET @VstupCenaNC = 1 ELSE
IF @NCBezDPH = N'S' SET @VstupCenaNC = 8
END ELSE
BEGIN
IF @NCBezDPH = N'A' SET @VstupCenaNC = 4 ELSE
IF @NCBezDPH = N'N' SET @VstupCenaNC = 5 ELSE
IF @NCBezDPH = N'S' SET @VstupCenaNC = 10
END
IF @VstupCenaNC =  0 SET @JCbezDaniKC  = @Cena ELSE
IF @VstupCenaNC =  1 SET @JCsDPHKc     = @Cena ELSE
IF @VstupCenaNC =  4 SET @JCbezDaniVal = @Cena ELSE
IF @VstupCenaNC =  5 SET @JCsDPHVal    = @Cena ELSE
IF @VstupCenaNC =  8 SET @JCSSDKc      = @Cena ELSE
IF @VstupCenaNC = 10 SET @JCSSDVal     = @Cena
DECLARE @SazbaDPHW NUMERIC(5,2)
DECLARE @SazbaSDW NUMERIC(19,6)
SET @SazbaDPHW = CASE WHEN @ZdrojCeny = 1 THEN @In_SazbaDPH ELSE @SazbaDPH END
SET @SazbaSDW = CASE WHEN @ZdrojCeny = 1 THEN @In_SazbaSD ELSE @SazbaSD END
EXEC dbo.hp_VypCenOZPolozek @VstupCenaNC,
@JCBezDaniKc  OUT, @JCSSDKc  OUT, @JCSDPHKc  OUT, NULL,
@CCBezDaniKc  OUT, @CCSSDKc  OUT, @CCSDPHKc  OUT, NULL,
@JCBezDaniVal OUT, @JCSSDVal OUT, @JCSDPHVal OUT, NULL,
@CCBezDaniVal OUT, @CCSSDVal OUT, @CCSDPHVal OUT, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
0, 0, 0, 0, 0, 0, NULL, NULL, 9362, @DruhPohybu, @SazbaSDW,
@SazbaDPHW, @Mnozstvi, @Mena, @Kurz, @JednotkaMeny, @KurzEuro, 0, 0
IF @VstupniCena = 0  SET @Cena = @JCbezDaniKC  ELSE
IF @VstupniCena = 1  SET @Cena = @JCsDPHKC     ELSE
IF @VstupniCena = 2  SET @Cena = @CCbezDaniKC  ELSE
IF @VstupniCena = 3  SET @Cena = @CCsDPHKC     ELSE
IF @VstupniCena = 4  SET @Cena = @JCbezDaniVal ELSE
IF @VstupniCena = 5  SET @Cena = @JCsDPHVal    ELSE
IF @VstupniCena = 6  SET @Cena = @CCbezDaniVal ELSE
IF @VstupniCena = 7  SET @Cena = @CCsDPHVal    ELSE
IF @VstupniCena = 8  SET @Cena = @JCsSDKC      ELSE
IF @VstupniCena = 9  SET @Cena = @CCsSDKC      ELSE
IF @VstupniCena = 10 SET @Cena = @JCsSDVal     ELSE
IF @VstupniCena = 11 SET @Cena = @CCsSDVal
IF @ZdrojCeny = 1
BEGIN
SET @Skryt = CASE WHEN (@DatPorizeni>=@PlatiOd OR @PlatiOd IS NULL) AND
(@DatPorizeni<=@PlatiDo OR @PlatiDo IS NULL) THEN 0 ELSE 1 END
INSERT #TabZdrojCeny(ZdrojCeny, ZdrojCU, CenovaUroven, Priorita, Cena,
JCBezDaniKc, JCSSDKc, JCSDPHKc, JCBezDaniVal, JCSSDVal, JCSDPHVal,
Aktivni, PlatiOd, PlatiDo, Skryt, Mena, Kurz, JednotkaMeny)
SELECT 3, NULL, NULL, 30, ISNULL(@Cena,0),
ISNULL(@JCBezDaniKc,0),  ISNULL(@JCSSDKc,0),  ISNULL(@JCSDPHKc,0),
ISNULL(@JCBezDaniVal,0), ISNULL(@JCSSDVal,0), ISNULL(@JCSDPHVal,0),
CASE WHEN EXISTS(SELECT * FROM #TabZdrojCeny WHERE Aktivni = 1) THEN 0 ELSE 1 END,
@PlatiOd, @PlatiDo, @Skryt, @Mena, ISNULL(@Kurz,1), ISNULL(@JednotkaMeny,1)
END
END
END
IF @Nalezeno = 0
BEGIN
SET @MJ       = @In_MJ
SET @SazbaSD  = @In_SazbaSD
SET @SazbaDPH = @In_SazbaDPH
END
IF @In_SazbaDPH IS NOT NULL
SET @SazbaDPH = @In_SazbaDPH
IF @Selectem = 1
SELECT @Nalezeno AS Nalezeno,
@Cena     AS Cena,
@MJ       AS MJ,
@SazbaDPH AS SazbaDPH,
@SazbaSD  AS SazbaSD,
@IDAkce   AS IDAkce,
@UplatnitSlevy AS UplatnitSlevy,
@VstupCenaNC AS VstupCenaNC,
@VysledekHledaniAkceCenik AS VysledekHledaniAkceCenik
GO
