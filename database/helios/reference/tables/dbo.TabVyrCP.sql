-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPolozkaDokladu] [int] NOT NULL,
	[IDVyrCis] [int] NOT NULL,
	[Nazev] [nvarchar](100) NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[Odebrano] [numeric](19, 6) NOT NULL,
	[DatVstup] [datetime] NULL,
	[DatVystup] [datetime] NULL,
	[IdUmisteni] [int] NULL,
	[Poznamka] [ntext] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[DatExpirace] [datetime] NULL,
	[DatVstup_D]  AS (datepart(day,[DatVstup])),
	[DatVstup_M]  AS (datepart(month,[DatVstup])),
	[DatVstup_Y]  AS (datepart(year,[DatVstup])),
	[DatVstup_Q]  AS (datepart(quarter,[DatVstup])),
	[DatVstup_W]  AS (datepart(week,[DatVstup])),
	[DatVstup_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatVstup],0),0),0)),
	[DatVystup_D]  AS (datepart(day,[DatVystup])),
	[DatVystup_M]  AS (datepart(month,[DatVystup])),
	[DatVystup_Y]  AS (datepart(year,[DatVystup])),
	[DatVystup_Q]  AS (datepart(quarter,[DatVystup])),
	[DatVystup_W]  AS (datepart(week,[DatVystup])),
	[DatVystup_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatVystup],0),0),0)),
	[DatExpirace_D]  AS (datepart(day,[DatExpirace])),
	[DatExpirace_M]  AS (datepart(month,[DatExpirace])),
	[DatExpirace_Y]  AS (datepart(year,[DatExpirace])),
	[DatExpirace_Q]  AS (datepart(quarter,[DatExpirace])),
	[DatExpirace_W]  AS (datepart(week,[DatExpirace])),
	[DatExpirace_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatExpirace],0),0),0)),
	[MnozstviReal] [numeric](19, 6) NOT NULL,
	[Vznik] [tinyint] NOT NULL,
	[MnozOdebrane] [numeric](19, 6) NOT NULL,
	[CCEvid] [numeric](19, 6) NOT NULL,
	[CCevidPozadovana] [numeric](19, 6) NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[VydMnozstviVyrCProvereno] [bit] NOT NULL,
	[VraceneMnozstvi] [numeric](19, 6) NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatPorizeni] [datetime] NOT NULL,
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
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
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
 CONSTRAINT [UQ__TabVyrCP__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCP__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCP__IDVyrCis__IDPolozkaDokladu] UNIQUE NONCLUSTERED 
(
	[IDVyrCis] ASC,
	[IDPolozkaDokladu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IC__TabVyrCP__IDPolozkaDokladu]    Script Date: 18.10.2026 20:33:01 ******/
CREATE CLUSTERED INDEX [IC__TabVyrCP__IDPolozkaDokladu] ON [dbo].[TabVyrCP]
(
	[IDPolozkaDokladu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabVyrCP__AVAExternalID]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabVyrCP__AVAExternalID] ON [dbo].[TabVyrCP]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__Odebrano]  DEFAULT ((0.0)) FOR [Odebrano]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__MnozstviReal]  DEFAULT ((0.0)) FOR [MnozstviReal]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__Vznik]  DEFAULT ((0)) FOR [Vznik]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__MnozOdebrane]  DEFAULT ((0.0)) FOR [MnozOdebrane]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__CCEvid]  DEFAULT ((0.0)) FOR [CCEvid]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__CCevidPozadovana]  DEFAULT ((0.0)) FOR [CCevidPozadovana]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__VydMnozstviVyrCProvereno]  DEFAULT ((0)) FOR [VydMnozstviVyrCProvereno]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__VraceneMnozstvi]  DEFAULT ((0.0)) FOR [VraceneMnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabVyrCP] ADD  CONSTRAINT [DF__TabVyrCP__AVAItemOutputFlag]  DEFAULT ((0)) FOR [AVAItemOutputFlag]
GO
ALTER TABLE [dbo].[TabVyrCP]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCP__IDPolozkaDokladu] FOREIGN KEY([IDPolozkaDokladu])
REFERENCES [dbo].[TabPohybyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCP] CHECK CONSTRAINT [FK__TabVyrCP__IDPolozkaDokladu]
GO
ALTER TABLE [dbo].[TabVyrCP]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCP__IdUmisteni] FOREIGN KEY([IdUmisteni])
REFERENCES [dbo].[TabVStavUmisteni] ([Id])
GO
ALTER TABLE [dbo].[TabVyrCP] CHECK CONSTRAINT [FK__TabVyrCP__IdUmisteni]
GO
ALTER TABLE [dbo].[TabVyrCP]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCP__IDVyrCis] FOREIGN KEY([IDVyrCis])
REFERENCES [dbo].[TabVyrCS] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCP] CHECK CONSTRAINT [FK__TabVyrCP__IDVyrCis]
GO
ALTER TABLE [dbo].[TabVyrCP]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCP__AVAItemOutputFlag] CHECK  (([AVAItemOutputFlag]=(5) OR [AVAItemOutputFlag]=(4) OR [AVAItemOutputFlag]=(3) OR [AVAItemOutputFlag]=(2) OR [AVAItemOutputFlag]=(1) OR [AVAItemOutputFlag]=(0)))
GO
ALTER TABLE [dbo].[TabVyrCP] CHECK CONSTRAINT [CK__TabVyrCP__AVAItemOutputFlag]
GO
ALTER TABLE [dbo].[TabVyrCP]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCP__Vznik] CHECK  (([Vznik]>=(0) AND [Vznik]<=(1)))
GO
ALTER TABLE [dbo].[TabVyrCP] CHECK CONSTRAINT [CK__TabVyrCP__Vznik]
GO
ALTER TABLE [dbo].[TabVyrCP] ENABLE TRIGGER [ht_TabVyrCP]
GO
