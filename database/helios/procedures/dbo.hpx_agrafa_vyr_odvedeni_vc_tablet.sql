-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_vyr_odvedeni_vc_tablet]
@IDPrijem INT OUTPUT,
@Msg NVARCHAR(2000) OUTPUT,
@IDVyrCis INT,
@CisloZam INT

AS

EXEC dbo.hpx_agrafa_vyr_odved_vc @CisloZam = @CisloZam, @IDVyrCis = @IDVyrCis, @IDPrijem = @IDPrijem OUTPUT, @Msg = @Msg OUTPUT

--RETURN @IDPrijem
GO
