-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_OZGetDanKlicPolo]
@IDDanKlic    INT OUT,             -- 1. danovy klic polozky
@SmerPlneni   TINYINT,             -- 2. smer plneni DPH
@IDDanRezim   INT          = NULL, -- 3. danovy rezim na hlavicce
@SazbaDPH     NUMERIC(5,2) = NULL, -- 4. procentni sazba DPH / sazba PDP
@KodZeme      NVARCHAR(3)  = NULL, -- 5. zeme plneni DPH
@Datum        DATETIME     = NULL, -- 6. rozhodne datum DUZP ci datum pripadu
@IDDokZbo     INT          = NULL, -- 7. ID hlavicky dokladu    (jen pro OZ)
@IDDruhDokZbo INT          = NULL, -- 8. ID typove rady dokladu (jen pro OZ)
@IDKmenZbozi  INT          = NULL, -- 9. ID kmenove karty
@IDZboSklad   INT          = NULL, -- 10. ID skladove karty
@RezimMOSS    TINYINT      = 0     -- 11. Rezim OSS - One stop shop
AS
SET NOCOUNT ON
DECLARE @DruhSazbyDPH TINYINT -- druh sazby DPH na polozce
DECLARE @ZboziSluzba  TINYINT -- 0=neurceno 1=zbozi 2=sluzba
DECLARE @PocetDK      INT     -- zjisteny pocet danovych klicu
DECLARE @PocetDKVcetneNeaktiv      INT     -- zjisteny pocet danovych klicu v prvnim cyklu vcetne neaktivnich (pomocna promenna)
DECLARE @HledatAktivniCnt INT -- hledat v selectech vsechy nebo jen aktivni danove klice
SET @IDDanKlic = NULL
IF @IDDruhDokZbo IS NULL AND
@IDDokZbo IS NOT NULL
SELECT @IDDruhDokZbo = R.ID
FROM TabDokladyZbozi AS D
JOIN TabDruhDokZbo   AS R
ON  R.RadaDokladu   = D.RadaDokladu
AND R.DruhPohybuZbo = D.DruhPohybuZbo
WHERE D.ID = @IDDokZbo
IF EXISTS(SELECT * FROM TabDruhDokZbo
WHERE ID = @IDDruhDokZbo AND PouzivatDanoveKlice = 0)
RETURN
IF @Datum IS NULL SET @Datum = GETDATE()
IF @KodZeme IS NULL
SELECT @KodZeme = ISOKod FROM TabZeme WHERE Vlastni = 1
EXEC hp_OZGetDruhSazbyDPH
@DruhSazbyDPH OUT, @SazbaDPH, @KodZeme, @Datum
IF @DruhSazbyDPH IS NULL
RETURN
SET @ZboziSluzba = 0
IF @IDDokZbo IS NOT NULL
SELECT @ZboziSluzba = ZboziSluzba
FROM TabDokladyZbozi WHERE ID = @IDDokZbo
IF @ZboziSluzba = 0
BEGIN
IF @IDKmenZbozi IS NULL AND
@IDZboSklad IS NOT NULL
SELECT @IDKmenZbozi = IDKmenZbozi
FROM TabStavSkladu WHERE ID = @IDZboSklad
IF @IDKmenZbozi IS NOT NULL
SELECT @ZboziSluzba = ZboziSluzba
FROM TabKmenZbozi WHERE ID = @IDKmenZbozi
END
IF @ZboziSluzba = 0
IF @IDKmenZbozi IS NOT NULL
BEGIN
SELECT @ZboziSluzba = S.ZboziSluzba
FROM TabSkupinyZbozi AS S
JOIN TabKmenZbozi    AS K ON K.SkupZbo = S.SkupZbo
WHERE K.ID = @IDKmenZbozi
END
IF @IDDanRezim IS NULL
BEGIN
SET @PocetDK = 0
IF @ZboziSluzba IN (1,2)
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = @ZboziSluzba
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = @ZboziSluzba
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
IF @IDDanKlic IS NULL AND @PocetDK = 0
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = 0
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = 0
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
IF @IDDanKlic IS NULL AND @PocetDK = 0 AND @ZboziSluzba = 0
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
END ELSE
BEGIN
IF @ZboziSluzba IN(1,2)
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim    = @IDDanRezim
AND ((R.Prednastaveno = 2 AND @ZboziSluzba = 1) OR
(R.Prednastaveno = 3 AND @ZboziSluzba = 2))
AND   D.ISOKodZeme    = @KodZeme
AND   K.SmerPlneni    = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH      = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH  = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
IF @IDDanKlic IS NULL
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim    = @IDDanRezim
AND   R.Prednastaveno = 1
AND   D.ISOKodZeme    = @KodZeme
AND   K.SmerPlneni    = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH      = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH  = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
IF @IDDanKlic IS NULL
IF @ZboziSluzba = 0
BEGIN
SET @PocetDK = 0
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim    = @IDDanRezim
AND   R.Prednastaveno IN(2,3)
AND   D.ISOKodZeme    = @KodZeme
AND   K.SmerPlneni    = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH      = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH  = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim    = @IDDanRezim
AND   R.Prednastaveno IN(2,3)
AND   D.ISOKodZeme    = @KodZeme
AND   K.SmerPlneni    = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH      = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH  = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
END
IF @IDDanKlic IS NULL
BEGIN
SET @PocetDK = 0
IF @ZboziSluzba IN (1,2)
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = @ZboziSluzba
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = @ZboziSluzba
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
IF @IDDanKlic IS NULL AND @PocetDK = 0
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = 0
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   K.ZboziSluzba  = 0
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
IF @IDDanKlic IS NULL AND @PocetDK = 0 AND @ZboziSluzba = 0
BEGIN
SET @HledatAktivniCnt = 0
WHILE @HledatAktivniCnt < 2
BEGIN
SELECT @PocetDK = COUNT(*)
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @PocetDK = 1
SELECT @IDDanKlic = K.ID
FROM TabDanoveKlice      AS K
JOIN TabVDanRezimDanKlic AS R ON R.IDDanKlic = K.ID
JOIN TabVDanKlicSazbaDPH AS S ON S.IDDanKlic = K.ID
JOIN TabSazbyDPH         AS D ON D.ID = S.IDSazbaDPH
WHERE R.IDDanRezim   = @IDDanRezim
AND   D.ISOKodZeme   = @KodZeme
AND   K.SmerPlneni   = @SmerPlneni
AND  ((@RezimMOSS <= 1 AND K.RezimOSS = 0) OR (K.RezimOSS = @RezimMOSS))
AND   D.SazbaDPH     = CASE WHEN @SmerPlneni = 3 THEN D.SazbaDPH ELSE @SazbaDPH END
AND   D.DruhSazbyDPH = CASE WHEN @SmerPlneni = 3 THEN 0 ELSE @DruhSazbyDPH END
AND ISNULL(D.PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(D.DatUkonceni, '99991231 23:59:59.997') >= @Datum
AND (@SmerPlneni <> 3 OR K.DruhSazbyPDP = @DruhSazbyDPH)
AND (@HledatAktivniCnt = 0 OR K.Aktivni = 1)
IF @HledatAktivniCnt = 0
SET @PocetDKVcetneNeaktiv = @PocetDK
IF @PocetDK <= 1
SET @HledatAktivniCnt = 2
ELSE
SET @HledatAktivniCnt = @HledatAktivniCnt+1
END
SET @PocetDK = @PocetDKVcetneNeaktiv
END
END
END
GO
