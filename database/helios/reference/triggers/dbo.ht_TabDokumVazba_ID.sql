-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabDokumVazba_ID] ON [dbo].[TabDokumVazba] FOR INSERT, DELETE AS

SET NOCOUNT ON
DECLARE @ModelId1 NVARCHAR(255)
DECLARE @ModelId2 NVARCHAR(255)
DECLARE @ModelId3 NVARCHAR(255)
SET @ModelId1 = N'8d332687-7911-447f-99e1-b49728460bfd'
SET @ModelId2 = N'fd6e382f-5114-4be3-ac5f-e85570d346c6'
SET @ModelId3 = N'715ee6ff-e2a0-4fce-8d3f-77c7f67fc387'
DECLARE @AVAStockMasterDataCard NVARCHAR(MAX) = N'd1a4b801-374a-4064-a347-d8ec7455cabe'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID IN (@ModelId1,@ModelId2,@ModelId3) AND DataDirection IN(0,2))
BEGIN
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT M.RegistrationID, N'U' AS ActionType, M.ModelID, U.AVAReferenceID
FROM TabAVARegisteredModels M
LEFT JOIN INSERTED I ON M.ModelID = @ModelId1 AND m.DataDirection IN(0,2) AND I.IdentVazby = 17
LEFT JOIN DELETED D ON M.ModelID = @ModelId1 AND m.DataDirection IN(0,2) AND D.IdentVazby = 17
LEFT JOIN TabUkoly U ON U.ID = COALESCE(I.IDTab, D.IDTab) -- Připojení ID z INSERTED nebo DELETED
WHERE (D.ID IS NOT NULL OR I.ID IS NOT NULL) AND -- Změny pouze tam, kde existují vložené nebo smazané řádky
U.AVAOutputFlag IN(1,3,4) AND
NOT EXISTS (SELECT 1 FROM TabAVAModelDataChanges
WHERE RegistrationID = M.RegistrationID AND ActionType = N'U'
AND ModelID = M.ModelID AND m.DataDirection IN(0,2) AND AVAReferenceID = U.AVAReferenceID)
UNION
SELECT DISTINCT M.RegistrationID, N'U' AS ActionType, M.ModelID, KJ.AVAReferenceID
FROM TabAVARegisteredModels M
LEFT JOIN INSERTED I ON M.ModelID = @ModelId2 AND m.DataDirection IN(0,2) AND I.IdentVazby = 1
LEFT JOIN DELETED D ON M.ModelID = @ModelId2 AND m.DataDirection IN(0,2) AND D.IdentVazby = 1
LEFT JOIN TabKontaktJednani KJ ON KJ.ID = COALESCE(I.IDTab, D.IDTab) -- Připojení ID z INSERTED nebo DELETED
WHERE (D.ID IS NOT NULL OR I.ID IS NOT NULL) AND -- Změny pouze tam, kde existují vložené nebo smazané řádky
KJ.AVAOutputFlag IN(1,3,4) AND
NOT EXISTS (SELECT 1 FROM TabAVAModelDataChanges
WHERE RegistrationID = M.RegistrationID AND ActionType = N'U'
AND ModelID = M.ModelID AND m.DataDirection IN(0,2) AND AVAReferenceID = KJ.AVAReferenceID)
UNION
SELECT DISTINCT M.RegistrationID, N'U' AS ActionType, M.ModelID, H20.AVAReferenceID
FROM TabAVARegisteredModels M
LEFT JOIN INSERTED I ON M.ModelID = @ModelId3 AND m.DataDirection IN(0,2) AND I.IdentVazby = 133
LEFT JOIN DELETED D ON M.ModelID = @ModelId3 AND m.DataDirection IN(0,2) AND D.IdentVazby = 133
LEFT JOIN TabDosleObjH20 H20 ON H20.ID = COALESCE(I.IDTab, D.IDTab) -- Připojení ID z INSERTED nebo DELETED
WHERE (D.ID IS NOT NULL OR I.ID IS NOT NULL) AND -- Změny pouze tam, kde existují vložené nebo smazané řádky
H20.AVAOutputFlag IN(1,3,4) AND
NOT EXISTS (SELECT 1 FROM TabAVAModelDataChanges
WHERE RegistrationID = M.RegistrationID AND ActionType = N'U'
AND ModelID = M.ModelID AND m.DataDirection IN(0,2) AND AVAReferenceID = H20.AVAReferenceID)
END
IF EXISTS(
  SELECT *
  FROM TabAVARegisteredModels
  WHERE ModelID IN (@AVAStockMasterDataCard) AND DataDirection IN(0,2)
)
BEGIN
  INSERT INTO TabAVAModelDataChanges (
      RegistrationID, ActionType, ModelID, AVAReferenceID)
  SELECT DISTINCT M.RegistrationID, N'U' AS ActionType, M.ModelID, U.AVAReferenceID
  FROM TabAVARegisteredModels M
  LEFT JOIN INSERTED I ON M.ModelID = @AVAStockMasterDataCard AND m.DataDirection IN(0,2) AND I.IdentVazby = 8
  LEFT JOIN DELETED D ON M.ModelID = @AVAStockMasterDataCard AND m.DataDirection IN(0,2) AND D.IdentVazby = 8
  LEFT JOIN TabKmenZbozi U ON U.ID = COALESCE(I.IDTab, D.IDTab) -- Připojení ID z INSERTED nebo DELETED
  WHERE (D.ID IS NOT NULL OR I.ID IS NOT NULL) AND -- Změny pouze tam, kde existují vložené nebo smazané řádky
        U.AVAOutputFlag IN(1,3,4) AND
        NOT EXISTS (SELECT 1 FROM TabAVAModelDataChanges
                    WHERE RegistrationID = M.RegistrationID AND ActionType = N'U'
                    AND ModelID = M.ModelID AND m.DataDirection IN(0,2) AND AVAReferenceID = U.AVAReferenceID)
END
GO
