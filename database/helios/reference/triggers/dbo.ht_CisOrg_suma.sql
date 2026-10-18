-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisOrg_suma] ON [dbo].[TabCisOrg] FOR INSERT, UPDATE, DELETE
AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @PocetInserted INT,@PocetDeleted INT,@CisloOrg INT, @DIC NVARCHAR(15),
@VlZeme NVARCHAR(3), @ISOZeme NVARCHAR(3), @Zeme NVARCHAR(3),
@DICSk NVARCHAR(15), @Legislativa INT,
@OldICO NVARCHAR(20), @NewICO NVARCHAR(20), @ID INT, @Partner NVARCHAR(7),
@Overeni BIT
DECLARE @ErrStr NVARCHAR(2047), @Chyba NVARCHAR(200), @ErrNo INT
SET @PocetInserted = (SELECT COUNT(*) FROM inserted)
SET @PocetDeleted  = (SELECT COUNT(*) FROM deleted)
IF @PocetDeleted > @PocetInserted
IF EXISTS(SELECT * FROM deleted WHERE CisloOrg = 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(83144, '')
RAISERROR(@ErrStr, 16, 1)
END
IF @PocetInserted > 0 AND
(UPDATE(CenovaUroven) OR UPDATE(CenovaUrovenNakup)) AND
EXISTS(SELECT * FROM Inserted
WHERE CenovaUroven IS NOT NULL OR CenovaUrovenNakup IS NOT NULL)
BEGIN
IF EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS C ON C.CenovaUroven = I.CenovaUroven
WHERE C.DruhCU = 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71854, '')
RAISERROR(@ErrStr, 16, 1)
END
IF EXISTS(SELECT *
FROM Inserted AS I
JOIN TabCisNC AS C ON C.CenovaUroven = I.CenovaUrovenNakup
WHERE C.DruhCU = 1)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71855, '')
RAISERROR(@ErrStr, 16, 1)
END
END
IF @PocetDeleted = @PocetInserted AND
(UPDATE(Nazev) OR UPDATE(DruhyNazev) OR UPDATE(Misto) OR UPDATE(Ulice) OR
UPDATE(DIC) OR UPDATE(DICSk) OR UPDATE(ICO) OR UPDATE(PSC) OR UPDATE(OdpOs) OR
UPDATE(PopCislo) OR UPDATE(OrCislo) OR UPDATE(Stav) OR UPDATE(PostAddress) OR
UPDATE(NespolehPlatce) OR UPDATE(DatZverejNespolehPlatce) OR UPDATE(IdZeme) OR
UPDATE(DatPoslOverNespolehPlatceSys) OR UPDATE(DatPoslOverNespolehPlatceUziv) OR
UPDATE(UdajOZapisuDoObchRej) OR UPDATE(AresDatumAktualizaceRegistru) OR
UPDATE(NazevCastiObce) OR UPDATE(NazevOkresu) OR UPDATE(MestskaCast))
BEGIN
INSERT INTO TabCisOrgArch (DatZmeny,CisloOrg,Nazev,DruhyNazev,Misto,Ulice,DIC,DICSk,ICO,PSC,OdpOs,PopCislo,OrCislo,Stav,PostAddress,NazevCastiObce,NazevOkresu,MestskaCast,
NespolehPlatce,DatZverejNespolehPlatce,DatPoslOverNespolehPlatceSys,DatPoslOverNespolehPlatceUziv,IdZeme,Overeni,UdajOZapisuDoObchRej, AresDatumAktualizaceRegistru)
SELECT GETDATE(),I.CisloOrg,T.Nazev,T.DruhyNazev,T.Misto,T.Ulice,T.DIC,T.DICSk,T.ICO,T.PSC,T.OdpOs,T.PopCislo,T.OrCislo,T.Stav,T.PostAddress,T.NazevCastiObce,T.NazevOkresu,T.MestskaCast,
T.NespolehPlatce,T.DatZverejNespolehPlatce,T.DatPoslOverNespolehPlatceSys,T.DatPoslOverNespolehPlatceUziv,T.IdZeme,
CASE WHEN UPDATE(NespolehPlatce) OR UPDATE(DatZverejNespolehPlatce) OR UPDATE(DatPoslOverNespolehPlatceSys) OR UPDATE(DatPoslOverNespolehPlatceUziv) THEN 1 ELSE 0 END,
T.UdajOZapisuDoObchRej, T.AresDatumAktualizaceRegistru
FROM (SELECT ID,Nazev,DruhyNazev,Misto,Ulice,PopCislo,OrCislo,PostAddress,DIC = ISNULL(DIC, ''),DICSk = ISNULL(DICSk, ''),ICO = ISNULL(ICO, ''),PSC = ISNULL(PSC, ''),
OdpOs,Stav,NespolehPlatce,DatZverejNespolehPlatce,DatPoslOverNespolehPlatceSys,DatPoslOverNespolehPlatceUziv,IdZeme,UdajOZapisuDoObchRej,NazevCastiObce,NazevOkresu,MestskaCast,AresDatumAktualizaceRegistru
FROM DELETED
EXCEPT
SELECT ID,Nazev,DruhyNazev,Misto,Ulice,PopCislo,OrCislo,PostAddress,ISNULL(DIC, ''),ISNULL(DICSk, ''),ISNULL(ICO, ''),ISNULL(PSC, ''),
OdpOs,Stav,NespolehPlatce,DatZverejNespolehPlatce,DatPoslOverNespolehPlatceSys,DatPoslOverNespolehPlatceUziv,IdZeme,UdajOZapisuDoObchRej,NazevCastiObce,NazevOkresu,MestskaCast,AresDatumAktualizaceRegistru
FROM INSERTED
EXCEPT
SELECT ID,N'',N'',N'',N'',N'',N'',N'',N'',N'',N'',N'',NULL,0,3,NULL,NULL,NULL,NULL,N'',N'',N'',N'',NULL
FROM DELETED
) as T
INNER JOIN DELETED D ON T.ID = D.ID
INNER JOIN INSERTED I ON T.ID = I.ID
WHERE NOT (@PocetDeleted = 1 AND @PocetInserted = 1 AND I.DatZmeny IS NULL AND D.DatZmeny IS NULL)
END
IF @PocetInserted>0 AND UPDATE(DIC)
BEGIN
SELECT @VlZeme = ISOKod FROM TabZeme WHERE Vlastni = 1
SELECT @Legislativa = Legislativa FROM TabHGlob
IF @Legislativa = 0
SET @VlZeme = ISNULL(@Zeme,'CZ')
ELSE
IF @Legislativa = 1
SET @VlZeme = ISNULL(@Zeme,'SK')
ELSE
IF @Legislativa = 2
SET @VlZeme = ISNULL(@Zeme,'DE')
ELSE
IF @Legislativa = 4
SET @VlZeme = ISNULL(@Zeme,'PL')
DECLARE OrgCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT CisloOrg, DIC,IdZeme FROM Inserted WHERE DIC IS NOT NULL
OPEN OrgCursor
WHILE 1=1
BEGIN
FETCH NEXT FROM OrgCursor INTO @CisloOrg, @DIC, @ISOZeme
IF @@FETCH_STATUS<>0 BREAK
SET @Zeme = LEFT(@DIC,2)
IF @Zeme=N'EL' SET @Zeme=N'GR'
IF @Zeme IS NULL OR @Zeme=''
SET @Zeme = ISNULL(@ISOZeme,@VlZeme)
IF NOT EXISTS(SELECT * FROM TabDICOrg WHERE CisloOrg=@CisloOrg AND DIC=@DIC)
BEGIN
IF NOT EXISTS(SELECT * FROM TabZeme WHERE ISOKod=@Zeme)
BEGIN
ROLLBACK
SET @Chyba = N'63877' + NCHAR(13) + @Zeme + NCHAR(13) + @DIC
SET @ErrStr = dbo.hf_FormatError(99996, @Chyba)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
ELSE
BEGIN
IF @PocetInserted=1
BEGIN
EXEC dbo.hp_VAT_ID_kontrola @DIC, @ErrNo OUT
IF @ErrNo<>0
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(@ErrNo, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
INSERT INTO TabDICOrg (CisloOrg, DIC, ISOZeme) VALUES (@CisloOrg, @DIC, @Zeme)
IF @@ERROR <> 0
BEGIN
ROLLBACK
RETURN
END
END
END
END
CLOSE OrgCursor
DEALLOCATE OrgCursor
END
IF @PocetInserted>0 AND (UPDATE(ICO) OR UPDATE(Partner))
BEGIN
DECLARE OrgCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT CisloOrg, ICO, Partner FROM Inserted
OPEN OrgCursor
WHILE 1=1
BEGIN
FETCH NEXT FROM OrgCursor INTO @CisloOrg, @NewICO, @Partner
IF @@FETCH_STATUS<>0 BREAK
IF @Partner IS NOT NULL AND @Partner<>''
SET @NewICO=REPLACE(UPPER(@Partner),' ','')
ELSE
SET @NewICO=dbo.hf_KontrolaICOJenCisla(@NewICO)
UPDATE TabCisOrg SET PartnerICO=@NewICO WHERE CisloOrg=@CisloOrg
END
CLOSE OrgCursor
DEALLOCATE OrgCursor
END
IF @PocetDeleted > 0 AND @PocetInserted > 0 AND UPDATE(ICO) AND
EXISTS(SELECT * FROM Deleted  WHERE CisloOrg=0) AND
EXISTS(SELECT * FROM Inserted WHERE CisloOrg=0)
BEGIN
SELECT @OldICO=ICO FROM Deleted WHERE CisloOrg=0
SELECT @NewICO=ICO FROM Inserted WHERE CisloOrg=0
IF @OldICO IS NOT NULL AND @OldICO<>'' AND @NewICO IS NOT NULL AND @NewICO<>''
UPDATE TabSkupRegDPH SET ICO=@NewICO WHERE ICO=@OldICO
END
IF UPDATE(VernostniProgram)
BEGIN
DECLARE @VernostniProgram BIT, @PoklProdBKPrvniBody INT, @PoklProdBKIdent NVARCHAR(36)
SELECT @PoklProdBKPrvniBody = PoklProdBKPrvniBody, @PoklProdBKIdent = PoklProdBKIdent
FROM TabHGlob
IF @PoklProdBKPrvniBody > 0
BEGIN
DECLARE c CURSOR FAST_FORWARD LOCAL FOR
SELECT CisloOrg, VernostniProgram FROM INSERTED WHERE VernostniProgram=1
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c INTO @CisloOrg, @VernostniProgram
IF @@FETCH_STATUS <> 0 BREAK
IF NOT EXISTS(SELECT*FROM TabBodoveKontoView WHERE CisloOrg = @CisloOrg)
INSERT TabBodoveKontoUprava(CisloOrg,Ident,BodyPlus,BodyMinus,Poznamka)
VALUES(@CisloOrg,@PoklProdBKIdent,@PoklProdBKPrvniBody,0,'Vstup do věrnostního programu')
END
CLOSE c
DEALLOCATE c
END
END
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE DataDirection IN(0,2))
BEGIN
  DECLARE @INSERTED htyp_InsertedDeletedTriggerCisOrg
  DECLARE @DELETED  htyp_InsertedDeletedTriggerCisOrg
  DECLARE @Upd_CenovaUroven BIT = 0, @Upd_CenovaUrovenNakup BIT = 0

  IF UPDATE(CenovaUroven) SET @Upd_CenovaUroven = 1
  IF UPDATE(CenovaUrovenNakup) SET @Upd_CenovaUrovenNakup = 1

  INSERT @INSERTED(ID, AVAOutputFlag, AVAReferenceID, CisloOrg, ICO,
    CenovaUroven, CenovaUrovenNakup, PravniForma, DIC, DICSk,
    Nazev, Ulice, PSC, Misto, IDZeme, NadrizenaOrg)
  SELECT ID, AVAOutputFlag, AVAReferenceID, CisloOrg, ICO,
    CenovaUroven, CenovaUrovenNakup, PravniForma, DIC, DICSk,
    Nazev, Ulice, PSC, Misto, IDZeme, NadrizenaOrg
  FROM INSERTED

  INSERT @DELETED(ID, AVAOutputFlag, AVAReferenceID, CisloOrg, ICO,
    CenovaUroven, CenovaUrovenNakup, PravniForma, DIC, DICSk,
    Nazev, Ulice, PSC, Misto, IDZeme, NadrizenaOrg)
  SELECT ID, AVAOutputFlag, AVAReferenceID, CisloOrg, ICO,
    CenovaUroven, CenovaUrovenNakup, PravniForma, DIC, DICSk,
    Nazev, Ulice, PSC, Misto, IDZeme, NadrizenaOrg
  FROM DELETED

  EXEC dbo.hp_CisOrg_AVAModel_Change
    @INSERTED, @DELETED, @Upd_CenovaUroven, @Upd_CenovaUrovenNakup
END
GO
