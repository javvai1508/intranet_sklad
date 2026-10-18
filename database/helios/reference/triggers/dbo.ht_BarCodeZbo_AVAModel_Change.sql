-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_BarCodeZbo_AVAModel_Change] ON [dbo].[TabBarCodeZbo] FOR INSERT, UPDATE, DELETE AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @ModelId NVARCHAR(255)
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)
SET @ModelId = N'd1a4b801-374a-4064-a347-d8ec7455cabe'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelId AND DataDirection IN(0,2))
BEGIN
SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
SET @ActionType = N'U'
IF @Ins = 0 AND @Del > 0
BEGIN
INSERT TabAVAModelDataChanges(
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT m.RegistrationID, @ActionType, m.ModelID, kz.AVAReferenceID
FROM TabAVARegisteredModels m, DELETED d
JOIN TabKmenZbozi kz ON kz.ID = d.IDKmenZbo
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2)
END
ELSE
BEGIN
INSERT TabAVAModelDataChanges(
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT m.RegistrationID, @ActionType, m.ModelID, kz.AVAReferenceID
FROM TabAVARegisteredModels m,
(SELECT ID, AVAReferenceID, Prednastaveno, BarCode, CisloOrg, DoplnkovyKod, IDKmenZbo
FROM INSERTED
EXCEPT
SELECT ID, AVAReferenceID, Prednastaveno, BarCode, CisloOrg, DoplnkovyKod, IDKmenZbo
FROM DELETED) i
JOIN TabKmenZbozi kz ON kz.ID = i.IDKmenZbo
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2)
END
END
GO
