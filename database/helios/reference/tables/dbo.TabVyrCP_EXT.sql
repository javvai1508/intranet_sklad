-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCP_EXT](
	[ID] [int] NOT NULL,
	[_exp_schenker_mnoz] [numeric](19, 6) NULL,
	[_exp_schenker_datcas] [datetime] NULL,
	[_exp_schenker_datcas_import] [datetime] NULL,
	[_exp_mnoz_potvrz] [numeric](19, 6) NULL,
	[_exp_edi_mnozprij_vyrc] [numeric](19, 6) NULL,
	[_SSCC_cisterna] [nvarchar](30) NULL,
 CONSTRAINT [PK__TabVyrCP_EXT__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
