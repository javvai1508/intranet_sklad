-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZamCizinecDoklady] ON [dbo].[TabCisZam] FOR INSERT, UPDATE AS
SET NOCOUNT ON
IF TRIGGER_NESTLEVEL() > 1
RETURN
UPDATE t
SET
Ciz_Doklad_Typ = 2,
Ciz_Doklad_Cislo = t.CisloPasu,
Ciz_Doklad_Vydal = t.PasVydal,
Ciz_Doklad_Vydal_Zeme = t.PasVydal_Zeme
FROM TabCisZam t
JOIN inserted i ON i.ID = t.ID
WHERE i.StatniPrislus IS NOT NULL AND
ISNULL(i.CisloPasu, N'') <> N'' AND
i.StatniPrislus <> CASE
WHEN (SELECT Legislativa FROM TabHGlob) = 1
THEN N'SK'
ELSE N'CZ'
END AND
ISNULL(i.Ciz_Doklad_Cislo, N'') = N'' AND
ISNULL(i.Ciz_Doklad_Vydal, N'') = N'' AND
ISNULL(i.Ciz_Doklad_Vydal_Zeme, N'') = N''
GO
