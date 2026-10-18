-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabDokZboDodatek](
	[IDHlavicky] [int] NOT NULL,
	[FIntrMonthMsg] [int] NULL,
	[ZemeUrceni] [nvarchar](2) NOT NULL,
	[RegionUrceniPuvodu] [tinyint] NULL,
	[DodaciPodminky] [nvarchar](3) NOT NULL,
	[DD] [tinyint] NULL,
	[PovahaTransakce] [tinyint] NULL,
	[ZPZ] [nvarchar](2) NULL,
	[ZPZtext] [nvarchar](40) NOT NULL,
	[PoziceZaokrDPHHla] [tinyint] NOT NULL,
	[HraniceZaokrDPHHla] [tinyint] NOT NULL,
	[ZaokrNaPadesat] [smallint] NOT NULL,
	[DatPrijOdeslZbozi] [datetime] NULL,
	[DatumTisku] [datetime] NULL,
	[Guid] [nchar](32) NOT NULL,
	[Stav] [tinyint] NOT NULL,
	[DatumOdeslani] [datetime] NULL,
	[DatumPrijetiPVS] [datetime] NULL,
	[DatumZpracovani] [datetime] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[FIntrMonthMsgAnoNe]  AS (CONVERT([bit],case when [FIntrMonthMsg] IS NULL then (0) else (1) end,0)),
	[DatPrijOdeslZbozi_D]  AS (datepart(day,[DatPrijOdeslZbozi])),
	[DatPrijOdeslZbozi_M]  AS (datepart(month,[DatPrijOdeslZbozi])),
	[DatPrijOdeslZbozi_Y]  AS (datepart(year,[DatPrijOdeslZbozi])),
	[DatPrijOdeslZbozi_Q]  AS (datepart(quarter,[DatPrijOdeslZbozi])),
	[DatPrijOdeslZbozi_W]  AS (datepart(week,[DatPrijOdeslZbozi])),
	[DatPrijOdeslZbozi_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPrijOdeslZbozi],0),0),0)),
	[DatumOdeslani_D]  AS (datepart(day,[DatumOdeslani])),
	[DatumOdeslani_M]  AS (datepart(month,[DatumOdeslani])),
	[DatumOdeslani_Y]  AS (datepart(year,[DatumOdeslani])),
	[DatumOdeslani_Q]  AS (datepart(quarter,[DatumOdeslani])),
	[DatumOdeslani_W]  AS (datepart(week,[DatumOdeslani])),
	[DatumOdeslani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumOdeslani],0),0),0)),
	[DatumPrijetiPVS_D]  AS (datepart(day,[DatumPrijetiPVS])),
	[DatumPrijetiPVS_M]  AS (datepart(month,[DatumPrijetiPVS])),
	[DatumPrijetiPVS_Y]  AS (datepart(year,[DatumPrijetiPVS])),
	[DatumPrijetiPVS_Q]  AS (datepart(quarter,[DatumPrijetiPVS])),
	[DatumPrijetiPVS_W]  AS (datepart(week,[DatumPrijetiPVS])),
	[DatumPrijetiPVS_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumPrijetiPVS],0),0),0)),
	[DatumZpracovani_D]  AS (datepart(day,[DatumZpracovani])),
	[DatumZpracovani_M]  AS (datepart(month,[DatumZpracovani])),
	[DatumZpracovani_Y]  AS (datepart(year,[DatumZpracovani])),
	[DatumZpracovani_Q]  AS (datepart(quarter,[DatumZpracovani])),
	[DatumZpracovani_W]  AS (datepart(week,[DatumZpracovani])),
	[DatumZpracovani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumZpracovani],0),0),0)),
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
	[PoziceZaokrDPHTxt] [tinyint] NOT NULL,
	[HraniceZaokrDPHTxt] [tinyint] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VypocetSumaKcPoZao] [tinyint] NOT NULL,
	[ZapoctiStornoDoOdebMnoz] [bit] NOT NULL,
	[KoeficientDPH] [bit] NOT NULL,
	[DatumSchvaleni] [datetime] NULL,
	[PovolitUpravuDPH] [bit] NOT NULL,
	[DatumSchvaleni_D]  AS (datepart(day,[DatumSchvaleni])),
	[DatumSchvaleni_M]  AS (datepart(month,[DatumSchvaleni])),
	[DatumSchvaleni_Y]  AS (datepart(year,[DatumSchvaleni])),
	[DatumSchvaleni_Q]  AS (datepart(quarter,[DatumSchvaleni])),
	[DatumSchvaleni_W]  AS (datepart(week,[DatumSchvaleni])),
	[DatumSchvaleni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumSchvaleni],0),0),0)),
	[Schvaleno]  AS (CONVERT([bit],case when [DatumSchvaleni] IS NULL then (0) else (1) end,0)),
	[StavSkonta] [smallint] NULL,
	[DOBJZapoctiStornoCiDobropis] [bit] NOT NULL,
	[Schvalil] [nvarchar](128) NULL,
	[CastkaRPT] [numeric](19, 6) NOT NULL,
	[CastkaRPTCM] [numeric](19, 6) NOT NULL,
	[PTRU] [bit] NOT NULL,
	[PTRUCastka] [numeric](19, 6) NOT NULL,
	[PTRUCastkaCM] [numeric](19, 6) NOT NULL,
	[IDDokladOprava] [int] NULL,
	[RezimKurzuDPHFaktur] [tinyint] NOT NULL,
	[Aktivni] [bit] NOT NULL,
	[DatumAkceptace] [datetime] NULL,
	[Akceptovano]  AS (CONVERT([bit],case when [DatumAkceptace] IS NULL then (0) else (1) end)),
	[DatumAkceptace_D]  AS (datepart(day,[DatumAkceptace])),
	[DatumAkceptace_M]  AS (datepart(month,[DatumAkceptace])),
	[DatumAkceptace_Y]  AS (datepart(year,[DatumAkceptace])),
	[DatumAkceptace_Q]  AS (datepart(quarter,[DatumAkceptace])),
	[DatumAkceptace_W]  AS (datepart(week,[DatumAkceptace])),
	[DatumAkceptace_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumAkceptace])))),
	[JeNovaVetaEditor] [bit] NOT NULL,
	[ZeFA] [bit] NOT NULL,
	[IDP] [nchar](36) NOT NULL,
	[DatumISEFa] [datetime] NULL,
	[ZeFAXML] [bit] NOT NULL,
	[DatumISEFa_D]  AS (datepart(day,[DatumISEFa])),
	[DatumISEFa_M]  AS (datepart(month,[DatumISEFa])),
	[DatumISEFa_Y]  AS (datepart(year,[DatumISEFa])),
	[DatumISEFa_Q]  AS (datepart(quarter,[DatumISEFa])),
	[DatumISEFa_W]  AS (datepart(week,[DatumISEFa])),
	[DatumISEFa_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumISEFa])))),
	[StavEfaktura] [tinyint] NULL,
 CONSTRAINT [PK__TabDokZboDodatek__IDHlavicky] PRIMARY KEY CLUSTERED 
(
	[IDHlavicky] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabDokZboDodatek__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabDokZboDodatek__FIntrMonthMsg]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabDokZboDodatek__FIntrMonthMsg] ON [dbo].[TabDokZboDodatek]
(
	[FIntrMonthMsg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZemeUrceni]  DEFAULT ('') FOR [ZemeUrceni]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__DodaciPodminky]  DEFAULT ('') FOR [DodaciPodminky]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__DD]  DEFAULT ((3)) FOR [DD]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PovahaTransakce]  DEFAULT (case when datepart(year,getdate())>=(2009) then (11) else (1) end) FOR [PovahaTransakce]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZPZtext]  DEFAULT ('') FOR [ZPZtext]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PoziceZaokrDPHHla]  DEFAULT ((2)) FOR [PoziceZaokrDPHHla]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__HraniceZaokrDPHHla]  DEFAULT ((4)) FOR [HraniceZaokrDPHHla]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZaokrNaPadesat]  DEFAULT ((0)) FOR [ZaokrNaPadesat]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__Guid]  DEFAULT ('') FOR [Guid]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__Stav]  DEFAULT ((0)) FOR [Stav]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PoziceZaokrDPHTxt]  DEFAULT ((2)) FOR [PoziceZaokrDPHTxt]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__HraniceZaokrDPHTxt]  DEFAULT ((4)) FOR [HraniceZaokrDPHTxt]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__VypocetSumaKcPoZao]  DEFAULT ((1)) FOR [VypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZapoctiStornoDoOdebMnoz]  DEFAULT ((0)) FOR [ZapoctiStornoDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__KoeficientDPH]  DEFAULT ((1)) FOR [KoeficientDPH]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PovolitUpravuDPH]  DEFAULT ((0)) FOR [PovolitUpravuDPH]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__DOBJZapoctiStornoCiDobropis]  DEFAULT ((1)) FOR [DOBJZapoctiStornoCiDobropis]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__CastkaRPT]  DEFAULT ((0.0)) FOR [CastkaRPT]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__CastkaRPTCM]  DEFAULT ((0.0)) FOR [CastkaRPTCM]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PTRU]  DEFAULT ((0)) FOR [PTRU]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PTRUCastka]  DEFAULT ((0.0)) FOR [PTRUCastka]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__PTRUCastkaCM]  DEFAULT ((0.0)) FOR [PTRUCastkaCM]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__RezimKurzuDPHFaktur]  DEFAULT ((0)) FOR [RezimKurzuDPHFaktur]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__Aktivni]  DEFAULT ((0)) FOR [Aktivni]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZeFA]  DEFAULT ((0)) FOR [ZeFA]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__IDP]  DEFAULT ('') FOR [IDP]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__ZeFAXML]  DEFAULT ((0)) FOR [ZeFAXML]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ADD  CONSTRAINT [DF__TabDokZboDodatek__StavEfaktura]  DEFAULT ((0)) FOR [StavEfaktura]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [FK__TabDokZboDodatek__FIntrMonthMsg] FOREIGN KEY([FIntrMonthMsg])
REFERENCES [dbo].[TabIntrMonthMsg] ([ID])
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [FK__TabDokZboDodatek__FIntrMonthMsg]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [FK__TabDokZboDodatek__IDDokladOprava] FOREIGN KEY([IDDokladOprava])
REFERENCES [dbo].[TabDokladyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [FK__TabDokZboDodatek__IDDokladOprava]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [FK__TabDokZboDodatek__IDHlavicky] FOREIGN KEY([IDHlavicky])
REFERENCES [dbo].[TabDokladyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [FK__TabDokZboDodatek__IDHlavicky]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__HraniceZaokrDPHHla] CHECK  (([HraniceZaokrDPHHla]>=(0) AND [HraniceZaokrDPHHla]<=(5)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__HraniceZaokrDPHHla]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__HraniceZaokrDPHTxt] CHECK  (([HraniceZaokrDPHTxt]>=(0) AND [HraniceZaokrDPHTxt]<=(5)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__HraniceZaokrDPHTxt]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__PoziceZaokrDPHHla] CHECK  (([PoziceZaokrDPHHla]=(127) OR [PoziceZaokrDPHHla]=(2) OR [PoziceZaokrDPHHla]=(1) OR [PoziceZaokrDPHHla]=(0)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__PoziceZaokrDPHHla]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__PoziceZaokrDPHTxt] CHECK  (([PoziceZaokrDPHTxt]=(127) OR [PoziceZaokrDPHTxt]=(126) OR [PoziceZaokrDPHTxt]=(3) OR [PoziceZaokrDPHTxt]=(2) OR [PoziceZaokrDPHTxt]=(1) OR [PoziceZaokrDPHTxt]=(0)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__PoziceZaokrDPHTxt]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__Stav] CHECK  (([Stav]>=(0) AND [Stav]<=(4)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__Stav]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__VypocetSumaKcPoZao] CHECK  (([VypocetSumaKcPoZao]>=(0) AND [VypocetSumaKcPoZao]<=(1)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__VypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabDokZboDodatek]  WITH CHECK ADD  CONSTRAINT [CK__TabDokZboDodatek__ZaokrNaPadesat] CHECK  (([ZaokrNaPadesat]=(7) OR [ZaokrNaPadesat]=(6) OR [ZaokrNaPadesat]=(4) OR [ZaokrNaPadesat]=(2) OR [ZaokrNaPadesat]=(1) OR [ZaokrNaPadesat]=(0)))
GO
ALTER TABLE [dbo].[TabDokZboDodatek] CHECK CONSTRAINT [CK__TabDokZboDodatek__ZaokrNaPadesat]
GO
ALTER TABLE [dbo].[TabDokZboDodatek] ENABLE TRIGGER [et_TabDokZboDodatek_ASOL_Log]
GO
