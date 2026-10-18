-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_modi_BarCodeZbo] ON [dbo].[TabBarCodeZbo] FOR INSERT, UPDATE AS
SET NOCOUNT ON
IF UPDATE(BarCode)
IF EXISTS(SELECT*FROM TabBalicekZboziBarCode b JOIN INSERTED i ON i.BarCode=b.BarCode)
BEGIN
ROLLBACK
DECLARE @ErrStr NVARCHAR(2047)
SET @ErrStr = dbo.hf_FormatError(83039, '')
RAISERROR(@ErrStr, 16, 1)
END
GO
