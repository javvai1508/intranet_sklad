-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCK_EXT] (
	[ID] [int] NOT NULL,
	 [_vlhkost_km] [numeric](19, 6) NULL,
	 [_grana_km] [numeric](19, 6) NULL,
	 [_granb_km] [numeric](19, 6) NULL,
	 [_popel_km] [numeric](19, 6) NULL,
	 [_vlak_km] [numeric](19, 6) NULL,
	 [_bobt_km] [numeric](19, 6) NULL,
	 [_ocko_km] [numeric](19, 6) NULL,
	 [_lepek_km] [numeric](19, 6) NULL,
	 [_padc_km] [numeric](19, 6) NULL,
	 [_sarze_km] [nvarchar](20) NULL,
	 [_datPytlovani_km] [datetime] NULL,
	 [_rlfirma_km] [int] NULL,
	 [_rlarchiv_km] [bit] NULL,
	 [_vl_btto_km] [numeric](19, 6) NULL,
	 [_vl_tara_km] [numeric](19, 6) NULL,
	 [_vl_firma_km] [int] NULL,
	 [_vl_datum_km] [datetime] NULL,
	 [_vl_pozn_km] [nvarchar](100) NULL,
	 [_vl_pocet_dod_km] [int] NULL,
	 [_vl_vlhkost_km] [numeric](19, 6) NULL,
	 [_vl_necistoty_km] [numeric](19, 6) NULL,
	 [_vl_primes_km] [numeric](19, 6) NULL,
	 [_vl_lepek_km] [numeric](19, 6) NULL,
	 [_vl_objhm_km] [numeric](19, 6) NULL,
	 [_vl_padc_km] [numeric](19, 6) NULL,
	 [_vl_n_latky_km] [numeric](19, 6) NULL,
	 [_vl_spz_km] [nvarchar](20) NULL,
	 [_gran250_km] [numeric](19, 6) NULL,
	 [_gran160_km] [numeric](19, 6) NULL,
	 [_gran106_km] [numeric](19, 6) NULL,
	 [_vyhovuje_km] [bit] NULL,
	 [_vl_cislovl_km] [int] NULL,
	 [_vl_tvrdost_km] [numeric](19, 6) NULL,
	 [_vl_sedi_km] [numeric](19, 6) NULL,
	 [_vl_senzor_km] [bit] NULL,
	 [_vl_ok_spec_km] [bit] NULL,
	 [_vl_ok_term_km] [bit] NULL,
	 [_vl_odruda_km] [nvarchar](20) NULL,
	 [_vl_ridic_km] [nvarchar](50) NULL,
	 [_vl_id_dod_km] [int] NULL,
	 [_vl_dodavatel_km] [varchar](100) NULL,
	 [_vl_dodavatel_novy_km] [nvarchar](100) NULL,
	 [_ir_vlhkost_km] [numeric](19, 6) NULL,
	 [_ir_popel_km] [numeric](19, 6) NULL,
	 [_ir_lepek_km] [numeric](19, 6) NULL,
	 [_ir_mouka_km] [nvarchar](50) NULL,
	 [_ir_n_latky_km] [numeric](19, 6) NULL,
	 [_ir_zeleny_test_km] [numeric](19, 6) NULL,
	 [_ir_padc_km] [numeric](19, 6) NULL,
	 [_ir_f_vaznost_km] [numeric](19, 6) NULL,
	 [_ir_f_vyvin_km] [numeric](19, 6) NULL,
	 [_ir_f_stabilita_km] [numeric](19, 6) NULL,
	 [_ir_f_pokles_km] [numeric](19, 6) NULL,
	 [_ir_e_taznost_km] [numeric](19, 6) NULL,
	 [_ir_e_maximum_km] [numeric](19, 6) NULL,
	 [_ir_e_energie_km] [numeric](19, 6) NULL,
	 [_ir_a_energie_km] [numeric](19, 6) NULL,
	 [_ir_a_pl_km] [numeric](19, 6) NULL,
	 [_ir_poskozeny_skrob_km] [numeric](19, 6) NULL,
	 [_ir_src_mlecna_km] [numeric](19, 6) NULL,
	 [_ir_src_sacharoza_km] [numeric](19, 6) NULL,
	 [_ir_src_uhlicitan_km] [numeric](19, 6) NULL,
	 [_ir_src_voda_km] [numeric](19, 6) NULL,
	 [_ir_kodlab_km] [nvarchar](30) NULL,
	 [_vl_kod_umisteni_km] [nvarchar](15) NULL,
	 [_vl_kod_umisteni_log_km] [ntext] NULL,
	 [_vl_nasklad_km] [bit] NULL,
	 [_vl_zeskladu_km] [bit] NULL,
	 [_vl_jinymlyn_km] [bit] NULL,
	 CONSTRAINT [PK__TabVyrCK_EXT__ID] PRIMARY KEY CLUSTERED 
	 (
	[ID] ASC
	 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- přetažení externích údajů - TabVyrCS > TabVyrCK
INSERT INTO [dbo].[TabVyrCK_EXT]
           ([ID]
           ,[_vlhkost_km]
           ,[_grana_km]
           ,[_granb_km]
           ,[_popel_km]
           ,[_vlak_km]
           ,[_bobt_km]
           ,[_ocko_km]
           ,[_lepek_km]
           ,[_padc_km]
           ,[_sarze_km]
           ,[_datPytlovani_km]
           ,[_rlfirma_km]
           ,[_rlarchiv_km]
           ,[_vl_btto_km]
           ,[_vl_tara_km]
           ,[_vl_firma_km]
           ,[_vl_datum_km]
           ,[_vl_pozn_km]
           ,[_vl_pocet_dod_km]
           ,[_vl_vlhkost_km]
           ,[_vl_necistoty_km]
           ,[_vl_primes_km]
           ,[_vl_lepek_km]
           ,[_vl_objhm_km]
           ,[_vl_padc_km]
           ,[_vl_n_latky_km]
           ,[_vl_spz_km]
           ,[_gran250_km]
           ,[_gran160_km]
           ,[_gran106_km]
           ,[_vyhovuje_km]
           ,[_vl_cislovl_km]
           ,[_vl_tvrdost_km]
           ,[_vl_sedi_km]
           ,[_vl_senzor_km]
           ,[_vl_ok_spec_km]
           ,[_vl_ok_term_km]
           ,[_vl_odruda_km]
           ,[_vl_ridic_km]
           ,[_vl_id_dod_km]
           ,[_vl_dodavatel_km]
           ,[_vl_dodavatel_novy_km]
           ,[_ir_vlhkost_km]
           ,[_ir_popel_km]
           ,[_ir_lepek_km]
           ,[_ir_mouka_km]
           ,[_ir_n_latky_km]
           ,[_ir_zeleny_test_km]
           ,[_ir_padc_km]
           ,[_ir_f_vaznost_km]
           ,[_ir_f_vyvin_km]
           ,[_ir_f_stabilita_km]
           ,[_ir_f_pokles_km]
           ,[_ir_e_taznost_km]
           ,[_ir_e_maximum_km]
           ,[_ir_e_energie_km]
           ,[_ir_a_energie_km]
           ,[_ir_a_pl_km]
           ,[_ir_poskozeny_skrob_km]
           ,[_ir_src_mlecna_km]
           ,[_ir_src_sacharoza_km]
           ,[_ir_src_uhlicitan_km]
           ,[_ir_src_voda_km]
           ,[_ir_kodlab_km]
           ,[_vl_kod_umisteni_km]
           ,[_vl_kod_umisteni_log_km]
           ,[_vl_nasklad_km]
           ,[_vl_zeskladu_km]
           ,[_vl_jinymlyn_km])

SELECT [dbo].[TabVyrCS].[IDVyrCK]
      ,MAX([_vlhkost])
      ,MAX([_grana])
      ,MAX([_granb])
      ,MAX([_popel])
      ,MAX([_vlak])
      ,MAX([_bobt])
      ,MAX([_ocko])
      ,MAX([_lepek])
      ,MAX([_padc])
      ,MAX([_sarze])
      ,MAX([_datPytlovani])
      ,MAX([_rlfirma])
      ,MAX(CONVERT(INT, [_rlarchiv]))
      ,MAX([_vl_btto])
      ,MAX([_vl_tara])
      ,MAX([_vl_firma])
      ,MAX([_vl_datum])
      ,MAX([_vl_pozn])
      ,MAX([_vl_pocet_dod])
      ,MAX([_vl_vlhkost])
      ,MAX([_vl_necistoty])
      ,MAX([_vl_primes])
      ,MAX([_vl_lepek])
      ,MAX([_vl_objhm])
      ,MAX([_vl_padc])
      ,MAX([_vl_n_latky])
      ,MAX([_vl_spz])
      ,MAX([_gran250])
      ,MAX([_gran160])
      ,MAX([_gran106])
      ,MAX(CONVERT(INT, [_vyhovuje]))
      ,MAX([_vl_cislovl])
      ,MAX([_vl_tvrdost])
      ,MAX([_vl_sedi])
      ,MAX(CONVERT(INT, [_vl_senzor]))
      ,MAX(CONVERT(INT, [_vl_ok_spec]))
      ,MAX(CONVERT(INT, [_vl_ok_term]))
      ,MAX([_vl_odruda])
      ,MAX([_vl_ridic])
      ,MAX([_vl_id_dod])
      ,MAX([_vl_dodavatel])
      ,MAX([_vl_dodavatel_novy])
      ,MAX([_ir_vlhkost])
      ,MAX([_ir_popel])
      ,MAX([_ir_lepek])
      ,MAX([_ir_mouka])
      ,MAX([_ir_n_latky])
      ,MAX([_ir_zeleny_test])
      ,MAX([_ir_padc])
      ,MAX([_ir_f_vaznost])
      ,MAX([_ir_f_vyvin])
      ,MAX([_ir_f_stabilita])
      ,MAX([_ir_f_pokles])
      ,MAX([_ir_e_taznost])
      ,MAX([_ir_e_maximum])
      ,MAX([_ir_e_energie])
      ,MAX([_ir_a_energie])
      ,MAX([_ir_a_pl])
      ,MAX([_ir_poskozeny_skrob])
      ,MAX([_ir_src_mlecna])
      ,MAX([_ir_src_sacharoza])
      ,MAX([_ir_src_uhlicitan])
      ,MAX([_ir_src_voda])
      ,MAX([_ir_kodlab])
      ,MAX([_vl_kod_umisteni])
      ,MAX(CONVERT(NVARCHAR(4000), [_vl_kod_umisteni_log]))
      ,MAX(CONVERT(INT, [_vl_nasklad]))
      ,MAX(CONVERT(INT, [_vl_zeskladu]))
      ,MAX(CONVERT(INT, [_vl_jinymlyn]))
  FROM [dbo].[TabVyrCS_EXT]
  LEFT JOIN [dbo].[TabVyrCS] ON [dbo].[TabVyrCS_EXT].ID = [dbo].[TabVyrCS].ID
  GROUP BY [dbo].[TabVyrCS].[IDVyrCK]
GO
