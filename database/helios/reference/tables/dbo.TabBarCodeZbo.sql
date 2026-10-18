-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabBarCodeZbo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDKmenZbo] [int] NULL,
	[Prednastaveno] [bit] NOT NULL,
	[BarCode] [nvarchar](50) NOT NULL,
	[DoplnkovyKod] [nvarchar](50) NULL,
	[CisloOrg] [int] NULL,
	[Porizeno] [datetime] NOT NULL,
	[DatZmeny] [datetime] NULL,
	[Porizeno_D]  AS (datepart(day,[Porizeno])),
	[Porizeno_M]  AS (datepart(month,[Porizeno])),
	[Porizeno_Y]  AS (datepart(year,[Porizeno])),
	[Porizeno_Q]  AS (datepart(quarter,[Porizeno])),
	[Porizeno_W]  AS (datepart(week,[Porizeno])),
	[Porizeno_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[Porizeno],0),0),0)),
	[DatZmeny_D]  AS (datepart(day,[DatZmeny])),
	[DatZmeny_M]  AS (datepart(month,[DatZmeny])),
	[DatZmeny_Y]  AS (datepart(year,[DatZmeny])),
	[DatZmeny_Q]  AS (datepart(quarter,[DatZmeny])),
	[DatZmeny_W]  AS (datepart(week,[DatZmeny])),
	[DatZmeny_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatZmeny],0),0),0)),
	[IDKolekce] [int] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__TabBarCodeZbo__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabBarCodeZbo__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabBarCodeZbo__BarCode] UNIQUE NONCLUSTERED 
(
	[BarCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabBarCodeZbo__AVAExternalID]    Script Date: 18.10.2026 20:33:13 ******/
CREATE NONCLUSTERED INDEX [IX__TabBarCodeZbo__AVAExternalID] ON [dbo].[TabBarCodeZbo]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__Prednastaveno]  DEFAULT ((0)) FOR [Prednastaveno]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__Porizeno]  DEFAULT (getdate()) FOR [Porizeno]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ADD  CONSTRAINT [DF__TabBarCodeZbo__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabBarCodeZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabBarCodeZbo__CisloOrg] FOREIGN KEY([CisloOrg])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabBarCodeZbo] CHECK CONSTRAINT [FK__TabBarCodeZbo__CisloOrg]
GO
ALTER TABLE [dbo].[TabBarCodeZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabBarCodeZbo__IDKmenZbo] FOREIGN KEY([IDKmenZbo])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabBarCodeZbo] CHECK CONSTRAINT [FK__TabBarCodeZbo__IDKmenZbo]
GO
ALTER TABLE [dbo].[TabBarCodeZbo]  WITH CHECK ADD  CONSTRAINT [FK__TabBarCodeZbo__IDKolekce] FOREIGN KEY([IDKolekce])
REFERENCES [dbo].[TabOZKolekce] ([ID])
GO
ALTER TABLE [dbo].[TabBarCodeZbo] CHECK CONSTRAINT [FK__TabBarCodeZbo__IDKolekce]
GO
ALTER TABLE [dbo].[TabBarCodeZbo]  WITH CHECK ADD  CONSTRAINT [CK__TabBarCodeZbo__IDKmenZbo__IDKolekce] CHECK  (([IDKmenZbo] IS NOT NULL AND [IDKolekce] IS NULL OR [IDKmenZbo] IS NULL AND [IDKolekce] IS NOT NULL))
GO
ALTER TABLE [dbo].[TabBarCodeZbo] CHECK CONSTRAINT [CK__TabBarCodeZbo__IDKmenZbo__IDKolekce]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ENABLE TRIGGER [ht_BarCodeZbo_AVAModel_Change]
GO
ALTER TABLE [dbo].[TabBarCodeZbo] ENABLE TRIGGER [ht_modi_BarCodeZbo]
GO
