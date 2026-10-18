-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_ModifyDIC] ON [dbo].[TabDICOrg] FOR INSERT,UPDATE,DELETE
AS
SET NOCOUNT ON
DECLARE @JakaAkce INT, @PocetInserted INT, @PocetDeleted INT
DECLARE @ID INT, @CisloOrg INT, @PlatceDPH BIT
DECLARE @ISOZeme NVARCHAR(3), @VlaZeme NVARCHAR(3)
DECLARE @DIC NVARCHAR(20)
DECLARE @AktualniDICNeplatce BIT
DECLARE @AutorOvereniDIC NVARCHAR(128), @DatumOvereniDIC DATETIME
IF EXISTS(SELECT * FROM INSERTED)
SET @JakaAkce = 1
ELSE
SET @JakaAkce = 0
IF EXISTS(SELECT * FROM DELETED) SET @JakaAkce = @JakaAkce + 2
SET @PocetInserted=(SELECT COUNT(*)FROM inserted)
SET @PocetDeleted =(SELECT COUNT(*)FROM deleted)
IF @JakaAkce = 2
BEGIN
UPDATE O SET DIC = NULL
FROM TabCisOrg AS O
JOIN Deleted   AS D ON D.CisloOrg = O.CisloOrg AND D.DIC = O.DIC
DECLARE Kur CURSOR LOCAL FAST_FORWARD FOR
SELECT CisloOrg, ISOZeme, AktualniDICNeplatce FROM deleted
GROUP BY CisloOrg, ISOZeme, AktualniDICNeplatce
OPEN Kur
WHILE 1=1 BEGIN
FETCH NEXT FROM Kur INTO @CisloOrg, @ISOZeme, @AktualniDICNeplatce
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_AktualniDICVyber @CisloOrg, @ISOZeme, @AktualniDICNeplatce
END
CLOSE Kur
DEALLOCATE Kur
END
IF @JakaAkce = 3
UPDATE TabDICOrg SET Zmenil=SUSER_SNAME(),DatZmeny=GETDATE()
FROM TabDICOrg JOIN Inserted ON Inserted.Id=TabDICOrg.Id
IF @JakaAkce = 3 AND (UPDATE(DIC))
UPDATE O SET DIC = I.DIC
FROM TabCisOrg AS O
JOIN Deleted   AS D ON D.CisloOrg = O.CisloOrg AND D.DIC = O.DIC
JOIN Inserted  AS I ON I.ID = D.ID
IF @JakaAkce = 3 AND (UPDATE(ISOZeme) OR UPDATE(DIC) OR UPDATE(AktualniDIC))
BEGIN
SELECT TOP 1 @VlaZeme = ISOKod FROM TabZeme WHERE Vlastni = 1
DECLARE Kur CURSOR LOCAL FAST_FORWARD FOR
SELECT CisloOrg, AutorOvereniDIC, DatumOvereniDIC FROM inserted
OPEN Kur
WHILE 1=1 BEGIN
FETCH NEXT FROM Kur
INTO @CisloOrg, @AutorOvereniDIC, @DatumOvereniDIC
IF @@FETCH_STATUS <> 0 BREAK
IF EXISTS(SELECT * FROM TabDICOrg
WHERE CisloOrg=@CisloOrg AND ISOZeme=@VlaZeme AND SUBSTRING(DIC,1,2)=@VlaZeme AND AktualniDIC=1)
SET @PlatceDPH = 1
ELSE
SET @PlatceDPH = 0
UPDATE o SET
o.PlatceDPH = @PlatceDPH,
o.Zmenil = SUSER_SNAME(),
o.DatZmeny = GETDATE()
FROM TabCisOrg o
WHERE o.CisloOrg = @CisloOrg
END
CLOSE Kur
DEALLOCATE Kur
END
IF @JakaAkce = 1
BEGIN
UPDATE TabDICOrg SET DIC=dbo.hf_OrezDIC(TabDICOrg.DIC)
FROM TabDICOrg JOIN Inserted ON Inserted.Id=TabDICOrg.Id
WHERE TabDICOrg.DIC IS NOT NULL AND TabDICOrg.DIC<>''
DECLARE Kur CURSOR LOCAL FAST_FORWARD FOR
SELECT ID, DIC, CisloOrg, ISOZeme FROM inserted
WHERE DIC IS NOT NULL AND DIC<>''
OPEN Kur
WHILE 1=1 BEGIN
FETCH NEXT FROM Kur INTO @ID, @DIC, @CisloOrg, @ISOZeme
IF @@FETCH_STATUS <> 0 BREAK
IF EXISTS(SELECT * FROM TabDICOrg WHERE Id<>@ID AND CisloOrg=@CisloOrg AND ISOZeme=@ISOZeme AND AktualniDICNeplatce=1)
EXEC dbo.hp_AktualniDIC @ID, 1
ELSE
EXEC dbo.hp_AktualniDIC @ID, 0
END
CLOSE Kur
DEALLOCATE Kur
END
IF @JakaAkce = 3 AND (UPDATE(DIC))
UPDATE DO SET
VysledekOvereniDIC = N'',
AutorOvereniDIC    = N'',
DatumOvereniDIC    = NULL
FROM TabDICOrg DO
JOIN inserted ON DO.ID = Inserted.ID
IF @JakaAkce = 3 AND
(UPDATE(CisloOrg) OR UPDATE(ISOZeme) OR UPDATE(DIC) OR UPDATE(AktualniDIC) OR UPDATE(AktualniDICNeplatce))
INSERT INTO TabDICOrgArch
(DatZmeny, IDDICOrg, CisloOrg, ISOZeme, DIC, AktualniDIC, AktualniDICNeplatce)
SELECT
GETDATE(), d.ID, d.CisloOrg, d.ISOZeme, d.DIC, d.AktualniDIC, d.AktualniDICNeplatce
FROM Deleted AS d
JOIN Inserted AS i ON i.ID = d.ID
WHERE NOT EXISTS (
SELECT
i.CisloOrg, i.ISOZeme, i.DIC, i.AktualniDIC, i.AktualniDICNeplatce
INTERSECT
SELECT
d.CisloOrg, d.ISOZeme, d.DIC, d.AktualniDIC, d.AktualniDICNeplatce)
DECLARE @ModelId NVARCHAR(255)
SET @ModelId = N'7871b21b-358a-417a-9938-e7a9308708b3'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelId AND DataDirection IN(0,2))
BEGIN
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)
SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
IF @Ins > 0 AND @Del = 0 SET @ActionType = N'I'
IF @Ins = 0 AND @Del > 0 SET @ActionType = N'D'
IF @Ins > 0 AND @Del > 0 SET @ActionType = N'U'
IF @Ins = 0 AND @Del > 0
BEGIN
INSERT TabAVAModelDataChanges(
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
FROM TabAVARegisteredModels m, DELETED d
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2)
END
ELSE
BEGIN
INSERT TabAVAModelDataChanges(
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
FROM TabAVARegisteredModels m, 
(SELECT ID, AVAReferenceID, CisloOrg, DIC, ISOZeme
FROM INSERTED
EXCEPT
SELECT ID, AVAReferenceID, CisloOrg, DIC, ISOZeme
FROM DELETED) i
JOIN TabCisOrg org ON org.CisloOrg = i.CisloOrg
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2) AND org.AVAOutputFlag IN(1,3,4)
END
END
GO
