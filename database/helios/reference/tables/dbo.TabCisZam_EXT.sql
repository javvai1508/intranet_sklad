-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabCisZam_EXT](
	[ID] [int] NOT NULL,
	[_intranet_exp] [bit] NULL,
	[_intranet_sklad] [bit] NULL,
	[_intranet_vychozi] [int] NULL,
	[_intranet_vyroba] [bit] NULL,
	[_intranet_odvadeni] [bit] NULL,
 CONSTRAINT [PK__TabCisZam_EXT__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
