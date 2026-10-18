-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[hp_DotahniPopisy]
@CisloOrg INT,
@IDZboSklad INT,
@Nazev1 NVARCHAR(100)OUT,
@Nazev2 NVARCHAR(100)OUT,
@Nazev3 NVARCHAR(100)OUT,
@Selectem BIT=1
AS
DECLARE @Konfig INT
SELECT @Nazev1=TabSozNa.Nazev1,
@Nazev2=TabSozNa.Nazev2,
@Nazev3=TabSozNa.Nazev3
FROM TabSozNa
JOIN TabCisOrg ON TabCisOrg.IDSOZnazev=TabSozNa.IDSoz
JOIN TabStavSkladu ON TabStavSkladu.IDKmenZbozi=TabSozNa.IDKmenZbo
WHERE TabStavSkladu.ID=@IDZboSklad
AND TabCisOrg.CisloOrg=@CisloOrg
IF @@ROWCOUNT = 0
BEGIN
SELECT TOP 1 @Konfig=NenalezenoSozNa FROM TabHGlob
IF @Konfig = 1
BEGIN
SELECT @Nazev1 = TabKmenZbozi.Nazev1,
@Nazev2 = TabKmenZbozi.Nazev2,
@Nazev3 = TabKmenZbozi.Nazev3
FROM TabKmenZbozi
JOIN TabStavSkladu ON TabStavSkladu.IDKmenZbozi=TabKmenZbozi.ID
WHERE TabStavSkladu.ID=@IDZboSklad
END ELSE BEGIN
IF @Konfig = 2
SELECT @Nazev1 = TabKmenZbozi.RegCis
FROM TabKmenZbozi
JOIN TabStavSkladu ON TabStavSkladu.IDKmenZbozi=TabKmenZbozi.ID
WHERE TabStavSkladu.ID=@IDZboSklad
END
END
IF @Selectem = 1
SELECT @Nazev1 AS Popis1,
@Nazev2 AS Popis2,
@Nazev3 AS Popis3
GO
