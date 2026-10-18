-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_skl_dokl_priprav_paletu]
@SSCC NVARCHAR(50),
@IDDoklad INT

AS

DECLARE @IDVyrCP INT
DECLARE @Mnozstvi NUMERIC(19, 6)

SELECT 
  @IDVyrCP = TabVyrCP.ID,
  @Mnozstvi = TabVyrCP.Mnozstvi  
FROM TabVyrCP 
JOIN TabVyrCS ON TabVyrCP.IDVyrCis = TabVyrCS.ID 
JOIN TabPohybyZbozi ON TabPohybyZbozi.ID = TabVyrCP.IDPolozkaDokladu 
WHERE TabPohybyZbozi.IDDoklad = @IDDoklad AND TabVyrCS.Nazev1 = @SSCC

IF @IDVyrCP IS NOT NULL
BEGIN

  IF EXISTS(SELECT ID FROM TabVyrCP_EXT WHERE ID = @IDVyrCP)
    UPDATE TabVyrCP_EXT SET _exp_mnoz_potvrz = @Mnozstvi WHERE ID = @IDVyrCP
  ELSE
    INSERT INTO TabVyrCP_EXT (ID, _exp_mnoz_potvrz) VALUES (@IDVyrCP, @Mnozstvi)
END
GO
