-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabInvItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDoklad] [int] NOT NULL,
	[IdSklad] [int] NOT NULL,
	[SkupZbo] [nvarchar](3) NOT NULL,
	[RegCis] [nvarchar](30) NOT NULL,
	[Nazev1] [nvarchar](100) NOT NULL,
	[MnozstviSklad] [numeric](19, 6) NOT NULL,
	[EvidCenaCelkem] [numeric](19, 6) NOT NULL,
	[MnozstviInv] [numeric](19, 6) NOT NULL,
	[CenaInvCelkem] [numeric](19, 6) NOT NULL,
	[CenaInvJC] [numeric](19, 6) NOT NULL,
	[Uzav] [bit] NOT NULL,
	[Poznamka] [ntext] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[IdVyrCS] [int] NULL,
	[IDKmenZbozi] [int] NULL,
	[MnozstviRozdil]  AS (CONVERT([numeric](20,6),[MnozstviSklad]-[MnozstviInv],0)),
	[CenaRozdil]  AS (CONVERT([numeric](20,6),[EvidCenaCelkem]-[CenaInvCelkem],0)),
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
	[IDUmisteni] [int] NULL,
	[SkladRozdil] [numeric](19, 6) NOT NULL,
	[SkladRozdilProm] [numeric](19, 6) NOT NULL,
	[SkladRozdilReal] [numeric](19, 6) NOT NULL,
	[RozdilVC] [numeric](19, 6) NOT NULL,
	[RozdilVCProm] [numeric](19, 6) NOT NULL,
	[RozdilVCReal] [numeric](19, 6) NOT NULL,
	[RozdilVCVyrov] [numeric](19, 6) NOT NULL,
	[RozdilUmi] [numeric](19, 6) NOT NULL,
	[RozdilUmiProm] [numeric](19, 6) NOT NULL,
	[RozdilUmiReal] [numeric](19, 6) NOT NULL,
	[RozdilUmiVyrov] [numeric](19, 6) NOT NULL,
	[RozdilVCUmi] [numeric](19, 6) NOT NULL,
	[RozdilVCUmiProm] [numeric](19, 6) NOT NULL,
	[RozdilVCUmiReal] [numeric](19, 6) NOT NULL,
	[RozdilVCUmiVyrov] [numeric](19, 6) NOT NULL,
	[MnozstviMJ] [numeric](19, 6) NOT NULL,
	[MJ] [nvarchar](10) NULL,
	[PrepMnozstvi] [float] NOT NULL,
	[RozdilVCRealUpl] [numeric](19, 6) NOT NULL,
	[Hmotnost] [numeric](19, 6) NOT NULL,
 CONSTRAINT [PK__TabInvItem__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabInvItem__IDDoklad__IDSklad__IDVyrCS__IDUmisteni] UNIQUE NONCLUSTERED 
(
	[IdDoklad] ASC,
	[IdSklad] ASC,
	[IdVyrCS] ASC,
	[IDUmisteni] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__Nazev1]  DEFAULT ('') FOR [Nazev1]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__MnozstviSklad]  DEFAULT ((0.0)) FOR [MnozstviSklad]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__EvidCenaCelkem]  DEFAULT ((0.0)) FOR [EvidCenaCelkem]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__MnozstviInv]  DEFAULT ((0.0)) FOR [MnozstviInv]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__CenaInvCelkem]  DEFAULT ((0.0)) FOR [CenaInvCelkem]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__CenaInvJC]  DEFAULT ((0.0)) FOR [CenaInvJC]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__Uzav]  DEFAULT ((0)) FOR [Uzav]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__SkladRozdil]  DEFAULT ((0.0)) FOR [SkladRozdil]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__SkladRozdilProm]  DEFAULT ((0.0)) FOR [SkladRozdilProm]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__SkladRozdilReal]  DEFAULT ((0.0)) FOR [SkladRozdilReal]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVC]  DEFAULT ((0.0)) FOR [RozdilVC]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCProm]  DEFAULT ((0.0)) FOR [RozdilVCProm]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCReal]  DEFAULT ((0.0)) FOR [RozdilVCReal]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCVyrov]  DEFAULT ((0.0)) FOR [RozdilVCVyrov]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilUmi]  DEFAULT ((0.0)) FOR [RozdilUmi]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilUmiProm]  DEFAULT ((0.0)) FOR [RozdilUmiProm]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilUmiReal]  DEFAULT ((0.0)) FOR [RozdilUmiReal]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilUmiVyrov]  DEFAULT ((0.0)) FOR [RozdilUmiVyrov]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCUmi]  DEFAULT ((0.0)) FOR [RozdilVCUmi]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCUmiProm]  DEFAULT ((0.0)) FOR [RozdilVCUmiProm]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCUmiReal]  DEFAULT ((0.0)) FOR [RozdilVCUmiReal]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCUmiVyrov]  DEFAULT ((0.0)) FOR [RozdilVCUmiVyrov]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__MnozstviMJ]  DEFAULT ((0.0)) FOR [MnozstviMJ]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__PrepMnozstvi]  DEFAULT ((1.0)) FOR [PrepMnozstvi]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__RozdilVCRealUpl]  DEFAULT ((0.0)) FOR [RozdilVCRealUpl]
GO
ALTER TABLE [dbo].[TabInvItem] ADD  CONSTRAINT [DF__TabInvItem__Hmotnost]  DEFAULT ((0.0)) FOR [Hmotnost]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__IdDoklad] FOREIGN KEY([IdDoklad])
REFERENCES [dbo].[TabInvHead] ([Id])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__IdDoklad]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__IDKmenZbozi] FOREIGN KEY([IDKmenZbozi])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__IDKmenZbozi]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__IdSklad] FOREIGN KEY([IdSklad])
REFERENCES [dbo].[TabStavSkladu] ([ID])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__IdSklad]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__IDUmisteni] FOREIGN KEY([IDUmisteni])
REFERENCES [dbo].[TabVStavUmisteni] ([Id])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__IDUmisteni]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__IdVyrCS] FOREIGN KEY([IdVyrCS])
REFERENCES [dbo].[TabVyrCS] ([ID])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__IdVyrCS]
GO
ALTER TABLE [dbo].[TabInvItem]  WITH CHECK ADD  CONSTRAINT [FK__TabInvItem__SkupZbo] FOREIGN KEY([SkupZbo])
REFERENCES [dbo].[TabSkupinyZbozi] ([SkupZbo])
GO
ALTER TABLE [dbo].[TabInvItem] CHECK CONSTRAINT [FK__TabInvItem__SkupZbo]
GO
