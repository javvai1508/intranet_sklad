-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_SkladInventura]
@Konst   INT,      -- typ operace: 1=generujpolozky / 2=uzavri / 3=otevri
@ID      INT,      -- ID hlavicky inventury
@IDPol   INT,      -- ID pozadovane skladove karty / NULL=vsechny
@VC      INT = 0,  -- 0=bez VC            / 1=vcetne VC
@MnSklad INT = 0,  -- 0=generovat vsechny / 1=jen s nenulovym mnozstvim skladu
@MnVC    INT = 0,  -- 0=generovat vsechny / 1=jen s nenulovym mnozstvim VC
@MnUmist INT = 0,  -- 0=generovat vsechny / 1=jen s nenulovym mnozstvim umisteni
@DleUmi  INT = 0,  -- 0=bez umisteni      / 1=dle umisteni
@TmpTab  BIT = 0   -- 0=dle IDPol / 1=seznam skladovych karet predan tmp tabulkou
AS
SET NOCOUNT ON
DECLARE @TypInv       INT            -- typ inventury 0=mnozstevni / 1=financni
DECLARE @TypCeny      INT            -- inventurni udaj predvyplnit 0=CC / 1=JC
DECLARE @Predvypln    BIT            -- predvyplnovat inventurni udaj mnozstvi/cenu
DECLARE @Sklad        NVARCHAR(30)   -- cislo skladu
DECLARE @ErrStr       NVARCHAR(2047)
DECLARE @MJEvi        NVARCHAR(10)
DECLARE @MJInv        NVARCHAR(10)
DECLARE @Vztah        NUMERIC(19,6)
DECLARE @Citatel      NUMERIC(19,6)
DECLARE @Jmenovatel   NUMERIC(19,6)
DECLARE @PrepMnozstvi FLOAT
DECLARE @IDKmenZbozi  INT
DECLARE @IDInvItem    INT
SELECT
@TypInv    = TypInv,
@TypCeny   = TypCeny,
@Sklad     = IDSklad,
@Predvypln = MnozPredvypl
FROM TabInvHead WHERE ID = @ID
IF @Konst = 1
BEGIN
IF (SELECT DatumClose FROM TabInvHead WHERE ID = @ID) IS NOT NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(70439, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF @TypInv = 0
BEGIN
SELECT ID INTO #TabInv FROM TabInvItem WHERE IDDoklad = @ID
IF @VC = 0
IF @DleUmi = 0
INSERT TabInvItem(
IDDoklad, IDSklad, IDKmenZbozi, SkupZbo, RegCis, Nazev1,
MnozstviSklad, EvidCenaCelkem, MnozstviInv, MnozstviMJ, MJ)
SELECT
@ID, S.ID, K.ID, K.SkupZbo, K.RegCis, K.Nazev1, S.Mnozstvi, S.StavSkladu,
(CASE WHEN @Predvypln = 1 THEN S.Mnozstvi ELSE 0 END),
(CASE WHEN @Predvypln = 1 THEN S.Mnozstvi ELSE 0 END),
ISNULL(K.MJInventura, K.MJEvidence)
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE S.IDSklad = @Sklad
AND ((@TmpTab = 0 AND ISNULL(@IDPol, S.ID) = S.ID)
OR (@TmpTab = 1 AND EXISTS(SELECT * FROM #TmpOZSezIDInventura WHERE ID = S.ID)))
AND NOT EXISTS(
SELECT * FROM TabInvItem
WHERE IDDoklad = @ID
AND   IDSklad  = S.ID
AND   IDVyrCS    IS NULL
AND   IDUmisteni IS NULL)
AND (@MnSklad = 0 OR S.Mnozstvi > 0)
ELSE
INSERT TabInvItem(
IDDoklad, IDSklad, IDUmisteni, IDKmenZbozi, SkupZbo, RegCis, Nazev1,
MnozstviSklad, EvidCenaCelkem, MnozstviInv, MnozstviMJ, MJ)
SELECT
@ID, I.SID, I.UID, K.ID, K.SkupZbo, K.RegCis, K.Nazev1, I.Mnozstvi, I.Stav,
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
ISNULL(K.MJInventura, K.MJEvidence)
FROM(
SELECT
S.IDKmenZbozi AS KID, S.IDSklad AS Sklad, S.ID AS SID, U.ID AS UID,
S.Mnozstvi AS SMnozstvi,  S.StavSkladu AS Stav, U.MnozstviUmisteni AS Mnozstvi
FROM TabStavSkladu    AS S
JOIN TabVStavUmisteni AS U ON U.IDStav = S.ID
UNION
SELECT
S.IDKmenZbozi, S.IDSklad, S.ID, NULL,
S.Mnozstvi, S.StavSkladu, S.Mnozstvi - ISNULL((
SELECT SUM(U.MnozstviUmisteni)
FROM TabVStavUmisteni AS U WHERE U.IDStav = S.ID), 0)
FROM TabStavSkladu AS S
) AS I
JOIN TabKmenZbozi AS K ON K.ID = I.KID
WHERE I.Sklad = @Sklad
AND ((@TmpTab = 0 AND ISNULL(@IDPol, I.SID) = I.SID)
OR (@TmpTab = 1 AND EXISTS(SELECT * FROM #TmpOZSezIDInventura WHERE ID = I.SID)))
AND NOT EXISTS(
SELECT * FROM TabInvItem
WHERE IDDoklad = @ID AND IDSklad = I.SID
AND IDVyrCS IS NULL
AND ISNULL(IDUmisteni, 0) = ISNULL(I.UID, 0))
AND (@MnSklad = 0 OR I.SMnozstvi > 0)
AND (@MnUmist = 0 OR I.Mnozstvi  > 0)
ELSE
BEGIN
IF @DleUmi = 0
BEGIN
INSERT INTO TabInvItem(
IDDoklad, IDSklad, IDVyrCS, IDKmenZbozi, SkupZbo, RegCis, Nazev1,
MnozstviSklad, EvidCenaCelkem, MnozstviInv, MnozstviMJ, MJ)
SELECT
@ID, I.SID, I.VCID, K.ID, K.SkupZbo, K.RegCis, K.Nazev1, I.Mnozstvi, I.Stav,
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
ISNULL(K.MJInventura, K.MJEvidence)
FROM(
SELECT
S.IDKmenZbozi AS KID, S.IDSklad AS Sklad, S.ID AS SID, V.ID AS VCID,
S.Mnozstvi AS SMnozstvi, S.StavSkladu AS Stav, V.Mnozstvi AS Mnozstvi
FROM TabStavSkladu    AS S
JOIN TabVyrCS         AS V ON V.IDStavSkladu = S.ID
UNION SELECT
S.IDKmenZbozi, S.IDSklad, S.ID, NULL,
S.Mnozstvi, S.StavSkladu AS Stav, S.Mnozstvi - ISNULL((
SELECT SUM(V.Mnozstvi)
FROM TabVyrCS AS V WHERE V.IDStavSkladu = S.ID), 0)
FROM TabStavSkladu AS S
) AS I
JOIN TabKmenZbozi AS K ON K.ID = I.KID
WHERE I.Sklad = @Sklad
AND ((@TmpTab = 0 AND ISNULL(@IDPol, I.SID) = I.SID)
OR (@TmpTab = 1 AND EXISTS(SELECT * FROM #TmpOZSezIDInventura WHERE ID = I.SID)))
AND NOT EXISTS(
SELECT * FROM TabInvItem
WHERE IDDoklad = @ID AND IDSklad = I.SID
AND IDUmisteni IS NULL
AND ISNULL(IDVyrCS, 0) = ISNULL(I.VCID, 0))
AND (@MnSklad = 0 OR I.SMnozstvi > 0)
AND (@MnVC    = 0 OR I.Mnozstvi  > 0)
END ELSE
BEGIN
INSERT INTO TabInvItem(
IDDoklad, IDSklad, IDVyrCS, IDUmisteni, IDKmenZbozi, SkupZbo, RegCis, Nazev1,
MnozstviSklad, EvidCenaCelkem, MnozstviInv, MnozstviMJ, MJ)
SELECT
@ID, I.SID, I.VCID, I.UID, K.ID, K.SkupZbo, K.RegCis, K.Nazev1, I.Mnozstvi, I.Stav,
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
(CASE WHEN @Predvypln = 1 THEN I.Mnozstvi ELSE 0 END),
ISNULL(K.MJInventura, K.MJEvidence)
FROM(
SELECT
S.IDKmenZbozi AS KID, S.IDSklad AS Sklad, S.ID AS SID, V.ID AS VCID, U.ID AS UID,
S.Mnozstvi AS SMnozstvi, S.StavSkladu AS Stav, ISNULL(SUM(UPVC.Mnozstvi), 0) AS Mnozstvi
FROM TabStavSkladu    AS S
JOIN TabVyrCS         AS V ON V.IDStavSkladu = S.ID
JOIN TabVStavUmisteni AS U ON U.IDStav = S.ID
LEFT OUTER JOIN TabUmisteniPrijem AS UP   ON UP.IDUmisteni = U.ID
LEFT OUTER JOIN TabUmistPrijemVC  AS UPVC
ON UPVC.IDUmistPrijem = UP.ID AND UPVC.IDVyrCS = V.ID
WHERE (@MnVC    = 0 OR V.Mnozstvi > 0)
AND   (@MnUmist = 0 OR U.MnozstviUmisteni > 0)
GROUP BY S.IDKmenZbozi, S.IDSklad, S.ID, S.Mnozstvi, S.StavSkladu, V.ID, U.ID
UNION SELECT
S.IDKmenZbozi, S.IDSklad, S.ID,  V.ID, NULL,
S.Mnozstvi, S.StavSkladu, V.Mnozstvi - ISNULL((
SELECT SUM(UPVC.Mnozstvi)
FROM TabUmistPrijemVC  AS UPVC
JOIN TabUmisteniPrijem AS UP ON UP.ID = UPVC.IDUmistPrijem
JOIN TabVStavUmisteni  AS UM ON UM.ID = UP.IDUmisteni AND UM.IDStav = S.ID
WHERE UPVC.IDVyrCS = V.ID), 0)
FROM TabStavSkladu AS S
JOIN TabVyrCS      AS V ON V.IDStavSkladu = S.ID
WHERE @MnVC = 0 OR V.Mnozstvi > 0
UNION SELECT
S.IDKmenZbozi, S.IDSklad, S.ID, NULL, U.ID,
S.Mnozstvi, S.StavSkladu, U.MnozstviUmisteni - ISNULL((
SELECT SUM(UPVC.Mnozstvi)
FROM TabUmistPrijemVC  AS UPVC
JOIN TabUmisteniPrijem AS UP ON UP.ID = UPVC.IDUmistPrijem
JOIN TabVStavUmisteni  AS UM ON UM.ID = UP.IDUmisteni AND UM.IDStav = S.ID
WHERE UM.ID = U.ID), 0)
FROM TabStavSkladu    AS S
JOIN TabVStavUmisteni AS U ON U.IDStav = S.ID
WHERE @MnUmist = 0 OR U.MnozstviUmisteni > 0
UNION SELECT
S.IDKmenZbozi, S.IDSklad, S.ID, NULL, NULL,
S.Mnozstvi, S.StavSkladu, S.Mnozstvi -
(SELECT ISNULL(SUM(Mnozstvi), 0)         FROM TabVyrCS         WHERE IDStavSkladu = S.ID) -
(SELECT ISNULL(SUM(MnozstviUmisteni), 0) FROM TabVStavUmisteni WHERE IDStav       = S.ID) +
(SELECT ISNULL(SUM(XVC.Mnozstvi), 0)
FROM TabUmistPrijemVC  AS XVC
JOIN TabUmisteniPrijem AS XUP ON XUP.ID = XVC.IDUmistPrijem
JOIN TabVStavUmisteni  AS XUS ON XUS.ID = XUP.IDUmisteni
WHERE XUS.IDStav = S.ID)
FROM TabStavSkladu AS S
WHERE (@MnVC = 0 OR (S.Mnozstvi - ISNULL((
SELECT SUM(Mnozstvi) FROM TabVyrCS WHERE IDStavSkladu = S.ID), 0) > 0))
AND (@MnUmist = 0 OR (S.Mnozstvi - ISNULL((
SELECT SUM(MnozstviUmisteni) FROM TabVStavUmisteni WHERE IDStav = S.ID), 0) > 0))
) AS I
JOIN TabKmenZbozi AS K ON K.ID = I.KID
WHERE I.Sklad = @Sklad
AND ((@TmpTab = 0 AND ISNULL(@IDPol, I.SID) = I.SID)
OR (@TmpTab = 1 AND EXISTS(SELECT * FROM #TmpOZSezIDInventura WHERE ID = I.SID)))
AND NOT EXISTS(
SELECT * FROM TabInvItem
WHERE IDDoklad = @ID AND IDSklad = I.SID
AND ISNULL(IDUmisteni,0) = ISNULL(I.UID, 0)
AND ISNULL(IDVyrCS,   0) = ISNULL(I.VCID, 0))
AND (@MnSklad = 0 OR I.SMnozstvi > 0)
END
END
DECLARE c CURSOR FAST_FORWARD LOCAL FOR
SELECT I.ID, K.MJEvidence, K.MJInventura, K.ID
FROM TabInvItem   AS I
JOIN TabKmenZbozi AS K ON K.ID = I.IDKmenZbozi
WHERE I.IDDoklad = @ID
AND NOT EXISTS (SELECT * FROM #TabInv WHERE ID = I.ID)
ORDER BY I.IDSklad
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c INTO @IDInvItem, @MJEvi, @MJInv, @IDKmenZbozi
IF @@FETCH_STATUS <> 0 BREAK
IF @MJInv IS NOT NULL AND
@MJEvi IS NOT NULL AND
@MJEvi <> @MJInv
BEGIN
SET @PrepMnozstvi = 1
EXEC dbo.hp_ZjistiVztahMJ @MJEvi, @MJInv,
NULL, NULL, @IDKmenZbozi, 0, @Citatel OUT, @Jmenovatel OUT
IF @Citatel IS NOT NULL
BEGIN
SET @PrepMnozstvi = @Citatel / @Jmenovatel
IF ABS(@PrepMnozstvi) < 1E-12 SET @PrepMnozstvi = 1
UPDATE TabInvItem
SET MnozstviMJ   = MnozstviInv * @Jmenovatel / @Citatel,
PrepMnozstvi = @PrepMnozstvi
WHERE ID = @IDInvItem
END
END
END
CLOSE c
DEALLOCATE c
DROP TABLE #TabInv
END ELSE
BEGIN
INSERT INTO TabInvItem(
IDDoklad, IDVyrCS, IDSklad, MnozstviSklad, EvidCenaCelkem, Uzav,
IDKmenZbozi, SkupZbo, RegCis, Nazev1, CenaInvCelkem, CenaInvJC)
SELECT DISTINCT
@ID,
CASE @VC WHEN 0 THEN NULL         ELSE V.ID END, S.ID,
CASE @VC WHEN 0 THEN S.Mnozstvi   ELSE V.Mnozstvi END,
CASE @VC WHEN 0 THEN S.StavSkladu ELSE V.FinStav  END,
0, K.ID, K.SkupZbo, K.RegCis, K.Nazev1,
CASE WHEN @PredVypln = 0 THEN 0 ELSE
CASE WHEN @TypCeny   = 1 THEN 0 ELSE
CASE WHEN @VC        = 0 THEN S.StavSkladu ELSE V.FinStav END END END,
CASE WHEN @PredVypln = 0 THEN 0 ELSE
CASE WHEN @TypCeny   = 0 THEN 0 ELSE
CASE WHEN @VC        = 0 THEN
CASE S.Mnozstvi WHEN 0 THEN 0 ELSE S.StavSkladu / S.Mnozstvi END ELSE
CASE V.Mnozstvi WHEN 0 THEN 0 ELSE V.FinStav / V.Mnozstvi END END END END
FROM TabStavSkladu AS S
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
LEFT OUTER JOIN TabVyrCS AS V ON V.IDStavSkladu = S.ID
WHERE S.IDSklad = @Sklad
AND ((@TmpTab = 0 AND ISNULL(@IDPol, S.ID) = S.ID)
OR (@TmpTab = 1 AND EXISTS(SELECT * FROM #TmpOZSezIDInventura WHERE ID = S.ID)))
AND S.ID NOT IN(SELECT DISTINCT IDSklad FROM TabInvItem WHERE IDDoklad = @ID)
AND (@MnSklad = 0 OR S.Mnozstvi > 0)
AND (@VC      = 0 OR V.Mnozstvi > 0)
END
UPDATE TabInvHead SET DatumGenerovani = GetDate() WHERE ID = @ID
END
IF @Konst = 2
BEGIN
IF (SELECT DatumSchvaleni FROM TabInvHead WHERE ID = @ID) IS NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(70440, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF (SELECT DokladPrijem FROM TabInvHead WHERE ID = @ID) IS NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(70441, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF (SELECT DokladVydej FROM TabInvHead WHERE ID = @ID) IS NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(70442, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF (SELECT DatumClose FROM TabInvHead WHERE ID = @ID) IS NOT NULL
BEGIN
SET @ErrStr = dbo.hf_FormatError(70439, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
UPDATE TabInvHead SET DatumClose = GetDate() WHERE ID = @ID
UPDATE TabInvItem SET Uzav = 1 WHERE IDDoklad = @ID
END
IF @Konst = 3
BEGIN
IF ((SELECT LEN(DokladPrijem) FROM TabInvHead WHERE ID = @ID) > 3) OR
((SELECT LEN(DokladVydej)  FROM TabInvHead WHERE ID = @ID) > 3)
BEGIN
SET @ErrStr = dbo.hf_FormatError(70443, '')
RAISERROR(@ErrStr, 16, 1)
RETURN
END
UPDATE TabInvHead SET DatumClose = NULL WHERE ID = @ID
END
GO
