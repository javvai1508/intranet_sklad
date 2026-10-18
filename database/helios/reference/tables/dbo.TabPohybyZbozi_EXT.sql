-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPohybyZbozi_EXT](
	[ID] [int] NOT NULL,
	[_exp_id_rozbor] [int] NULL,
	[_exp_mnozstvi_pozad_puvodni] [numeric](19, 6) NULL,
	[_exp_mnozstvi_vc] [numeric](19, 6) NULL,
	[_exp_edi_mnozprij] [numeric](19, 6) NULL,
	[_exp_cenik_chyba_ceny] [bit] NULL,
	[SystemRowVersionExt] [timestamp] NOT NULL,
	[SystemRowVersionExtText]  AS (CONVERT([nvarchar](16),CONVERT([binary](8),[SystemRowVersionExt]),(2))),
	[_ISDOC_Extensions] [ntext] NULL,
	[_exp_mnoz_import] [numeric](19, 6) NULL,
 CONSTRAINT [PK__TabPohybyZbozi_EXT__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
