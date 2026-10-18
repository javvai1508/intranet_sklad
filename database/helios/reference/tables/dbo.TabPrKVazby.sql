-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPrKVazby](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Doklad] [int] NOT NULL,
	[IDPrikaz] [int] NOT NULL,
	[Prednastaveno] [bit] NOT NULL,
	[predzpracovano] [bit] NOT NULL,
	[Sklad] [nvarchar](30) NULL,
	[VyrStredisko] [nvarchar](30) NULL,
	[IDPracoviste] [int] NULL,
	[mnoz_zad] [numeric](19, 6) NOT NULL,
	[Mnoz_nepotrebne] [numeric](19, 6) NOT NULL,
	[Mnoz_skut_realizovane] [numeric](19, 6) NOT NULL,
	[Mnoz_odv] [numeric](19, 6) NOT NULL,
	[mat_real] [numeric](19, 6) NOT NULL,
	[MatRezie_real] [numeric](19, 6) NOT NULL,
	[koop_real] [numeric](19, 6) NOT NULL,
	[mzda_real] [numeric](19, 6) NOT NULL,
	[rezieS_real] [numeric](19, 6) NOT NULL,
	[rezieP_real] [numeric](19, 6) NOT NULL,
	[ReziePrac_real] [numeric](19, 6) NOT NULL,
	[NakladyPrac_real] [numeric](19, 6) NOT NULL,
	[OPN_real] [numeric](19, 6) NOT NULL,
	[VedProdukt_real] [numeric](19, 6) NOT NULL,
	[naradi_real] [numeric](19, 6) NOT NULL,
	[NespecNakl_real] [numeric](19, 6) NOT NULL,
	[mat_odv] [numeric](19, 6) NOT NULL,
	[MatRezie_odv] [numeric](19, 6) NOT NULL,
	[koop_odv] [numeric](19, 6) NOT NULL,
	[mzda_odv] [numeric](19, 6) NOT NULL,
	[rezieS_odv] [numeric](19, 6) NOT NULL,
	[rezieP_odv] [numeric](19, 6) NOT NULL,
	[ReziePrac_odv] [numeric](19, 6) NOT NULL,
	[NakladyPrac_odv] [numeric](19, 6) NOT NULL,
	[OPN_odv] [numeric](19, 6) NOT NULL,
	[VedProdukt_odv] [numeric](19, 6) NOT NULL,
	[naradi_odv] [numeric](19, 6) NOT NULL,
	[NespecNakl_odv] [numeric](19, 6) NOT NULL,
	[Uzavreno] [bit] NOT NULL,
	[AutorUzavreni] [nvarchar](128) NULL,
	[IDOdchylkyOd] [int] NULL,
	[IDOdchylkyDo] [int] NULL,
	[RefMnoz] [numeric](19, 6) NOT NULL,
	[VydanoRefMnoz] [numeric](19, 6) NOT NULL,
	[priorita] [int] NOT NULL,
	[vyssi] [int] NOT NULL,
	[nizsi] [int] NOT NULL,
	[DavkaTPV] [numeric](19, 6) NOT NULL,
	[pozice] [nvarchar](100) NULL,
	[Operace] [nchar](4) NULL,
	[FixniMnozstvi] [numeric](19, 6) NOT NULL,
	[mnozstvi] [numeric](19, 6) NOT NULL,
	[ProcZtrat] [numeric](5, 2) NOT NULL,
	[mnozstviSeZtratou] [numeric](19, 6) NOT NULL,
	[Prirez] [numeric](19, 6) NOT NULL,
	[SpotRozmer] [nvarchar](100) NULL,
	[IDVzorceSpotMat] [int] NULL,
	[PromA] [numeric](19, 6) NULL,
	[PromB] [numeric](19, 6) NULL,
	[PromC] [numeric](19, 6) NULL,
	[PromD] [numeric](19, 6) NULL,
	[PromE] [numeric](19, 6) NULL,
	[Poznamka] [nvarchar](max) NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[AutorTisku] [nvarchar](128) NULL,
	[DatumTisku] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[ID1] [int] NOT NULL,
	[RezijniMat] [bit] NOT NULL,
	[VyraditZKalkulace] [bit] NOT NULL,
	[Cena_real]  AS (CONVERT([numeric](19,6),(((((((((([mat_real]+[MatRezie_real])+[koop_real])+[mzda_real])+[rezieS_real])+[rezieP_real])+[ReziePrac_real])+[NakladyPrac_real])+[OPN_real])-[VedProdukt_real])+[naradi_real])+[NespecNakl_real],0)),
	[JeNeco_real]  AS (CONVERT([bit],case when [Mnoz_skut_realizovane]<>(0.0) OR [mat_real]<>(0.0) OR [MatRezie_real]<>(0.0) OR [koop_real]<>(0.0) OR [mzda_real]<>(0.0) OR [rezieS_real]<>(0.0) OR [rezieP_real]<>(0.0) OR [ReziePrac_real]<>(0.0) OR [NakladyPrac_real]<>(0.0) OR [OPN_real]<>(0.0) OR [VedProdukt_real]<>(0.0) OR [naradi_real]<>(0.0) OR [NespecNakl_real]<>(0.0) then (1) else (0) end,0)),
	[Cena_odv]  AS (CONVERT([numeric](19,6),(((((((((([mat_odv]+[MatRezie_odv])+[koop_odv])+[mzda_odv])+[rezieS_odv])+[rezieP_odv])+[ReziePrac_odv])+[NakladyPrac_odv])+[OPN_odv])-[VedProdukt_odv])+[naradi_odv])+[NespecNakl_odv],0)),
	[JeNeco_NeOdv]  AS (CONVERT([bit],case when [Mnoz_skut_realizovane]<>[Mnoz_odv] OR [mat_real]<>[mat_odv] OR [MatRezie_real]<>[MatRezie_odv] OR [koop_real]<>[koop_odv] OR [mzda_real]<>[mzda_odv] OR [rezieS_real]<>[rezieS_odv] OR [rezieP_real]<>[rezieP_odv] OR [ReziePrac_real]<>[ReziePrac_odv] OR [NakladyPrac_real]<>[NakladyPrac_odv] OR [OPN_real]<>[OPN_odv] OR [VedProdukt_real]<>[VedProdukt_odv] OR [naradi_real]<>[naradi_odv] OR [NespecNakl_real]<>[NespecNakl_odv] then (1) else (0) end,0)),
	[Odchylkovano]  AS (CONVERT([bit],case when [IDOdchylkyOd] IS NULL then (0) else (1) end,0)),
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
	[Vytisteno]  AS (CONVERT([bit],case when [DatumTisku] IS NULL then (0) else (1) end,0)),
	[DatumTisku_D]  AS (datepart(day,[DatumTisku])),
	[DatumTisku_M]  AS (datepart(month,[DatumTisku])),
	[DatumTisku_Y]  AS (datepart(year,[DatumTisku])),
	[DatumTisku_Q]  AS (datepart(quarter,[DatumTisku])),
	[DatumTisku_W]  AS (datepart(week,[DatumTisku])),
	[DatumTisku_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumTisku],0),0),0)),
	[LastRecord]  AS (CONVERT([tinyint],case when [IDOdchylkyDo] IS NULL then (1) else (0) end,0)),
	[mnoz_pozadovane]  AS (CONVERT([numeric](19,6),case when [mnoz_nepotrebne]>[mnoz_zad] then (0.0) else [mnoz_zad]-[mnoz_nepotrebne] end,0)),
	[matA_real] [numeric](19, 6) NOT NULL,
	[matB_real] [numeric](19, 6) NOT NULL,
	[matC_real] [numeric](19, 6) NOT NULL,
	[matA_odv] [numeric](19, 6) NOT NULL,
	[matB_odv] [numeric](19, 6) NOT NULL,
	[matC_odv] [numeric](19, 6) NOT NULL,
	[mnoz_Nevydane]  AS (CONVERT([numeric](19,6),case when ([VydanoRefMnoz]-[RefMnoz])>(-0.0001) then (0.0) else [mnoz_zad]-([VydanoRefMnoz]*[mnoz_zad])/[RefMnoz] end,0)),
	[Splneno]  AS (CONVERT([bit],case when ([VydanoRefMnoz]-[RefMnoz])>(-0.0001) OR [Uzavreno]=(1) OR [RezijniMat]=(1) then (1) else (0) end,0)),
	[ProcSplneni]  AS (CONVERT([numeric](19,6),case when ([VydanoRefMnoz]-[RefMnoz])>(-0.0001) OR [Uzavreno]=(1) OR [RezijniMat]=(1) then (100.0) else ((100.0)*[VydanoRefMnoz])/[RefMnoz] end,0)),
	[VychoziSklad] [nvarchar](30) NULL,
	[UzivNastSklad] [bit] NOT NULL,
	[UzivZadaniPrirezu]  AS (CONVERT([bit],case when [mnozstvi]>(0.0) AND [mnozstvi]=[Prirez] OR [mnozstvi]=(0.0) AND [FixniMnozstvi]=[Prirez] then (0) else (1) end)),
	[KopirovatVC] [bit] NOT NULL,
 CONSTRAINT [PK__TabPrKVazby__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrKVazby__IDPrikaz__Doklad__IDOdchylkyDo__Priorita] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[Doklad] ASC,
	[IDOdchylkyDo] ASC,
	[priorita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrKVazby__IDPrikaz__IDOdchylkyDo__Doklad__nizsi] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[IDOdchylkyDo] ASC,
	[Doklad] ASC,
	[nizsi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrKVazby__ID1__IDOdchylkyDo]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrKVazby__ID1__IDOdchylkyDo] ON [dbo].[TabPrKVazby]
(
	[ID1] ASC,
	[IDOdchylkyDo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrKVazby__IDPrikaz__IDOdchylkyDo__vyssi__operace]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrKVazby__IDPrikaz__IDOdchylkyDo__vyssi__operace] ON [dbo].[TabPrKVazby]
(
	[IDPrikaz] ASC,
	[IDOdchylkyDo] ASC,
	[vyssi] ASC,
	[Operace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrKVazby__IDPrikaz__IDOdchylkyDo__vyssi__pozice]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrKVazby__IDPrikaz__IDOdchylkyDo__vyssi__pozice] ON [dbo].[TabPrKVazby]
(
	[IDPrikaz] ASC,
	[IDOdchylkyDo] ASC,
	[vyssi] ASC,
	[pozice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrKVazby__nizsi__sklad__IDOdchylkyDo]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrKVazby__nizsi__sklad__IDOdchylkyDo] ON [dbo].[TabPrKVazby]
(
	[nizsi] ASC,
	[Sklad] ASC,
	[IDOdchylkyDo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Prednastaveno]  DEFAULT ((1)) FOR [Prednastaveno]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__predzpracovano]  DEFAULT ((0)) FOR [predzpracovano]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mnoz_zad]  DEFAULT ((1)) FOR [mnoz_zad]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Mnoz_nepotrebne]  DEFAULT ((0)) FOR [Mnoz_nepotrebne]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Mnoz_skut_realizovane]  DEFAULT ((0)) FOR [Mnoz_skut_realizovane]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Mnoz_odv]  DEFAULT ((0)) FOR [Mnoz_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mat_real]  DEFAULT ((0)) FOR [mat_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__MatRezie_real]  DEFAULT ((0)) FOR [MatRezie_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__koop_real]  DEFAULT ((0)) FOR [koop_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mzda_real]  DEFAULT ((0)) FOR [mzda_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__rezieS_real]  DEFAULT ((0)) FOR [rezieS_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__rezieP_real]  DEFAULT ((0)) FOR [rezieP_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__ReziePrac_real]  DEFAULT ((0)) FOR [ReziePrac_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__NakladyPrac_real]  DEFAULT ((0)) FOR [NakladyPrac_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__OPN_real]  DEFAULT ((0)) FOR [OPN_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__VedProdukt_real]  DEFAULT ((0)) FOR [VedProdukt_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__naradi_real]  DEFAULT ((0)) FOR [naradi_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__NespecNakl_real]  DEFAULT ((0)) FOR [NespecNakl_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mat_odv]  DEFAULT ((0)) FOR [mat_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__MatRezie_odv]  DEFAULT ((0)) FOR [MatRezie_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__koop_odv]  DEFAULT ((0)) FOR [koop_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mzda_odv]  DEFAULT ((0)) FOR [mzda_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__rezieS_odv]  DEFAULT ((0)) FOR [rezieS_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__rezieP_odv]  DEFAULT ((0)) FOR [rezieP_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__ReziePrac_odv]  DEFAULT ((0)) FOR [ReziePrac_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__NakladyPrac_odv]  DEFAULT ((0)) FOR [NakladyPrac_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__OPN_odv]  DEFAULT ((0)) FOR [OPN_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__VedProdukt_odv]  DEFAULT ((0)) FOR [VedProdukt_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__naradi_odv]  DEFAULT ((0)) FOR [naradi_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__NespecNakl_odv]  DEFAULT ((0)) FOR [NespecNakl_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Uzavreno]  DEFAULT ((0)) FOR [Uzavreno]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__RefMnoz]  DEFAULT ((0)) FOR [RefMnoz]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__VydanoRefMnoz]  DEFAULT ((0)) FOR [VydanoRefMnoz]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__priorita]  DEFAULT ((0)) FOR [priorita]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__DavkaTPV]  DEFAULT ((1)) FOR [DavkaTPV]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__pozice]  DEFAULT ('') FOR [pozice]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__FixniMnozstvi]  DEFAULT ((0)) FOR [FixniMnozstvi]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mnozstvi]  DEFAULT ((1)) FOR [mnozstvi]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__ProcZtrat]  DEFAULT ((0)) FOR [ProcZtrat]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__mnozstviSeZtratou]  DEFAULT ((1)) FOR [mnozstviSeZtratou]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Prirez]  DEFAULT ((1)) FOR [Prirez]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__ID1]  DEFAULT ((0)) FOR [ID1]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__RezijniMat]  DEFAULT ((0)) FOR [RezijniMat]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__VyraditZKalkulace]  DEFAULT ((0)) FOR [VyraditZKalkulace]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matA_real]  DEFAULT ((0)) FOR [matA_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matB_real]  DEFAULT ((0)) FOR [matB_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matC_real]  DEFAULT ((0)) FOR [matC_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matA_odv]  DEFAULT ((0)) FOR [matA_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matB_odv]  DEFAULT ((0)) FOR [matB_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__matC_odv]  DEFAULT ((0)) FOR [matC_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__UzivNastSklad]  DEFAULT ((0)) FOR [UzivNastSklad]
GO
ALTER TABLE [dbo].[TabPrKVazby] ADD  CONSTRAINT [DF__TabPrKVazby__KopirovatVC]  DEFAULT ((0)) FOR [KopirovatVC]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__IDOdchylkyDo] FOREIGN KEY([IDOdchylkyDo])
REFERENCES [dbo].[TabCOdchylek] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__IDOdchylkyDo]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__IDOdchylkyOd] FOREIGN KEY([IDOdchylkyOd])
REFERENCES [dbo].[TabCOdchylek] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__IDOdchylkyOd]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__IDPracoviste] FOREIGN KEY([IDPracoviste])
REFERENCES [dbo].[TabCPraco] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__IDPracoviste]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__IDPrikaz] FOREIGN KEY([IDPrikaz])
REFERENCES [dbo].[TabPrikaz] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__IDPrikaz]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__IDVzorceSpotMat] FOREIGN KEY([IDVzorceSpotMat])
REFERENCES [dbo].[TabCVzorcuSpotMat] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__IDVzorceSpotMat]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__nizsi] FOREIGN KEY([nizsi])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__nizsi]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__Sklad] FOREIGN KEY([Sklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__Sklad]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__VychoziSklad] FOREIGN KEY([VychoziSklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__VychoziSklad]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__VyrStredisko] FOREIGN KEY([VyrStredisko])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__VyrStredisko]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [FK__TabPrKVazby__vyssi] FOREIGN KEY([vyssi])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [FK__TabPrKVazby__vyssi]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__DavkaTPV] CHECK  (([DavkaTPV]>(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__DavkaTPV]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__Doklad] CHECK  (([Doklad]>(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__Doklad]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__FixniMnozstvi] CHECK  (([FixniMnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__FixniMnozstvi]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__koop_odv] CHECK  (([koop_odv]>=(0) AND [koop_odv]<=[koop_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__koop_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__koop_real] CHECK  (([koop_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__koop_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mat_odv] CHECK  (([mat_odv]>=(0) AND [mat_odv]<=[mat_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mat_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mat_real] CHECK  (([mat_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mat_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matA_odv] CHECK  (([matA_odv]>=(0) AND [matA_odv]<=[matA_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matA_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matA_real] CHECK  (([matA_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matA_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matB_odv] CHECK  (([matB_odv]>=(0) AND [matB_odv]<=[matB_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matB_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matB_real] CHECK  (([matB_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matB_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matC_odv] CHECK  (([matC_odv]>=(0) AND [matC_odv]<=[matC_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matC_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__matC_real] CHECK  (([matC_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__matC_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__MatRezie_odv] CHECK  (([MatRezie_odv]>=(0) AND [MatRezie_odv]<=[MatRezie_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__MatRezie_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__MatRezie_real] CHECK  (([MatRezie_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__MatRezie_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__Mnoz_nepotrebne] CHECK  (([Mnoz_nepotrebne]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__Mnoz_nepotrebne]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__Mnoz_odv] CHECK  (([Mnoz_odv]>=(0) AND [Mnoz_odv]<=[Mnoz_skut_realizovane]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__Mnoz_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__Mnoz_skut_realizovane] CHECK  (([Mnoz_skut_realizovane]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__Mnoz_skut_realizovane]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mnoz_zad] CHECK  (([mnoz_zad]>(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mnoz_zad]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mnozstvi] CHECK  (([mnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mnozstvi]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mnozstviSeZtratou] CHECK  (([mnozstviSeZtratou]>=[mnozstvi]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mnozstviSeZtratou]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mzda_odv] CHECK  (([mzda_odv]>=(0) AND [mzda_odv]<=[mzda_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mzda_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__mzda_real] CHECK  (([mzda_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__mzda_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__NakladyPrac_odv] CHECK  (([NakladyPrac_odv]>=(0) AND [NakladyPrac_odv]<=[NakladyPrac_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__NakladyPrac_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__NakladyPrac_real] CHECK  (([NakladyPrac_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__NakladyPrac_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__naradi_odv] CHECK  (([naradi_odv]>=(0) AND [naradi_odv]<=[naradi_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__naradi_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__naradi_real] CHECK  (([naradi_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__naradi_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__OPN_odv] CHECK  (([OPN_odv]>=(0) AND [OPN_odv]<=[OPN_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__OPN_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__OPN_real] CHECK  (([OPN_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__OPN_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__priorita] CHECK  (([priorita]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__priorita]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__Prirez] CHECK  (([Prirez]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__Prirez]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__ProcZtrat] CHECK  (([ProcZtrat]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__ProcZtrat]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__rezieP_odv] CHECK  (([rezieP_odv]>=(0) AND [rezieP_odv]<=[rezieP_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__rezieP_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__rezieP_real] CHECK  (([rezieP_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__rezieP_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__ReziePrac_odv] CHECK  (([ReziePrac_odv]>=(0) AND [ReziePrac_odv]<=[ReziePrac_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__ReziePrac_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__ReziePrac_real] CHECK  (([ReziePrac_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__ReziePrac_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__rezieS_odv] CHECK  (([rezieS_odv]>=(0) AND [rezieS_odv]<=[rezieS_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__rezieS_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__rezieS_real] CHECK  (([rezieS_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__rezieS_real]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__VedProdukt_odv] CHECK  (([VedProdukt_odv]>=(0) AND [VedProdukt_odv]<=[VedProdukt_real]))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__VedProdukt_odv]
GO
ALTER TABLE [dbo].[TabPrKVazby]  WITH CHECK ADD  CONSTRAINT [CK__TabPrKVazby__VedProdukt_real] CHECK  (([VedProdukt_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrKVazby] CHECK CONSTRAINT [CK__TabPrKVazby__VedProdukt_real]
GO
ALTER TABLE [dbo].[TabPrKVazby] ENABLE TRIGGER [ht_PrKVazby_insert_update_delete]
GO
ALTER TABLE [dbo].[TabPrKVazby] ENABLE TRIGGER [ht_PrKVazby_insert_update_delete_2]
GO
