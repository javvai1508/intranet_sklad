-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_VyrCK_AVAModel_Change] ON [dbo].[TabVyrCK] FOR INSERT, UPDATE, DELETE AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @SerialNumber NVARCHAR(255)
SET @SerialNumber = N'f25ac619-893a-423d-a1c7-623a7e678c96'
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)
SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
IF @Ins > 0 AND @Del = 0 SET @ActionType = N'I'
IF @Ins = 0 AND @Del > 0 SET @ActionType = N'D'
IF @Ins > 0 AND @Del > 0 SET @ActionType = N'U'

IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @SerialNumber AND DataDirection IN(0,2))
BEGIN
   -- DELETE
  IF @Ins = 0 AND @Del > 0
    BEGIN
      INSERT TabAVAModelDataChanges(
        RegistrationID, ActionType, ModelID, AVAReferenceID)
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @SerialNumber AND m.DataDirection IN(0,2)
    END
  ELSE
    -- INSERT + UPDATE
    BEGIN
      INSERT TabAVAModelDataChanges(
        RegistrationID, ActionType, ModelID, AVAReferenceID)
      SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
      FROM TabAVARegisteredModels m,
        (SELECT ID, AVAReferenceID, Poznamka, DatExpirace, Nazev2,
             Nazev1, DatVyroby, ZarukaVstup, TypZarukaVstup, DatVstup,
             ZarukaVystup, TypZarukaVystup, DatVystup, IDKmenZbozi
         FROM INSERTED
         EXCEPT
         SELECT ID, AVAReferenceID, Poznamka, DatExpirace, Nazev2,
           Nazev1, DatVyroby, ZarukaVstup, TypZarukaVstup, DatVstup,
           ZarukaVystup, TypZarukaVystup, DatVystup, IDKmenZbozi
         FROM DELETED) i
      JOIN TabKmenZbozi kz ON i.IDKmenZbozi = kz.ID
      WHERE m.ModelID = @SerialNumber AND m.DataDirection IN(0,2)
      AND kz.AVAOutputFlag IN(1,3,4)
    END
END
GO
