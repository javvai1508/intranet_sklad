-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabUmisteniPrijem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPohybu] [int] NOT NULL,
	[IDUmisteni] [int] NOT NULL,
	[Mnozstvi] [numeric](19, 6) NOT NULL,
 CONSTRAINT [PK__TabUmisteniPrijem__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabUmisteniPrijem__IDPohybu__IDUmisteni] UNIQUE NONCLUSTERED 
(
	[IDPohybu] ASC,
	[IDUmisteni] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX__TabUmisteniPrijem__IDUmisteni]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabUmisteniPrijem__IDUmisteni] ON [dbo].[TabUmisteniPrijem]
(
	[IDUmisteni] ASC
)
INCLUDE([ID],[Mnozstvi]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabUmisteniPrijem] ADD  CONSTRAINT [DF__TabUmisteniPrijem__Mnozstvi]  DEFAULT ((0.0)) FOR [Mnozstvi]
GO
ALTER TABLE [dbo].[TabUmisteniPrijem]  WITH CHECK ADD  CONSTRAINT [FK__TabUmisteniPrijem__IDPohybu] FOREIGN KEY([IDPohybu])
REFERENCES [dbo].[TabPohybyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabUmisteniPrijem] CHECK CONSTRAINT [FK__TabUmisteniPrijem__IDPohybu]
GO
ALTER TABLE [dbo].[TabUmisteniPrijem]  WITH CHECK ADD  CONSTRAINT [FK__TabUmisteniPrijem__IDUmisteni] FOREIGN KEY([IDUmisteni])
REFERENCES [dbo].[TabVStavUmisteni] ([Id])
GO
ALTER TABLE [dbo].[TabUmisteniPrijem] CHECK CONSTRAINT [FK__TabUmisteniPrijem__IDUmisteni]
GO
ALTER TABLE [dbo].[TabUmisteniPrijem] ENABLE TRIGGER [ht_UmistPrijemInUpDel]
GO
