-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZamLogZmenProSocPoj] ON [dbo].[TabCisZam] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @PocetInserted INT,@PocetDeleted INT, @StavES INT
SET @PocetInserted=(SELECT COUNT(*)FROM inserted)
SET @PocetDeleted =(SELECT COUNT(*)FROM deleted)
IF @PocetInserted=0 OR @PocetDeleted=0
RETURN
DECLARE @IdObdobi INT, @IdObdobi_Akt INT, @IdObdobi_Bez INT
DECLARE @RokLog INT, @MesicLog INT, @JeObdobiRegZamCz BIT
SELECT @IdObdobi_Akt=IdObdobi FROM TabMzdObd WHERE Stav=1
SELECT @IdObdobi_Bez=IdObdobi FROM TabMzdObd WHERE Stav=2
IF (@IdObdobi_Akt IS NULL) OR (@IdObdobi_Bez IS NULL)
RETURN
IF UPDATE(Prijmeni) OR UPDATE(Jmeno) OR UPDATE(TitulPred) OR UPDATE(TitulZa) OR  
UPDATE(Pohlavi) OR UPDATE(RodinnyStav) OR UPDATE(StatniPrislus) OR
UPDATE(AdrTrvUlice) OR UPDATE(AdrTrvOrCislo) OR UPDATE(AdrTrvPopCislo) OR
UPDATE(AdrTrvMisto) OR UPDATE(AdrTrvPSC) OR UPDATE(AdrTrvZeme) OR
UPDATE(AdrPrechUlice) OR UPDATE(AdrPrechOrCislo) OR UPDATE(AdrPrechPopCislo) OR
UPDATE(AdrPrechMisto) OR UPDATE(AdrPrechPSC) OR UPDATE(AdrPrechZeme) OR
UPDATE(AdrKontUlice) OR UPDATE(AdrKontOrCislo) OR UPDATE(AdrKontPopCislo) OR
UPDATE(AdrKontMisto) OR UPDATE(AdrKontPSC) OR UPDATE(AdrKontZeme) OR
UPDATE(AdrRez_Ulice) OR UPDATE(AdrRez_OrCislo) OR UPDATE(AdrRez_PopCislo) OR
UPDATE(AdrRez_Misto) OR UPDATE(AdrRez_PSC) OR UPDATE(AdrRez_Zeme) OR
UPDATE(Ciz_Doklad_Typ) OR UPDATE(Ciz_Doklad_Cislo) OR
UPDATE(Ciz_Doklad_Vydal) OR UPDATE(Ciz_Doklad_Vydal_Zeme) OR
(
(EXISTS(SELECT * FROM TabHGlob WHERE Legislativa=1)) AND
(UPDATE(RodnePrijmeni) OR UPDATE(RodneCislo) OR UPDATE(RodinnyStav) OR
UPDATE(DatumNarozeni) OR UPDATE(MistoNarozeni))
)
BEGIN
DECLARE @Id INT,
@oPrijmeni NVARCHAR(100), @nPrijmeni NVARCHAR(100), @oJmeno NVARCHAR(100), @nJmeno NVARCHAR(100),
@oRodnePrijmeni NVARCHAR(100), @nRodnePrijmeni NVARCHAR(100), @oRodneCislo NVARCHAR(11), @nRodneCislo NVARCHAR(11),
@oTitulPred NVARCHAR(100), @nTitulPred NVARCHAR(100), @oTitulZa NVARCHAR(100), @nTitulZa NVARCHAR(100),
@oDatumNarozeni DATETIME, @nDatumNarozeni DATETIME, @oMistoNarozeni NVARCHAR(100), @nMistoNarozeni NVARCHAR(100),
@oStatNarozeni NVARCHAR(3), @nStatNarozeni NVARCHAR(3), @oPohlavi SMALLINT, @nPohlavi SMALLINT, @oRodinnyStav SMALLINT, @nRodinnyStav SMALLINT,
@oStatniPrislus NVARCHAR(3), @nStatniPrislus NVARCHAR(3),
@oAdrTrvUlice NVARCHAR(100), @nAdrTrvUlice NVARCHAR(100), @oAdrTrvOrCislo NVARCHAR(15), @nAdrTrvOrCislo NVARCHAR(15),
@oAdrTrvPopCislo NVARCHAR(15), @nAdrTrvPopCislo NVARCHAR(15), @oAdrTrvMisto NVARCHAR(100), @nAdrTrvMisto NVARCHAR(100),
@oAdrTrvPSC NVARCHAR(10), @nAdrTrvPSC NVARCHAR(10), @oAdrTrvZeme NVARCHAR(3), @nAdrTrvZeme NVARCHAR(3),
@oAdrPrechUlice NVARCHAR(100), @nAdrPrechUlice NVARCHAR(100), @oAdrPrechOrCislo NVARCHAR(15), @nAdrPrechOrCislo NVARCHAR(15),
@oAdrPrechPopCislo NVARCHAR(15), @nAdrPrechPopCislo NVARCHAR(15), @oAdrPrechMisto NVARCHAR(100), @nAdrPrechMisto NVARCHAR(100),
@oAdrPrechPSC NVARCHAR(10), @nAdrPrechPSC NVARCHAR(10), @oAdrPrechZeme NVARCHAR(3), @nAdrPrechZeme NVARCHAR(3),
@oAdrKontUlice NVARCHAR(100), @nAdrKontUlice NVARCHAR(100), @oAdrKontOrCislo NVARCHAR(15), @nAdrKontOrCislo NVARCHAR(15),
@oAdrKontPopCislo NVARCHAR(15), @nAdrKontPopCislo NVARCHAR(15), @oAdrKontMisto NVARCHAR(100), @nAdrKontMisto NVARCHAR(100),
@oAdrKontPSC NVARCHAR(10), @nAdrKontPSC NVARCHAR(10), @oAdrKontZeme NVARCHAR(3), @nAdrKontZeme NVARCHAR(3),
@oAdrRezUlice NVARCHAR(100), @nAdrRezUlice NVARCHAR(100), @oAdrRezOrCislo NVARCHAR(15), @nAdrRezOrCislo NVARCHAR(15),
@oAdrRezPopCislo NVARCHAR(15), @nAdrRezPopCislo NVARCHAR(15), @oAdrRezMisto NVARCHAR(100), @nAdrRezMisto NVARCHAR(100),
@oAdrRezPSC NVARCHAR(10), @nAdrRezPSC NVARCHAR(10), @oAdrRezZeme NVARCHAR(3), @nAdrRezZeme NVARCHAR(3),
@oCiz_Doklad_Typ SMALLINT, @nCiz_Doklad_Typ SMALLINT, @oCiz_Doklad_Cislo NVARCHAR(20), @nCiz_Doklad_Cislo NVARCHAR(20),
@oCiz_Doklad_Vydal NVARCHAR(100), @nCiz_Doklad_Vydal NVARCHAR(100), @oCiz_Doklad_Vydal_Zeme NVARCHAR(3), @nCiz_Doklad_Vydal_Zeme NVARCHAR(3)
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
SELECT d.Id, d.Prijmeni, i.Prijmeni, d.Jmeno, i.Jmeno, d.RodnePrijmeni, i.RodnePrijmeni, d.RodneCislo, i.RodneCislo,
d.TitulPred, i.TitulPred, d.TitulZa, i.TitulZa, d.DatumNarozeni, i.DatumNarozeni, d.MistoNarozeni, i.MistoNarozeni,
d.StatNarozeni, i.StatNarozeni, d.Pohlavi, i.Pohlavi, d.RodinnyStav, i.RodinnyStav, d.StatniPrislus, i.StatniPrislus,
d.AdrTrvUlice, i.AdrTrvUlice, d.AdrTrvOrCislo, i.AdrTrvOrCislo, d.AdrTrvPopCislo, i.AdrTrvPopCislo,
d.AdrTrvMisto, i.AdrTrvMisto, d.AdrTrvPSC, i.AdrTrvPSC, d.AdrTrvZeme, i.AdrTrvZeme,
d.AdrPrechUlice, i.AdrPrechUlice, d.AdrPrechOrCislo, i.AdrPrechOrCislo, d.AdrPrechPopCislo, i.AdrPrechPopCislo,
d.AdrPrechMisto, i.AdrPrechMisto, d.AdrPrechPSC, i.AdrPrechPSC, d.AdrPrechZeme, i.AdrPrechZeme,
d.AdrKontUlice, i.AdrKontUlice, d.AdrKontOrCislo, i.AdrKontOrCislo, d.AdrKontPopCislo, i.AdrKontPopCislo,
d.AdrKontMisto, i.AdrKontMisto, d.AdrKontPSC, i.AdrKontPSC, d.AdrKontZeme, i.AdrKontZeme,
d.AdrRez_Ulice, i.AdrRez_Ulice, d.AdrRez_OrCislo, i.AdrRez_OrCislo, d.AdrRez_PopCislo, i.AdrRez_PopCislo,
d.AdrRez_Misto, i.AdrRez_Misto, d.AdrRez_PSC, i.AdrRez_PSC, d.AdrRez_Zeme, i.AdrRez_Zeme,
d.Ciz_Doklad_Typ, i.Ciz_Doklad_Typ, d.Ciz_Doklad_Cislo, i.Ciz_Doklad_Cislo,
d.Ciz_Doklad_Vydal, i.Ciz_Doklad_Vydal, d.Ciz_Doklad_Vydal_Zeme, i.Ciz_Doklad_Vydal_Zeme
FROM TabCisZam AS i
RIGHT JOIN deleted AS d ON i.ID=d.ID
WHERE (i.VyraditZPrehledu=0)
OPEN c
WHILE 1=1
BEGIN
FETCH NEXT FROM c
INTO @Id, @oPrijmeni, @nPrijmeni, @oJmeno, @nJmeno, @oRodnePrijmeni, @nRodnePrijmeni, @oRodneCislo, @nRodneCislo,
@oTitulPred, @nTitulPred, @oTitulZa, @nTitulZa, @oDatumNarozeni, @nDatumNarozeni, @oMistoNarozeni, @nMistoNarozeni,
@oStatNarozeni, @nStatNarozeni, @oPohlavi, @nPohlavi, @oRodinnyStav, @nRodinnyStav, @oStatniPrislus, @nStatniPrislus,
@oAdrTrvUlice, @nAdrTrvUlice, @oAdrTrvOrCislo, @nAdrTrvOrCislo, @oAdrTrvPopCislo, @nAdrTrvPopCislo,
@oAdrTrvMisto, @nAdrTrvMisto, @oAdrTrvPSC, @nAdrTrvPSC, @oAdrTrvZeme, @nAdrTrvZeme,
@oAdrPrechUlice, @nAdrPrechUlice, @oAdrPrechOrCislo, @nAdrPrechOrCislo, @oAdrPrechPopCislo, @nAdrPrechPopCislo,
@oAdrPrechMisto, @nAdrPrechMisto, @oAdrPrechPSC, @nAdrPrechPSC, @oAdrPrechZeme, @nAdrPrechZeme,
@oAdrKontUlice, @nAdrKontUlice, @oAdrKontOrCislo, @nAdrKontOrCislo, @oAdrKontPopCislo, @nAdrKontPopCislo,
@oAdrKontMisto, @nAdrKontMisto, @oAdrKontPSC, @nAdrKontPSC, @oAdrKontZeme, @nAdrKontZeme,
@oAdrRezUlice, @nAdrRezUlice, @oAdrRezOrCislo, @nAdrRezOrCislo, @oAdrRezPopCislo, @nAdrRezPopCislo,
@oAdrRezMisto, @nAdrRezMisto, @oAdrRezPSC, @nAdrRezPSC, @oAdrRezZeme, @nAdrRezZeme,
@oCiz_Doklad_Typ, @nCiz_Doklad_Typ, @oCiz_Doklad_Cislo, @nCiz_Doklad_Cislo,
@oCiz_Doklad_Vydal, @nCiz_Doklad_Vydal, @oCiz_Doklad_Vydal_Zeme, @nCiz_Doklad_Vydal_Zeme
IF @@FETCH_STATUS<>0 BREAK
SET @StavES = NULL
SELECT @StavES=StavES FROM TabZamMzd WHERE IdObdobi=@IdObdobi_Akt AND ZamestnanecId=@Id
IF NOT (@StavES IS NULL)
SET @IdObdobi = @IdObdobi_Akt
ELSE
BEGIN
SELECT @StavES=StavES FROM TabZamMzd WHERE IdObdobi=@IdObdobi_Bez AND ZamestnanecId=@Id
IF NOT (@StavES IS NULL)
SET @IdObdobi = @IdObdobi_Bez
ELSE
CONTINUE
END
IF NOT (@StavES IN (0,1))
CONTINUE
SELECT @RokLog=Rok, @MesicLog=Mesic FROM TabMzdObd WHERE IdObdobi=@IdObdobi
SET @JeObdobiRegZamCz = 0
IF EXISTS(SELECT * FROM TabHGlob WHERE Legislativa<>1) AND (
(@RokLog > 2026) OR ((@RokLog=2026) AND (@MesicLog>=4))
)
SET @JeObdobiRegZamCz = 1
IF @JeObdobiRegZamCz = 0
BEGIN
IF UPDATE(Prijmeni) AND (@oPrijmeni IS NULL OR @nPrijmeni IS NULL OR @oPrijmeni<>@nPrijmeni)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 0, @oPrijmeni, @nPrijmeni, GetDate(), SUSER_SNAME())
IF UPDATE(Jmeno) AND (@oJmeno IS NULL OR @nJmeno IS NULL OR @oJmeno<>@nJmeno)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 1, @oJmeno, @nJmeno, GetDate(), SUSER_SNAME())
IF UPDATE(TitulPred) AND (@oTitulPred IS NULL OR @nTitulPred IS NULL OR @oTitulPred<>@nTitulPred)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 3, @oTitulPred, @nTitulPred, GetDate(), SUSER_SNAME())
IF UPDATE(TitulZa) AND (@oTitulZa IS NULL OR @nTitulZa IS NULL OR @oTitulZa<>@nTitulZa)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 4, @oTitulZa, @nTitulZa, GetDate(), SUSER_SNAME())
IF UPDATE(Pohlavi) AND (@oPohlavi IS NULL OR @nPohlavi IS NULL OR @oPohlavi<>@nPohlavi)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 8, @oPohlavi, @nPohlavi, GetDate(), SUSER_SNAME())
IF UPDATE(StatniPrislus) AND (@oStatniPrislus IS NULL OR @nStatniPrislus IS NULL OR @oStatniPrislus<>@nStatniPrislus)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 10, @oStatniPrislus, @nStatniPrislus, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvUlice) AND (@oAdrTrvUlice IS NULL OR @nAdrTrvUlice IS NULL OR @oAdrTrvUlice<>@nAdrTrvUlice)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 11, @oAdrTrvUlice, @nAdrTrvUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvPopCislo) AND (@oAdrTrvPopCislo IS NULL OR @nAdrTrvPopCislo IS NULL OR @oAdrTrvPopCislo<>@nAdrTrvPopCislo)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 12, @oAdrTrvPopCislo, @nAdrTrvPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvOrCislo) AND (@oAdrTrvOrCislo IS NULL OR @nAdrTrvOrCislo IS NULL OR @oAdrTrvOrCislo<>@nAdrTrvOrCislo)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 13, @oAdrTrvOrCislo, @nAdrTrvOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvPSC) AND (@oAdrTrvPSC IS NULL OR @nAdrTrvPSC IS NULL OR @oAdrTrvPSC<>@nAdrTrvPSC)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 14, @oAdrTrvPSC, @nAdrTrvPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvMisto) AND (@oAdrTrvMisto IS NULL OR @nAdrTrvMisto IS NULL OR @oAdrTrvMisto<>@nAdrTrvMisto)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 15, @oAdrTrvMisto, @nAdrTrvMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvZeme) AND (@oAdrTrvZeme IS NULL OR @nAdrTrvZeme IS NULL OR @oAdrTrvZeme<>@nAdrTrvZeme)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 16, @oAdrTrvZeme, @nAdrTrvZeme, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechUlice) AND (@oAdrPrechUlice IS NULL OR @nAdrPrechUlice IS NULL OR @oAdrPrechUlice<>@nAdrPrechUlice)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 17, @oAdrPrechUlice, @nAdrPrechUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechPopCislo) AND (@oAdrPrechPopCislo IS NULL OR @nAdrPrechPopCislo IS NULL OR @oAdrPrechPopCislo<>@nAdrPrechPopCislo)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 18, @oAdrPrechPopCislo, @nAdrPrechPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechOrCislo) AND (@oAdrPrechOrCislo IS NULL OR @nAdrPrechOrCislo IS NULL OR @oAdrPrechOrCislo<>@nAdrPrechOrCislo)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 19, @oAdrPrechOrCislo, @nAdrPrechOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechPSC) AND (@oAdrPrechPSC IS NULL OR @nAdrPrechPSC IS NULL OR @oAdrPrechPSC<>@nAdrPrechPSC)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 20, @oAdrPrechPSC, @nAdrPrechPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechMisto) AND (@oAdrPrechMisto IS NULL OR @nAdrPrechMisto IS NULL OR @oAdrPrechMisto<>@nAdrPrechMisto)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 21, @oAdrPrechMisto, @nAdrPrechMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechZeme) AND (@oAdrPrechZeme IS NULL OR @nAdrPrechZeme IS NULL OR @oAdrPrechZeme<>@nAdrPrechZeme)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 22, @oAdrPrechZeme, @nAdrPrechZeme, GetDate(), SUSER_SNAME())
END
ELSE
BEGIN
IF UPDATE(Prijmeni) AND (@oPrijmeni IS NULL OR @nPrijmeni IS NULL OR @oPrijmeni<>@nPrijmeni)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 0, @oPrijmeni, @nPrijmeni, GetDate(), SUSER_SNAME())
IF UPDATE(Jmeno) AND (@oJmeno IS NULL OR @nJmeno IS NULL OR @oJmeno<>@nJmeno)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 1, @oJmeno, @nJmeno, GetDate(), SUSER_SNAME())
IF UPDATE(TitulPred) AND (@oTitulPred IS NULL OR @nTitulPred IS NULL OR @oTitulPred<>@nTitulPred)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 3, @oTitulPred, @nTitulPred, GetDate(), SUSER_SNAME())
IF UPDATE(TitulZa) AND (@oTitulZa IS NULL OR @nTitulZa IS NULL OR @oTitulZa<>@nTitulZa)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 4, @oTitulZa, @nTitulZa, GetDate(), SUSER_SNAME())
IF UPDATE(Pohlavi) AND (@oPohlavi IS NULL OR @nPohlavi IS NULL OR @oPohlavi<>@nPohlavi)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 8, @oPohlavi, @nPohlavi, GetDate(), SUSER_SNAME())
IF UPDATE(StatniPrislus) AND (@oStatniPrislus IS NULL OR @nStatniPrislus IS NULL OR @oStatniPrislus<>@nStatniPrislus)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 10, @oStatniPrislus, @nStatniPrislus, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvUlice) AND (@oAdrTrvUlice IS NULL OR @nAdrTrvUlice IS NULL OR @oAdrTrvUlice<>@nAdrTrvUlice)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 11, @oAdrTrvUlice, @nAdrTrvUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvPopCislo) AND (@oAdrTrvPopCislo IS NULL OR @nAdrTrvPopCislo IS NULL OR @oAdrTrvPopCislo<>@nAdrTrvPopCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 12, @oAdrTrvPopCislo, @nAdrTrvPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvOrCislo) AND (@oAdrTrvOrCislo IS NULL OR @nAdrTrvOrCislo IS NULL OR @oAdrTrvOrCislo<>@nAdrTrvOrCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 13, @oAdrTrvOrCislo, @nAdrTrvOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvPSC) AND (@oAdrTrvPSC IS NULL OR @nAdrTrvPSC IS NULL OR @oAdrTrvPSC<>@nAdrTrvPSC)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 14, @oAdrTrvPSC, @nAdrTrvPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvMisto) AND (@oAdrTrvMisto IS NULL OR @nAdrTrvMisto IS NULL OR @oAdrTrvMisto<>@nAdrTrvMisto)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 15, @oAdrTrvMisto, @nAdrTrvMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrTrvZeme) AND (@oAdrTrvZeme IS NULL OR @nAdrTrvZeme IS NULL OR @oAdrTrvZeme<>@nAdrTrvZeme)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 16, @oAdrTrvZeme, @nAdrTrvZeme, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechUlice) AND (@oAdrPrechUlice IS NULL OR @nAdrPrechUlice IS NULL OR @oAdrPrechUlice<>@nAdrPrechUlice)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 17, @oAdrPrechUlice, @nAdrPrechUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechPopCislo) AND (@oAdrPrechPopCislo IS NULL OR @nAdrPrechPopCislo IS NULL OR @oAdrPrechPopCislo<>@nAdrPrechPopCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 18, @oAdrPrechPopCislo, @nAdrPrechPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechOrCislo) AND (@oAdrPrechOrCislo IS NULL OR @nAdrPrechOrCislo IS NULL OR @oAdrPrechOrCislo<>@nAdrPrechOrCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 19, @oAdrPrechOrCislo, @nAdrPrechOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechPSC) AND (@oAdrPrechPSC IS NULL OR @nAdrPrechPSC IS NULL OR @oAdrPrechPSC<>@nAdrPrechPSC)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 20, @oAdrPrechPSC, @nAdrPrechPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrPrechMisto) AND (@oAdrPrechMisto IS NULL OR @nAdrPrechMisto IS NULL OR @oAdrPrechMisto<>@nAdrPrechMisto)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 21, @oAdrPrechMisto, @nAdrPrechMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontUlice) AND (@oAdrKontUlice IS NULL OR @nAdrKontUlice IS NULL OR @oAdrKontUlice<>@nAdrKontUlice)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 23, @oAdrKontUlice, @nAdrKontUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontPopCislo) AND (@oAdrKontPopCislo IS NULL OR @nAdrKontPopCislo IS NULL OR @oAdrKontPopCislo<>@nAdrKontPopCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 24, @oAdrKontPopCislo, @nAdrKontPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontOrCislo) AND (@oAdrKontOrCislo IS NULL OR @nAdrKontOrCislo IS NULL OR @oAdrKontOrCislo<>@nAdrKontOrCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 25, @oAdrKontOrCislo, @nAdrKontOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontPSC) AND (@oAdrKontPSC IS NULL OR @nAdrKontPSC IS NULL OR @oAdrKontPSC<>@nAdrKontPSC)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 26, @oAdrKontPSC, @nAdrKontPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontMisto) AND (@oAdrKontMisto IS NULL OR @nAdrKontMisto IS NULL OR @oAdrKontMisto<>@nAdrKontMisto)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 27, @oAdrKontMisto, @nAdrKontMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrKontZeme) AND (@oAdrKontZeme IS NULL OR @nAdrKontZeme IS NULL OR @oAdrKontZeme<>@nAdrKontZeme)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 28, @oAdrKontZeme, @nAdrKontZeme, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_Ulice) AND (@oAdrRezUlice IS NULL OR @nAdrRezUlice IS NULL OR @oAdrRezUlice<>@nAdrRezUlice)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 29, @oAdrRezUlice, @nAdrRezUlice, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_PopCislo) AND (@oAdrRezPopCislo IS NULL OR @nAdrRezPopCislo IS NULL OR @oAdrRezPopCislo<>@nAdrRezPopCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 30, @oAdrRezPopCislo, @nAdrRezPopCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_OrCislo) AND (@oAdrRezOrCislo IS NULL OR @nAdrRezOrCislo IS NULL OR @oAdrRezOrCislo<>@nAdrRezOrCislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 31, @oAdrRezOrCislo, @nAdrRezOrCislo, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_PSC) AND (@oAdrRezPSC IS NULL OR @nAdrRezPSC IS NULL OR @oAdrRezPSC<>@nAdrRezPSC)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 32, @oAdrRezPSC, @nAdrRezPSC, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_Misto) AND (@oAdrRezMisto IS NULL OR @nAdrRezMisto IS NULL OR @oAdrRezMisto<>@nAdrRezMisto)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 33, @oAdrRezMisto, @nAdrRezMisto, GetDate(), SUSER_SNAME())
IF UPDATE(AdrRez_Zeme) AND (@oAdrRezZeme IS NULL OR @nAdrRezZeme IS NULL OR @oAdrRezZeme<>@nAdrRezZeme)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 34, @oAdrRezZeme, @nAdrRezZeme, GetDate(), SUSER_SNAME())
IF UPDATE(Ciz_Doklad_Typ) AND (@oCiz_Doklad_Typ IS NULL OR @nCiz_Doklad_Typ IS NULL OR @oCiz_Doklad_Typ<>@nCiz_Doklad_Typ)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 35, @oCiz_Doklad_Typ, @nCiz_Doklad_Typ, GetDate(), SUSER_SNAME())
IF UPDATE(Ciz_Doklad_Cislo) AND (@oCiz_Doklad_Cislo IS NULL OR @nCiz_Doklad_Cislo IS NULL OR @oCiz_Doklad_Cislo<>@nCiz_Doklad_Cislo)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 36, @oCiz_Doklad_Cislo, @nCiz_Doklad_Cislo, GetDate(), SUSER_SNAME())
IF UPDATE(Ciz_Doklad_Vydal) AND (@oCiz_Doklad_Vydal IS NULL OR @nCiz_Doklad_Vydal IS NULL OR @oCiz_Doklad_Vydal<>@nCiz_Doklad_Vydal)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 37, @oCiz_Doklad_Vydal, @nCiz_Doklad_Vydal, GetDate(), SUSER_SNAME())
IF UPDATE(Ciz_Doklad_Vydal_Zeme) AND (@oCiz_Doklad_Vydal_Zeme IS NULL OR @nCiz_Doklad_Vydal_Zeme IS NULL OR @oCiz_Doklad_Vydal_Zeme<>@nCiz_Doklad_Vydal_Zeme)
INSERT INTO TabMzRegZamCzLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 38, @oCiz_Doklad_Vydal_Zeme, @nCiz_Doklad_Vydal_Zeme, GetDate(), SUSER_SNAME())
END
IF EXISTS(SELECT * FROM TabHGlob WHERE Legislativa=1)
BEGIN
IF UPDATE(RodnePrijmeni) AND (@oRodnePrijmeni IS NULL OR @nRodnePrijmeni IS NULL OR @oRodnePrijmeni<>@nRodnePrijmeni)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 2, @oRodnePrijmeni, @nRodnePrijmeni, GetDate(), SUSER_SNAME())
IF UPDATE(RodneCislo) AND (@oRodneCislo IS NULL OR @nRodneCislo IS NULL OR @oRodneCislo<>@nRodneCislo)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 5, @oRodneCislo, @nRodneCislo, GetDate(), SUSER_SNAME())
IF UPDATE(DatumNarozeni) AND (@oDatumNarozeni IS NULL OR @nDatumNarozeni IS NULL OR @oDatumNarozeni<>@nDatumNarozeni)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 6, @oDatumNarozeni, @nDatumNarozeni, GetDate(), SUSER_SNAME())
IF UPDATE(MistoNarozeni) AND (@oMistoNarozeni IS NULL OR @nMistoNarozeni IS NULL OR @oMistoNarozeni<>@nMistoNarozeni)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 7, @oMistoNarozeni, @nMistoNarozeni, GetDate(), SUSER_SNAME())
IF UPDATE(RodinnyStav) AND (@oRodinnyStav IS NULL OR @nRodinnyStav IS NULL OR @oRodinnyStav<>@nRodinnyStav)
INSERT INTO TabMzSPZmenyLog(ZamestnanecId, IdObdobi, Atribut, Hodnota_Old, Hodnota_New, Zmena_Datum, Zmena_Autor)
VALUES(@Id, @IdObdobi, 9, @oRodinnyStav, @nRodinnyStav, GetDate(), SUSER_SNAME())
END
END
END
GO
