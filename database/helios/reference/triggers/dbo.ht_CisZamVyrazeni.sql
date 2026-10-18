-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZamVyrazeni] ON [dbo].[TabCisZam] FOR INSERT,UPDATE,DELETE AS
SET NOCOUNT ON
DECLARE @IDZam INT, @IDMzdObd INT, @RC NVARCHAR(11), @IDObd INT, @IDOut INT, @Vyrad BIT
DECLARE @PocetInserted INT,@PocetDeleted INT
SET @PocetInserted=(SELECT COUNT(*)FROM inserted)
SET @PocetDeleted =(SELECT COUNT(*)FROM deleted)
IF (@PocetInserted = 0 OR (UPDATE(RodneCislo) AND @PocetInserted > 0)) AND @PocetDeleted > 0
BEGIN
UPDATE z
SET z.VyraditZPrehledu = 0
FROM TabCisZam z
JOIN deleted d ON d.RodneCislo = z.RodneCislo
WHERE d.VyraditZPrehledu = 0 AND d.RodneCislo IS NOT NULL AND d.RodneCislo <> N''
DECLARE cDel CURSOR FAST_FORWARD FOR
SELECT d.ID, d.RodneCislo, d.VyraditZPrehledu, d.IdObdobi
FROM deleted d
WHERE d.RodneCislo IS NOT NULL AND d.RodneCislo <> N''
OPEN cDel
WHILE 1=1
BEGIN
FETCH NEXT FROM cDel INTO @IDZam, @RC, @Vyrad, @IdObd
IF @@FETCH_STATUS<>0 BREAK
IF @Vyrad = 0
BEGIN
EXEC dbo.hp_MzIdZamestnanceProSeskupeniZaRC @RC, @IDObd, @IDOut OUT
UPDATE TabCisZam SET VyraditZPrehledu = 1 WHERE RodneCislo=@RC AND ID <> @IDOut AND VyraditZPrehledu = 0
UPDATE TabCisZam SET VyraditZPrehledu = 0 WHERE ID = @IDOut
END
END
CLOSE cDel
DEALLOCATE cDel
END
IF @PocetInserted > 0 AND (@PocetDeleted = 0 OR (@PocetDeleted > 0 AND UPDATE(RodneCislo)))
BEGIN
DECLARE cIns CURSOR FAST_FORWARD FOR
SELECT i.ID, i.RodneCislo, i.VyraditZPrehledu
FROM inserted i
OPEN cIns
WHILE 1=1
BEGIN
FETCH NEXT FROM cINS INTO @IDZam, @RC, @Vyrad
IF @@FETCH_STATUS<>0 BREAK
IF EXISTS (SELECT 0 FROM TabCisZam WHERE @RC IS NOT NULL AND @RC <> N'' AND RodneCislo=@RC AND VyraditZPrehledu=0 AND ID<>@IDZam)
UPDATE TabCisZam SET VyraditZPrehledu = 1 WHERE ID = @IDZam
ELSE
UPDATE TabCisZam SET VyraditZPrehledu = 0 WHERE ID = @IDZam
END
CLOSE cIns
DEALLOCATE cINS
END
GO
