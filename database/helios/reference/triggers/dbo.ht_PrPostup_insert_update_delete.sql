-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_PrPostup_insert_update_delete] ON [dbo].[TabPrPostup] FOR INSERT,UPDATE,DELETE 
 AS 
  IF @@rowcount=0 RETURN 
  SET NOCOUNT ON 
  DECLARE @IsInsert bit, @IsDelete bit, @IsUpdate bit, @ErrID int, @errMsg nvarchar(500), @IDZurnal int 
  IF EXISTS(SELECT * FROM INSERTED) SET @IsDelete=0 ELSE SET @IsDelete=1 
  IF EXISTS(SELECT * FROM DELETED) SET @IsInsert=0 ELSE SET @IsInsert=1 
  IF @IsInsert=1 AND @IsDelete=1  RETURN 
  SET @IsUpdate= CASE WHEN @IsDelete=0 AND @IsInsert=0 THEN 1 ELSE 0 END 
  SELECT @ErrID=NULL, @ErrMsg='' 
  IF @IsInsert=1 
    BEGIN 
      SELECT TOP 1 @ErrID=2001536, @errMsg=CAST(I.doklad AS nvarchar(20)) 
        FROM INSERTED I 
        WHERE I.ID1=0 AND I.prednastaveno=1 AND 
              EXISTS(SELECT * FROM TabPrPostup PrP WHERE PrP.IDPrikaz=I.IDPrikaz AND PrP.Doklad=I.Doklad AND PrP.prednastaveno=1 AND PrP.ID1<>0) 
      IF @ErrID IS NOT NULL GOTO CHYBA 
    END 
  IF UPDATE(Kusy_nepotrebne) 
    BEGIN 
      UPDATE PrP SET Kusy_nepotrebne=PrP_P.Kusy_nepotrebne 
        FROM INSERTED I 
          INNER JOIN TabPrPostup PrP ON (PrP.IDPrikaz=I.IDPrikaz AND PrP.Doklad=I.Doklad AND PrP.prednastaveno=0) 
          INNER JOIN TabPrPostup PrP_P ON (PrP_P.IDPrikaz=PrP.IDPrikaz AND PrP_P.Doklad=PrP.Doklad AND PrP_P.prednastaveno=1 AND PrP_P.IDOdchylkyDo IS NULL) 
    END 
  IF UPDATE(IDODchylkyDo) OR UPDATE(Kusy_nepotrebne) OR 
     UPDATE(prednastaveno) OR 
     UPDATE(Kusy_real) OR UPDATE(Kusy_ztra) OR UPDATE(Kusy_zmet) OR UPDATE(Kusy_zmet_neopr) 
    BEGIN 
      UPDATE TabPrPostup SET ZaevidovaneKusyAll=(SELECT ISNULL(SUM(CASE WHEN PrP2.prednastaveno=1 THEN PrP2.Kusy_nepotrebne ELSE 0.0 END + PrP2.Kusy_real + PrP2.Kusy_ztra + PrP2.Kusy_zmet + PrP2.Kusy_zmet_neopr),0.0) 
                                                   FROM TabPrPostup PrP2 
                                                   WHERE PrP2.IDPrikaz=TabPrPostup.IDPrikaz AND PrP2.Doklad=TabPrPostup.Doklad AND PrP2.IDOdchylkyDo IS NULL) 
        FROM TabPrPostup 
        WHERE EXISTS(SELECT * FROM (SELECT IDPrikaz, Doklad FROM INSERTED 
                                     UNION 
                                    SELECT IDPrikaz, Doklad FROM DELETED) AS X 
                              WHERE X.IDPrikaz=TabPrPostup.IDPrikaz AND X.Doklad=TabPrPostup.Doklad) 
    END 
  IF UPDATE(KusyVKoop) 
    BEGIN 
      UPDATE TabPrPostup SET KusyVKoopAll=(SELECT ISNULL(SUM(PrP2.KusyVKoop),0.0) 
                                             FROM TabPrPostup PrP2 
                                             WHERE PrP2.IDPrikaz=TabPrPostup.IDPrikaz AND PrP2.Doklad=TabPrPostup.Doklad AND PrP2.IDOdchylkyDo IS NULL) 
        FROM TabPrPostup 
        WHERE EXISTS(SELECT * FROM (SELECT IDPrikaz, Doklad FROM INSERTED 
                                     UNION 
                                    SELECT IDPrikaz, Doklad FROM DELETED) AS X 
                              WHERE X.IDPrikaz=TabPrPostup.IDPrikaz AND X.Doklad=TabPrPostup.Doklad) 
    END 
  IF @IsInsert=1 UPDATE TabPrPostup SET ID1=ID WHERE ID1=0 AND ID IN (SELECT I.ID FROM INSERTED I) 
  IF @IsInsert=0 AND (UPDATE(Operace) OR UPDATE(Dilec)) 
    BEGIN 
      UPDATE PrKV SET Vyssi=I.Dilec, Operace=I.Operace 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID AND (I.Operace<>D.Operace OR I.Dilec<>D.Dilec)) 
          INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=I.IDPrikaz AND PrKV.Vyssi=D.Dilec AND PrKV.Operace=D.Operace) 
        WHERE I.prednastaveno=1 AND I.IDOdchylkyDo IS NULL 
      UPDATE PrNV SET Dilec=I.Dilec, Operace=I.Operace 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID AND (I.Operace<>D.Operace OR I.Dilec<>D.Dilec)) 
          INNER JOIN TabPrNVazby PrNV ON (PrNV.IDPrikaz=I.IDPrikaz AND PrNV.Dilec=D.Dilec AND PrNV.Operace=D.Operace) 
        WHERE I.prednastaveno=1 AND I.IDOdchylkyDo IS NULL 
      UPDATE PrVPV SET Dilec=I.Dilec, Operace=I.Operace 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID AND (I.Operace<>D.Operace OR I.Dilec<>D.Dilec)) 
          INNER JOIN TabPrVPVazby PrVPV ON (PrVPV.IDPrikaz=I.IDPrikaz AND PrVPV.Dilec=D.Dilec AND PrVPV.Operace=D.Operace) 
        WHERE I.prednastaveno=1 AND I.IDOdchylkyDo IS NULL 
    END 
  IF @IsInsert=0 AND UPDATE(Alt) 
    BEGIN 
      UPDATE PrNV SET AltOperace=I.Alt 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID AND I.Alt<>D.Alt) 
          INNER JOIN TabPrNVazby PrNV ON (PrNV.IDPrikaz=I.IDPrikaz AND PrNV.Dilec=I.Dilec AND PrNV.Operace=I.Operace AND PrNV.AltOperace=D.Alt) 
        WHERE I.IDOdchylkyDo IS NULL 
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
