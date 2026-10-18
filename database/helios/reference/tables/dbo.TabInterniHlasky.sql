-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabInterniHlasky](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cislo] [int] NOT NULL,
	[Jazyk] [smallint] NOT NULL,
	[Hlaska] [nvarchar](max) NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK__TabInterniHlasky__Cislo__Jazyk] PRIMARY KEY CLUSTERED 
(
	[Cislo] ASC,
	[Jazyk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabInterniHlasky__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabInterniHlasky] ADD  CONSTRAINT [DF__TabInterniHlasky__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabInterniHlasky] ADD  CONSTRAINT [DF__TabInterniHlasky__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabInterniHlasky]  WITH CHECK ADD  CONSTRAINT [CK__TabInterniHlasky__Jazyk] CHECK  (([Jazyk]=(1058) OR [Jazyk]=(2052) OR [Jazyk]=(1028) OR [Jazyk]=(1042) OR [Jazyk]=(1041) OR [Jazyk]=(1063) OR [Jazyk]=(1062) OR [Jazyk]=(1061) OR [Jazyk]=(1055) OR [Jazyk]=(1049) OR [Jazyk]=(1026) OR [Jazyk]=(1032) OR [Jazyk]=(1060) OR [Jazyk]=(1051) OR [Jazyk]=(1050) OR [Jazyk]=(1048) OR [Jazyk]=(1045) OR [Jazyk]=(1038) OR [Jazyk]=(1053) OR [Jazyk]=(1035) OR [Jazyk]=(2070) OR [Jazyk]=(2068) OR [Jazyk]=(1043) OR [Jazyk]=(1040) OR [Jazyk]=(3082) OR [Jazyk]=(1030) OR [Jazyk]=(1036) OR [Jazyk]=(1031) OR [Jazyk]=(1033) OR [Jazyk]=(12) OR [Jazyk]=(11) OR [Jazyk]=(10) OR [Jazyk]=(9) OR [Jazyk]=(8) OR [Jazyk]=(7) OR [Jazyk]=(6) OR [Jazyk]=(4) OR [Jazyk]=(1) OR [Jazyk]=(0)))
GO
ALTER TABLE [dbo].[TabInterniHlasky] CHECK CONSTRAINT [CK__TabInterniHlasky__Jazyk]
GO
