-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_SazbyDPH] ON [dbo].[TabSazbyDPH]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON
DECLARE @PocetDeleted  INT
DECLARE @PocetInserted INT
DECLARE @Legislativa   TINYINT
DECLARE @ErrStr        NVARCHAR(2047)
SET @PocetDeleted  = (SELECT COUNT(*) FROM DELETED)
SET @PocetInserted = (SELECT COUNT(*) FROM INSERTED)
SELECT @Legislativa = Legislativa FROM TabHGlob
IF @PocetInserted = 0 AND @PocetDeleted > 0
BEGIN
DELETE FROM TabSazbyDPHZboAVA
WHERE IDSazbyDPH IN (SELECT ID FROM DELETED)
END
IF    NOT UPDATE(DruhSazbyDPH)
AND NOT UPDATE(SazbaDPH)
AND NOT UPDATE(ISOKodZeme)
AND NOT UPDATE(DistribCislo)
AND NOT UPDATE(PlatnostOd)
AND NOT UPDATE(PlatnostDo)
AND NOT UPDATE(DatUkonceni)
RETURN
IF @PocetDeleted > 0
BEGIN
IF EXISTS(
SELECT * FROM TabSazbyDPHZbo AS Z
WHERE EXISTS(
SELECT * FROM DELETED AS D
WHERE D.DruhSazbyDPH = Z.DruhSazbyDPH
AND   D.ISOKodZeme   = Z.ISOKodZeme)
AND NOT EXISTS(
SELECT * FROM TabSazbyDPH AS S
WHERE S.DruhSazbyDPH = Z.DruhSazbyDPH
AND   S.ISOKodZeme   = Z.ISOKodZeme))
OR EXISTS(
SELECT * FROM TabSazbyDPHSku AS Z
WHERE EXISTS(
SELECT * FROM DELETED AS D
WHERE D.DruhSazbyDPH = Z.DruhSazbyDPH
AND   D.ISOKodZeme   = Z.ISOKodZeme)
AND NOT EXISTS(
SELECT * FROM TabSazbyDPH AS S
WHERE S.DruhSazbyDPH = Z.DruhSazbyDPH
AND   S.ISOKodZeme   = Z.ISOKodZeme))
BEGIN
ROLLBACK
IF @PocetInserted > 0
SET @ErrStr = dbo.hf_FormatError(71573, '')
ELSE
SET @ErrStr = dbo.hf_FormatError(71574, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM TabDokladyZbozi AS X
WHERE X.SazbaDPH IS NOT NULL
AND EXISTS(
SELECT * FROM DELETED AS D
WHERE D.ISOKodZeme   = X.ZemeDPH
AND   D.SazbaDPH     = X.SazbaDPH
AND   D.DruhSazbyDPH = X.DruhSazbyDPH)
AND NOT EXISTS(
SELECT * FROM TabSazbyDPH AS H
WHERE H.ISOKodZeme   = X.ZemeDPH
AND   H.SazbaDPH     = X.SazbaDPH
AND   H.DruhSazbyDPH = X.DruhSazbyDPH))
OR EXISTS(
SELECT * FROM DELETED AS D
WHERE EXISTS(
SELECT * FROM  TabPohybyZbozi AS X JOIN TabDokladyZbozi AS L ON L.ID = X.IDDoklad
WHERE D.ISOKodZeme = L.ZemeDPH
AND (D.SazbaDPH    = X.SazbaDPH OR D.SazbaDPH = X.SazbaDPHproPDP)
AND D.DruhSazbyDPH = X.DruhSazbyDPH)
AND NOT EXISTS(
SELECT * FROM TabSazbyDPH AS H
WHERE H.ISOKodZeme   = D.ISOKodZeme
AND   H.SazbaDPH     = D.SazbaDPH
AND   H.DruhSazbyDPH = D.DruhSazbyDPH))
OR EXISTS(
SELECT * FROM TabOZTxtPol AS X
JOIN TabDokladyZbozi AS L ON L.ID = X.IDDoklad
WHERE (X.SazbaDPH IS NOT NULL OR X.SazbaDPHproPDP IS NOT NULL)
AND EXISTS(
SELECT * FROM DELETED AS D
WHERE D.ISOKodZeme   = L.ZemeDPH
AND   (D.SazbaDPH     = X.SazbaDPH OR D.SazbaDPH = X.SazbaDPHproPDP)
AND   D.DruhSazbyDPH = X.DruhSazbyDPH)
AND NOT EXISTS(
SELECT * FROM TabSazbyDPH AS H
WHERE H.ISOKodZeme   = L.ZemeDPH
AND   (H.SazbaDPH     = X.SazbaDPH OR H.SazbaDPH = X.SazbaDPHproPDP)
AND   H.DruhSazbyDPH = X.DruhSazbyDPH))
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71644, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @PocetInserted > 0
BEGIN
IF EXISTS(
SELECT * FROM TabSazbyDPH AS A
JOIN INSERTED AS I ON I.ID = A.ID
WHERE EXISTS(
SELECT * FROM TabSazbyDPH AS B
WHERE A.DruhSazbyDPH = B.DruhSazbyDPH
AND   A.ISOKodZeme   = B.ISOKodZeme
AND   A.ID <> B.ID
AND  ISNULL(B.PlatnostDo, '99991231 23:59:59.997') >=
ISNULL(A.PlatnostOd, '19000101 00:00:00.000') AND
ISNULL(B.PlatnostOd, '19000101 00:00:00.000') <=
ISNULL(A.PlatnostDo, '99991231 23:59:59.997')))
BEGIN
ROLLBACK
IF @PocetDeleted > 0
SET @ErrStr = dbo.hf_FormatError(71575, '')
ELSE
SET @ErrStr = dbo.hf_FormatError(71576, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(
SELECT * FROM TabSazbyDPH AS A
JOIN INSERTED AS I ON I.ID = A.ID
WHERE A.DruhSazbyDPH = 0
AND   A.SazbaDPH <> 0)
BEGIN
ROLLBACK
SET @ErrStr = dbo.hf_FormatError(71581, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
UPDATE S SET
PlatnostOd = CONVERT(DATETIME,CONVERT(INT,CONVERT(FLOAT,S.PlatnostOd))),
PlatnostDo = CONVERT(DATETIME,CONVERT(FLOAT,(CONVERT(INT,CONVERT(FLOAT,S.PlatnostDo))))+
CONVERT(FLOAT,(CONVERT(DATETIME,'23:59:59.997'))))
FROM TabSazbyDPH AS S
JOIN INSERTED    AS I ON I.ID = S.ID
IF EXISTS(
SELECT * FROM TabSazbyDPH AS N
JOIN INSERTED AS I ON I.ID = N.ID
WHERE NOT EXISTS(
SELECT * FROM TabDPH AS O WHERE O.Sazba = N.SazbaDPH))
INSERT TabDPH(Sazba, DruhSazbyDPH, Nazev)
SELECT N.SazbaDPH,
CASE N.DruhSazbyDPH
WHEN 0 THEN 0
WHEN 1 THEN 1
WHEN 2 THEN 2
WHEN 3 THEN 3
WHEN 4 THEN 2
WHEN 5 THEN 2
WHEN 6 THEN 2
WHEN 7 THEN 1
WHEN 8 THEN 1 ELSE 1 END,
CASE
WHEN @Legislativa = 1 THEN CASE
WHEN N.DruhSazbyDPH IN(0)       THEN 'Nulová sadzba'
WHEN N.DruhSazbyDPH IN(1,7,8)   THEN 'Základná sadzba'
WHEN N.DruhSazbyDPH IN(2,4,5,6) THEN 'Znížená sadzba'
WHEN N.DruhSazbyDPH IN(3)       THEN 'Jednotná sadzba'
ELSE '' END
WHEN @Legislativa IN(2,5) THEN CASE
WHEN N.DruhSazbyDPH IN(0)       THEN 'Nullsatz'
WHEN N.DruhSazbyDPH IN(1,7,8)   THEN 'Normaler Steuersatz'
WHEN N.DruhSazbyDPH IN(2,4,5,6) THEN 'Ermäßigter Steuersatz'
WHEN N.DruhSazbyDPH IN(3)       THEN ''
ELSE '' END
WHEN @Legislativa = 4 THEN CASE
WHEN N.DruhSazbyDPH IN(0)       THEN 'Zerowa stawka VAT'
WHEN N.DruhSazbyDPH IN(1,7,8)   THEN 'Standardowa stawka VAT'
WHEN N.DruhSazbyDPH IN(2,4,5,6) THEN 'Obnizona stawka VAT'
WHEN N.DruhSazbyDPH IN(3)       THEN ''
ELSE '' END
ELSE CASE        WHEN N.DruhSazbyDPH IN(0)       THEN 'Nulová sazba'
WHEN N.DruhSazbyDPH IN(1,7,8)   THEN 'Základní sazba'
WHEN N.DruhSazbyDPH IN(2,4,5,6) THEN 'Snížená sazba'
WHEN N.DruhSazbyDPH IN(3)       THEN 'Jednotná sazba'
ELSE '' END END
FROM TabSazbyDPH AS N
JOIN INSERTED AS I ON I.ID = N.ID
WHERE NOT EXISTS(
SELECT * FROM TabDPH AS O WHERE O.Sazba = N.SazbaDPH)
GROUP BY N.SazbaDPH, N.DruhSazbyDPH
END
DECLARE @StockMasterDataCard NVARCHAR(255)
SET @StockMasterDataCard = N'd1a4b801-374a-4064-a347-d8ec7455cabe'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @StockMasterDataCard AND DataDirection IN(0,2))
BEGIN
  IF UPDATE(DruhSazbyDPH) OR UPDATE(PlatnostOd) OR UPDATE(PlatnostDo) OR
     UPDATE(ISOKodZeme) OR UPDATE(SazbaDPH)
  BEGIN
    INSERT INTO TabZmenySazebDPHAVA(DruhSazbyDPH, ISOKodZeme, IDSazbyDPHZbo,
      IDKmenZbozi, ActionType, AVAReferenceID)
      SELECT i.DruhSazbyDPH, i.ISOKodZeme, i.ID,
        i.IDKmenZbozi, N'U', kz.AVAReferenceID
      FROM TabAVARegisteredModels m,
         (SELECT sdz.DruhSazbyDPH, sdz.ISOKodZeme, sdz.ID, sdz.IDKmenZbozi
          FROM INSERTED i JOIN TabSazbyDPHZbo sdz
          ON I.DruhSazbyDPH = sdz.DruhSazbyDPH AND I.ISOKodZeme = sdz.ISOKodZeme
          GROUP BY sdz.ID, sdz.IDKmenZbozi, sdz.ISOKodZeme, sdz.DruhSazbyDPH) i
      JOIN TabKmenZbozi kz ON kz.ID = i.IDKmenZbozi
      WHERE m.ModelID = @StockMasterDataCard AND m.DataDirection IN(0,2) AND kz.AVAOutputFlag IN(1,3,4)
      EXCEPT
      SELECT DruhSazbyDPH, ISOKodZeme, IDSazbyDPHZbo,
        IDKmenZbozi, ActionType, AVAReferenceID
      FROM TabZmenySazebDPHAVA t
  END
END
GO
