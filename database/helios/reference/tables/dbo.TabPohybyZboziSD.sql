-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabPohybyZboziSD](
	[ID] [int] NOT NULL,
	[KodSD] [nvarchar](10) NULL,
	[PrepocetMJSD] [numeric](19, 6) NOT NULL,
	[MJSD] [nvarchar](10) NULL,
	[MJRecyk] [nvarchar](10) NULL,
	[PrepMJRecyk] [numeric](19, 6) NULL,
	[CastkaHistRec] [numeric](19, 6) NULL,
	[CastkaGarRec] [numeric](19, 6) NULL,
	[Region] [tinyint] NULL,
	[ZaplaceneClo] [numeric](19, 6) NULL,
	[StHDovoz] [numeric](19, 6) NULL,
	[FakCenaDovoz] [numeric](19, 6) NULL,
	[CelniHodDovoz] [numeric](19, 6) NULL,
	[CastkaRecyk]  AS (CONVERT([numeric](19,6),isnull([CastkaHistRec],(0))+isnull([CastkaGarRec],(0)))),
	[CastkaHistRecVal] [numeric](19, 6) NULL,
	[CastkaGarRecVal] [numeric](19, 6) NULL,
	[CastkaRecykVal]  AS (CONVERT([numeric](19,6),case when [CastkaHistRecVal] IS NULL AND [CastkaGarRecVal] IS NULL then NULL else isnull([CastkaHistRecVal],(0))+isnull([CastkaGarRecVal],(0)) end)),
 CONSTRAINT [PK__TabPohybyZboziSD__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabPohybyZboziSD] ADD  CONSTRAINT [DF__TabPohybyZboziSD__PrepocetMJSD]  DEFAULT ((1.00)) FOR [PrepocetMJSD]
GO
ALTER TABLE [dbo].[TabPohybyZboziSD]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZboziSD__ID] FOREIGN KEY([ID])
REFERENCES [dbo].[TabPohybyZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabPohybyZboziSD] CHECK CONSTRAINT [FK__TabPohybyZboziSD__ID]
GO
ALTER TABLE [dbo].[TabPohybyZboziSD]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZboziSD__MJRecyk] FOREIGN KEY([MJRecyk])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabPohybyZboziSD] CHECK CONSTRAINT [FK__TabPohybyZboziSD__MJRecyk]
GO
ALTER TABLE [dbo].[TabPohybyZboziSD]  WITH CHECK ADD  CONSTRAINT [FK__TabPohybyZboziSD__MJSD] FOREIGN KEY([MJSD])
REFERENCES [dbo].[TabMJ] ([Kod])
GO
ALTER TABLE [dbo].[TabPohybyZboziSD] CHECK CONSTRAINT [FK__TabPohybyZboziSD__MJSD]
GO
