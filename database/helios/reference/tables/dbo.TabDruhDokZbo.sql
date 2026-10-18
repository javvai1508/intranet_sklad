-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabDruhDokZbo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RadaDokladu] [nvarchar](3) NOT NULL,
	[NavaznaRada] [nvarchar](3) NULL,
	[NavaznyPohyb] [tinyint] NULL,
	[Nazev] [nvarchar](40) NOT NULL,
	[DruhPohybuZbo] [tinyint] NOT NULL,
	[PohybSkladu] [tinyint] NOT NULL,
	[UKod] [int] NULL,
	[PovolenyNuly] [nchar](1) NOT NULL,
	[TiskovyForm] [int] NULL,
	[InterniDoklad] [nchar](1) NOT NULL,
	[DruhMeny] [nvarchar](3) NULL,
	[VstupniCena] [tinyint] NOT NULL,
	[Poznamka] [ntext] NULL,
	[PosledniPC] [int] NOT NULL,
	[CisloOrg] [int] NULL,
	[CisloZakazky] [nvarchar](15) NULL,
	[AutoRealizace] [tinyint] NOT NULL,
	[PovolenNovy] [nchar](1) NOT NULL,
	[FormaUhrady] [nvarchar](30) NULL,
	[FormaDopravy] [nvarchar](30) NULL,
	[Sleva] [numeric](5, 2) NOT NULL,
	[OdHodnoty] [numeric](19, 6) NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[HlidaniDokladu] [nchar](1) NOT NULL,
	[PouzitOdhadZvyseniNC] [nchar](1) NOT NULL,
	[DefOKTisk] [bit] NOT NULL,
	[DefOKReal] [bit] NOT NULL,
	[DefOKUcto] [bit] NOT NULL,
	[DefOKNext] [bit] NOT NULL,
	[PrevodParam] [tinyint] NOT NULL,
	[TypPrevodky] [nvarchar](3) NULL,
	[IDSkladPrevodu] [nvarchar](30) NULL,
	[TabDruhDZ_DruhPohybuZboPre] [tinyint] NULL,
	[DefOKExtA] [int] NULL,
	[DefOKExtARunPo] [int] NULL,
	[Pokladna] [nvarchar](3) NULL,
	[DodrzetShodnePorC] [bit] NOT NULL,
	[StredNaklad] [nvarchar](30) NULL,
	[NOkruh] [nvarchar](15) NULL,
	[IDVozidlo] [int] NULL,
	[IDBankSpoj] [int] NULL,
	[KonstSymbol] [nvarchar](10) NULL,
	[OsvobozenaPlneni] [tinyint] NOT NULL,
	[DatumPokladny] [tinyint] NOT NULL,
	[DatumFaktury] [tinyint] NOT NULL,
	[DoplnkovyKod] [nvarchar](10) NULL,
	[Fiskal] [bit] NOT NULL,
	[FiskalPort] [tinyint] NOT NULL,
	[FiskalTimeProdleva] [int] NOT NULL,
	[FiskalMena] [nvarchar](3) NOT NULL,
	[UctoCislovani] [tinyint] NOT NULL,
	[dPrijem] [tinyint] NULL,
	[RadDoklPrijemVracMn] [nvarchar](3) NULL,
	[FaNavCisloSkladu] [nvarchar](30) NULL,
	[KontrolaJakosti] [bit] NOT NULL,
	[VyrZaplZaloh] [bit] NOT NULL,
	[PrefixDodFak] [nvarchar](20) NOT NULL,
	[ServisniList] [bit] NOT NULL,
	[ZPZ] [nvarchar](2) NULL,
	[ZPZtext] [nvarchar](40) NOT NULL,
	[ZemeUrceni] [nvarchar](2) NOT NULL,
	[Region] [tinyint] NULL,
	[DodaciPodminky] [nvarchar](3) NOT NULL,
	[DD] [tinyint] NULL,
	[PovahaTransakce] [tinyint] NULL,
	[DoPenTok] [bit] NOT NULL,
	[DefOKVyznamOK] [int] NOT NULL,
	[DefOKAutomat] [int] NULL,
	[ZadavaniOkruhu] [tinyint] NOT NULL,
	[ZadavaniAuta] [tinyint] NOT NULL,
	[ZadavaniZakazka] [tinyint] NOT NULL,
	[ZadavaniStrediska] [tinyint] NOT NULL,
	[DUDSconta] [nvarchar](3) NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatZmeny] [datetime] NULL,
	[Zmenil] [nvarchar](128) NULL,
	[NavaznyDruhPrevodu] [tinyint] NOT NULL,
	[TextPokladny] [int] NOT NULL,
	[VlastniTextPokladny] [nvarchar](255) NULL,
	[CisZam] [int] NULL,
	[ZadavaniZamestnance] [tinyint] NOT NULL,
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
	[UKodPokladny] [int] NULL,
	[ParZnakPokladny] [int] NOT NULL,
	[RadaDosleObj] [nvarchar](3) NULL,
	[DatumDosleObj] [tinyint] NOT NULL,
	[PredAnal] [bit] NOT NULL,
	[SazbaDPH] [numeric](5, 2) NULL,
	[PlneniPoznamkyPD] [tinyint] NULL,
	[PrevStinuDruh] [tinyint] NOT NULL,
	[PrevStinuCena] [tinyint] NOT NULL,
	[TypKoeficientDPH] [tinyint] NOT NULL,
	[NastavDatPripadu] [tinyint] NOT NULL,
	[NastavDatVystaveni] [tinyint] NOT NULL,
	[NastavDUZP] [tinyint] NOT NULL,
	[NastavLhutaSplat] [smallint] NOT NULL,
	[NastavDatSplatPocOdFV] [tinyint] NOT NULL,
	[NastavDatSplatPocOdFP] [tinyint] NOT NULL,
	[NastavDatDoruceni] [tinyint] NOT NULL,
	[NastavObdobiStavu] [tinyint] NOT NULL,
	[NavaznyTerminDodavky] [tinyint] NOT NULL,
	[PovolitUpravuDPH] [bit] NOT NULL,
	[KontrolovatNespolehPlatce] [bit] NOT NULL,
	[KontrolovatZverejBankUcty] [bit] NOT NULL,
	[UcetZalohy] [nvarchar](30) NULL,
	[JeToZaloha] [bit] NOT NULL,
	[ZdrojCisKV] [tinyint] NOT NULL,
	[ZahrnoutDoVykazuLihu] [bit] NOT NULL,
	[OpravDanDoklad] [bit] NOT NULL,
	[IntrHranicePohybZbozi] [tinyint] NOT NULL,
	[SamoVyZdrojKurzu] [int] NOT NULL,
	[SamoVyDICDPH] [nvarchar](15) NULL,
	[PrevodDICDPH] [tinyint] NOT NULL,
	[NavaznyDUZP] [tinyint] NOT NULL,
	[NavaznaRada2] [nvarchar](3) NULL,
	[NavaznyPohyb2] [tinyint] NULL,
	[RezimMOSS] [bit] NOT NULL,
	[UKodKRCelkove] [int] NULL,
	[UKodKRKBilDni] [int] NULL,
	[UKodDorovnani] [int] NULL,
	[HlidejLimitPDP] [bit] NOT NULL,
	[ZmenaRezimuPDP] [bit] NOT NULL,
	[KHDPHDoLimitu] [tinyint] NOT NULL,
	[NastavPreuctovaniSK] [tinyint] NOT NULL,
	[PouzivatDanoveKlice] [bit] NOT NULL,
	[PrevadetDanoveKlice] [bit] NOT NULL,
	[StavEET] [tinyint] NOT NULL,
	[IDProvozovny] [int] NULL,
	[IDFCertifikatu] [int] NULL,
	[IDUCertifikatu] [int] NULL,
	[QR_MSGPlatba] [int] NOT NULL,
	[QR_MSGPlatbaText] [nvarchar](60) NOT NULL,
	[QR_MSGFaktura] [int] NOT NULL,
	[QR_MSGFakturaText] [nvarchar](40) NOT NULL,
	[ZmenaProvozUhradyAno] [bit] NOT NULL,
	[DruhCU] [tinyint] NOT NULL,
	[OrgFaktZam] [tinyint] NOT NULL,
	[PotvrDoruceni] [bit] NOT NULL,
	[PouzitiPZ2] [tinyint] NOT NULL,
	[StavNahPlneni] [tinyint] NOT NULL,
	[GenerRFnDDPP] [bit] NOT NULL,
	[SrazkovaDan] [bit] NOT NULL,
	[UKodSrazkoveDane] [int] NULL,
	[PZ2NaZadrznem] [tinyint] NOT NULL,
	[SledovaniMarzePl] [bit] NOT NULL,
	[SledovaniMarze] [bit] NOT NULL,
	[MarzeUpozorDoklad] [tinyint] NOT NULL,
	[MarzeUpozorPolozka] [tinyint] NOT NULL,
	[JeToDDPP] [bit] NOT NULL,
	[DDPPRada] [nvarchar](3) NULL,
	[DDPPPohyb] [tinyint] NULL,
	[RFRada] [nvarchar](3) NULL,
	[RFPohyb] [tinyint] NULL,
	[SKDPHKontrolovatPlatceNaZruseni] [bit] NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[ZpusobKurzZal] [tinyint] NOT NULL,
	[ZajDOrealPrij] [tinyint] NOT NULL,
	[Nehradit] [tinyint] NOT NULL,
	[UKodUhrady] [int] NULL,
	[DatumFaktury2] [tinyint] NOT NULL,
	[NavaznyDUZP2] [tinyint] NOT NULL,
	[StornoProdeje] [bit] NOT NULL,
	[TextBanky] [int] NOT NULL,
	[VlastniTextBanky] [nvarchar](255) NULL,
	[UrceniECStornoVydejeUct] [tinyint] NOT NULL,
	[RealizovatStornoVydejeUct] [bit] NOT NULL,
	[NapocitavatDatPoslVydej] [bit] NULL,
	[NapocitavatDatPoslPrijem] [bit] NULL,
	[PovolitVydejVyrCKProvereni] [bit] NOT NULL,
	[OdlisnaFormaUhrady] [bit] NOT NULL,
	[OrgICO] [tinyint] NOT NULL,
	[UcetPohlZav] [nvarchar](30) NULL,
	[OvereniDIC] [bit] NOT NULL,
	[StromVC] [bit] NOT NULL,
	[FilNulVC] [bit] NOT NULL,
	[NabidkaCenik] [int] NOT NULL,
	[RadaDoklGenStornoPrijmu] [nvarchar](3) NULL,
	[PohybGenStornoPrijmu] [tinyint] NULL,
	[RadaDoklGenStornoVydeje] [nvarchar](3) NULL,
	[PohybGenStornoVydeje] [tinyint] NULL,
	[VypDetekciECSave] [bit] NOT NULL,
	[VypDetekciECReal] [bit] NOT NULL,
	[UcetOstPohlZav] [nvarchar](30) NULL,
	[RezimOSS] [bit] NOT NULL,
	[RezimIOSS] [bit] NOT NULL,
	[PrednastaveniRezimuOSS] [tinyint] NOT NULL,
	[PrevadetNastaveniOSS] [bit] NOT NULL,
	[HromGenDOBJ] [tinyint] NOT NULL,
	[NavaznyDokladRealizovat] [bit] NOT NULL,
	[KontrolZverejBankUctySK] [bit] NOT NULL,
	[DoplnovatPolozkySN] [bit] NOT NULL,
	[AutoUctoKR] [bit] NOT NULL,
	[PouzivatVolVObjProZaj] [bit] NOT NULL,
	[GenerovatNavDokPriRealizaci] [bit] NOT NULL,
	[PrevodRealizovat] [bit] NOT NULL,
	[StornoPVRada] [nvarchar](3) NULL,
	[StornoPVRadaPohyb] [tinyint] NULL,
	[VytvaretDokVaz] [bit] NOT NULL,
	[NavaznyDokladRealizovatMno] [bit] NOT NULL,
	[DefOKRealMno] [bit] NOT NULL,
	[PrevodRealizovatMno] [bit] NOT NULL,
	[PrevadetPlneniDPH] [bit] NOT NULL,
	[RealizovatPoStorna] [bit] NOT NULL,
	[Sbornik] [nvarchar](3) NULL,
	[NulovyVydej] [nchar](1) NOT NULL,
	[AutoDorovnani] [bit] NOT NULL,
	[PrepojitPrevodkuZajPriPrevodu] [bit] NOT NULL,
	[UKodDobropis] [int] NULL,
	[Neupominat] [bit] NOT NULL,
	[Nepenalizovat] [bit] NOT NULL,
	[ZeFA] [bit] NOT NULL,
	[ZeFATypDokladu] [nvarchar](3) NULL,
	[PrenasetPoznamkaPriRealizaci] [bit] NOT NULL,
	[PokladnaZdrojUctu] [tinyint] NOT NULL,
	[PokladnaUcet] [nvarchar](30) NULL,
	[PokladnaZUOrganizace] [tinyint] NOT NULL,
	[PokladnaZURadaFaktury] [tinyint] NOT NULL,
	[PokladnaZUOrgPoprRadaFa] [tinyint] NOT NULL,
	[MetodaDSN] [tinyint] NOT NULL,
	[AutomatUcto] [bit] NOT NULL,
	[DruhPrevoduDoPrijemky] [tinyint] NOT NULL,
	[VarSymbPP] [int] NOT NULL,
	[UKodZadrzne] [int] NULL,
	[UKodUZadrzne] [int] NULL,
	[OvereniVInsolvRejstriku] [bit] NOT NULL,
	[LimitObratu] [bit] NOT NULL,
	[ZboziSluzba] [tinyint] NOT NULL,
	[UcetZalohyZaklad] [nvarchar](30) NULL,
 CONSTRAINT [PK__TabDruhDokZbo__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabDruhDokZbo__RadaDokladu__DruhPohybuZbo] UNIQUE NONCLUSTERED 
(
	[RadaDokladu] ASC,
	[DruhPohybuZbo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PovolenyNuly]  DEFAULT (N'N') FOR [PovolenyNuly]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__InterniDoklad]  DEFAULT (N'N') FOR [InterniDoklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VstupniCena]  DEFAULT ((0)) FOR [VstupniCena]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PosledniPC]  DEFAULT ((0)) FOR [PosledniPC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__AutoRealizace]  DEFAULT ((0)) FOR [AutoRealizace]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PovolenNovy]  DEFAULT (N'A') FOR [PovolenNovy]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Sleva]  DEFAULT ((0.0)) FOR [Sleva]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OdHodnoty]  DEFAULT ((0.0)) FOR [OdHodnoty]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__HlidaniDokladu]  DEFAULT (N'N') FOR [HlidaniDokladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PouzitOdhadZvyseniNC]  DEFAULT (N'N') FOR [PouzitOdhadZvyseniNC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKTisk]  DEFAULT ((0)) FOR [DefOKTisk]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKReal]  DEFAULT ((0)) FOR [DefOKReal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKUcto]  DEFAULT ((0)) FOR [DefOKUcto]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKNext]  DEFAULT ((0)) FOR [DefOKNext]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevodParam]  DEFAULT ((0)) FOR [PrevodParam]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DodrzetShodnePorC]  DEFAULT ((0)) FOR [DodrzetShodnePorC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OsvobozenaPlneni]  DEFAULT ((0)) FOR [OsvobozenaPlneni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DatumPokladny]  DEFAULT ((0)) FOR [DatumPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DatumFaktury]  DEFAULT ((0)) FOR [DatumFaktury]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Fiskal]  DEFAULT ((0)) FOR [Fiskal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__FiskalPort]  DEFAULT ((1)) FOR [FiskalPort]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__FiskalTimeProdleva]  DEFAULT ((300)) FOR [FiskalTimeProdleva]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__FiskalMena]  DEFAULT ('') FOR [FiskalMena]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__UctoCislovani]  DEFAULT ((0)) FOR [UctoCislovani]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__KontrolaJakosti]  DEFAULT ((0)) FOR [KontrolaJakosti]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VyrZaplZaloh]  DEFAULT ((0)) FOR [VyrZaplZaloh]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrefixDodFak]  DEFAULT ('') FOR [PrefixDodFak]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ServisniList]  DEFAULT ((0)) FOR [ServisniList]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZPZtext]  DEFAULT ('') FOR [ZPZtext]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZemeUrceni]  DEFAULT ('') FOR [ZemeUrceni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DodaciPodminky]  DEFAULT ('') FOR [DodaciPodminky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DoPenTok]  DEFAULT ((0)) FOR [DoPenTok]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKVyznamOK]  DEFAULT ((0)) FOR [DefOKVyznamOK]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZadavaniOkruhu]  DEFAULT ((0)) FOR [ZadavaniOkruhu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZadavaniAuta]  DEFAULT ((0)) FOR [ZadavaniAuta]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZadavaniZakazka]  DEFAULT ((0)) FOR [ZadavaniZakazka]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZadavaniStrediska]  DEFAULT ((0)) FOR [ZadavaniStrediska]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyDruhPrevodu]  DEFAULT ((0)) FOR [NavaznyDruhPrevodu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__TextPokladny]  DEFAULT ((0)) FOR [TextPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZadavaniZamestnance]  DEFAULT ((0)) FOR [ZadavaniZamestnance]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ParZnakPokladny]  DEFAULT ((0)) FOR [ParZnakPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DatumDosleObj]  DEFAULT ((0)) FOR [DatumDosleObj]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PredAnal]  DEFAULT ((0)) FOR [PredAnal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PlneniPoznamkyPD]  DEFAULT ((0)) FOR [PlneniPoznamkyPD]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevStinuDruh]  DEFAULT ((0)) FOR [PrevStinuDruh]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevStinuCena]  DEFAULT ((0)) FOR [PrevStinuCena]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__TypKoeficientDPH]  DEFAULT ((0)) FOR [TypKoeficientDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDatPripadu]  DEFAULT ((0)) FOR [NastavDatPripadu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDatVystaveni]  DEFAULT ((0)) FOR [NastavDatVystaveni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDUZP]  DEFAULT ((0)) FOR [NastavDUZP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavLhutaSplat]  DEFAULT ((10)) FOR [NastavLhutaSplat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDatSplatPocOdFV]  DEFAULT ((0)) FOR [NastavDatSplatPocOdFV]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDatSplatPocOdFP]  DEFAULT ((0)) FOR [NastavDatSplatPocOdFP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavDatDoruceni]  DEFAULT ((0)) FOR [NastavDatDoruceni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavObdobiStavu]  DEFAULT ((0)) FOR [NastavObdobiStavu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyTerminDodavky]  DEFAULT ((0)) FOR [NavaznyTerminDodavky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PovolitUpravuDPH]  DEFAULT ((0)) FOR [PovolitUpravuDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__KontrolovatNespolehPlatce]  DEFAULT ((0)) FOR [KontrolovatNespolehPlatce]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__KontrolovatZverejBankUcty]  DEFAULT ((0)) FOR [KontrolovatZverejBankUcty]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__JeToZaloha]  DEFAULT ((0)) FOR [JeToZaloha]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZdrojCisKV]  DEFAULT ((0)) FOR [ZdrojCisKV]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZahrnoutDoVykazuLihu]  DEFAULT ((0)) FOR [ZahrnoutDoVykazuLihu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OpravDanDoklad]  DEFAULT ((0)) FOR [OpravDanDoklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__IntrHranicePohybZbozi]  DEFAULT ((0)) FOR [IntrHranicePohybZbozi]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__SamoVyZdrojKurzu]  DEFAULT ((2)) FOR [SamoVyZdrojKurzu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevodDICDPH]  DEFAULT ((0)) FOR [PrevodDICDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyDUZP]  DEFAULT ((0)) FOR [NavaznyDUZP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__RezimMOSS]  DEFAULT ((0)) FOR [RezimMOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__HlidejLimitPDP]  DEFAULT ((0)) FOR [HlidejLimitPDP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZmenaRezimuPDP]  DEFAULT ((0)) FOR [ZmenaRezimuPDP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__KHDPHDoLimitu]  DEFAULT ((1)) FOR [KHDPHDoLimitu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NastavPreuctovaniSK]  DEFAULT ((1)) FOR [NastavPreuctovaniSK]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PouzivatDanoveKlice]  DEFAULT ((0)) FOR [PouzivatDanoveKlice]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevadetDanoveKlice]  DEFAULT ((0)) FOR [PrevadetDanoveKlice]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__StavEET]  DEFAULT ((2)) FOR [StavEET]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__QR_MSGPlatba]  DEFAULT ((0)) FOR [QR_MSGPlatba]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__QR_MSGPlatbaText]  DEFAULT ('') FOR [QR_MSGPlatbaText]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__QR_MSGFaktura]  DEFAULT ((0)) FOR [QR_MSGFaktura]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__QR_MSGFakturaText]  DEFAULT ('') FOR [QR_MSGFakturaText]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZmenaProvozUhradyAno]  DEFAULT ((0)) FOR [ZmenaProvozUhradyAno]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DruhCU]  DEFAULT ((1)) FOR [DruhCU]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OrgFaktZam]  DEFAULT ((0)) FOR [OrgFaktZam]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PotvrDoruceni]  DEFAULT ((0)) FOR [PotvrDoruceni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PouzitiPZ2]  DEFAULT ((3)) FOR [PouzitiPZ2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__StavNahPlneni]  DEFAULT ((0)) FOR [StavNahPlneni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__GenerRFnDDPP]  DEFAULT ((0)) FOR [GenerRFnDDPP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__SrazkovaDan]  DEFAULT ((0)) FOR [SrazkovaDan]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PZ2NaZadrznem]  DEFAULT ((0)) FOR [PZ2NaZadrznem]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__SledovaniMarzePl]  DEFAULT ((0)) FOR [SledovaniMarzePl]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__SledovaniMarze]  DEFAULT ((0)) FOR [SledovaniMarze]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__MarzeUpozorDoklad]  DEFAULT ((0)) FOR [MarzeUpozorDoklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__MarzeUpozorPolozka]  DEFAULT ((0)) FOR [MarzeUpozorPolozka]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__JeToDDPP]  DEFAULT ((0)) FOR [JeToDDPP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__SKDPHKontrolovatPlatceNaZruseni]  DEFAULT ((0)) FOR [SKDPHKontrolovatPlatceNaZruseni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZpusobKurzZal]  DEFAULT ((1)) FOR [ZpusobKurzZal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZajDOrealPrij]  DEFAULT ((0)) FOR [ZajDOrealPrij]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Nehradit]  DEFAULT ((0)) FOR [Nehradit]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DatumFaktury2]  DEFAULT ((0)) FOR [DatumFaktury2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyDUZP2]  DEFAULT ((0)) FOR [NavaznyDUZP2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__StornoProdeje]  DEFAULT ((0)) FOR [StornoProdeje]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__TextBanky]  DEFAULT ((2)) FOR [TextBanky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__UrceniECStornoVydejeUct]  DEFAULT ((2)) FOR [UrceniECStornoVydejeUct]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__RealizovatStornoVydejeUct]  DEFAULT ((0)) FOR [RealizovatStornoVydejeUct]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PovolitVydejVyrCKProvereni]  DEFAULT ((0)) FOR [PovolitVydejVyrCKProvereni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OdlisnaFormaUhrady]  DEFAULT ((0)) FOR [OdlisnaFormaUhrady]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OrgICO]  DEFAULT ((0)) FOR [OrgICO]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OvereniDIC]  DEFAULT ((0)) FOR [OvereniDIC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__StromVC]  DEFAULT ((0)) FOR [StromVC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__FilNulVC]  DEFAULT ((0)) FOR [FilNulVC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NabidkaCenik]  DEFAULT ((0)) FOR [NabidkaCenik]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VypDetekciECSave]  DEFAULT ((0)) FOR [VypDetekciECSave]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VypDetekciECReal]  DEFAULT ((0)) FOR [VypDetekciECReal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__RezimOSS]  DEFAULT ((0)) FOR [RezimOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__RezimIOSS]  DEFAULT ((0)) FOR [RezimIOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrednastaveniRezimuOSS]  DEFAULT ((0)) FOR [PrednastaveniRezimuOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevadetNastaveniOSS]  DEFAULT ((1)) FOR [PrevadetNastaveniOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__HromGenDOBJ]  DEFAULT ((0)) FOR [HromGenDOBJ]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyDokladRealizovat]  DEFAULT ((0)) FOR [NavaznyDokladRealizovat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__KontrolZverejBankUctySK]  DEFAULT ((0)) FOR [KontrolZverejBankUctySK]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DoplnovatPolozkySN]  DEFAULT ((0)) FOR [DoplnovatPolozkySN]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__AutoUctoKR]  DEFAULT ((0)) FOR [AutoUctoKR]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PouzivatVolVObjProZaj]  DEFAULT ((0)) FOR [PouzivatVolVObjProZaj]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__GenerovatNavDokPriRealizaci]  DEFAULT ((1)) FOR [GenerovatNavDokPriRealizaci]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevodRealizovat]  DEFAULT ((0)) FOR [PrevodRealizovat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VytvaretDokVaz]  DEFAULT ((0)) FOR [VytvaretDokVaz]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NavaznyDokladRealizovatMno]  DEFAULT ((0)) FOR [NavaznyDokladRealizovatMno]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DefOKRealMno]  DEFAULT ((0)) FOR [DefOKRealMno]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevodRealizovatMno]  DEFAULT ((0)) FOR [PrevodRealizovatMno]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrevadetPlneniDPH]  DEFAULT ((0)) FOR [PrevadetPlneniDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__RealizovatPoStorna]  DEFAULT ((0)) FOR [RealizovatPoStorna]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__NulovyVydej]  DEFAULT (N'X') FOR [NulovyVydej]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__AutoDorovnani]  DEFAULT ((0)) FOR [AutoDorovnani]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrepojitPrevodkuZajPriPrevodu]  DEFAULT ((0)) FOR [PrepojitPrevodkuZajPriPrevodu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Neupominat]  DEFAULT ((0)) FOR [Neupominat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__Nepenalizovat]  DEFAULT ((0)) FOR [Nepenalizovat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZeFA]  DEFAULT ((0)) FOR [ZeFA]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PrenasetPoznamkaPriRealizaci]  DEFAULT ((1)) FOR [PrenasetPoznamkaPriRealizaci]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PokladnaZdrojUctu]  DEFAULT ((0)) FOR [PokladnaZdrojUctu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PokladnaZUOrganizace]  DEFAULT ((0)) FOR [PokladnaZUOrganizace]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PokladnaZURadaFaktury]  DEFAULT ((0)) FOR [PokladnaZURadaFaktury]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__PokladnaZUOrgPoprRadaFa]  DEFAULT ((0)) FOR [PokladnaZUOrgPoprRadaFa]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__MetodaDSN]  DEFAULT ((0)) FOR [MetodaDSN]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__AutomatUcto]  DEFAULT ((1)) FOR [AutomatUcto]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__DruhPrevoduDoPrijemky]  DEFAULT ((1)) FOR [DruhPrevoduDoPrijemky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__VarSymbPP]  DEFAULT ((0)) FOR [VarSymbPP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__OvereniVInsolvRejstriku]  DEFAULT ((0)) FOR [OvereniVInsolvRejstriku]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__LimitObratu]  DEFAULT ((0)) FOR [LimitObratu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ADD  CONSTRAINT [DF__TabDruhDokZbo__ZboziSluzba]  DEFAULT ((0)) FOR [ZboziSluzba]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__CisloOrg] FOREIGN KEY([CisloOrg])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__CisloOrg]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__CisloZakazky] FOREIGN KEY([CisloZakazky])
REFERENCES [dbo].[TabZakazka] ([CisloZakazky])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__CisloZakazky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__CisZam] FOREIGN KEY([CisZam])
REFERENCES [dbo].[TabCisZam] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__CisZam]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__DefOKAutomat] FOREIGN KEY([DefOKAutomat])
REFERENCES [dbo].[TabAutomatPrehled] ([ID])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__DefOKAutomat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__DefOKExtA] FOREIGN KEY([DefOKExtA])
REFERENCES [dbo].[TabExtKom] ([ID])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__DefOKExtA]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__DruhMeny] FOREIGN KEY([DruhMeny])
REFERENCES [dbo].[TabKodMen] ([Kod])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__DruhMeny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__DUDSconta] FOREIGN KEY([DUDSconta])
REFERENCES [dbo].[TabSbornik] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__DUDSconta]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__FaNavCisloSkladu] FOREIGN KEY([FaNavCisloSkladu])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__FaNavCisloSkladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__FormaDopravy] FOREIGN KEY([FormaDopravy])
REFERENCES [dbo].[TabFormaDopravy] ([FormaDopravy])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__FormaDopravy]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__FormaUhrady] FOREIGN KEY([FormaUhrady])
REFERENCES [dbo].[TabFormaUhrady] ([FormaUhrady])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__FormaUhrady]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__IDBankSpoj] FOREIGN KEY([IDBankSpoj])
REFERENCES [dbo].[TabBankSpojeni] ([ID])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__IDBankSpoj]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__IDProvozovny] FOREIGN KEY([IDProvozovny])
REFERENCES [dbo].[TabEETProvozovny] ([ID])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__IDProvozovny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__IDSkladPrevodu] FOREIGN KEY([IDSkladPrevodu])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__IDSkladPrevodu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__IDVozidlo] FOREIGN KEY([IDVozidlo])
REFERENCES [dbo].[TabIVozidlo] ([id])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__IDVozidlo]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__NavaznaRada__NavaznyPohyb] FOREIGN KEY([NavaznaRada], [NavaznyPohyb])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__NavaznaRada__NavaznyPohyb]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__NOkruh] FOREIGN KEY([NOkruh])
REFERENCES [dbo].[TabNakladovyOkruh] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__NOkruh]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__Pokladna] FOREIGN KEY([Pokladna])
REFERENCES [dbo].[TabDruhPokladen] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__Pokladna]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__PokladnaUcet] FOREIGN KEY([PokladnaUcet])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__PokladnaUcet]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__RadaDosleObj] FOREIGN KEY([RadaDosleObj])
REFERENCES [dbo].[TabDosleObjRada] ([Rada])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__RadaDosleObj]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__RadDoklPrijemVracMn__dPrijem] FOREIGN KEY([RadDoklPrijemVracMn], [dPrijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__RadDoklPrijemVracMn__dPrijem]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__SazbaDPH] FOREIGN KEY([SazbaDPH])
REFERENCES [dbo].[TabDPH] ([Sazba])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__SazbaDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__Sbornik] FOREIGN KEY([Sbornik])
REFERENCES [dbo].[TabSbornik] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__Sbornik]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__StredNaklad] FOREIGN KEY([StredNaklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__StredNaklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__TiskovyForm] FOREIGN KEY([TiskovyForm])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__TiskovyForm]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UcetOstPohlZav] FOREIGN KEY([UcetOstPohlZav])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UcetOstPohlZav]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UcetPohlZav] FOREIGN KEY([UcetPohlZav])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UcetPohlZav]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UcetZalohy] FOREIGN KEY([UcetZalohy])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UcetZalohy]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UcetZalohyZaklad] FOREIGN KEY([UcetZalohyZaklad])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UcetZalohyZaklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKod] FOREIGN KEY([UKod])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKod]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodDobropis] FOREIGN KEY([UKodDobropis])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodDobropis]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodDorovnani] FOREIGN KEY([UKodDorovnani])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodDorovnani]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodKRCelkove] FOREIGN KEY([UKodKRCelkove])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodKRCelkove]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodKRKBilDni] FOREIGN KEY([UKodKRKBilDni])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodKRKBilDni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodPokladny] FOREIGN KEY([UKodPokladny])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodSrazkoveDane] FOREIGN KEY([UKodSrazkoveDane])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodSrazkoveDane]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodUhrady] FOREIGN KEY([UKodUhrady])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodUhrady]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodUZadrzne] FOREIGN KEY([UKodUZadrzne])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodUZadrzne]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__UKodZadrzne] FOREIGN KEY([UKodZadrzne])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__UKodZadrzne]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabDruhDokZbo__ZeFATypDokladu] FOREIGN KEY([ZeFATypDokladu])
REFERENCES [dbo].[TabZeFATypDokladu] ([Kod])
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [FK__TabDruhDokZbo__ZeFATypDokladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__AutoRealizace] CHECK  (([AutoRealizace]>=(0) AND [AutoRealizace]<=(5)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__AutoRealizace]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DatumDosleObj] CHECK  (([DatumDosleObj]=(1) OR [DatumDosleObj]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DatumDosleObj]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DatumFaktury] CHECK  (([DatumFaktury]>=(0) AND [DatumFaktury]<=(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DatumFaktury]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DatumFaktury2] CHECK  (([DatumFaktury2]>=(0) AND [DatumFaktury2]<=(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DatumFaktury2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DatumPokladny] CHECK  (([DatumPokladny]=(1) OR [DatumPokladny]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DatumPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DDPPPohyb] CHECK  (([DDPPPohyb]>=(0) AND [DDPPPohyb]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DDPPPohyb]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DefOKVyznamOK] CHECK  (([DefOKVyznamOK]>=(0) AND [DefOKVyznamOK]<=(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DefOKVyznamOK]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__dPrijem] CHECK  (([dPrijem]>=(0) AND [dPrijem]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__dPrijem]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DruhCU] CHECK  (([DruhCU]>=(0) AND [DruhCU]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DruhCU]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DruhPohybuZbo] CHECK  (([DruhPohybuZbo]>=(0) AND [DruhPohybuZbo]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DruhPohybuZbo]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__DruhPrevoduDoPrijemky] CHECK  (([DruhPrevoduDoPrijemky]=(1) OR [DruhPrevoduDoPrijemky]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__DruhPrevoduDoPrijemky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__FiskalPort] CHECK  (([FiskalPort]>=(0) AND [FiskalPort]<=(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__FiskalPort]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__HlidaniDokladu] CHECK  ((ascii([HlidaniDokladu])=(65) OR ascii([HlidaniDokladu])=(78)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__HlidaniDokladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__InterniDoklad] CHECK  ((ascii([InterniDoklad])=(65) OR ascii([InterniDoklad])=(78)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__InterniDoklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__IntrHranicePohybZbozi] CHECK  (([IntrHranicePohybZbozi]>=(0) AND [IntrHranicePohybZbozi]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__IntrHranicePohybZbozi]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__KHDPHDoLimitu] CHECK  (([KHDPHDoLimitu]=(2) OR [KHDPHDoLimitu]=(1) OR [KHDPHDoLimitu]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__KHDPHDoLimitu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__MarzeUpozorDoklad] CHECK  (([MarzeUpozorDoklad]>=(0) AND [MarzeUpozorDoklad]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__MarzeUpozorDoklad]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__MarzeUpozorPolozka] CHECK  (([MarzeUpozorPolozka]>=(0) AND [MarzeUpozorPolozka]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__MarzeUpozorPolozka]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__MetodaDSN] CHECK  (([MetodaDSN]=(1) OR [MetodaDSN]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__MetodaDSN]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDatDoruceni] CHECK  (([NastavDatDoruceni]>=(0) AND [NastavDatDoruceni]<=(3)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDatDoruceni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDatPripadu] CHECK  (([NastavDatPripadu]>=(0) AND [NastavDatPripadu]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDatPripadu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDatSplatPocOdFP] CHECK  (([NastavDatSplatPocOdFP]>=(0) AND [NastavDatSplatPocOdFP]<=(9)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDatSplatPocOdFP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDatSplatPocOdFV] CHECK  (([NastavDatSplatPocOdFV]=(9) OR [NastavDatSplatPocOdFV]=(6) OR [NastavDatSplatPocOdFV]=(5) OR [NastavDatSplatPocOdFV]=(4) OR [NastavDatSplatPocOdFV]=(3) OR [NastavDatSplatPocOdFV]=(2) OR [NastavDatSplatPocOdFV]=(1) OR [NastavDatSplatPocOdFV]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDatSplatPocOdFV]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDatVystaveni] CHECK  (([NastavDatVystaveni]>=(0) AND [NastavDatVystaveni]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDatVystaveni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavDUZP] CHECK  (([NastavDUZP]>=(0) AND [NastavDUZP]<=(3)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavDUZP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavLhutaSplat] CHECK  (([NastavLhutaSplat]>=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavLhutaSplat]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavObdobiStavu] CHECK  (([NastavObdobiStavu]>=(0) AND [NastavObdobiStavu]<=(3)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavObdobiStavu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NastavPreuctovaniSK] CHECK  (([NastavPreuctovaniSK]=(2) OR [NastavPreuctovaniSK]=(1) OR [NastavPreuctovaniSK]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NastavPreuctovaniSK]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyDruhPrevodu] CHECK  (([NavaznyDruhPrevodu]=(1) OR [NavaznyDruhPrevodu]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyDruhPrevodu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyDUZP] CHECK  (([NavaznyDUZP]>=(0) AND [NavaznyDUZP]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyDUZP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyDUZP2] CHECK  (([NavaznyDUZP2]>=(0) AND [NavaznyDUZP2]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyDUZP2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyPohyb] CHECK  (([NavaznyPohyb]>=(0) AND [NavaznyPohyb]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyPohyb]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyPohyb2] CHECK  (([NavaznyPohyb2]>=(0) AND [NavaznyPohyb2]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyPohyb2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NavaznyTerminDodavky] CHECK  (([NavaznyTerminDodavky]>=(0) AND [NavaznyTerminDodavky]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NavaznyTerminDodavky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__Nehradit] CHECK  (([Nehradit]>=(0) AND [Nehradit]<=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__Nehradit]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__NulovyVydej] CHECK  ((ascii([NulovyVydej])=(65) OR ascii([NulovyVydej])=(78) OR ascii([NulovyVydej])=(88)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__NulovyVydej]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__OdHodnoty] CHECK  (([OdHodnoty]>=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__OdHodnoty]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__OrgFaktZam] CHECK  (([OrgFaktZam]=(0) OR ([DruhPohybuZbo]=(19) OR [DruhPohybuZbo]=(18) OR [DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(13) OR [DruhPohybuZbo]=(11) OR [DruhPohybuZbo]=(10) OR [DruhPohybuZbo]=(9) OR [DruhPohybuZbo]=(6) OR [DruhPohybuZbo]=(4) OR [DruhPohybuZbo]=(3) OR [DruhPohybuZbo]=(2) OR [DruhPohybuZbo]=(1) OR [DruhPohybuZbo]=(0)) AND ([OrgFaktZam]=(2) OR [OrgFaktZam]=(1) OR [OrgFaktZam]=(0))))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__OrgFaktZam]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__OrgICO] CHECK  (([OrgICO]=(2) OR [OrgICO]=(1) OR [OrgICO]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__OrgICO]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__OsvobozenaPlneni] CHECK  (([OsvobozenaPlneni]=(3) OR [OsvobozenaPlneni]=(2) OR [OsvobozenaPlneni]=(1) OR [OsvobozenaPlneni]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__OsvobozenaPlneni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ParZnakPokladny] CHECK  (([ParZnakPokladny]=(1) OR [ParZnakPokladny]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ParZnakPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PohybGenStornoPrijmu] CHECK  (([PohybGenStornoPrijmu]>=(0) AND [PohybGenStornoPrijmu]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PohybGenStornoPrijmu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PohybGenStornoVydeje] CHECK  (([PohybGenStornoVydeje]>=(0) AND [PohybGenStornoVydeje]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PohybGenStornoVydeje]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PohybSkladu] CHECK  (([PohybSkladu]>=(0) AND [PohybSkladu]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PohybSkladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PotvrDoruceni] CHECK  (([DruhPohybuZbo]=(14) OR [DruhPohybuZbo]=(13) OR [PotvrDoruceni]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PotvrDoruceni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PouzitiPZ2] CHECK  (([PouzitiPZ2]<(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PouzitiPZ2]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PouzitOdhadZvyseniNC] CHECK  ((ascii([PouzitOdhadZvyseniNC])=(65) OR ascii([PouzitOdhadZvyseniNC])=(78)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PouzitOdhadZvyseniNC]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PovolenNovy] CHECK  ((ascii([PovolenNovy])=(65) OR ascii([PovolenNovy])=(78)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PovolenNovy]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PovolenyNuly] CHECK  ((ascii([PovolenyNuly])=(65) OR ascii([PovolenyNuly])=(78)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PovolenyNuly]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrednastaveniRezimuOSS] CHECK  (([PrednastaveniRezimuOSS]=(3) OR [PrednastaveniRezimuOSS]=(2) OR [PrednastaveniRezimuOSS]=(1) OR [PrednastaveniRezimuOSS]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrednastaveniRezimuOSS]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrevadetDanoveKlice] CHECK  (([PrevadetDanoveKlice]=(0) OR [PouzivatDanoveKlice]=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrevadetDanoveKlice]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrevodDICDPH] CHECK  (([PrevodDICDPH]=(1) OR [PrevodDICDPH]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrevodDICDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrevodParam] CHECK  (([PrevodParam]=(3) OR [PrevodParam]=(2) OR [PrevodParam]=(1) OR [PrevodParam]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrevodParam]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrevStinuCena] CHECK  (([PrevStinuCena]=(2) OR [PrevStinuCena]=(1) OR [PrevStinuCena]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrevStinuCena]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PrevStinuDruh] CHECK  (([PrevStinuDruh]=(1) OR [PrevStinuDruh]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PrevStinuDruh]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__PZ2NaZadrznem] CHECK  (([PZ2NaZadrznem]<(4)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__PZ2NaZadrznem]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__QR_MSGFaktura] CHECK  (([QR_MSGFaktura]>=(0) AND [QR_MSGFaktura]<=(5)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__QR_MSGFaktura]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__QR_MSGPlatba] CHECK  (([QR_MSGPlatba]>=(0) AND [QR_MSGPlatba]<=(5)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__QR_MSGPlatba]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__RadaDokladu] CHECK  ((len([RadaDokladu])=(3) OR len([RadaDokladu])=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__RadaDokladu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__RFPohyb] CHECK  (([RFPohyb]>=(0) AND [RFPohyb]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__RFPohyb]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__StavEET] CHECK  (([StavEET]>=(0) AND [StavEET]<=(3)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__StavEET]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__StavNahPlneni] CHECK  (([StavNahPlneni]>=(0) AND [StavNahPlneni]<=(5)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__StavNahPlneni]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__StornoProdeje] CHECK  (([DruhPohybuZbo]=(3) OR [StornoProdeje]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__StornoProdeje]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__StornoPVRadaPohyb] CHECK  (([StornoPVRadaPohyb]>=(0) AND [StornoPVRadaPohyb]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__StornoPVRadaPohyb]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__TabDruhDZ_DruhPohybuZboPre] CHECK  (([TabDruhDZ_DruhPohybuZboPre]>=(0) AND [TabDruhDZ_DruhPohybuZboPre]<=(73)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__TabDruhDZ_DruhPohybuZboPre]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__TextBanky] CHECK  (([TextBanky]=(2) OR [TextBanky]=(1)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__TextBanky]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__TextPokladny] CHECK  (([TextPokladny]=(2) OR [TextPokladny]=(1) OR [TextPokladny]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__TextPokladny]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__TypKoeficientDPH] CHECK  (([TypKoeficientDPH]=(2) OR [TypKoeficientDPH]=(1) OR [TypKoeficientDPH]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__TypKoeficientDPH]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__UctoCislovani] CHECK  (([UctoCislovani]=(1) OR [UctoCislovani]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__UctoCislovani]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__UrceniECStornoVydejeUct] CHECK  (([UrceniECStornoVydejeUct]>=(0) AND [UrceniECStornoVydejeUct]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__UrceniECStornoVydejeUct]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__VarSymbPP] CHECK  (([VarSymbPP]=(2) OR [VarSymbPP]=(1) OR [VarSymbPP]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__VarSymbPP]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__VstupniCena] CHECK  (([VstupniCena]>=(0) AND [VstupniCena]<=(11)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__VstupniCena]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZadavaniAuta] CHECK  (([ZadavaniAuta]=(3) OR [ZadavaniAuta]=(2) OR [ZadavaniAuta]=(1) OR [ZadavaniAuta]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZadavaniAuta]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZadavaniOkruhu] CHECK  (([ZadavaniOkruhu]=(3) OR [ZadavaniOkruhu]=(2) OR [ZadavaniOkruhu]=(1) OR [ZadavaniOkruhu]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZadavaniOkruhu]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZadavaniStrediska] CHECK  (([ZadavaniStrediska]=(3) OR [ZadavaniStrediska]=(2) OR [ZadavaniStrediska]=(1) OR [ZadavaniStrediska]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZadavaniStrediska]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZadavaniZakazka] CHECK  (([ZadavaniZakazka]=(3) OR [ZadavaniZakazka]=(2) OR [ZadavaniZakazka]=(1) OR [ZadavaniZakazka]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZadavaniZakazka]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZadavaniZamestnance] CHECK  (([ZadavaniZamestnance]=(3) OR [ZadavaniZamestnance]=(2) OR [ZadavaniZamestnance]=(1) OR [ZadavaniZamestnance]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZadavaniZamestnance]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZboziSluzba] CHECK  (([ZboziSluzba]=(2) OR [ZboziSluzba]=(1) OR [ZboziSluzba]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZboziSluzba]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZdrojCisKV] CHECK  (([ZdrojCisKV]=(2) OR [ZdrojCisKV]=(1) OR [ZdrojCisKV]=(0)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZdrojCisKV]
GO
ALTER TABLE [dbo].[TabDruhDokZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabDruhDokZbo__ZpusobKurzZal] CHECK  (([ZpusobKurzZal]>=(0) AND [ZpusobKurzZal]<=(2)))
GO
ALTER TABLE [dbo].[TabDruhDokZbo] CHECK CONSTRAINT [CK__TabDruhDokZbo__ZpusobKurzZal]
GO
ALTER TABLE [dbo].[TabDruhDokZbo] ENABLE TRIGGER [ht_TabDruhDZ_Trigger]
GO
