-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_UmistPrijemInUpDel] ON [dbo].[TabUmisteniPrijem]
FOR INSERT, UPDATE, DELETE
AS
SET NOCOUNT ON
UPDATE U
SET MnozstviUmisteni = MnozstviUmisteni - ISNULL(D.Mnozstvi, 0)
FROM TabVStavUmisteni AS U
JOIN Deleted AS D ON D.IDUmisteni = U.ID
UPDATE U
SET MnozstviUmisteni = MnozstviUmisteni + ISNULL(I.Mnozstvi, 0)
FROM TabVStavUmisteni AS U
JOIN Inserted AS I ON I.IDUmisteni = U.ID
GO
