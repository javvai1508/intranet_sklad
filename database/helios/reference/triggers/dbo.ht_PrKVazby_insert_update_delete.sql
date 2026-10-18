-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_PrKVazby_insert_update_delete] ON [dbo].[TabPrKVazby] FOR INSERT,UPDATE,DELETE 
 AS 
  IF @@rowcount=0 RETURN 
  SET NOCOUNT ON 
  DECLARE @IsInsert bit, @IsDelete bit, @ErrID int, @errMsg nvarchar(500), @IDZajisteni int, @RecID int 
  IF EXISTS(SELECT * FROM INSERTED) SET @IsDelete=0 ELSE SET @IsDelete=1 
  IF EXISTS(SELECT * FROM DELETED) SET @IsInsert=0 ELSE SET @IsInsert=1 
  IF @IsInsert=1 AND @IsDelete=1  RETURN 
  SELECT @ErrID=NULL, @ErrMsg='' 
  IF @IsInsert=1 
    BEGIN 
      SELECT TOP 1 @ErrID=2001536, @errMsg=CAST(I.doklad AS nvarchar(20)) 
        FROM INSERTED I 
        WHERE I.ID1=0 AND I.prednastaveno=1 AND 
              EXISTS(SELECT * FROM TabPrKVazby PrKV WHERE PrKV.IDPrikaz=I.IDPrikaz AND PrKV.Doklad=I.Doklad AND PrKV.prednastaveno=1 AND PrKV.ID1<>0) 
      IF @ErrID IS NOT NULL GOTO CHYBA 
    END 
  IF @IsInsert=0 AND @IsDelete=0 AND (UPDATE(nizsi) OR UPDATE(Sklad)) 
    IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
      BEGIN 
        SELECT TOP 1 @ErrID=2004837, @ErrMsg=P.RadaPrikaz+NCHAR(13)+CAST(D.doklad AS nvarchar(20)) 
          FROM DELETED D 
            INNER JOIN INSERTED I ON (I.ID=D.ID) 
            INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=D.ID1) 
            INNER JOIN TabPrikaz P ON (P.ID=D.IDPrikaz) 
          WHERE ((D.nizsi<>I.Nizsi) OR (ISNULL(D.Sklad,'')<>ISNULL(I.Sklad,''))) AND D.IDOdchylkyDo IS NULL 
        IF @ErrID IS NOT NULL GOTO CHYBA 
      END 
  IF @IsDelete=1 
    IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
      IF EXISTS(SELECT * FROM DELETED D 
                           INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=D.ID1) 
                         WHERE NOT EXISTS(SELECT * FROM TabPrKVazby PrKV WHERE PrKV.ID1=D.ID1)) 
        BEGIN 
          DECLARE crSezPolZajisteni CURSOR FAST_FORWARD LOCAL FOR 
            SELECT DISTINCT Z.ID 
              FROM DELETED D 
                INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=D.ID1) 
              WHERE NOT EXISTS(SELECT * FROM TabPrKVazby PrKV WHERE PrKV.ID1=D.ID1) 
          OPEN crSezPolZajisteni 
          FETCH NEXT FROM crSezPolZajisteni INTO @IDZajisteni 
          WHILE @@fetch_status=0 
            BEGIN 
              EXEC hp_NZB_SmazZajisteni @IDZajisteni 
              IF @@error<>0  GOTO CHYBA 
              FETCH NEXT FROM crSezPolZajisteni INTO @IDZajisteni 
            END 
          CLOSE crSezPolZajisteni 
          DEALLOCATE crSezPolZajisteni 
        END 
  IF @IsInsert=0 AND @IsDelete=0 AND UPDATE(Uzavreno) 
    IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
      IF EXISTS(SELECT * FROM INSERTED I 
                           INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=I.ID1) 
                         WHERE I.Uzavreno=1 AND I.IDOdchylkyDo IS NULL) 
        BEGIN 
          DECLARE crSezPolZajisteni CURSOR FAST_FORWARD LOCAL FOR 
            SELECT DISTINCT Z.ID 
              FROM INSERTED I 
                INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=I.ID1) 
              WHERE I.Uzavreno=1 AND I.IDOdchylkyDo IS NULL 
          OPEN crSezPolZajisteni 
          FETCH NEXT FROM crSezPolZajisteni INTO @IDZajisteni 
          WHILE @@fetch_status=0 
            BEGIN 
              EXEC hp_NZB_SmazZajisteni @IDZajisteni 
              IF @@error<>0  GOTO CHYBA 
              FETCH NEXT FROM crSezPolZajisteni INTO @IDZajisteni 
            END 
          CLOSE crSezPolZajisteni 
          DEALLOCATE crSezPolZajisteni 
        END 
  IF UPDATE(Mnoz_nepotrebne) OR UPDATE(mnoz_zad) OR UPDATE(IDOdchylkyDo) 
    BEGIN 
      UPDATE PrKV SET Mnoz_nepotrebne=PrKV_P.Mnoz_nepotrebne * PrKV_L.Mnoz_Zad/PrKV_P.Mnoz_Zad 
        FROM TabPrKVazby PrKV 
          INNER JOIN TabPrKVazby PrKV_P ON (PrKV_P.IDPrikaz=PrKV.IDPrikaz AND PrKV_P.Doklad=PrKV.Doklad AND PrKV_P.prednastaveno=1 AND PrKV_P.IDOdchylkyDo IS NULL) 
          INNER JOIN TabPrKVazby PrKV_L ON (PrKV_L.IDPrikaz=PrKV.IDPrikaz AND PrKV_L.Doklad=PrKV.Doklad AND PrKV_L.Nizsi=PrKV.Nizsi AND PrKV_L.IDOdchylkyDo IS NULL) 
        WHERE PrKV.prednastaveno=0 AND 
              EXISTS(SELECT * FROM (SELECT IDPrikaz, Doklad FROM INSERTED 
                                     UNION 
                                    SELECT IDPrikaz, Doklad FROM DELETED) AS X 
                              WHERE X.IDPrikaz=PrKV.IDPrikaz AND X.Doklad=PrKV.Doklad) 
    END 
  IF UPDATE(prednastaveno) OR UPDATE(mnoz_zad) OR 
     UPDATE(Mnoz_skut_realizovane) OR UPDATE(mnoz_nepotrebne) OR 
     UPDATE(IDOdchylkyDo) 
    BEGIN 
      UPDATE TabPrKVazby SET RefMnoz=PrKV_P.mnoz_zad, 
                             VydanoRefMnoz=PrKV_P.mnoz_nepotrebne + 
                                           (SELECT ISNULL(SUM(PrKV2.Mnoz_skut_realizovane*PrKV_P2.mnoz_zad/PrKV2.mnoz_zad),0.0) 
                                              FROM TabPrKVazby PrKV2 
                                                INNER JOIN TabPrKVazby PrKV_P2 ON (PrKV_P2.ID=PrKV_P.ID) 
                                              WHERE PrKV2.IDPrikaz=TabPrKVazby.IDPrikaz AND PrKV2.Doklad=TabPrKVazby.Doklad AND PrKV2.IDOdchylkyDo IS NULL) 
        FROM TabPrKVazby 
          INNER JOIN TabPrKVazby PrKV_P ON (PrKV_P.IDPrikaz=TabPrKVazby.IDPrikaz AND PrKV_P.Doklad=TabPrKVazby.Doklad AND PrKV_P.IDOdchylkyDo IS NULL AND PrKV_P.prednastaveno=1) 
        WHERE EXISTS(SELECT * FROM (SELECT IDPrikaz, Doklad FROM INSERTED 
                                     UNION 
                                    SELECT IDPrikaz, Doklad FROM DELETED) AS X 
                              WHERE X.IDPrikaz=TabPrKVazby.IDPrikaz AND X.Doklad=TabPrKVazby.Doklad) 
    END 
  IF @IsInsert=1 UPDATE TabPrKVazby SET ID1=ID WHERE ID1=0 AND ID IN (SELECT I.ID FROM INSERTED I) 
  IF @IsInsert=1 OR UPDATE(Sklad) OR UPDATE(nizsi) 
    IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
      IF EXISTS(SELECT * 
                  FROM INSERTED I 
                    INNER JOIN TabParametryKmeneZbozi PKZ ON (PKZ.IDKmenZbozi=I.Nizsi AND PKZ.AutoGenerPozadavkuNaZajisteni=1) 
                    INNER JOIN TabPrKVazby PrKV ON (PrKV.ID=I.ID AND PrKV.IDOdchylkyDo IS NULL AND PrKV.Sklad IS NOT NULL) 
                    LEFT OUTER JOIN TabZajistX Z ON (Z.IDPrKVaz=PrKV.ID1) 
                  WHERE Z.ID IS NULL AND (PrKV.ID=PrKV.ID1 OR (@IsInsert=0 AND @IsDelete=0)) 
               ) 
        BEGIN 
          DECLARE crSezPolProZajisteni CURSOR FAST_FORWARD LOCAL FOR 
            SELECT PrKV.ID 
              FROM INSERTED I 
                INNER JOIN TabParametryKmeneZbozi PKZ ON (PKZ.IDKmenZbozi=I.Nizsi AND PKZ.AutoGenerPozadavkuNaZajisteni=1) 
                INNER JOIN TabPrKVazby PrKV ON (PrKV.ID=I.ID AND PrKV.IDOdchylkyDo IS NULL AND PrKV.Sklad IS NOT NULL) 
                LEFT OUTER JOIN TabZajistX Z ON (Z.IDPrKVaz=PrKV.ID1) 
              WHERE Z.ID IS NULL AND (PrKV.ID=PrKV.ID1 OR (@IsInsert=0 AND @IsDelete=0)) 
          OPEN crSezPolProZajisteni 
          FETCH NEXT FROM crSezPolProZajisteni INTO @RecID 
          WHILE @@fetch_status=0 
            BEGIN 
              EXEC hp_NZB_ZapisDoZajisteniVyroba @ID=@RecID, @IDZajistX=NULL, @Chyba=NULL, @ErrStr=NULL 
              IF @@error<>0  GOTO CHYBA 
              FETCH NEXT FROM crSezPolProZajisteni INTO @RecID 
            END 
          CLOSE crSezPolProZajisteni 
          DEALLOCATE crSezPolProZajisteni 
        END 
  RETURN 
 CHYBA:  
   IF @@trancount>0 ROLLBACK 
   IF @ErrID IS NOT NULL 
     BEGIN 
       SET @ErrMsg = dbo.hf_FormatError(@ErrID, @ErrMsg) 
       RAISERROR(@ErrMsg, 16, 1) 
     END 
   RETURN
GO
