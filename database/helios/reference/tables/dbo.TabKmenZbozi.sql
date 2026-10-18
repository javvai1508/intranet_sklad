-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabKmenZbozi](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SkupZbo] [nvarchar](3) NOT NULL,
	[RegCis] [nvarchar](30) NOT NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[Nazev2] [nvarchar](100) NOT NULL,
	[Nazev3] [nvarchar](100) NOT NULL,
	[Nazev4] [nvarchar](100) NOT NULL,
	[SKP] [nvarchar](50) NOT NULL,
	[PLUKod] [nvarchar](10) NOT NULL,
	[BodovaHodnota] [int] NOT NULL,
	[Upozorneni] [nvarchar](255) NOT NULL,
	[BaleniTXT] [nvarchar](30) NOT NULL,
	[MJEvidence] [nvarchar](10) NULL,
	[MJVstup] [nvarchar](10) NULL,
	[MJVystup] [nvarchar](10) NULL,
	[ZarukaVstup] [int] NOT NULL,
	[TypZarukaVstup] [tinyint] NOT NULL,
	[ZarukaVystup] [int] NOT NULL,
	[TypZarukaVystup] [tinyint] NOT NULL,
	[SazbaDPHVstup] [numeric](5, 2) NULL,
	[SazbaDPHVystup] [numeric](5, 2) NULL,
	[SazbaSDVstup] [numeric](19, 6) NOT NULL,
	[SazbaSDVystup] [numeric](19, 6) NOT NULL,
	[KodSD] [nvarchar](10) NOT NULL,
	[PrepocetMJSD] [numeric](19, 6) NOT NULL,
	[MJSD] [nvarchar](10) NULL,
	[Poznamka] [nvarchar](max) NULL,
	[UKod] [int] NULL,
	[Blokovano] [tinyint] NOT NULL,
	[DruhSkladu] [tinyint] NOT NULL,
	[Sleva] [numeric](5, 2) NOT NULL,
	[ZakladniMarze] [numeric](5, 2) NOT NULL,
	[Aktualni_Dodavatel] [int] NULL,
	[Minimum_Dodavatel] [numeric](19, 6) NOT NULL,
	[Minimum_Odberatel] [numeric](19, 6) NOT NULL,
	[Hmotnost] [numeric](19, 6) NOT NULL,
	[Objem] [numeric](19, 6) NOT NULL,
	[Vyska] [numeric](19, 6) NOT NULL,
	[Sirka] [numeric](19, 6) NOT NULL,
	[Hloubka] [numeric](19, 6) NOT NULL,
	[Vykres] [nvarchar](35) NULL,
	[KmenoveStredisko] [nvarchar](30) NULL,
	[Davka] [numeric](19, 6) NOT NULL,
	[PrepMnozstvi] [numeric](19, 6) NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[DatumOd] [datetime] NOT NULL,
	[DatumDo] [datetime] NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[OdhadZvysNakupniCeny] [numeric](5, 2) NOT NULL,
	[Dilec] [bit] NOT NULL,
	[Montaz] [bit] NOT NULL,
	[Material] [bit] NOT NULL,
	[Naradi] [bit] NOT NULL,
	[RezijniMat] [bit] NOT NULL,
	[CelniNomenklatura] [nvarchar](8) NOT NULL,
	[Obrazek] [varbinary](max) NULL,
	[DodaciLhuta] [int] NOT NULL,
	[TypDodaciLhuty] [tinyint] NOT NULL,
	[CLOPopisZbozi] [nvarchar](max) NULL,
	[DopKod] [nvarchar](2) NOT NULL,
	[CNSPD] [nvarchar](4) NOT NULL,
	[CNKod1] [nvarchar](4) NOT NULL,
	[CNKod2] [nvarchar](4) NOT NULL,
	[Slevy] [nchar](1) NOT NULL,
	[UpravaCen] [nchar](1) NOT NULL,
	[EMJ] [nvarchar](10) NULL,
	[PrepMJ_EMJ] [numeric](19, 6) NOT NULL,
	[PrepMJ_CMJ] [numeric](19, 6) NOT NULL,
	[ProdCenaTabak] [numeric](19, 6) NOT NULL,
	[ObvyklaZemePuvodu] [nvarchar](2) NULL,
	[ObvyklyKodPreference] [nvarchar](3) NOT NULL,
	[ObvyklaCenavCM] [numeric](19, 6) NOT NULL,
	[ZakladSDvSJ] [numeric](19, 6) NOT NULL,
	[JCDFaTyp] [tinyint] NOT NULL,
	[VychoziMnozstvi] [numeric](19, 6) NOT NULL,
	[MjPocetEvidVstup] [numeric](19, 6) NOT NULL,
	[MjPocetEvidVystup] [numeric](19, 6) NOT NULL,
	[MjPocetVstup] [numeric](19, 6) NOT NULL,
	[MjPocetVystup] [numeric](19, 6) NOT NULL,
	[ADRtrida] [nvarchar](15) NOT NULL,
	[ADRcislice] [nvarchar](15) NOT NULL,
	[ADRpismeno] [nvarchar](15) NOT NULL,
	[ADRidLatky] [nvarchar](15) NOT NULL,
	[ADRidNebezpecnosti] [nvarchar](15) NOT NULL,
	[ADRPojmenovani] [nvarchar](255) NULL,
	[ADRTechnickyNazev] [nvarchar](255) NULL,
	[ADRObchodniNazev] [nvarchar](255) NULL,
	[KontrolaVyrC] [nchar](1) NOT NULL,
	[IdKusovnik] [int] NULL,
	[IdVarianta] [int] NULL,
	[VedProdukt] [bit] NOT NULL,
	[KJDatOd] [datetime] NULL,
	[KJDatDo] [datetime] NULL,
	[IdSortiment] [int] NULL,
	[Vyrobce] [int] NULL,
	[ZadavaniUmisteni] [smallint] NOT NULL,
	[LhutaNaskladneni] [int] NOT NULL,
	[Sluzba]  AS (CONVERT([bit],case [DruhSkladu] when (0) then (1) else (0) end,0)),
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
	[DatumOd_D]  AS (datepart(day,[DatumOd])),
	[DatumOd_M]  AS (datepart(month,[DatumOd])),
	[DatumOd_Y]  AS (datepart(year,[DatumOd])),
	[DatumOd_Q]  AS (datepart(quarter,[DatumOd])),
	[DatumOd_W]  AS (datepart(week,[DatumOd])),
	[DatumOd_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumOd],0),0),0)),
	[DatumDo_D]  AS (datepart(day,[DatumDo])),
	[DatumDo_M]  AS (datepart(month,[DatumDo])),
	[DatumDo_Y]  AS (datepart(year,[DatumDo])),
	[DatumDo_Q]  AS (datepart(quarter,[DatumDo])),
	[DatumDo_W]  AS (datepart(week,[DatumDo])),
	[DatumDo_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumDo],0),0),0)),
	[ShodaId]  AS (CONVERT([bit],case [IdKusovnik] when [ID] then (1) else (0) end,0)),
	[KJDatOd_D]  AS (datepart(day,[KJDatOd])),
	[KJDatOd_M]  AS (datepart(month,[KJDatOd])),
	[KJDatOd_Y]  AS (datepart(year,[KJDatOd])),
	[KJDatOd_Q]  AS (datepart(quarter,[KJDatOd])),
	[KJDatOd_W]  AS (datepart(week,[KJDatOd])),
	[KJDatOd_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[KJDatOd],0),0),0)),
	[KJDatDo_D]  AS (datepart(day,[KJDatDo])),
	[KJDatDo_M]  AS (datepart(month,[KJDatDo])),
	[KJDatDo_Y]  AS (datepart(year,[KJDatDo])),
	[KJDatDo_Q]  AS (datepart(quarter,[KJDatDo])),
	[KJDatDo_W]  AS (datepart(week,[KJDatDo])),
	[KJDatDo_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[KJDatDo],0),0),0)),
	[SkupZbo2]  AS (substring([SkupZbo],(1),(2))),
	[SkupZbo1]  AS (substring([SkupZbo],(1),(1))),
	[CisloZbozi]  AS ([SkupZbo]+[RegCis]),
	[SZ] [nvarchar](2) NOT NULL,
	[DPHPrenesPov] [bit] NOT NULL,
	[ADRObal] [nvarchar](15) NOT NULL,
	[ADRJednotka] [nvarchar](15) NOT NULL,
	[MJInventura] [nvarchar](10) NULL,
	[Minimum_Baleni_Dodavatel] [numeric](19, 6) NOT NULL,
	[KodKV] [nvarchar](4) NOT NULL,
	[VykazLihuObjemVML] [numeric](19, 6) NOT NULL,
	[VykazLihuProcentoLihu] [numeric](5, 2) NOT NULL,
	[VykazLihuKoefKEvidMJ] [numeric](19, 6) NOT NULL,
	[RowGUID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[Obrazek_DatLen]  AS (isnull(datalength([Obrazek]),(0))),
	[IDKodPDP] [int] NULL,
	[DruhEET] [tinyint] NOT NULL,
	[EET_dic_poverujiciho] [nvarchar](12) NULL,
	[PocetBaleniVeVrstve] [numeric](19, 6) NOT NULL,
	[PocetVrstevNaPalete] [numeric](19, 6) NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[NCSluzbyVHM] [numeric](19, 6) NOT NULL,
	[HraniceMarze] [numeric](5, 2) NULL,
	[CisloUcetPrijem] [nvarchar](30) NULL,
	[CisloUcetVydej] [nvarchar](30) NULL,
	[CisloUcetVydejEC] [nvarchar](30) NULL,
	[CisloUcetFAPrij] [nvarchar](30) NULL,
	[CisloUcetFAVyd] [nvarchar](30) NULL,
	[PouzitMarzeOdDo] [bit] NOT NULL,
	[CisloUcetPrijem_DSN] [nvarchar](30) NULL,
	[CisloUcetVydej_DSN] [nvarchar](30) NULL,
	[CisloUcetVydejEC_DSN] [nvarchar](30) NULL,
	[CisloUcetFAPrij_DSN] [nvarchar](30) NULL,
	[ZboziSluzba] [tinyint] NOT NULL,
	[VCSarze] [tinyint] NOT NULL,
	[TypVoucheru] [smallint] NOT NULL,
	[PlatnostVoucheru] [smallint] NOT NULL,
	[ZmenaCenyVoucheru] [bit] NOT NULL,
	[DruhKarty] [tinyint] NOT NULL,
	[ADRBezpZnacka] [nvarchar](15) NULL,
	[ADROmezMnozstvi] [nvarchar](15) NULL,
	[ADRNebezpZP] [nvarchar](15) NULL,
	[ADRzvlBezpOpatreni] [nvarchar](255) NULL,
	[ADRzvlOpatreni] [nvarchar](255) NULL,
	[NeplatitBody] [bit] NOT NULL,
	[SystemRowVersion] [timestamp] NOT NULL,
	[SystemRowVersionText]  AS (CONVERT([nvarchar](16),CONVERT([binary](8),[SystemRowVersion]),(2))),
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
	[AVAOutputFlag] [tinyint] NOT NULL,
	[AVASentDate] [datetime] NULL,
	[AVASentDate_D]  AS (datepart(day,[AVASentDate])),
	[AVASentDate_M]  AS (datepart(month,[AVASentDate])),
	[AVASentDate_Y]  AS (datepart(year,[AVASentDate])),
	[AVASentDate_Q]  AS (datepart(quarter,[AVASentDate])),
	[AVASentDate_W]  AS (datepart(week,[AVASentDate])),
	[AVASentDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVASentDate])))),
	[CisloUcetPoklProd] [nvarchar](30) NULL,
	[MJMerneCeny] [nvarchar](10) NULL,
	[Obrazek_BGJ]  AS (case when [Obrazek] IS NULL then NULL else case when substring([Obrazek],(1),(2))=0x424D then N'Bitmap' else case when substring([Obrazek],(1),(3))=0x474946 then N'GIF' else case when substring([Obrazek],(1),(2))=0xFFD8 then N'JPEG' else case when substring([Obrazek],(1),(4))=0x00000100 then N'Icon' else case when substring([Obrazek],(1),(8))=0x89504E470D0A1A0A then N'PNG' else case when substring([Obrazek],(1),(4))=0x54494646 then N'TIFF' else case when substring([Obrazek],(1),(4))=0x25504446 then N'PDF' else case when substring([Obrazek],(1),(4))=0x52494646 AND substring([Obrazek],(9),(4))=0x57454250 then N'WEBP' else case when charindex(0x3C737667,substring([Obrazek],(1),(500)))>(0) then N'SVG' else '' end end end end end end end end end end),
	[RuznaProdHodnotaVouch] [smallint] NOT NULL,
	[VlastniProdCenaVouch] [numeric](19, 6) NOT NULL,
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
	[UcetZalohyZakladFP] [nvarchar](30) NULL,
	[UcetZalohyZakladFV] [nvarchar](30) NULL,
	[EETPovereniVicePopl] [bit] NOT NULL,
 CONSTRAINT [PK__TabKmenZbozi__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabKmenZbozi__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabKmenZbozi__RowGUID] UNIQUE NONCLUSTERED 
(
	[RowGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabKmenZbozi__SkupZbo__RegCis] UNIQUE NONCLUSTERED 
(
	[SkupZbo] ASC,
	[RegCis] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabKmenZbozi__AVAExternalID]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabKmenZbozi__AVAExternalID] ON [dbo].[TabKmenZbozi]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabKmenZbozi__IdKusovnik]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabKmenZbozi__IdKusovnik] ON [dbo].[TabKmenZbozi]
(
	[IdKusovnik] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Nazev1]  DEFAULT ('') FOR [Nazev1]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Nazev2]  DEFAULT ('') FOR [Nazev2]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Nazev3]  DEFAULT ('') FOR [Nazev3]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Nazev4]  DEFAULT ('') FOR [Nazev4]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__SKP]  DEFAULT ('') FOR [SKP]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PLUKod]  DEFAULT ('') FOR [PLUKod]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__BodovaHodnota]  DEFAULT ((0)) FOR [BodovaHodnota]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Upozorneni]  DEFAULT ('') FOR [Upozorneni]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__BaleniTXT]  DEFAULT ('') FOR [BaleniTXT]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZarukaVstup]  DEFAULT ((0)) FOR [ZarukaVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__TypZarukaVstup]  DEFAULT ((0)) FOR [TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZarukaVystup]  DEFAULT ((0)) FOR [ZarukaVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__TypZarukaVystup]  DEFAULT ((0)) FOR [TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__SazbaSDVstup]  DEFAULT ((0.0)) FOR [SazbaSDVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__SazbaSDVystup]  DEFAULT ((0.0)) FOR [SazbaSDVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__KodSD]  DEFAULT ('') FOR [KodSD]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PrepocetMJSD]  DEFAULT ((1.00)) FOR [PrepocetMJSD]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Blokovano]  DEFAULT ((0)) FOR [Blokovano]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Sleva]  DEFAULT ((0.0)) FOR [Sleva]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZakladniMarze]  DEFAULT ((0.0)) FOR [ZakladniMarze]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Minimum_Dodavatel]  DEFAULT ((0.0)) FOR [Minimum_Dodavatel]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Minimum_Odberatel]  DEFAULT ((0.0)) FOR [Minimum_Odberatel]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Hmotnost]  DEFAULT ((0.0)) FOR [Hmotnost]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Objem]  DEFAULT ((0.0)) FOR [Objem]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Vyska]  DEFAULT ((0.0)) FOR [Vyska]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Sirka]  DEFAULT ((0.0)) FOR [Sirka]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Hloubka]  DEFAULT ((0.0)) FOR [Hloubka]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Davka]  DEFAULT ((0.0)) FOR [Davka]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PrepMnozstvi]  DEFAULT ((1.0)) FOR [PrepMnozstvi]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DatumOd]  DEFAULT ('19000101 00:00:00.000') FOR [DatumOd]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DatumDo]  DEFAULT ('99991231 23:59:59.000') FOR [DatumDo]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__OdhadZvysNakupniCeny]  DEFAULT ((0.0)) FOR [OdhadZvysNakupniCeny]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Dilec]  DEFAULT ((0)) FOR [Dilec]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Montaz]  DEFAULT ((0)) FOR [Montaz]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Material]  DEFAULT ((0)) FOR [Material]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Naradi]  DEFAULT ((0)) FOR [Naradi]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__RezijniMat]  DEFAULT ((0)) FOR [RezijniMat]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__CelniNomenklatura]  DEFAULT ('') FOR [CelniNomenklatura]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DodaciLhuta]  DEFAULT ((0)) FOR [DodaciLhuta]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__TypDodaciLhuty]  DEFAULT ((0)) FOR [TypDodaciLhuty]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DopKod]  DEFAULT ('') FOR [DopKod]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__CNSPD]  DEFAULT ('') FOR [CNSPD]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__CNKod1]  DEFAULT ('') FOR [CNKod1]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__CNKod2]  DEFAULT ('') FOR [CNKod2]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Slevy]  DEFAULT (N'A') FOR [Slevy]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__UpravaCen]  DEFAULT (N'A') FOR [UpravaCen]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PrepMJ_EMJ]  DEFAULT ((1.0)) FOR [PrepMJ_EMJ]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PrepMJ_CMJ]  DEFAULT ((1.0)) FOR [PrepMJ_CMJ]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ProdCenaTabak]  DEFAULT ((0.0)) FOR [ProdCenaTabak]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ObvyklyKodPreference]  DEFAULT ('') FOR [ObvyklyKodPreference]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ObvyklaCenavCM]  DEFAULT ((0.0)) FOR [ObvyklaCenavCM]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZakladSDvSJ]  DEFAULT ((0.0)) FOR [ZakladSDvSJ]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__JCDFaTyp]  DEFAULT ((0)) FOR [JCDFaTyp]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VychoziMnozstvi]  DEFAULT ((0.0)) FOR [VychoziMnozstvi]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__MjPocetEvidVstup]  DEFAULT ((1.0)) FOR [MjPocetEvidVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__MjPocetEvidVystup]  DEFAULT ((1.0)) FOR [MjPocetEvidVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__MjPocetVstup]  DEFAULT ((1.0)) FOR [MjPocetVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__MjPocetVystup]  DEFAULT ((1.0)) FOR [MjPocetVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRtrida]  DEFAULT ('') FOR [ADRtrida]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRcislice]  DEFAULT ('') FOR [ADRcislice]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRpismeno]  DEFAULT ('') FOR [ADRpismeno]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRidLatky]  DEFAULT ('') FOR [ADRidLatky]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRidNebezpecnosti]  DEFAULT ('') FOR [ADRidNebezpecnosti]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__KontrolaVyrC]  DEFAULT (N'N') FOR [KontrolaVyrC]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VedProdukt]  DEFAULT ((0)) FOR [VedProdukt]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZadavaniUmisteni]  DEFAULT ((4)) FOR [ZadavaniUmisteni]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__LhutaNaskladneni]  DEFAULT ((0)) FOR [LhutaNaskladneni]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__SZ]  DEFAULT ('') FOR [SZ]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DPHPrenesPov]  DEFAULT ((0)) FOR [DPHPrenesPov]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRObal]  DEFAULT ('') FOR [ADRObal]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ADRJednotka]  DEFAULT ('') FOR [ADRJednotka]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__Minimum_Baleni_Dodavatel]  DEFAULT ((0.0)) FOR [Minimum_Baleni_Dodavatel]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__KodKV]  DEFAULT ('') FOR [KodKV]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VykazLihuObjemVML]  DEFAULT ((0.0)) FOR [VykazLihuObjemVML]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VykazLihuProcentoLihu]  DEFAULT ((0.0)) FOR [VykazLihuProcentoLihu]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VykazLihuKoefKEvidMJ]  DEFAULT ((1)) FOR [VykazLihuKoefKEvidMJ]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__RowGUID]  DEFAULT (newid()) FOR [RowGUID]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DruhEET]  DEFAULT ((1)) FOR [DruhEET]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PocetBaleniVeVrstve]  DEFAULT ((0.0)) FOR [PocetBaleniVeVrstve]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PocetVrstevNaPalete]  DEFAULT ((0.0)) FOR [PocetVrstevNaPalete]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__NCSluzbyVHM]  DEFAULT ((0.0)) FOR [NCSluzbyVHM]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PouzitMarzeOdDo]  DEFAULT ((0)) FOR [PouzitMarzeOdDo]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZboziSluzba]  DEFAULT ((0)) FOR [ZboziSluzba]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VCSarze]  DEFAULT ((0)) FOR [VCSarze]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__TypVoucheru]  DEFAULT ((0)) FOR [TypVoucheru]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__PlatnostVoucheru]  DEFAULT ((0)) FOR [PlatnostVoucheru]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__ZmenaCenyVoucheru]  DEFAULT ((0)) FOR [ZmenaCenyVoucheru]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__DruhKarty]  DEFAULT ((0)) FOR [DruhKarty]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__NeplatitBody]  DEFAULT ((0)) FOR [NeplatitBody]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__AVAOutputFlag]  DEFAULT ((0)) FOR [AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__RuznaProdHodnotaVouch]  DEFAULT ((0)) FOR [RuznaProdHodnotaVouch]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__VlastniProdCenaVouch]  DEFAULT ((0.0)) FOR [VlastniProdCenaVouch]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ADD  CONSTRAINT [DF__TabKmenZbozi__EETPovereniVicePopl]  DEFAULT ((0)) FOR [EETPovereniVicePopl]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__Aktualni_Dodavatel] FOREIGN KEY([Aktualni_Dodavatel])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__Aktualni_Dodavatel]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAPrij] FOREIGN KEY([CisloUcetFAPrij])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAPrij]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAPrij_DSN] FOREIGN KEY([CisloUcetFAPrij_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAPrij_DSN]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAVyd] FOREIGN KEY([CisloUcetFAVyd])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetFAVyd]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetPoklProd] FOREIGN KEY([CisloUcetPoklProd])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetPoklProd]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetPrijem] FOREIGN KEY([CisloUcetPrijem])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetPrijem]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetPrijem_DSN] FOREIGN KEY([CisloUcetPrijem_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetPrijem_DSN]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydej] FOREIGN KEY([CisloUcetVydej])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydej]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydej_DSN] FOREIGN KEY([CisloUcetVydej_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydej_DSN]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydejEC] FOREIGN KEY([CisloUcetVydejEC])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydejEC]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydejEC_DSN] FOREIGN KEY([CisloUcetVydejEC_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__CisloUcetVydejEC_DSN]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__EMJ] FOREIGN KEY([EMJ])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__EMJ]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__IDKodPDP] FOREIGN KEY([IDKodPDP])
REFERENCES [dbo].[TabCisKoduPDP] ([ID])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__IDKodPDP]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__IdKusovnik] FOREIGN KEY([IdKusovnik])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__IdKusovnik]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__IdSortiment] FOREIGN KEY([IdSortiment])
REFERENCES [dbo].[TabSortiment] ([ID])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__IdSortiment]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__IdVarianta] FOREIGN KEY([IdVarianta])
REFERENCES [dbo].[TabCVariant] ([ID])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__IdVarianta]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__KmenoveStredisko] FOREIGN KEY([KmenoveStredisko])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__KmenoveStredisko]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJEvidence] FOREIGN KEY([MJEvidence])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJEvidence]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJInventura] FOREIGN KEY([MJInventura])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJInventura]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJMerneCeny] FOREIGN KEY([MJMerneCeny])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJMerneCeny]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJSD] FOREIGN KEY([MJSD])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJSD]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJVstup] FOREIGN KEY([MJVstup])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__MJVystup] FOREIGN KEY([MJVystup])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__MJVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__SazbaDPHVstup] FOREIGN KEY([SazbaDPHVstup])
REFERENCES [dbo].[TabDPH] ([Sazba])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__SazbaDPHVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__SazbaDPHVystup] FOREIGN KEY([SazbaDPHVystup])
REFERENCES [dbo].[TabDPH] ([Sazba])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__SazbaDPHVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__SkupZbo] FOREIGN KEY([SkupZbo])
REFERENCES [dbo].[TabSkupinyZbozi] ([SkupZbo])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__SkupZbo]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__UcetZalohyZakladFP] FOREIGN KEY([UcetZalohyZakladFP])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__UcetZalohyZakladFP]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__UcetZalohyZakladFV] FOREIGN KEY([UcetZalohyZakladFV])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__UcetZalohyZakladFV]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__UKod] FOREIGN KEY([UKod])
REFERENCES [dbo].[TabSkupUKod] ([ID])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__UKod]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [FK__TabKmenZbozi__Vyrobce] FOREIGN KEY([Vyrobce])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [FK__TabKmenZbozi__Vyrobce]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__AVAOutputFlag] CHECK  (([AVAOutputFlag]=(5) OR [AVAOutputFlag]=(4) OR [AVAOutputFlag]=(3) OR [AVAOutputFlag]=(2) OR [AVAOutputFlag]=(1) OR [AVAOutputFlag]=(0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__DruhEET] CHECK  (([DruhEET]>=(0) AND [DruhEET]<=(4)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__DruhEET]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__DruhKarty] CHECK  (([DruhKarty]>=(0) AND [DruhKarty]<=(4)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__DruhKarty]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__DruhSkladu] CHECK  (([DruhSkladu]>=(0) AND [DruhSkladu]<=(4)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__DruhSkladu]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__JCDFaTyp] CHECK  (([JCDFaTyp]>=(0) AND [JCDFaTyp]<=(40)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__JCDFaTyp]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__KontrolaVyrC] CHECK  ((ascii([KontrolaVyrC])=(65) OR ascii([KontrolaVyrC])=(78) OR ascii([KontrolaVyrC])=(68) OR ascii([KontrolaVyrC])=(66)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__KontrolaVyrC]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__MjPocetEvidVstup] CHECK  (([MjPocetEvidVstup]>(0.0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__MjPocetEvidVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__MjPocetEvidVystup] CHECK  (([MjPocetEvidVystup]>(0.0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__MjPocetEvidVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__MjPocetVstup] CHECK  (([MjPocetVstup]>(0.0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__MjPocetVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__MjPocetVystup] CHECK  (([MjPocetVystup]>(0.0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__MjPocetVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__Slevy] CHECK  ((ascii([Slevy])=(65) OR ascii([Slevy])=(78)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__Slevy]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__TypDodaciLhuty] CHECK  (([TypDodaciLhuty]>=(0) AND [TypDodaciLhuty]<=(2)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__TypDodaciLhuty]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__TypVoucheru] CHECK  (([TypVoucheru]=(3) OR [TypVoucheru]=(2) OR [TypVoucheru]=(1) OR [TypVoucheru]=(0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__TypVoucheru]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__TypZarukaVstup] CHECK  (([TypZarukaVstup]>=(0) AND [TypZarukaVstup]<=(2)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__TypZarukaVystup] CHECK  (([TypZarukaVystup]>=(0) AND [TypZarukaVystup]<=(2)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__UpravaCen] CHECK  ((ascii([UpravaCen])=(65) OR ascii([UpravaCen])=(78)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__UpravaCen]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__VCSarze] CHECK  (([VCSarze]>=(0) AND [VCSarze]<=(4)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__VCSarze]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__ZadavaniUmisteni] CHECK  (([ZadavaniUmisteni]=(7) OR [ZadavaniUmisteni]=(6) OR [ZadavaniUmisteni]=(4) OR [ZadavaniUmisteni]=(3) OR [ZadavaniUmisteni]=(2) OR [ZadavaniUmisteni]=(1) OR [ZadavaniUmisteni]=(0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__ZadavaniUmisteni]
GO
ALTER TABLE [dbo].[TabKmenZbozi]  WITH CHECK ADD  CONSTRAINT [CK__TabKmenZbozi__ZboziSluzba] CHECK  (([ZboziSluzba]=(2) OR [ZboziSluzba]=(1) OR [ZboziSluzba]=(0)))
GO
ALTER TABLE [dbo].[TabKmenZbozi] CHECK CONSTRAINT [CK__TabKmenZbozi__ZboziSluzba]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ENABLE TRIGGER [et_TabKmenZbozi_ASOL_Log]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ENABLE TRIGGER [ht_KmenZbozi_AVAModel_Change]
GO
ALTER TABLE [dbo].[TabKmenZbozi] ENABLE TRIGGER [ht_modi_kmenzbozi]
GO
