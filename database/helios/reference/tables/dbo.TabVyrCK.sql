-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCK](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDKmenZbozi] [int] NOT NULL,
	[IDZakazModif] [int] NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[Nazev2] [nvarchar](100) NOT NULL,
	[ZarukaVstup] [int] NOT NULL,
	[ZarukaVystup] [int] NOT NULL,
	[TypZarukaVstup] [tinyint] NOT NULL,
	[TypZarukaVystup] [tinyint] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatVstup] [datetime] NULL,
	[DatVystup] [datetime] NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[DatZmeny] [datetime] NULL,
	[DatExpirace] [datetime] NULL,
	[Poznamka] [nvarchar](max) NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[DatVstup_D]  AS (datepart(day,[DatVstup])),
	[DatVstup_M]  AS (datepart(month,[DatVstup])),
	[DatVstup_Y]  AS (datepart(year,[DatVstup])),
	[DatVstup_Q]  AS (datepart(quarter,[DatVstup])),
	[DatVstup_W]  AS (datepart(week,[DatVstup])),
	[DatVstup_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatVstup])))),
	[DatVystup_D]  AS (datepart(day,[DatVystup])),
	[DatVystup_M]  AS (datepart(month,[DatVystup])),
	[DatVystup_Y]  AS (datepart(year,[DatVystup])),
	[DatVystup_Q]  AS (datepart(quarter,[DatVystup])),
	[DatVystup_W]  AS (datepart(week,[DatVystup])),
	[DatVystup_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatVystup])))),
	[DatExpirace_D]  AS (datepart(day,[DatExpirace])),
	[DatExpirace_M]  AS (datepart(month,[DatExpirace])),
	[DatExpirace_Y]  AS (datepart(year,[DatExpirace])),
	[DatExpirace_Q]  AS (datepart(quarter,[DatExpirace])),
	[DatExpirace_W]  AS (datepart(week,[DatExpirace])),
	[DatExpirace_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatExpirace])))),
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
	[VyrCKProvereni] [bit] NOT NULL,
	[DatVyroby] [datetime] NULL,
	[DatVyroby_D]  AS (datepart(day,[DatVyroby])),
	[DatVyroby_M]  AS (datepart(month,[DatVyroby])),
	[DatVyroby_Y]  AS (datepart(year,[DatVyroby])),
	[DatVyroby_Q]  AS (datepart(quarter,[DatVyroby])),
	[DatVyroby_W]  AS (datepart(week,[DatVyroby])),
	[DatVyroby_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatVyroby])))),
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
	[AVASentDate] [datetime] NULL,
	[AVASentDate_D]  AS (datepart(day,[AVASentDate])),
	[AVASentDate_M]  AS (datepart(month,[AVASentDate])),
	[AVASentDate_Y]  AS (datepart(year,[AVASentDate])),
	[AVASentDate_Q]  AS (datepart(quarter,[AVASentDate])),
	[AVASentDate_W]  AS (datepart(week,[AVASentDate])),
	[AVASentDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVASentDate])))),
	[VerzeSw] [nvarchar](20) NULL,
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
 CONSTRAINT [PK__TabVyrCK__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCK__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCK__IDKmenZbozi__Nazev1] UNIQUE NONCLUSTERED 
(
	[IDKmenZbozi] ASC,
	[Nazev1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabVyrCK__AVAExternalID]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabVyrCK__AVAExternalID] ON [dbo].[TabVyrCK]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__Nazev1]  DEFAULT ('') FOR [Nazev1]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__Nazev2]  DEFAULT ('') FOR [Nazev2]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__ZarukaVstup]  DEFAULT ((0)) FOR [ZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__ZarukaVystup]  DEFAULT ((0)) FOR [ZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__TypZarukaVstup]  DEFAULT ((0)) FOR [TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__TypZarukaVystup]  DEFAULT ((0)) FOR [TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__VyrCKProvereni]  DEFAULT ((0)) FOR [VyrCKProvereni]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabVyrCK] ADD  CONSTRAINT [DF__TabVyrCK__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabVyrCK]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCK__IDKmenZbozi] FOREIGN KEY([IDKmenZbozi])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCK] CHECK CONSTRAINT [FK__TabVyrCK__IDKmenZbozi]
GO
ALTER TABLE [dbo].[TabVyrCK]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCK__IDZakazModif] FOREIGN KEY([IDZakazModif])
REFERENCES [dbo].[TabZakazModif] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCK] CHECK CONSTRAINT [FK__TabVyrCK__IDZakazModif]
GO
ALTER TABLE [dbo].[TabVyrCK]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCK__TypZarukaVstup] CHECK  (([TypZarukaVstup]>=(0) AND [TypZarukaVstup]<=(2)))
GO
ALTER TABLE [dbo].[TabVyrCK] CHECK CONSTRAINT [CK__TabVyrCK__TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCK]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCK__TypZarukaVystup] CHECK  (([TypZarukaVystup]>=(0) AND [TypZarukaVystup]<=(2)))
GO
ALTER TABLE [dbo].[TabVyrCK] CHECK CONSTRAINT [CK__TabVyrCK__TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCK] ENABLE TRIGGER [ht_TabVyrCK]
GO
ALTER TABLE [dbo].[TabVyrCK] ENABLE TRIGGER [ht_VyrCK_AVAModel_Change]
GO
