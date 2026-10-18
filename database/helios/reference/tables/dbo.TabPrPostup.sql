-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPrPostup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Doklad] [int] NOT NULL,
	[Alt] [nchar](1) NOT NULL,
	[IDPrikaz] [int] NOT NULL,
	[Prednastaveno] [bit] NOT NULL,
	[predzpracovano] [bit] NOT NULL,
	[Odvadeci] [bit] NOT NULL,
	[Kusy_zad] [numeric](19, 6) NOT NULL,
	[Kusy_nepotrebne] [numeric](19, 6) NOT NULL,
	[Kusy_real] [numeric](19, 6) NOT NULL,
	[Kusy_ztra] [numeric](19, 6) NOT NULL,
	[Kusy_zmet] [numeric](19, 6) NOT NULL,
	[Kusy_zmet_opr_IO] [numeric](19, 6) NOT NULL,
	[Kusy_zmet_neopr] [numeric](19, 6) NOT NULL,
	[KusyPredOperaci] [numeric](19, 6) NOT NULL,
	[KusyVKoop] [numeric](19, 6) NOT NULL,
	[Kusy_odv] [numeric](19, 6) NOT NULL,
	[Mzda_real] [numeric](19, 6) NOT NULL,
	[koop_real] [numeric](19, 6) NOT NULL,
	[rezieS_real] [numeric](19, 6) NOT NULL,
	[rezieP_real] [numeric](19, 6) NOT NULL,
	[reziePrac_real] [numeric](19, 6) NOT NULL,
	[nakladyPrac_real] [numeric](19, 6) NOT NULL,
	[Mzda_odv] [numeric](19, 6) NOT NULL,
	[koop_odv] [numeric](19, 6) NOT NULL,
	[rezieS_odv] [numeric](19, 6) NOT NULL,
	[rezieP_odv] [numeric](19, 6) NOT NULL,
	[reziePrac_odv] [numeric](19, 6) NOT NULL,
	[nakladyPrac_odv] [numeric](19, 6) NOT NULL,
	[Uzavreno] [bit] NOT NULL,
	[AutorUzavreni] [nvarchar](128) NULL,
	[IDOdchylkyOd] [int] NULL,
	[IDOdchylkyDo] [int] NULL,
	[ZaevidovaneKusyAll] [numeric](19, 6) NOT NULL,
	[KusyVKoopAll] [numeric](19, 6) NOT NULL,
	[priorita] [int] NOT NULL,
	[dilec] [int] NOT NULL,
	[typ] [tinyint] NOT NULL,
	[TypOznaceni] [nvarchar](10) NULL,
	[DavkaTPV] [numeric](19, 6) NOT NULL,
	[Operace] [nchar](4) NOT NULL,
	[nazev] [nvarchar](100) NULL,
	[pracoviste] [int] NULL,
	[IDkooperace] [int] NULL,
	[tarif] [int] NULL,
	[TBC] [numeric](19, 6) NOT NULL,
	[TBC_T] [tinyint] NOT NULL,
	[TBC_KC] [numeric](19, 6) NOT NULL,
	[TEC] [numeric](19, 6) NOT NULL,
	[TEC_T] [tinyint] NOT NULL,
	[TEC_KC] [numeric](19, 6) NOT NULL,
	[NasobekTAC] [numeric](19, 6) NOT NULL,
	[TAC_J] [numeric](19, 6) NOT NULL,
	[TAC_J_T] [tinyint] NOT NULL,
	[TAC_KC_J] [numeric](19, 6) NOT NULL,
	[TAC] [numeric](19, 6) NOT NULL,
	[TAC_T] [tinyint] NOT NULL,
	[TAC_KC] [numeric](19, 6) NOT NULL,
	[KoopMnozstvi] [numeric](19, 6) NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[PocetLidi] [int] NOT NULL,
	[PocetKusu] [numeric](19, 6) NOT NULL,
	[PocetStroju] [int] NOT NULL,
	[IDObrazek] [int] NULL,
	[ZpusobZaplanovani] [tinyint] NULL,
	[PlanDavka] [numeric](19, 6) NULL,
	[MeziOperCas] [numeric](19, 6) NOT NULL,
	[MeziOperCas_T] [tinyint] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[AutorTisku] [nvarchar](128) NULL,
	[DatumTisku] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[ID1] [int] NOT NULL,
	[Kusy_zive]  AS (CONVERT([numeric](19,6),case when [ZaevidovaneKusyAll]>=[kusy_zad] then (0.0) else [kusy_zad]-[ZaevidovaneKusyAll] end,0)),
	[Odchylkovano]  AS (CONVERT([bit],case when [IDOdchylkyOd] IS NULL then (0) else (1) end,0)),
	[Splneno]  AS (CONVERT([bit],case when [ZaevidovaneKusyAll]>=[kusy_zad] OR [Uzavreno]=(1) then (1) else (0) end,0)),
	[TBC_S]  AS (CONVERT([numeric](19,6),[TBC]*case [TBC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_N]  AS (CONVERT([numeric](19,6),case [TBC_T] when (0) then [TBC]/(60.0) when (1) then [TBC] when (2) then (60.0)*[TBC]  end,0)),
	[TBC_H]  AS (CONVERT([numeric](19,6),[TBC]/case [TBC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_S]  AS (CONVERT([numeric](19,6),[TEC]*case [TEC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_N]  AS (CONVERT([numeric](19,6),case [TEC_T] when (0) then [TEC]/(60.0) when (1) then [TEC] when (2) then (60.0)*[TEC]  end,0)),
	[TEC_H]  AS (CONVERT([numeric](19,6),[TEC]/case [TEC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_J_S]  AS (CONVERT([numeric](19,6),[TAC_J]*case [TAC_J_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_J_N]  AS (CONVERT([numeric](19,6),case [TAC_J_T] when (0) then [TAC_J]/(60.0) when (1) then [TAC_J] when (2) then (60.0)*[TAC_J]  end,0)),
	[TAC_J_H]  AS (CONVERT([numeric](19,6),[TAC_J]/case [TAC_J_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_S]  AS (CONVERT([numeric](19,6),[TAC]*case [TAC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_N]  AS (CONVERT([numeric](19,6),case [TAC_T] when (0) then [TAC]/(60.0) when (1) then [TAC] when (2) then (60.0)*[TAC]  end,0)),
	[TAC_H]  AS (CONVERT([numeric](19,6),[TAC]/case [TAC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[MeziOperCas_S]  AS (CONVERT([numeric](19,6),[MeziOperCas]*case [MeziOperCas_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[MeziOperCas_N]  AS (CONVERT([numeric](19,6),case [MeziOperCas_T] when (0) then [MeziOperCas]/(60.0) when (1) then [MeziOperCas] when (2) then (60.0)*[MeziOperCas]  end,0)),
	[MeziOperCas_H]  AS (CONVERT([numeric](19,6),[MeziOperCas]/case [MeziOperCas_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
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
	[BarCode]  AS (CONVERT([nvarchar](15),((N'A'+isnull(replicate(N'0',(4)-len([ID1])),''))+CONVERT([nvarchar](13),[ID1],0))+N'B',0)),
	[KVO] [numeric](19, 6) NOT NULL,
	[DavkaTPV_VO]  AS (CONVERT([numeric](19,6),ceiling([DavkaTPV]/[PocetKusu])*[PocetKusu],0)),
	[ParKP_ParalelZpracTranDavek] [tinyint] NULL,
	[ParKP_PovolitPreruseniTranDavky] [tinyint] NULL,
	[ParKP_PovolitPreruseniOperace] [tinyint] NULL,
	[ParKP_ZpusobPouzitiTBC] [tinyint] NULL,
	[ParKP_ZpusobPouzitiTEC] [tinyint] NULL,
	[Kusy_pozadovane]  AS (CONVERT([numeric](19,6),case when [Kusy_nepotrebne]>[kusy_zad] then (0.0) else [kusy_zad]-[Kusy_nepotrebne] end,0)),
	[Konf_ZahrnoutDoKapacPlan] [bit] NOT NULL,
	[ParKP_ZpusobBlokovaniKapacit] [tinyint] NULL,
	[ProcSplneni]  AS (CONVERT([numeric](19,6),case when [ZaevidovaneKusyAll]>=[kusy_zad] OR [Uzavreno]=(1) then (100.0) else ((100.0)*[ZaevidovaneKusyAll])/[Kusy_zad] end,0)),
	[TBC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TBC_Obsluhy_T] [tinyint] NOT NULL,
	[TEC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TEC_Obsluhy_T] [tinyint] NOT NULL,
	[TAC_Obsluhy_J] [numeric](19, 6) NOT NULL,
	[TAC_Obsluhy_J_T] [tinyint] NOT NULL,
	[TAC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TAC_Obsluhy_T] [tinyint] NOT NULL,
	[IDStroje] [int] NULL,
	[Koop_KalkulacniDavka] [numeric](19, 6) NULL,
	[Koop_CenaDavky] [numeric](19, 6) NULL,
	[Koop_CenaMJ] [numeric](19, 6) NULL,
	[TBC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TBC_Obsluhy]*case [TBC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TBC_Obsluhy_T] when (0) then [TBC_Obsluhy]/(60.0) when (1) then [TBC_Obsluhy] when (2) then (60.0)*[TBC_Obsluhy]  end,0)),
	[TBC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TBC_Obsluhy]/case [TBC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TEC_Obsluhy]*case [TEC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TEC_Obsluhy_T] when (0) then [TEC_Obsluhy]/(60.0) when (1) then [TEC_Obsluhy] when (2) then (60.0)*[TEC_Obsluhy]  end,0)),
	[TEC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TEC_Obsluhy]/case [TEC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_Obsluhy_J_S]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy_J]*case [TAC_Obsluhy_J_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_Obsluhy_J_N]  AS (CONVERT([numeric](19,6),case [TAC_Obsluhy_J_T] when (0) then [TAC_Obsluhy_J]/(60.0) when (1) then [TAC_Obsluhy_J] when (2) then (60.0)*[TAC_Obsluhy_J]  end,0)),
	[TAC_Obsluhy_J_H]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy_J]/case [TAC_Obsluhy_J_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy]*case [TAC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TAC_Obsluhy_T] when (0) then [TAC_Obsluhy]/(60.0) when (1) then [TAC_Obsluhy] when (2) then (60.0)*[TAC_Obsluhy]  end,0)),
	[TAC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy]/case [TAC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[Koop_IndividualniKalkulace]  AS (CONVERT([bit],case when [Koop_CenaMJ] IS NULL then (0) else (1) end,0)),
	[VyraditZKontrolyPosloupOper] [bit] NOT NULL,
	[Naradi_real] [numeric](19, 6) NOT NULL,
	[Naradi_odv] [numeric](19, 6) NOT NULL,
	[JeNeco_real]  AS (CONVERT([bit],case when [Kusy_real]<>(0.0) OR [Kusy_ztra]<>(0.0) OR [Kusy_zmet]<>(0.0) OR [Kusy_zmet_opr_IO]<>(0.0) OR [Kusy_zmet_neopr]<>(0.0) OR [Mzda_real]<>(0.0) OR [koop_real]<>(0.0) OR [rezieS_real]<>(0.0) OR [rezieP_real]<>(0.0) OR [reziePrac_real]<>(0.0) OR [nakladyPrac_real]<>(0.0) OR [Naradi_real]<>(0.0) then (1) else (0) end)),
	[JeNeco_NeOdv]  AS (CONVERT([bit],case when [Kusy_real]<>[Kusy_odv] OR [Mzda_real]<>[Mzda_odv] OR [koop_real]<>[koop_odv] OR [rezieS_real]<>[rezieS_odv] OR [rezieP_real]<>[rezieP_odv] OR [reziePrac_real]<>[reziePrac_odv] OR [nakladyPrac_real]<>[nakladyPrac_odv] OR [Naradi_real]<>[Naradi_odv] then (1) else (0) end)),
	[Cena_real]  AS (CONVERT([numeric](19,6),((((([mzda_real]+[koop_real])+[rezieS_real])+[rezieP_real])+[ReziePrac_real])+[NakladyPrac_real])+[Naradi_real])),
	[Cena_odv]  AS (CONVERT([numeric](19,6),((((([mzda_odv]+[koop_odv])+[rezieS_odv])+[rezieP_odv])+[ReziePrac_odv])+[NakladyPrac_odv])+[naradi_odv])),
	[Koop_ZpracovatelskaDavka] [numeric](19, 6) NULL,
	[Koop_DobaZpracDavky] [numeric](19, 6) NULL,
	[Koop_DobaZpracDavky_T] [tinyint] NOT NULL,
	[Plan_zadani] [datetime] NULL,
	[Plan_ukonceni] [datetime] NULL,
	[Koop_IndividualniKapacita]  AS (CONVERT([bit],case when [Koop_ZpracovatelskaDavka] IS NULL then (0) else (1) end)),
	[Koop_DobaZpracDavky_S]  AS (CONVERT([numeric](19,6),[Koop_DobaZpracDavky]*case [Koop_DobaZpracDavky_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0) when (3) then (86400.0)  end)),
	[Koop_DobaZpracDavky_N]  AS (CONVERT([numeric](19,6),case [Koop_DobaZpracDavky_T] when (0) then [Koop_DobaZpracDavky]/(60.0) when (1) then [Koop_DobaZpracDavky] when (2) then (60.0)*[Koop_DobaZpracDavky] when (3) then (1440.0)*[Koop_DobaZpracDavky]  end)),
	[Koop_DobaZpracDavky_H]  AS (CONVERT([numeric](19,6),case [Koop_DobaZpracDavky_T] when (0) then [Koop_DobaZpracDavky]/(3600.0) when (1) then [Koop_DobaZpracDavky]/(60.0) when (2) then [Koop_DobaZpracDavky] when (3) then (24.0)*[Koop_DobaZpracDavky]  end)),
	[Koop_DobaZpracDavky_D]  AS (CONVERT([numeric](19,6),[Koop_DobaZpracDavky]/case [Koop_DobaZpracDavky_T] when (0) then (86400.0) when (1) then (1440.0) when (2) then (24.0) when (3) then (1.0)  end)),
	[Plan_zadani_D]  AS (datepart(day,[Plan_zadani])),
	[Plan_zadani_M]  AS (datepart(month,[Plan_zadani])),
	[Plan_zadani_Y]  AS (datepart(year,[Plan_zadani])),
	[Plan_zadani_Q]  AS (datepart(quarter,[Plan_zadani])),
	[Plan_zadani_W]  AS (datepart(week,[Plan_zadani])),
	[Plan_zadani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Plan_zadani])))),
	[Plan_ukonceni_D]  AS (datepart(day,[Plan_ukonceni])),
	[Plan_ukonceni_M]  AS (datepart(month,[Plan_ukonceni])),
	[Plan_ukonceni_Y]  AS (datepart(year,[Plan_ukonceni])),
	[Plan_ukonceni_Q]  AS (datepart(quarter,[Plan_ukonceni])),
	[Plan_ukonceni_W]  AS (datepart(week,[Plan_ukonceni])),
	[Plan_ukonceni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Plan_ukonceni])))),
	[IDKoduSdruzeni] [int] NULL,
	[Konf_TypMzdy] [tinyint] NULL,
	[Koop_MenaKalkulace] [nvarchar](3) NULL,
	[ParKP_ParalelZpracTranDavek_MaxPocet] [tinyint] NULL,
	[ParKP_TranDavka] [numeric](19, 6) NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[KorekceKusuPredOperaci] [numeric](19, 6) NOT NULL,
	[Pozastaveno] [bit] NOT NULL,
	[IDTypuNaklPrac] [int] NULL,
	[CisloTypOperace] [int] NULL,
 CONSTRAINT [PK__TabPrPostup__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrPostup__IDPrikaz__Doklad__IDOdchylkyDo__Alt] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[Doklad] ASC,
	[IDOdchylkyDo] ASC,
	[Alt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrPostup__IDPrikaz__Doklad__IDOdchylkyDo__Priorita] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[Doklad] ASC,
	[IDOdchylkyDo] ASC,
	[priorita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrPostup__IDPrikaz__IDOdchylkyDo__Dilec__Operace__Alt] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[IDOdchylkyDo] ASC,
	[dilec] ASC,
	[Operace] ASC,
	[Alt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrPostup__BarCode__IDOdchylkyDo]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrPostup__BarCode__IDOdchylkyDo] ON [dbo].[TabPrPostup]
(
	[BarCode] ASC,
	[IDOdchylkyDo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrPostup__ID1__IDOdchylkyDo]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrPostup__ID1__IDOdchylkyDo] ON [dbo].[TabPrPostup]
(
	[ID1] ASC,
	[IDOdchylkyDo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Alt]  DEFAULT (N'A') FOR [Alt]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Prednastaveno]  DEFAULT ((1)) FOR [Prednastaveno]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__predzpracovano]  DEFAULT ((0)) FOR [predzpracovano]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Odvadeci]  DEFAULT ((0)) FOR [Odvadeci]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_zad]  DEFAULT ((0)) FOR [Kusy_zad]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_nepotrebne]  DEFAULT ((0)) FOR [Kusy_nepotrebne]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_real]  DEFAULT ((0)) FOR [Kusy_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_ztra]  DEFAULT ((0)) FOR [Kusy_ztra]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_zmet]  DEFAULT ((0)) FOR [Kusy_zmet]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_zmet_opr_IO]  DEFAULT ((0)) FOR [Kusy_zmet_opr_IO]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_zmet_neopr]  DEFAULT ((0)) FOR [Kusy_zmet_neopr]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KusyPredOperaci]  DEFAULT ((0)) FOR [KusyPredOperaci]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KusyVKoop]  DEFAULT ((0)) FOR [KusyVKoop]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Kusy_odv]  DEFAULT ((0)) FOR [Kusy_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Mzda_real]  DEFAULT ((0)) FOR [Mzda_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__koop_real]  DEFAULT ((0)) FOR [koop_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__rezieS_real]  DEFAULT ((0)) FOR [rezieS_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__rezieP_real]  DEFAULT ((0)) FOR [rezieP_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__reziePrac_real]  DEFAULT ((0)) FOR [reziePrac_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__nakladyPrac_real]  DEFAULT ((0)) FOR [nakladyPrac_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Mzda_odv]  DEFAULT ((0)) FOR [Mzda_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__koop_odv]  DEFAULT ((0)) FOR [koop_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__rezieS_odv]  DEFAULT ((0)) FOR [rezieS_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__rezieP_odv]  DEFAULT ((0)) FOR [rezieP_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__reziePrac_odv]  DEFAULT ((0)) FOR [reziePrac_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__nakladyPrac_odv]  DEFAULT ((0)) FOR [nakladyPrac_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Uzavreno]  DEFAULT ((0)) FOR [Uzavreno]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__ZaevidovaneKusyAll]  DEFAULT ((0)) FOR [ZaevidovaneKusyAll]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KusyVKoopAll]  DEFAULT ((0)) FOR [KusyVKoopAll]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__priorita]  DEFAULT ((0)) FOR [priorita]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__typ]  DEFAULT ((1)) FOR [typ]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__DavkaTPV]  DEFAULT ((1)) FOR [DavkaTPV]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Operace]  DEFAULT ('') FOR [Operace]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__nazev]  DEFAULT ('') FOR [nazev]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TBC]  DEFAULT ((0)) FOR [TBC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TBC_T]  DEFAULT ((1)) FOR [TBC_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TBC_KC]  DEFAULT ((0)) FOR [TBC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TEC]  DEFAULT ((0)) FOR [TEC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TEC_T]  DEFAULT ((1)) FOR [TEC_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TEC_KC]  DEFAULT ((0)) FOR [TEC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__NasobekTAC]  DEFAULT ((1)) FOR [NasobekTAC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_J]  DEFAULT ((0)) FOR [TAC_J]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_J_T]  DEFAULT ((1)) FOR [TAC_J_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_KC_J]  DEFAULT ((0)) FOR [TAC_KC_J]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC]  DEFAULT ((0)) FOR [TAC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_T]  DEFAULT ((1)) FOR [TAC_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_KC]  DEFAULT ((0)) FOR [TAC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KoopMnozstvi]  DEFAULT ((0)) FOR [KoopMnozstvi]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__PocetLidi]  DEFAULT ((1)) FOR [PocetLidi]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__PocetKusu]  DEFAULT ((1)) FOR [PocetKusu]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__PocetStroju]  DEFAULT ((1)) FOR [PocetStroju]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__MeziOperCas]  DEFAULT ((0)) FOR [MeziOperCas]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__MeziOperCas_T]  DEFAULT ((1)) FOR [MeziOperCas_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__ID1]  DEFAULT ((0)) FOR [ID1]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KVO]  DEFAULT ((1)) FOR [KVO]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Konf_ZahrnoutDoKapacPlan]  DEFAULT ((1)) FOR [Konf_ZahrnoutDoKapacPlan]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TBC_Obsluhy]  DEFAULT ((0)) FOR [TBC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TBC_Obsluhy_T]  DEFAULT ((1)) FOR [TBC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TEC_Obsluhy]  DEFAULT ((0)) FOR [TEC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TEC_Obsluhy_T]  DEFAULT ((1)) FOR [TEC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_Obsluhy_J]  DEFAULT ((0)) FOR [TAC_Obsluhy_J]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_Obsluhy_J_T]  DEFAULT ((1)) FOR [TAC_Obsluhy_J_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_Obsluhy]  DEFAULT ((0)) FOR [TAC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__TAC_Obsluhy_T]  DEFAULT ((1)) FOR [TAC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__VyraditZKontrolyPosloupOper]  DEFAULT ((0)) FOR [VyraditZKontrolyPosloupOper]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Naradi_real]  DEFAULT ((0)) FOR [Naradi_real]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Naradi_odv]  DEFAULT ((0)) FOR [Naradi_odv]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Koop_DobaZpracDavky_T]  DEFAULT ((2)) FOR [Koop_DobaZpracDavky_T]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__KorekceKusuPredOperaci]  DEFAULT ((0)) FOR [KorekceKusuPredOperaci]
GO
ALTER TABLE [dbo].[TabPrPostup] ADD  CONSTRAINT [DF__TabPrPostup__Pozastaveno]  DEFAULT ((0)) FOR [Pozastaveno]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__CisloTypOperace] FOREIGN KEY([CisloTypOperace])
REFERENCES [dbo].[TabTypPostup] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__CisloTypOperace]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__dilec] FOREIGN KEY([dilec])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__dilec]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDKoduSdruzeni] FOREIGN KEY([IDKoduSdruzeni])
REFERENCES [dbo].[TabCisKoduSdruzeni] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDKoduSdruzeni]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDkooperace] FOREIGN KEY([IDkooperace])
REFERENCES [dbo].[TabCKoop] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDkooperace]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDObrazek] FOREIGN KEY([IDObrazek])
REFERENCES [dbo].[TabCisObr] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDObrazek]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDOdchylkyDo] FOREIGN KEY([IDOdchylkyDo])
REFERENCES [dbo].[TabCOdchylek] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDOdchylkyDo]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDOdchylkyOd] FOREIGN KEY([IDOdchylkyOd])
REFERENCES [dbo].[TabCOdchylek] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDOdchylkyOd]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDPrikaz] FOREIGN KEY([IDPrikaz])
REFERENCES [dbo].[TabPrikaz] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDPrikaz]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDStroje] FOREIGN KEY([IDStroje])
REFERENCES [dbo].[TabCisStroju] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDStroje]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__IDTypuNaklPrac] FOREIGN KEY([IDTypuNaklPrac])
REFERENCES [dbo].[TabTypyNaklPrac] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__IDTypuNaklPrac]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__Koop_MenaKalkulace] FOREIGN KEY([Koop_MenaKalkulace])
REFERENCES [dbo].[TabKodMen] ([Kod])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__Koop_MenaKalkulace]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__pracoviste] FOREIGN KEY([pracoviste])
REFERENCES [dbo].[TabCPraco] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__pracoviste]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [FK__TabPrPostup__tarif] FOREIGN KEY([tarif])
REFERENCES [dbo].[TabTarH] ([ID])
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [FK__TabPrPostup__tarif]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Alt] CHECK  (([Alt]>=N'A' AND [Alt]<=N'Z'))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Alt]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__DavkaTPV] CHECK  (([DavkaTPV]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__DavkaTPV]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Doklad] CHECK  (([Doklad]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Doklad]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__IndiKalkKoop] CHECK  (([Koop_KalkulacniDavka] IS NULL AND [Koop_CenaDavky] IS NULL AND [Koop_CenaMJ] IS NULL AND [Koop_MenaKalkulace] IS NULL OR [Typ]=(2) AND [Koop_KalkulacniDavka] IS NOT NULL AND [Koop_CenaDavky] IS NOT NULL AND [Koop_CenaMJ] IS NOT NULL))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__IndiKalkKoop]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__IndiKapacitaKoop] CHECK  (([Koop_ZpracovatelskaDavka] IS NULL AND [Koop_DobaZpracDavky] IS NULL OR [Typ]=(2) AND [Koop_ZpracovatelskaDavka] IS NOT NULL AND [Koop_DobaZpracDavky] IS NOT NULL))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__IndiKapacitaKoop]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Konf_TypMzdy] CHECK  (([Konf_TypMzdy]>=(0) AND [Konf_TypMzdy]<=(1)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Konf_TypMzdy]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_CenaDavky] CHECK  (([Koop_CenaDavky]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_CenaDavky]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_CenaMJ] CHECK  (([Koop_CenaMJ]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_CenaMJ]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_DobaZpracDavky] CHECK  (([Koop_DobaZpracDavky]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_DobaZpracDavky]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_DobaZpracDavky_T] CHECK  (([Koop_DobaZpracDavky_T]>=(0) AND [Koop_DobaZpracDavky_T]<=(3)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_DobaZpracDavky_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_KalkulacniDavka] CHECK  (([Koop_KalkulacniDavka]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_KalkulacniDavka]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__koop_odv] CHECK  (([koop_odv]>=(0) AND [koop_odv]<=[koop_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__koop_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Koop_ZpracovatelskaDavka] CHECK  (([Koop_ZpracovatelskaDavka]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Koop_ZpracovatelskaDavka]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__KoopMnozstvi] CHECK  (([KoopMnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__KoopMnozstvi]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_nepotrebne] CHECK  (([Kusy_nepotrebne]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_nepotrebne]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_odv] CHECK  (([Kusy_odv]>=(0) AND [Kusy_odv]<=[Kusy_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_real] CHECK  (([Kusy_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_real]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_zad] CHECK  (([Kusy_zad]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_zad]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_zmet] CHECK  (([Kusy_zmet]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_zmet]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_zmet_neopr] CHECK  (([Kusy_zmet_neopr]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_zmet_neopr]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_zmet_opr_IO] CHECK  (([Kusy_zmet_opr_IO]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_zmet_opr_IO]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Kusy_ztra] CHECK  (([Kusy_ztra]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Kusy_ztra]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__KusyVKoop] CHECK  (([KusyVKoop]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__KusyVKoop]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__KVO] CHECK  (([KVO]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__KVO]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__MeziOperCas] CHECK  (([MeziOperCas]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__MeziOperCas]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__MeziOperCas_T] CHECK  (([MeziOperCas_T]>=(0) AND [MeziOperCas_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__MeziOperCas_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Mzda_odv] CHECK  (([Mzda_odv]>=(0) AND [Mzda_odv]<=[Mzda_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Mzda_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__nakladyPrac_odv] CHECK  (([nakladyPrac_odv]>=(0) AND [nakladyPrac_odv]<=[nakladyPrac_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__nakladyPrac_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Naradi_odv] CHECK  (([Naradi_odv]>=(0) AND [Naradi_odv]<=[Naradi_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Naradi_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Naradi_real] CHECK  (([Naradi_real]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Naradi_real]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__NasobekTAC] CHECK  (([NasobekTAC]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__NasobekTAC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__Operace] CHECK  ((len([operace])>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__Operace]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__ParKP_ParalelZpracTranDavek_MaxPocet] CHECK  (([ParKP_ParalelZpracTranDavek_MaxPocet]>(1)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__ParKP_ParalelZpracTranDavek_MaxPocet]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__ParKP_TranDavka] CHECK  (([ParKP_TranDavka]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__ParKP_TranDavka]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__PlanDavka] CHECK  (([PlanDavka] IS NULL OR [PlanDavka]>(0.0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__PlanDavka]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__PocetKusu] CHECK  (([PocetKusu]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__PocetKusu]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__PocetLidi] CHECK  (([PocetLidi]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__PocetLidi]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__PocetStroju] CHECK  (([PocetStroju]>(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__PocetStroju]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__priorita] CHECK  (([priorita]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__priorita]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__rezieP_odv] CHECK  (([rezieP_odv]>=(0) AND [rezieP_odv]<=[rezieP_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__rezieP_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__reziePrac_odv] CHECK  (([reziePrac_odv]>=(0) AND [reziePrac_odv]<=[reziePrac_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__reziePrac_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__rezieS_odv] CHECK  (([rezieS_odv]>=(0) AND [rezieS_odv]<=[rezieS_real]))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__rezieS_odv]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC] CHECK  (([TAC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_J] CHECK  (([TAC_J]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_J]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_J_T] CHECK  (([TAC_J_T]>=(0) AND [TAC_J_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_J_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_KC] CHECK  (([TAC_KC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_KC_J] CHECK  (([TAC_KC_J]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_KC_J]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy] CHECK  (([TAC_Obsluhy]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_J] CHECK  (([TAC_Obsluhy_J]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_J]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_J_T] CHECK  (([TAC_Obsluhy_J_T]>=(0) AND [TAC_Obsluhy_J_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_J_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_T] CHECK  (([TAC_Obsluhy_T]>=(0) AND [TAC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TAC_T] CHECK  (([TAC_T]>=(0) AND [TAC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TAC_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TBC] CHECK  (([TBC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TBC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TBC_KC] CHECK  (([TBC_KC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TBC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TBC_Obsluhy] CHECK  (([TBC_Obsluhy]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TBC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TBC_Obsluhy_T] CHECK  (([TBC_Obsluhy_T]>=(0) AND [TBC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TBC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TBC_T] CHECK  (([TBC_T]>=(0) AND [TBC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TBC_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TEC] CHECK  (([TEC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TEC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TEC_KC] CHECK  (([TEC_KC]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TEC_KC]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TEC_Obsluhy] CHECK  (([TEC_Obsluhy]>=(0)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TEC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TEC_Obsluhy_T] CHECK  (([TEC_Obsluhy_T]>=(0) AND [TEC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TEC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__TEC_T] CHECK  (([TEC_T]>=(0) AND [TEC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__TEC_T]
GO
ALTER TABLE [dbo].[TabPrPostup]  WITH CHECK ADD  CONSTRAINT [CK__TabPrPostup__typ] CHECK  (([typ]>=(0) AND [typ]<=(2)))
GO
ALTER TABLE [dbo].[TabPrPostup] CHECK CONSTRAINT [CK__TabPrPostup__typ]
GO
ALTER TABLE [dbo].[TabPrPostup] ENABLE TRIGGER [ht_PrPostup_insert_update_delete]
GO
