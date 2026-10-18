-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPrikaz](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Rada] [nvarchar](10) NOT NULL,
	[Prikaz] [int] NOT NULL,
	[StavPrikazu] [tinyint] NOT NULL,
	[IDTabKmen] [int] NOT NULL,
	[IDZakazka] [int] NULL,
	[Plan_zadani] [datetime] NOT NULL,
	[Plan_ukonceni] [datetime] NOT NULL,
	[DatumTPV] [datetime] NULL,
	[zadani] [datetime] NULL,
	[ukonceni] [datetime] NULL,
	[AutorUzavreni] [nvarchar](128) NULL,
	[kusy_ciste] [numeric](19, 6) NOT NULL,
	[kusy_zad] [numeric](19, 6) NOT NULL,
	[kusy_zad_puvodni] [numeric](19, 6) NOT NULL,
	[kusy_odved] [numeric](19, 6) NOT NULL,
	[kusy_zmet] [numeric](19, 6) NOT NULL,
	[kusy_ztrac] [numeric](19, 6) NOT NULL,
	[kusy_zive] [numeric](19, 6) NOT NULL,
	[BarCode] [nvarchar](50) NULL,
	[EvidJednotka] [numeric](19, 6) NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[IDRezervace] [int] NULL,
	[NakladyOPN] [numeric](19, 6) NOT NULL,
	[NakladyOPN_odv] [numeric](19, 6) NOT NULL,
	[NeodvedeneNakladyPoUzav] [numeric](19, 6) NOT NULL,
	[IDPlan] [int] NULL,
	[Sklad] [nvarchar](30) NULL,
	[TypDilce] [tinyint] NOT NULL,
	[IDPrikazVyssi] [int] NULL,
	[IDPrikazRidici] [int] NULL,
	[Strom] [nvarchar](max) NULL,
	[ZahrnoutDoKapacPlan] [bit] NOT NULL,
	[SmerZaplanovani] [int] NOT NULL,
	[NavaznaObjednavka] [nvarchar](30) NULL,
	[SkupinaPlanu] [nvarchar](10) NULL,
	[IDObchPrip] [int] NULL,
	[KmenoveStredisko] [nvarchar](30) NULL,
	[UKod] [int] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[AutorTisku] [nvarchar](128) NULL,
	[DatumTisku] [datetime] NULL,
	[mat] [numeric](19, 6) NOT NULL,
	[MatRezie] [numeric](19, 6) NOT NULL,
	[koop] [numeric](19, 6) NOT NULL,
	[TAC] [numeric](19, 6) NOT NULL,
	[TAC_T] [tinyint] NOT NULL,
	[TBC] [numeric](19, 6) NOT NULL,
	[TBC_T] [tinyint] NOT NULL,
	[TEC] [numeric](19, 6) NOT NULL,
	[TEC_T] [tinyint] NOT NULL,
	[TAC_KC] [numeric](19, 6) NOT NULL,
	[TBC_KC] [numeric](19, 6) NOT NULL,
	[TEC_KC] [numeric](19, 6) NOT NULL,
	[rezieS] [numeric](19, 6) NOT NULL,
	[rezieP] [numeric](19, 6) NOT NULL,
	[ReziePrac] [numeric](19, 6) NOT NULL,
	[NakladyPrac] [numeric](19, 6) NOT NULL,
	[OPN] [numeric](19, 6) NOT NULL,
	[VedProdukt] [numeric](19, 6) NOT NULL,
	[naradi] [numeric](19, 6) NOT NULL,
	[mat_P] [numeric](19, 6) NOT NULL,
	[MatRezie_P] [numeric](19, 6) NOT NULL,
	[koop_P] [numeric](19, 6) NOT NULL,
	[TAC_P] [numeric](19, 6) NOT NULL,
	[TAC_P_T] [tinyint] NOT NULL,
	[TBC_P] [numeric](19, 6) NOT NULL,
	[TBC_P_T] [tinyint] NOT NULL,
	[TEC_P] [numeric](19, 6) NOT NULL,
	[TEC_P_T] [tinyint] NOT NULL,
	[TAC_KC_P] [numeric](19, 6) NOT NULL,
	[TBC_KC_P] [numeric](19, 6) NOT NULL,
	[TEC_KC_P] [numeric](19, 6) NOT NULL,
	[rezieS_P] [numeric](19, 6) NOT NULL,
	[rezieP_P] [numeric](19, 6) NOT NULL,
	[ReziePrac_P] [numeric](19, 6) NOT NULL,
	[NakladyPrac_P] [numeric](19, 6) NOT NULL,
	[OPN_P] [numeric](19, 6) NOT NULL,
	[VedProdukt_P] [numeric](19, 6) NOT NULL,
	[naradi_P] [numeric](19, 6) NOT NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[IDNaklOkruh] [int] NULL,
	[JeNewRec] [bit] NOT NULL,
	[Plan_zadani_D]  AS (datepart(day,[Plan_zadani])),
	[Plan_zadani_M]  AS (datepart(month,[Plan_zadani])),
	[Plan_zadani_Y]  AS (datepart(year,[Plan_zadani])),
	[Plan_zadani_Q]  AS (datepart(quarter,[Plan_zadani])),
	[Plan_zadani_W]  AS (datepart(week,[Plan_zadani])),
	[Plan_zadani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Plan_zadani],0),0),0)),
	[Plan_ukonceni_D]  AS (datepart(day,[Plan_ukonceni])),
	[Plan_ukonceni_M]  AS (datepart(month,[Plan_ukonceni])),
	[Plan_ukonceni_Y]  AS (datepart(year,[Plan_ukonceni])),
	[Plan_ukonceni_Q]  AS (datepart(quarter,[Plan_ukonceni])),
	[Plan_ukonceni_W]  AS (datepart(week,[Plan_ukonceni])),
	[Plan_ukonceni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Plan_ukonceni],0),0),0)),
	[DatumTPV_D]  AS (datepart(day,[DatumTPV])),
	[DatumTPV_M]  AS (datepart(month,[DatumTPV])),
	[DatumTPV_Y]  AS (datepart(year,[DatumTPV])),
	[DatumTPV_Q]  AS (datepart(quarter,[DatumTPV])),
	[DatumTPV_W]  AS (datepart(week,[DatumTPV])),
	[DatumTPV_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumTPV],0),0),0)),
	[DatumTPVOrDnes]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],isnull([DatumTPV],getdate()),0),0),0)),
	[zadani_D]  AS (datepart(day,[zadani])),
	[zadani_M]  AS (datepart(month,[zadani])),
	[zadani_Y]  AS (datepart(year,[zadani])),
	[zadani_Q]  AS (datepart(quarter,[zadani])),
	[zadani_W]  AS (datepart(week,[zadani])),
	[zadani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[zadani],0),0),0)),
	[ukonceni_D]  AS (datepart(day,[ukonceni])),
	[ukonceni_M]  AS (datepart(month,[ukonceni])),
	[ukonceni_Y]  AS (datepart(year,[ukonceni])),
	[ukonceni_Q]  AS (datepart(quarter,[ukonceni])),
	[ukonceni_W]  AS (datepart(week,[ukonceni])),
	[ukonceni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[ukonceni],0),0),0)),
	[predzpracovano]  AS (CONVERT([bit],case when [StavPrikazu]=(20) then (1) else (0) end,0)),
	[zadano]  AS (CONVERT([bit],case when [StavPrikazu]>=(30) then (1) else (0) end,0)),
	[ZadanoNeboPredzpracovano]  AS (CONVERT([bit],case when [StavPrikazu]>=(20) then (1) else (0) end,0)),
	[ukonceno]  AS (CONVERT([bit],case when [StavPrikazu]>=(50) then (1) else (0) end,0)),
	[Uzavreno]  AS (CONVERT([bit],case when [StavPrikazu]=(60) then (1) else (0) end,0)),
	[PlanZmetky]  AS (CONVERT([numeric](19,6),[kusy_zad]-[kusy_ciste],0)),
	[kusy_zive_ciste]  AS (CONVERT([numeric](19,6),case when ([kusy_ciste]-[kusy_odved])<(0) then (0) when ([kusy_ciste]-[kusy_odved])<[kusy_zive] then [kusy_ciste]-[kusy_odved] else [kusy_zive] end,0)),
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
	[TAC_S]  AS (CONVERT([numeric](19,6),[TAC]*case [TAC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_N]  AS (CONVERT([numeric](19,6),case [TAC_T] when (0) then [TAC]/(60.0) when (1) then [TAC] when (2) then (60.0)*[TAC]  end,0)),
	[TAC_H]  AS (CONVERT([numeric](19,6),[TAC]/case [TAC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TBC_S]  AS (CONVERT([numeric](19,6),[TBC]*case [TBC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_N]  AS (CONVERT([numeric](19,6),case [TBC_T] when (0) then [TBC]/(60.0) when (1) then [TBC] when (2) then (60.0)*[TBC]  end,0)),
	[TBC_H]  AS (CONVERT([numeric](19,6),[TBC]/case [TBC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_S]  AS (CONVERT([numeric](19,6),[TEC]*case [TEC_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_N]  AS (CONVERT([numeric](19,6),case [TEC_T] when (0) then [TEC]/(60.0) when (1) then [TEC] when (2) then (60.0)*[TEC]  end,0)),
	[TEC_H]  AS (CONVERT([numeric](19,6),[TEC]/case [TEC_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[CelkNakl]  AS (CONVERT([numeric](19,6),((((((((((([mat]+[MatRezie])+[koop])+[tbc_kc])+[tec_kc])+[tac_kc])+[rezies])+[reziep])+[reziePrac])+[NakladyPrac])+[OPN])-[VedProdukt])+[naradi],0)),
	[TAC_P_S]  AS (CONVERT([numeric](19,6),[TAC_P]*case [TAC_P_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_P_N]  AS (CONVERT([numeric](19,6),case [TAC_P_T] when (0) then [TAC_P]/(60.0) when (1) then [TAC_P] when (2) then (60.0)*[TAC_P]  end,0)),
	[TAC_P_H]  AS (CONVERT([numeric](19,6),[TAC_P]/case [TAC_P_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TBC_P_S]  AS (CONVERT([numeric](19,6),[TBC_P]*case [TBC_P_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_P_N]  AS (CONVERT([numeric](19,6),case [TBC_P_T] when (0) then [TBC_P]/(60.0) when (1) then [TBC_P] when (2) then (60.0)*[TBC_P]  end,0)),
	[TBC_P_H]  AS (CONVERT([numeric](19,6),[TBC_P]/case [TBC_P_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_P_S]  AS (CONVERT([numeric](19,6),[TEC_P]*case [TEC_P_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_P_N]  AS (CONVERT([numeric](19,6),case [TEC_P_T] when (0) then [TEC_P]/(60.0) when (1) then [TEC_P] when (2) then (60.0)*[TEC_P]  end,0)),
	[TEC_P_H]  AS (CONVERT([numeric](19,6),[TEC_P]/case [TEC_P_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[CelkNakl_P]  AS (CONVERT([numeric](19,6),((((((((((([mat_P]+[MatRezie_P])+[koop_P])+[tbc_kc_P])+[tec_kc_P])+[tac_kc_P])+[rezies_P])+[reziep_P])+[reziePrac_P])+[NakladyPrac_P])+[OPN_P])-[VedProdukt_P])+[naradi_P],0)),
	[RadaPrikaz]  AS ((rtrim([rada])+N' - ')+CONVERT([nvarchar](20),[prikaz],0)),
	[TBC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TBC_Obsluhy_T] [tinyint] NOT NULL,
	[TAC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TAC_Obsluhy_T] [tinyint] NOT NULL,
	[TEC_Obsluhy] [numeric](19, 6) NOT NULL,
	[TEC_Obsluhy_T] [tinyint] NOT NULL,
	[TBC_P_Obsluhy] [numeric](19, 6) NOT NULL,
	[TBC_P_Obsluhy_T] [tinyint] NOT NULL,
	[TAC_P_Obsluhy] [numeric](19, 6) NOT NULL,
	[TAC_P_Obsluhy_T] [tinyint] NOT NULL,
	[TEC_P_Obsluhy] [numeric](19, 6) NOT NULL,
	[TEC_P_Obsluhy_T] [tinyint] NOT NULL,
	[TBC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TBC_Obsluhy]*case [TBC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TBC_Obsluhy_T] when (0) then [TBC_Obsluhy]/(60.0) when (1) then [TBC_Obsluhy] when (2) then (60.0)*[TBC_Obsluhy]  end,0)),
	[TBC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TBC_Obsluhy]/case [TBC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy]*case [TAC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TAC_Obsluhy_T] when (0) then [TAC_Obsluhy]/(60.0) when (1) then [TAC_Obsluhy] when (2) then (60.0)*[TAC_Obsluhy]  end,0)),
	[TAC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TAC_Obsluhy]/case [TAC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TEC_Obsluhy]*case [TEC_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TEC_Obsluhy_T] when (0) then [TEC_Obsluhy]/(60.0) when (1) then [TEC_Obsluhy] when (2) then (60.0)*[TEC_Obsluhy]  end,0)),
	[TEC_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TEC_Obsluhy]/case [TEC_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TBC_P_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TBC_P_Obsluhy]*case [TBC_P_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TBC_P_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TBC_P_Obsluhy_T] when (0) then [TBC_P_Obsluhy]/(60.0) when (1) then [TBC_P_Obsluhy] when (2) then (60.0)*[TBC_P_Obsluhy]  end,0)),
	[TBC_P_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TBC_P_Obsluhy]/case [TBC_P_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TAC_P_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TAC_P_Obsluhy]*case [TAC_P_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TAC_P_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TAC_P_Obsluhy_T] when (0) then [TAC_P_Obsluhy]/(60.0) when (1) then [TAC_P_Obsluhy] when (2) then (60.0)*[TAC_P_Obsluhy]  end,0)),
	[TAC_P_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TAC_P_Obsluhy]/case [TAC_P_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[TEC_P_Obsluhy_S]  AS (CONVERT([numeric](19,6),[TEC_P_Obsluhy]*case [TEC_P_Obsluhy_T] when (0) then (1.0) when (1) then (60.0) when (2) then (3600.0)  end,0)),
	[TEC_P_Obsluhy_N]  AS (CONVERT([numeric](19,6),case [TEC_P_Obsluhy_T] when (0) then [TEC_P_Obsluhy]/(60.0) when (1) then [TEC_P_Obsluhy] when (2) then (60.0)*[TEC_P_Obsluhy]  end,0)),
	[TEC_P_Obsluhy_H]  AS (CONVERT([numeric](19,6),[TEC_P_Obsluhy]/case [TEC_P_Obsluhy_T] when (0) then (3600.0) when (1) then (60.0) when (2) then (1.0)  end,0)),
	[DatumUzavreni] [datetime] NULL,
	[DatumUzavreni_D]  AS (datepart(day,[DatumUzavreni])),
	[DatumUzavreni_M]  AS (datepart(month,[DatumUzavreni])),
	[DatumUzavreni_Y]  AS (datepart(year,[DatumUzavreni])),
	[DatumUzavreni_Q]  AS (datepart(quarter,[DatumUzavreni])),
	[DatumUzavreni_W]  AS (datepart(week,[DatumUzavreni])),
	[DatumUzavreni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumUzavreni],0),0),0)),
	[IDZakazModif] [int] NULL,
	[DatumPredzprac] [datetime] NULL,
	[matA] [numeric](19, 6) NOT NULL,
	[matB] [numeric](19, 6) NOT NULL,
	[matC] [numeric](19, 6) NOT NULL,
	[matA_P] [numeric](19, 6) NOT NULL,
	[matB_P] [numeric](19, 6) NOT NULL,
	[matC_P] [numeric](19, 6) NOT NULL,
	[DatumPredzprac_D]  AS (datepart(day,[DatumPredzprac])),
	[DatumPredzprac_M]  AS (datepart(month,[DatumPredzprac])),
	[DatumPredzprac_Y]  AS (datepart(year,[DatumPredzprac])),
	[DatumPredzprac_Q]  AS (datepart(quarter,[DatumPredzprac])),
	[DatumPredzprac_W]  AS (datepart(week,[DatumPredzprac])),
	[DatumPredzprac_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumPredzprac],0),0),0)),
	[Plan_ukonceni_puvodni] [datetime] NULL,
	[Plan_ukonceni_puvodni_D]  AS (datepart(day,[Plan_ukonceni_puvodni])),
	[Plan_ukonceni_puvodni_M]  AS (datepart(month,[Plan_ukonceni_puvodni])),
	[Plan_ukonceni_puvodni_Y]  AS (datepart(year,[Plan_ukonceni_puvodni])),
	[Plan_ukonceni_puvodni_Q]  AS (datepart(quarter,[Plan_ukonceni_puvodni])),
	[Plan_ukonceni_puvodni_W]  AS (datepart(week,[Plan_ukonceni_puvodni])),
	[Plan_ukonceni_puvodni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Plan_ukonceni_puvodni],0),0),0)),
	[ProcOdved]  AS (CONVERT([numeric](19,6),case when ((([kusy_odved]+[kusy_zmet])+[kusy_ztrac])-[Kusy_zad])>(-0.0001) OR [StavPrikazu]=(60) then (100.0) else ((100.0)*(([kusy_odved]+[kusy_zmet])+[kusy_ztrac]))/[Kusy_zad] end,0)),
	[TranDavka] [numeric](19, 6) NULL,
	[UrovenVnoreni] [int] NULL,
	[IndexZmeny1] [nvarchar](15) NULL,
	[IndexZmeny2] [nvarchar](15) NULL,
	[Priorita] [nvarchar](10) NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[CelkNakl_N]  AS (CONVERT([numeric](19,6),(((((((((((([mat]+[MatRezie])+[koop])+[tbc_kc])+[tec_kc])+[tac_kc])+[rezies])+[reziep])+[reziePrac])+[NakladyPrac])+[OPN])-[VedProdukt])+[naradi])-(((((((((((([mat_P]+[MatRezie_P])+[koop_P])+[tbc_kc_P])+[tec_kc_P])+[tac_kc_P])+[rezies_P])+[reziep_P])+[reziePrac_P])+[NakladyPrac_P])+[OPN_P])-[VedProdukt_P])+[naradi_P]))),
	[mat_N]  AS (CONVERT([numeric](19,6),[mat]-[mat_P])),
	[matA_N]  AS (CONVERT([numeric](19,6),[matA]-[matA_P])),
	[matB_N]  AS (CONVERT([numeric](19,6),[matB]-[matB_P])),
	[matC_N]  AS (CONVERT([numeric](19,6),[matC]-[matC_P])),
	[MatRezie_N]  AS (CONVERT([numeric](19,6),[MatRezie]-[MatRezie_P])),
	[koop_N]  AS (CONVERT([numeric](19,6),[koop]-[koop_P])),
	[TBC_KC_N]  AS (CONVERT([numeric](19,6),[TBC_KC]-[TBC_KC_P])),
	[TAC_KC_N]  AS (CONVERT([numeric](19,6),[TAC_KC]-[TAC_KC_P])),
	[TEC_KC_N]  AS (CONVERT([numeric](19,6),[TEC_KC]-[TEC_KC_P])),
	[rezieS_N]  AS (CONVERT([numeric](19,6),[rezieS]-[rezieS_P])),
	[rezieP_N]  AS (CONVERT([numeric](19,6),[rezieP]-[rezieP_P])),
	[ReziePrac_N]  AS (CONVERT([numeric](19,6),[ReziePrac]-[ReziePrac_P])),
	[NakladyPrac_N]  AS (CONVERT([numeric](19,6),[NakladyPrac]-[NakladyPrac_P])),
	[OPN_N]  AS (CONVERT([numeric](19,6),[OPN]-[OPN_P])),
	[VedProdukt_N]  AS (CONVERT([numeric](19,6),[VedProdukt]-[VedProdukt_P])),
	[naradi_N]  AS (CONVERT([numeric](19,6),[naradi]-[naradi_P])),
 CONSTRAINT [PK__TabPrikaz__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabPrikaz__Rada__Prikaz] UNIQUE NONCLUSTERED 
(
	[Rada] ASC,
	[Prikaz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrikaz__IDObchPrip]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrikaz__IDObchPrip] ON [dbo].[TabPrikaz]
(
	[IDObchPrip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrikaz__IDPrikazRidici]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrikaz__IDPrikazRidici] ON [dbo].[TabPrikaz]
(
	[IDPrikazRidici] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrikaz__IDPrikazVyssi]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrikaz__IDPrikazVyssi] ON [dbo].[TabPrikaz]
(
	[IDPrikazVyssi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrikaz__IDRezervace]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrikaz__IDRezervace] ON [dbo].[TabPrikaz]
(
	[IDRezervace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabPrikaz__IDTabKmen__Sklad]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabPrikaz__IDTabKmen__Sklad] ON [dbo].[TabPrikaz]
(
	[IDTabKmen] ASC,
	[Sklad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__StavPrikazu]  DEFAULT ((10)) FOR [StavPrikazu]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__Plan_zadani]  DEFAULT (CONVERT([datetime],CONVERT([int],CONVERT([float],getdate(),0),0),0)) FOR [Plan_zadani]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__Plan_ukonceni]  DEFAULT (CONVERT([datetime],CONVERT([int],CONVERT([float],getdate(),0),0),0)) FOR [Plan_ukonceni]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_ciste]  DEFAULT ((1)) FOR [kusy_ciste]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_zad]  DEFAULT ((1)) FOR [kusy_zad]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_zad_puvodni]  DEFAULT ((0)) FOR [kusy_zad_puvodni]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_odved]  DEFAULT ((0)) FOR [kusy_odved]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_zmet]  DEFAULT ((0)) FOR [kusy_zmet]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_ztrac]  DEFAULT ((0)) FOR [kusy_ztrac]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__kusy_zive]  DEFAULT ((0)) FOR [kusy_zive]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__EvidJednotka]  DEFAULT ((1)) FOR [EvidJednotka]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__NakladyOPN]  DEFAULT ((0)) FOR [NakladyOPN]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__NakladyOPN_odv]  DEFAULT ((0)) FOR [NakladyOPN_odv]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__NeodvedeneNakladyPoUzav]  DEFAULT ((0)) FOR [NeodvedeneNakladyPoUzav]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TypDilce]  DEFAULT ((1)) FOR [TypDilce]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__ZahrnoutDoKapacPlan]  DEFAULT ((0)) FOR [ZahrnoutDoKapacPlan]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__SmerZaplanovani]  DEFAULT ((0)) FOR [SmerZaplanovani]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__mat]  DEFAULT ((0)) FOR [mat]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__MatRezie]  DEFAULT ((0)) FOR [MatRezie]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__koop]  DEFAULT ((0)) FOR [koop]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC]  DEFAULT ((0)) FOR [TAC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_T]  DEFAULT ((1)) FOR [TAC_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC]  DEFAULT ((0)) FOR [TBC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_T]  DEFAULT ((1)) FOR [TBC_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC]  DEFAULT ((0)) FOR [TEC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_T]  DEFAULT ((1)) FOR [TEC_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_KC]  DEFAULT ((0)) FOR [TAC_KC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_KC]  DEFAULT ((0)) FOR [TBC_KC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_KC]  DEFAULT ((0)) FOR [TEC_KC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__rezieS]  DEFAULT ((0)) FOR [rezieS]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__rezieP]  DEFAULT ((0)) FOR [rezieP]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__ReziePrac]  DEFAULT ((0)) FOR [ReziePrac]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__NakladyPrac]  DEFAULT ((0)) FOR [NakladyPrac]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__OPN]  DEFAULT ((0)) FOR [OPN]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__VedProdukt]  DEFAULT ((0)) FOR [VedProdukt]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__naradi]  DEFAULT ((0)) FOR [naradi]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__mat_P]  DEFAULT ((0)) FOR [mat_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__MatRezie_P]  DEFAULT ((0)) FOR [MatRezie_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__koop_P]  DEFAULT ((0)) FOR [koop_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_P]  DEFAULT ((0)) FOR [TAC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_P_T]  DEFAULT ((1)) FOR [TAC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_P]  DEFAULT ((0)) FOR [TBC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_P_T]  DEFAULT ((1)) FOR [TBC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_P]  DEFAULT ((0)) FOR [TEC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_P_T]  DEFAULT ((1)) FOR [TEC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_KC_P]  DEFAULT ((0)) FOR [TAC_KC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_KC_P]  DEFAULT ((0)) FOR [TBC_KC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_KC_P]  DEFAULT ((0)) FOR [TEC_KC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__rezieS_P]  DEFAULT ((0)) FOR [rezieS_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__rezieP_P]  DEFAULT ((0)) FOR [rezieP_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__ReziePrac_P]  DEFAULT ((0)) FOR [ReziePrac_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__NakladyPrac_P]  DEFAULT ((0)) FOR [NakladyPrac_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__OPN_P]  DEFAULT ((0)) FOR [OPN_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__VedProdukt_P]  DEFAULT ((0)) FOR [VedProdukt_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__naradi_P]  DEFAULT ((0)) FOR [naradi_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__JeNewRec]  DEFAULT ((0)) FOR [JeNewRec]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_Obsluhy]  DEFAULT ((0)) FOR [TBC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_Obsluhy_T]  DEFAULT ((1)) FOR [TBC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_Obsluhy]  DEFAULT ((0)) FOR [TAC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_Obsluhy_T]  DEFAULT ((1)) FOR [TAC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_Obsluhy]  DEFAULT ((0)) FOR [TEC_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_Obsluhy_T]  DEFAULT ((1)) FOR [TEC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_P_Obsluhy]  DEFAULT ((0)) FOR [TBC_P_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TBC_P_Obsluhy_T]  DEFAULT ((1)) FOR [TBC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_P_Obsluhy]  DEFAULT ((0)) FOR [TAC_P_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TAC_P_Obsluhy_T]  DEFAULT ((1)) FOR [TAC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_P_Obsluhy]  DEFAULT ((0)) FOR [TEC_P_Obsluhy]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__TEC_P_Obsluhy_T]  DEFAULT ((1)) FOR [TEC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matA]  DEFAULT ((0)) FOR [matA]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matB]  DEFAULT ((0)) FOR [matB]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matC]  DEFAULT ((0)) FOR [matC]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matA_P]  DEFAULT ((0)) FOR [matA_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matB_P]  DEFAULT ((0)) FOR [matB_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__matC_P]  DEFAULT ((0)) FOR [matC_P]
GO
ALTER TABLE [dbo].[TabPrikaz] ADD  CONSTRAINT [DF__TabPrikaz__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__BarCode] FOREIGN KEY([BarCode])
REFERENCES [dbo].[TabBarCodeZbo] ([BarCode])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__BarCode]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDNaklOkruh] FOREIGN KEY([IDNaklOkruh])
REFERENCES [dbo].[TabNakladovyOkruh] ([Id])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDNaklOkruh]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDObchPrip] FOREIGN KEY([IDObchPrip])
REFERENCES [dbo].[TabKontaktJednani] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDObchPrip]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDPlan] FOREIGN KEY([IDPlan])
REFERENCES [dbo].[TabPlan] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDPlan]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDPrikazRidici] FOREIGN KEY([IDPrikazRidici])
REFERENCES [dbo].[TabPrikaz] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDPrikazRidici]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDPrikazVyssi] FOREIGN KEY([IDPrikazVyssi])
REFERENCES [dbo].[TabPrikaz] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDPrikazVyssi]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDTabKmen] FOREIGN KEY([IDTabKmen])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDTabKmen]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDZakazka] FOREIGN KEY([IDZakazka])
REFERENCES [dbo].[TabZakazka] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDZakazka]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__IDZakazModif] FOREIGN KEY([IDZakazModif])
REFERENCES [dbo].[TabZakazModif] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__IDZakazModif]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__KmenoveStredisko] FOREIGN KEY([KmenoveStredisko])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__KmenoveStredisko]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__Rada] FOREIGN KEY([Rada])
REFERENCES [dbo].[TabRadyPrikazu] ([Rada])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__Rada]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__Sklad] FOREIGN KEY([Sklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__Sklad]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabPrikaz__UKod] FOREIGN KEY([UKod])
REFERENCES [dbo].[TabSkupUKod] ([ID])
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [FK__TabPrikaz__UKod]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__EvidJednotka] CHECK  (([EvidJednotka]>(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__EvidJednotka]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_ciste] CHECK  (([kusy_ciste]>(0) AND [kusy_zad]>=[kusy_ciste]))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_ciste]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_odved] CHECK  (([kusy_odved]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_odved]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_zad] CHECK  (([kusy_zad]>(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_zad]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_zad_puvodni] CHECK  (([kusy_zad_puvodni]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_zad_puvodni]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_zive] CHECK  (([kusy_zive]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_zive]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_zmet] CHECK  (([kusy_zmet]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_zmet]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__kusy_ztrac] CHECK  (([kusy_ztrac]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__kusy_ztrac]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__NakladyOPN] CHECK  (([NakladyOPN]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__NakladyOPN]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__NakladyOPN_odv] CHECK  (([NakladyOPN_odv]>=(0) AND [NakladyOPN_odv]<=[NakladyOPN]))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__NakladyOPN_odv]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__Prikaz] CHECK  (([Prikaz]>(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__Prikaz]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__Priorita] CHECK  ((len([Priorita])>(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__Priorita]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__SmerZaplanovani] CHECK  (([SmerZaplanovani]>=(0) AND [SmerZaplanovani]<=(1)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__SmerZaplanovani]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__StavPrikazu] CHECK  (([StavPrikazu]=(10) OR [StavPrikazu]=(20) OR [StavPrikazu]=(30) OR [StavPrikazu]=(40) OR [StavPrikazu]=(50) OR [StavPrikazu]=(60)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__StavPrikazu]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TAC_Obsluhy_T] CHECK  (([TAC_Obsluhy_T]>=(0) AND [TAC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TAC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TAC_P_Obsluhy_T] CHECK  (([TAC_P_Obsluhy_T]>=(0) AND [TAC_P_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TAC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TAC_P_T] CHECK  (([TAC_P_T]>=(0) AND [TAC_P_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TAC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TAC_T] CHECK  (([TAC_T]>=(0) AND [TAC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TAC_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TBC_Obsluhy_T] CHECK  (([TBC_Obsluhy_T]>=(0) AND [TBC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TBC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TBC_P_Obsluhy_T] CHECK  (([TBC_P_Obsluhy_T]>=(0) AND [TBC_P_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TBC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TBC_P_T] CHECK  (([TBC_P_T]>=(0) AND [TBC_P_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TBC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TBC_T] CHECK  (([TBC_T]>=(0) AND [TBC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TBC_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TEC_Obsluhy_T] CHECK  (([TEC_Obsluhy_T]>=(0) AND [TEC_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TEC_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TEC_P_Obsluhy_T] CHECK  (([TEC_P_Obsluhy_T]>=(0) AND [TEC_P_Obsluhy_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TEC_P_Obsluhy_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TEC_P_T] CHECK  (([TEC_P_T]>=(0) AND [TEC_P_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TEC_P_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TEC_T] CHECK  (([TEC_T]>=(0) AND [TEC_T]<=(2)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TEC_T]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TranDavka] CHECK  (([TranDavka]>=(0)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TranDavka]
GO
ALTER TABLE [dbo].[TabPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabPrikaz__TypDilce] CHECK  (([TypDilce]>=(0) AND [TypDilce]<=(1)))
GO
ALTER TABLE [dbo].[TabPrikaz] CHECK CONSTRAINT [CK__TabPrikaz__TypDilce]
GO
ALTER TABLE [dbo].[TabPrikaz] ENABLE TRIGGER [et_TabPrikaz_ASOL_Log]
GO
ALTER TABLE [dbo].[TabPrikaz] ENABLE TRIGGER [ht_Prikaz_insert_update_delete]
GO
