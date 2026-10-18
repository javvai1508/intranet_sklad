-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabStavSkladu](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDKmenZbozi] [int] NOT NULL,
	[IDSklad] [nvarchar](30) NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[MnozstviDispo] [numeric](19, 6) NOT NULL,
	[MnozstviKVydeji] [numeric](19, 6) NOT NULL,
	[StavSkladu] [numeric](19, 6) NOT NULL,
	[StavSkladuSouvis] [numeric](19, 6) NOT NULL,
	[Prumer] [numeric](19, 6) NOT NULL,
	[PrumerZadany] [numeric](19, 6) NOT NULL,
	[InventuraMn] [numeric](19, 6) NOT NULL,
	[InventuraCena] [numeric](19, 6) NOT NULL,
	[Minimum] [numeric](19, 6) NOT NULL,
	[Maximum] [numeric](19, 6) NOT NULL,
	[Sleva] [numeric](5, 2) NOT NULL,
	[Poznamka] [ntext] NULL,
	[UKod] [int] NULL,
	[Blokovano] [tinyint] NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[JizNaSklade] [bit] NOT NULL,
	[Objednano] [numeric](19, 6) NOT NULL,
	[KontrolaVC] [nchar](1) NOT NULL,
	[IDAkce] [int] NULL,
	[MnozstviKPrijmu] [numeric](19, 6) NOT NULL,
	[ZadavaniUmisteni] [smallint] NOT NULL,
	[MnozNaDObjKVyrizeni] [numeric](19, 6) NOT NULL,
	[MnozBezVyd]  AS ([Mnozstvi]-[MnozstviKVydeji]),
	[MnozDispoBezVyd]  AS ([MnozstviDispo]-[MnozstviKVydeji]),
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni],0),0),0)),
	[Rezervace]  AS ([Mnozstvi]-[MnozstviDispo]),
	[PodMin]  AS ([Minimum]-[Mnozstvi]),
	[NadMax]  AS ([Mnozstvi]-[Maximum]),
	[Inventura_Mn]  AS ([InventuraMn]-[Mnozstvi]),
	[Inventura_Fin]  AS ([InventuraCena]-[StavSkladu]),
	[MnozSPrij]  AS ([Mnozstvi]+[MnozstviKPrijmu]),
	[MnozDispoSPri]  AS ([MnozstviDispo]+[MnozstviKPrijmu]),
	[MnozSPrijBezVyd]  AS (CONVERT([numeric](20,6),([Mnozstvi]+[MnozstviKPrijmu])-[MnozstviKVydeji],0)),
	[MnozDispoSPrijBezVyd]  AS (CONVERT([numeric](20,6),([MnozstviDispo]+[MnozstviKPrijmu])-[MnozstviKVydeji],0)),
	[BlokovanoProDObj] [numeric](19, 6) NOT NULL,
	[MnozstviKryte] [numeric](19, 6) NOT NULL,
	[DruhEET] [tinyint] NOT NULL,
	[EET_cb_dic_poverujiciho] [tinyint] NOT NULL,
	[EET_dic_poverujiciho] [nvarchar](12) NULL,
	[Metoda] [tinyint] NOT NULL,
	[HraniceMarze] [numeric](5, 2) NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[CisloUcetPrijem] [nvarchar](30) NULL,
	[CisloUcetVydej] [nvarchar](30) NULL,
	[CisloUcetVydejEC] [nvarchar](30) NULL,
	[CisloUcetFAPrij] [nvarchar](30) NULL,
	[CisloUcetFAVyd] [nvarchar](30) NULL,
	[SkladPriPreskoc] [bit] NOT NULL,
	[PouzitMarzeOdDo] [bit] NOT NULL,
	[CisloUcetPrijem_DSN] [nvarchar](30) NULL,
	[CisloUcetVydej_DSN] [nvarchar](30) NULL,
	[CisloUcetVydejEC_DSN] [nvarchar](30) NULL,
	[CisloUcetFAPrij_DSN] [nvarchar](30) NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[PoslPrijem] [datetime] NULL,
	[PoslVydej] [datetime] NULL,
	[PoslPrijem_D]  AS (datepart(day,[PoslPrijem])),
	[PoslPrijem_M]  AS (datepart(month,[PoslPrijem])),
	[PoslPrijem_Y]  AS (datepart(year,[PoslPrijem])),
	[PoslPrijem_Q]  AS (datepart(quarter,[PoslPrijem])),
	[PoslPrijem_W]  AS (datepart(week,[PoslPrijem])),
	[PoslPrijem_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PoslPrijem])))),
	[PoslVydej_D]  AS (datepart(day,[PoslVydej])),
	[PoslVydej_M]  AS (datepart(month,[PoslVydej])),
	[PoslVydej_Y]  AS (datepart(year,[PoslVydej])),
	[PoslVydej_Q]  AS (datepart(quarter,[PoslVydej])),
	[PoslVydej_W]  AS (datepart(week,[PoslVydej])),
	[PoslVydej_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PoslVydej])))),
	[BlokovanoVydProDobj] [numeric](19, 6) NOT NULL,
	[MnozNaGPrUMZKVyrizeni] [numeric](19, 6) NOT NULL,
	[BlokovanoProGPrUMZ] [numeric](19, 6) NOT NULL,
	[BlokovanoVydProGPrUMZ] [numeric](19, 6) NOT NULL,
	[MnozstviKryteGPrUMZ] [numeric](19, 6) NOT NULL,
	[MnozFinReal] [numeric](19, 6) NOT NULL,
	[MnozZPrKVazKVyrizeni] [numeric](19, 6) NOT NULL,
	[BlokovanoProPrKVaz] [numeric](19, 6) NOT NULL,
	[BlokovanoVydProPrKVaz] [numeric](19, 6) NOT NULL,
	[MnozstviKrytePrKVaz] [numeric](19, 6) NOT NULL,
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
	[AVAReceivedDate] [datetime] NULL,
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
	[UcetZalohyZakladFP] [nvarchar](30) NULL,
	[UcetZalohyZakladFV] [nvarchar](30) NULL,
	[EETPovereniVicePopl] [tinyint] NOT NULL,
 CONSTRAINT [PK__TabStavSkladu__IDKmenZbozi__IDSklad] PRIMARY KEY CLUSTERED 
(
	[IDKmenZbozi] ASC,
	[IDSklad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabStavSkladu__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabStavSkladu__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabStavSkladu__AVAExternalID]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabStavSkladu__AVAExternalID] ON [dbo].[TabStavSkladu]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviDispo]  DEFAULT ((0.0)) FOR [MnozstviDispo]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviKVydeji]  DEFAULT ((0.0)) FOR [MnozstviKVydeji]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__StavSkladu]  DEFAULT ((0.0)) FOR [StavSkladu]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__StavSkladuSouvis]  DEFAULT ((0.0)) FOR [StavSkladuSouvis]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Prumer]  DEFAULT ((0.0)) FOR [Prumer]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__PrumerZadany]  DEFAULT ((0.0)) FOR [PrumerZadany]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__InventuraMn]  DEFAULT ((0.0)) FOR [InventuraMn]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__InventuraCena]  DEFAULT ((0.0)) FOR [InventuraCena]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Minimum]  DEFAULT ((0.0)) FOR [Minimum]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Maximum]  DEFAULT ((0.0)) FOR [Maximum]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Sleva]  DEFAULT ((0.0)) FOR [Sleva]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Blokovano]  DEFAULT ((0)) FOR [Blokovano]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__JizNaSklade]  DEFAULT ((1)) FOR [JizNaSklade]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Objednano]  DEFAULT ((0.0)) FOR [Objednano]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__KontrolaVC]  DEFAULT (N'C') FOR [KontrolaVC]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviKPrijmu]  DEFAULT ((0.0)) FOR [MnozstviKPrijmu]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__ZadavaniUmisteni]  DEFAULT ((5)) FOR [ZadavaniUmisteni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozNaDObjKVyrizeni]  DEFAULT ((0.0)) FOR [MnozNaDObjKVyrizeni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoProDObj]  DEFAULT ((0.0)) FOR [BlokovanoProDObj]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviKryte]  DEFAULT ((0.0)) FOR [MnozstviKryte]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__DruhEET]  DEFAULT ((5)) FOR [DruhEET]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__EET_cb_dic_poverujiciho]  DEFAULT ((0)) FOR [EET_cb_dic_poverujiciho]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__Metoda]  DEFAULT ((0)) FOR [Metoda]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__SkladPriPreskoc]  DEFAULT ((0)) FOR [SkladPriPreskoc]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__PouzitMarzeOdDo]  DEFAULT ((0)) FOR [PouzitMarzeOdDo]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoVydProDobj]  DEFAULT ((0.0)) FOR [BlokovanoVydProDobj]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozNaGPrUMZKVyrizeni]  DEFAULT ((0.0)) FOR [MnozNaGPrUMZKVyrizeni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoProGPrUMZ]  DEFAULT ((0.0)) FOR [BlokovanoProGPrUMZ]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoVydProGPrUMZ]  DEFAULT ((0.0)) FOR [BlokovanoVydProGPrUMZ]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviKryteGPrUMZ]  DEFAULT ((0.0)) FOR [MnozstviKryteGPrUMZ]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozFinReal]  DEFAULT ((0.0)) FOR [MnozFinReal]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozZPrKVazKVyrizeni]  DEFAULT ((0.0)) FOR [MnozZPrKVazKVyrizeni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoProPrKVaz]  DEFAULT ((0.0)) FOR [BlokovanoProPrKVaz]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__BlokovanoVydProPrKVaz]  DEFAULT ((0.0)) FOR [BlokovanoVydProPrKVaz]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__MnozstviKrytePrKVaz]  DEFAULT ((0.0)) FOR [MnozstviKrytePrKVaz]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__AVAOutputFlag]  DEFAULT ((0)) FOR [AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabStavSkladu] ADD  CONSTRAINT [DF__TabStavSkladu__EETPovereniVicePopl]  DEFAULT ((2)) FOR [EETPovereniVicePopl]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetFAPrij] FOREIGN KEY([CisloUcetFAPrij])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetFAPrij]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetFAPrij_DSN] FOREIGN KEY([CisloUcetFAPrij_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetFAPrij_DSN]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetFAVyd] FOREIGN KEY([CisloUcetFAVyd])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetFAVyd]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetPoklProd] FOREIGN KEY([CisloUcetPoklProd])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetPoklProd]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetPrijem] FOREIGN KEY([CisloUcetPrijem])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetPrijem]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetPrijem_DSN] FOREIGN KEY([CisloUcetPrijem_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetPrijem_DSN]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetVydej] FOREIGN KEY([CisloUcetVydej])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetVydej]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetVydej_DSN] FOREIGN KEY([CisloUcetVydej_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetVydej_DSN]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetVydejEC] FOREIGN KEY([CisloUcetVydejEC])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetVydejEC]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__CisloUcetVydejEC_DSN] FOREIGN KEY([CisloUcetVydejEC_DSN])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__CisloUcetVydejEC_DSN]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__IDAkce] FOREIGN KEY([IDAkce])
REFERENCES [dbo].[TabAkce] ([ID])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__IDAkce]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__IDKmenZbozi] FOREIGN KEY([IDKmenZbozi])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__IDKmenZbozi]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__IDSklad] FOREIGN KEY([IDSklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__IDSklad]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__UcetZalohyZakladFP] FOREIGN KEY([UcetZalohyZakladFP])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__UcetZalohyZakladFP]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [FK__TabStavSkladu__UcetZalohyZakladFV] FOREIGN KEY([UcetZalohyZakladFV])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [FK__TabStavSkladu__UcetZalohyZakladFV]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__AVAOutputFlag] CHECK  (([AVAOutputFlag]=(5) OR [AVAOutputFlag]=(4) OR [AVAOutputFlag]=(3) OR [AVAOutputFlag]=(2) OR [AVAOutputFlag]=(1) OR [AVAOutputFlag]=(0)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__AVAOutputFlag]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__Blokovano] CHECK  (([Blokovano]=(2) OR [Blokovano]=(1) OR [Blokovano]=(0)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__Blokovano]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__DruhEET] CHECK  (([DruhEET]>=(0) AND [DruhEET]<=(5)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__DruhEET]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__EET_cb_dic_poverujiciho] CHECK  (([EET_cb_dic_poverujiciho]>=(0) AND [EET_cb_dic_poverujiciho]<=(2)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__EET_cb_dic_poverujiciho]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__EETPovereniVicePopl] CHECK  (([EETPovereniVicePopl]>=(0) AND [EETPovereniVicePopl]<=(2)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__EETPovereniVicePopl]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__JizNaSklade] CHECK  (([JizNaSklade]=(1)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__JizNaSklade]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__KontrolaVC] CHECK  ((ascii([KontrolaVC])=(65) OR ascii([KontrolaVC])=(67) OR ascii([KontrolaVC])=(68) OR ascii([KontrolaVC])=(78) OR ascii([KontrolaVC])=(66)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__KontrolaVC]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__Metoda] CHECK  (([Metoda]>=(0) AND [Metoda]<=(11)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__Metoda]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__Mn] CHECK  (([Mnozstvi]>=[MnozstviDispo]))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__Mn]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__MnozFinReal] CHECK  (([MnozFinReal]>=(0)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__MnozFinReal]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__Mnozstvi] CHECK  (([Mnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__Mnozstvi]
GO
ALTER TABLE [dbo].[TabStavSkladu]  WITH CHECK ADD  CONSTRAINT [CK__TabStavSkladu__ZadavaniUmisteni] CHECK  (([ZadavaniUmisteni]>=(0) AND [ZadavaniUmisteni]<=(7)))
GO
ALTER TABLE [dbo].[TabStavSkladu] CHECK CONSTRAINT [CK__TabStavSkladu__ZadavaniUmisteni]
GO
ALTER TABLE [dbo].[TabStavSkladu] ENABLE TRIGGER [ht_Modify_StavSkladu]
GO
