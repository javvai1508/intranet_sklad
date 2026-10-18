-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabVStavUmisteni_IUD] ON [dbo].[TabVStavUmisteni] FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
DECLARE @Id INT, @IdStav INT, @JineId INT, @Prednastaveno Bit
IF EXISTS (SELECT * FROM INSERTED)
BEGIN
DECLARE d CURSOR LOCAL FAST_FORWARD FOR
SELECT ID, IDStav, Prednastaveno FROM INSERTED
OPEN d
FETCH NEXT FROM d INTO @ID, @IdStav, @Prednastaveno
WHILE @@FETCH_STATUS = 0
BEGIN
/* pokud vkladam prednastavene umisteni Skladu, odprednastavim predchozi prednastavene */
IF @Prednastaveno = 1
UPDATE TabVStavUmisteni SET Prednastaveno = 0
WHERE ISNULL (IDStav, -999) = ISNULL (@IdStav, -999)
AND (Prednastaveno = 1) AND (Id <> @Id)
FETCH NEXT FROM d INTO @Id, @IdStav, @Prednastaveno
END
CLOSE d
DEALLOCATE d
END
GO
