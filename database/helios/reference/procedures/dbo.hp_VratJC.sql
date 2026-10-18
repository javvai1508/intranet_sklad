-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[hp_VratJC]
@VstupniCena INT OUTPUT
AS
IF @VstupniCena=2 SET @VstupniCena=0
ELSE
IF @VstupniCena=3 SET @VstupniCena=1
ELSE
IF @VstupniCena=6 SET @VstupniCena=4
ELSE
IF @VstupniCena=7 SET @VstupniCena=5
ELSE
IF @VstupniCena=9 SET @VstupniCena=8
ELSE
IF @VstupniCena=11 SET @VstupniCena=10
GO
