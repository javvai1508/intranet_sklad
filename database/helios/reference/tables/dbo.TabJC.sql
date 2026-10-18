-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabJC](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDStavSkladu] [int] NOT NULL,
	[EcCelkem] [numeric](19, 6) NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[MnKDispozici] [numeric](19, 6) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[DatZmeny] [datetime] NULL,
	[JCPrijem] [numeric](19, 6) NOT NULL,
	[EcJc]  AS (CONVERT([numeric](19,6),case when isnull([Mnozstvi],(0))>(0) then [EcCelkem]/[Mnozstvi] else (0) end,0)),
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
 CONSTRAINT [UQ__TabJC__ID] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IC__TabJC__IDStavSkladu]    Script Date: 18.10.2026 20:33:07 ******/
CREATE CLUSTERED INDEX [IC__TabJC__IDStavSkladu] ON [dbo].[TabJC]
(
	[IDStavSkladu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabJC] ADD  CONSTRAINT [DF__TabJC__EcCelkem]  DEFAULT ((0.0)) FOR [EcCelkem]
GO
ALTER TABLE [dbo].[TabJC] ADD  CONSTRAINT [DF__TabJC__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabJC] ADD  CONSTRAINT [DF__TabJC__MnKDispozici]  DEFAULT ((0.0)) FOR [MnKDispozici]
GO
ALTER TABLE [dbo].[TabJC] ADD  CONSTRAINT [DF__TabJC__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabJC] ADD  CONSTRAINT [DF__TabJC__DatZmeny]  DEFAULT (getdate()) FOR [DatZmeny]
GO
ALTER TABLE [dbo].[TabJC]  WITH CHECK ADD  CONSTRAINT [FK__TabJC__IDStavSkladu] FOREIGN KEY([IDStavSkladu])
REFERENCES [dbo].[TabStavSkladu] ([ID])
GO
ALTER TABLE [dbo].[TabJC] CHECK CONSTRAINT [FK__TabJC__IDStavSkladu]
GO
ALTER TABLE [dbo].[TabJC] ENABLE TRIGGER [ht_Hlidej]
GO
