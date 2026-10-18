-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hpx_agrafa_sklad_uzavrit_vydej]
@ID INT

AS

-- převodka do Schenkeru

SET NOCOUNT ON

IF (SELECT COUNT(ID) FROM TabPohybyZbozi WHERE IDDoklad = @ID) <= 0
BEGIN
  DELETE FROM TabDokZboDodatek WHERE IDHlavicky = @ID
  DELETE FROM TabDokladyZbozi_EXT WHERE ID = @ID
  DELETE FROM TabDokladyZbozi WHERE ID = @ID
END

DECLARE @Chyba NVARCHAR(255)
/*
BEGIN TRANSACTION
BEGIN TRY
*/
-- přepočet množství na položce podle množství na VČ
  DECLARE @IDPohyb INT
  DECLARE @MnozVC NUMERIC(19, 6)

  DECLARE cp CURSOR LOCAL FAST_FORWARD FOR
  SELECT 
    po.ID,
    SUM(vcp.Mnozstvi)
  FROM TabPohybyZbozi po
  LEFT JOIN TabVyrCP vcp ON vcp.IDPolozkaDokladu = po.ID
  WHERE po.IDDoklad = @ID  
  GROUP BY po.ID

  OPEN cp
  FETCH NEXT FROM cp INTO @IDPohyb, @MnozVC
  WHILE @@FETCH_STATUS = 0
  BEGIN
    UPDATE TabPohybyZbozi SET Mnozstvi = @MnozVC WHERE ID = @IDPohyb

    FETCH NEXT FROM cp INTO @IDPohyb, @MnozVC
  END

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

  EXEC hp_VypCenOZPolozek_IDDokladu @IDDoklad = @ID, @AktualizaceSlev = 0 

/*
  DECLARE @Res BIT
  -- realizace
  BEGIN TRY
    EXEC dbo.hp_realizuj_vydej @ID = @ID, @DatumRealizace = NULL, @Uzivatel = NULL, @Hlidat = 0, @BylaChyba = @Res 
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION
  END CATCH
*/
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
