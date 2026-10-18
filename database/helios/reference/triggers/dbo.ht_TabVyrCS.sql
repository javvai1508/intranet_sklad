-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabVyrCS]
ON [dbo].[TabVyrCS] FOR UPDATE, INSERT
AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @TypOperace INT   -- 0=UPDATE / 1=INSERT / -1=DELETE
DECLARE @ErrStr     NVARCHAR(2047)
IF EXISTS (SELECT * FROM INSERTED)
IF EXISTS (SELECT * FROM DELETED)
SET @TypOperace = 0 ELSE
SET @TypOperace = 1 ELSE
SET @TypOperace = -1
IF @TypOperace = 1
BEGIN
IF EXISTS(SELECT *
FROM INSERTED      AS I
JOIN TabStavSkladu AS S ON S.ID = I.IDStavSkladu
JOIN TabVyrCK      AS VCK ON VCK.ID = I.IDVyrCK
WHERE I.Nazev1 <> VCK.Nazev1)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71974, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(SELECT * FROM TabHGlob WHERE OZTrgInsertVyrCK = 1)
IF EXISTS(SELECT * FROM INSERTED WHERE IDVyrCK IS NULL)
BEGIN
IF EXISTS(
SELECT * FROM INSERTED   AS I
JOIN TabStavSkladu       AS S ON S.ID = I.IDStavSkladu
LEFT OUTER JOIN TabVyrCK AS VCK
ON  VCK.IDKmenZbozi = S.IDKmenZbozi
AND VCK.Nazev1 = I.Nazev1
WHERE I.IDVyrCK IS NULL AND VCK.ID IS NULL)
BEGIN
INSERT TabVyrCK(
IDKmenZbozi, IDZakazModif, Nazev1, Nazev2,
ZarukaVstup,  TypZarukaVstup,  DatVstup,
ZarukaVystup, TypZarukaVystup, DatVystup,
DatExpirace, Poznamka)
SELECT S.IDKmenZbozi,
V.IDZakazModif, V.Nazev1, V.Nazev2,
V.ZarukaVstup,  V.TypZarukaVstup,  V.DatVstup,
V.ZarukaVystup, V.TypZarukaVystup, V.DatVystup,
V.DatExpirace, V.Poznamka
FROM TabVyrCS AS V
JOIN( SELECT MIN(VCS.ID) AS VCSID
FROM TabVyrCS            AS VCS
JOIN INSERTED            AS INS ON INS.ID = VCS.ID
JOIN TabStavSkladu       AS S ON S.ID = VCS.IDStavSkladu
LEFT OUTER JOIN TabVyrCK AS VCK
ON VCK.IDKmenZbozi = S.IDKmenZbozi
AND VCK.Nazev1 = VCS.Nazev1
WHERE VCK.ID IS NULL
GROUP BY S.IDKmenZbozi, VCS.Nazev1) AS I
ON I.VCSID = V.ID
JOIN TabStavSkladu AS S ON S.ID = V.IDStavSkladu
ORDER BY S.IDKmenzbozi
END
IF EXISTS(
SELECT * FROM INSERTED   AS I
JOIN TabStavSkladu       AS S ON S.ID = I.IDStavSkladu
JOIN TabKmenZbozi        AS K ON K.ID = S.IDKmenZbozi
JOIN TabVyrCK            AS VCK
ON  VCK.IDKmenZbozi = K.ID
AND VCK.Nazev1 = I.Nazev1
LEFT OUTER JOIN TabVyrCK AS X ON X.ID = I.IDVyrCK
WHERE X.ID IS NULL)
BEGIN
UPDATE VCS SET IDVyrCK = VCK.ID
FROM TabVyrCS            AS VCS
JOIN INSERTED            AS I ON I.ID = VCS.ID
JOIN TabStavSkladu       AS S ON S.ID = I.IDStavSkladu
JOIN TabKmenZbozi        AS K ON K.ID = S.IDKmenZbozi
JOIN TabVyrCK            AS VCK
ON  VCK.IDKmenZbozi = K.ID
AND VCK.Nazev1 = I.Nazev1
LEFT OUTER JOIN TabVyrCK AS X ON X.ID = I.IDVyrCK
WHERE X.ID IS NULL
END
END
END
IF @TypOperace = 0
BEGIN
IF UPDATE(IDStavSkladu)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(70278, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF UPDATE(IDVyrCK) OR UPDATE(Nazev1)
IF EXISTS(SELECT *
FROM INSERTED      AS I
JOIN TabStavSkladu AS S ON S.ID = I.IDStavSkladu
JOIN TabVyrCK      AS VCK ON VCK.ID = I.IDVyrCK
WHERE I.Nazev1 <> VCK.Nazev1)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71974, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @TypOperace IN(0,1)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZShodaVCSVyrCK = 1)
IF @TypOperace = 1 OR
@TypOperace = 0 AND (
UPDATE(ZarukaVstup)  OR UPDATE(TypZarukaVstup)  OR UPDATE(DatVstup) OR
UPDATE(ZarukaVystup) OR UPDATE(TypZarukaVystup) OR UPDATE(DatVystup) OR
UPDATE(Nazev2) OR UPDATE(DatExpirace))
IF EXISTS(SELECT *
FROM INSERTED AS I
JOIN TabVyrCK AS K ON K.ID = I.IDVyrCK
WHERE I.Nazev2          <> K.Nazev2          OR
I.ZarukaVstup     <> K.ZarukaVstup     OR
I.ZarukaVystup    <> K.ZarukaVystup    OR
I.TypZarukaVstup  <> K.TypZarukaVstup  OR
I.TypZarukaVystup <> K.TypZarukaVystup OR
(I.DatVstup <> K.DatVstup) OR
(I.DatVstup IS NULL AND K.DatVstup IS NOT NULL) OR
(K.DatVstup IS NULL AND I.DatVstup IS NOT NULL) OR
(I.DatVystup <> K.DatVystup) OR
(I.DatVystup IS NULL AND K.DatVystup IS NOT NULL) OR
(K.DatVystup IS NULL AND I.DatVystup IS NOT NULL) OR
(I.DatExpirace <> K.DatExpirace) OR
(I.DatExpirace IS NULL AND K.DatExpirace IS NOT NULL) OR
(K.DatExpirace IS NULL AND I.DatExpirace IS NOT NULL))
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71979, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(SELECT * FROM TabHGlob WHERE OZTrgHlidaZaporneVC = 1)
BEGIN
IF EXISTS(
SELECT *
FROM INSERTED AS I
JOIN TabStavSkladu AS S ON S.ID = I.IDStavSkladu
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE S.Metoda IN(5,7,9,11)
AND (S.KontrolaVC    IN (N'A', N'B', N'D') OR
(K.KontrolaVyrC IN (N'A', N'B', N'D') AND S.KontrolaVC = N'C'))
AND I.Mnozstvi < 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(72024, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT *
FROM INSERTED AS I
JOIN TabStavSkladu AS S ON S.ID = I.IDStavSkladu
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE S.Metoda IN(5,7,9,11)
AND (S.KontrolaVC    IN (N'A', N'B', N'D') OR
(K.KontrolaVyrC IN (N'A', N'B', N'D') AND S.KontrolaVC = N'C'))
AND I.FinStav < 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(72025, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
END
GO
