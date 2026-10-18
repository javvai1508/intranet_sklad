-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabDokumVazba](
	[IdentVazby] [int] NOT NULL,
	[IdTab] [int] NOT NULL,
	[IdTab2] [int] NOT NULL,
	[IdTab3] [int] NOT NULL,
	[IdDok] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdUzivTab] [int] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni])))),
 CONSTRAINT [PK__TabDokumVazba__IdentVazby__IdTab__IdTab2__IdTab3__IdDok__IdUzivTab] PRIMARY KEY CLUSTERED 
(
	[IdentVazby] ASC,
	[IdTab] ASC,
	[IdTab2] ASC,
	[IdTab3] ASC,
	[IdDok] ASC,
	[IdUzivTab] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabDokumVazba__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabDokumVazba] ADD  CONSTRAINT [DF__TabDokumVazba__IdTab2]  DEFAULT ((0)) FOR [IdTab2]
GO
ALTER TABLE [dbo].[TabDokumVazba] ADD  CONSTRAINT [DF__TabDokumVazba__IdTab3]  DEFAULT ((0)) FOR [IdTab3]
GO
ALTER TABLE [dbo].[TabDokumVazba] ADD  CONSTRAINT [DF__TabDokumVazba__IdUzivTab]  DEFAULT ((0)) FOR [IdUzivTab]
GO
ALTER TABLE [dbo].[TabDokumVazba] ADD  CONSTRAINT [DF__TabDokumVazba__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabDokumVazba] ADD  CONSTRAINT [DF__TabDokumVazba__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabDokumVazba]  WITH CHECK ADD  CONSTRAINT [FK__TabDokumVazba__IdDok] FOREIGN KEY([IdDok])
REFERENCES [dbo].[TabDokumenty] ([ID])
GO
ALTER TABLE [dbo].[TabDokumVazba] CHECK CONSTRAINT [FK__TabDokumVazba__IdDok]
GO
ALTER TABLE [dbo].[TabDokumVazba] ENABLE TRIGGER [ht_TabDokumVazba_ID]
GO
