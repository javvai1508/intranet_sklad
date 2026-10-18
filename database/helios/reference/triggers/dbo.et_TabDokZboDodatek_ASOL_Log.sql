-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[et_TabDokZboDodatek_ASOL_Log] ON [dbo].[TabDokZboDodatek]
FOR INSERT, UPDATE
AS
IF @@ROWCOUNT = 0 RETURN
DECLARE @Akce CHAR
DECLARE @Ins INT
DECLARE @Del INT
DECLARE @IDZurnal INT
DECLARE @Filtr BIT = 0
DECLARE @Tab_ASOL_NoLog table (ID int)
SET NOCOUNT ON
IF OBJECT_ID(N'tempdb..#TabDokZboDodatek_ASOL_NoLog') IS NOT NULL
BEGIN
IF (SELECT COUNT(*) FROM #TabDokZboDodatek_ASOL_NoLog) = 0
RETURN
ELSE
BEGIN
SET @Filtr = 1
INSERT INTO @Tab_ASOL_NoLog(ID) SELECT ID FROM #TabDokZboDodatek_ASOL_NoLog
END
END
SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
IF @Ins > 0 AND @Del = 0 SET @Akce = N'I'
IF @Ins = 0 AND @Del > 0 SET @Akce = N'D'
IF @Ins > 0 AND @Del > 0 SET @Akce = N'U'

IF @Ins = 1 AND @Del = 0 AND (SELECT JeNovaVetaEditor FROM INSERTED) = 1
RETURN
IF @Ins = 0 AND @Del = 1 AND (SELECT JeNovaVetaEditor FROM DELETED) = 1
RETURN
IF @Ins = 1 AND (SELECT JeNovaVetaEditor FROM INSERTED) = 0 AND (SELECT JeNovaVetaEditor FROM DELETED) = 1
SET @Akce = 'I'

IF @Akce IN (N'I', N'D') OR UPDATE(DatumSchvaleni)

BEGIN
EXEC hp_VratZurnalID @IDZurnal OUT


IF @Akce IN (N'X',N'U')
INSERT INTO TabZmenovyLOG(Tabulka, IDvTab, Sloupec, LogAkce, Old, New, IDZurnal) 
SELECT N'TabDokZboDodatek', ISNULL(D.ID, I.ID), N'DatumSchvaleni',  @Akce , CONVERT(NVARCHAR(255), D.DatumSchvaleni, 20) , CONVERT(NVARCHAR(255), I.DatumSchvaleni, 20) , @IDZurnal
FROM DELETED AS D FULL JOIN INSERTED AS I ON D.ID = I.ID
WHERE ((D.DatumSchvaleni <> I.DatumSchvaleni) OR (D.DatumSchvaleni IS NULL AND I.DatumSchvaleni IS NOT NULL ) OR (D.DatumSchvaleni IS NOT NULL AND I.DatumSchvaleni IS NULL ) OR @Akce = N'I')
AND (@Filtr = 0 OR I.ID IN (SELECT ID FROM @Tab_ASOL_NoLog) OR D.ID IN (SELECT ID FROM @Tab_ASOL_NoLog))





END
GO
