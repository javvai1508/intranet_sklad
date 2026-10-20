-- Spustit v cílové databázi Heliosu před nasazením PHP aplikace.
-- Převod do Loukova i zpět; obsahuje také změnu z 20261020_loukov.sql.
-- Tisk a realizace zůstávají ruční.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[hpx_agrafa_sklad_zaloz_vydej_ost_hl_tablet]
@TypVydejky NVARCHAR(20),
@Token NVARCHAR(100)

AS

DECLARE @IDDoklad INT
DECLARE @IDSklad NVARCHAR(50)
DECLARE @DruhPohybu INT
DECLARE @RadaDokladu NVARCHAR(10)
DECLARE @DruhPohybuPrevodu INT
DECLARE @RadaDokladuPrevodu NVARCHAR(10)
DECLARE @IDSkladPrevodu NVARCHAR(50)
DECLARE @CisloOrg INT

SET @DruhPohybu = 4
IF @TypVydejky = 'toSchenker'
BEGIN
  SET @RadaDokladu = '372'
  SET @IDSklad = '00100304'
  SET @DruhPohybuPrevodu = 0
  SET @RadaDokladuPrevodu = '351'
  SET @IDSkladPrevodu = '00100303'
END
ELSE IF @TypVydejky = 'toLoukov'
BEGIN
  SET @RadaDokladu = '384'
  SET @IDSklad = '00100304'
  SET @DruhPohybuPrevodu = 0
  SET @RadaDokladuPrevodu = '351'
  SET @IDSkladPrevodu = '00100308'
END
ELSE IF @TypVydejky = 'fromLoukov'
BEGIN
  SET @RadaDokladu = '381'
  SET @IDSklad = '00100308'
  SET @DruhPohybuPrevodu = 0
  SET @RadaDokladuPrevodu = '351'
  SET @IDSkladPrevodu = '00100304'
END
ELSE
BEGIN
  IF @TypVydejky = 'def'
  BEGIN
    SET @RadaDokladu = '615'
  END
END
SET @CisloOrg = 0

-- založit prázdnou výdejku
EXEC hp_InsertHlavickyOZ
  @IDent = @IDDoklad OUTPUT,
  @Sklad = @IDSklad,
  @DruhPohybu = @DruhPohybu,
  @RadaDokladu = @RadaDokladu,
  @CisloOrg = @CisloOrg

IF @IDDoklad IS NOT NULL
BEGIN
-- doplnit převodku
  IF @DruhPohybuPrevodu IS NOT NULL
    UPDATE TabDokladyZbozi
    SET
      DruhPohybuPrevod = @DruhPohybuPrevodu,
      TypPrevodky = @RadaDokladuPrevodu,
      IdSkladPrevodu = @IDSkladPrevodu
    WHERE ID = @IDDoklad

-- externí údaje - odkaz na operaci
  IF EXISTS(SELECT ID FROM TabDokladyZbozi_EXT WHERE ID = @IDDoklad)
  BEGIN
    UPDATE TabDokladyZbozi_EXT SET _skl_token = @Token WHERE ID = @IDDoklad
  END
  ELSE
  BEGIN
    INSERT INTO TabDokladyZbozi_EXT (ID, _skl_token) VALUES (@IDDoklad, @Token)
  END
END
CHYBA:
GO
