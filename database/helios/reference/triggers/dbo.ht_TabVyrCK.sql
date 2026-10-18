-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabVyrCK]
ON [dbo].[TabVyrCK] FOR UPDATE
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
IF @TypOperace = 0
BEGIN
IF UPDATE(IDKmenZbozi)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71975, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF UPDATE(Nazev1)
IF EXISTS(SELECT *
FROM INSERTED AS I
JOIN DELETED  AS D ON D.ID = I.ID
WHERE I.Nazev1 <> D.Nazev1)
BEGIN
UPDATE VCS SET Nazev1 = I.Nazev1
FROM TabVyrCS AS VCS
JOIN INSERTED AS I ON I.ID = VCS.IDVyrCK
JOIN DELETED  AS D ON D.ID = I.ID
WHERE I.Nazev1 <> D.Nazev1
END
IF EXISTS(SELECT * FROM TabHGlob WHERE OZShodaVCSVyrCK = 1) AND(
UPDATE(ZarukaVstup)  OR UPDATE(TypZarukaVstup)  OR UPDATE(DatVstup) OR
UPDATE(ZarukaVystup) OR UPDATE(TypZarukaVystup) OR UPDATE(DatVystup) OR
UPDATE(Nazev2)       OR UPDATE(DatExpirace))
IF EXISTS(
SELECT *
FROM INSERTED AS I
JOIN TabVyrCS AS S ON S.IDVyrCK = I.ID
WHERE I.Nazev2          <> S.Nazev2          OR
I.ZarukaVstup     <> S.ZarukaVstup     OR
I.ZarukaVystup    <> S.ZarukaVystup    OR
I.TypZarukaVstup  <> S.TypZarukaVstup  OR
I.TypZarukaVystup <> S.TypZarukaVystup OR
(I.DatVstup <> S.DatVstup) OR
(I.DatVstup IS NULL AND S.DatVstup IS NOT NULL) OR
(S.DatVstup IS NULL AND I.DatVstup IS NOT NULL) OR
(I.DatVystup <> S.DatVystup) OR
(I.DatVystup IS NULL AND S.DatVystup IS NOT NULL) OR
(S.DatVystup IS NULL AND I.DatVystup IS NOT NULL) OR
(I.DatExpirace <> S.DatExpirace) OR
(I.DatExpirace IS NULL AND S.DatExpirace IS NOT NULL) OR
(S.DatExpirace IS NULL AND I.DatExpirace IS NOT NULL))
UPDATE S SET
Nazev2          = I.Nazev2,
ZarukaVstup     = I.ZarukaVstup,
ZarukaVystup    = I.ZarukaVystup,
TypZarukaVstup  = I.TypZarukaVstup,
TypZarukaVystup = I.TypZarukaVystup,
DatVstup        = I.DatVstup,
DatVystup       = I.DatVystup,
DatExpirace     = I.DatExpirace
FROM TabVyrCS AS S
JOIN INSERTED AS I ON I.ID = S.IDVyrCK
WHERE I.Nazev2          <> S.Nazev2          OR
I.ZarukaVstup     <> S.ZarukaVstup     OR
I.ZarukaVystup    <> S.ZarukaVystup    OR
I.TypZarukaVstup  <> S.TypZarukaVstup  OR
I.TypZarukaVystup <> S.TypZarukaVystup OR
(I.DatVstup <> S.DatVstup) OR
(I.DatVstup IS NULL AND S.DatVstup IS NOT NULL) OR
(S.DatVstup IS NULL AND I.DatVstup IS NOT NULL) OR
(I.DatVystup <> S.DatVystup) OR
(I.DatVystup IS NULL AND S.DatVystup IS NOT NULL) OR
(S.DatVystup IS NULL AND I.DatVystup IS NOT NULL) OR
(I.DatExpirace <> S.DatExpirace) OR
(I.DatExpirace IS NULL AND S.DatExpirace IS NOT NULL) OR
(S.DatExpirace IS NULL AND I.DatExpirace IS NOT NULL)
END
GO
