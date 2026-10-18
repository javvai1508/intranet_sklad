-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabDruhDZ_Trigger] ON [dbo].[TabDruhDokZbo] FOR INSERT, UPDATE, DELETE
AS
SET NOCOUNT ON
DECLARE @ErrStr     NVARCHAR(2000)
DECLARE @TypOperace INT -- Update=0, Insert=1, Delete=-1
DECLARE @IdVzor INT, @IdDruhDZ INT, @IdObdobi INT, @DatumOd DATETIME, @Uzavreno BIT
DECLARE @DDPPRadaSmazana NVARCHAR(3), @DDPPRadaVlozena NVARCHAR(3)
DECLARE @DDPPPohybSmazan TINYINT, @DDPPPohybVlozen TINYINT
IF EXISTS (SELECT * FROM INSERTED)
IF EXISTS (SELECT * FROM DELETED)
SET @TypOperace =  0 ELSE
SET @TypOperace =  1 ELSE
SET @TypOperace = -1
IF (@TypOperace = 0) OR (@TypOperace = 1)
BEGIN
IF EXISTS(
SELECT * FROM TabHGlob AS H
JOIN INSERTED AS D ON D.RadaDokladu = H.DruhDokladuPenFak
WHERE D.DruhPohybuZbo IN (13,14) AND H.DruhDokladuPenFak <> '')
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(63355, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM Inserted AS I
WHERE I.DruhCU = 0
AND I.DruhPohybuZbo IN(2,3,4,8,9,10,13,14,15,26,27))
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71903, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM Inserted AS I
WHERE I.DruhCU = 1
AND I.DruhPohybuZbo IN(0,1,5,6,7,18,19,24,25))
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71902, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF (@TypOperace = -1)
BEGIN
IF EXISTS(
SELECT * FROM TabHGlob AS H
JOIN DELETED AS D ON D.RadaDokladu = H.InventuraRadaPrijem AND D.DruhPohybuZbo  = H.InventuraPohybPrijem)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(77179, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM TabHGlob AS H
JOIN DELETED AS D ON D.RadaDokladu = H.InventuraRadaVydej AND D.DruhPohybuZbo  = H.InventuraPohybVydej)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(77180, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF (@TypOperace = 1 AND NOT EXISTS(SELECT 1 FROM Inserted WHERE Autor=N'Rozkopirovani_ASOL')) OR
(UPDATE(RadaDokladu) AND UPDATE(Autor) AND @TypOperace = 0)
BEGIN
BEGIN
DECLARE PresInserted CURSOR LOCAL FAST_FORWARD FOR
SELECT Id FROM Inserted
OPEN PresInserted
WHILE 1=1
BEGIN
FETCH NEXT FROM PresInserted INTO @IdDruhDZ
IF @@fetch_status<>0 BREAK
DECLARE PresObdobi CURSOR LOCAL FAST_FORWARD FOR
SELECT Id, Uzavreno, DatumOd FROM TabObdobi
OPEN PresObdobi
WHILE 1=1
BEGIN
FETCH NEXT FROM PresObdobi INTO @IdObdobi, @Uzavreno, @DatumOd
IF @@fetch_status<>0 BREAK
IF EXISTS(SELECT * FROM TabDruhDokZboDef WHERE IdObdobi = @IdObdobi AND IdDruhDZ = @IdDruhDZ) CONTINUE
SET @IdVzor=NULL
IF UPDATE(RadaDokladu) AND UPDATE(Autor) AND @TypOperace = 0
SELECT TOP 1 @IdVzor=TabDruhDokZboDef.Id FROM TabDruhDokZboDef JOIN TabObdobi ON TabDruhDokZboDef.IdObdobi=TabObdobi.Id
WHERE TabDruhDokZboDef.IdDruhDZ=@IdDruhDZ AND TabObdobi.DatumOd<@DatumOd
ORDER BY TabObdobi.DatumOd DESC
IF @IdVzor IS NOT NULL
INSERT TabDruhDokZboDef (IdObdobi, IdDruhDZ, Blokovano, PosledniPC)
SELECT @IdObdobi, @IdDruhDZ, @Uzavreno, PosledniPC
FROM TabDruhDokZboDef
WHERE TabDruhDokZboDef.Id=@IdVzor
ELSE
INSERT TabDruhDokZboDef (IdObdobi, IdDruhDZ, Blokovano)
SELECT @IdObdobi, @IdDruhDZ, @Uzavreno
END
CLOSE PresObdobi
DEALLOCATE PresObdobi
END
CLOSE PresInserted
DEALLOCATE PresInserted
END
END
IF EXISTS(SELECT*FROM TabHGlob WHERE Zal30=1)
IF EXISTS(SELECT*FROM INSERTED AS I
WHERE I.DruhPohybuZbo IN(13,14,18,19)) OR
EXISTS(SELECT*FROM DELETED AS D
WHERE D.DruhPohybuZbo IN(13,14,18,19))
BEGIN
IF ((@TypOperace = 0) AND (UPDATE(DDPPRada) OR UPDATE(DDPPPohyb))) OR (@TypOperace = -1)
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT d.ID, d.DDPPRada, d.DDPPPohyb, i.DDPPRada, i.DDPPPohyb
FROM DELETED d
LEFT JOIN INSERTED i ON i.id = d.id
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IdDruhDZ, @DDPPRadaSmazana, @DDPPPohybSmazan, @DDPPRadaVlozena, @DDPPPohybVlozen
IF @@FETCH_STATUS <> 0 BREAK
IF (@DDPPRadaSmazana IS NOT NULL) AND
(@DDPPPohybSmazan IS NOT NULL) AND
(((@TypOperace = 0) AND ((ISNULL(@DDPPRadaVlozena, '') <> ISNULL(@DDPPRadaSmazana, '')) OR (ISNULL(@DDPPPohybVlozen, 0) <> ISNULL(@DDPPPohybSmazan, 0)))) OR
(@TypOperace = -1))
BEGIN
UPDATE TabDruhDokZbo
SET JeToDDPP = 0
WHERE JeToDDPP = 1
AND RadaDokladu = @DDPPRadaSmazana
AND DruhPohybuZbo = @DDPPPohybSmazan
AND NOT EXISTS(SELECT*FROM TabDruhDokZbo B
WHERE B.DDPPRada  = @DDPPRadaSmazana
AND B.DDPPPohyb = @DDPPPohybSmazan)
END
END
CLOSE Cur
DEALLOCATE Cur
END
IF (@TypOperace = 0) OR (@TypOperace = 1)
BEGIN
UPDATE TabDruhDokZbo
SET JeToDDPP = 1
WHERE ID IN (SELECT ID
FROM TabDruhDokZbo A
WHERE A.JeToDDPP = 0
AND EXISTS(SELECT*FROM TabDruhDokZbo B
WHERE A.RadaDokladu = B.DDPPRada
AND A.DruhPohybuZbo = B.DDPPPohyb))
END
END
IF (@TypOperace = 0) OR (@TypOperace = 1)
BEGIN
IF UPDATE(UKodDorovnani)
UPDATE t SET t.AutoDorovnani=0 FROM TabDruhDokZbo t JOIN INSERTED AS i
ON i.ID=t.ID WHERE i.UKodDorovnani IS NULL
END
GO
