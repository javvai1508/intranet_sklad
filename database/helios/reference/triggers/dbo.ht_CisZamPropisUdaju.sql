-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZamPropisUdaju] ON [dbo].[TabCisZam] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @SeznamDeklaraci NVARCHAR(4000)
DECLARE @RodneCislo NVARCHAR(11), @ID INT
DECLARE @Sql NVARCHAR(4000)
DECLARE @Jmeno NVARCHAR(100),@Prijmeni NVARCHAR(100),@RodnePrijmeni NVARCHAR(100),
@TitulPred NVARCHAR(100),@TitulZa NVARCHAR(100),@LoginId NVARCHAR(128),@DatumNarozeni DATETIME,
@Pohlavi SMALLINT,@MistoNarozeni NVARCHAR(100),@StatNarozeni NVARCHAR(3),@AdrTrvUlice NVARCHAR(100),
@AdrTrvOrCislo NVARCHAR(15),@AdrTrvPopCislo NVARCHAR(15),
@AdrTrvMisto NVARCHAR(100),@AdrTrvPSC NVARCHAR(10),@AdrTrvZeme NVARCHAR(3),@AdrPrechUlice NVARCHAR(100),
@AdrPrechOrCislo NVARCHAR(15),@AdrPrechPopCislo NVARCHAR(15),
@AdrPrechMisto NVARCHAR(100),@AdrPrechPSC NVARCHAR(10),@AdrPrechZeme NVARCHAR(3),@StatniPrislus NVARCHAR(3),
@Narodnost NVARCHAR(100),@RodinnyStav SMALLINT,@Stredisko NVARCHAR(30),@NakladovyOkruh NVARCHAR(15),@Zakazka NVARCHAR(15) ,
@CisloOP NVARCHAR(15),@PlatnostOP DATETIME, @CisloPasu NVARCHAR(20),@PlatnostPasu DATETIME,@PasVydal NVARCHAR(40),@PasVydal_Zeme NVarchar(3),
@CisloRP NVARCHAR(20),@SkupinaRP NVARCHAR(55),@PlatnostRP DATETIME,@Alias NVARCHAR(15),@SSN NVARCHAR(24),
@PovoleniKPobytu NVARCHAR(30),@HesloPDF NVARCHAR(20),@AdrKontJmeno NVARCHAR(100),@AdrKontPrijmeni NVARCHAR(100),
@AdrKontUlice NVARCHAR(100),
@AdrKontOrCislo NVARCHAR(15),@AdrKontPopCislo NVARCHAR(15),@AdrKontMisto NVARCHAR(100),@AdrKontPSC NVARCHAR(10),
@AdrKontZeme NVARCHAR(3),@KodZdrPojAVA NVARCHAR(40), @CisloPojistenceAVA NVARCHAR(15), @OsobniIC NVARCHAR(10),
@Ciz_Doklad_Typ SMALLINT,@Ciz_Doklad_Cislo NVARCHAR(20),@Ciz_Doklad_Vydal NVARCHAR(100),
@Ciz_Doklad_Vydal_Zeme NVARCHAR(3),@AdrRez_Ulice NVARCHAR(100),@AdrRez_OrCislo NVARCHAR(12),
@AdrRez_PopCislo NVARCHAR(12),@AdrRez_Misto NVARCHAR(100),@AdrRez_PSC NVARCHAR(10),@AdrRez_Zeme NVARCHAR(3)
DECLARE cProp CURSOR FOR
SELECT
RodneCislo, ID,
Jmeno,Prijmeni,RodnePrijmeni,TitulPred,TitulZa,DatumNarozeni,
Pohlavi,MistoNarozeni,StatNarozeni,AdrTrvUlice,AdrTrvOrCislo,AdrTrvPopCislo,AdrTrvMisto,AdrTrvPSC,
AdrTrvZeme,AdrPrechUlice,AdrPrechOrCislo,AdrPrechPopCislo,AdrPrechMisto,AdrPrechPSC,
AdrPrechZeme,StatniPrislus,Narodnost,RodinnyStav,
CisloOP,PlatnostOP,CisloPasu,PlatnostPasu,PasVydal,PasVydal_Zeme,CisloRP,SkupinaRP,PlatnostRP,SSN,
PovoleniKPobytu,AdrKontJmeno,AdrKontPrijmeni,AdrKontUlice,AdrKontOrCislo,
AdrKontPopCislo,AdrKontMisto,AdrKontPSC,AdrKontZeme,KodZdrPojAVA, CisloPojistenceAVA, OsobniIC,
Ciz_Doklad_Typ,Ciz_Doklad_Cislo,Ciz_Doklad_Vydal,Ciz_Doklad_Vydal_Zeme,AdrRez_Ulice,
AdrRez_OrCislo,AdrRez_PopCislo,AdrRez_Misto,AdrRez_PSC,AdrRez_Zeme
FROM inserted
WHERE RodneCislo IS NOT NULL AND RodneCislo <> '' AND VyraditZPrehledu = 0
OPEN cProp
WHILE 1=1
BEGIN
FETCH NEXT FROM cProp INTO
@RodneCislo, @ID,
@Jmeno,@Prijmeni,@RodnePrijmeni,@TitulPred,@TitulZa,@DatumNarozeni,
@Pohlavi,@MistoNarozeni,@StatNarozeni,@AdrTrvUlice,@AdrTrvOrCislo,@AdrTrvPopCislo,@AdrTrvMisto,@AdrTrvPSC,
@AdrTrvZeme,@AdrPrechUlice,@AdrPrechOrCislo,@AdrPrechPopCislo,@AdrPrechMisto,@AdrPrechPSC,
@AdrPrechZeme,@StatniPrislus,@Narodnost,@RodinnyStav,
@CisloOP,@PlatnostOP,@CisloPasu,@PlatnostPasu,@PasVydal,@PasVydal_Zeme,@CisloRP,@SkupinaRP,@PlatnostRP,@SSN,
@PovoleniKPobytu,@AdrKontJmeno,@AdrKontPrijmeni,@AdrKontUlice,@AdrKontOrCislo,
@AdrKontPopCislo,@AdrKontMisto,@AdrKontPSC,@AdrKontZeme,@KodZdrPojAVA, @CisloPojistenceAVA, @OsobniIC,
@Ciz_Doklad_Typ,@Ciz_Doklad_Cislo,@Ciz_Doklad_Vydal,@Ciz_Doklad_Vydal_Zeme,@AdrRez_Ulice,
@AdrRez_OrCislo,@AdrRez_PopCislo,@AdrRez_Misto,@AdrRez_PSC,@AdrRez_Zeme
IF @@FETCH_STATUS <> 0 BREAK
IF NOT EXISTS(SELECT * FROM TabCisZam WHERE RodneCislo = @RodneCislo AND ID <> @ID AND VyraditZPrehledu = 1)
CONTINUE
SET @Sql = N''
IF UPDATE(Jmeno)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Jmeno=@Jmeno'
END
IF UPDATE(Prijmeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Prijmeni=@Prijmeni'
END
IF UPDATE(RodnePrijmeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'RodnePrijmeni=@RodnePrijmeni'
END
IF UPDATE(TitulPred)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'TitulPred=@TitulPred'
END
IF UPDATE(TitulZa)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'TitulZa=@TitulZa'
END
IF UPDATE(DatumNarozeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'DatumNarozeni=@DatumNarozeni'
END
IF UPDATE(Pohlavi)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Pohlavi=@Pohlavi'
END
IF UPDATE(MistoNarozeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'MistoNarozeni=@MistoNarozeni'
END
IF UPDATE(StatNarozeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'StatNarozeni=@StatNarozeni'
END
IF UPDATE(AdrTrvUlice)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvUlice=@AdrTrvUlice'
END
IF UPDATE(AdrTrvOrCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvOrCislo=@AdrTrvOrCislo'
END
IF UPDATE(AdrTrvPopCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvPopCislo=@AdrTrvPopCislo'
END
IF UPDATE(AdrTrvMisto)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvMisto=@AdrTrvMisto'
END
IF UPDATE(AdrTrvPSC)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvPSC=@AdrTrvPSC'
END
IF UPDATE(AdrTrvZeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrTrvZeme=@AdrTrvZeme'
END
IF UPDATE(AdrPrechUlice)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechUlice=@AdrPrechUlice'
END
IF UPDATE(AdrPrechOrCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechOrCislo=@AdrPrechOrCislo'
END
IF UPDATE(AdrPrechPopCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechPopCislo=@AdrPrechPopCislo'
END
IF UPDATE(AdrPrechMisto)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechMisto=@AdrPrechMisto'
END
IF UPDATE(AdrPrechPSC)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechPSC=@AdrPrechPSC'
END
IF UPDATE(AdrPrechZeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrPrechZeme=@AdrPrechZeme'
END
IF UPDATE(StatniPrislus)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'StatniPrislus=@StatniPrislus'
END
IF UPDATE(Narodnost)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Narodnost=@Narodnost'
END
IF UPDATE(RodinnyStav)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'RodinnyStav=@RodinnyStav'
END
IF UPDATE(CisloOP)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'CisloOP=@CisloOP'
END
IF UPDATE(PlatnostOP)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PlatnostOP=@PlatnostOP'
END
IF UPDATE(CisloPasu)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'CisloPasu=@CisloPasu'
END
IF UPDATE(PlatnostPasu)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PlatnostPasu=@PlatnostPasu'
END
IF UPDATE(PasVydal)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PasVydal=@PasVydal'
END
IF UPDATE(PasVydal_Zeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PasVydal_Zeme=@PasVydal_Zeme'
END
IF UPDATE(CisloRP)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'CisloRP=@CisloRP'
END
IF UPDATE(SkupinaRP)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'SkupinaRP=@SkupinaRP'
END
IF UPDATE(PlatnostRP)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PlatnostRP=@PlatnostRP'
END
IF UPDATE(SSN)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'SSN=@SSN'
END
IF UPDATE(PovoleniKPobytu)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'PovoleniKPobytu=@PovoleniKPobytu'
END
IF UPDATE(AdrKontJmeno)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontJmeno=@AdrKontJmeno'
END
IF UPDATE(AdrKontPrijmeni)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontPrijmeni=@AdrKontPrijmeni'
END
IF UPDATE(AdrKontUlice)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontUlice=@AdrKontUlice'
END
IF UPDATE(AdrKontOrCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontOrCislo=@AdrKontOrCislo'
END
IF UPDATE(AdrKontPopCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontPopCislo=@AdrKontPopCislo'
END
IF UPDATE(AdrKontMisto)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontMisto=@AdrKontMisto'
END
IF UPDATE(AdrKontPSC)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontPSC=@AdrKontPSC'
END
IF UPDATE(AdrKontZeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrKontZeme=@AdrKontZeme'
END
IF UPDATE(KodZdrPojAVA)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'KodZdrPojAVA=@KodZdrPojAVA'
IF (EXISTS(SELECT * FROM TabHGlob WHERE Legislativa=1))  --SK
BEGIN
IF EXISTS (SELECT * FROM TabMzNastupPP WHERE ZamestnanecId=@ID AND Stav=0 AND ZdrPojSk<>@KodZdrPojAVA)
UPDATE TabMzNastupPP SET ZdrPojSk=@KodZdrPojAVA WHERE ZamestnanecId=@ID AND Stav=0 AND ZdrPojSk<>@KodZdrPojAVA
END
ELSE
IF EXISTS (SELECT * FROM TabMzNastupPP WHERE ZamestnanecId=@ID AND Stav=0 AND ZdravPojistovna<>@KodZdrPojAVA)
UPDATE TabMzNastupPP SET ZdravPojistovna=@KodZdrPojAVA WHERE ZamestnanecId=@ID AND Stav=0 AND ZdravPojistovna<>@KodZdrPojAVA
END
IF UPDATE(CisloPojistenceAVA)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'CisloPojistenceAVA=@CisloPojistenceAVA'
IF (EXISTS(SELECT * FROM TabHGlob WHERE Legislativa<>1))  -- Leg<>SK
BEGIN
IF EXISTS (SELECT * FROM TabMzNastupPP WHERE ZamestnanecId= @ID AND Stav=0 AND CisloPojistence<>@CisloPojistenceAVA)
UPDATE TabMzNastupPP SET CisloPojistence=@CisloPojistenceAVA WHERE ZamestnanecId=@ID AND Stav=0 AND CisloPojistence<>@CisloPojistenceAVA
END
END
IF UPDATE(OsobniIC)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'OsobniIC=@OsobniIC'
END
IF UPDATE(Ciz_Doklad_Typ)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Ciz_Doklad_Typ=@Ciz_Doklad_Typ'
END
IF UPDATE(Ciz_Doklad_Cislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Ciz_Doklad_Cislo=@Ciz_Doklad_Cislo'
END
IF UPDATE(Ciz_Doklad_Vydal)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Ciz_Doklad_Vydal=@Ciz_Doklad_Vydal'
END
IF UPDATE(Ciz_Doklad_Vydal_Zeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'Ciz_Doklad_Vydal_Zeme=@Ciz_Doklad_Vydal_Zeme'
END
IF UPDATE(AdrRez_Ulice)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_Ulice=@AdrRez_Ulice'
END
IF UPDATE(AdrRez_OrCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_OrCislo=@AdrRez_OrCislo'
END
IF UPDATE(AdrRez_PopCislo)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_PopCislo=@AdrRez_PopCislo'
END
IF UPDATE(AdrRez_Misto)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_Misto=@AdrRez_Misto'
END
IF UPDATE(AdrRez_PSC)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_PSC=@AdrRez_PSC'
END
IF UPDATE(AdrRez_Zeme)
BEGIN
IF @Sql <> N'' SET @Sql=@Sql+N','
SET @Sql=@Sql+N'AdrRez_Zeme=@AdrRez_Zeme'
END
IF @Sql <> N''
BEGIN
SET @Sql =
N'UPDATE TabCisZam SET ' +
@Sql +
N' WHERE RodneCislo = @RodneCislo AND ID <> @ID AND VyraditZPrehledu = 1'+
N' AND ISNULL((SELECT m.StavEs FROM TabZamMzd m WHERE m.ZamestnanecID = TabCisZam.ID AND m.IdObdobi=(SELECT IdObdobi FROM TabMzdObd WHERE Stav = 1)), 10) NOT IN (3, 10)'
SET @SeznamDeklaraci = N'
@Rodnecislo NVARCHAR(11), @ID INT,
@Jmeno NVARCHAR(100),@Prijmeni NVARCHAR(100),@RodnePrijmeni NVARCHAR(100),
@TitulPred NVARCHAR(100),@TitulZa NVARCHAR(100),
@DatumNarozeni DATETIME,@Pohlavi SMALLINT,@MistoNarozeni NVARCHAR(100),@StatNarozeni NVARCHAR(3),
@AdrTrvUlice NVARCHAR(100),@AdrTrvOrCislo NVARCHAR(15),@AdrTrvPopCislo NVARCHAR(15),
@AdrTrvMisto NVARCHAR(100),@AdrTrvPSC NVARCHAR(10),@AdrTrvZeme NVARCHAR(3),
@AdrPrechUlice NVARCHAR(100),@AdrPrechOrCislo NVARCHAR(15),@AdrPrechPopCislo NVARCHAR(15),
@AdrPrechMisto NVARCHAR(100),@AdrPrechPSC NVARCHAR(10),@AdrPrechZeme NVARCHAR(3),
@StatniPrislus NVARCHAR(3),@Narodnost NVARCHAR(100),@RodinnyStav SMALLINT,
@CisloOP NVARCHAR(15),@PlatnostOP DATETIME, @CisloPasu NVARCHAR(20),@PlatnostPasu DATETIME,@PasVydal NVARCHAR(40),@PasVydal_Zeme NVARCHAR(3),
@CisloRP NVARCHAR(20),@SkupinaRP NVARCHAR(55),@PlatnostRP DATETIME,@SSN NVARCHAR(24),
@PovoleniKPobytu NVARCHAR(30),@AdrKontJmeno NVARCHAR(100),
@AdrKontPrijmeni NVARCHAR(100),@AdrKontUlice NVARCHAR(100),
@AdrKontOrCislo NVARCHAR(15),@AdrKontPopCislo NVARCHAR(15),@AdrKontMisto NVARCHAR(100),
@AdrKontPSC NVARCHAR(10),@AdrKontZeme NVARCHAR(3),@KodZdrPojAVA NVARCHAR(40), @CisloPojistenceAVA NVARCHAR(15), @OsobniIC NVARCHAR(10),
@Ciz_Doklad_Typ SMALLINT,@Ciz_Doklad_Cislo NVARCHAR(20),@Ciz_Doklad_Vydal NVARCHAR(100),
@Ciz_Doklad_Vydal_Zeme NVARCHAR(3),@AdrRez_Ulice NVARCHAR(100),@AdrRez_OrCislo NVARCHAR(12),
@AdrRez_PopCislo NVARCHAR(12),@AdrRez_Misto NVARCHAR(100),@AdrRez_PSC NVARCHAR(10),@AdrRez_Zeme NVARCHAR(3)'
EXEC sp_executesql @Sql, @SeznamDeklaraci,
@Rodnecislo, @ID,
@Jmeno,@Prijmeni,@RodnePrijmeni,@TitulPred,@TitulZa,@DatumNarozeni,
@Pohlavi,@MistoNarozeni,@StatNarozeni,@AdrTrvUlice,@AdrTrvOrCislo,@AdrTrvPopCislo,@AdrTrvMisto,@AdrTrvPSC,
@AdrTrvZeme,@AdrPrechUlice,@AdrPrechOrCislo,@AdrPrechPopCislo,@AdrPrechMisto,@AdrPrechPSC,
@AdrPrechZeme,@StatniPrislus,@Narodnost,@RodinnyStav,
@CisloOP,@PlatnostOP,@CisloPasu,@PlatnostPasu,@PasVydal,@PasVydal_Zeme,@CisloRP,@SkupinaRP,@PlatnostRP,@SSN,
@PovoleniKPobytu,@AdrKontJmeno,@AdrKontPrijmeni,@AdrKontUlice,@AdrKontOrCislo,
@AdrKontPopCislo,@AdrKontMisto,@AdrKontPSC,@AdrKontZeme,@KodZdrPojAVA, @CisloPojistenceAVA, @OsobniIC,
@Ciz_Doklad_Typ,@Ciz_Doklad_Cislo,@Ciz_Doklad_Vydal,@Ciz_Doklad_Vydal_Zeme,@AdrRez_Ulice,
@AdrRez_OrCislo,@AdrRez_PopCislo,@AdrRez_Misto,@AdrRez_PSC,@AdrRez_Zeme
END
IF UPDATE(Obrazek)
BEGIN
UPDATE z
SET z.Obrazek = i.Obrazek
FROM TabCisZam z
JOIN TabCisZam i ON i.RodneCislo = z.RodneCislo AND z.ID <> i.ID
WHERE i.ID = @ID AND z.VyraditZPrehledu = 1 
AND ISNULL((SELECT m.StavEs FROM TabZamMzd m WHERE m.ZamestnanecID = z.ID AND m.IdObdobi=(SELECT IdObdobi FROM TabMzdObd WHERE Stav = 1)), 10) NOT IN (3, 10)
END
END
CLOSE cProp
DEALLOCATE cProp
GO
