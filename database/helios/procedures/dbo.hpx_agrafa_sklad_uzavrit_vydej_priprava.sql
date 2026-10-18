-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_sklad_uzavrit_vydej_priprava]
@ID INT

AS

-- mimo převodku do Schenkeru

SET NOCOUNT ON

DECLARE @Chyba NVARCHAR(255)
/*
BEGIN TRANSACTION
BEGIN TRY
*/

IF EXISTS(SELECT ID FROM TabDokladyZbozi_EXT WHERE ID = @ID)
BEGIN
  UPDATE TabDokladyZbozi_EXT 
  SET 
    _exp_dat_uzavreno = GETDATE(), 
    _exp_dat_ktisku = GETDATE(), 
    _exp_dat_tisku = NULL 
  WHERE ID = @ID
END 
ELSE 
BEGIN
  INSERT INTO TabDokladyZbozi_EXT (ID, _exp_dat_uzavreno, _exp_dat_ktisku, _exp_dat_tisku)
  VALUES (@ID, GETDATE(), GETDATE(), NULL)
END

-- EXEC hp_VypCenOZPolozek_IDDokladu @IDDoklad = @ID, @AktualizaceSlev = 0 

/*
END TRY
BEGIN CATCH
  SET @Chyba=ERROR_MESSAGE()
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION
END CATCH

IF @@TRANCOUNT > 0	-- uspesny zapis
  COMMIT TRANSACTION
*/
GO
