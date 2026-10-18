-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabDICOrg](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CisloOrg] [int] NULL,
	[ISOZeme] [nvarchar](3) NULL,
	[DIC] [nvarchar](15) NULL,
	[DatumOvereniDIC] [datetime] NULL,
	[AutorOvereniDIC] [nvarchar](128) NOT NULL,
	[VysledekOvereniDIC] [nvarchar](255) NOT NULL,
	[DatumOvereniDIC_D]  AS (datepart(day,[DatumOvereniDIC])),
	[DatumOvereniDIC_M]  AS (datepart(month,[DatumOvereniDIC])),
	[DatumOvereniDIC_Y]  AS (datepart(year,[DatumOvereniDIC])),
	[DatumOvereniDIC_Q]  AS (datepart(quarter,[DatumOvereniDIC])),
	[DatumOvereniDIC_W]  AS (datepart(week,[DatumOvereniDIC])),
	[DatumOvereniDIC_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumOvereniDIC],0),0),0)),
	[AktualniDIC] [bit] NOT NULL,
	[AktualniDICNeplatce] [bit] NOT NULL,
	[RezimPreuctovaniSK] [bit] NOT NULL,
	[IdentifikovanaOsoba] [nvarchar](32) NULL,
	[SKRegistrace7] [bit] NOT NULL,
	[SkupinoveDPH] [bit] NOT NULL,
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
	[AVASentDate] [datetime] NULL,
	[AVASentDate_D]  AS (datepart(day,[AVASentDate])),
	[AVASentDate_M]  AS (datepart(month,[AVASentDate])),
	[AVASentDate_Y]  AS (datepart(year,[AVASentDate])),
	[AVASentDate_Q]  AS (datepart(quarter,[AVASentDate])),
	[AVASentDate_W]  AS (datepart(week,[AVASentDate])),
	[AVASentDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVASentDate])))),
	[JeIdentifikovanaOsoba] [bit] NOT NULL,
	[DanEvCis]  AS (CONVERT([bit],case when right([DIC],(3))='-EX' then (1) else (0) end)),
	[HodnotuDicDPHnaOrganizaciNeaktualizovat] [bit] NOT NULL,
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni])))),
	[DatZmeny_D]  AS (datepart(day,[DatZmeny])),
	[DatZmeny_M]  AS (datepart(month,[DatZmeny])),
	[DatZmeny_Y]  AS (datepart(year,[DatZmeny])),
	[DatZmeny_Q]  AS (datepart(quarter,[DatZmeny])),
	[DatZmeny_W]  AS (datepart(week,[DatZmeny])),
	[DatZmeny_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatZmeny])))),
 CONSTRAINT [PK__TabDICOrg__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabDICOrg__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabDICOrg__CisloOrg__DIC] UNIQUE NONCLUSTERED 
(
	[CisloOrg] ASC,
	[DIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabDICOrg__AVAExternalID]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabDICOrg__AVAExternalID] ON [dbo].[TabDICOrg]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabDICOrg__DIC__CisloOrg]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabDICOrg__DIC__CisloOrg] ON [dbo].[TabDICOrg]
(
	[DIC] ASC,
	[CisloOrg] ASC
)
INCLUDE([AktualniDIC],[AktualniDICNeplatce]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabDICOrg__ISOZeme__AktualniDIC__CisloOrg__DIC]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabDICOrg__ISOZeme__AktualniDIC__CisloOrg__DIC] ON [dbo].[TabDICOrg]
(
	[ISOZeme] ASC,
	[AktualniDIC] ASC,
	[CisloOrg] ASC,
	[DIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__AutorOvereniDIC]  DEFAULT ('') FOR [AutorOvereniDIC]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__VysledekOvereniDIC]  DEFAULT ('') FOR [VysledekOvereniDIC]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__AktualniDIC]  DEFAULT ((0)) FOR [AktualniDIC]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__AktualniDICNeplatce]  DEFAULT ((0)) FOR [AktualniDICNeplatce]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__RezimPreuctovaniSK]  DEFAULT ((0)) FOR [RezimPreuctovaniSK]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__SKRegistrace7]  DEFAULT ((0)) FOR [SKRegistrace7]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__SkupinoveDPH]  DEFAULT ((0)) FOR [SkupinoveDPH]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__JeIdentifikovanaOsoba]  DEFAULT ((0)) FOR [JeIdentifikovanaOsoba]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__HodnotuDicDPHnaOrganizaciNeaktualizovat]  DEFAULT ((0)) FOR [HodnotuDicDPHnaOrganizaciNeaktualizovat]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabDICOrg] ADD  CONSTRAINT [DF__TabDICOrg__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabDICOrg]  WITH CHECK ADD  CONSTRAINT [FK__TabDICOrg__CisloOrg] FOREIGN KEY([CisloOrg])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabDICOrg] CHECK CONSTRAINT [FK__TabDICOrg__CisloOrg]
GO
ALTER TABLE [dbo].[TabDICOrg]  WITH CHECK ADD  CONSTRAINT [FK__TabDICOrg__ISOZeme] FOREIGN KEY([ISOZeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabDICOrg] CHECK CONSTRAINT [FK__TabDICOrg__ISOZeme]
GO
ALTER TABLE [dbo].[TabDICOrg] ENABLE TRIGGER [ht_ModifyDIC]
GO
