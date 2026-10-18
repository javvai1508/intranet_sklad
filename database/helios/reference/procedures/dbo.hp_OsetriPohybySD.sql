-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_OsetriPohybySD]
@IDPohyb        INT,
@VstupKmenPohyb INT,
@DelatUpdateMJ  INT,
@MJNaPolozce    NVARCHAR(10),
@IDZboSklad     INT           = NULL,
@VratRecykl     BIT           = 0,
@ZemeDPH        NVARCHAR(3)   = NULL,
@KurzDPHHM      NUMERIC(19,6) = NULL,
@MnoKurzDPHHM   INT           = NULL
AS
SET NOCOUNT ON
DECLARE @MJEvid      NVARCHAR(10)
DECLARE @MJRecyk     NVARCHAR(10)
DECLARE @CastkaHist  NUMERIC(19,6)
DECLARE @CastkaGar   NUMERIC(19,6)
DECLARE @CastkaHistVal  NUMERIC(19,6)
DECLARE @CastkaGarVal   NUMERIC(19,6)
DECLARE @ZpusobKurzu TINYINT
DECLARE @Returnem    BIT
DECLARE @IDKmenZbozi INT
DECLARE @Vstup       BIT
DECLARE @ProMnozstvi NUMERIC(19,6)
DECLARE @PrepMJRecyk NUMERIC(19,6)
IF @IDZboSklad   IS NULL OR
@KurzDPHHM    IS NULL OR
@ZemeDPH      IS NULL OR
@MnoKurzDPHHM IS NULL
SELECT
@IDZboSklad   = ISNULL(@IDZboSklad,   P.IDZboSklad),
@KurzDPHHM    = ISNULL(@KurzDPHHM,    D.SamoVyKurzDPHHM),
@ZemeDPH      = ISNULL(@ZemeDPH,      D.ZemeDPH),
@MnoKurzDPHHM = ISNULL(@MnoKurzDPHHM, D.SamoVyMnoKurzDPHHM)
FROM TabDokladyZbozi AS D
JOIN TabPohybyZbozi  AS P ON P.IDDoklad = D.ID
WHERE P.ID = @IDPohyb
SELECT
@IDKmenZbozi = K.ID,
@MJEvid      = K.MJEvidence
FROM TabKmenZbozi   AS K
JOIN TabStavSkladu  AS S ON S.IDKmenZbozi = K.ID
WHERE S.ID = @IDZboSklad
SELECT @ZpusobKurzu = ZpusobKurzu FROM TabKodMen WHERE HlavniMena = 1
IF OBJECT_ID(N'dbo.ep_PohybyZboziSDCastkyZaRecyklaci','P')IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_PohybyZboziSDCastkyZaRecyklaci - start - OZ - zjisti recyklační příspěvek dle země DPH',1
EXEC dbo.ep_PohybyZboziSDCastkyZaRecyklaci
@IDKmenZbozi, @ZemeDPH, @KurzDPHHM, @MnoKurzDPHHM, @CastkaHist OUT, @CastkaGar OUT
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_PohybyZboziSDCastkyZaRecyklaci - stop',1
END
IF OBJECT_ID(N'dbo.ep_PohybyZboziSDCastkyZaRecyklaciVal','P')IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_PohybyZboziSDCastkyZaRecyklaciVal - start - OZ - zjisti recyklační příspěvek dle země DPH',1
EXEC dbo.ep_PohybyZboziSDCastkyZaRecyklaciVal
@IDKmenZbozi, @ZemeDPH, @CastkaHistVal OUT, @CastkaGarVal OUT
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_PohybyZboziSDCastkyZaRecyklaciVal - stop',1
END
SELECT
@CastkaHist   = ISNULL(@CastkaHist,ISNULL(CastkaHistRecyk, 0)),
@CastkaGar    = ISNULL(@CastkaGar, ISNULL(CastkaGarRecyk,  0)),
@MJRecyk     = MJRecyk,
@PrepMJRecyk = ISNULL(PrepMJRecyk,0)
FROM TabKmenZboziDodatek
WHERE ID = @IDKmenZbozi
SET @CastkaHist  = ISNULL(@CastkaHist,  0)
SET @CastkaGar   = ISNULL(@CastkaGar,   0)
SET @PrepMJRecyk = ISNULL(@PrepMJRecyk, 1)
IF @MJEvid <> '' AND @MJNaPolozce <> ''
BEGIN
EXEC dbo.hp_PrepoctiDleMJ
@MJEvid, @MJNaPolozce, @CastkaHist OUT, @Returnem, @ProMnozstvi, @IDKmenZbozi, @Vstup
EXEC dbo.hp_PrepoctiDleMJ
@MJEvid, @MJNaPolozce, @CastkaGar  OUT, @Returnem, @ProMnozstvi, @IDKmenZbozi, @Vstup
END
IF @VratRecykl = 1
SELECT (@CastkaHist * @PrepMJRecyk) + (@CastkaGar * @PrepMJRecyk)
ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM TabPohybyZboziSD WHERE ID = @IDPohyb)
BEGIN
SET @ProMnozstvi = 0
INSERT INTO TabPohybyZboziSD(
ID, MJRecyk, CastkaHistRec, CastkaGarRec, CastkaHistRecVal, CastkaGarRecVal, PrepMJRecyk, KodSD, PrepocetMJSD, MJSD)
SELECT @IDPohyb, @MJRecyk,
@CastkaHist * @PrepMJRecyk,
@CastkaGar  * @PrepMJRecyk,
@CastkaHistVal * @PrepMJRecyk,
@CastkaGarVal  * @PrepMJRecyk,
@PrepMJRecyk, K.KodSD, K.PrepocetMJSD, K.MJSD
FROM TabStavSkladu  AS S
JOIN TabKmenZbozi   AS K ON K.ID = S.IDKmenZbozi
JOIN TabPohybyZbozi AS P ON P.IDZboSklad = S.ID
WHERE P.ID = @IDPohyb
END
ELSE
IF (@DelatUpdateMJ = 1) AND ((@CastkaHist + @CastkaGar <> 0) OR (ISNULL(@CastkaHistVal,0) + ISNULL(@CastkaGarVal,0) <> 0))
BEGIN
IF @MJEvid<>'' AND @MJNaPolozce<>''
BEGIN
IF @VstupKmenPohyb = 0
UPDATE SD SET
MJRecyk       = @MJRecyk,
PrepMJRecyk   = @PrepMJRecyk,
CastkaHistRec = @CastkaHist * @PrepMJRecyk,
CastkaGarRec  = @CastkaGar  * @PrepMJRecyk,
CastkaHistRecVal = @CastkaHistVal * @PrepMJRecyk,
CastkaGarRecVal  = @CastkaGarVal  * @PrepMJRecyk
FROM TabPohybyZboziSD AS SD
JOIN TabPohybyZbozi   AS P ON P.ID = SD.ID
JOIN TabStavSkladu    AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi     AS K ON K.ID = S.IDKmenZbozi
WHERE SD.ID = @IDPohyb
ELSE
UPDATE SD SET
MJRecyk       = @MJRecyk,
CastkaHistRec = @CastkaHist * ISNULL(SD.PrepMJRecyk,0),
CastkaGarRec  = @CastkaGar  * ISNULL(SD.PrepMJRecyk,0),
CastkaHistRecVal = @CastkaHistVal * ISNULL(SD.PrepMJRecyk,0),
CastkaGarRecVal  = @CastkaGarVal  * ISNULL(SD.PrepMJRecyk,0)
FROM TabPohybyZboziSD AS SD
JOIN TabPohybyZbozi   AS P ON P.ID = SD.ID
JOIN TabStavSkladu    AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi     AS K ON K.ID = S.IDKmenZbozi
WHERE SD.ID = @IDPohyb
END
ELSE
BEGIN
IF @VstupKmenPohyb = 0
UPDATE SD SET
MJRecyk       = @MJRecyk,
PrepMJRecyk   = @PrepMJRecyk,
CastkaHistRec = @CastkaHist,
CastkaGarRec  = @CastkaGar,
CastkaHistRecVal = @CastkaHistVal,
CastkaGarRecVal  = @CastkaGarVal
FROM TabPohybyZboziSD AS SD
JOIN TabPohybyZbozi   AS P ON P.ID = SD.ID
JOIN TabStavSkladu    AS S ON S.ID = P.IDZboSklad
JOIN TabKmenZbozi     AS K ON K.ID = S.IDKmenZbozi
WHERE SD.ID = @IDPohyb
END
END
END
GO
