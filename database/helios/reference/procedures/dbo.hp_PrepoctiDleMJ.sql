-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[hp_PrepoctiDleMJ]
@MJ1         NVARCHAR(10),      -- puvodni MJ
@MJ2         NVARCHAR(10),      -- pozadovana MJ
@Pocet       NUMERIC(19,6) OUT, -- hodnota, kterou chceme prepocitat
@Returnem    BIT = 0,           -- 0=vraci select / 1=nevraci select
@ProMnozstvi BIT = 1,           -- 1=hodnotou je mnozstvi; 0=hodnotou je JC
@IDKmenZbozi INT = NULL,        -- ID kmenove karty
@Vstup       BIT = 0
AS
SET NOCOUNT ON
DECLARE @Citatel    NUMERIC(19,6)
DECLARE @Jmenovatel NUMERIC(19,6)
DECLARE @Opacne     BIT
DECLARE @Pom        NUMERIC(19,6)
DECLARE @Vysledek   NUMERIC(19,6)
EXEC dbo.hp_ZjistiVztahMJ
@MJ1, @MJ2, NULL, NULL, @IDKmenZbozi, @Vstup, @Citatel OUT, @Jmenovatel OUT
IF @Citatel IS NULL
SET @Pocet = NULL
ELSE
IF @Citatel <> @Jmenovatel
BEGIN
IF (@Citatel > @Jmenovatel) AND (@Citatel <> 1)
SET @Opacne = 0
ELSE
BEGIN
SET @Pom = @Citatel
SET @Citatel = @Jmenovatel
SET @Jmenovatel = @Pom
SET @Opacne = 1
END
IF (@Opacne = 0 AND @ProMnozstvi = 1) OR (@Opacne = 1 AND @ProMnozstvi = 0)
BEGIN
SET @Vysledek = @Pocet * @Jmenovatel
SET @Pocet = @Vysledek / @Citatel
END
ELSE
BEGIN
SET @Vysledek = @Pocet * @Citatel
SET @Pocet = @Vysledek / @Jmenovatel
END
END
IF @Returnem = 0
SELECT @Pocet
GO
