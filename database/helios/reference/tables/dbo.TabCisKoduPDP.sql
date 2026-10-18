-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabCisKoduPDP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NazevZbozi] [nvarchar](255) NOT NULL,
	[KodZbozi] [nvarchar](20) NOT NULL,
	[MernaJednotka] [nvarchar](10) NULL,
	[IDMJ] [int] NULL,
	[DatumOd] [datetime] NULL,
	[DatumDo] [datetime] NULL,
	[PrednabizetMnozstvi] [numeric](19, 6) NOT NULL,
	[DelkaKoduZbozi]  AS (CONVERT([int],len([KodZbozi]),0)),
	[Zeme] [nvarchar](3) NOT NULL,
	[Rezim] [tinyint] NOT NULL,
	[LimitPDP] [numeric](19, 6) NOT NULL,
	[Skupina] [int] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[DatumOd_D]  AS (datepart(day,[DatumOd])),
	[DatumOd_M]  AS (datepart(month,[DatumOd])),
	[DatumOd_Y]  AS (datepart(year,[DatumOd])),
	[DatumOd_Q]  AS (datepart(quarter,[DatumOd])),
	[DatumOd_W]  AS (datepart(week,[DatumOd])),
	[DatumOd_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumOd])))),
	[DatumDo_D]  AS (datepart(day,[DatumDo])),
	[DatumDo_M]  AS (datepart(month,[DatumDo])),
	[DatumDo_Y]  AS (datepart(year,[DatumDo])),
	[DatumDo_Q]  AS (datepart(quarter,[DatumDo])),
	[DatumDo_W]  AS (datepart(week,[DatumDo])),
	[DatumDo_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumDo])))),
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
 CONSTRAINT [PK__TabCisKoduPDP__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__DatumOd]  DEFAULT ('20110401 00:00:00.001') FOR [DatumOd]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__PrednabizetMnozstvi]  DEFAULT ((0)) FOR [PrednabizetMnozstvi]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__Rezim]  DEFAULT ((0)) FOR [Rezim]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__LimitPDP]  DEFAULT ((0)) FOR [LimitPDP]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ADD  CONSTRAINT [DF__TabCisKoduPDP__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabCisKoduPDP]  WITH CHECK ADD  CONSTRAINT [FK__TabCisKoduPDP__IDMJ] FOREIGN KEY([IDMJ])
REFERENCES [dbo].[TabMJ] ([ID])
GO
ALTER TABLE [dbo].[TabCisKoduPDP] CHECK CONSTRAINT [FK__TabCisKoduPDP__IDMJ]
GO
ALTER TABLE [dbo].[TabCisKoduPDP]  WITH CHECK ADD  CONSTRAINT [FK__TabCisKoduPDP__Zeme] FOREIGN KEY([Zeme])
REFERENCES [dbo].[TabZeme] ([ISOKod])
GO
ALTER TABLE [dbo].[TabCisKoduPDP] CHECK CONSTRAINT [FK__TabCisKoduPDP__Zeme]
GO
ALTER TABLE [dbo].[TabCisKoduPDP]  WITH CHECK ADD  CONSTRAINT [CK__TabCisKoduPDP__Rezim] CHECK  (([Rezim]>=(0) AND [Rezim]<=(3)))
GO
ALTER TABLE [dbo].[TabCisKoduPDP] CHECK CONSTRAINT [CK__TabCisKoduPDP__Rezim]
GO
ALTER TABLE [dbo].[TabCisKoduPDP] ENABLE TRIGGER [ht_CisKoduPDP]
GO
