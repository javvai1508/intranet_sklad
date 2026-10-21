-- Referencni snimek exportu 18. 10. 2026; NENASAZOVAT jako migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabInvHead](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DatumGenerovani] [datetime] NULL,
	[DatumClose] [datetime] NULL,
	[DatumDoklady] [datetime] NULL,
	[IdSklad] [nvarchar](30) NOT NULL,
	[IdObdobi] [int] NOT NULL,
	[IdPrijem] [int] NULL,
	[IdVydej] [int] NULL,
	[dPrijem] [tinyint] NULL,
	[dVydej] [tinyint] NULL,
	[DokladPrijem] [nvarchar](3) NULL,
	[DokladVydej] [nvarchar](3) NULL,
	[Popis] [nvarchar](40) NULL,
	[DatumSchvaleni] [datetime] NULL,
	[Stav] [tinyint] NOT NULL,
	[MnozPredvypl] [bit] NOT NULL,
	[ZamSchvalil] [int] NULL,
	[KosSchvalil] [int] NULL,
	[ZamSprac] [int] NULL,
	[KosSprac] [int] NULL,
	[TypInv] [int] NOT NULL,
	[TypCeny] [int] NOT NULL,
	[Poznamka] [ntext] NULL,
	[Autor] [nvarchar](128) NOT NULL,
	[DatPorizeni] [datetime] NOT NULL,
	[Zmenil] [nvarchar](128) NULL,
	[DatZmeny] [datetime] NULL,
	[BlokovaniEditoru] [smallint] NULL,
	[VC] [bit] NOT NULL,
	[EvNulaStavVC] [int] NOT NULL,
	[EvNulaStavSkladu] [int] NOT NULL,
	[DatumGenerovani_D]  AS (datepart(day,[DatumGenerovani])),
	[DatumGenerovani_M]  AS (datepart(month,[DatumGenerovani])),
	[DatumGenerovani_Y]  AS (datepart(year,[DatumGenerovani])),
	[DatumGenerovani_Q]  AS (datepart(quarter,[DatumGenerovani])),
	[DatumGenerovani_W]  AS (datepart(week,[DatumGenerovani])),
	[DatumGenerovani_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumGenerovani],0),0),0)),
	[DatumClose_D]  AS (datepart(day,[DatumClose])),
	[DatumClose_M]  AS (datepart(month,[DatumClose])),
	[DatumClose_Y]  AS (datepart(year,[DatumClose])),
	[DatumClose_Q]  AS (datepart(quarter,[DatumClose])),
	[DatumClose_W]  AS (datepart(week,[DatumClose])),
	[DatumClose_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumClose],0),0),0)),
	[DatumDoklady_D]  AS (datepart(day,[DatumDoklady])),
	[DatumDoklady_M]  AS (datepart(month,[DatumDoklady])),
	[DatumDoklady_Y]  AS (datepart(year,[DatumDoklady])),
	[DatumDoklady_Q]  AS (datepart(quarter,[DatumDoklady])),
	[DatumDoklady_W]  AS (datepart(week,[DatumDoklady])),
	[DatumDoklady_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumDoklady],0),0),0)),
	[DatumSchvaleni_D]  AS (datepart(day,[DatumSchvaleni])),
	[DatumSchvaleni_M]  AS (datepart(month,[DatumSchvaleni])),
	[DatumSchvaleni_Y]  AS (datepart(year,[DatumSchvaleni])),
	[DatumSchvaleni_Q]  AS (datepart(quarter,[DatumSchvaleni])),
	[DatumSchvaleni_W]  AS (datepart(week,[DatumSchvaleni])),
	[DatumSchvaleni_X]  AS (CONVERT([datetime],CONVERT([int],CONVERT([float],[DatumSchvaleni],0),0),0)),
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
	[DleUmisteni] [bit] NOT NULL,
	[EvNulaUmisteni] [int] NOT NULL,
	[JeNovaVetaEditor] [bit] NOT NULL,
 CONSTRAINT [UQ__TabInvHead__Id] UNIQUE NONCLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__IdSklad]  DEFAULT ('') FOR [IdSklad]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__Popis]  DEFAULT ('') FOR [Popis]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__Stav]  DEFAULT ((0)) FOR [Stav]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__MnozPredvypl]  DEFAULT ((0)) FOR [MnozPredvypl]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__TypInv]  DEFAULT ((0)) FOR [TypInv]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__TypCeny]  DEFAULT ((0)) FOR [TypCeny]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__Autor]  DEFAULT (suser_sname()) FOR [Autor]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__DatPorizeni]  DEFAULT (getdate()) FOR [DatPorizeni]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__VC]  DEFAULT ((0)) FOR [VC]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__EvNulaStavVC]  DEFAULT ((0)) FOR [EvNulaStavVC]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__EvNulaStavSkladu]  DEFAULT ((0)) FOR [EvNulaStavSkladu]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__DleUmisteni]  DEFAULT ((0)) FOR [DleUmisteni]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__EvNulaUmisteni]  DEFAULT ((0)) FOR [EvNulaUmisteni]
GO
ALTER TABLE [dbo].[TabInvHead] ADD  CONSTRAINT [DF__TabInvHead__JeNovaVetaEditor]  DEFAULT ((0)) FOR [JeNovaVetaEditor]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__DokladPrijem__dPrijem] FOREIGN KEY([DokladPrijem], [dPrijem])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__DokladPrijem__dPrijem]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__DokladVydej__dVydej] FOREIGN KEY([DokladVydej], [dVydej])
REFERENCES [dbo].[TabDruhDokZbo] ([RadaDokladu], [DruhPohybuZbo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__DokladVydej__dVydej]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__IdObdobi] FOREIGN KEY([IdObdobi])
REFERENCES [dbo].[TabObdobi] ([Id])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__IdObdobi]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__IdPrijem] FOREIGN KEY([IdPrijem])
REFERENCES [dbo].[TabDokladyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__IdPrijem]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__IdSklad] FOREIGN KEY([IdSklad])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__IdSklad]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__IdVydej] FOREIGN KEY([IdVydej])
REFERENCES [dbo].[TabDokladyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__IdVydej]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__KosSchvalil] FOREIGN KEY([KosSchvalil])
REFERENCES [dbo].[TabCisKOs] ([Cislo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__KosSchvalil]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__KosSprac] FOREIGN KEY([KosSprac])
REFERENCES [dbo].[TabCisKOs] ([Cislo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__KosSprac]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__ZamSchvalil] FOREIGN KEY([ZamSchvalil])
REFERENCES [dbo].[TabCisZam] ([Cislo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__ZamSchvalil]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [FK__TabInvHead__ZamSprac] FOREIGN KEY([ZamSprac])
REFERENCES [dbo].[TabCisZam] ([Cislo])
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [FK__TabInvHead__ZamSprac]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [CK__TabInvHead__dPrijem] CHECK  (([dPrijem]>=(0) AND [dPrijem]<=(73)))
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [CK__TabInvHead__dPrijem]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [CK__TabInvHead__dVydej] CHECK  (([dVydej]>=(0) AND [dVydej]<=(73)))
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [CK__TabInvHead__dVydej]
GO
ALTER TABLE [dbo].[TabInvHead]  WITH CHECK ADD  CONSTRAINT [CK__TabInvHead__Stav] CHECK  (([Stav]>=(0) AND [Stav]<=(2)))
GO
ALTER TABLE [dbo].[TabInvHead] CHECK CONSTRAINT [CK__TabInvHead__Stav]
GO
