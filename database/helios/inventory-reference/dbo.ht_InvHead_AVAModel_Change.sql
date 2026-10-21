-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_InvHead_AVAModel_Change] ON [dbo].[TabInvHead] FOR UPDATE AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @ModelId NVARCHAR(255)
SET @ModelId = N'4834f437-3ec6-4e55-ae27-2b06f1c54f89'
IF UPDATE(Stav) AND EXISTS(SELECT*FROM INSERTED WHERE Stav=2) AND
EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelId AND DataDirection IN(0,2))
BEGIN
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT M.RegistrationID, 'D', M.ModelID, A.AVAReferenceID
FROM INSERTED I
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabInvItem P ON P.IDDoklad = I.ID
JOIN TabStavSkladu S ON S.ID = P.IDSklad
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = P.IDSklad
WHERE S.AVAOutputFlag IN(1,3,4) AND NOT EXISTS(SELECT*FROM TabStavSkladuAVAView WHERE AVAReferenceID=A.AVAReferenceID)
DELETE A
FROM INSERTED I
JOIN TabInvItem P ON P.IDDoklad = I.ID
JOIN TabStavSkladuAVA A ON A.IDStavSkladu=P.IDSklad
WHERE NOT EXISTS(SELECT*FROM TabStavSkladuAVAView WHERE IDStavSkladu=A.IDStavSkladu AND ISNULL(IDUmisteni,-1)=ISNULL(A.IDUmisteni,-1) AND ISNULL(IDVyrCislo,-1)=ISNULL(A.IDVyrCislo,-1))
DECLARE @InsertedIds TABLE (ID INT)
INSERT INTO TabStavSkladuAVA (IDStavSkladu, IDUmisteni, IDVyrCislo, Mnozstvi, SourceTrigger)
OUTPUT INSERTED.ID INTO @InsertedIDs
SELECT DISTINCT V.IDStavSkladu, V.IDUmisteni, V.IDVyrCislo, V.Mnozstvi, 'TabInvHead'
FROM INSERTED I
JOIN TabInvItem P ON P.IDDoklad = I.ID
JOIN TabStavSkladuAVAView V ON V.IDStavSkladu = P.IDSklad AND ISNULL(V.IDUmisteni,-1)=ISNULL(P.IDUmisteni,-1) AND ISNULL(V.IDVyrCislo,-1)=ISNULL(P.IDVyrCS,-1)
WHERE NOT EXISTS (
SELECT 1 FROM TabStavSkladuAVA A
WHERE A.IDStavSkladu = V.IDStavSkladu
AND ISNULL(A.IDUmisteni, -1) = ISNULL(V.IDUmisteni, -1)
AND ISNULL(A.IDVyrCislo, -1) = ISNULL(V.IDVyrCislo, -1)
)
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT M.RegistrationID, 'I', M.ModelID, A.AVAReferenceID
FROM @InsertedIDs I
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabStavSkladuAVA A ON A.ID = I.ID
JOIN TabStavSkladu S ON S.ID = A.IDStavSkladu
WHERE S.AVAOutputFlag IN(1,3,4)
INSERT INTO TabAVAModelDataChanges (
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT M.RegistrationID, 'U', M.ModelID, A.AVAReferenceID
FROM INSERTED I
JOIN TabInvItem P ON P.IDDoklad = I.ID
JOIN TabAVARegisteredModels M ON M.ModelID = @ModelId AND m.DataDirection IN(0,2)
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = P.IDSklad AND ISNULL(A.IDUmisteni,-1)=ISNULL(P.IDUmisteni,-1) AND ISNULL(A.IDVyrCislo,-1)=ISNULL(P.IDVyrCS,-1)
JOIN TabStavSkladuAVAView V ON V.ID = A.ID
WHERE A.Mnozstvi <> V.Mnozstvi
UPDATE A
SET A.Mnozstvi = V.Mnozstvi
FROM INSERTED I
JOIN TabInvItem P ON P.IDDoklad = I.ID
JOIN TabStavSkladuAVA A ON A.IDStavSkladu = P.IDSklad AND ISNULL(A.IDUmisteni,-1)=ISNULL(P.IDUmisteni,-1) AND ISNULL(A.IDVyrCislo,-1)=ISNULL(P.IDVyrCS,-1)
JOIN TabStavSkladuAVAView V ON V.ID = A.ID
WHERE A.Mnozstvi <> V.Mnozstvi
END
GO
