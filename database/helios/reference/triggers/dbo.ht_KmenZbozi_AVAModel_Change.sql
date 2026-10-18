-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_KmenZbozi_AVAModel_Change] ON [dbo].[TabKmenZbozi] FOR INSERT, UPDATE, DELETE AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
DECLARE @StockMasterDataCard NVARCHAR(255)
DECLARE @SerialNumber NVARCHAR(255)
DECLARE @ExciseTaxCode NVARCHAR(255)
DECLARE @RecyclingFee NVARCHAR(255)
DECLARE @PriceListHeader NVARCHAR(MAX)
DECLARE @PriceListItem NVARCHAR(MAX)
SET @StockMasterDataCard = N'd1a4b801-374a-4064-a347-d8ec7455cabe'
SET @SerialNumber = N'f25ac619-893a-423d-a1c7-623a7e678c96'
SET @ExciseTaxCode = N'339f3d3c-541c-4a2c-bb2a-b0f3f58cfcb4'
SET @RecyclingFee = N'6d2ea065-6c17-4eda-997b-7d9137f0bce2'
SET @PriceListHeader = N'0dfb66bd-8c32-4629-ae35-61ebd85db527'
SET @PriceListItem = N'80df5d41-6f57-46e4-b820-b14fe4c9a69a'
DECLARE @Ins INT, @Del INT, @ActionType NCHAR(1)
SELECT @Ins = COUNT(1) FROM INSERTED
SELECT @Del = COUNT(1) FROM DELETED
IF @Ins > 0 AND @Del = 0 SET @ActionType = N'I'
IF @Ins = 0 AND @Del > 0 SET @ActionType = N'D'
IF @Ins > 0 AND @Del > 0 SET @ActionType = N'U'

IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @StockMasterDataCard AND DataDirection IN(0,2))
BEGIN
  -- DELETE
  IF @Ins = 0 AND @Del > 0
    BEGIN
      INSERT TabAVAModelDataChanges(
        RegistrationID, ActionType, ModelID, AVAReferenceID)
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @StockMasterDataCard AND m.DataDirection IN(0,2)
      -- pokud to neni pouze porizeno, tak smazani posleme vzdy
      AND d.AVAOutputFlag > 0
      UNION
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @ExciseTaxCode AND m.DataDirection IN(0,2)
      -- pokud to neni pouze porizeno, tak smazani posleme vzdy
      AND d.AVAOutputFlag > 0
      UNION
      SELECT m.RegistrationID, @ActionType, m.ModelID, d.AVAReferenceID
      FROM TabAVARegisteredModels m, DELETED d
      WHERE m.ModelID = @RecyclingFee AND m.DataDirection IN(0,2)
      -- pokud to neni pouze porizeno, tak smazani posleme vzdy
      AND d.AVAOutputFlag > 0
    END
  ELSE
    IF NOT UPDATE(VCSarze)
       AND NOT UPDATE(KodSD)
       AND NOT UPDATE(MJSD)
       AND NOT UPDATE(PrepocetMJSD)
       AND NOT UPDATE(SazbaSDVystup)
    BEGIN
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
          WHERE m.ModelID = @ExciseTaxCode AND m.DataDirection IN(0,2)
          AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
          UNION
          SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
          FROM TabAVARegisteredModels m, INSERTED i
          LEFT JOIN DELETED d ON i.ID = d.ID
          WHERE m.ModelID = @StockMasterDataCard AND m.DataDirection IN(0,2)
          AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
          UNION
          SELECT m.RegistrationID, @ActionType, m.ModelID, vck.AVAReferenceID
          FROM TabAVARegisteredModels m, INSERTED i
          LEFT JOIN DELETED d ON i.ID = d.ID
          JOIN TabVyrCK vck ON i.ID = vck.IDKmenZbozi
          WHERE m.ModelID = @SerialNumber AND m.DataDirection IN(0,2)
          AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
          UNION
          SELECT m.RegistrationID, @ActionType, m.ModelID, i.AVAReferenceID
          FROM TabAVARegisteredModels m, INSERTED i
          LEFT JOIN DELETED d ON i.ID = d.ID
          JOIN TabKmenZboziDodatek kzd ON i.ID = kzd.ID
          WHERE m.ModelID = @RecyclingFee AND m.DataDirection IN(0,2)
          AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) <> 1
          UNION
          SELECT m.RegistrationID, @ActionType, m.ModelID, nca.AVAReferenceID
          FROM TabAVARegisteredModels m, INSERTED i
          LEFT JOIN DELETED d ON i.ID = d.ID
          JOIN TabNCAVA nca ON d.ID = nca.IDKmenZbozi
          WHERE m.ModelID = @PriceListItem AND m.DataDirection IN(0,2)
          AND i.AVAOutputFlag = 1 AND ISNULL(d.AVAOutputFlag,0) NOT IN (0,1)
        END

        /* pouze po zmene stavu Porizeno na Odeslat provadime aktualizace Sazeb a Men
           nutne pro VATMasterCardType(TabSazbyDPHZboAVA)
           a PriceListHeader/Item(TabCisNCAVA, TabNCAVA) */
        IF EXISTS(SELECT * FROM DELETED WHERE ISNULL(AVAOutputFlag,0) = 0)
        BEGIN
          IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListHeader AND DataDirection IN(0,2)) AND
             EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @PriceListItem AND DataDirection IN(0,2))
          BEGIN
            DECLARE @CU INT

            DECLARE CurMeny CURSOR FAST_FORWARD LOCAL FOR
               SELECT nc.CenovaUroven
               FROM TabNC nc JOIN INSERTED i ON i.ID = nc.IDKmenZbozi
               WHERE nc.IDZboSklad IS NULL
            OPEN CurMeny
            WHILE 1=1
              BEGIN
                FETCH NEXT FROM CurMeny INTO @CU
                IF @@FETCH_STATUS <> 0 BREAK

                EXEC hp_AktualizujMenyCisNCAVA @CU
              END
            CLOSE CurMeny
            DEALLOCATE CurMeny
          END

          DECLARE @DruhSazbyDPH TINYINT
          DECLARE @ISOKodZeme NVARCHAR(MAX)
          DECLARE @IDSazbyDPHZbo INT
          DECLARE @IDKmenZbozi INT

          DECLARE CurSazby CURSOR FAST_FORWARD LOCAL FOR
            SELECT sdz.DruhSazbyDPH, sdz.ISOKodZeme, sdz.ID, i.ID
            FROM INSERTED i JOIN TabSazbyDPHZbo sdz ON sdz.IDKmenZbozi = i.ID
          OPEN CurSazby
            WHILE 1=1
            BEGIN
              FETCH NEXT FROM CurSazby INTO @DruhSazbyDPH, @ISOKodZeme, @IDSazbyDPHZbo, @IDKmenZbozi
              IF @@FETCH_STATUS <> 0 BREAK;

              EXEC hp_AktualizujSazbyDPHZboAVA @DruhSazbyDPH, @ISOKodZeme, @IDSazbyDPHZbo, @IDKmenZbozi
            END
          CLOSE CurSazby
          DEALLOCATE CurSazby
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
            (SELECT ID, AVAReferenceID, Blokovano, IdSortiment, Hloubka,
               SkupZbo, Vyska, Nazev1, Vyrobce, MJEvidence, RegCis, DruhSkladu,
               Objem, Hmotnost, Sirka, Poznamka, CLOPopisZbozi, CelniNomenklatura,
               SZ, DopKod, CNSPD, CNKod1, CNKod2, KodSD, MJSD, SazbaSDVystup, PrepocetMJSD,
               DodaciLhuta, TypDodaciLhuty, Minimum_Dodavatel, MJVstup, MJVystup, MJPocetVstup,
               MJPocetEvidVstup, ZarukaVstup, Aktualni_Dodavatel, TypZarukaVstup,
               ZarukaVystup, TypZarukaVystup
             FROM INSERTED
             EXCEPT
             SELECT ID, AVAReferenceID, Blokovano, IdSortiment, Hloubka,
               SkupZbo, Vyska, Nazev1, Vyrobce, MJEvidence, RegCis, DruhSkladu,
               Objem, Hmotnost, Sirka, Poznamka, CLOPopisZbozi, CelniNomenklatura,
               SZ, DopKod, CNSPD, CNKod1, CNKod2, KodSD, MJSD, SazbaSDVystup, PrepocetMJSD,
               DodaciLhuta, TypDodaciLhuty, Minimum_Dodavatel, MJVstup, MJVystup, MJPocetVstup,
               MJPocetEvidVstup, ZarukaVstup, Aktualni_Dodavatel, TypZarukaVstup,
               ZarukaVystup, TypZarukaVystup
             FROM DELETED) X
          JOIN INSERTED i ON i.ID = X.ID
          WHERE m.ModelID = @StockMasterDataCard AND m.DataDirection IN(0,2) AND i.AVAOutputFlag IN(1,3,4)
        END
      END
    END
END

IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @SerialNumber AND DataDirection IN(0,2))
BEGIN
  IF UPDATE(VCSarze)
  BEGIN
      -- INSERT + UPDATE
    IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4))
    BEGIN
      -- byl jiz nastaven priznak 'odeslat na AVA' a nastala dalsi zmena
      IF EXISTS(SELECT*FROM INSERTED i JOIN DELETED d ON i.ID = d.ID
                WHERE i.AVAOutputFlag = 1 AND d.AVAOutputFlag = 1)
      -- nebo jiz bylo odeslano na AVA, tak posleme pouze zmeny
      OR EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(3,4))
      BEGIN
        INSERT TabAVAModelDataChanges(
          RegistrationID, ActionType, ModelID, AVAReferenceID)
        SELECT m.RegistrationID, @ActionType, m.ModelID, vck.AVAReferenceID
        FROM TabAVARegisteredModels m,
          (SELECT ID, AVAReferenceID, VCSarze
           FROM INSERTED
           EXCEPT
           SELECT ID, AVAReferenceID, VCSarze
           FROM DELETED) X
        JOIN INSERTED i ON i.ID = X.ID
        JOIN TabVyrCK vck ON i.ID = vck.IDKmenZbozi
        WHERE m.ModelID = @SerialNumber AND m.DataDirection IN(0,2) AND i.AVAOutputFlag IN(1,3,4)
      END
    END
  END
END

IF EXISTS(SELECT*FROM TabAVARegisteredModels WHERE ModelID = @ExciseTaxCode AND DataDirection IN(0,2))
BEGIN
  IF UPDATE(KodSD) OR UPDATE(MJSD) OR UPDATE(PrepocetMJSD) OR UPDATE(SazbaSDVystup)
  BEGIN
      -- INSERT + UPDATE
    IF EXISTS(SELECT*FROM INSERTED WHERE AVAOutputFlag IN(1,3,4))
    BEGIN
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
          (SELECT ID, AVAReferenceID, KodSD, MJSD, PrepocetMJSD, SazbaSDVystup
           FROM INSERTED
           EXCEPT
           SELECT ID, AVAReferenceID, KodSD, MJSD, PrepocetMJSD, SazbaSDVystup
           FROM DELETED) X
        JOIN INSERTED i ON i.ID = X.ID
        WHERE m.ModelID = @ExciseTaxCode AND m.DataDirection IN(0,2) AND i.AVAOutputFlag IN(1,3,4)
      END
    END
  END
END
GO
