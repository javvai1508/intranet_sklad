-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDStavSkladu] [int] NOT NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[Nazev2] [nvarchar](100) NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[MnozstviDispo] [numeric](19, 6) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[DatZmeny] [datetime] NULL,
	[ZarukaVstup] [int] NOT NULL,
	[TypZarukaVstup] [tinyint] NOT NULL,
	[ZarukaVystup] [int] NOT NULL,
	[TypZarukaVystup] [tinyint] NOT NULL,
	[DatVstup] [datetime] NULL,
	[DatVystup] [datetime] NULL,
	[Poznamka] [ntext] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[DatExpirace] [datetime] NULL,
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
	[IDZakazModif] [int] NULL,
	[Objednano] [numeric](19, 6) NOT NULL,
	[MnozstviKPrijmu] [numeric](19, 6) NOT NULL,
	[MnozstviKVydeji] [numeric](19, 6) NOT NULL,
	[MnozstviHlidano] [numeric](19, 6) NOT NULL,
	[Rezervace]  AS ([Mnozstvi]-[MnozstviDispo]),
	[MnozSPrij]  AS ([Mnozstvi]+[MnozstviKPrijmu]),
	[MnozBezVyd]  AS ([Mnozstvi]-[MnozstviKVydeji]),
	[MnozSPrijBezVyd]  AS (CONVERT([numeric](20,6),([Mnozstvi]+[MnozstviKPrijmu])-[MnozstviKVydeji],0)),
	[MnozDispoSPrij]  AS ([MnozstviDispo]+[MnozstviKPrijmu]),
	[MnozDispoBezVyd]  AS ([MnozstviDispo]-[MnozstviKVydeji]),
	[MnozDispoSPrijBezVyd]  AS (CONVERT([numeric](20,6),([MnozstviDispo]+[MnozstviKPrijmu])-[MnozstviKVydeji],0)),
	[FinStav] [numeric](19, 6) NOT NULL,
	[Prumer] [numeric](19, 6) NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[IDVyrCK] [int] NULL,
	[MnozNaDObjKVyrizeni] [numeric](19, 6) NOT NULL,
	[BlokovanoProDObj] [numeric](19, 6) NOT NULL,
	[BlokovanoVydProDobj] [numeric](19, 6) NOT NULL,
	[MnozstviKryte] [numeric](19, 6) NOT NULL,
	[MnozNaGPrUMZKVyrizeni] [numeric](19, 6) NOT NULL,
	[BlokovanoProGPrUmz] [numeric](19, 6) NOT NULL,
	[BlokovanoVydProGPrUMZ] [numeric](19, 6) NOT NULL,
	[MnozstviKryteGPrUMZ] [numeric](19, 6) NOT NULL,
	[MnozFinReal] [numeric](19, 6) NOT NULL,
	[MnozZPrKVazKVyrizeni] [numeric](19, 6) NOT NULL,
	[BlokovanoProPrKVaz] [numeric](19, 6) NOT NULL,
	[BlokovanoVydProPrKVaz] [numeric](19, 6) NOT NULL,
	[MnozstviKrytePrKVaz] [numeric](19, 6) NOT NULL,
 CONSTRAINT [PK__TabVyrCS__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCS__IDStavSkladu__Nazev1] UNIQUE NONCLUSTERED 
(
	[IDStavSkladu] ASC,
	[Nazev1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Nazev1]  DEFAULT ('') FOR [Nazev1]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Nazev2]  DEFAULT ('') FOR [Nazev2]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviDispo]  DEFAULT ((0.0)) FOR [MnozstviDispo]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__ZarukaVstup]  DEFAULT ((0)) FOR [ZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__TypZarukaVstup]  DEFAULT ((0)) FOR [TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__ZarukaVystup]  DEFAULT ((0)) FOR [ZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__TypZarukaVystup]  DEFAULT ((0)) FOR [TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Objednano]  DEFAULT ((0.0)) FOR [Objednano]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviKPrijmu]  DEFAULT ((0.0)) FOR [MnozstviKPrijmu]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviKVydeji]  DEFAULT ((0.0)) FOR [MnozstviKVydeji]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviHlidano]  DEFAULT ((0.0)) FOR [MnozstviHlidano]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__FinStav]  DEFAULT ((0.0)) FOR [FinStav]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__Prumer]  DEFAULT ((0.0)) FOR [Prumer]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozNaDObjKVyrizeni]  DEFAULT ((0.0)) FOR [MnozNaDObjKVyrizeni]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoProDObj]  DEFAULT ((0.0)) FOR [BlokovanoProDObj]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoVydProDobj]  DEFAULT ((0.0)) FOR [BlokovanoVydProDobj]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviKryte]  DEFAULT ((0.0)) FOR [MnozstviKryte]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozNaGPrUMZKVyrizeni]  DEFAULT ((0.0)) FOR [MnozNaGPrUMZKVyrizeni]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoProGPrUmz]  DEFAULT ((0.0)) FOR [BlokovanoProGPrUmz]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoVydProGPrUMZ]  DEFAULT ((0.0)) FOR [BlokovanoVydProGPrUMZ]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviKryteGPrUMZ]  DEFAULT ((0.0)) FOR [MnozstviKryteGPrUMZ]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozFinReal]  DEFAULT ((0.0)) FOR [MnozFinReal]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozZPrKVazKVyrizeni]  DEFAULT ((0.0)) FOR [MnozZPrKVazKVyrizeni]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoProPrKVaz]  DEFAULT ((0.0)) FOR [BlokovanoProPrKVaz]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__BlokovanoVydProPrKVaz]  DEFAULT ((0.0)) FOR [BlokovanoVydProPrKVaz]
GO
ALTER TABLE [dbo].[TabVyrCS] ADD  CONSTRAINT [DF__TabVyrCS__MnozstviKrytePrKVaz]  DEFAULT ((0.0)) FOR [MnozstviKrytePrKVaz]
GO
ALTER TABLE [dbo].[TabVyrCS]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCS__IDStavSkladu] FOREIGN KEY([IDStavSkladu])
REFERENCES [dbo].[TabStavSkladu] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCS] CHECK CONSTRAINT [FK__TabVyrCS__IDStavSkladu]
GO
ALTER TABLE [dbo].[TabVyrCS]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCS__IDVyrCK] FOREIGN KEY([IDVyrCK])
REFERENCES [dbo].[TabVyrCK] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCS] CHECK CONSTRAINT [FK__TabVyrCS__IDVyrCK]
GO
ALTER TABLE [dbo].[TabVyrCS]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCS__IDZakazModif] FOREIGN KEY([IDZakazModif])
REFERENCES [dbo].[TabZakazModif] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCS] CHECK CONSTRAINT [FK__TabVyrCS__IDZakazModif]
GO
ALTER TABLE [dbo].[TabVyrCS]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCS__TypZarukaVstup] CHECK  (([TypZarukaVstup]>=(0) AND [TypZarukaVstup]<=(2)))
GO
ALTER TABLE [dbo].[TabVyrCS] CHECK CONSTRAINT [CK__TabVyrCS__TypZarukaVstup]
GO
ALTER TABLE [dbo].[TabVyrCS]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCS__TypZarukaVystup] CHECK  (([TypZarukaVystup]>=(0) AND [TypZarukaVystup]<=(2)))
GO
ALTER TABLE [dbo].[TabVyrCS] CHECK CONSTRAINT [CK__TabVyrCS__TypZarukaVystup]
GO
ALTER TABLE [dbo].[TabVyrCS] ENABLE TRIGGER [ht_TabVyrCS]
GO
