-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_prepoc_doklad]
@IDDoklad INT

AS

UPDATE TabPohybyZbozi
SET JCBezDaniKc = 1 
WHERE IDDoklad = @IDDoklad AND JCBezDaniKc = 0

EXEC hp_VypCenOZPolozek_IDDokladu @IDDoklad = @IDDoklad, @AktualizaceSlev = 0
GO
