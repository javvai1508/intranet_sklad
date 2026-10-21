-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabUmisteni](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdSklad] [nvarchar](30) NOT NULL,
	[Kod] [nvarchar](15) NOT NULL,
	[Nazev] [nvarchar](40) NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[Blokovano] [tinyint] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[DatZmeny] [datetime] NULL,
	[Zmenil] [nvarchar](128) NULL,
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
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
	[AVASentDate] [datetime] NULL,
	[AVAReceivedDate] [datetime] NULL,
	[AVASentDate_D]  AS (datepart(day,[AVASentDate])),
	[AVASentDate_M]  AS (datepart(month,[AVASentDate])),
	[AVASentDate_Y]  AS (datepart(year,[AVASentDate])),
	[AVASentDate_Q]  AS (datepart(quarter,[AVASentDate])),
	[AVASentDate_W]  AS (datepart(week,[AVASentDate])),
	[AVASentDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVASentDate])))),
	[AVAReceivedDate_D]  AS (datepart(day,[AVAReceivedDate])),
	[AVAReceivedDate_M]  AS (datepart(month,[AVAReceivedDate])),
	[AVAReceivedDate_Y]  AS (datepart(year,[AVAReceivedDate])),
	[AVAReceivedDate_Q]  AS (datepart(quarter,[AVAReceivedDate])),
	[AVAReceivedDate_W]  AS (datepart(week,[AVAReceivedDate])),
	[AVAReceivedDate_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[AVAReceivedDate])))),
 CONSTRAINT [PK__TabUmisteni__ID] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabUmisteni__AVAReferenceID] UNIQUE NONCLUSTERED
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabUmisteni__IdSklad__Kod] UNIQUE NONCLUSTERED
(
	[IdSklad] ASC,
	[Kod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabUmisteni__AVAExternalID]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabUmisteni__AVAExternalID] ON [dbo].[TabUmisteni]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__Blokovano]  DEFAULT ((0)) FOR [Blokovano]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabUmisteni] ADD  CONSTRAINT [DF__TabUmisteni__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabUmisteni]  WITH CHECK ADD  CONSTRAINT [FK__TabUmisteni__IdSklad] FOREIGN KEY([IdSklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabUmisteni] CHECK CONSTRAINT [FK__TabUmisteni__IdSklad]
GO
