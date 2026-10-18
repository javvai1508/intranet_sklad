-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabSozNa](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDSoz] [int] NOT NULL,
	[IDKmenZbo] [int] NOT NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[Nazev2] [nvarchar](100) NOT NULL,
	[Nazev3] [nvarchar](100) NOT NULL,
	[BarCode] [nvarchar](50) NULL,
	[Sleva] [numeric](5, 2) NOT NULL,
	[CenovaUroven] [int] NULL,
	[DruhSlevy] [tinyint] NOT NULL,
	[OdHodnoty] [numeric](19, 6) NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[DatPorizeni_D]  AS (datepart(day,[DatPorizeni])),
	[DatPorizeni_M]  AS (datepart(month,[DatPorizeni])),
	[DatPorizeni_Y]  AS (datepart(year,[DatPorizeni])),
	[DatPorizeni_Q]  AS (datepart(quarter,[DatPorizeni])),
	[DatPorizeni_W]  AS (datepart(week,[DatPorizeni])),
	[DatPorizeni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatPorizeni],0),0),0)),
	[DatZmeny_D]  AS (datepart(day,[DatZmeny])),
	[DatZmeny_M]  AS (datepart(month,[DatZmeny])),
	[DatZmeny_Y]  AS (datepart(year,[DatZmeny])),
	[DatZmeny_Q]  AS (datepart(quarter,[DatZmeny])),
	[DatZmeny_W]  AS (datepart(week,[DatZmeny])),
	[DatZmeny_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatZmeny],0),0),0)),
	[ExpiraceTyp] [tinyint] NOT NULL,
	[ExpiraceProcento] [numeric](5, 2) NOT NULL,
	[ExpiraceHodnota] [int] NOT NULL,
	[UplatnitSlevy] [bit] NOT NULL,
	[CenovaUrovenNakup] [int] NULL,
	[DruhSlevyNakup] [tinyint] NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[Nazev4] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK__TabSozNa__IDKmenZbo__IDSoz] PRIMARY KEY CLUSTERED 
(
	[IDKmenZbo] ASC,
	[IDSoz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabSozNa__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Nazev1]  DEFAULT ('') FOR [Nazev1]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Nazev2]  DEFAULT ('') FOR [Nazev2]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Nazev3]  DEFAULT ('') FOR [Nazev3]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Sleva]  DEFAULT ((0.0)) FOR [Sleva]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__DruhSlevy]  DEFAULT ((0)) FOR [DruhSlevy]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__OdHodnoty]  DEFAULT ((0.0)) FOR [OdHodnoty]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__ExpiraceTyp]  DEFAULT ((0)) FOR [ExpiraceTyp]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__ExpiraceProcento]  DEFAULT ((0.0)) FOR [ExpiraceProcento]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__ExpiraceHodnota]  DEFAULT ((0)) FOR [ExpiraceHodnota]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__UplatnitSlevy]  DEFAULT ((1)) FOR [UplatnitSlevy]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__DruhSlevyNakup]  DEFAULT ((0)) FOR [DruhSlevyNakup]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabSozNa] ADD  CONSTRAINT [DF__TabSozNa__Nazev4]  DEFAULT ('') FOR [Nazev4]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [FK__TabSozNa__BarCode] FOREIGN KEY([BarCode])
REFERENCES [dbo].[TabBarCodeZbo] ([BarCode])
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [FK__TabSozNa__BarCode]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [FK__TabSozNa__CenovaUroven] FOREIGN KEY([CenovaUroven])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [FK__TabSozNa__CenovaUroven]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [FK__TabSozNa__CenovaUrovenNakup] FOREIGN KEY([CenovaUrovenNakup])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [FK__TabSozNa__CenovaUrovenNakup]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [FK__TabSozNa__IDKmenZbo] FOREIGN KEY([IDKmenZbo])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [FK__TabSozNa__IDKmenZbo]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [FK__TabSozNa__IDSoz] FOREIGN KEY([IDSoz])
REFERENCES [dbo].[TabSoz] ([ID])
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [FK__TabSozNa__IDSoz]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [CK__TabSozNa__DruhSlevy] CHECK  (([DruhSlevy]=(2) OR [DruhSlevy]=(1) OR [DruhSlevy]=(0)))
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [CK__TabSozNa__DruhSlevy]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [CK__TabSozNa__DruhSlevyNakup] CHECK  (([DruhSlevyNakup]=(2) OR [DruhSlevyNakup]=(1) OR [DruhSlevyNakup]=(0)))
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [CK__TabSozNa__DruhSlevyNakup]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [CK__TabSozNa__ExpiraceTyp] CHECK  (([ExpiraceTyp]>=(0) AND [ExpiraceTyp]<=(4)))
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [CK__TabSozNa__ExpiraceTyp]
GO
ALTER TABLE [dbo].[TabSozNa]  WITH CHECK ADD  CONSTRAINT [CK__TabSozNa__OdHodnoty] CHECK  (([OdHodnoty]>=(0)))
GO
ALTER TABLE [dbo].[TabSozNa] CHECK CONSTRAINT [CK__TabSozNa__OdHodnoty]
GO
ALTER TABLE [dbo].[TabSozNa] ENABLE TRIGGER [ht_SOzNa]
GO
