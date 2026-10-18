-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_NovaMzdovaVeta2] ON [dbo].[TabCisZam] FOR INSERT AS
SET NOCOUNT ON
DECLARE @ErrStr NVARCHAR(2047)
IF EXISTS(SELECT * FROM INSERTED i WHERE Status=1)
BEGIN
DECLARE @IdObdobi INT, @ZamestnanecId INT
SELECT TOP 1 @IdObdobi=VybraneObdobi FROM #TabMzVybObdobi
IF @IdObdobi IS NULL OR @IdObdobi<=0
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(50596, N'Nepodarilo se identifikovat vybrane obdobi.')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
SELECT @ZamestnanecId=i.Id FROM INSERTED i WHERE Status=1
EXEC dbo.hp_PridejMzdovouVetu @ZamestnanecId, @IdObdobi
END
GO
