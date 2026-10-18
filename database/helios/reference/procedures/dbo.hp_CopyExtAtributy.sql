-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_CopyExtAtributy]
@IDSrc    INT,
@IDDst    INT,
@SrcTab   NVARCHAR(100),
@DstTab   NVARCHAR(100) = NULL,  -- NULL = shodna tabulka jako Src
@AllAtr   BIT = 0,               -- kopiruj vsechny vcetne TabUzivAtr.Kopirovat = 0
@Selectem BIT = 0,               -- nekopiruj ale vrat Selectem
@UpdateKdyzNull BIT = 0          -- updatovat jenom kdyz dst.field je nullovy nebo '' 
AS
SET NOCOUNT ON
DECLARE @AtribSet NVARCHAR(MAX)  -- seznam atributu pro klauzuli SET prikazu UPDATE
DECLARE @AtribBez NVARCHAR(MAX)  -- seznam atributu bez prefixu
DECLARE @AtribNullCheck NVARCHAR(MAX) -- seznam atributu s ISNULL(dst.field, src.field)
DECLARE @SufixExt NVARCHAR(10)   -- koncovka nazvu tabulky externich atributu
DECLARE @ExecStr  NVARCHAR(MAX)  -- text pro UPDATE skript
DECLARE @StdCopy  BIT            -- provest kopii dle standardni metodiky
SET @AtribSet = ''
SET @AtribBez = ''
SET @AtribNullCheck = ''
SET @SufixExt = N'_Ext'
SET @StdCopy  = 1
IF @DstTab IS NULL
SET @DstTab = @SrcTab
IF @IDSrc IS NULL GOTO Konec
IF @IDDst IS NULL AND @Selectem = 0 GOTO Konec
IF OBJECT_ID(@SrcTab) IS NULL GOTO Konec
IF OBJECT_ID(@DstTab) IS NULL GOTO Konec
IF OBJECT_ID(@SrcTab + @SufixExt) IS NULL GOTO Konec
IF OBJECT_ID(@DstTab + @SufixExt) IS NULL GOTO Konec
IF OBJECT_ID(N'dbo.ep_CopyExtAtributy','P')IS NOT NULL
BEGIN
EXEC hp_loguj 'start','User_Ep_procedure','' ,1,0,'ep_CopyExtAtributy - start - Jádro - externí atributy',1
EXEC dbo.ep_CopyExtAtributy
@StdCopy OUT, @IDSrc, @IDDst, @SrcTab, @DstTab, @Selectem
EXEC hp_loguj 'stop'  ,'User_Ep_procedure','',1,0,'ep_CopyExtAtributy - stop',1
END
IF @StdCopy = 0 GOTO Konec
SELECT
@AtribNullCheck = @AtribNullCheck + ', ' + SRC.NazevAtrSys + '' +
CASE
WHEN SRC.TypAtr IN ('nvarchar', 'varchar', 'nchar', 'char', 'text', 'ntext')
THEN ' = ISNULL(NULLIF(DST.' + SRC.NazevAtrSys + ', ''''), SRC.' + SRC.NazevAtrSys + ')'
ELSE ' = ISNULL(DST.' + SRC.NazevAtrSys + ', SRC.' + SRC.NazevAtrSys + ')'
END,
@AtribSet = @AtribSet + N', ' + SRC.NazevAtrSys + N' = SRC.' + SRC.NazevAtrSys,
@AtribBez = @AtribBez + N', ' + SRC.NazevAtrSys
FROM TabUzivAtr     AS SRC
JOIN TabUzivAtr     AS DST ON DST.NazevAtrSys = SRC.NazevAtrSys
JOIN dbo.syscolumns AS SCS ON SCS.ID = OBJECT_ID(@SrcTab + @SufixExt)
JOIN dbo.syscolumns AS SCD ON SCD.ID = OBJECT_ID(@DstTab + @SufixExt)
WHERE SRC.NazevTabulkySys = @SrcTab
AND   DST.NazevTabulkySys = @DstTab
AND   SRC.Externi     = 1
AND   DST.Externi     = 1
AND  (SRC.Kopirovat   = 1 OR @AllAtr = 1)
AND   SCS.IsComputed  = 0
AND   SCD.IsComputed  = 0
AND   SCS.XType       = SCD.XType
AND   SCS.IsNullable <= SCD.IsNullable
AND   SCS.Name        = SRC.NazevAtrSys
AND   SCD.Name        = DST.NazevAtrSys
Konec:
IF @AtribSet = ''
SET @AtribSet = NULL ELSE
SET @AtribSet = SUBSTRING(@AtribSet, 3, LEN(@AtribSet) - 2)
IF @AtribBez = ''
SET @AtribBez = NULL ELSE
SET @AtribBez = SUBSTRING(@AtribBez, 3, LEN(@AtribBez) - 2)
IF @AtribNullCheck = ''
SET @AtribNullCheck = NULL ELSE
SET @AtribNullCheck = SUBSTRING(@AtribNullCheck, 3, LEN(@AtribNullCheck) - 2)
IF @Selectem = 0
BEGIN
IF @AtribSet IS NOT NULL AND
@AtribBez IS NOT NULL AND
@AtribNullCheck IS NOT NULL
BEGIN
SET @ExecStr=
N'IF NOT EXISTS(SELECT * FROM ' + @DstTab + @SufixExt +
N' WHERE ID = ' + CAST(@IDDst AS NVARCHAR(20)) + N')' +
N' INSERT ' + @DstTab + @SufixExt +
N' (ID, ' + @AtribBez + N')' +
N' SELECT ' + CAST(@IDDst AS NVARCHAR(20)) + N', ' + @AtribBez +
N' FROM '+ @SrcTab + @SufixExt +
N' WHERE ID = '+ CAST(@IDSrc AS NVARCHAR(20)) +
N' ELSE'+
N' UPDATE DST SET ' + CASE WHEN @UpdateKdyzNull = 1 THEN @AtribNullCheck ELSE @AtribSet END +
N' FROM ' + @DstTab + @SufixExt + N' AS DST'+
N' JOIN ' + @SrcTab + @SufixExt + N' AS SRC'+
N' ON  SRC.ID = ' + CAST(@IDSrc AS NVARCHAR(20))+
N' WHERE DST.ID = ' + CAST(@IDDst AS NVARCHAR(20))
EXEC(@ExecStr)
END
END ELSE
BEGIN
IF @AtribBez IS NOT NULL
SET @ExecStr =
N' SELECT ' + @AtribBez +
N' FROM '+ @SrcTab + @SufixExt +
N' WHERE ID = '+ CAST(@IDSrc AS NVARCHAR(20))
ELSE
SET @ExecStr =
N' SELECT NULL WHERE 1=0'
EXEC(@ExecStr)
END
GO
