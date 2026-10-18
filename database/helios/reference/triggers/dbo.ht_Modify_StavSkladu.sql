-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_Modify_StavSkladu]
ON [dbo].[TabStavSkladu] FOR INSERT, UPDATE, DELETE
AS
SET NOCOUNT ON
DECLARE @JeDeleted      BIT
DECLARE @JeInserted     BIT
DECLARE @OK             BIT
DECLARE @IDRole         INT
DECLARE @RoleOK         INT
DECLARE @IDZboSklad     INT
DECLARE @IDKmen         INT
DECLARE @IDSklad        NVARCHAR(30)
DECLARE @Chyba          INT
DECLARE @MetodaDst      TINYINT -- stanovena metoda skladove karty
DECLARE @MetodaSkladu   TINYINT -- dle TabHGlob
DECLARE @MetodaEvidCeny TINYINT -- dle TabHGlob
DECLARE @MetodaEvidVysl TINYINT -- vysledna metoda s ohlede na kontrolu VC
DECLARE @DruhSkladuG    TINYINT -- druh skladu dle TabHGlob
DECLARE @DruhSkladuT    TINYINT -- druh skladu dle TabStrom
DECLARE @DruhSkladu     TINYINT -- druh skladu vysledny
DECLARE @DruhSkladuSN   TINYINT -- druh skladu SN
DECLARE @KontrolaVC     BIT     -- kontrola VC dle kmene, stromu a HGlob
DECLARE @ErrStr         NVARCHAR(2047)
DECLARE @ChybHlaska     NVARCHAR(2047)
DECLARE @IDStavSkladu   INT     -- TabStavSkladu.ID
DECLARE @Mnozstvi       NUMERIC(19,6) -- diference hodnot Mnozstvi
DECLARE @MnozFinReal    NUMERIC(19,6) -- diference hodnot MnozFinReal
DECLARE @MnKDispo       NUMERIC(19,6) -- diference hodnot MnozstviDispo
DECLARE @EcCelkem       NUMERIC(19,6) -- diference hodnot StavSkladu
DECLARE @DelMnozstvi    NUMERIC(19,6) -- stare hodnoty from deleted
DECLARE @DelMnozFinReal NUMERIC(19,6) -- stare hodnoty from deleted
DECLARE @DelEcCelkem    NUMERIC(19,6) -- stare hodnoty from deleted
DECLARE @InsMnozstvi    NUMERIC(19,6) --  nove hodnoty from inserted
DECLARE @InsMnozFinReal NUMERIC(19,6) --  nove hodnoty from inserted
DECLARE @InsEcCelkem    NUMERIC(19,6) --  nove hodnoty from inserted
DECLARE @ChybovaHlaskaAJ NVARCHAR(100)
DECLARE @Exec            NVARCHAR(500)
IF EXISTS(SELECT * FROM INSERTED) SET @JeInserted = 1 ELSE SET @JeInserted = 0
IF EXISTS(SELECT * FROM DELETED)  SET @JeDeleted  = 1 ELSE SET @JeDeleted  = 0
IF (@JeInserted = 1) AND
(@JeDeleted  = 0)
BEGIN
IF EXISTS(SELECT
*
FROM
INSERTED i
JOIN TabKmenZbozi tkz ON tkz.ID = i.IDKmenZbozi
WHERE
(tkz.Blokovano = 2))
BEGIN
SET @ErrStr = dbo.hf_FormatError(74110, '')
ROLLBACK
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
SELECT
@MetodaSkladu   = MetodaSkladu,
@MetodaEvidCeny = MetodaEvidCeny,
@DruhSkladuG    = DruhSkladu,
@DruhSkladuSN   = DruhSkladuSN
FROM TabHGlob
IF ((UPDATE(StavSkladu) OR UPDATE(Mnozstvi)) AND @JeInserted = 1 AND @JeDeleted = 1) OR
((@JeInserted=0) AND EXISTS(SELECT * FROM DELETED  WHERE StavSkladu<>0 OR Mnozstvi<>0)) OR
((@JeDeleted =0) AND EXISTS(SELECT * FROM INSERTED WHERE StavSkladu<>0 OR Mnozstvi<>0))
BEGIN
SET @OK = 1
SET @IDRole = NULL
SELECT @IDRole = IDRole FROM TabUziv WHERE LoginName = SUSER_SNAME()
IF @JeInserted = 1
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo)
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
WHERE P.LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
WHERE P.LoginName = SUSER_SNAME() AND P.Realizace = 0)
SET @OK = 0
END
ELSE
BEGIN
SET @RoleOK = -1
IF (@IDRole IS NOT NULL) AND
EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
WHERE P.IDRole = @IDRole)
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
WHERE P.IDRole = @IDRole AND P.Realizace = 1)
SET @RoleOK = 1
ELSE
SET @RoleOK = 0
END
IF (@RoleOK <> 1) AND EXISTS(SELECT*FROM TabRoleUziv WHERE LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT*FROM TabPravaSklad p
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
JOIN TabRoleUziv ru ON ru.IDRole = p.IDRole
WHERE ru.LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT*FROM TabPravaSklad p
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
JOIN TabRoleUziv ru ON ru.IDRole = p.IDRole
WHERE ru.LoginName = SUSER_SNAME() AND P.Realizace = 1)
SET @RoleOK = 1
ELSE
SET @RoleOK = 0
END
END
IF @RoleOK = 0
SET @OK = 0
ELSE
IF @RoleOK = -1
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN INSERTED AS I ON I.IDSklad = P.Cislo
WHERE P.Realizace = 1)
SET @OK = 0
END
END
END
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED AS D ON D.IDSklad = P.Cislo)
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED AS D ON D.IDSklad = P.Cislo
WHERE P.LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED AS D ON D.IDSklad = P.Cislo
WHERE P.LoginName = SUSER_SNAME() AND P.Realizace = 0)
SET @OK = 0
END
ELSE
BEGIN
SET @RoleOK = -1
IF (@IDRole IS NOT NULL) AND
EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED AS D ON D.IDSklad = P.Cislo
WHERE P.IDRole = @IDRole)
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED AS D ON D.IDSklad = P.Cislo
WHERE P.IDRole = @IDRole AND P.Realizace = 1)
SET @RoleOK = 1
ELSE
SET @RoleOK = 0
END
IF (@RoleOK <> 1) AND EXISTS(SELECT*FROM TabRoleUziv WHERE LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT*FROM TabPravaSklad p
JOIN DELETED AS D ON D.IDSklad = P.Cislo
JOIN TabRoleUziv ru ON ru.IDRole = p.IDRole
WHERE ru.LoginName = SUSER_SNAME())
BEGIN
IF EXISTS(SELECT*FROM TabPravaSklad p
JOIN DELETED AS D ON D.IDSklad = P.Cislo
JOIN TabRoleUziv ru ON ru.IDRole = p.IDRole
WHERE ru.LoginName = SUSER_SNAME() AND P.Realizace = 1)
SET @RoleOK = 1
ELSE
SET @RoleOK = 0
END
END
IF @RoleOK = 0
SET @OK = 0
ELSE
IF @RoleOK = -1
BEGIN
IF EXISTS(SELECT * FROM TabPravaSklad AS P
JOIN DELETED D ON D.IDSklad = P.Cislo
WHERE P.Realizace = 1)
SET @OK = 0
END
END
END
END
IF @OK = 0
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(59013, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @JeInserted = 1 AND @JeDeleted = 1
AND UPDATE(KontrolaVC)
BEGIN
IF EXISTS(
SELECT *
FROM INSERTED AS I
JOIN DELETED  AS D ON D.ID = I.ID
WHERE (I.KontrolaVC = N'B' AND D.KontrolaVC <> N'B')
OR    (D.KontrolaVC = N'B' AND I.KontrolaVC <> N'B'))
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID
FROM INSERTED AS I
JOIN DELETED  AS D ON D.ID = I.ID
WHERE (I.KontrolaVC = N'B' AND D.KontrolaVC <> N'B')
OR    (D.KontrolaVC = N'B' AND I.KontrolaVC <> N'B')
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDZboSklad
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_OZAktualHlidanoVCMain
NULL, @IDZboSklad, 0, @Chyba OUT, @ChybHlaska OUT
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
FROM INSERTED     AS I
JOIN DELETED      AS D ON D.ID = I.ID
JOIN TabKmenZbozi AS K ON K.ID = I.IDKmenZbozi
WHERE I.Metoda NOT IN(0,1,3)
AND ((I.KontrolaVC = N'N' AND D.KontrolaVC <> N'N')
OR   (D.KontrolaVC = N'N' AND I.KontrolaVC <> N'N')
OR   (I.KontrolaVC = N'C' AND D.KontrolaVC <> N'C' AND K.KontrolaVyrC  = N'N' AND D.KontrolaVC <> N'N')
OR   (I.KontrolaVC = N'C' AND D.KontrolaVC <> N'C' AND K.KontrolaVyrC <> N'N' AND D.KontrolaVC  = N'N')
OR   (D.KontrolaVC = N'C' AND I.KontrolaVC <> N'C' AND K.KontrolaVyrC  = N'N' AND I.KontrolaVC <> N'N')
OR   (D.KontrolaVC = N'C' AND I.KontrolaVC <> N'C' AND K.KontrolaVyrC <> N'N' AND I.KontrolaVC  = N'N')))
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID
FROM INSERTED     AS I
JOIN DELETED      AS D ON D.ID = I.ID
JOIN TabKmenZbozi AS K ON K.ID = I.IDKmenZbozi
WHERE I.Metoda NOT IN(0,1,3)
AND ((I.KontrolaVC = N'N' AND D.KontrolaVC <> N'N')
OR   (D.KontrolaVC = N'N' AND I.KontrolaVC <> N'N')
OR   (I.KontrolaVC = N'C' AND D.KontrolaVC <> N'C' AND K.KontrolaVyrC  = N'N' AND D.KontrolaVC <> N'N')
OR   (I.KontrolaVC = N'C' AND D.KontrolaVC <> N'C' AND K.KontrolaVyrC <> N'N' AND D.KontrolaVC  = N'N')
OR   (D.KontrolaVC = N'C' AND I.KontrolaVC <> N'C' AND K.KontrolaVyrC  = N'N' AND I.KontrolaVC <> N'N')
OR   (D.KontrolaVC = N'C' AND I.KontrolaVC <> N'C' AND K.KontrolaVyrC <> N'N' AND I.KontrolaVC  = N'N'))
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDZboSklad
IF @@FETCH_STATUS <> 0 BREAK
UPDATE TabStavSkladu SET Metoda = 2
WHERE ID = @IDZboSklad
EXEC hp_OZStartSkladPri NULL, 0, @IDZboSklad
END
CLOSE Cur
DEALLOCATE Cur
END
END
IF   UPDATE(StavSkladu)
OR UPDATE(Mnozstvi)
OR UPDATE(MnozFinReal)
OR UPDATE(MnozstviDispo)
OR @JeInserted = 0
BEGIN
DECLARE CurSklad CURSOR FAST_FORWARD LOCAL FOR
SELECT ISNULL(I.Mnozstvi     ,0) - ISNULL(D.Mnozstvi     ,0),
ISNULL(I.MnozFinReal  ,0) - ISNULL(D.MnozFinReal  ,0),
ISNULL(I.MnozstviDispo,0) - ISNULL(D.MnozstviDispo,0),
ISNULL(I.StavSkladu   ,0) - ISNULL(D.StavSkladu   ,0),
ISNULL(I.Mnozstvi     ,0),
ISNULL(I.MnozFinReal  ,0),
ISNULL(D.Mnozstvi     ,0),
ISNULL(D.MnozFinReal  ,0),
ISNULL(I.StavSkladu   ,0),
ISNULL(D.StavSkladu   ,0),
I.ID
FROM INSERTED AS I
FULL JOIN DELETED AS D ON D.ID = I.ID
OPEN CurSklad
WHILE 1=1
BEGIN
FETCH NEXT FROM CurSklad INTO
@Mnozstvi, @MnozFinReal, @MnKDispo, @EcCelkem,
@InsMnozstvi, @InsMnozFinReal, @DelMnozstvi, @DelMnozFinReal,
@InsEcCelkem, @DelEcCelkem, @IDStavSkladu
IF @@fetch_status <> 0 BREAK
UPDATE TabStavSkladu
SET StavSkladuSouvis = StavSkladu +
ISNULL((SELECT Celkem FROM TabSouvNaklady
WHERE IDZboSklad = @IDStavSkladu), 0)
WHERE ID = @IDStavSkladu
IF (@Mnozstvi    <> 0) OR
(@MnozFinReal <> 0) OR
(@MnKDispo    <> 0) OR
(@EcCelkem    <> 0)
BEGIN
IF ((@Mnozstvi < 0) AND (@JeInserted = 1) AND (@InsMnozstvi = 0)) OR
((@DelMnozstvi <> 0) AND (@JeInserted = 0))
BEGIN
IF EXISTS(
SELECT * FROM TabVyrCS
WHERE IDStavSkladu = @IDStavSkladu
AND(Mnozstvi <> 0
))
UPDATE TabVyrCS SET
Mnozstvi      = 0,
MnozstviDispo = MnozstviDispo - Mnozstvi
WHERE IDStavSkladu = @IDStavSkladu
AND(Mnozstvi      <> 0 OR
MnozstviDispo <> 0)
END
IF ((@MnozFinReal < 0) AND (@JeInserted = 1) AND (@InsMnozFinReal = 0)) OR
((@DelMnozFinReal <> 0) AND (@JeInserted = 0))
BEGIN
IF EXISTS(
SELECT * FROM TabVyrCS
WHERE IDStavSkladu = @IDStavSkladu
AND(MnozFinReal <> 0 OR
FinStav     <> 0))
UPDATE TabVyrCS SET
MnozFinReal   = 0,
FinStav       = 0
WHERE IDStavSkladu = @IDStavSkladu
AND(MnozFinReal <> 0 OR
FinStav     <> 0)
END
END
END
CLOSE CurSklad
DEALLOCATE CurSklad
END
IF @JeInserted = 1 AND
@JeDeleted  = 1 AND
UPDATE(Metoda) AND
NOT UPDATE(IDKmenZbozi) AND
EXISTS(SELECT *
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.Metoda <> D.Metoda)
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID
FROM Inserted AS I
JOIN Deleted  AS D ON D.ID = I.ID
WHERE I.Metoda <> D.Metoda
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDZboSklad
IF @@FETCH_STATUS <> 0 BREAK
EXEC hp_OZStartSkladPri NULL, 0, @IDZboSklad
END
CLOSE Cur
DEALLOCATE Cur
END
IF @JeInserted = 1 AND
@JeDeleted = 0
BEGIN
DECLARE Cur CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID,
CASE WHEN K.DruhSkladu <> 1
THEN K.DruhSkladu
ELSE CASE WHEN T.DruhSkladu <> 1
THEN T.DruhSkladu
ELSE @DruhSkladuG END END,
CASE WHEN (I.KontrolaVC   = N'N')
OR   (K.KontrolaVyrC = N'N' AND I.KontrolaVC   = N'C')
THEN 0 ELSE 1 END
FROM Inserted     AS I
JOIN TabStrom     AS T ON T.Cislo = I.IDSklad
JOIN TabKmenZbozi AS K ON K.ID = I.IDKmenZbozi
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur INTO @IDZboSklad, @DruhSkladu, @KontrolaVC
IF @@FETCH_STATUS <> 0 BREAK
IF @KontrolaVC = 0
SET @MetodaEvidVysl = 0 ELSE
SET @MetodaEvidVysl = @MetodaEvidCeny
SET @MetodaDst = NULL
SET @MetodaDst =
CASE @MetodaSkladu
WHEN 0 THEN 0
WHEN 1 THEN 1
WHEN 2 THEN 1
ELSE CASE @DruhSkladu
WHEN 0 THEN 3
WHEN 4 THEN 3
WHEN 3 THEN CASE @DruhSkladuSN
WHEN 3 THEN CASE WHEN @MetodaEvidVysl = 0 THEN 4 ELSE 5 END
WHEN 2 THEN CASE WHEN @MetodaEvidVysl = 0 THEN 6 ELSE 7 END END
WHEN 2 THEN CASE @DruhSkladuSN
WHEN 3 THEN CASE WHEN @MetodaEvidVysl = 0 THEN 8 ELSE 9 END
WHEN 2 THEN CASE WHEN @MetodaEvidVysl = 0 THEN 10 ELSE 11 END END
END
END
UPDATE TabStavSkladu SET
Metoda = @MetodaDst,
IDKmenZbozi = IDKmenZbozi
WHERE ID = @IDZboSklad
END
CLOSE Cur
DEALLOCATE Cur
END
DECLARE @ModelId NVARCHAR(255)
SET @ModelId = N'4834f437-3ec6-4e55-ae27-2b06f1c54f89'
IF UPDATE(AVAOutputFlag) AND EXISTS(
SELECT * FROM TabAVARegisteredModels
WHERE ModelID = @ModelId AND DataDirection IN(0,2))
BEGIN
IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4)) AND
EXISTS(SELECT * FROM INSERTED i LEFT JOIN DELETED d ON i.ID = d.ID
WHERE i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1)
BEGIN
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT M.RegistrationID, 'D', M.ModelID, A.AVAReferenceID
FROM INSERTED I
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = I.ID
WHERE I.AVAOutputFlag IN(1,3,4)
AND NOT EXISTS(SELECT * FROM TabStavSkladuAVAView WHERE AVAReferenceID=A.AVAReferenceID)
DELETE A
FROM INSERTED I
JOIN TabStavSkladuAVA A ON A.IDStavSkladu=I.ID
WHERE NOT EXISTS(
SELECT * FROM TabStavSkladuAVAView
WHERE IDStavSkladu = A.IDStavSkladu
AND ISNULL(IDUmisteni,-1) = ISNULL(A.IDUmisteni,-1)
AND ISNULL(IDVyrCislo,-1) = ISNULL(A.IDVyrCislo,-1))
DECLARE @InsertedIds TABLE (ID INT)
INSERT INTO TabStavSkladuAVA (IDStavSkladu, IDUmisteni, IDVyrCislo, Mnozstvi, SourceTrigger)
OUTPUT INSERTED.ID INTO @InsertedIDs
SELECT DISTINCT V.IDStavSkladu, V.IDUmisteni, V.IDVyrCislo, V.Mnozstvi, 'TabStavSk'
FROM INSERTED I
JOIN TabStavSkladuAVAView V ON V.IDStavSkladu = I.ID
WHERE NOT EXISTS (
SELECT 1 FROM TabStavSkladuAVA A
WHERE A.IDStavSkladu = V.IDStavSkladu
AND ISNULL(A.IDUmisteni, -1) = ISNULL(V.IDUmisteni, -1)
AND ISNULL(A.IDVyrCislo, -1) = ISNULL(V.IDVyrCislo, -1)
)
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT M.RegistrationID, 'I', M.ModelID, A.AVAReferenceID
FROM @InsertedIDs I
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabStavSkladuAVA A ON A.ID = I.ID
JOIN TabStavSkladu S ON S.ID = A.IDStavSkladu
WHERE S.AVAOutputFlag IN(1,3,4)
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT DISTINCT M.RegistrationID, 'U', M.ModelID, A.AVAReferenceID
FROM INSERTED I
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = I.ID
JOIN TabStavSkladuAVAView V ON V.ID = A.ID
UPDATE A
SET A.Mnozstvi = V.Mnozstvi
FROM INSERTED I
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = I.ID
JOIN TabStavSkladuAVAView V ON V.ID = A.ID
WHERE A.Mnozstvi <> V.Mnozstvi
END
END
DECLARE @PriceListHeader NVARCHAR(MAX)
DECLARE @PriceListItem NVARCHAR(255)
SET @PriceListHeader = N'0dfb66bd-8c32-4629-ae35-61ebd85db527'
SET @PriceListItem = N'80df5d41-6f57-46e4-b820-b14fe4c9a69a'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListHeader AND DataDirection IN(0,2)) AND
EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListItem AND DataDirection IN(0,2))
BEGIN
IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4))
BEGIN
IF EXISTS(SELECT*FROM INSERTED i LEFT JOIN DELETED d ON i.ID = d.ID
WHERE i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1)
BEGIN
  IF EXISTS(SELECT * FROM DELETED WHERE ISNULL(AVAOutputFlag,0) = 0)
  BEGIN
    DECLARE @CU INT
    DECLARE CurMeny CURSOR FAST_FORWARD LOCAL FOR
       SELECT nc.CenovaUroven
       FROM TabNC nc JOIN INSERTED i ON i.ID = nc.IDZboSklad
       WHERE nc.IDKmenZbozi IS NULL
    OPEN CurMeny
    WHILE 1=1
      BEGIN
        FETCH NEXT FROM CurMeny INTO @CU
        IF @@FETCH_STATUS <> 0 BREAK
        EXEC hp_AktualizujMenyCisNCAVA @CU
      END
    CLOSE CurMeny
    DEALLOCATE CurMeny
  END
END
END
END
GO
