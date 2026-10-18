-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_SOzNa] ON [dbo].[TabSozNa]
FOR INSERT, UPDATE
AS
SET NOCOUNT ON
DECLARE @PocetDeleted  INT
DECLARE @PocetInserted INT
DECLARE @ErrStr     NVARCHAR(2000)
SET @PocetDeleted  = (SELECT COUNT(*) FROM Deleted)
SET @PocetInserted = (SELECT COUNT(*) FROM Inserted)
IF @PocetInserted > 0 AND
(UPDATE(CenovaUroven) OR UPDATE(CenovaUrovenNakup)) AND
EXISTS(SELECT * FROM Inserted
WHERE CenovaUroven IS NOT NULL OR CenovaUrovenNakup IS NOT NULL)
BEGIN
IF EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS C ON C.CenovaUroven = I.CenovaUroven
WHERE C.DruhCU = 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71854, '')
RAISERROR(@ErrStr, 16, 1)
END
IF EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS C ON C.CenovaUroven = I.CenovaUrovenNakup
WHERE C.DruhCU = 1)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71855, '')
RAISERROR(@ErrStr, 16, 1)
END
END
GO
