-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabRadyPrikazu](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Rada] [nvarchar](10) NOT NULL,
	[nazev] [nvarchar](100) NULL,
	[DruhPohybu_GenerRezVyd] [tinyint] NOT NULL,
	[RadaDokl_GenerRezVyd_Mat] [nvarchar](3) NULL,
	[RadaDokl_GenerRezVyd_Pol] [nvarchar](3) NULL,
	[DruhPohybu_prijem] [tinyint] NOT NULL,
	[RadaDokl_GenerVratky_Mat] [nvarchar](3) NULL,
	[RadaDokl_GenerVratky_Pol] [nvarchar](3) NULL,
	[RadaDokl_OdvedeniVedProd] [nvarchar](3) NULL,
	[RadaDokl_OdvedeniPrikazu] [nvarchar](3) NULL,
	[NekontrolovatMnozMatPol] [bit] NOT NULL,
	[NekontrolMnozOdvedVedProd] [bit] NOT NULL,
	[NekontrolMnozEvidMezd] [bit] NOT NULL,
	[NekontrolMnozOdvedFinal] [bit] NOT NULL,
	[KontrolovatVydMatPolNaOper] [bit] NOT NULL,
	[KontrolovatVydMatPolPriOdv] [tinyint] NOT NULL,
	[KontrolovatOdvedVyrOperPriOdv] [tinyint] NOT NULL,
	[KontrolovatOdvedVedProdPriOdv] [tinyint] NOT NULL,
	[KontrolavatUkonceniPredchOper] [tinyint] NOT NULL,
	[AutomatickeOceneniZmetku] [int] NOT NULL,
	[KontrolavatPokryMatProPrvOper] [tinyint] NOT NULL,
	[KontrolovatExistTechnolPos] [bit] NOT NULL,
	[KontrolovatExistKosovniku] [bit] NOT NULL,
	[KontrolovatRozpracPriUzav] [bit] NOT NULL,
	[KontrolPrevodOprZmetPriUzav] [bit] NOT NULL,
	[ZahrnoutRezOperMeziOdvadeci] [bit] NOT NULL,
	[AktualizacePrikazuPriZadani] [tinyint] NOT NULL,
	[PredvyplnitVyrCisPriVydeji] [tinyint] NOT NULL,
	[PredvyplnitVyrCisPriGenVrat] [bit] NOT NULL,
	[NacistVyrobniCislaZPozadavku] [bit] NOT NULL,
	[MaskaProGenVyrCis] [nvarchar](100) NULL,
	[PrednastavenyStavMezd] [tinyint] NOT NULL,
	[ZahrnoutDoKapacPlan] [bit] NOT NULL,
	[GenerovatPohybVyrCisel] [tinyint] NOT NULL,
	[KontrMnozOdebNaVyrCisPrKV] [bit] NOT NULL,
	[KontrMaxMnozVyrCisVyrPrik] [bit] NOT NULL,
	[TypOdvedeni] [tinyint] NOT NULL,
	[TypOdvedeni_PrimyPrev] [tinyint] NOT NULL,
	[RespekDatumPripPriVypocCeny] [bit] NOT NULL,
	[KontrCenuVyrPrijemPriReal] [bit] NOT NULL,
	[IDKalkVzorPlanOcen] [int] NULL,
	[IDKalkVzorSkutOcen] [int] NULL,
	[KontrZadaniKmenStred] [bit] NOT NULL,
	[KontrZadaniZakazky] [bit] NOT NULL,
	[ZdrojNakladStrediska] [tinyint] NOT NULL,
	[UKod] [int] NULL,
	[KontrolaZadaniUcetnihoKodu] [bit] NOT NULL,
	[ZdrojNakladStredProVydej] [tinyint] NOT NULL,
	[ZdrojNakladStredProPrijem] [tinyint] NOT NULL,
	[ZdrojNakladStredProPrijemVedPr] [tinyint] NOT NULL,
	[DotazNatstavPriznakTisku] [bit] NOT NULL,
	[RespekDatumPripPriVypocCenyVP] [bit] NOT NULL,
	[IDKalkVzorSkutOcenVedProd] [int] NULL,
	[GenerVydejVMJEvid] [bit] NOT NULL,
	[GenerVratkyVMJEvid] [bit] NOT NULL,
	[GenerOdvVedProdVMJEvid] [bit] NOT NULL,
	[GenerOdvVyrobkuVMJEvid] [bit] NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[PrednastavenyStavKoopMezd] [tinyint] NOT NULL,
	[IDNaklOkruh] [int] NULL,
	[TiskFormPrikaz] [int] NULL,
	[KontrolovatStavPracPomeruZam] [int] NOT NULL,
	[AktualizacePrikazuP_PriZadani] [bit] NOT NULL,
	[AktualizacePrikazuP_PriPredzpr] [bit] NOT NULL,
	[PredvyplnitVyrCisPriGenRezExp] [bit] NOT NULL,
	[NekontrolMnozEvidKoopMezd] [bit] NOT NULL,
	[KontrStavBlokaceDat] [int] NOT NULL,
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
	[RadaDokl_OdvedZmetNaSkladNesh] [nvarchar](3) NULL,
	[KontrOdvZmetNaSkladNesPriUzav] [bit] NOT NULL,
	[UprednostnitNakOkruhZPozadavku] [bit] NOT NULL,
	[ZdrojNakladStredProPrijZmetku] [tinyint] NOT NULL,
	[GenerPrijemZmetkuVMJEvid] [bit] NOT NULL,
	[VydejMatPol_SkladProGenHlavDZ] [nvarchar](30) NULL,
	[PrijemVedPr_SkladProGenHlavDZ] [nvarchar](30) NULL,
	[PrijemZmetku_SkladProGenHlavDZ] [nvarchar](30) NULL,
	[PrijemVyrDil_SkladProGenHlavDZ] [nvarchar](30) NULL,
	[KontrolMnozEvidVyrCisUMezd] [bit] NOT NULL,
	[KontrOdvedMnozVyrCisVyrPrik] [bit] NOT NULL,
	[PovolitZmenuDilcePriOdvedeni] [bit] NOT NULL,
	[PredvyplnitVyrCisPriPrijmuZmetku] [bit] NOT NULL,
	[DruhPohybu_FakPrijata] [tinyint] NOT NULL,
	[RadaDokl_GenerFakPrijateKoop] [nvarchar](3) NULL,
	[ZpusobOdvedeniDilceZVyroby] [tinyint] NOT NULL,
	[CilPrimehoPrevoduPolotovaru] [tinyint] NOT NULL,
	[DruhPohybu_GenerRezVyd_Pol] [tinyint] NOT NULL,
	[ZdrojTarifuProMzdy_Nor] [tinyint] NULL,
	[ZdrojTarifuProMzdy_Cas] [tinyint] NULL,
	[MzdovaSlozUkolMzd] [int] NULL,
	[EvidOp_PrednabizetZiveKusy] [int] NOT NULL,
	[EvidKoop_PrednabizetZiveKusy] [int] NOT NULL,
	[OvereniKontrolKPLVyr] [int] NOT NULL,
	[PovolitZamenuVyrCisVratkyPrKV] [bit] NOT NULL,
	[AutomatickeGenerovaniKPL] [bit] NOT NULL,
	[EvidRozpracOper_TypEvidMnoz] [tinyint] NOT NULL,
	[EvidRozpracOper_PrednabizetZiveMnoz] [tinyint] NOT NULL,
	[Blokovano] [tinyint] NOT NULL,
	[DruhPohybu_VydObj] [tinyint] NOT NULL,
	[RadaDokl_GenerZajisteniVydObj_Mat] [nvarchar](3) NULL,
	[VONeslucovatZaZakazku] [bit] NOT NULL,
	[UzavreneOperVyraditZKontrPosloupOper] [bit] NOT NULL,
	[NakladyZaZmetkyRozpDoDobrychKusu] [bit] NOT NULL,
	[AutoPrirazeniVyrCisPrKVNaVystupniVyrCis] [bit] NOT NULL,
	[MaskaProGenVyrCisVedProd] [nvarchar](100) NULL,
	[RadaDokladuDSNOdvedeniDoUbytku] [nvarchar](3) NULL,
	[DruhDSNOdvedeniDoUbytku] [tinyint] NULL,
	[TypDokladuProDSNOdvedeniDoUbytku] [tinyint] NOT NULL,
	[DruhPohybu_VydejVEvidCene] [tinyint] NOT NULL,
	[RadaDokl_GenerPrevodNaSkladProKooperanta] [nvarchar](3) NULL,
	[SkladProKooperanta] [nvarchar](30) NULL,
 CONSTRAINT [PK__TabRadyPrikazu__Rada] PRIMARY KEY CLUSTERED 
(
	[Rada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabRadyPrikazu__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_GenerRezVyd]  DEFAULT ((4)) FOR [DruhPohybu_GenerRezVyd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_prijem]  DEFAULT ((0)) FOR [DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NekontrolovatMnozMatPol]  DEFAULT ((0)) FOR [NekontrolovatMnozMatPol]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NekontrolMnozOdvedVedProd]  DEFAULT ((0)) FOR [NekontrolMnozOdvedVedProd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NekontrolMnozEvidMezd]  DEFAULT ((0)) FOR [NekontrolMnozEvidMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NekontrolMnozOdvedFinal]  DEFAULT ((0)) FOR [NekontrolMnozOdvedFinal]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatVydMatPolNaOper]  DEFAULT ((0)) FOR [KontrolovatVydMatPolNaOper]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatVydMatPolPriOdv]  DEFAULT ((0)) FOR [KontrolovatVydMatPolPriOdv]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatOdvedVyrOperPriOdv]  DEFAULT ((0)) FOR [KontrolovatOdvedVyrOperPriOdv]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatOdvedVedProdPriOdv]  DEFAULT ((0)) FOR [KontrolovatOdvedVedProdPriOdv]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolavatUkonceniPredchOper]  DEFAULT ((0)) FOR [KontrolavatUkonceniPredchOper]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AutomatickeOceneniZmetku]  DEFAULT ((1)) FOR [AutomatickeOceneniZmetku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolavatPokryMatProPrvOper]  DEFAULT ((0)) FOR [KontrolavatPokryMatProPrvOper]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatExistTechnolPos]  DEFAULT ((0)) FOR [KontrolovatExistTechnolPos]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatExistKosovniku]  DEFAULT ((0)) FOR [KontrolovatExistKosovniku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatRozpracPriUzav]  DEFAULT ((1)) FOR [KontrolovatRozpracPriUzav]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolPrevodOprZmetPriUzav]  DEFAULT ((0)) FOR [KontrolPrevodOprZmetPriUzav]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZahrnoutRezOperMeziOdvadeci]  DEFAULT ((1)) FOR [ZahrnoutRezOperMeziOdvadeci]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AktualizacePrikazuPriZadani]  DEFAULT ((0)) FOR [AktualizacePrikazuPriZadani]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PredvyplnitVyrCisPriVydeji]  DEFAULT ((0)) FOR [PredvyplnitVyrCisPriVydeji]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PredvyplnitVyrCisPriGenVrat]  DEFAULT ((0)) FOR [PredvyplnitVyrCisPriGenVrat]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NacistVyrobniCislaZPozadavku]  DEFAULT ((0)) FOR [NacistVyrobniCislaZPozadavku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PrednastavenyStavMezd]  DEFAULT ((1)) FOR [PrednastavenyStavMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZahrnoutDoKapacPlan]  DEFAULT ((0)) FOR [ZahrnoutDoKapacPlan]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerovatPohybVyrCisel]  DEFAULT ((1)) FOR [GenerovatPohybVyrCisel]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrMnozOdebNaVyrCisPrKV]  DEFAULT ((1)) FOR [KontrMnozOdebNaVyrCisPrKV]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrMaxMnozVyrCisVyrPrik]  DEFAULT ((1)) FOR [KontrMaxMnozVyrCisVyrPrik]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__TypOdvedeni]  DEFAULT ((0)) FOR [TypOdvedeni]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__TypOdvedeni_PrimyPrev]  DEFAULT ((0)) FOR [TypOdvedeni_PrimyPrev]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__RespekDatumPripPriVypocCeny]  DEFAULT ((0)) FOR [RespekDatumPripPriVypocCeny]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrCenuVyrPrijemPriReal]  DEFAULT ((0)) FOR [KontrCenuVyrPrijemPriReal]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrZadaniKmenStred]  DEFAULT ((0)) FOR [KontrZadaniKmenStred]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrZadaniZakazky]  DEFAULT ((0)) FOR [KontrZadaniZakazky]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZdrojNakladStrediska]  DEFAULT ((0)) FOR [ZdrojNakladStrediska]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolaZadaniUcetnihoKodu]  DEFAULT ((0)) FOR [KontrolaZadaniUcetnihoKodu]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZdrojNakladStredProVydej]  DEFAULT ((1)) FOR [ZdrojNakladStredProVydej]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZdrojNakladStredProPrijem]  DEFAULT ((1)) FOR [ZdrojNakladStredProPrijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZdrojNakladStredProPrijemVedPr]  DEFAULT ((1)) FOR [ZdrojNakladStredProPrijemVedPr]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DotazNatstavPriznakTisku]  DEFAULT ((0)) FOR [DotazNatstavPriznakTisku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__RespekDatumPripPriVypocCenyVP]  DEFAULT ((0)) FOR [RespekDatumPripPriVypocCenyVP]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerVydejVMJEvid]  DEFAULT ((1)) FOR [GenerVydejVMJEvid]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerVratkyVMJEvid]  DEFAULT ((1)) FOR [GenerVratkyVMJEvid]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerOdvVedProdVMJEvid]  DEFAULT ((1)) FOR [GenerOdvVedProdVMJEvid]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerOdvVyrobkuVMJEvid]  DEFAULT ((1)) FOR [GenerOdvVyrobkuVMJEvid]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PrednastavenyStavKoopMezd]  DEFAULT ((1)) FOR [PrednastavenyStavKoopMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolovatStavPracPomeruZam]  DEFAULT ((0)) FOR [KontrolovatStavPracPomeruZam]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AktualizacePrikazuP_PriZadani]  DEFAULT ((0)) FOR [AktualizacePrikazuP_PriZadani]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AktualizacePrikazuP_PriPredzpr]  DEFAULT ((0)) FOR [AktualizacePrikazuP_PriPredzpr]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PredvyplnitVyrCisPriGenRezExp]  DEFAULT ((0)) FOR [PredvyplnitVyrCisPriGenRezExp]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NekontrolMnozEvidKoopMezd]  DEFAULT ((0)) FOR [NekontrolMnozEvidKoopMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrStavBlokaceDat]  DEFAULT ((1)) FOR [KontrStavBlokaceDat]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrOdvZmetNaSkladNesPriUzav]  DEFAULT ((0)) FOR [KontrOdvZmetNaSkladNesPriUzav]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__UprednostnitNakOkruhZPozadavku]  DEFAULT ((0)) FOR [UprednostnitNakOkruhZPozadavku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZdrojNakladStredProPrijZmetku]  DEFAULT ((1)) FOR [ZdrojNakladStredProPrijZmetku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__GenerPrijemZmetkuVMJEvid]  DEFAULT ((1)) FOR [GenerPrijemZmetkuVMJEvid]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrolMnozEvidVyrCisUMezd]  DEFAULT ((1)) FOR [KontrolMnozEvidVyrCisUMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__KontrOdvedMnozVyrCisVyrPrik]  DEFAULT ((1)) FOR [KontrOdvedMnozVyrCisVyrPrik]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PovolitZmenuDilcePriOdvedeni]  DEFAULT ((0)) FOR [PovolitZmenuDilcePriOdvedeni]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PredvyplnitVyrCisPriPrijmuZmetku]  DEFAULT ((0)) FOR [PredvyplnitVyrCisPriPrijmuZmetku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_FakPrijata]  DEFAULT ((18)) FOR [DruhPohybu_FakPrijata]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__ZpusobOdvedeniDilceZVyroby]  DEFAULT ((0)) FOR [ZpusobOdvedeniDilceZVyroby]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__CilPrimehoPrevoduPolotovaru]  DEFAULT ((1)) FOR [CilPrimehoPrevoduPolotovaru]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_GenerRezVyd_Pol]  DEFAULT ((4)) FOR [DruhPohybu_GenerRezVyd_Pol]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__EvidOp_PrednabizetZiveKusy]  DEFAULT ((0)) FOR [EvidOp_PrednabizetZiveKusy]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__EvidKoop_PrednabizetZiveKusy]  DEFAULT ((0)) FOR [EvidKoop_PrednabizetZiveKusy]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__OvereniKontrolKPLVyr]  DEFAULT ((0)) FOR [OvereniKontrolKPLVyr]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__PovolitZamenuVyrCisVratkyPrKV]  DEFAULT ((0)) FOR [PovolitZamenuVyrCisVratkyPrKV]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AutomatickeGenerovaniKPL]  DEFAULT ((1)) FOR [AutomatickeGenerovaniKPL]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__EvidRozpracOper_TypEvidMnoz]  DEFAULT ((0)) FOR [EvidRozpracOper_TypEvidMnoz]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__EvidRozpracOper_PrednabizetZiveMnoz]  DEFAULT ((0)) FOR [EvidRozpracOper_PrednabizetZiveMnoz]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__Blokovano]  DEFAULT ((0)) FOR [Blokovano]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_VydObj]  DEFAULT ((6)) FOR [DruhPohybu_VydObj]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__VONeslucovatZaZakazku]  DEFAULT ((0)) FOR [VONeslucovatZaZakazku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__UzavreneOperVyraditZKontrPosloupOper]  DEFAULT ((0)) FOR [UzavreneOperVyraditZKontrPosloupOper]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__NakladyZaZmetkyRozpDoDobrychKusu]  DEFAULT ((0)) FOR [NakladyZaZmetkyRozpDoDobrychKusu]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__AutoPrirazeniVyrCisPrKVNaVystupniVyrCis]  DEFAULT ((0)) FOR [AutoPrirazeniVyrCisPrKVNaVystupniVyrCis]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__TypDokladuProDSNOdvedeniDoUbytku]  DEFAULT ((0)) FOR [TypDokladuProDSNOdvedeniDoUbytku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ADD  CONSTRAINT [DF__TabRadyPrikazu__DruhPohybu_VydejVEvidCene]  DEFAULT ((4)) FOR [DruhPohybu_VydejVEvidCene]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorPlanOcen] FOREIGN KEY([IDKalkVzorPlanOcen])
REFERENCES [dbo].[TabCKalkVzor] ([ID])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorPlanOcen]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorSkutOcen] FOREIGN KEY([IDKalkVzorSkutOcen])
REFERENCES [dbo].[TabCKalkVzor] ([ID])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorSkutOcen]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorSkutOcenVedProd] FOREIGN KEY([IDKalkVzorSkutOcenVedProd])
REFERENCES [dbo].[TabCKalkVzor] ([ID])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__IDKalkVzorSkutOcenVedProd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__IDNaklOkruh] FOREIGN KEY([IDNaklOkruh])
REFERENCES [dbo].[TabNakladovyOkruh] ([Id])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__IDNaklOkruh]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__PrijemVedPr_SkladProGenHlavDZ] FOREIGN KEY([PrijemVedPr_SkladProGenHlavDZ])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__PrijemVedPr_SkladProGenHlavDZ]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__PrijemVyrDil_SkladProGenHlavDZ] FOREIGN KEY([PrijemVyrDil_SkladProGenHlavDZ])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__PrijemVyrDil_SkladProGenHlavDZ]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__PrijemZmetku_SkladProGenHlavDZ] FOREIGN KEY([PrijemZmetku_SkladProGenHlavDZ])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__PrijemZmetku_SkladProGenHlavDZ]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerFakPrijateKoop__DruhPohybu_FakPrijata] FOREIGN KEY([RadaDokl_GenerFakPrijateKoop], [DruhPohybu_FakPrijata])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerFakPrijateKoop__DruhPohybu_FakPrijata]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerPrevodNaSkladProKooperanta__DruhPohybu_VydejVEvidCene] FOREIGN KEY([RadaDokl_GenerPrevodNaSkladProKooperanta], [DruhPohybu_VydejVEvidCene])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerPrevodNaSkladProKooperanta__DruhPohybu_VydejVEvidCene]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerRezVyd_Mat__DruhPohybu_GenerRezVyd] FOREIGN KEY([RadaDokl_GenerRezVyd_Mat], [DruhPohybu_GenerRezVyd])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerRezVyd_Mat__DruhPohybu_GenerRezVyd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerRezVyd_Pol__DruhPohybu_GenerRezVyd_Pol] FOREIGN KEY([RadaDokl_GenerRezVyd_Pol], [DruhPohybu_GenerRezVyd_Pol])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerRezVyd_Pol__DruhPohybu_GenerRezVyd_Pol]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerVratky_Mat__DruhPohybu_prijem] FOREIGN KEY([RadaDokl_GenerVratky_Mat], [DruhPohybu_prijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerVratky_Mat__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerVratky_Pol__DruhPohybu_prijem] FOREIGN KEY([RadaDokl_GenerVratky_Pol], [DruhPohybu_prijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerVratky_Pol__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerZajisteniVydObj_Mat__DruhPohybu_VydObj] FOREIGN KEY([RadaDokl_GenerZajisteniVydObj_Mat], [DruhPohybu_VydObj])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_GenerZajisteniVydObj_Mat__DruhPohybu_VydObj]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedeniPrikazu__DruhPohybu_prijem] FOREIGN KEY([RadaDokl_OdvedeniPrikazu], [DruhPohybu_prijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedeniPrikazu__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedeniVedProd__DruhPohybu_prijem] FOREIGN KEY([RadaDokl_OdvedeniVedProd], [DruhPohybu_prijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedeniVedProd__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedZmetNaSkladNesh__DruhPohybu_prijem] FOREIGN KEY([RadaDokl_OdvedZmetNaSkladNesh], [DruhPohybu_prijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokl_OdvedZmetNaSkladNesh__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__RadaDokladuDSNOdvedeniDoUbytku] FOREIGN KEY([RadaDokladuDSNOdvedeniDoUbytku])
REFERENCES [dbo].[TabDruhSN] ([RadaDokladu])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__RadaDokladuDSNOdvedeniDoUbytku]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__SkladProKooperanta] FOREIGN KEY([SkladProKooperanta])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__SkladProKooperanta]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__TiskFormPrikaz] FOREIGN KEY([TiskFormPrikaz])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__TiskFormPrikaz]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__UKod] FOREIGN KEY([UKod])
REFERENCES [dbo].[TabSkupUKod] ([ID])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__UKod]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [FK__TabRadyPrikazu__VydejMatPol_SkladProGenHlavDZ] FOREIGN KEY([VydejMatPol_SkladProGenHlavDZ])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [FK__TabRadyPrikazu__VydejMatPol_SkladProGenHlavDZ]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__AktualizacePrikazuPriZadani] CHECK  (([AktualizacePrikazuPriZadani]>=(0) AND [AktualizacePrikazuPriZadani]<=(2)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__AktualizacePrikazuPriZadani]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__CilPrimehoPrevoduPolotovaru] CHECK  (([CilPrimehoPrevoduPolotovaru]>=(0) AND [CilPrimehoPrevoduPolotovaru]<=(2)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__CilPrimehoPrevoduPolotovaru]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_FakPrijata] CHECK  (([DruhPohybu_FakPrijata]=(18)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_FakPrijata]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_GenerRezVyd] CHECK  (([DruhPohybu_GenerRezVyd]=(2) OR [DruhPohybu_GenerRezVyd]=(4) OR [DruhPohybu_GenerRezVyd]=(6) OR [DruhPohybu_GenerRezVyd]=(9) OR [DruhPohybu_GenerRezVyd]=(10) OR [DruhPohybu_GenerRezVyd]=(11)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_GenerRezVyd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_GenerRezVyd_Pol] CHECK  (([DruhPohybu_GenerRezVyd_Pol]=(2) OR [DruhPohybu_GenerRezVyd_Pol]=(4) OR [DruhPohybu_GenerRezVyd_Pol]=(6) OR [DruhPohybu_GenerRezVyd_Pol]=(9) OR [DruhPohybu_GenerRezVyd_Pol]=(10) OR [DruhPohybu_GenerRezVyd_Pol]=(11)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_GenerRezVyd_Pol]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_prijem] CHECK  (([DruhPohybu_prijem]=(0)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_prijem]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_VydejVEvidCene] CHECK  (([DruhPohybu_VydejVEvidCene]=(4)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_VydejVEvidCene]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_VydObj] CHECK  (([DruhPohybu_VydObj]=(6)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__DruhPohybu_VydObj]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__MzdovaSlozUkolMzd] CHECK  (([MzdovaSlozUkolMzd]>=(0) AND [MzdovaSlozUkolMzd]<=(999)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__MzdovaSlozUkolMzd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__PrednastavenyStavKoopMezd] CHECK  (([PrednastavenyStavKoopMezd]>=(0) AND [PrednastavenyStavKoopMezd]<=(1)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__PrednastavenyStavKoopMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__PrednastavenyStavMezd] CHECK  (([PrednastavenyStavMezd]>=(0) AND [PrednastavenyStavMezd]<=(1)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__PrednastavenyStavMezd]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__PredvyplnitVyrCisPriVydeji] CHECK  (([PredvyplnitVyrCisPriVydeji]>=(0) AND [PredvyplnitVyrCisPriVydeji]<=(2)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__PredvyplnitVyrCisPriVydeji]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__Rada] CHECK  ((len([rada])>(0)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__Rada]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__ZdrojNakladStrediska] CHECK  (([ZdrojNakladStrediska]>=(0) AND [ZdrojNakladStrediska]<=(2)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__ZdrojNakladStrediska]
GO
ALTER TABLE [dbo].[TabRadyPrikazu]  WITH CHECK ADD  CONSTRAINT [CK__TabRadyPrikazu__ZpusobOdvedeniDilceZVyroby] CHECK  (([ZpusobOdvedeniDilceZVyroby]>=(0) AND [ZpusobOdvedeniDilceZVyroby]<=(2)))
GO
ALTER TABLE [dbo].[TabRadyPrikazu] CHECK CONSTRAINT [CK__TabRadyPrikazu__ZpusobOdvedeniDilceZVyroby]
GO
ALTER TABLE [dbo].[TabRadyPrikazu] ENABLE TRIGGER [et_TabRadyPrikazu_ASOL_Log]
GO
