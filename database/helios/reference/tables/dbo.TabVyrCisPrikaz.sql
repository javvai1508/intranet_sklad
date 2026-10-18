-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVyrCisPrikaz](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPrikaz] [int] NOT NULL,
	[VyrCislo] [nvarchar](100) NOT NULL,
	[DatExpirace] [datetime] NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[DatExpirace_D]  AS (datepart(day,[DatExpirace])),
	[DatExpirace_M]  AS (datepart(month,[DatExpirace])),
	[DatExpirace_Y]  AS (datepart(year,[DatExpirace])),
	[DatExpirace_Q]  AS (datepart(quarter,[DatExpirace])),
	[DatExpirace_W]  AS (datepart(week,[DatExpirace])),
	[DatExpirace_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatExpirace],0),0),0)),
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
	[Odvedeno] [numeric](19, 6) NOT NULL,
	[Zmetky] [numeric](19, 6) NOT NULL,
	[Popis] [nvarchar](100) NOT NULL,
	[BlokovaneMnozstvi] [numeric](19, 6) NOT NULL,
	[MnozstviZive]  AS (CONVERT([numeric](19,6),case when ((([Mnozstvi]-[BlokovaneMnozstvi])-[Odvedeno])-[Zmetky])<(0.0) then (0.0) else (([Mnozstvi]-[BlokovaneMnozstvi])-[Odvedeno])-[Zmetky] end)),
 CONSTRAINT [PK__TabVyrCisPrikaz__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVyrCisPrikaz__IDPrikaz__VyrCislo] UNIQUE NONCLUSTERED 
(
	[IDPrikaz] ASC,
	[VyrCislo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__Mnozstvi]  DEFAULT ((0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__Odvedeno]  DEFAULT ((0)) FOR [Odvedeno]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__Zmetky]  DEFAULT ((0)) FOR [Zmetky]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__Popis]  DEFAULT ('') FOR [Popis]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] ADD  CONSTRAINT [DF__TabVyrCisPrikaz__BlokovaneMnozstvi]  DEFAULT ((0)) FOR [BlokovaneMnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [FK__TabVyrCisPrikaz__IDPrikaz] FOREIGN KEY([IDPrikaz])
REFERENCES [dbo].[TabPrikaz] ([ID])
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [FK__TabVyrCisPrikaz__IDPrikaz]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCisPrikaz__BlokovaneMnozstvi] CHECK  (([BlokovaneMnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [CK__TabVyrCisPrikaz__BlokovaneMnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCisPrikaz__Mnozstvi] CHECK  (([Mnozstvi]>=(0)))
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [CK__TabVyrCisPrikaz__Mnozstvi]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCisPrikaz__Odvedeno] CHECK  (([Odvedeno]>=(0)))
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [CK__TabVyrCisPrikaz__Odvedeno]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCisPrikaz__VyrCislo] CHECK  ((len([VyrCislo])>(0)))
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [CK__TabVyrCisPrikaz__VyrCislo]
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz]  WITH CHECK ADD  CONSTRAINT [CK__TabVyrCisPrikaz__Zmetky] CHECK  (([Zmetky]>=(0)))
GO
ALTER TABLE [dbo].[TabVyrCisPrikaz] CHECK CONSTRAINT [CK__TabVyrCisPrikaz__Zmetky]
GO
