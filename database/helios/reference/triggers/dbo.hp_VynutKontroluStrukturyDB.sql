-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[hp_VynutKontroluStrukturyDB] ON [dbo].[TabHGlob] FOR INSERT, UPDATE AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @ErrStr  NVARCHAR(2000)
DECLARE @Hlaska  NVARCHAR(2000)
DECLARE @Hodnota NVARCHAR(2000)
IF UPDATE(VerzeEXE)
BEGIN
DECLARE @VerzeEXE NVARCHAR(12), @Skript NVARCHAR(1024)
IF COLUMNPROPERTY(OBJECT_ID(N'dbo.TabSetup',N'U'),N'VerzeSysDB',N'AllowsNull')IS NOT NULL
BEGIN
SELECT @VerzeEXE = VerzeEXE FROM TabHGlob
SET @Skript =
N'IF NOT EXISTS(SELECT*FROM TabSetup) ' +
'INSERT TabSetup(ID,VerzeSysDB)VALUES(0, N''' + @VerzeEXE + ''') ' +
'ELSE ' +
'UPDATE TabSetup SET VerzeSysDB = N''' + @VerzeEXE + ''''
EXEC(@Skript)
END
END
IF UPDATE(CasRozliseniSplatnosti)  OR
UPDATE(CasRozliseniSplatnosti2) OR
UPDATE(CasRozliseniSplatnosti3) OR
UPDATE(CasRozliseniSplatnosti4) OR
UPDATE(CasRozliseniSplatnosti5) OR
UPDATE(CasRozliseniSplatnosti6)
UPDATE TabHGlob SET VelikostEXE = 0
IF UPDATE(FazeEuro)
IF (SELECT FazeEuro FROM Inserted)<
(SELECT FazeEuro FROM Deleted)
BEGIN
SET @ErrStr = dbo.hf_FormatError(62318, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF (SELECT COUNT(*)FROM deleted) = (SELECT COUNT(*)FROM Inserted) AND
UPDATE(PouzivatPomerKoef) AND (SELECT PouzivatPomerKoef FROM Deleted)=2
BEGIN
SET @ErrStr = dbo.hf_FormatError(101188, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF (SELECT COUNT(*)FROM deleted) = (SELECT COUNT(*)FROM Inserted) AND
UPDATE(PomerKoefDatumPlatnosti) AND EXISTS(SELECT 1 FROM Deleted WHERE PomerKoefDatumPlatnosti IS NOT NULL)
BEGIN
SET @ErrStr = dbo.hf_FormatError(101189, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF UPDATE(OZZpusobRealizace)
IF EXISTS(
SELECT * FROM Inserted AS I
JOIN Deleted AS D ON D.ID = I.ID
WHERE I.OZZpusobRealizace <> 
D.OZZpusobRealizace)
BEGIN
IF EXISTS(
SELECT * FROM TabStavSkladu
WHERE Mnozstvi <> MnozFinReal)
BEGIN
SET @ErrStr = dbo.hf_FormatError(72157, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM TabVyrCS
WHERE Mnozstvi <> MnozFinReal)
BEGIN
SET @ErrStr = dbo.hf_FormatError(72158, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM Inserted AS I
JOIN Deleted AS D ON D.ID = I.ID
WHERE I.OZZpusobRealizace = 0
AND   D.OZZpusobRealizace <> 0)
BEGIN
IF EXISTS(
SELECT * FROM TabDokladyZbozi
WHERE DruhPohybuZbo < 5
AND DatRealizace IS NULL
AND DatRealMnoz IS NOT NULL)
BEGIN
SET @ErrStr = dbo.hf_FormatError(72159, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF EXISTS(
SELECT * FROM Inserted AS I
JOIN Deleted AS D ON D.ID = I.ID
WHERE I.OZZpusobRealizace = 1
AND   D.OZZpusobRealizace <> 1)
BEGIN
IF EXISTS(
SELECT * FROM TabStavSkladu WHERE Metoda <= 2)
BEGIN
SET @ErrStr = dbo.hf_FormatError(72160, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM TabHGlob
WHERE OZHromadnaRealizace_DruhDatumu <> 2)
BEGIN
SET @ErrStr = dbo.hf_FormatError(72164, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF OBJECT_ID(N'dbo.ep_P01','P')IS NOT NULL OR
OBJECT_ID(N'dbo.ep_P03','P')IS NOT NULL OR
OBJECT_ID(N'dbo.ep_V01','P')IS NOT NULL OR
OBJECT_ID(N'dbo.ep_V03','P')IS NOT NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(72161, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
UPDATE TabHGlob SET
OZFinRealJeDrivMnoReal = 2,
OZFinRealJeDrivNezReal = 2,
OZMnoRealJePoteFinReal = 2,
OZMnoRealTestMnozstvi  = 2
END
END
IF EXISTS(SELECT * FROM Deleted) AND
EXISTS(SELECT * FROM Inserted) AND(
UPDATE(DruhSkladu) OR
UPDATE(DruhSkladuSN) OR
UPDATE(MetodaEvidCeny))
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE MetodaSkladu >= 3)
BEGIN
IF (UPDATE(DruhSkladuSN) AND
(SELECT DruhSkladuSN FROM Inserted) <>
(SELECT DruhSkladuSN FROM Deleted)) OR
(UPDATE(MetodaEvidCeny) AND
(SELECT MetodaEvidCeny FROM Inserted) <>
(SELECT MetodaEvidCeny FROM Deleted))
UPDATE TabStavSkladu SET Metoda = 2
WHERE Metoda >= 4
ELSE
IF (UPDATE(DruhSkladu) AND
(SELECT DruhSkladu FROM Inserted) <>
(SELECT DruhSkladu FROM Deleted))
UPDATE S SET Metoda = 2
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE S.Metoda >= 4
AND K.DruhSkladu = 1
END
END
IF UPDATE(OZShodaVCSVyrCK) AND EXISTS(
SELECT * FROM INSERTED WHERE OZShodaVCSVyrCK = 1)
IF EXISTS(
SELECT *
FROM TabVyrCK AS K
JOIN TabVyrCS AS S ON S.IDVyrCK = K.ID
WHERE K.Nazev2          <> S.Nazev2          OR
K.ZarukaVstup     <> S.ZarukaVstup     OR
K.ZarukaVystup    <> S.ZarukaVystup    OR
K.TypZarukaVstup  <> S.TypZarukaVstup  OR
K.TypZarukaVystup <> S.TypZarukaVystup OR
(K.DatVstup <> S.DatVstup) OR
(K.DatVstup IS NULL AND S.DatVstup IS NOT NULL) OR
(S.DatVstup IS NULL AND K.DatVstup IS NOT NULL) OR
(K.DatVystup <> S.DatVystup) OR
(K.DatVystup IS NULL AND S.DatVystup IS NOT NULL) OR
(S.DatVystup IS NULL AND K.DatVystup IS NOT NULL) OR
(K.DatExpirace <> S.DatExpirace) OR
(K.DatExpirace IS NULL AND S.DatExpirace IS NOT NULL) OR
(S.DatExpirace IS NULL AND K.DatExpirace IS NOT NULL))
UPDATE S SET
Nazev2          = K.Nazev2,
ZarukaVstup     = K.ZarukaVstup,
ZarukaVystup    = K.ZarukaVystup,
TypZarukaVstup  = K.TypZarukaVstup,
TypZarukaVystup = K.TypZarukaVystup,
DatVstup        = K.DatVstup,
DatVystup       = K.DatVystup,
DatExpirace     = K.DatExpirace
FROM TabVyrCS AS S
JOIN TabVyrCK AS K ON K.ID = S.IDVyrCK
WHERE K.Nazev2          <> S.Nazev2          OR
K.ZarukaVstup     <> S.ZarukaVstup     OR
K.ZarukaVystup    <> S.ZarukaVystup    OR
K.TypZarukaVstup  <> S.TypZarukaVstup  OR
K.TypZarukaVystup <> S.TypZarukaVystup OR
(K.DatVstup <> S.DatVstup) OR
(K.DatVstup IS NULL AND S.DatVstup IS NOT NULL) OR
(S.DatVstup IS NULL AND K.DatVstup IS NOT NULL) OR
(K.DatVystup <> S.DatVystup) OR
(K.DatVystup IS NULL AND S.DatVystup IS NOT NULL) OR
(S.DatVystup IS NULL AND K.DatVystup IS NOT NULL) OR
(K.DatExpirace <> S.DatExpirace) OR
(K.DatExpirace IS NULL AND S.DatExpirace IS NOT NULL) OR
(S.DatExpirace IS NULL AND K.DatExpirace IS NOT NULL)
IF UPDATE(CenovaUroven) AND EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS N ON N.CenovaUroven = I.CenovaUroven
WHERE N.DruhCU = 0)
BEGIN
SET @ErrStr = dbo.hf_FormatError(71854, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF UPDATE(CenovaUrovenNakup) AND EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS N ON N.CenovaUroven = I.CenovaUrovenNakup
WHERE N.DruhCU = 1)
BEGIN
SET @ErrStr = dbo.hf_FormatError(71855, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF UPDATE(OZZpusobZapStoren) AND
(SELECT OZZpusobZapStoren FROM Inserted) <>
(SELECT OZZpusobZapStoren FROM Deleted)
UPDATE TabStavKDatu
SET ZpusobZapStoren = (SELECT OZZpusobZapStoren FROM Inserted)
IF UPDATE(OZZpusobRealizace)
IF EXISTS(
SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.OZZpusobRealizace <> 
D.OZZpusobRealizace)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZZpusobRealizace = 0)
SET @Hodnota = N'společná realizace'
ELSE
SET @Hodnota = N'oddělená realizace'
SET @Hlaska=N'Změna nastavení globální konfigurace - způsob realizace; '+
N'Nastavená hodnota = ' + @Hodnota
EXEC dbo.hp_ZapisDoZurnalu 1,125,@Hlaska
END
IF UPDATE(OZFinRealJeDrivMnoReal)
IF EXISTS(
SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.OZFinRealJeDrivMnoReal <> 
D.OZFinRealJeDrivMnoReal)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZFinRealJeDrivMnoReal = 0)
SET @Hodnota = N'realizovat bez kontroly'
ELSE
SET @Hodnota = N'zobrazit chybu a znemožnit realizaci'
SET @Hlaska=N'Změna nastavení globální konfigurace - '+
N'Kontroly dle data případu při realizaci dokladů: '+
N'Jen množstevně realizovaný doklad s dřívějším datem případu; '+
N'Nastavená hodnota = ' + @Hodnota
EXEC dbo.hp_ZapisDoZurnalu 1,125,@Hlaska
END
IF UPDATE(OZFinRealJeDrivNezReal)
IF EXISTS(
SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.OZFinRealJeDrivNezReal <> 
D.OZFinRealJeDrivNezReal)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZFinRealJeDrivNezReal = 0)
SET @Hodnota = N'realizovat bez kontroly'
ELSE
SET @Hodnota = N'zobrazit chybu a znemožnit realizaci'
SET @Hlaska=N'Změna nastavení globální konfigurace - '+
N'Kontroly dle data případu při realizaci dokladů: '+
N'Nerealizovaný doklad s dřívějším datem případu; '+
N'Nastavená hodnota = ' + @Hodnota
EXEC dbo.hp_ZapisDoZurnalu 1,125,@Hlaska
END
IF UPDATE(OZMnoRealJePoteFinReal)
IF EXISTS(
SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.OZMnoRealJePoteFinReal <> 
D.OZMnoRealJePoteFinReal)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZMnoRealJePoteFinReal = 0)
SET @Hodnota = N'realizovat bez kontroly'
ELSE
SET @Hodnota = N'zobrazit chybu a znemožnit realizaci'
SET @Hlaska=N'Změna nastavení globální konfigurace - '+
N'Kontroly dle data případu při realizaci dokladů: '+
N'Finančně realizovaný doklad s pozdějším datem případu; '+
N'Nastavená hodnota = ' + @Hodnota
EXEC dbo.hp_ZapisDoZurnalu 1,125,@Hlaska
END
IF UPDATE(OZMnoRealTestMnozstvi)
IF EXISTS(
SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.OZMnoRealTestMnozstvi <> 
D.OZMnoRealTestMnozstvi)
BEGIN
IF EXISTS(SELECT * FROM TabHGlob WHERE OZMnoRealTestMnozstvi = 0)
SET @Hodnota = N'realizovat bez kontroly'
ELSE
SET @Hodnota = N'zobrazit chybu a znemožnit realizaci'
SET @Hlaska=N'Změna nastavení globální konfigurace - '+
N'Kontroly dle data případu při realizaci dokladů: '+
N'Kontrola na ponížené množství skladem; '+
N'Nastavená hodnota = ' + @Hodnota
EXEC dbo.hp_ZapisDoZurnalu 1,125,@Hlaska
END
DECLARE @PriceListHeader NVARCHAR(MAX) = N'0dfb66bd-8c32-4629-ae35-61ebd85db527'
DECLARE @PriceListItem   NVARCHAR(MAX) = N'80df5d41-6f57-46e4-b820-b14fe4c9a69a'
  IF OBJECT_ID(N'dbo.hp_AktualizujMenyCisNCAVA', N'P') IS NOT NULL AND
     EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListHeader AND DataDirection IN(0,2)) AND
     EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListItem AND DataDirection IN(0,2))
  BEGIN
    DECLARE @CU INT

    IF UPDATE(CenovaUroven)
    BEGIN
      SELECT @CU = CenovaUroven FROM INSERTED

      IF @CU IS NULL
        SELECT @CU = CenovaUroven FROM DELETED

      EXEC hp_AktualizujMenyCisNCAVA @CU
    END

    IF UPDATE(CenovaUrovenNakup)
    BEGIN
      SELECT @CU = CenovaUrovenNakup FROM INSERTED

      IF @CU IS NULL
        SELECT @CU = CenovaUrovenNakup FROM DELETED

      EXEC hp_AktualizujMenyCisNCAVA @CU
    END
  END
GO
