-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_TabVyrCP]
ON [dbo].[TabVyrCP] FOR UPDATE, INSERT, DELETE
AS
SET NOCOUNT ON
DECLARE @DruhPohybu      INT         -- druh pohybu zbozi
DECLARE @IDPohyb         INT         -- ID pohybu zbozi
DECLARE @IDVyrCP         INT         -- ID pohybu VC
DECLARE @IDVyrCS         INT         -- ID stavu vyrobnich cisel
DECLARE @IDVyrCSSrc      INT         -- ID stavu VC src polozky, muze se lisit, pokud cisla skladu neprenaset
DECLARE @IDZboSklad      INT         -- ID skladove karty
DECLARE @IDZboSkladSrc   INT         -- ID sklad. karty src polozky, muze se lisit, pokud cisla skladu neprenaset
DECLARE @IDUmisteni      INT         -- ID umisteni na pohybu VC
DECLARE @IDOldPolozka    INT         -- ID sousedni zdrojove polozky
DECLARE @IDPohybSrc      INT         -- ID zdrojove rezervacni polozky VObj, EP, Rez
DECLARE @IDVyrCPSrc      INT         -- ID zdrojoveho pohybu VC
DECLARE @Blokovat        BIT         -- blokovat prekroceni nehlidaneho mnozstvi
DECLARE @BlokovatSrc     BIT         -- blokovat prekroceni nehlidaneho mnozstvi - na zdrojovem skladu
DECLARE @ChciKontrolu    BIT         -- hnulo se hlidane mnozstvi, chceme kontrolu dostatecnosti
DECLARE @Splneno         BIT         -- priznak splneno na aktualni hlavicce
DECLARE @SplnenoPol      BIT         -- priznak splneno na aktualni polozce
DECLARE @SplnenoSrc      BIT         -- priznak splneno na hlavicce zdrojoveho dokladu
DECLARE @PocStornoMnOdeb BIT         -- zapocti storno do odebraneho mnozstvi dle dokladu
DECLARE @PocStoHGlob     BIT         -- zapocitavat stornodoklady dle HGlob
DECLARE @MetodaEvidCeny  TINYINT       -- metoda stanoveni evidencni ceny dle HGlob
DECLARE @Mnozstvi        NUMERIC(19,6) -- mnozstvi pro sekci umisteni
DECLARE @MnozVCS         NUMERIC(19,6) -- dosavadni mnozstvi na stavu VC - zobrazit v blokacni hlasce
DECLARE @MnozHlid        NUMERIC(19,6) -- dosavadni hlidane mnozstvi VCS - zobrazit v blokacni hlasce
DECLARE @MnozIns         NUMERIC(19,6) -- mnozstvi dle Inserted
DECLARE @MnozDel         NUMERIC(19,6) -- mnozstvi dle Deleted
DECLARE @MnozOdebIns     NUMERIC(19,6) -- mnozstvi odebrane dle Inserted
DECLARE @MnozOdebDel     NUMERIC(19,6) -- mnozstvi odebrane dle Deleted
DECLARE @OdebranoIns     NUMERIC(19,6) -- mnozstvi odebrane dle Inserted
DECLARE @OdebranoDel     NUMERIC(19,6) -- mnozstvi odebrane dle Deleted
DECLARE @MnozNeOdebDif   NUMERIC(19,6) -- zmena neodebraneho mnozstvi
DECLARE @MnozVCOdeOld    NUMERIC(19,6) -- odebrane mnozstvi na zdrojovem pohybu VC - puvodni
DECLARE @MnozVCOdeNew    NUMERIC(19,6) -- odebrane mnozstvi na zdrojovem pohybu VC - nove
DECLARE @SrcVztah        FLOAT         -- hodnota PrepMnozstvi zdrojove polozky VObj, Rez, EP
DECLARE @SrcSmer         INT           -- pro storna pouzijeme opacne znamenko smer
DECLARE @SignVObjEPRez   INT           -- znamenko smeru hlidani mnozstvi VC na rezervacnim dokladu VObj/EP/Rez
DECLARE @TypOperace      INT           -- Update=0, Insert=1, Delete=-1
DECLARE @SkupZbo         NVARCHAR(255)
DECLARE @RegCis          NVARCHAR(255)
DECLARE @Nazev           NVARCHAR(255)
DECLARE @VyrCis          NVARCHAR(255)
DECLARE @RadaDokladu     NVARCHAR(3)
DECLARE @MnozErr         NUMERIC(19,6)
DECLARE @PorCis          INT            -- poradove cislo dokladu v rade
DECLARE @Poradi          INT            -- poradove cislo polozky na dokladu
DECLARE @ErrStr          NVARCHAR(2000) -- text chyby
DECLARE @TmpCreateDelete BIT = 0
DECLARE @zvcMnozstviDleKoeficientu  NUMERIC(19,6)
DECLARE @zvcMJ                      NVARCHAR(10)
DECLARE @zvcMJEvid                  NVARCHAR(10)
DECLARE @zvcIDKmenZbozi             INT
DECLARE @zvcID                      INT
DECLARE @zvcIDVydejeZBlokace        INT
DECLARE @zvcMnozstviBlokovaneEvidMJ NUMERIC(19,6)
DECLARE @zvcMnozstviZmenene         NUMERIC(19,6)
DECLARE @zvcMnozstviZmeneneEvidMJ   NUMERIC(19,6)
DECLARE @CelkemBlokovaneMnozstvi    NUMERIC(19,6)
DECLARE @SumaBlokaciVC              NUMERIC(19,6)
DECLARE @zvcIDZajistKry             INT
DECLARE @cUpravZajID                INT
DECLARE @cUpravZajMnozstviEvid      NUMERIC(19,6)
DECLARE @cIDPolozkaDokladu          INT
DECLARE @cMnozstviKryteEvid         NUMERIC(19,6)
DECLARE @cMnozstviKryteEvidVC       NUMERIC(19,6)
DECLARE @cIDZboSklad                INT
DECLARE @cIDZajistKryX              INT
DECLARE @MnozstviNaVCPredEditaci    NUMERIC(19,6)
DECLARE @MnozstviNaVCPoEditaci      NUMERIC(19,6)
IF EXISTS (SELECT * FROM INSERTED)
IF EXISTS (SELECT * FROM DELETED)
SET @TypOperace =  0 ELSE
SET @TypOperace =  1 ELSE
SET @TypOperace = -1
SELECT
@PocStoHGlob = OZZapoctiStornoDoOdebMnoz,
@MetodaEvidCeny = MetodaEvidCeny
FROM TabHGlob
IF OBJECT_ID(N'tempdb..#TmpZrusStornoDokl') IS NULL
BEGIN
SET @TmpCreateDelete = 1
CREATE TABLE #TmpZrusStornoDokl(ID INT)
END
IF @TypOperace = -1
BEGIN
IF EXISTS(SELECT *
FROM Deleted         AS VC
JOIN TabPohybyZbozi  AS P ON P.ID = VC.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL)
AND NOT EXISTS(SELECT * FROM #TmpZrusStornoDokl WHERE ID = D.ID))
BEGIN
SELECT TOP 1
@RadaDokladu = D.RadaDokladu,
@PorCis      = D.PoradoveCislo,
@DruhPohybu  = D.DruhPohybuZbo,
@Poradi      = P.Poradi
FROM Deleted         AS VC
JOIN TabPohybyZbozi  AS P ON P.ID = VC.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL)
ROLLBACK
SET @ErrStr = N'72153'+NCHAR(13)+
@RadaDokladu+NCHAR(13)+
CAST(@PorCis AS NVARCHAR)+NCHAR(13)+
CAST(@Poradi AS NVARCHAR)+NCHAR(13)+
CAST(@DruhPohybu AS NVARCHAR)
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @TypOperace = 1
BEGIN
IF EXISTS(SELECT *
FROM Inserted        AS VC
JOIN TabPohybyZbozi  AS P ON P.ID = VC.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL))
BEGIN
SELECT TOP 1
@RadaDokladu = D.RadaDokladu,
@PorCis      = D.PoradoveCislo,
@DruhPohybu  = D.DruhPohybuZbo,
@Poradi      = P.Poradi
FROM Inserted        AS VC
JOIN TabPohybyZbozi  AS P ON P.ID = VC.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL)
ROLLBACK
SET @ErrStr = N'72154'+NCHAR(13)+
@RadaDokladu+NCHAR(13)+
CAST(@PorCis AS NVARCHAR)+NCHAR(13)+
CAST(@Poradi AS NVARCHAR)+NCHAR(13)+
CAST(@DruhPohybu AS NVARCHAR)
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF EXISTS(SELECT *
FROM Inserted       AS VCP
JOIN TabVyrCS       AS VCS ON VCS.ID = VCP.IDVyrCis
JOIN TabPohybyZbozi AS P   ON P.ID = VCP.IDPolozkaDokladu
WHERE VCS.IDStavSkladu <> P.IDZboSklad)
BEGIN
SELECT TOP 1
@RadaDokladu = D.RadaDokladu,
@PorCis      = D.PoradoveCislo,
@DruhPohybu  = D.DruhPohybuZbo,
@Poradi      = P.Poradi
FROM Inserted        AS VCP
JOIN TabVyrCS        AS VCS ON VCS.ID = VCP.IDVyrCis
JOIN TabPohybyZbozi  AS P   ON P.ID = VCP.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D   ON D.ID = P.IDDoklad
WHERE VCS.IDStavSkladu <> P.IDZboSklad
ROLLBACK
SET @ErrStr = N'72216'+NCHAR(13)+
@RadaDokladu+NCHAR(13)+
CAST(@PorCis AS NVARCHAR)+NCHAR(13)+
CAST(@Poradi AS NVARCHAR)+NCHAR(13)+
CAST(@DruhPohybu AS NVARCHAR)
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @TypOperace = 0
BEGIN
IF (UPDATE(Mnozstvi) OR
UPDATE(MnozstviReal))
AND EXISTS(SELECT *
FROM Inserted        AS VCI
JOIN Deleted         AS VCD ON VCD.ID = VCI.ID
JOIN TabPohybyZbozi  AS P ON P.ID = VCI.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL)
AND (VCI.Mnozstvi     <> VCD.Mnozstvi OR
VCI.MnozstviReal <> VCD.MnozstviReal))
BEGIN
SELECT TOP 1
@RadaDokladu = D.RadaDokladu,
@PorCis      = D.PoradoveCislo,
@DruhPohybu  = D.DruhPohybuZbo,
@Poradi      = P.Poradi
FROM Inserted        AS VCI
JOIN Deleted         AS VCD ON VCD.ID = VCI.ID
JOIN TabPohybyZbozi  AS P ON P.ID = VCI.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
WHERE D.DruhPohybuZbo < 5
AND  (D.DatRealizace IS NOT NULL OR
D.DatRealMnoz  IS NOT NULL)
AND (VCI.Mnozstvi     <> VCD.Mnozstvi OR
VCI.MnozstviReal <> VCD.MnozstviReal)
ROLLBACK
SET @ErrStr = N'72155'+NCHAR(13)+
@RadaDokladu+NCHAR(13)+
CAST(@PorCis AS NVARCHAR)+NCHAR(13)+
CAST(@Poradi AS NVARCHAR)+NCHAR(13)+
CAST(@DruhPohybu AS NVARCHAR)
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
IF @TypOperace = 0 OR @TypOperace = 1
BEGIN
IF UPDATE(Mnozstvi) AND EXISTS(SELECT * FROM TabHGlob WHERE OZVCTestMnoz = 1)
BEGIN
SELECT TOP 1
@RadaDokladu = D.RadaDokladu,
@PorCis      = D.PoradoveCislo,
@DruhPohybu  = D.DruhPohybuZbo,
@Poradi      = P.Poradi,
@VyrCis      = VCS.Nazev1,
@MnozErr     = VCP.Mnozstvi
FROM INSERTED        AS I
JOIN TabVyrCP        AS VCP ON VCP.ID = I.ID
JOIN TabVyrCS        AS VCS ON VCS.ID = VCP.IDVyrCis
JOIN TabPohybyZbozi  AS P ON P.ID = VCP.IDPolozkaDokladu
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
JOIN TabStavSkladu   AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi    AS K ON K.ID = S.IDKmenZbozi
WHERE K.VCSarze = 2
AND (D.DruhPohybuZbo = 0 OR
D.DruhPohybuZbo = 3)
AND VCP.Mnozstvi <> 0
AND VCP.Mnozstvi <> 1
AND NOT EXISTS(
SELECT *
FROM TabInvHead AS H
WHERE H.IDPrijem = D.ID
OR    H.IDVydej  = D.ID)
IF @@ROWCOUNT <> 0
BEGIN
ROLLBACK
SET @ErrStr = N'72511'+NCHAR(13)+
@RadaDokladu+NCHAR(13)+
CAST(@PorCis AS NVARCHAR)+NCHAR(13)+
CAST(@Poradi AS NVARCHAR)+NCHAR(13)+
CAST(@DruhPohybu AS NVARCHAR)+NCHAR(13)+
@VyrCis+NCHAR(13)+
CAST(@MnozErr AS NVARCHAR)
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
END
IF UPDATE(Mnozstvi) OR UPDATE(MnozOdebrane)
BEGIN
IF EXISTS(
SELECT * FROM TabVyrCP AS V
JOIN INSERTED AS I ON V.ID = I.ID
JOIN TabPohybyZbozi AS P ON P.ID = I.IDPolozkaDokladu
WHERE P.DruhPohybuZbo IN (9,10))
UPDATE V SET Odebrano =
CASE WHEN V.MnozOdebrane < V.Mnozstvi
THEN V.MnozOdebrane ELSE V.Mnozstvi END
FROM INSERTED AS I
JOIN TabPohybyZbozi AS P ON P.ID = I.IDPolozkaDokladu
JOIN TabVyrCP AS V ON V.ID = I.ID
WHERE P.DruhPohybuZbo IN (9,10)
END
DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
SELECT X.ID, X.IDVyrCis, X.IDPolozkaDokladu,
P.IDZboSklad, P.DruhPohybuZbo, P.IDOldPolozka, H.Splneno, P.SplnenoPol,
ISNULL(E.ZapoctiStornoDoOdebMnoz, @PocStoHGlob),
CASE WHEN (K.KontrolaVyrC = N'B' AND S.KontrolaVC   = N'C') OR
(S.KontrolaVC   = N'B') THEN 1 ELSE 0 END,
ISNULL(I.Mnozstvi     * P.PrepMnozstvi, 0),
ISNULL(D.Mnozstvi     * P.PrepMnozstvi, 0),
ISNULL(I.MnozOdebrane * P.PrepMnozstvi, 0),
ISNULL(D.MnozOdebrane * P.PrepMnozstvi, 0),
ISNULL(I.Odebrano     * P.PrepMnozstvi, 0),
ISNULL(D.Odebrano     * P.PrepMnozstvi, 0)
FROM(
SELECT ID, IDVyrCis, IDPolozkaDokladu FROM INSERTED
UNION
SELECT ID, IDVyrCis, IDPolozkaDokladu FROM DELETED) AS X
LEFT OUTER JOIN INSERTED AS I ON I.ID = X.ID
LEFT OUTER JOIN DELETED  AS D ON D.ID = X.ID
JOIN TabPohybyZbozi      AS P ON P.ID = X.IDPolozkaDokladu
JOIN TabDokladyZbozi     AS H ON H.ID = P.IDDoklad
LEFT OUTER JOIN TabDokZboDodatek AS E ON E.IDHlavicky = H.ID
JOIN TabStavSkladu       AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi        AS K ON K.ID = S.IDKmenZbozi AND K.DruhSkladu <> 0
JOIN TabStrom            AS T ON T.Cislo = S.IDSklad  AND T.DruhSkladu <> 0
WHERE P.DruhPohybuZbo IN(0,1,2,3,4,6,9,10,24,25,26,27)
AND NOT(P.DruhPohybuZbo IN(0,1,2,3,4) AND H.DatRealizace IS NOT NULL)
AND H.PoradoveCislo >= 0
ORDER BY X.IDVyrCis
OPEN Cur
WHILE 1=1
BEGIN
FETCH NEXT FROM Cur
INTO @IDVyrCP, @IDVyrCS, @IDPohyb, @IDZboSklad,
@DruhPohybu, @IDOldPolozka, @Splneno, @SplnenoPol, @PocStornoMnOdeb,
@Blokovat, @MnozIns, @MnozDel, @MnozOdebIns, @MnozOdebDel, @OdebranoIns, @OdebranoDel
IF @@FETCH_STATUS<>0 BREAK
SET @MnozVCOdeOld  = 0
SET @MnozVCOdeNew  = 0
SET @SrcVztah      = 1
SET @SignVObjEPRez = 1
SET @BlokovatSrc   = @Blokovat
IF @DruhPohybu IN(9,10)
BEGIN
SET @OdebranoIns = CASE WHEN @MnozOdebIns <= @MnozIns
THEN @MnozOdebIns ELSE @MnozIns END
SET @OdebranoDel = CASE WHEN @MnozOdebDel <= @MnozDel
THEN @MnozOdebDel ELSE @MnozDel END
END
SELECT
@MnozVCS  = Mnozstvi,
@MnozHlid = MnozstviHlidano
FROM TabVyrCS
WHERE ID = @IDVyrCS
IF @Splneno = 0 AND @DruhPohybu = 6 AND
@SplnenoPol = 0 AND
ABS((@MnozIns - @MnozOdebIns) -
(@MnozDel - @MnozOdebDel)) > 0
BEGIN
UPDATE TabVyrCS
SET Objednano = Objednano + (@MnozIns - @MnozOdebIns) - (@MnozDel - @MnozOdebDel)
WHERE ID = @IDVyrCS
END
IF @Splneno = 0 AND @DruhPohybu IN(9,10) AND
@SplnenoPol = 0 AND
ABS((@MnozIns - @OdebranoIns) -
(@MnozDel - @OdebranoDel)) > 0
BEGIN
UPDATE TabVyrCS
SET MnozstviDispo = MnozstviDispo + (@MnozDel - @OdebranoDel) - (@MnozIns - @OdebranoIns)
WHERE ID = @IDVyrCS
END
IF @DruhPohybu IN(0,3,24,27) AND
ABS(@MnozIns - @MnozDel) > 0
BEGIN
UPDATE TabVyrCS
SET MnozstviKPrijmu = ROUND(MnozstviKPrijmu + @MnozIns - @MnozDel, 4)
WHERE ID = @IDVyrCS
END
IF @DruhPohybu IN(1,2,4,26,25) AND
ABS(@MnozIns - @MnozDel) > 0
BEGIN
UPDATE TabVyrCS
SET MnozstviKVydeji = ROUND(MnozstviKVydeji + @MnozIns - @MnozDel, 4)
WHERE ID = @IDVyrCS
END
SET @IDVyrCSSrc = @IDVyrCS
IF @DruhPohybu IN (0,1,2,3,4) AND @IDOldPolozka IS NOT NULL AND
(@PocStornoMnOdeb = 1 OR @DruhPohybu IN(0,2,4))
BEGIN
EXEC dbo.hp_OZGetSrcVObjEPRez
@IDOldPolozka, @DruhPohybu, @IDPohybSrc OUT
IF @IDPohybSrc IS NOT NULL
BEGIN
SELECT
@SrcVztah      = P.PrepMnozstvi,
@SignVObjEPRez = CASE WHEN D.DruhPohybuZbo = 6 THEN 0 ELSE 1 END,
@IDZboSkladSrc = P.IDZboSklad,
@SplnenoSrc    = D.Splneno,
@SrcSmer       = CASE WHEN @DruhPohybu IN(0,2,4) THEN 1 ELSE -1 END,
@BlokovatSrc   = CASE WHEN (K.KontrolaVyrC = N'B' AND S.KontrolaVC   = N'C') OR
(S.KontrolaVC   = N'B') THEN 1 ELSE 0 END
FROM TabPohybyZbozi  AS P
JOIN TabDokladyZbozi AS D ON D.ID = P.IDDoklad
JOIN TabStavSkladu   AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi    AS K ON K.ID = S.IDKmenZbozi
WHERE P.ID = @IDPohybSrc
IF ABS(@SrcVztah) < 1E-12 SET @SrcVztah = 1
EXEC dbo.hp_Najdi_IDVyrCS
@IDZboSklad, @IDZboSkladSrc, @IDVyrCSSrc OUT, 0
SET @IDVyrCPSrc = NULL
SELECT
@IDVyrCPSrc = V.ID
FROM TabVyrCP AS V
JOIN TabPohybyZbozi AS P ON P.ID = V.IDPolozkaDokladu
WHERE P.ID = @IDPohybSrc
AND V.IDVyrCis = @IDVyrCSSrc
IF @IDVyrCPSrc IS NOT NULL
BEGIN
SELECT @MnozVCOdeOld = Odebrano FROM TabVyrCP WHERE ID = @IDVyrCPSrc
UPDATE TabVyrCP
SET MnozOdebrane = MnozOdebrane + @SrcSmer * (@MnozIns - @MnozDel) / @SrcVztah
WHERE ID = @IDVyrCPSrc
UPDATE TabVyrCP
SET Odebrano = CASE WHEN MnozOdebrane <= Mnozstvi
THEN MnozOdebrane ELSE Mnozstvi END
WHERE ID = @IDVyrCPSrc
SELECT @MnozVCOdeNew = Odebrano FROM TabVyrCP WHERE ID = @IDVyrCPSrc
IF @SplnenoSrc = 0
BEGIN
IF @DruhPohybu IN(2,3,4)
UPDATE TabVyrCS
SET MnozstviDispo = MnozstviDispo + (@MnozVCOdeNew - @MnozVCOdeOld) * @SrcVztah
WHERE ID = @IDVyrCSSrc
IF @DruhPohybu IN(0,1)
UPDATE TabVyrCS
SET Objednano = Objednano - (@MnozVCOdeNew - @MnozVCOdeOld) * @SrcVztah
WHERE ID = @IDVyrCSSrc
END
END
END
END
IF @DruhPohybu IN (1,2,4,9,10)
BEGIN
IF @DruhPohybu IN (0,3)   SET @MnozNeOdebDif = @MnozDel - @MnozIns ELSE
IF @DruhPohybu IN (1,2,4) SET @MnozNeOdebDif = @MnozIns - @MnozDel ELSE
IF @DruhPohybu IN (9,10)  SET @MnozNeOdebDif = (@MnozIns - @OdebranoIns) -
(@MnozDel - @OdebranoDel)
SET @ChciKontrolu = 0
IF @IDVyrCSSrc = @IDVyrCS
BEGIN
SET @BlokovatSrc = 0
IF ABS(@MnozNeOdebDif - (@MnozVCOdeNew - @MnozVCOdeOld) * @SrcVztah * @SignVObjEPRez) > 0
BEGIN
SET @ChciKontrolu = 1
UPDATE TabVyrCS
SET MnozstviHlidano = MnozstviHlidano +
@MnozNeOdebDif - (@MnozVCOdeNew - @MnozVCOdeOld) * @SrcVztah * @SignVObjEPRez
WHERE ID = @IDVyrCS
END
END ELSE
BEGIN
IF @MnozVCOdeNew <> @MnozVCOdeOld
BEGIN
SET @ChciKontrolu = 1
UPDATE TabVyrCS
SET MnozstviHlidano = MnozstviHlidano - (@MnozVCOdeNew - @MnozVCOdeOld) * @SrcVztah * @SignVObjEPRez
WHERE ID = @IDVyrCSSrc
END
IF @MnozNeOdebDif <> 0 OR @MnozVCOdeNew <> @MnozVCOdeOld
BEGIN
SET @ChciKontrolu = 1
UPDATE TabVyrCS
SET MnozstviHlidano = MnozstviHlidano + @MnozNeOdebDif
WHERE ID = @IDVyrCS
END
END
IF @ChciKontrolu = 1
AND OBJECT_ID(N'tempdb..#TmpVCAktOdebMnoz') IS NULL
BEGIN
IF @Blokovat = 1 AND EXISTS(
SELECT * FROM TabVyrCS WHERE ID = @IDVyrCS AND MnozstviHlidano > Mnozstvi)
BEGIN
SELECT
@SkupZbo = K.SkupZbo,
@RegCis  = K.RegCis,
@Nazev   = K.Nazev1,
@VyrCis  = V.Nazev1
FROM TabVyrCS      AS V
JOIN TabStavSkladu AS S ON S.ID = V.IDStavSkladu
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE V.ID = @IDVyrCS
ROLLBACK
SET @ErrStr = N'71429'+NCHAR(13)+@SkupZbo
+NCHAR(13)+@RegCis
+NCHAR(13)+@Nazev
+NCHAR(13)+@VyrCis
+NCHAR(13)+CAST(@MnozVCS  AS NVARCHAR(30))
+NCHAR(13)+CAST(@MnozHlid AS NVARCHAR(30))
+NCHAR(13)+CAST((@MnozVCS - @MnozHlid) AS NVARCHAR(30))
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
IF @BlokovatSrc = 1 AND EXISTS(
SELECT * FROM TabVyrCS WHERE ID = @IDVyrCSSrc AND MnozstviHlidano > Mnozstvi)
BEGIN
SELECT
@SkupZbo = K.SkupZbo,
@RegCis  = K.RegCis,
@Nazev   = K.Nazev1,
@VyrCis  = V.Nazev1
FROM TabVyrCS      AS V
JOIN TabStavSkladu AS S ON S.ID = V.IDStavSkladu
JOIN TabKmenZbozi  AS K ON K.ID = S.IDKmenZbozi
WHERE V.ID = @IDVyrCSSrc
ROLLBACK
SET @ErrStr = N'71429'+NCHAR(13)+@SkupZbo
+NCHAR(13)+@RegCis
+NCHAR(13)+@Nazev
+NCHAR(13)+@VyrCis
+NCHAR(13)+CAST(@MnozVCS  AS NVARCHAR(30))
+NCHAR(13)+CAST(@MnozHlid AS NVARCHAR(30))
+NCHAR(13)+CAST((@MnozVCS - @MnozHlid) AS NVARCHAR(30))
SET @ErrStr = dbo.hf_FormatError(99999, @ErrStr)
RAISERROR(@ErrStr, 16, 1)
RETURN
END
END
END
END
CLOSE Cur
DEALLOCATE Cur
IF @MetodaEvidCeny = 1
BEGIN
UPDATE P
SET CCEvidPozadovana = ISNULL(
(SELECT SUM(VCP.CCEvidPozadovana) FROM TabVyrCP AS VCP WHERE VCP.IDPolozkaDokladu = P.ID), 0)
FROM(
SELECT IDPolozkaDokladu FROM INSERTED
UNION
SELECT IDPolozkaDokladu FROM DELETED) AS X
JOIN TabPohybyZbozi      AS P ON P.ID = X.IDPolozkaDokladu
JOIN TabDokladyZbozi     AS H ON H.ID = P.IDDoklad
JOIN TabStavSkladu       AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi        AS K ON K.ID = S.IDKmenZbozi AND K.DruhSkladu <> 0
JOIN TabStrom            AS T ON T.Cislo = S.IDSklad  AND T.DruhSkladu <> 0
WHERE P.DruhPohybuZbo IN(1,3)
AND H.DatRealizace IS NULL
AND H.PoradoveCislo >= 0
AND S.Metoda IN(5,7,9,11)
END
IF UPDATE(IDUmisteni) OR UPDATE(Mnozstvi)
BEGIN
IF EXISTS(
SELECT * FROM DELETED WHERE IDUmisteni IS NOT NULL)
BEGIN
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
SELECT IDPolozkaDokladu, IDVyrCis, IDUmisteni, Mnozstvi
FROM DELETED WHERE IDUmisteni IS NOT NULL
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c
INTO @IDPohyb, @IDVyrCS, @IDUmisteni, @Mnozstvi
IF @@FETCH_STATUS<>0 BREAK
SELECT @DruhPohybu = DruhPohybuZbo
FROM TabPohybyZbozi WHERE ID = @IDPohyb
IF @DruhPohybu IN (1,2,4,25,26)
SET @Mnozstvi = -@Mnozstvi
ELSE
IF @DruhPohybu NOT IN (0,3,24,27)
SET @Mnozstvi = 0
IF @Mnozstvi <> 0
IF EXISTS(
SELECT * FROM TabUmisteniVyrCS
WHERE IDVyrCS = @IDVyrCS AND IDUmisteni = @IDUmisteni)
UPDATE TabUmisteniVyrCS
SET Mnozstvi = Mnozstvi - @Mnozstvi
WHERE IDVyrCS = @IDVyrCS AND IDUmisteni = @IDUmisteni
END
CLOSE c
DEALLOCATE c
END
IF EXISTS (SELECT * FROM INSERTED WHERE IDUmisteni IS NOT NULL)
BEGIN
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
SELECT IDPolozkaDokladu, IDVyrCis, IDUmisteni, Mnozstvi
FROM INSERTED WHERE IDUmisteni IS NOT NULL
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c INTO @IDPohyb, @IDVyrCS, @IDUmisteni, @Mnozstvi
IF @@FETCH_STATUS<>0 BREAK
SELECT @DruhPohybu = DruhPohybuZbo
FROM TabPohybyZbozi WHERE ID = @IDPohyb
IF @DruhPohybu IN (1,2,4,25,26)
SET @Mnozstvi = -@Mnozstvi
ELSE
IF @DruhPohybu NOT IN (0,3,24,27)
SET @Mnozstvi = 0
IF @Mnozstvi <> 0
IF EXISTS(
SELECT * FROM TabUmisteniVyrCS
WHERE IDVyrCS = @IDVyrCS AND IDUmisteni = @IDUmisteni)
UPDATE TabUmisteniVyrCS
SET Mnozstvi = Mnozstvi + @Mnozstvi
WHERE IDVyrCS = @IDVyrCS AND IDUmisteni = @IDUmisteni
ELSE
INSERT TabUmisteniVyrCS (IDVyrCS, IDUmisteni, Mnozstvi)
VALUES (@IDVyrCS, @IDUmisteni, @Mnozstvi)
END
CLOSE c
DEALLOCATE c
END
IF EXISTS (SELECT * FROM TabUmisteniVyrCS WHERE Mnozstvi = 0)
DELETE TabUmisteniVyrCS WHERE Mnozstvi = 0
END
IF @TypOperace = 1
BEGIN
IF EXISTS(SELECT * FROM INSERTED new
JOIN TabPohybyZbozi p ON p.ID = new.IDPolozkaDokladu
JOIN TabPohybyZbozi old ON old.ID = p.IDOldPolozka
JOIN TabDosleObjNavazDok02 v ON v.IDNavazDok = old.IDDoklad
AND v.DruhPohybuZbo = old.DruhPohybuZbo AND v.IDNavazPol = old.ID)
BEGIN
IF NOT EXISTS(SELECT * FROM INSERTED new
JOIN TabPohybyZbozi p ON p.ID = new.IDPolozkaDokladu
JOIN TabPohybyZbozi old ON old.ID = p.IDOldPolozka
JOIN TabDosleObjNavazDok02 v ON v.IDNavazDok = p.IDDoklad
AND v.DruhPohybuZbo = p.DruhPohybuZbo AND v.IDNavazPol = p.ID
JOIN TabDosleObjNavazVyrCis02 nvc ON nvc.IDDosleObjNavazDok = v.ID
JOIN TabDosleObjVyrCis02 dvc ON dvc.id = nvc.IDDoslaObjVyrCis AND dvc.IDVyrCis = new.IDVyrCis)
BEGIN
INSERT TabDosleObjNavazVyrCis02(
IDDosleObjNavazDok, IDDoslaObjVyrCis, IDOZVyrCP, MnozstviMJObj, MnozstviPohybu)
SELECT
v.ID,  nvc.IDDoslaObjVyrCis, new.ID,
0, (CASE WHEN p.DruhPohybuZbo IN(1,3,14,25,27)
THEN new.VraceneMnozstvi - new.Mnozstvi
ELSE new.Mnozstvi - new.VraceneMnozstvi END)
FROM INSERTED new
JOIN TabPohybyZbozi p ON p.ID = new.IDPolozkaDokladu
JOIN TabPohybyZbozi old ON old.ID = p.IDOldPolozka
JOIN TabDosleObjNavazDok02 v ON v.IDNavazDok = p.IDDoklad
AND v.DruhPohybuZbo = p.DruhPohybuZbo AND v.IDNavazPol = p.ID
JOIN TabDosleObjNavazDok02 vold ON vold.IDNavazDok = old.IDDoklad
AND vold.DruhPohybuZbo = old.DruhPohybuZbo AND vold.IDNavazPol = old.ID
JOIN TabDosleObjNavazVyrCis02 nvc ON nvc.IDDosleObjNavazDok = vold.ID
JOIN TabDosleObjVyrCis02 dvc ON dvc.id = nvc.IDDoslaObjVyrCis AND dvc.IDVyrCis = new.IDVyrCis
END
END
END
IF @TypOperace = 0
BEGIN
IF UPDATE(Mnozstvi) OR UPDATE(VraceneMnozstvi) OR UPDATE(MnozstviReal)
BEGIN
IF EXISTS(SELECT * FROM TabDosleObjNavazVyrCis02 nvc
JOIN TabDosleObjNavazDok02 v ON v.ID = nvc.IDDosleObjNavazDok
JOIN INSERTED i ON i.ID = nvc.IDOZVyrCP
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu AND p.IDDoklad = v.IDNavazDok
AND p.DruhPohybuZbo = v.DruhPohybuZbo AND p.ID = v.IDNavazPol)
BEGIN
UPDATE nvc SET
MnozstviPohybu = (CASE WHEN p.DruhPohybuZbo IN(1,3,14,25,27)
THEN i.VraceneMnozstvi - i.Mnozstvi
ELSE i.Mnozstvi - i.VraceneMnozstvi END)
FROM TabDosleObjNavazVyrCis02 nvc
JOIN TabDosleObjNavazDok02 v ON v.ID = nvc.IDDosleObjNavazDok
JOIN INSERTED i ON i.ID = nvc.IDOZVyrCP
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu AND p.IDDoklad = v.IDNavazDok
AND p.DruhPohybuZbo = v.DruhPohybuZbo AND p.ID = v.IDNavazPol
END
END
END
IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1)
BEGIN
IF UPDATE(Mnozstvi)
BEGIN
DECLARE cDistIDPol CURSOR LOCAL FAST_FORWARD FOR
SELECT DISTINCT i.IDPolozkaDokladu, d.ID, d.MnKryteEvid, ISNULL(d.IDZboSklad, r.IDZboSklad)
FROM INSERTED i
JOIN TabPohybyZbozi prij ON prij.ID = i.IDPolozkaDokladu
JOIN TabPohybyZbozi   vo ON vo.ID = prij.IDOldPolozka AND vo.DruhPohybuZbo = 6
JOIN TabZajistKryX     d ON d.IDPohybu = vo.ID AND d.Zpusob = 2
JOIN TabZajistX        z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabDosleObjR02    r ON r.ID = z.IDDObjR02
WHERE i.BlokovaniEditoru IS NULL
UNION
SELECT DISTINCT i.IDPolozkaDokladu, d.ID, d.MnKryteEvid, ISNULL(d.IDZboSklad, r.IDZboSklad)
FROM INSERTED i
JOIN TabPohybyZbozi prij ON prij.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX dp ON dp.IDPohybu = prij.ID
JOIN TabZajistKryX     d ON d.ID = dp.IDZajistKry AND d.Zpusob = 4
JOIN TabZajistX        z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabDosleObjR02    r ON r.ID = z.IDDObjR02
WHERE i.BlokovaniEditoru IS NULL
OPEN cDistIDPol
WHILE 1=1
BEGIN
FETCH NEXT FROM cDistIDPol
INTO @cIDPolozkaDokladu, @cIDZajistKryX, @cMnozstviKryteEvid, @cIDZboSklad
IF @@FETCH_STATUS<>0 BREAK
SELECT @cMnozstviKryteEvidVC = ISNULL( SUM(vcx.MnKryteEv), 0 )
FROM TabZajistKryX     d
JOIN TabZajistKryVyrCX vcx ON vcx.IDZajistKry = d.ID
WHERE d.ID = @cIDZajistKryX
SELECT @cMnozstviKryteEvidVC = @cMnozstviKryteEvidVC + ISNULL( SUM(vcpx.Mnozstvi), 0 )
FROM TabZajistKryX     d
JOIN TabZajistKryPrijX p ON p.IDZajistKry = d.ID
JOIN TabZajistKryVyrCPrijX vcpx ON vcpx.IDZajistKryPrij = p.ID AND vcpx.IDZajistKryVyrC IS NULL
WHERE d.ID = @cIDZajistKryX
DECLARE cZVC CURSOR LOCAL FAST_FORWARD FOR
SELECT i.ID, p.MJ, k.MJEvidence, k.ID
FROM INSERTED i
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu
JOIN TabStavSkladu  s ON s.ID = p.IDZboSklad
JOIN TabKmenZbozi   k ON k.ID = s.IDKmenZbozi
WHERE p.ID = @cIDPolozkaDokladu
AND p.IDZboSklad = @cIDZboSklad
OPEN cZVC
WHILE 1=1
BEGIN
FETCH NEXT FROM cZVC INTO @zvcID, @zvcMJ, @zvcMJEvid, @zvcIDKmenZbozi
IF @@FETCH_STATUS<>0 BREAK
IF EXISTS(
SELECT * FROM INSERTED i
JOIN TabPohybyZbozi prij ON prij.ID = i.IDPolozkaDokladu
JOIN TabPohybyZbozi   vo ON vo.ID = prij.IDOldPolozka AND vo.DruhPohybuZbo = 6
JOIN TabZajistKryX     d ON d.IDPohybu = vo.ID AND d.Zpusob = 2
JOIN TabZajistX        z ON z.ID = d.IDZajist AND z.JeVC = 1
WHERE i.ID NOT IN(
SELECT vcpx.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryPrijX dp ON dp.ID = vcpx.IDZajistKryPrij AND dp.IDZajistKry = d.ID)
AND i.ID = @zvcID) OR
EXISTS(
SELECT * FROM INSERTED i
JOIN TabPohybyZbozi prij ON prij.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX dp ON dp.IDPohybu = prij.ID
JOIN TabZajistKryX     d ON d.ID = dp.IDZajistKry AND d.Zpusob = 4
JOIN TabZajistX        z ON z.ID = d.IDZajist AND z.JeVC = 1
WHERE i.ID NOT IN(
SELECT vcpx.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryPrijX dp ON dp.ID = vcpx.IDZajistKryPrij AND dp.IDZajistKry = d.ID)
AND i.ID = @zvcID)
BEGIN
SELECT @zvcMnozstviDleKoeficientu = i.Mnozstvi
FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryX       d ON d.ID = dp.IDZajistKry AND d.Zpusob IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE i.ID NOT IN(
SELECT vcpx.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryVyrCX vcx
ON vcx.ID = vcpx.IDZajistKryVyrC AND vcx.IDZajistKry = dp.IDZajistKry)
AND i.ID = @zvcID
IF @zvcMnozstviDleKoeficientu IS NOT NULL
BEGIN
EXEC dbo.hp_PrepoctiDleMJ
@zvcMJ, @zvcMJEvid, @zvcMnozstviDleKoeficientu OUT, 1, 1, @zvcIDKmenZbozi, 0
IF ( @cMnozstviKryteEvid - @cMnozstviKryteEvidVC - @zvcMnozstviDleKoeficientu ) < 0
SET @zvcMnozstviDleKoeficientu = @cMnozstviKryteEvid - @cMnozstviKryteEvidVC
IF @zvcMnozstviDleKoeficientu = 0
BREAK
IF EXISTS(
SELECT *
FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryX       d ON d.ID = dp.IDZajistKry AND d.Zpusob IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE i.ID NOT IN(
SELECT v.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryVyrCX    vcx
ON vcx.ID = vcpx.IDZajistKryVyrC AND vcx.IDZajistKry = dp.IDZajistKry
JOIN TabZajistKryVyrCXVyrCP v ON v.IDZajistKryVyrC = vcx.ID)
AND i.BlokovaniEditoru IS NULL
AND i.ID = @zvcID
AND d.ID = @cIDZajistKryX)
BEGIN
IF NOT EXISTS(
SELECT *
FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryVyrCPrijX vcpx ON vcpx.IDZajistKryPrij = dp.ID
JOIN TabZajistKryX       d ON d.ID = dp.IDZajistKry AND d.Zpusob IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE i.ID NOT IN(
SELECT v.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryVyrCX    vcx
ON vcx.ID = vcpx.IDZajistKryVyrC AND vcx.IDZajistKry = dp.IDZajistKry
JOIN TabZajistKryVyrCXVyrCP v ON v.IDZajistKryVyrC = vcx.ID)
AND i.BlokovaniEditoru IS NULL
AND i.ID = @zvcID
AND d.ID = @cIDZajistKryX)
INSERT TabZajistKryVyrCPrijX (IDZajistKryPrij, IDZajistKryVyrC, IDVyrCP, Mnozstvi )
SELECT dp.ID, NULL, i.ID, @zvcMnozstviDleKoeficientu
FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryX       d ON d.ID = dp.IDZajistKry AND d.Zpusob IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE i.ID NOT IN(
SELECT v.IDVyrCP
FROM TabZajistKryVyrCPrijX vcpx
JOIN TabZajistKryVyrCX     vcx
ON vcx.ID = vcpx.IDZajistKryVyrC AND vcx.IDZajistKry = dp.IDZajistKry
JOIN TabZajistKryVyrCXVyrCP v ON v.IDZajistKryVyrC = vcx.ID )
AND i.BlokovaniEditoru IS NULL
AND i.ID = @zvcID
AND d.ID = @cIDZajistKryX
IF @cMnozstviKryteEvid = @cMnozstviKryteEvidVC
BREAK
END
IF EXISTS(
SELECT * FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryVyrCX dvc ON dvc.IDZajistKry = dp.IDZajistKry AND dvc.IDVyrCS = i.IDVyrCis
JOIN TabZajistKryX       d ON d.ID = dvc.IDZajistKry AND d.Zpusob IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE dvc.ID NOT IN ( SELECT IDZajistKryVyrC FROM TabZajistKryVyrCPrijX WHERE IDVyrCP = i.ID )
AND i.BlokovaniEditoru IS NULL
AND i.ID = @zvcID
AND d.ID = @cIDZajistKryX)
BEGIN
INSERT TabZajistKryVyrCPrijX (IDZajistKryPrij, IDZajistKryVyrC, IDVyrCP, Mnozstvi )
SELECT dp.ID, dvc.ID, i.ID, @zvcMnozstviDleKoeficientu
FROM INSERTED i
JOIN TabPohybyZbozi      p ON p.ID = i.IDPolozkaDokladu
JOIN TabZajistKryPrijX  dp ON dp.IDPohybu = p.ID
JOIN TabZajistKryVyrCX dvc ON dvc.IDZajistKry = dp.IDZajistKry AND dvc.IDVyrCS = i.IDVyrCis
JOIN TabZajistKryX       d ON d.ID = dvc.IDZajistKry AND d.Zpusob  IN (2,4)
JOIN TabZajistX          z ON z.ID = d.IDZajist AND z.JeVC = 1
JOIN TabStavSkladu       s ON s.ID = p.IDZboSklad AND s.IDKmenZbozi = @zvcIDKmenZbozi
WHERE dvc.ID NOT IN ( SELECT IDZajistKryVyrC FROM TabZajistKryVyrCPrijX WHERE IDVyrCP = i.ID )
AND i.BlokovaniEditoru IS NULL
AND i.ID = @zvcID
AND d.ID = @cIDZajistKryX
IF @cMnozstviKryteEvid = @cMnozstviKryteEvidVC
BREAK
END
SET @cMnozstviKryteEvidVC = @cMnozstviKryteEvidVC + @zvcMnozstviDleKoeficientu
END
END
END
CLOSE cZVC
DEALLOCATE cZVC
END
CLOSE cDistIDPol
DEALLOCATE cDistIDPol
END
IF (UPDATE(Mnozstvi) AND
EXISTS(SELECT*FROM INSERTED i
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu AND p.DruhPohybuZbo IN(0,6)
WHERE i.BlokovaniEditoru IS NULL))
OR ( NOT EXISTS(SELECT * FROM INSERTED i
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu AND p.DruhPohybuZbo IN(0,6)
WHERE i.BlokovaniEditoru IS NULL) AND
EXISTS(SELECT * FROM DELETED d
JOIN TabPohybyZbozi p ON p.ID = d.IDPolozkaDokladu AND p.DruhPohybuZbo IN(0,6)
WHERE d.BlokovaniEditoru IS NULL) )
BEGIN
DECLARE cUpravZaj CURSOR FAST_FORWARD LOCAL FOR
SELECT DISTINCT a.ID, a.Mnozstvi
FROM ( SELECT i.ID, i.Mnozstvi * p.PrepMnozstvi AS Mnozstvi
FROM INSERTED i
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu AND p.DruhPohybuZbo IN(0,6)
UNION
SELECT d.ID, NULL
FROM DELETED d
JOIN TabPohybyZbozi p ON p.ID = d.IDPolozkaDokladu AND p.DruhPohybuZbo IN(0,6)
WHERE NOT EXISTS(SELECT*FROM INSERTED i WHERE i.ID = d.ID)
) a
OPEN cUpravZaj
WHILE 1=1
BEGIN
FETCH NEXT FROM cUpravZaj INTO @cUpravZajID, @cUpravZajMnozstviEvid
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_NZB_UpravZajisteniPoZmeneMnozstviVC
@cUpravZajID, DEFAULT, DEFAULT, DEFAULT, @cUpravZajMnozstviEvid
END
CLOSE cUpravZaj
DEALLOCATE cUpravZaj
END
IF UPDATE(Mnozstvi) AND
EXISTS(SELECT vcbx.*
FROM INSERTED i
JOIN TabZajistKryVyrCVydX  vcvx ON vcvx.IDVyrCP = i.ID
JOIN TabZajistKryVyrCXVyrCP   v ON v.ID = vcvx.IDZajistKryVyrCVyrCP
JOIN TabZajistKryVyrCBlokX vcbx
ON vcbx.IDZajistKryVyrC = v.IDZajistKryVyrC AND vcbx.IDVyrCS = i.IDVyrCis
WHERE i.BlokovaniEditoru IS NULL)
BEGIN
DECLARE c CURSOR FAST_FORWARD LOCAL FOR
SELECT vcbx.ID, vcbx.Mnozstvi, i.Mnozstvi, k.MJEvidence, p.MJ, k.ID, vcvx.ID
FROM INSERTED i
JOIN TabZajistKryVyrCVydX  vcvx ON vcvx.IDVyrCP = i.ID
JOIN TabZajistKryVyrCXVyrCP   v ON v.ID = vcvx.IDZajistKryVyrCVyrCP
JOIN TabZajistKryVyrCBlokX vcbx ON vcbx.IDZajistKryVyrC = v.IDZajistKryVyrC AND vcbx.IDVyrCS = i.IDVyrCis
JOIN TabVyrCS                cs ON cs.ID = i.IDVyrCis
JOIN TabStavSkladu            s ON s.ID = cs.IDStavSkladu
JOIN TabKmenZbozi             k ON k.ID = s.IDKmenZbozi
JOIN TabPohybyZbozi           p ON p.ID = i.IDPolozkaDokladu
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c
INTO @zvcID, @zvcMnozstviBlokovaneEvidMJ, @zvcMnozstviZmenene,
@zvcMJEvid, @zvcMJ, @zvcIDKmenZbozi, @zvcIDVydejeZBlokace
IF @@FETCH_STATUS <> 0 BREAK
SET @zvcMnozstviZmeneneEvidMJ = @zvcMnozstviZmenene
EXEC dbo.hp_PrepoctiDleMJ
@zvcMJ, @zvcMJEvid, @zvcMnozstviZmeneneEvidMJ OUT, 1, 1, @zvcIDKmenZbozi, 0
SELECT @CelkemBlokovaneMnozstvi = b.Mnozstvi, @zvcIDZajistKry = vcx.IDZajistKry
FROM TabZajistKryVyrCBlokX vcbx
JOIN TabZajistKryVyrCX vcx ON vcx.ID = vcbx.IDZajistKryVyrC
JOIN TabZajistKryBlokX   b ON b.IDZajistKry = vcx.IDZajistKry
WHERE vcbx.ID = @zvcID
SELECT @SumaBlokaciVC = SUM(Mnozstvi)
FROM TabZajistKryVyrCBlokX vcbx
JOIN TabZajistKryVyrCX vcx
ON vcx.ID = vcbx.IDZajistKryVyrC AND vcx.IDZajistKry = @zvcIDZajistKry
WHERE vcbx.ID <> @zvcID
IF @zvcMnozstviZmeneneEvidMJ > ( @CelkemBlokovaneMnozstvi - @SumaBlokaciVC )
SET @zvcMnozstviZmeneneEvidMJ = @CelkemBlokovaneMnozstvi - @SumaBlokaciVC
UPDATE TabZajistKryVyrCVydX
SET Mnozstvi = @zvcMnozstviZmeneneEvidMJ
WHERE ID = @zvcIDVydejeZBlokace
END
CLOSE c
DEALLOCATE c
END
DECLARE @curIDVyrCis INT
DECLARE curMnozKVyrizeniVC CURSOR FAST_FORWARD LOCAL FOR
SELECT DISTINCT a.IDVyrCis
FROM ( SELECT IDVyrCis FROM INSERTED
UNION
SELECT IDVyrCis FROM DELETED
) a
OPEN curMnozKVyrizeniVC
WHILE 1=1
BEGIN
FETCH NEXT FROM curMnozKVyrizeniVC INTO @curIDVyrCis
IF @@FETCH_STATUS <> 0 BREAK
EXEC dbo.hp_NZB_AktualizujMnozKVyrizeniVC 0, @curIDVyrCis
END
CLOSE curMnozKVyrizeniVC
DEALLOCATE curMnozKVyrizeniVC
END
IF @TmpCreateDelete = 1
DROP TABLE #TmpZrusStornoDokl
DECLARE @ModelId NVARCHAR(255)
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)
SET @ModelId = N'd8ce7835-fc17-4fd1-9f7a-89214f901ab2'
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelId AND DataDirection IN(0,2))
BEGIN
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
JOIN TabPohybyZbozi p ON p.ID = d.IDPolozkaDokladu
JOIN TabDokladyZbozi h ON h.ID = p.IDDoklad
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2)
AND p.DruhPohybuZbo IN(2,3,4) AND h.AVAOutputFlag > 0
END
ELSE
IF (@Ins > 0 AND @Del = 0) OR
UPDATE(Poznamka) OR UPDATE(Mnozstvi)
BEGIN
INSERT TabAVAModelDataChanges(
RegistrationID, ActionType, ModelID, AVAReferenceID)
SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
FROM TabAVARegisteredModels m, 
(SELECT ID, AVAReferenceID, IDPolozkaDokladu, IDVyrCis
FROM INSERTED
EXCEPT
SELECT ID, AVAReferenceID, IDPolozkaDokladu, IDVyrCis
FROM DELETED) i
JOIN TabPohybyZbozi p ON p.ID = i.IDPolozkaDokladu
JOIN TabDokladyZbozi h ON h.ID = p.IDDoklad
WHERE m.ModelID = @ModelId AND m.DataDirection IN(0,2)
AND p.DruhPohybuZbo IN(2,3,4) AND h.AVAOutputFlag IN(1,3,4)
END
END
GO
