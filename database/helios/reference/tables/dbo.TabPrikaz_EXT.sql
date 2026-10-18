-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPrikaz_EXT](
	[ID] [int] NOT NULL,
	[_vyr_pr_cislosmeny] [int] NULL,
	[_vyr_pr_datexpirace] [datetime] NULL,
	[_vyr_pr_idstroje] [int] NULL,
	[_vyr_pr_odberatel_mu] [int] NULL,
	[_vyr_pr_sarze] [nvarchar](50) NULL,
	[_vyr_pr_zeme_urceni] [nvarchar](3) NULL,
	[_vyr_pr_obal_id] [int] NULL,
	[_vyr_pr_hmotnost_na_palete] [numeric](19, 6) NULL,
	[_vyr_pr_typ_palety] [int] NULL,
	[_vyr_pr_mnozstvi_na_pal] [numeric](19, 6) NULL,
	[_vyr_pr_karton] [int] NULL,
	[_vyr_pr_dat_vyroby] [datetime] NULL,
	[_vyr_pr_objednavka] [nvarchar](50) NULL,
 CONSTRAINT [PK__TabPrikaz_EXT__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
