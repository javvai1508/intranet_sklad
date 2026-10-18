-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[hp_ZjistiVztahMJ]
@MJ1 NVARCHAR(10),
@MJ2 NVARCHAR(10),
@Vztah NUMERIC(19,6) OUT,
@Opacne BIT OUT, -- platne pouze pro hodnotu @Vztah !!!
@IDKmenZbozi INT = NULL,
@Vstup BIT = 0,
@Citatel    NUMERIC(19,6) = NULL OUT, -- vztah jako presny zlomek, nezavisi na @Opacne
@Jmenovatel NUMERIC(19,6) = NULL OUT  -- vztah jako presny zlomek, nezavisi na @Opacne
AS
SET NOCOUNT ON
DECLARE @Pom NUMERIC(19,6)
SET @Citatel    = NULL
SET @Jmenovatel = NULL
IF @IDKmenZbozi IS NOT NULL
EXEC dbo.hp_NajdiVztahMJ_Zbozi
@MJ1, @MJ2, @IDKmenZbozi, @Vstup, NULL, @Citatel OUT, @Jmenovatel OUT
IF @Citatel IS NULL
EXEC dbo.hp_NajdiVztahMJ @MJ1, @MJ2, NULL, 1, @Citatel OUT, @Jmenovatel OUT
SET @Opacne = 0
IF @Citatel IS NULL
SET @Vztah = NULL
ELSE
BEGIN
IF @Citatel >= @Jmenovatel
SET @Vztah = @Citatel / @Jmenovatel
ELSE
BEGIN
SET @Vztah = @Jmenovatel / @Citatel
SET @Pom = @Vztah * @Citatel
IF @Pom = @Jmenovatel
SET @Opacne = 1
ELSE
SET @Vztah = @Citatel / @Jmenovatel
END
END
GO
