-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_Hlidej] ON [dbo].[TabJC] FOR UPDATE, INSERT AS
SET NOCOUNT ON
IF EXISTS(SELECT *
FROM Inserted AS JC
WHERE JC.EcCelkem     = 0
AND   JC.Mnozstvi     = 0
AND   JC.MnKDispozici = 0
AND EXISTS(SELECT * FROM TabJC AS JC2
WHERE JC2.IDStavSkladu = JC.IDStavSkladu
AND JC2.ID <> JC.ID))
DELETE JC
FROM TabJC AS JC
JOIN Inserted ON Inserted.ID = JC.ID
WHERE JC.EcCelkem     = 0
AND   JC.Mnozstvi     = 0
AND   JC.MnKDispozici = 0
AND EXISTS(SELECT * FROM TabJC AS JC2
WHERE JC2.IDStavSkladu = JC.IDStavSkladu
AND JC2.ID <> JC.ID)
GO
