-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_TestSazbuDPH]
@SazbaDPH     NUMERIC(5,2),
@SazbaPDP     NUMERIC(5,2),
@Platna       BIT OUT,
@ISOKodZeme   NVARCHAR(3) = NULL,
@Datum        DATETIME    = NULL,
@DICDPH       NVARCHAR(15)= NULL
AS
SET NOCOUNT ON
SET @Platna = 0
IF @Datum IS NULL
SET @Datum = GETDATE()
IF @ISOKodZeme IS NULL
EXEC hp_OZGetZemeDleDICDPH @DICDPH, @Datum, @ISOKodZeme OUT, 0
IF ISNULL(@SazbaDPH, 0) = 0 AND
ISNULL(@SazbaPDP, 0) > 0
SET @SazbaDPH = @SazbaPDP
IF EXISTS(SELECT *
FROM TabSazbyDPH
WHERE SazbaDPH = @SazbaDPH
AND ISOKodZeme = @ISOKodZeme
AND ISNULL(PlatnostOd,  '19000101 00:00:00.000') <= @Datum
AND ISNULL(DatUkonceni, '99991231 23:59:59.997') >= @Datum)
SET @Platna = 1
GO
