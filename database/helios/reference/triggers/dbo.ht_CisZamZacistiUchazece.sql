-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZamZacistiUchazece] ON [dbo].[TabCisZam] FOR DELETE AS
SET NOCOUNT ON
UPDATE TabPersUchazec
SET Stav=1, ZamestnanecId=NULL, PracPoziceID=NULL, PracPoziceDetailID=NULL
WHERE ZamestnanecId IN (SELECT ID FROM deleted)
GO
