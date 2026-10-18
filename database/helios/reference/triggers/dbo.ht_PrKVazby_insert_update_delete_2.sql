-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_PrKVazby_insert_update_delete_2] ON [dbo].[TabPrKVazby] FOR INSERT,UPDATE,DELETE 
 AS 
IF @@rowcount=0 RETURN 
SET NOCOUNT ON 
DECLARE @IsInsert bit, @IsDelete bit, @ID1 int 
IF EXISTS(SELECT * FROM INSERTED) SET @IsDelete=0 ELSE SET @IsDelete=1 
IF EXISTS(SELECT * FROM DELETED) SET @IsInsert=0 ELSE SET @IsInsert=1 
IF @IsInsert=1 AND @IsDelete=1  RETURN 
IF UPDATE(mnoz_zad) OR UPDATE(VydanoRefMnoz) OR 
   UPDATE(IDOdchylkyDo) OR 
   UPDATE(prednastaveno) OR 
   UPDATE(nizsi) OR 
   UPDATE(Uzavreno) OR UPDATE(RezijniMat) OR 
   @IsDelete=1 
  BEGIN 
    INSERT INTO TabParametryKmeneZbozi (IDKmenZbozi, VyraditZKalkulace, VyraditZKontrMaxVydanehoMnozDoVyroby, VyraditZKontrNaVydejDoVyroby, IDVzorceSpotMat, PrednasFixniMnozstvi, PrednasProcZtrat, VychoziSklad, AutoGenerPozadavkuNaZajisteni, KalkSkupina) 
      SELECT I.nizsi, 
             MAX(convert(int, CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_VyraditZKalkulace ELSE 0 END)), 
             MAX(convert(int, CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_VyraditZKontrMaxVydanehoMnozDoVyroby ELSE 0 END)), 
             MAX(convert(int, CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_VyraditZKontrNaVydejDoVyroby ELSE 0 END)), 
             MAX(CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_IDVzorceSpotMat END), 
             MAX(CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_PrednasFixniMnozstvi END), 
             MAX(CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_PrednasProcZtrat END), 
             MAX(CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_VychoziSklad END), 
             MAX(CASE WHEN KZ.dilec=1 OR KZ.material=1 THEN SZ.ParMD_AutoGenerPozadavkuNaZajisteni ELSE 0 END), 
             MAX(CASE WHEN KZ.material=1 THEN SZ.ParM_KalkSkupina END) 
        FROM INSERTED I 
          INNER JOIN TabKmenZbozi KZ ON (KZ.ID=I.nizsi) 
          INNER JOIN TabSkupinyZbozi SZ ON (SZ.SkupZbo=KZ.SkupZbo) 
        WHERE I.IDOdchylkyDo IS NULL AND I.prednastaveno=1 AND I.nizsi IS NOT NULL 
        GROUP BY I.nizsi 
        HAVING NOT EXISTS(SELECT * FROM TabParametryKmeneZbozi PKZ WHERE PKZ.IDKmenZbozi=I.nizsi) 
    UPDATE PKZ SET BlokovanoProVyrobu= PKZ.BlokovanoProVyrobu + S.Mnoz 
      FROM (SELECT T.Nizsi, Mnoz=SUM(T.Mnoz) 
              FROM ( SELECT D.Nizsi, Mnoz=-(D.mnoz_zad-D.VydanoRefMnoz) 
                       FROM DELETED D 
                         INNER JOIN TabPrikaz P ON (P.ID=D.IDPrikaz AND P.kusy_zive>0.0) 
                       WHERE D.IDOdchylkyDo IS NULL AND D.Splneno=0 AND D.prednastaveno=1 UNION ALL 
                     SELECT I.Nizsi, Mnoz=I.mnoz_zad-I.VydanoRefMnoz 
                       FROM INSERTED I 
                         INNER JOIN TabPrikaz P ON (P.ID=I.IDPrikaz AND P.kusy_zive>0.0) 
                       WHERE I.IDOdchylkyDo IS NULL AND I.Splneno=0 AND I.prednastaveno=1) T 
              GROUP BY T.Nizsi 
              HAVING SUM(T.Mnoz)<>0.0) S 
        INNER JOIN TabParametryKmeneZbozi PKZ ON (PKZ.IDKmenZbozi=S.Nizsi) 
  END 
IF (@IsInsert=0 AND @IsDelete=0) AND 
   (UPDATE(Mnoz_zad) OR UPDATE(Mnoz_nepotrebne) OR     UPDATE(VydanoRefMnoz) OR UPDATE(RefMnoz)) 
  IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
    IF EXISTS(SELECT * FROM DELETED D 
                         INNER JOIN INSERTED I ON (I.ID=D.ID) 
                         INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=D.ID1) 
                       WHERE ((D.mnoz_pozadovane<>I.mnoz_pozadovane) OR (D.VydanoRefMnoz<>I.VydanoRefMnoz) OR (D.RefMnoz<>I.RefMnoz)) AND D.IDOdchylkyDo IS NULL) 
      BEGIN 
        DECLARE crSezPolKZajisteni CURSOR FAST_FORWARD LOCAL FOR 
          SELECT DISTINCT D.ID1 
            FROM DELETED D 
              INNER JOIN INSERTED I ON (I.ID=D.ID) 
              INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=D.ID1) 
            WHERE ((D.mnoz_pozadovane<>I.mnoz_pozadovane) OR (D.VydanoRefMnoz<>I.VydanoRefMnoz) OR (D.RefMnoz<>I.RefMnoz)) AND D.IDOdchylkyDo IS NULL 
        OPEN crSezPolKZajisteni 
        FETCH NEXT FROM crSezPolKZajisteni INTO @ID1 
        WHILE @@fetch_status=0 
          BEGIN 
            EXEC hp_NZB_PrkVaz_ZmenaZajisteni @ID1 
            IF @@error<>0  GOTO CHYBA 
            FETCH NEXT FROM crSezPolKZajisteni INTO @ID1 
          END 
        CLOSE crSezPolKZajisteni 
        DEALLOCATE crSezPolKZajisteni 
      END 
RETURN 
CHYBA:  
  IF @@trancount>0 ROLLBACK 
  RETURN
GO
