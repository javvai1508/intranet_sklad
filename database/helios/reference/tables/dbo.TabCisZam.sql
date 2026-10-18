-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabCisZam](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cislo] [int] NOT NULL,
	[Jmeno] [nvarchar](100) NOT NULL,
	[Prijmeni] [nvarchar](100) NOT NULL,
	[RodnePrijmeni] [nvarchar](100) NOT NULL,
	[TitulPred] [nvarchar](100) NOT NULL,
	[TitulZa] [nvarchar](100) NOT NULL,
	[LoginId] [nvarchar](128) NOT NULL,
	[DatumNarozeni] [datetime] NULL,
	[RodneCislo] [nvarchar](11) NOT NULL,
	[Pohlavi] [smallint] NOT NULL,
	[MistoNarozeni] [nvarchar](100) NOT NULL,
	[AdrTrvUlice] [nvarchar](100) NOT NULL,
	[AdrTrvOrCislo] [nvarchar](15) NOT NULL,
	[AdrTrvPopCislo] [nvarchar](15) NOT NULL,
	[AdrTrvMisto] [nvarchar](100) NOT NULL,
	[AdrTrvPSC] [nvarchar](10) NOT NULL,
	[AdrTrvZeme] [nvarchar](3) NULL,
	[AdrPrechUlice] [nvarchar](100) NOT NULL,
	[AdrPrechOrCislo] [nvarchar](15) NOT NULL,
	[AdrPrechPopCislo] [nvarchar](15) NOT NULL,
	[AdrPrechMisto] [nvarchar](100) NOT NULL,
	[AdrPrechPSC] [nvarchar](10) NOT NULL,
	[AdrPrechZeme] [nvarchar](3) NULL,
	[StatniPrislus] [nvarchar](3) NULL,
	[Narodnost] [nvarchar](100) NOT NULL,
	[RodinnyStav] [smallint] NOT NULL,
	[Stredisko] [nvarchar](30) NULL,
	[NakladovyOkruh] [nvarchar](15) NULL,
	[Zakazka] [nvarchar](15) NULL,
	[CisloOP] [nvarchar](15) NOT NULL,
	[PlatnostOP] [datetime] NULL,
	[CisloPasu] [nvarchar](20) NOT NULL,
	[PlatnostPasu] [datetime] NULL,
	[CisloRP] [nvarchar](20) NOT NULL,
	[SkupinaRP] [nvarchar](55) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[IdObdobi] [int] NOT NULL,
	[Obrazek] [varbinary](max) NULL,
	[Alias] [nvarchar](15) NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[SSN] [nvarchar](24) NOT NULL,
	[PovoleniKPobytu] [nvarchar](30) NOT NULL,
	[HesloPDF] [nvarchar](20) NOT NULL,
	[DatumNarozeni_D]  AS (datepart(day,[DatumNarozeni])),
	[DatumNarozeni_M]  AS (datepart(month,[DatumNarozeni])),
	[DatumNarozeni_Y]  AS (datepart(year,[DatumNarozeni])),
	[DatumNarozeni_Q]  AS (datepart(quarter,[DatumNarozeni])),
	[DatumNarozeni_W]  AS (datepart(week,[DatumNarozeni])),
	[DatumNarozeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumNarozeni],0),0),0)),
	[PlatnostOP_D]  AS (datepart(day,[PlatnostOP])),
	[PlatnostOP_M]  AS (datepart(month,[PlatnostOP])),
	[PlatnostOP_Y]  AS (datepart(year,[PlatnostOP])),
	[PlatnostOP_Q]  AS (datepart(quarter,[PlatnostOP])),
	[PlatnostOP_W]  AS (datepart(week,[PlatnostOP])),
	[PlatnostOP_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PlatnostOP],0),0),0)),
	[PlatnostPasu_D]  AS (datepart(day,[PlatnostPasu])),
	[PlatnostPasu_M]  AS (datepart(month,[PlatnostPasu])),
	[PlatnostPasu_Y]  AS (datepart(year,[PlatnostPasu])),
	[PlatnostPasu_Q]  AS (datepart(quarter,[PlatnostPasu])),
	[PlatnostPasu_W]  AS (datepart(week,[PlatnostPasu])),
	[PlatnostPasu_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PlatnostPasu],0),0),0)),
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
	[PrijmeniJmeno]  AS (rtrim(ltrim((rtrim([Prijmeni])+space((1)))+ltrim([Jmeno])))),
	[PrijmeniJmenoTituly]  AS (((ltrim(rtrim([TitulPred])+space((1)))+ltrim(rtrim([Prijmeni])+space((1))))+ltrim(rtrim([Jmeno])+space((1))))+ltrim(rtrim([TitulZa]))),
	[CisloJmenoTituly]  AS (((((right(N'000000'+CONVERT([nvarchar],[Cislo],0),(6))+space((1)))+ltrim(rtrim([TitulPred])+space((1))))+ltrim(rtrim([Prijmeni])+space((1))))+ltrim(rtrim([Jmeno])+space((1))))+ltrim(rtrim([TitulZa]))),
	[AdrTrvUliceSCisly]  AS (([AdrTrvUlice]+N' ')+case when [AdrTrvPopCislo]<>'' AND [AdrTrvOrCislo]<>'' then ([AdrTrvPopCislo]+N'/')+[AdrTrvOrCislo] else [AdrTrvPopCislo]+[AdrTrvOrCislo] end),
	[AdrPrechUliceSCisly]  AS (([AdrPrechUlice]+N' ')+case when [AdrPrechPopCislo]<>'' AND [AdrPrechOrCislo]<>'' then ([AdrPrechPopCislo]+N'/')+[AdrPrechOrCislo] else [AdrPrechPopCislo]+[AdrPrechOrCislo] end),
	[HesloPokladni] [nvarchar](255) NOT NULL,
	[AdrKontJmeno] [nvarchar](100) NOT NULL,
	[AdrKontPrijmeni] [nvarchar](100) NOT NULL,
	[AdrKontUlice] [nvarchar](100) NOT NULL,
	[AdrKontOrCislo] [nvarchar](15) NOT NULL,
	[AdrKontPopCislo] [nvarchar](15) NOT NULL,
	[AdrKontMisto] [nvarchar](100) NOT NULL,
	[AdrKontPSC] [nvarchar](10) NOT NULL,
	[AdrKontZeme] [nvarchar](3) NULL,
	[RodneCisloBezLomitka]  AS (CONVERT([nvarchar](11),replace(replace([RodneCislo],N'/',''),N' ',''),0)),
	[AdrKontPrijmeniJmeno]  AS (rtrim(ltrim((rtrim([AdrKontPrijmeni])+space((1)))+ltrim([AdrKontJmeno])))),
	[AdrKontUliceSCisly]  AS (([AdrKontUlice]+N' ')+case when [AdrKontPopCislo]<>'' AND [AdrKontOrCislo]<>'' then ([AdrKontPopCislo]+N'/')+[AdrKontOrCislo] else [AdrKontPopCislo]+[AdrKontOrCislo] end),
	[VyraditZPrehledu] [bit] NOT NULL,
	[PasVydal] [nvarchar](40) NOT NULL,
	[Obrazek_DatLen]  AS (isnull(datalength([Obrazek]),(0))),
	[IDZdrojOsUdaju] [int] NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[OmezeniZpracOU] [bit] NOT NULL,
	[AdrTrvOkres] [nvarchar](15) NULL,
	[PasVydal_Zeme] [nvarchar](3) NULL,
	[RC_Cizinec] [nvarchar](24) NOT NULL,
	[PovoleniKPobytuOd] [datetime] NULL,
	[UcelPobytu] [nvarchar](255) NOT NULL,
	[SSN_RC]  AS (CONVERT([nvarchar](24),case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] when [SSN]<>N'' then [SSN] else [RodneCislo] end)),
	[SSN_RC_BezLomitka]  AS (CONVERT([nvarchar](24),replace(replace(case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] when [SSN]<>N'' then [SSN] else [RodneCislo] end,N'/',''),N' ',''))),
	[PovoleniKPobytuOd_D]  AS (datepart(day,[PovoleniKPobytuOd])),
	[PovoleniKPobytuOd_M]  AS (datepart(month,[PovoleniKPobytuOd])),
	[PovoleniKPobytuOd_Y]  AS (datepart(year,[PovoleniKPobytuOd])),
	[PovoleniKPobytuOd_Q]  AS (datepart(quarter,[PovoleniKPobytuOd])),
	[PovoleniKPobytuOd_W]  AS (datepart(week,[PovoleniKPobytuOd])),
	[PovoleniKPobytuOd_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PovoleniKPobytuOd])))),
	[RC_SSN_C]  AS (CONVERT([nvarchar](24),case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] when [SSN]<>N'' then [SSN] else N'' end)),
	[RC_SSN_C_BezLomitka]  AS (CONVERT([nvarchar](24),replace(replace(case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] when [SSN]<>N'' then [SSN] else N'' end,N'/',''),N' ',''))),
	[RC_C_RC]  AS (CONVERT([nvarchar](24),case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] else [RodneCislo] end)),
	[RC_C_RC_BezLomitka]  AS (CONVERT([nvarchar](24),replace(replace(case when [StatniPrislus] IS NULL then [RodneCislo] when [StatniPrislus]=upper(N'CZ') then [RodneCislo] when [RC_Cizinec]<>N'' then [RC_Cizinec] else [RodneCislo] end,N'/',''),N' ',''))),
	[PovoleniKPobytuDo] [datetime] NULL,
	[PovoleniKPobytuDo_D]  AS (datepart(day,[PovoleniKPobytuDo])),
	[PovoleniKPobytuDo_M]  AS (datepart(month,[PovoleniKPobytuDo])),
	[PovoleniKPobytuDo_Y]  AS (datepart(year,[PovoleniKPobytuDo])),
	[PovoleniKPobytuDo_Q]  AS (datepart(quarter,[PovoleniKPobytuDo])),
	[PovoleniKPobytuDo_W]  AS (datepart(week,[PovoleniKPobytuDo])),
	[PovoleniKPobytuDo_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PovoleniKPobytuDo])))),
	[IdVTypUcelPobytu_DuvodPovolSK] [int] NULL,
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
	[ProfeseAPI] [nvarchar](60) NOT NULL,
	[AdrTrvAVAReferenceID] [nvarchar](40) NOT NULL,
	[AdrPrechAVAReferenceID] [nvarchar](40) NOT NULL,
	[Obrazek_BGJ]  AS (case when [Obrazek] IS NULL then NULL else case when substring([Obrazek],(1),(2))=0x424D then N'Bitmap' else case when substring([Obrazek],(1),(3))=0x474946 then N'GIF' else case when substring([Obrazek],(1),(2))=0xFFD8 then N'JPEG' else case when substring([Obrazek],(1),(4))=0x00000100 then N'Icon' else case when substring([Obrazek],(1),(8))=0x89504E470D0A1A0A then N'PNG' else case when substring([Obrazek],(1),(4))=0x54494646 then N'TIFF' else case when substring([Obrazek],(1),(4))=0x25504446 then N'PDF' else case when substring([Obrazek],(1),(4))=0x52494646 AND substring([Obrazek],(9),(4))=0x57454250 then N'WEBP' else case when charindex(0x3C737667,substring([Obrazek],(1),(500)))>(0) then N'SVG' else '' end end end end end end end end end end),
	[PlatnostRP] [datetime] NULL,
	[PlatnostRP_D]  AS (datepart(day,[PlatnostRP])),
	[PlatnostRP_M]  AS (datepart(month,[PlatnostRP])),
	[PlatnostRP_Y]  AS (datepart(year,[PlatnostRP])),
	[PlatnostRP_Q]  AS (datepart(quarter,[PlatnostRP])),
	[PlatnostRP_W]  AS (datepart(week,[PlatnostRP])),
	[PlatnostRP_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PlatnostRP])))),
	[DochazkaChip] [nvarchar](128) NULL,
	[KodZdrPojAVA] [nvarchar](40) NULL,
	[CisloPojistenceAVA] [nvarchar](15) NOT NULL,
	[Ciz_Doklad_Typ] [smallint] NOT NULL,
	[Ciz_Doklad_Cislo] [nvarchar](20) NOT NULL,
	[Ciz_Doklad_Vydal] [nvarchar](100) NOT NULL,
	[Ciz_Doklad_Vydal_Zeme] [nvarchar](3) NULL,
	[Ciz_Doklad_Typ_Kod]  AS (CONVERT([nvarchar](2),case when [Ciz_Doklad_Typ]=(1) then N'I' when [Ciz_Doklad_Typ]=(2) then N'P' when [Ciz_Doklad_Typ]=(3) then N'O'  end)),
	[StatNarozeni] [nvarchar](3) NULL,
	[OsobniIC] [nvarchar](10) NOT NULL,
	[AdrRez_Ulice] [nvarchar](100) NOT NULL,
	[AdrRez_OrCislo] [nvarchar](12) NOT NULL,
	[AdrRez_PopCislo] [nvarchar](12) NOT NULL,
	[AdrRez_Misto] [nvarchar](100) NOT NULL,
	[AdrRez_PSC] [nvarchar](10) NOT NULL,
	[AdrRez_Zeme] [nvarchar](3) NULL,
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
 CONSTRAINT [PK__TabCisZam__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabCisZam__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabCisZam__Cislo] UNIQUE NONCLUSTERED 
(
	[Cislo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabCisZam__AVAExternalID]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabCisZam__AVAExternalID] ON [dbo].[TabCisZam]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabCisZam__LoginId]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabCisZam__LoginId] ON [dbo].[TabCisZam]
(
	[LoginId] ASC
)
WHERE ([LoginId]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Jmeno]  DEFAULT ('') FOR [Jmeno]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Prijmeni]  DEFAULT ('') FOR [Prijmeni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__RodnePrijmeni]  DEFAULT ('') FOR [RodnePrijmeni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__TitulPred]  DEFAULT ('') FOR [TitulPred]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__TitulZa]  DEFAULT ('') FOR [TitulZa]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__LoginId]  DEFAULT ('') FOR [LoginId]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__RodneCislo]  DEFAULT ('') FOR [RodneCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Pohlavi]  DEFAULT ((0)) FOR [Pohlavi]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__MistoNarozeni]  DEFAULT ('') FOR [MistoNarozeni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvUlice]  DEFAULT ('') FOR [AdrTrvUlice]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvOrCislo]  DEFAULT ('') FOR [AdrTrvOrCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvPopCislo]  DEFAULT ('') FOR [AdrTrvPopCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvMisto]  DEFAULT ('') FOR [AdrTrvMisto]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvPSC]  DEFAULT ('') FOR [AdrTrvPSC]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechUlice]  DEFAULT ('') FOR [AdrPrechUlice]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechOrCislo]  DEFAULT ('') FOR [AdrPrechOrCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechPopCislo]  DEFAULT ('') FOR [AdrPrechPopCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechMisto]  DEFAULT ('') FOR [AdrPrechMisto]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechPSC]  DEFAULT ('') FOR [AdrPrechPSC]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Narodnost]  DEFAULT ('') FOR [Narodnost]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__RodinnyStav]  DEFAULT ((0)) FOR [RodinnyStav]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__CisloOP]  DEFAULT ('') FOR [CisloOP]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__CisloPasu]  DEFAULT ('') FOR [CisloPasu]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__CisloRP]  DEFAULT ('') FOR [CisloRP]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__SkupinaRP]  DEFAULT ('') FOR [SkupinaRP]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__IdObdobi]  DEFAULT ((0)) FOR [IdObdobi]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Alias]  DEFAULT ('') FOR [Alias]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__SSN]  DEFAULT ('') FOR [SSN]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__PovoleniKPobytu]  DEFAULT ('') FOR [PovoleniKPobytu]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__HesloPDF]  DEFAULT ('') FOR [HesloPDF]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__HesloPokladni]  DEFAULT ('') FOR [HesloPokladni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontJmeno]  DEFAULT ('') FOR [AdrKontJmeno]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontPrijmeni]  DEFAULT ('') FOR [AdrKontPrijmeni]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontUlice]  DEFAULT ('') FOR [AdrKontUlice]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontOrCislo]  DEFAULT ('') FOR [AdrKontOrCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontPopCislo]  DEFAULT ('') FOR [AdrKontPopCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontMisto]  DEFAULT ('') FOR [AdrKontMisto]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrKontPSC]  DEFAULT ('') FOR [AdrKontPSC]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__VyraditZPrehledu]  DEFAULT ((0)) FOR [VyraditZPrehledu]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__PasVydal]  DEFAULT ('') FOR [PasVydal]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__OmezeniZpracOU]  DEFAULT ((0)) FOR [OmezeniZpracOU]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__RC_Cizinec]  DEFAULT ('') FOR [RC_Cizinec]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__UcelPobytu]  DEFAULT ('') FOR [UcelPobytu]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AVAOutputFlag]  DEFAULT ((0)) FOR [AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__ProfeseAPI]  DEFAULT ('') FOR [ProfeseAPI]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrTrvAVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AdrTrvAVAReferenceID]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrPrechAVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AdrPrechAVAReferenceID]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__CisloPojistenceAVA]  DEFAULT ('') FOR [CisloPojistenceAVA]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Ciz_Doklad_Typ]  DEFAULT ((0)) FOR [Ciz_Doklad_Typ]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Ciz_Doklad_Cislo]  DEFAULT ('') FOR [Ciz_Doklad_Cislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__Ciz_Doklad_Vydal]  DEFAULT ('') FOR [Ciz_Doklad_Vydal]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__OsobniIC]  DEFAULT ('') FOR [OsobniIC]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrRez_Ulice]  DEFAULT ('') FOR [AdrRez_Ulice]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrRez_OrCislo]  DEFAULT ('') FOR [AdrRez_OrCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrRez_PopCislo]  DEFAULT ('') FOR [AdrRez_PopCislo]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrRez_Misto]  DEFAULT ('') FOR [AdrRez_Misto]
GO
ALTER TABLE [dbo].[TabCisZam] ADD  CONSTRAINT [DF__TabCisZam__AdrRez_PSC]  DEFAULT ('') FOR [AdrRez_PSC]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__AdrKontZeme] FOREIGN KEY([AdrKontZeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__AdrKontZeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__AdrPrechZeme] FOREIGN KEY([AdrPrechZeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__AdrPrechZeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__AdrRez_Zeme] FOREIGN KEY([AdrRez_Zeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__AdrRez_Zeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__AdrTrvOkres] FOREIGN KEY([AdrTrvOkres])
REFERENCES [dbo].[TabRegion] ([Cislo])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__AdrTrvOkres]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__AdrTrvZeme] FOREIGN KEY([AdrTrvZeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__AdrTrvZeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__Ciz_Doklad_Vydal_Zeme] FOREIGN KEY([Ciz_Doklad_Vydal_Zeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__Ciz_Doklad_Vydal_Zeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__IdVTypUcelPobytu_DuvodPovolSK] FOREIGN KEY([IdVTypUcelPobytu_DuvodPovolSK])
REFERENCES [dbo].[TabVTypUcelPobytuDuvodPovolSK] ([ID])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__IdVTypUcelPobytu_DuvodPovolSK]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__IDZdrojOsUdaju] FOREIGN KEY([IDZdrojOsUdaju])
REFERENCES [dbo].[TabZdrojeOsUdaju] ([ID])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__IDZdrojOsUdaju]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__NakladovyOkruh] FOREIGN KEY([NakladovyOkruh])
REFERENCES [dbo].[TabNakladovyOkruh] ([Cislo])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__NakladovyOkruh]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__PasVydal_Zeme] FOREIGN KEY([PasVydal_Zeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__PasVydal_Zeme]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__StatNarozeni] FOREIGN KEY([StatNarozeni])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__StatNarozeni]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__StatniPrislus] FOREIGN KEY([StatniPrislus])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__StatniPrislus]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__Stredisko] FOREIGN KEY([Stredisko])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__Stredisko]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [FK__TabCisZam__Zakazka] FOREIGN KEY([Zakazka])
REFERENCES [dbo].[TabZakazka] ([CisloZakazky])
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [FK__TabCisZam__Zakazka]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [CK__TabCisZam__AVAOutputFlag] CHECK  (([AVAOutputFlag]=(5) OR [AVAOutputFlag]=(4) OR [AVAOutputFlag]=(3) OR [AVAOutputFlag]=(2) OR [AVAOutputFlag]=(1) OR [AVAOutputFlag]=(0)))
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [CK__TabCisZam__AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabCisZam]  WITH CHECK ADD  CONSTRAINT [CK__TabCisZam__Cislo] CHECK  (([Cislo]>=(0) AND [Cislo]<=(999999)))
GO
ALTER TABLE [dbo].[TabCisZam] CHECK CONSTRAINT [CK__TabCisZam__Cislo]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [et_TabCisZam_ASOL_Log]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZam_AVAModel_Change]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZamCizinecDoklady]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZamLogZmenProSocPoj]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZamPropisUdaju]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZamVyrazeni]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_CisZamZacistiUchazece]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_DoplnVekCisZam]
GO
ALTER TABLE [dbo].[TabCisZam] ENABLE TRIGGER [ht_NovaMzdovaVeta2]
GO
