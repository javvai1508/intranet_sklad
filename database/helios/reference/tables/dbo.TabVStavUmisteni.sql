-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabVStavUmisteni](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdStav] [int] NOT NULL,
	[IdUmisteni] [int] NOT NULL,
	[Poznamka] [nvarchar](max) NULL,
	[MnozstviUmisteni] [numeric](19, 6) NOT NULL,
	[Prednastaveno] [bit] NOT NULL,
	[AVAReferenceID] [nvarchar](40) NOT NULL,
	[AVAExternalID] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__TabVStavUmisteni__IdStav__IdUmisteni] PRIMARY KEY CLUSTERED 
(
	[IdStav] ASC,
	[IdUmisteni] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVStavUmisteni__AVAReferenceID] UNIQUE NONCLUSTERED 
(
	[AVAReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__TabVStavUmisteni__Id] UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX__TabVStavUmisteni__AVAExternalID]    Script Date: 18.10.2026 20:33:14 ******/
CREATE NONCLUSTERED INDEX [IX__TabVStavUmisteni__AVAExternalID] ON [dbo].[TabVStavUmisteni]
(
	[AVAExternalID] ASC
)
WHERE ([AVAExternalID]<>'')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabVStavUmisteni] ADD  CONSTRAINT [DF__TabVStavUmisteni__MnozstviUmisteni]  DEFAULT ((0.0)) FOR [MnozstviUmisteni]
GO
ALTER TABLE [dbo].[TabVStavUmisteni] ADD  CONSTRAINT [DF__TabVStavUmisteni__Prednastaveno]  DEFAULT ((0)) FOR [Prednastaveno]
GO
ALTER TABLE [dbo].[TabVStavUmisteni] ADD  CONSTRAINT [DF__TabVStavUmisteni__AVAReferenceID]  DEFAULT (CONVERT([nvarchar](36),CONVERT([uniqueidentifier],newid()))) FOR [AVAReferenceID]
GO
ALTER TABLE [dbo].[TabVStavUmisteni] ADD  CONSTRAINT [DF__TabVStavUmisteni__AVAExternalID]  DEFAULT ('') FOR [AVAExternalID]
GO
ALTER TABLE [dbo].[TabVStavUmisteni]  WITH CHECK ADD  CONSTRAINT [FK__TabVStavUmisteni__IDStav] FOREIGN KEY([IdStav])
REFERENCES [dbo].[TabStavSkladu] ([ID])
GO
ALTER TABLE [dbo].[TabVStavUmisteni] CHECK CONSTRAINT [FK__TabVStavUmisteni__IDStav]
GO
ALTER TABLE [dbo].[TabVStavUmisteni]  WITH CHECK ADD  CONSTRAINT [FK__TabVStavUmisteni__IDUmisteni] FOREIGN KEY([IdUmisteni])
REFERENCES [dbo].[TabUmisteni] ([ID])
GO
ALTER TABLE [dbo].[TabVStavUmisteni] CHECK CONSTRAINT [FK__TabVStavUmisteni__IDUmisteni]
GO
ALTER TABLE [dbo].[TabVStavUmisteni] ENABLE TRIGGER [ht_TabVStavUmisteni_IUD]
GO
