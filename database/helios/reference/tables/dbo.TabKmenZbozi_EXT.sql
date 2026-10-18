-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabKmenZbozi_EXT](
	[ID] [int] NOT NULL,
	[_ncena] [numeric](19, 6) NULL,
	[_rlvyber] [bit] NULL,
	[_ext_kodPDP] [int] NULL,
	[_fa_ean_tesco] [nvarchar](20) NULL,
	[_fa_tpn_tesco] [nvarchar](20) NULL,
	[_vlvyber] [bit] NULL,
	[_poznamka_en] [ntext] NULL,
	[_kod_da] [nvarchar](5) NULL,
	[_expok] [int] NULL,
	[_ext_NuloveMnozstviPDP] [bit] NULL,
	[_hmotnost_paleta] [numeric](19, 6) NULL,
	[_irvyber] [bit] NULL,
	[_ir_a_energie_min] [numeric](19, 6) NULL,
	[_ir_a_energie_max] [numeric](19, 6) NULL,
	[_ir_vlhkost_min] [numeric](19, 6) NULL,
	[_ir_vlhkost_max] [numeric](19, 6) NULL,
	[_ir_popel_min] [numeric](19, 6) NULL,
	[_ir_popel_max] [numeric](19, 6) NULL,
	[_ir_lepek_min] [numeric](19, 6) NULL,
	[_ir_lepek_max] [numeric](19, 6) NULL,
	[_ir_n_latky_min] [numeric](19, 6) NULL,
	[_ir_n_latky_max] [numeric](19, 6) NULL,
	[_ir_zeleny_test_min] [numeric](19, 6) NULL,
	[_ir_zeleny_test_max] [numeric](19, 6) NULL,
	[_ir_padc_min] [numeric](19, 6) NULL,
	[_ir_padc_max] [numeric](19, 6) NULL,
	[_ir_f_vaznost_min] [numeric](19, 6) NULL,
	[_ir_f_vaznost_max] [numeric](19, 6) NULL,
	[_ir_a_pl_min] [numeric](19, 6) NULL,
	[_ir_a_pl_max] [numeric](19, 6) NULL,
	[_ir_poskozeny_skrob_max] [numeric](19, 6) NULL,
	[_ir_poskozeny_skrob_min] [numeric](19, 6) NULL,
	[_ir_e_taznost_min] [numeric](19, 6) NULL,
	[_ir_e_taznost_max] [numeric](19, 6) NULL,
	[_ir_e_maximum_min] [numeric](19, 6) NULL,
	[_ir_e_maximum_max] [numeric](19, 6) NULL,
	[_ir_e_energie_min] [numeric](19, 6) NULL,
	[_ir_e_energie_max] [numeric](19, 6) NULL,
	[_vl_typ_zadavani] [int] NULL,
	[_vyr_mnoz_v_obalu] [numeric](19, 6) NULL,
	[_vyr_kmen_material] [int] NULL,
	[_vyr_material_jazyk] [nvarchar](20) NULL,
	[_PocetSpotrMjVeFaktMJ] [float] NULL,
	[_vyr_nazev_pl] [nvarchar](500) NULL,
	[_ro_bio] [bit] NULL,
	[_ro_surovina] [int] NULL,
	[_ro_clzr] [bit] NULL,
	[_ro_ost_ml3] [bit] NULL,
	[_expok_aut_dopln_sklad] [bit] NULL,
	[_ro_druh] [int] NULL,
	[_exp_karton_polozka] [int] NULL,
	[_vyr_linka] [int] NULL,
	[_bezlepku] [bit] NULL,
	[_ro_druh_baleni] [int] NULL,
	[_expok_zalozka] [int] NULL,
	[_expok_zalozka_poradi] [int] NULL,
	[SystemRowVersionExt] [timestamp] NOT NULL,
	[SystemRowVersionExtText]  AS (CONVERT([nvarchar](16),CONVERT([binary](8),[SystemRowVersionExt]),(2))),
	[_vyr_kmen_typ_palety] [int] NULL,
 CONSTRAINT [PK__TabKmenZbozi_EXT__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabKmenZbozi_EXT] ENABLE TRIGGER [et_TabKmenZbozi_EXT_PDP]
GO
