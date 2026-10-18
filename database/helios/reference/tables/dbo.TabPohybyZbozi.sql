-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPohybyZbozi](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDZboSklad] [int] NOT NULL,
	[IDDoklad] [int] NOT NULL,
	[IDOldDoklad] [int] NULL,
	[SkupZbo] [nvarchar](3) NOT NULL,
	[RegCis] [nvarchar](30) NOT NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[Nazev2] [nvarchar](100) NOT NULL,
	[Nazev3] [nvarchar](100) NOT NULL,
	[Nazev4] [nvarchar](100) NOT NULL,
	[SKP] [nvarchar](50) NOT NULL,
	[NazevSozNa1] [nvarchar](100) NOT NULL,
	[NazevSozNa2] [nvarchar](100) NOT NULL,
	[NazevSozNa3] [nvarchar](100) NOT NULL,
	[Popis4] [nvarchar](100) NOT NULL,
	[CisloZakazky] [nvarchar](15) NULL,
	[IDVozidlo] [int] NULL,
	[CisloZam] [int] NULL,
	[MJ] [nvarchar](10) NULL,
	[MJEvidence] [nvarchar](10) NULL,
	[PrepMnozstvi] [float] NOT NULL,
	[Mena] [nvarchar](3) NULL,
	[Kurz] [numeric](19, 6) NOT NULL,
	[JednotkaMeny] [int] NOT NULL,
	[KurzEuro] [numeric](19, 6) NOT NULL,
	[SazbaDPH] [numeric](5, 2) NULL,
	[SazbaDPHHlavicky] [numeric](5, 2) NULL,
	[SazbaSD] [numeric](19, 6) NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[VraceneMnozstvi] [numeric](19, 6) NOT NULL,
	[MnOdebrane] [numeric](19, 6) NOT NULL,
	[MnozstviStorno] [numeric](19, 6) NOT NULL,
	[MnozstviReal] [numeric](19, 6) NOT NULL,
	[MnOdebraneReal] [numeric](19, 6) NOT NULL,
	[MnozstviStornoReal] [numeric](19, 6) NOT NULL,
	[SlevaSkupZbo] [numeric](5, 2) NOT NULL,
	[SlevaZboKmen] [numeric](5, 2) NOT NULL,
	[SlevaZboSklad] [numeric](5, 2) NOT NULL,
	[SlevaOrg] [numeric](5, 2) NOT NULL,
	[SlevaSozNa] [numeric](5, 2) NOT NULL,
	[VstupniCena] [tinyint] NOT NULL,
	[JCbezDaniKC] [numeric](19, 6) NOT NULL,
	[JCsSDKc] [numeric](19, 6) NOT NULL,
	[JCsDPHKc] [numeric](19, 6) NOT NULL,
	[JCbezDaniVal] [numeric](19, 6) NOT NULL,
	[JCsSDVal] [numeric](19, 6) NOT NULL,
	[JCsDPHVal] [numeric](19, 6) NOT NULL,
	[JCbezDaniKcPoS] [numeric](19, 6) NOT NULL,
	[JCsSDKcPoS] [numeric](19, 6) NOT NULL,
	[JCsDPHKcPoS] [numeric](19, 6) NOT NULL,
	[JCbezDaniValPoS] [numeric](19, 6) NOT NULL,
	[JCsSDValPoS] [numeric](19, 6) NOT NULL,
	[JCsDPHValPoS] [numeric](19, 6) NOT NULL,
	[CCbezDaniKc] [numeric](19, 6) NOT NULL,
	[CCsSDKc] [numeric](19, 6) NOT NULL,
	[CCsDPHKc] [numeric](19, 6) NOT NULL,
	[CCbezDaniVal] [numeric](19, 6) NOT NULL,
	[CCsSDVal] [numeric](19, 6) NOT NULL,
	[CCsDPHVal] [numeric](19, 6) NOT NULL,
	[CCbezDaniKcPoS] [numeric](19, 6) NOT NULL,
	[CCsSDKcPoS] [numeric](19, 6) NOT NULL,
	[CCsDPHKcPoS] [numeric](19, 6) NOT NULL,
	[CCbezDaniValPoS] [numeric](19, 6) NOT NULL,
	[CCsSDValPoS] [numeric](19, 6) NOT NULL,
	[CCsDPHValPoS] [numeric](19, 6) NOT NULL,
	[CCevid] [numeric](19, 6) NOT NULL,
	[CCevidSN] [numeric](19, 6) NOT NULL,
	[AltCena] [numeric](19, 6) NOT NULL,
	[CCevidPozadovana] [numeric](19, 6) NOT NULL,
	[NastaveniSlev] [smallint] NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[EvMnozstvi] [numeric](19, 6) NOT NULL,
	[EvStav] [numeric](19, 6) NOT NULL,
	[Obal] [int] NULL,
	[CisloNOkruh] [nvarchar](15) NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[IDPrikaz] [int] NULL,
	[IDOldPolozka] [int] NULL,
	[CisloOrg] [int] NULL,
	[DruhPohybuZbo] [tinyint] NOT NULL,
	[JCZadaneDPHKc] [numeric](19, 6) NULL,
	[CCZadaneDPHKc] [numeric](19, 6) NULL,
	[JCZadaneDPHKcPoS] [numeric](19, 6) NULL,
	[CCZadaneDPHKcPoS] [numeric](19, 6) NULL,
	[JCZadaneDPHVal] [numeric](19, 6) NULL,
	[CCZadaneDPHVal] [numeric](19, 6) NULL,
	[JCZadaneDPHValPoS] [numeric](19, 6) NULL,
	[CCZadaneDPHValPoS] [numeric](19, 6) NULL,
	[PotvrzDatDod] [datetime] NULL,
	[PozadDatDod] [datetime] NULL,
	[DokladPrikazu] [int] NULL,
	[Hmotnost] [numeric](19, 6) NOT NULL,
	[ZemePuvodu] [nvarchar](2) NULL,
	[ZemePreference] [nvarchar](3) NOT NULL,
	[IDAkce] [int] NULL,
	[StredNaklad] [nvarchar](30) NULL,
	[SkutecneDatReal] [datetime] NULL,
	[ZemeOdeslani] [nvarchar](2) NULL,
	[JCDID] [int] NULL,
	[IdPolJCD] [int] NULL,
	[IdPolNCTS] [int] NULL,
	[Lokace] [nvarchar](50) NULL,
	[MnozstviObalu] [int] NOT NULL,
	[KodBaleni] [nvarchar](8) NOT NULL,
	[CisloEUR1] [nvarchar](35) NULL,
	[CisloLicence] [nvarchar](28) NOT NULL,
	[CisloJCD] [nvarchar](23) NULL,
	[PorCisloPolJCD] [int] NULL,
	[DatumProjednaniJCD] [datetime] NULL,
	[DodaciPodminka] [nvarchar](3) NULL,
	[KurzJCD] [numeric](19, 6) NULL,
	[HmotnostBrutto] [numeric](19, 6) NOT NULL,
	[Lhuta] [datetime] NULL,
	[PCDCislo] [nvarchar](23) NULL,
	[PCDPorCisloPol] [int] NULL,
	[PCDDatum] [datetime] NULL,
	[BarCode] [nvarchar](50) NULL,
	[TypVyrobnihoDokladu] [tinyint] NULL,
	[KJKontrolovat] [bit] NOT NULL,
	[KJSkontrolovano] [bit] NOT NULL,
	[PocetZmetku] [numeric](19, 6) NOT NULL,
	[TerminSlevaProc] [numeric](5, 2) NOT NULL,
	[TerminSlevaNazev] [nvarchar](50) NOT NULL,
	[SlevaCastka] [numeric](19, 6) NOT NULL,
	[IdUmisteni] [int] NULL,
	[FMonthMsgPohyby] [int] NULL,
	[ZamknoutCenu] [bit] NOT NULL,
	[SkutecnaSazbaDPH]  AS ([SazbaDPH]),
	[JCevid]  AS (CONVERT([numeric](19,6),case when isnull([MnozstviReal],(0))>(0) then [CCevid]/[MnozstviReal] else (0) end,0)),
	[JCevidSN]  AS (CONVERT([numeric](19,6),case when isnull([MnozstviReal],(0))>(0) then [CCevidSN]/[MnozstviReal] else (0) end,0)),
	[SlevaPolozkyKc]  AS ([CCbezDaniKc]-[CCbezDaniKcPoS]),
	[CCevidUcto]  AS (isnull(round([CCevid],(2)),(0))),
	[CCevidSNDruh]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCevidSN] else [CCevidSN] end),
	[Prevedeno]  AS (CONVERT([bit],case when [IDOldDoklad] IS NULL then (0) else (1) end,0)),
	[JeObal]  AS (CONVERT([bit],case when [Obal] IS NULL then (0) else (1) end,0)),
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni],0),0),0)),
	[DatZmeny_D]  AS (datepart(day,[DatZmeny])),
	[DatZmeny_M]  AS (datepart(month,[DatZmeny])),
	[DatZmeny_Y]  AS (datepart(year,[DatZmeny])),
	[DatZmeny_Q]  AS (datepart(quarter,[DatZmeny])),
	[DatZmeny_W]  AS (datepart(week,[DatZmeny])),
	[DatZmeny_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatZmeny],0),0),0)),
	[MnozstviDruhove]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[Mnozstvi] else [Mnozstvi] end),
	[MnozstviZvyseni]  AS (case when [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(0) then CONVERT([numeric](19,6),[Mnozstvi],0)  end),
	[MnozstviSnizeni]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) then CONVERT([numeric](19,6),[Mnozstvi],0)  end),
	[CCsDPHKcPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCsDPHKcPoS] else [CCsDPHKcPoS] end),
	[CCsDPHKcPoSZvyseni]  AS (case when [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(0) then CONVERT([numeric](19,6),[CCsDPHKcPoS],0)  end),
	[CCsDPHKcPoSSnizeni]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) then CONVERT([numeric](19,6),[CCsDPHKcPoS],0)  end),
	[CCsDPHValPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCsDPHValPoS] else [CCsDPHValPoS] end),
	[CCbezDaniKcPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCbezDaniKcPoS] else [CCbezDaniKcPoS] end),
	[CCbezDaniKcPoSZvyseni]  AS (case when [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(0) then [CCbezDaniKcPoS]  end),
	[CCbezDaniKcPoSSnizeni]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) then [CCbezDaniKcPoS]  end),
	[CCbezDaniValPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCbezDaniValPoS] else [CCbezDaniValPoS] end),
	[CCsSDKcPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCsSDKcPoS] else [CCsSDKcPoS] end),
	[CCsSDKcPoSZvyseni]  AS (case when [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(0) then CONVERT([numeric](19,6),[CCsSDKcPoS],0)  end),
	[CCsSDKcPoSSnizeni]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) then CONVERT([numeric](19,6),[CCsSDKcPoS],0)  end),
	[CCsSDValPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCsSDValPoS] else [CCsSDValPoS] end),
	[CCevidDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[CCevid] else [CCevid] end),
	[CCevidZvyseni]  AS (case when [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(0) then CONVERT([numeric](19,6),[CCevid],0)  end),
	[CCevidSnizeni]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) then CONVERT([numeric](19,6),[CCevid],0)  end),
	[PotvrzDatDod_D]  AS (datepart(day,[PotvrzDatDod])),
	[PotvrzDatDod_M]  AS (datepart(month,[PotvrzDatDod])),
	[PotvrzDatDod_Y]  AS (datepart(year,[PotvrzDatDod])),
	[PotvrzDatDod_Q]  AS (datepart(quarter,[PotvrzDatDod])),
	[PotvrzDatDod_W]  AS (datepart(week,[PotvrzDatDod])),
	[PotvrzDatDod_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PotvrzDatDod],0),0),0)),
	[PozadDatDod_D]  AS (datepart(day,[PozadDatDod])),
	[PozadDatDod_M]  AS (datepart(month,[PozadDatDod])),
	[PozadDatDod_Y]  AS (datepart(year,[PozadDatDod])),
	[PozadDatDod_Q]  AS (datepart(quarter,[PozadDatDod])),
	[PozadDatDod_W]  AS (datepart(week,[PozadDatDod])),
	[PozadDatDod_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PozadDatDod],0),0),0)),
	[SkutecneDatReal_D]  AS (datepart(day,[SkutecneDatReal])),
	[SkutecneDatReal_M]  AS (datepart(month,[SkutecneDatReal])),
	[SkutecneDatReal_Y]  AS (datepart(year,[SkutecneDatReal])),
	[SkutecneDatReal_Q]  AS (datepart(quarter,[SkutecneDatReal])),
	[SkutecneDatReal_W]  AS (datepart(week,[SkutecneDatReal])),
	[SkutecneDatReal_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[SkutecneDatReal],0),0),0)),
	[DatumProjednaniJCD_D]  AS (datepart(day,[DatumProjednaniJCD])),
	[DatumProjednaniJCD_M]  AS (datepart(month,[DatumProjednaniJCD])),
	[DatumProjednaniJCD_Y]  AS (datepart(year,[DatumProjednaniJCD])),
	[DatumProjednaniJCD_Q]  AS (datepart(quarter,[DatumProjednaniJCD])),
	[DatumProjednaniJCD_W]  AS (datepart(week,[DatumProjednaniJCD])),
	[DatumProjednaniJCD_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumProjednaniJCD],0),0),0)),
	[Lhuta_D]  AS (datepart(day,[Lhuta])),
	[Lhuta_M]  AS (datepart(month,[Lhuta])),
	[Lhuta_Y]  AS (datepart(year,[Lhuta])),
	[Lhuta_Q]  AS (datepart(quarter,[Lhuta])),
	[Lhuta_W]  AS (datepart(week,[Lhuta])),
	[Lhuta_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Lhuta],0),0),0)),
	[PCDDatum_D]  AS (datepart(day,[PCDDatum])),
	[PCDDatum_M]  AS (datepart(month,[PCDDatum])),
	[PCDDatum_Y]  AS (datepart(year,[PCDDatum])),
	[PCDDatum_Q]  AS (datepart(quarter,[PCDDatum])),
	[PCDDatum_W]  AS (datepart(week,[PCDDatum])),
	[PCDDatum_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PCDDatum],0),0),0)),
	[SazbaDPHproPDP] [numeric](5, 2) NULL,
	[IDOZTxtPol] [int] NULL,
	[Poradi] [int] NULL,
	[IDZakazModif] [int] NULL,
	[SamoVyDPHZaklad] [numeric](19, 6) NULL,
	[SamoVyDPHCastka] [numeric](19, 6) NULL,
	[SamoVyDPHZakladHM] [numeric](19, 6) NULL,
	[SamoVyDPHCastkaHM] [numeric](19, 6) NULL,
	[MnozOdebrane] [numeric](19, 6) NOT NULL,
	[IDCiloveTxtPol] [int] NULL,
	[MnozstviRPT] [numeric](19, 6) NOT NULL,
	[MJKV] [int] NULL,
	[MnozstviKV] [numeric](19, 6) NOT NULL,
	[DruhSazbyDPH] [tinyint] NULL,
	[SamoVyDPHRucneZadano] [bit] NOT NULL,
	[RezimPDP]  AS (CONVERT([bit],case when [SazbaDPHproPDP] IS NULL then (0) else (1) end,(0))),
	[IDKodPDP] [int] NULL,
	[IDDanovyKlic] [int] NULL,
	[JCbezDaniKcPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[JCbezDaniKcPoS] else [JCbezDaniKcPoS] end),
	[JCsDPHKcPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[JCsDPHKcPoS] else [JCsDPHKcPoS] end),
	[JCbezDaniValPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[JCbezDaniValPoS] else [JCbezDaniValPoS] end),
	[JCsDPHValPoSDruhova]  AS (case when [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(25) OR [DruhPohybuZbo]=(26) then  -[JCsDPHValPoS] else [JCsDPHValPoS] end),
	[EET_dic_poverujiciho] [nvarchar](12) NULL,
	[DruhEET] [tinyint] NOT NULL,
	[Zisk] [numeric](19, 6) NULL,
	[Marze] [numeric](5, 2) NULL,
	[ObchPrirazka] [numeric](19, 6) NULL,
	[PlZisk] [numeric](19, 6) NULL,
	[PlMarze] [numeric](5, 2) NULL,
	[PlObchPrirazka] [numeric](19, 6) NULL,
	[ZdrojNC] [tinyint] NULL,
	[ZdrojNCSl] [tinyint] NULL,
	[HraniceMarze] [numeric](5, 2) NULL,
	[NCMarze] [numeric](19, 6) NOT NULL,
	[PomerKoef] [numeric](19, 6) NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[JeSN] [bit] NOT NULL,
	[SplnenoPol] [bit] NOT NULL,
	[SplnenoHlava] [bit] NOT NULL,
	[Splneno]  AS (CONVERT([bit],case [SplnenoPol]|[SplnenoHlava] when (0) then (0) else (1) end,(0))),
	[PouzitoMajetek] [bit] NOT NULL,
	[PouzitoSklad] [bit] NOT NULL,
	[SkutDatRealMnoz] [datetime] NULL,
	[CisloKarty]  AS ([SkupZbo]+[RegCis]),
	[SkutDatRealMnoz_D]  AS (datepart(day,[SkutDatRealMnoz])),
	[SkutDatRealMnoz_M]  AS (datepart(month,[SkutDatRealMnoz])),
	[SkutDatRealMnoz_Y]  AS (datepart(year,[SkutDatRealMnoz])),
	[SkutDatRealMnoz_Q]  AS (datepart(quarter,[SkutDatRealMnoz])),
	[SkutDatRealMnoz_W]  AS (datepart(week,[SkutDatRealMnoz])),
	[SkutDatRealMnoz_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[SkutDatRealMnoz])))),
	[PrimarniCena]  AS (case [VstupniCena] when (0) then [JCbezDaniKC] when (1) then [JCsDPHKc] when (2) then [CCbezDaniKc] when (3) then [CCsDPHKc] when (4) then [JCbezDaniVal] when (5) then [JCsDPHVal] when (6) then [CCbezDaniVal] when (7) then [CCsDPHVal] when (8) then [JCsSDKc] when (9) then [CCsSDKc] when (10) then [JCsSDVal] when (11) then [CCsSDVal]  end),
	[NastaveniSlevaSozNa]  AS (case when ([NastaveniSlev]&(4096))<>(0) then (1) when ([NastaveniSlev]&(8192))<>(0) then (2) when ([NastaveniSlev]&(16384))<>(0) then (3)  end),
	[NastaveniSlevaSkupZbo]  AS (case when ([NastaveniSlev]&(512))<>(0) then (1) when ([NastaveniSlev]&(1024))<>(0) then (2) when ([NastaveniSlev]&(2048))<>(0) then (3)  end),
	[NastaveniSlevaZboKmen]  AS (case when ([NastaveniSlev]&(8))<>(0) then (1) when ([NastaveniSlev]&(16))<>(0) then (2) when ([NastaveniSlev]&(32))<>(0) then (3)  end),
	[NastaveniSlevaZboSklad]  AS (case when ([NastaveniSlev]&(1))<>(0) then (1) when ([NastaveniSlev]&(2))<>(0) then (2) when ([NastaveniSlev]&(4))<>(0) then (3)  end),
	[NastaveniSlevaOrg]  AS (case when ([NastaveniSlev]&(64))<>(0) then (1) when ([NastaveniSlev]&(128))<>(0) then (2) when ([NastaveniSlev]&(256))<>(0) then (3)  end),
	[ZadaneDPH]  AS (case [VstupniCena] when (0) then [JCZadaneDPHKc] when (1) then [JCZadaneDPHKc] when (2) then [CCZadaneDPHKc] when (3) then [CCZadaneDPHKc] when (4) then [JCZadaneDPHVal] when (5) then [JCZadaneDPHVal] when (6) then [CCZadaneDPHVal] when (7) then [CCZadaneDPHVal] when (8) then [JCZadaneDPHKc] when (9) then [CCZadaneDPHKc] when (10) then [JCZadaneDPHVal] when (11) then [CCZadaneDPHVal]  end),
	[DSNPolozkyFaktury] [numeric](19, 6) NULL,
	[MnFakOdebrane] [numeric](19, 6) NOT NULL,
	[MnozFakOdebrane] [numeric](19, 6) NOT NULL,
	[SystemRowVersion] [timestamp] NOT NULL,
	[SystemRowVersionText]  AS (CONVERT([nvarchar](16),CONVERT([binary](8),[SystemRowVersion]),(2))),
	[CCbezDaniKcPoS_KorZal] [numeric](19, 6) NOT NULL,
	[CCsDPHKcPoS_KorZal] [numeric](19, 6) NOT NULL,
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
	[CCDanKcPoS_KorZal]  AS ([CCsDPHKcPoS_KorZal]-[CCbezDaniKcPoS_KorZal]),
	[AVAItemOutputFlag] [tinyint] NOT NULL,
	[AVASentDate] [datetime] NULL,
	[AVASentDate_D]  AS (datepart(day,[AVASentDate])),
	[AVASentDate_M]  AS (datepart(month,[AVASentDate])),
	[AVASentDate_Y]  AS (datepart(year,[AVASentDate])),
	[AVASentDate_Q]  AS (datepart(quarter,[AVASentDate])),
	[AVASentDate_W]  AS (datepart(week,[AVASentDate])),
	[AVASentDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVASentDate])))),
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
	[UcetZalohyZaklad] [nvarchar](30) NULL,
	[KodKV] [nvarchar](4) NOT NULL,
 CONSTRAINT [PK__TabPohybyZbozi__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPohybyZbozi__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__AVAExternalID]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__AVAExternalID] ON [dbo].[TabPohybyZbozi]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__DatPorizeni]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__DatPorizeni] ON [dbo].[TabPohybyZbozi]
(
	[DatPorizeni] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__DruhPohybuZbo]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__DruhPohybuZbo] ON [dbo].[TabPohybyZbozi]
(
	[DruhPohybuZbo] ASC
)
INCLUDE([ID],[IDZboSklad],[IDDoklad],[PrepMnozstvi],[Mnozstvi]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__DruhPohybuZbo__CisloJCD]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__DruhPohybuZbo__CisloJCD] ON [dbo].[TabPohybyZbozi]
(
	[DruhPohybuZbo] ASC,
	[CisloJCD] ASC
)
INCLUDE([IDZboSklad],[IDDoklad],[Mena],[Mnozstvi],[MnOdebrane],[MnozstviStorno],[CCbezDaniVal],[PorCisloPolJCD],[DatumProjednaniJCD_X]) 
WHERE ([DruhPohybuZbo]=(24))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDCiloveTxtPol]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDCiloveTxtPol] ON [dbo].[TabPohybyZbozi]
(
	[IDCiloveTxtPol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDDoklad]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDDoklad] ON [dbo].[TabPohybyZbozi]
(
	[IDDoklad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDDoklad__IdPolNCTS]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDDoklad__IdPolNCTS] ON [dbo].[TabPohybyZbozi]
(
	[IDDoklad] ASC,
	[IdPolNCTS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDDoklad__Mnozstvi]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDDoklad__Mnozstvi] ON [dbo].[TabPohybyZbozi]
(
	[IDDoklad] ASC,
	[Mnozstvi] ASC
)
INCLUDE([MnOdebrane],[MnozstviStorno]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDDoklad__Poradi]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDDoklad__Poradi] ON [dbo].[TabPohybyZbozi]
(
	[IDDoklad] ASC,
	[Poradi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDOldDoklad]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDOldDoklad] ON [dbo].[TabPohybyZbozi]
(
	[IDOldDoklad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDOldPolozka]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDOldPolozka] ON [dbo].[TabPohybyZbozi]
(
	[IDOldPolozka] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDOZTxtPol]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDOZTxtPol] ON [dbo].[TabPohybyZbozi]
(
	[IDOZTxtPol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IdPolJCD]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IdPolJCD] ON [dbo].[TabPohybyZbozi]
(
	[IdPolJCD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IdPolNCTS]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IdPolNCTS] ON [dbo].[TabPohybyZbozi]
(
	[IdPolNCTS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDZboSklad]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDZboSklad] ON [dbo].[TabPohybyZbozi]
(
	[IDZboSklad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDZboSklad__CCevid]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDZboSklad__CCevid] ON [dbo].[TabPohybyZbozi]
(
	[IDZboSklad] ASC,
	[CCevid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDZboSklad__DruhPohybuZbo__Mnozstvi__MnOdebrane]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDZboSklad__DruhPohybuZbo__Mnozstvi__MnOdebrane] ON [dbo].[TabPohybyZbozi]
(
	[IDZboSklad] ASC,
	[DruhPohybuZbo] ASC,
	[Mnozstvi] ASC,
	[MnOdebrane] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDZboSklad__DruhPohybuZbo__MnozstviReal]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDZboSklad__DruhPohybuZbo__MnozstviReal] ON [dbo].[TabPohybyZbozi]
(
	[IDZboSklad] ASC,
	[DruhPohybuZbo] ASC,
	[MnozstviReal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__IDZboSklad__IDDoklad]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__IDZboSklad__IDDoklad] ON [dbo].[TabPohybyZbozi]
(
	[IDZboSklad] ASC,
	[IDDoklad] ASC
)
INCLUDE([CCevid],[MnozstviReal],[EvMnozstvi],[EvStav]) 
WHERE ([DruhPohybuZbo]<(5))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__Mena]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__Mena] ON [dbo].[TabPohybyZbozi]
(
	[Mena] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__MJ]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__MJ] ON [dbo].[TabPohybyZbozi]
(
	[MJ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__Obal]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__Obal] ON [dbo].[TabPohybyZbozi]
(
	[Obal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPohybyZbozi__TypVyrobnihoDokladu__IDPrikaz__DokladPrikazu]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPohybyZbozi__TypVyrobnihoDokladu__IDPrikaz__DokladPrikazu] ON [dbo].[TabPohybyZbozi]
(
	[TypVyrobnihoDokladu] ASC,
	[IDPrikaz] ASC,
	[DokladPrikazu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__NazevSozNa1]  DEFAULT ('') FOR [NazevSozNa1]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__NazevSozNa2]  DEFAULT ('') FOR [NazevSozNa2]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__NazevSozNa3]  DEFAULT ('') FOR [NazevSozNa3]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__Popis4]  DEFAULT ('') FOR [Popis4]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__PrepMnozstvi]  DEFAULT ((1.0)) FOR [PrepMnozstvi]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__Kurz]  DEFAULT ((1.0)) FOR [Kurz]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JednotkaMeny]  DEFAULT ((1)) FOR [JednotkaMeny]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__KurzEuro]  DEFAULT ((0)) FOR [KurzEuro]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SazbaSD]  DEFAULT ((0.0)) FOR [SazbaSD]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__VraceneMnozstvi]  DEFAULT ((0.0)) FOR [VraceneMnozstvi]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnOdebrane]  DEFAULT ((0.0)) FOR [MnOdebrane]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviStorno]  DEFAULT ((0.0)) FOR [MnozstviStorno]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviReal]  DEFAULT ((0.0)) FOR [MnozstviReal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnOdebraneReal]  DEFAULT ((0.0)) FOR [MnOdebraneReal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviStornoReal]  DEFAULT ((0.0)) FOR [MnozstviStornoReal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaSkupZbo]  DEFAULT ((0.0)) FOR [SlevaSkupZbo]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaZboKmen]  DEFAULT ((0.0)) FOR [SlevaZboKmen]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaZboSklad]  DEFAULT ((0.0)) FOR [SlevaZboSklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaOrg]  DEFAULT ((0.0)) FOR [SlevaOrg]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaSozNa]  DEFAULT ((0.0)) FOR [SlevaSozNa]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__VstupniCena]  DEFAULT ((0)) FOR [VstupniCena]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCbezDaniKC]  DEFAULT ((0.0)) FOR [JCbezDaniKC]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsSDKc]  DEFAULT ((0.0)) FOR [JCsSDKc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsDPHKc]  DEFAULT ((0.0)) FOR [JCsDPHKc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCbezDaniVal]  DEFAULT ((0.0)) FOR [JCbezDaniVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsSDVal]  DEFAULT ((0.0)) FOR [JCsSDVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsDPHVal]  DEFAULT ((0.0)) FOR [JCsDPHVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCbezDaniKcPoS]  DEFAULT ((0.0)) FOR [JCbezDaniKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsSDKcPoS]  DEFAULT ((0.0)) FOR [JCsSDKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsDPHKcPoS]  DEFAULT ((0.0)) FOR [JCsDPHKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCbezDaniValPoS]  DEFAULT ((0.0)) FOR [JCbezDaniValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsSDValPoS]  DEFAULT ((0.0)) FOR [JCsSDValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JCsDPHValPoS]  DEFAULT ((0.0)) FOR [JCsDPHValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCbezDaniKc]  DEFAULT ((0.0)) FOR [CCbezDaniKc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsSDKc]  DEFAULT ((0.0)) FOR [CCsSDKc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsDPHKc]  DEFAULT ((0.0)) FOR [CCsDPHKc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCbezDaniVal]  DEFAULT ((0.0)) FOR [CCbezDaniVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsSDVal]  DEFAULT ((0.0)) FOR [CCsSDVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsDPHVal]  DEFAULT ((0.0)) FOR [CCsDPHVal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCbezDaniKcPoS]  DEFAULT ((0.0)) FOR [CCbezDaniKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsSDKcPoS]  DEFAULT ((0.0)) FOR [CCsSDKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsDPHKcPoS]  DEFAULT ((0.0)) FOR [CCsDPHKcPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCbezDaniValPoS]  DEFAULT ((0.0)) FOR [CCbezDaniValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsSDValPoS]  DEFAULT ((0.0)) FOR [CCsSDValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsDPHValPoS]  DEFAULT ((0.0)) FOR [CCsDPHValPoS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCevid]  DEFAULT ((0.0)) FOR [CCevid]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCevidSN]  DEFAULT ((0.0)) FOR [CCevidSN]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__AltCena]  DEFAULT ((0.0)) FOR [AltCena]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCevidPozadovana]  DEFAULT ((0.0)) FOR [CCevidPozadovana]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__NastaveniSlev]  DEFAULT ((4681)) FOR [NastaveniSlev]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__EvMnozstvi]  DEFAULT ((0.0)) FOR [EvMnozstvi]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__EvStav]  DEFAULT ((0.0)) FOR [EvStav]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__Hmotnost]  DEFAULT ((0.0)) FOR [Hmotnost]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__ZemePreference]  DEFAULT ('') FOR [ZemePreference]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviObalu]  DEFAULT ((0.0)) FOR [MnozstviObalu]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__KodBaleni]  DEFAULT ('') FOR [KodBaleni]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CisloLicence]  DEFAULT ('') FOR [CisloLicence]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__HmotnostBrutto]  DEFAULT ((0.0)) FOR [HmotnostBrutto]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__KJKontrolovat]  DEFAULT ((0)) FOR [KJKontrolovat]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__KJSkontrolovano]  DEFAULT ((0)) FOR [KJSkontrolovano]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__PocetZmetku]  DEFAULT ((0.0)) FOR [PocetZmetku]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__TerminSlevaProc]  DEFAULT ((0.0)) FOR [TerminSlevaProc]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__TerminSlevaNazev]  DEFAULT ('') FOR [TerminSlevaNazev]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SlevaCastka]  DEFAULT ((0.0)) FOR [SlevaCastka]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__ZamknoutCenu]  DEFAULT ((0)) FOR [ZamknoutCenu]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozOdebrane]  DEFAULT ((0.0)) FOR [MnozOdebrane]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviRPT]  DEFAULT ((0)) FOR [MnozstviRPT]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozstviKV]  DEFAULT ((0.0)) FOR [MnozstviKV]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SamoVyDPHRucneZadano]  DEFAULT ((0)) FOR [SamoVyDPHRucneZadano]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__DruhEET]  DEFAULT ((1)) FOR [DruhEET]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__NCMarze]  DEFAULT ((0.0)) FOR [NCMarze]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__JeSN]  DEFAULT ((0)) FOR [JeSN]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SplnenoPol]  DEFAULT ((0)) FOR [SplnenoPol]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__SplnenoHlava]  DEFAULT ((0)) FOR [SplnenoHlava]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__PouzitoMajetek]  DEFAULT ((0)) FOR [PouzitoMajetek]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__PouzitoSklad]  DEFAULT ((0)) FOR [PouzitoSklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__DSNPolozkyFaktury]  DEFAULT ((0.0)) FOR [DSNPolozkyFaktury]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnFakOdebrane]  DEFAULT ((0.0)) FOR [MnFakOdebrane]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__MnozFakOdebrane]  DEFAULT ((0.0)) FOR [MnozFakOdebrane]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCbezDaniKcPoS_KorZal]  DEFAULT ((0.0)) FOR [CCbezDaniKcPoS_KorZal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__CCsDPHKcPoS_KorZal]  DEFAULT ((0.0)) FOR [CCsDPHKcPoS_KorZal]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__AVAItemOutputFlag]  DEFAULT ((0)) FOR [AVAItemOutputFlag]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ADD  CONSTRAINT [DF__TabPohybyZbozi__KodKV]  DEFAULT ('') FOR [KodKV]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__BarCode] FOREIGN KEY([BarCode])
REFERENCES [dbo].[TabBarCodeZbo] ([BarCode])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__BarCode]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__CisloNOkruh] FOREIGN KEY([CisloNOkruh])
REFERENCES [dbo].[TabNakladovyOkruh] ([Cislo])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__CisloNOkruh]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__CisloZakazky] FOREIGN KEY([CisloZakazky])
REFERENCES [dbo].[TabZakazka] ([CisloZakazky])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__CisloZakazky]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__CisloZam] FOREIGN KEY([CisloZam])
REFERENCES [dbo].[TabCisZam] ([Cislo])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__CisloZam]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__FMonthMsgPohyby] FOREIGN KEY([FMonthMsgPohyby])
REFERENCES [dbo].[TabIntrMonthMsgPohyby] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__FMonthMsgPohyby]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDAkce] FOREIGN KEY([IDAkce])
REFERENCES [dbo].[TabAkce] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDAkce]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDCiloveTxtPol] FOREIGN KEY([IDCiloveTxtPol])
REFERENCES [dbo].[TabOZTxtPol] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDCiloveTxtPol]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDDanovyKlic] FOREIGN KEY([IDDanovyKlic])
REFERENCES [dbo].[TabDanoveKlice] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDDanovyKlic]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDDoklad] FOREIGN KEY([IDDoklad])
REFERENCES [dbo].[TabDokladyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDDoklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDKodPDP] FOREIGN KEY([IDKodPDP])
REFERENCES [dbo].[TabCisKoduPDP] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDKodPDP]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDOZTxtPol] FOREIGN KEY([IDOZTxtPol])
REFERENCES [dbo].[TabOZTxtPol] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDOZTxtPol]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IdPolJCD] FOREIGN KEY([IdPolJCD])
REFERENCES [dbo].[TabJCDPohyby] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IdPolJCD]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IdPolNCTS] FOREIGN KEY([IdPolNCTS])
REFERENCES [dbo].[TabNCTSPohyby] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IdPolNCTS]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IdUmisteni] FOREIGN KEY([IdUmisteni])
REFERENCES [dbo].[TabVStavUmisteni] ([Id])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IdUmisteni]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDVozidlo] FOREIGN KEY([IDVozidlo])
REFERENCES [dbo].[TabIVozidlo] ([id])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDVozidlo]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDZakazModif] FOREIGN KEY([IDZakazModif])
REFERENCES [dbo].[TabZakazModif] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDZakazModif]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__IDZboSklad] FOREIGN KEY([IDZboSklad])
REFERENCES [dbo].[TabStavSkladu] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__IDZboSklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__JCDID] FOREIGN KEY([JCDID])
REFERENCES [dbo].[TabJCD] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__JCDID]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__Mena] FOREIGN KEY([Mena])
REFERENCES [dbo].[TabKodMen] ([Kod])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__Mena]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__StredNaklad] FOREIGN KEY([StredNaklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__StredNaklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZbozi__UcetZalohyZaklad] FOREIGN KEY([UcetZalohyZaklad])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [FK__TabPohybyZbozi__UcetZalohyZaklad]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__AVAItemOutputFlag] CHECK  (([AVAItemOutputFlag]=(5) OR [AVAItemOutputFlag]=(4) OR [AVAItemOutputFlag]=(3) OR [AVAItemOutputFlag]=(2) OR [AVAItemOutputFlag]=(1) OR [AVAItemOutputFlag]=(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__AVAItemOutputFlag]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__DruhEET] CHECK  (([DruhEET]>=(0) AND [DruhEET]<=(4)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__DruhEET]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__DruhPohybuZbo] CHECK  (([DruhPohybuZbo]>=(0) AND [DruhPohybuZbo]<=(73)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__DruhPohybuZbo]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__DruhSazbyDPH] CHECK  (([DruhSazbyDPH]>=(0) AND [DruhSazbyDPH]<=(8)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__DruhSazbyDPH]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__JednotkaMeny] CHECK  (([JednotkaMeny]>(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__JednotkaMeny]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__Kurz] CHECK  (([Kurz]>(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__Kurz]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__MJKV] CHECK  (([MJKV]>=(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__MJKV]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__Poradi] CHECK  (([Poradi]>(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__Poradi]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__SazbaDPH] CHECK  (([SazbaDPHproPDP] IS NULL OR isnull([SazbaDPH],(0))=(0)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__SazbaDPH]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__SazbaDPHproPDP] CHECK  (([SazbaDPHproPDP] IS NULL OR ([DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(18) OR [DruhPohybuZbo]=(15) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(13) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(0))))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__SazbaDPHproPDP]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__VstupniCena] CHECK  (([VstupniCena]>=(0) AND [VstupniCena]<=(11)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__VstupniCena]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__ZdrojNC] CHECK  (([ZdrojNC]>=(0) AND [ZdrojNC]<=(3)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__ZdrojNC]
GO
ALTER TABLE [dbo].[TabPohybyZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabPohybyZbozi__ZdrojNCSl] CHECK  (([ZdrojNCSl]>=(0) AND [ZdrojNCSl]<=(4)))
GO
ALTER TABLE [dbo].[TabPohybyZbozi] CHECK CONSTRAINT [CK__TabPohybyZbozi__ZdrojNCSl]
GO
ALTER TABLE [dbo].[TabPohybyZbozi] ENABLE TRIGGER [ht_PohybyZbozi_Modify]
GO
