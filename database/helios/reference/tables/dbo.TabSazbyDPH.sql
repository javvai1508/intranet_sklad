-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabSazbyDPH](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DruhSazbyDPH] [tinyint] NOT NULL,
	[SazbaDPH] [numeric](5, 2) NOT NULL,
	[ISOKodZeme] [nvarchar](3) NOT NULL,
	[Nazev] [nvarchar](30) NOT NULL,
	[DistribCislo] [int] NULL,
	[PlatnostOd] [datetime] NULL,
	[PlatnostDo] [datetime] NULL,
	[DatUkonceni] [datetime] NULL,
	[Poznamka] [ntext] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[PlatnostOd_D]  AS (datepart(day,[PlatnostOd])),
	[PlatnostOd_M]  AS (datepart(month,[PlatnostOd])),
	[PlatnostOd_Y]  AS (datepart(year,[PlatnostOd])),
	[PlatnostOd_Q]  AS (datepart(quarter,[PlatnostOd])),
	[PlatnostOd_W]  AS (datepart(week,[PlatnostOd])),
	[PlatnostOd_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PlatnostOd])))),
	[PlatnostDo_D]  AS (datepart(day,[PlatnostDo])),
	[PlatnostDo_M]  AS (datepart(month,[PlatnostDo])),
	[PlatnostDo_Y]  AS (datepart(year,[PlatnostDo])),
	[PlatnostDo_Q]  AS (datepart(quarter,[PlatnostDo])),
	[PlatnostDo_W]  AS (datepart(week,[PlatnostDo])),
	[PlatnostDo_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[PlatnostDo])))),
	[DatUkonceni_D]  AS (datepart(day,[DatUkonceni])),
	[DatUkonceni_M]  AS (datepart(month,[DatUkonceni])),
	[DatUkonceni_Y]  AS (datepart(year,[DatUkonceni])),
	[DatUkonceni_Q]  AS (datepart(quarter,[DatUkonceni])),
	[DatUkonceni_W]  AS (datepart(week,[DatUkonceni])),
	[DatUkonceni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatUkonceni])))),
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni])))),
	[DatZmeny_D]  AS (datepart(day,[DatZmeny])),
	[DatZmeny_M]  AS (datepart(month,[DatZmeny])),
	[DatZmeny_Y]  AS (datepart(year,[DatZmeny])),
	[DatZmeny_Q]  AS (datepart(quarter,[DatZmeny])),
	[DatZmeny_W]  AS (datepart(week,[DatZmeny])),
	[DatZmeny_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatZmeny])))),
	[PlatnostOd_Sys]  AS (case when [PlatnostOd] IS NULL then '19000101 00:00:00.000' else [PlatnostOd] end),
	[PlatnostDo_Sys]  AS (case when [PlatnostDo] IS NULL then '99991231 23:59:59.000' else [PlatnostDo] end),
 CONSTRAINT [PK__TabSazbyDPH__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IU__TabSazbyDPH__DistribCislo]    Script Date: 18.10.2026 20:33:14 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IU__TabSazbyDPH__DistribCislo] ON [dbo].[TabSazbyDPH]
(
	[DistribCislo] ASC
)
WHERE ([DistribCislo] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabSazbyDPH] ADD  CONSTRAINT [DF__TabSazbyDPH__Nazev]  DEFAULT ('') FOR [Nazev]
GO
ALTER TABLE [dbo].[TabSazbyDPH] ADD  CONSTRAINT [DF__TabSazbyDPH__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabSazbyDPH] ADD  CONSTRAINT [DF__TabSazbyDPH__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabSazbyDPH]  WITH CHECK ADD  CONSTRAINT [FK__TabSazbyDPH__ISOKodZeme] FOREIGN KEY([ISOKodZeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabSazbyDPH] CHECK CONSTRAINT [FK__TabSazbyDPH__ISOKodZeme]
GO
ALTER TABLE [dbo].[TabSazbyDPH]  WITH CHECK ADD  CONSTRAINT [CK__TabSazbyDPH__DruhSazbyDPH] CHECK  (([DruhSazbyDPH]>=(0) AND [DruhSazbyDPH]<=(8)))
GO
ALTER TABLE [dbo].[TabSazbyDPH] CHECK CONSTRAINT [CK__TabSazbyDPH__DruhSazbyDPH]
GO
ALTER TABLE [dbo].[TabSazbyDPH]  WITH CHECK ADD  CONSTRAINT [CK__TabSazbyDPH__PlatnostOd__PlatnostDo] CHECK  (([PlatnostOd] IS NULL OR [PlatnostDo] IS NULL OR [PlatnostOd]<=[PlatnostDo]))
GO
ALTER TABLE [dbo].[TabSazbyDPH] CHECK CONSTRAINT [CK__TabSazbyDPH__PlatnostOd__PlatnostDo]
GO
ALTER TABLE [dbo].[TabSazbyDPH] ENABLE TRIGGER [ht_SazbyDPH]
GO
