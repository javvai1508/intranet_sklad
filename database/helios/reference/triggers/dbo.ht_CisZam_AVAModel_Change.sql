-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_CisZam_AVAModel_Change] ON [dbo].[TabCisZam] FOR INSERT, UPDATE, DELETE AS

IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON

DECLARE @ModelId1 NVARCHAR(255) = N'f2511f7d-1a54-4a39-8e34-625c51397bbd'
DECLARE @ModelIdPerson NVARCHAR(255) = N'298d4779-93a0-4903-ac63-29cb15f9e8ce'
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)

SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
IF @Ins > 0 AND @Del = 0 SET @ActionType = N'I'
IF @Ins = 0 AND @Del > 0 SET @ActionType = N'D'
IF @Ins > 0 AND @Del > 0 SET @ActionType = N'U'

-- C_ModelGUID_AVAEmployeeDetail
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelId1 AND DataDirection IN(0,2))
BEGIN
  -- DELETE
  IF @Ins = 0 AND @Del > 0
    BEGIN
      INSERT TabAVAModelDataChanges(
        RegistrationID, ActionType, ModelID, AVAReferenceID)
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @ModelId1 AND m.DataDirection IN(0,2)
      -- pokud to neni pouze porizeno, tak smazani posleme vzdy
      AND d.AVAOutputFlag > 0
    END
  ELSE
    -- INSERT + UPDATE
    IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4))
    BEGIN
      -- pokud se zmenil stav na 'odeslat na AVA', tak posleme vzdy
      IF EXISTS(SELECT*FROM INSERTED i LEFT JOIN DELETED d ON i.ID = d.ID
                WHERE i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1)
      BEGIN
        INSERT TabAVAModelDataChanges(
          RegistrationID, ActionType, ModelID, AVAReferenceID)
        SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
        FROM TabAVARegisteredModels m, INSERTED i
        LEFT JOIN DELETED d ON i.ID = d.ID
        WHERE m.ModelID = @ModelId1 AND m.DataDirection IN(0,2)
        AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
      END

      -- byl jiz nastaven priznak 'odeslat na AVA' a nastala dalsi zmena
      IF EXISTS(SELECT*FROM INSERTED i JOIN DELETED d ON i.ID = d.ID
                WHERE i.AVAOutputFlag = 1 AND d.AVAOutputFlag = 1)
      -- nebo jiz bylo odeslano na AVA, tak posleme pouze zmeny
      OR EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(3,4))
      BEGIN
        INSERT TabAVAModelDataChanges(
          RegistrationID, ActionType, ModelID, AVAReferenceID)
        SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
        FROM TabAVARegisteredModels m,
          (SELECT ID, AVAReferenceID, StatniPrislus, DatumNarozeni, Cislo, Jmeno, PasVydal, CisloPasu, RodneCislo,
                Obrazek, MistoNarozeni, Prijmeni, TitulZa, TitulPred, RodinnyStav, Pohlavi, Narodnost, RodnePrijmeni,
                AdrTrvUlice, AdrTrvOrCislo, AdrTrvPopCislo, AdrTrvMisto, AdrTrvPSC, AdrTrvZeme,
                AdrPrechUlice, AdrPrechOrCislo, AdrPrechPopCislo, AdrPrechMisto, AdrPrechPSC, AdrPrechZeme
           FROM INSERTED
           EXCEPT
           SELECT ID, AVAReferenceID, StatniPrislus, DatumNarozeni, Cislo, Jmeno, PasVydal, CisloPasu, RodneCislo,
                Obrazek, MistoNarozeni, Prijmeni, TitulZa, TitulPred, RodinnyStav, Pohlavi, Narodnost, RodnePrijmeni,
                AdrTrvUlice, AdrTrvOrCislo, AdrTrvPopCislo, AdrTrvMisto, AdrTrvPSC, AdrTrvZeme,
                AdrPrechUlice, AdrPrechOrCislo, AdrPrechPopCislo, AdrPrechMisto, AdrPrechPSC, AdrPrechZeme
           FROM DELETED) X
        JOIN INSERTED i ON i.ID = X.ID
        WHERE m.ModelID = @ModelId1 AND m.DataDirection IN(0,2) AND i.AVAOutputFlag IN(1,3,4)
      END
    END
END

-- C_ModelGUID_AVAPerson
IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ModelIdPerson AND DataDirection IN(0,2))
BEGIN
  -- DELETE
  IF @Ins = 0 AND @Del > 0
    BEGIN
      INSERT TabAVAModelDataChanges(
        RegistrationID, ActionType, ModelID, AVAReferenceID)
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @ModelIdPerson AND m.DataDirection IN(0,2)
      -- pokud to neni pouze porizeno, tak smazani posleme vzdy
      AND d.AVAOutputFlag > 0
    END
  ELSE
    -- INSERT + UPDATE
    IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4))
    BEGIN
      -- pokud se zmenil stav na 'odeslat na AVA', tak posleme vzdy
      IF EXISTS(SELECT*FROM INSERTED i LEFT JOIN DELETED d ON i.ID = d.ID
                WHERE i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1)
      BEGIN
        INSERT TabAVAModelDataChanges(
          RegistrationID, ActionType, ModelID, AVAReferenceID)
        SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
        FROM TabAVARegisteredModels m, INSERTED i
        LEFT JOIN DELETED d ON i.ID = d.ID
        WHERE m.ModelID = @ModelIdPerson AND m.DataDirection IN(0,2)
        AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
      END

      -- byl jiz nastaven priznak 'odeslat na AVA' a nastala dalsi zmena
      IF EXISTS(SELECT*FROM INSERTED i JOIN DELETED d ON i.ID = d.ID
                WHERE i.AVAOutputFlag = 1 AND d.AVAOutputFlag = 1)
      -- nebo jiz bylo odeslano na AVA, tak posleme pouze zmeny
      OR EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(3,4))
      BEGIN
        INSERT TabAVAModelDataChanges(
          RegistrationID, ActionType, ModelID, AVAReferenceID)
        SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
        FROM TabAVARegisteredModels m,
          (SELECT ID, AVAReferenceID, RodneCislo, StatniPrislus, Jmeno, Prijmeni,
              TitulPred, TitulZa, DatumNarozeni, Pohlavi, Obrazek,
              AdrTrvUlice, AdrTrvOrCislo, AdrTrvPopCislo, AdrTrvMisto, AdrTrvPSC, AdrTrvZeme,
              AdrPrechUlice, AdrPrechOrCislo, AdrPrechPopCislo, AdrPrechMisto, AdrPrechPSC, AdrPrechZeme
           FROM INSERTED
           EXCEPT
           SELECT ID, AVAReferenceID, RodneCislo, StatniPrislus, Jmeno, Prijmeni,
              TitulPred, TitulZa, DatumNarozeni, Pohlavi, Obrazek,
              AdrTrvUlice, AdrTrvOrCislo, AdrTrvPopCislo, AdrTrvMisto, AdrTrvPSC, AdrTrvZeme,
              AdrPrechUlice, AdrPrechOrCislo, AdrPrechPopCislo, AdrPrechMisto, AdrPrechPSC, AdrPrechZeme
           FROM DELETED) X
        JOIN INSERTED i ON i.ID = X.ID
        WHERE m.ModelID = @ModelIdPerson AND m.DataDirection IN(0,2) AND i.AVAOutputFlag IN(1,3,4)
      END
    END
END
GO
