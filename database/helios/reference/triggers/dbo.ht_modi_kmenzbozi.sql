-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_modi_kmenzbozi] ON [dbo].[TabKmenZbozi]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON
DECLARE @PocetDeleted  INT
DECLARE @PocetInserted INT
DECLARE @IDKmenZbozi   INT
DECLARE @Chyba         INT
DECLARE @ErrStr        NVARCHAR(2047)
DECLARE @ChybHlaska    NVARCHAR(2047)
SET @PocetDeleted  = (SELECT COUNT(*) FROM DELETED)
SET @PocetInserted = (SELECT COUNT(*) FROM INSERTED)
IF (@PocetInserted = 0 AND @PocetDeleted > 0) OR UPDATE(PLUKod)
BEGIN
IF EXISTS(SELECT * FROM DELETED WHERE PLUKod <> '')
DELETE k FROM TabPLUKody k
JOIN DELETED d ON d.PLUKod = k.PLUKod
END
IF (@PocetInserted > 0 AND @PocetDeleted = 0) OR UPDATE(PLUKod)
BEGIN
IF EXISTS(SELECT * FROM INSERTED WHERE PLUKod <> '')
INSERT TabPLUKody(PLUKod, IdentTab, IDVazba)
SELECT PLUKod, 0, ID FROM INSERTED WHERE PLUKod <> ''
END
IF @PocetInserted = @PocetDeleted
AND @PocetInserted > 0
AND UPDATE(KontrolaVyrC)
BEGIN
IF EXISTS(
SELECT *
FROM INSERTED AS I
JOIN DELETED  AS D ON D.ID = I.ID
WHERE (I.KontrolaVyrC = N'B' AND D.KontrolaVyrC <> N'B')
OR    (D.KontrolaVyrC = N'B' AND I.KontrolaVyrC <> N'B'))
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID
FROM INSERTED AS I
JOIN DELETED  AS D ON D.ID = I.ID
WHERE (I.KontrolaVyrC = N'B' AND D.KontrolaVyrC <> N'B')
OR    (D.KontrolaVyrC = N'B' AND I.KontrolaVyrC <> N'B')
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDKmenZbozi
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_OZAktualHlidanoVCMain
@IDKmenZbozi, NULL, 0, @Chyba OUT, @ChybHlaska OUT
IF @Chyba = 1
BEGIN
CLOSE Cur
DEALLOCATE Cur
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71533, @ChybHlaska)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
CLOSE Cur
DEALLOCATE Cur
END
IF EXISTS(
SELECT * FROM TabHGlob
WHERE MetodaSkladu  >= 3
AND   MetodaEvidCeny = 1)
IF EXISTS(
SELECT *
FROM INSERTED      AS I
JOIN DELETED       AS D ON D.ID = I.ID
JOIN TabStavSkladu AS S ON S.IDKmenZbozi = I.ID
WHERE S.Metoda NOT IN(0,1,3)
AND ((I.KontrolaVyrC = N'N' AND D.KontrolaVyrC <> N'N' AND S.KontrolaVC = N'C')
OR   (D.KontrolaVyrC = N'N' AND I.KontrolaVyrC <> N'N' AND S.KontrolaVC = N'C')))
UPDATE S SET Metoda = 2
FROM TabStavSkladu AS S
JOIN INSERTED      AS I ON I.ID = S.IDKmenZbozi
JOIN DELETED       AS D ON D.ID = I.ID
WHERE S.Metoda NOT IN(0,1,3)
AND ((I.KontrolaVyrC = N'N' AND D.KontrolaVyrC <> N'N' AND S.KontrolaVC = N'C')
OR   (D.KontrolaVyrC = N'N' AND I.KontrolaVyrC <> N'N' AND S.KontrolaVC = N'C'))
END
IF @PocetDeleted  > 0 AND
@PocetInserted > 0 AND
UPDATE(DruhSkladu) AND
EXISTS(SELECT * FROM TabHGlob WHERE MetodaSkladu >= 3)
IF EXISTS(SELECT * FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
AND I.DruhSkladu <> D.DruhSkladu)
BEGIN
UPDATE S SET Metoda = 2
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
JOIN TabStrom      AS T ON T.Cislo = S.IDSklad
JOIN Inserted      AS I ON I.ID = K.ID
JOIN Deleted       AS D ON D.ID = K.ID
JOIN TabHGlob      AS H ON 1=1
WHERE S.Metoda >= 4
AND K.DruhSkladu <> 4
AND I.DruhSkladu <> D.DruhSkladu
AND NOT(I.DruhSkladu = 1 AND CASE WHEN T.DruhSkladu = 1
THEN H.DruhSkladu ELSE
T.DruhSkladu END = D.DruhSkladu)
AND NOT(D.DruhSkladu = 1 AND CASE WHEN T.DruhSkladu = 1
THEN H.DruhSkladu ELSE
T.DruhSkladu END = I.DruhSkladu)
END
IF @PocetInserted > 0 AND @PocetDeleted = 0
BEGIN
UPDATE TabKmenZbozi SET IdKusovnik = ID WHERE IdKusovnik IS NULL
END
IF EXISTS(SELECT * FROM INSERTED AS I
WHERE EXISTS(SELECT * FROM TabKmenZbozi AS KZ
WHERE KZ.ID <> I.ID AND KZ.IDKusovnik = I.IDKusovnik
AND (KZ.IDVarianta = I.IDVarianta OR (KZ.IDVarianta IS NULL AND I.IDVarianta IS NULL))))
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(70525, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
GO
