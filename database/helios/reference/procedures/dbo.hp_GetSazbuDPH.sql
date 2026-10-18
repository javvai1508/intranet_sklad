-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_GetSazbuDPH]
@SazbaDPH      NUMERIC(5,2) OUT,
@DruhSazbyDPH  TINYINT      OUT,
@DPHPrenesPov  BIT          OUT,
@DruhPohybu    TINYINT,
@IDKmenZbozi   INT         = NULL,
@SkupZbo       NVARCHAR(3) = NULL, -- lze zadat jen ID kmene, skupina se dohleda
@ISOKodZeme    NVARCHAR(3) = NULL, -- nezadana se dohleda dle DICDPH
@Datum         DATETIME    = NULL, -- nezadane se doplni na dnesni
@DICDPH        NVARCHAR(15)= NULL, -- nezadana zeme ani DIC znamena vlastni zemi
@DruhSazbyPref TINYINT     = NULL, -- preferovany druh sazby dle zdrojoveho dokladu
@DruhSazbyPov  BIT         = 0,    -- povinna shoda s preferovanym druhem sazby
@CisloOrg      INT         = NULL, -- organizace (dodavatel / odberatel)
@IDOZPozn      INT         = NULL, -- poznamka k dokladum OZ
@DruhCU        TINYINT     = 1     -- druh cenotvorby (urcuje typ nabidky, ma momentalne smysl pouze pro nabidku)
AS
SET NOCOUNT ON
DECLARE @Vstup BIT -- vstupni ci vystupni doklad
SET @DruhSazbyDPH = NULL
SET @SazbaDPH     = NULL
SET @DPHPrenesPov = 0
SET @Vstup = NULL
IF (@DruhPohybu IN (0,1,5,6,7,16,18,19,24,25)) OR (@DruhPohybu = 11 AND @DruhCU = 0)          SET @Vstup = 1
IF (@DruhPohybu IN (2,3,4,8,9,10,13,14,15,17,26,27,30,53)) OR (@DruhPohybu = 11 AND @DruhCU = 1) SET @Vstup = 0
IF @Vstup IS NULL RETURN
IF @Datum IS NULL
SET @Datum = GETDATE()
IF @ISOKodZeme IS NULL
EXEC hp_OZGetZemeDleDICDPH @DICDPH, @Datum, @ISOKodZeme OUT, 0
IF @IDKmenZbozi IS NOT NULL
SELECT TOP 1 @DruhSazbyDPH = DruhSazbyDPH,
@DPHPrenesPov = DPHPrenesPov
FROM TabSazbyDPHZbo
WHERE IDKmenZbozi = @IDKmenZbozi
AND   ISOKodZeme  = @ISOKodZeme
AND ISNULL(PlatnostOd, '19000101 00:00:00.000') <= @Datum
AND ISNULL(PlatnostDo, '99991231 23:59:59.997') >= @Datum
AND ((@Vstup = 1 AND VstupVystup IN(0,2)) OR
(@Vstup = 0 AND VstupVystup IN(1,2)))
ORDER BY
CASE WHEN ISNULL(@DruhSazbyPref, DruhSazbyDPH) = DruhSazbyDPH THEN 0 ELSE 1 END,
Prednastaveno DESC
IF @DruhSazbyDPH IS NULL
BEGIN
IF @SkupZbo IS NULL AND @IDKmenZbozi IS NOT NULL
SELECT @SkupZbo = SkupZbo
FROM TabKmenZbozi WHERE ID = @IDKmenZbozi
IF @SkupZbo IS NOT NULL
SELECT TOP 1 @DruhSazbyDPH = DruhSazbyDPH,
@DPHPrenesPov = DPHPrenesPov
FROM TabSazbyDPHSku
WHERE SkupZbo    = @SkupZbo
AND   ISOKodZeme = @ISOKodZeme
AND ISNULL(PlatnostOd, '19000101 00:00:00.000') <= @Datum
AND ISNULL(PlatnostDo, '99991231 23:59:59.997') >= @Datum
AND ((@Vstup = 1 AND VstupVystup IN(0,2)) OR
(@Vstup = 0 AND VstupVystup IN(1,2)))
ORDER BY
CASE WHEN ISNULL(@DruhSazbyPref, DruhSazbyDPH) = DruhSazbyDPH THEN 0 ELSE 1 END,
Prednastaveno DESC
END
IF @DruhSazbyDPH IS NULL AND @IDOZPozn IS NOT NULL
BEGIN
SELECT TOP 1 @DruhSazbyDPH = DruhSazbyDPH,
@DPHPrenesPov = DPHPrenesPov
FROM TabSazbyDPHPoznKDokl
WHERE IDOZPozn = @IDOZPozn
AND   ISOKodZeme  = @ISOKodZeme
AND ISNULL(PlatnostOd, '19000101 00:00:00.000') <= @Datum
AND ISNULL(PlatnostDo, '99991231 23:59:59.997') >= @Datum
AND ((@Vstup = 1 AND VstupVystup IN(0,2)) OR
(@Vstup = 0 AND VstupVystup IN(1,2)))
ORDER BY
CASE WHEN ISNULL(@DruhSazbyPref, DruhSazbyDPH) = DruhSazbyDPH THEN 0 ELSE 1 END,
Prednastaveno DESC
END
IF @DruhSazbyDPH IS NOT NULL
SELECT @SazbaDPH = SazbaDPH
FROM TabSazbyDPH
WHERE DruhSazbyDPH = @DruhSazbyDPH
AND   ISOKodZeme = @ISOKodZeme
AND ISNULL(PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(PlatnostDo,  '99991231 23:59:59.997') >= @Datum
AND ISNULL(DatUkonceni, '99991231 23:59:59.997') >= @Datum
IF EXISTS(SELECT *
FROM TabHGlob WHERE OZGetSazbuDPHOldKme = 1)
BEGIN
IF @SazbaDPH IS NULL AND
@IDKmenZbozi IS NOT NULL
SELECT @SazbaDPH =
CASE WHEN @Vstup = 1
THEN SazbaDPHVstup
ELSE SazbaDPHVystup END,
@DPHPrenesPov = DPHPrenesPov
FROM TabKmenZbozi
WHERE ID = @IDKmenZbozi
END
IF @CisloOrg IS NOT NULL AND NOT EXISTS(
SELECT *
FROM TabCisOrg AS O
JOIN TabDICOrg AS D ON D.CisloOrg = O.CisloOrg AND D.DIC = O.DIC
WHERE O.CisloOrg = @CisloOrg
AND D.AktualniDICNeplatce = 0)
SET @DPHPrenesPov = 0
GO
