-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ht_Prikaz_insert_update_delete] ON [dbo].[TabPrikaz] FOR INSERT, UPDATE, DELETE 
 AS 
  IF @@rowcount=0 RETURN 
  SET NOCOUNT ON 
  IF (dbo.hf_GetCountOfBits(COLUMNS_UPDATED())=1) AND UPDATE(BlokovaniEditoru) RETURN 
  DECLARE @IsDelete bit, @IsInsert bit, @IsUpdate bit 
  DECLARE @errID int, @errMsg nvarchar(500), @IDZurnal int, @IDZajisteni int 
  IF EXISTS(SELECT * FROM INSERTED) SET @IsDelete=0 ELSE SET @IsDelete=1 
  IF EXISTS(SELECT * FROM DELETED) SET @IsInsert=0 ELSE SET @IsInsert=1 
  IF @IsInsert=1 AND @IsDelete=1  RETURN 
  SET @IsUpdate= CASE WHEN @IsDelete=0 AND @IsInsert=0 THEN 1 ELSE 0 END 
  SELECT @ErrID=NULL, @ErrMsg='' 
  IF @IsUpdate=1 AND UPDATE(IDTabKmen) 
    BEGIN 
      SELECT TOP 1 @errID=2001593, @errMsg=RTRIM(I.rada)+N'-'+CAST(I.prikaz AS nvarchar(20)) 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID) 
        WHERE I.IDTabKmen<>D.IDTabKmen AND I.StavPrikazu>=20 
      IF (@errID IS NOT NULL) GOTO CHYBA 
    END 
  IF @IsUpdate=1 AND UPDATE(EvidJednotka) 
      UPDATE PP SET EvidJednotka=I.EvidJednotka 
        FROM INSERTED I 
          INNER JOIN TabPrikazP PP ON (PP.IDPrikaz=I.ID AND PP.Vnoreni=0) 
  IF @IsUpdate=1 AND UPDATE(kusy_zad) 
    BEGIN 
      DECLARE @vnoreni int 
      UPDATE PP SET CMnozstvi=I.kusy_zad 
        FROM INSERTED I 
          INNER JOIN TabPrikazP PP ON (PP.IDPrikaz=I.ID AND PP.Vnoreni=0) 
      SET @vnoreni=1 
      WHILE (1=1) 
        BEGIN 
          UPDATE PP SET CFixniMnozstvi=CEILING((PP2.CFixniMnozstvi*PP.Mnozstvi/PP.DavkaTPV_KV + PP.FixniMnozstvi)/PP.EvidJednotka)*PP.EvidJednotka, 
                        CMnozstvi=CEILING((PP2.CMnozstvi*PP.Mnozstvi/PP.DavkaTPV_KV)/PP.EvidJednotka)*PP.EvidJednotka 
            FROM TabPrikazP PP 
              INNER JOIN TabPrikazP PP2 ON (PP2.ID=PP.VyssiID) 
            WHERE PP.IDPrikaz IN (SELECT I.ID FROM INSERTED I) AND PP.Vnoreni=@vnoreni 
          IF @@rowcount=0 BREAK 
          SET @vnoreni=@vnoreni+1 
        END 
      UPDATE PP SET mnoz_zad=CASE WHEN NOT EXISTS(SELECT * FROM TabPrikazP PP2 WHERE PP2.IDPrikaz=PP.IDPrikaz AND PP2.IDTabKmen=PP.IDTabKmen AND (PP2.vnoreni>PP.vnoreni OR (PP2.vnoreni=PP.vnoreni AND PP2.Poradi<PP.Poradi) OR (PP2.vnoreni=PP.vnoreni AND PP2.Poradi=PP.Poradi AND PP2.ID>PP.ID))) 
                                  THEN (SELECT SUM(PP3.CFixniMnozstvi+PP3.CMnozstvi) FROM TabPrikazP PP3 WHERE PP3.IDPrikaz=PP.IDPrikaz AND PP3.IDTabKmen=PP.IDTabKmen) 
                                  ELSE 0.0 
                             END 
        FROM TabPrikazP PP  
        WHERE PP.IDPrikaz IN (SELECT I.ID FROM INSERTED I) 
    END 
  IF @IsUpdate=1 AND UPDATE(kusy_zive) 
    BEGIN 
      UPDATE P SET NeodvedeneNakladyPoUzav=0.0 
        FROM TabPrikaz P 
        WHERE P.ID IN (SELECT I.ID FROM INSERTED I) AND 
              P.NeodvedeneNakladyPoUzav<>0.0 AND P.kusy_zive>0.0 
    END 
  IF @IsUpdate=1 AND UPDATE(StavPrikazu) 
    BEGIN 
      IF EXISTS(SELECT * FROM TabHGlob WHERE NZB=1) 
        IF EXISTS(SELECT * FROM INSERTED I 
                             INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=I.ID AND PrKV.IDOdchylkyDo IS NULL) 
                             INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=PrKV.ID1) 
                           WHERE I.StavPrikazu=60) 
          BEGIN 
            DECLARE crSezPolKZajisteni CURSOR FAST_FORWARD LOCAL FOR 
              SELECT DISTINCT Z.ID 
                FROM INSERTED I 
                  INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=I.ID AND PrKV.IDOdchylkyDo IS NULL) 
                  INNER JOIN TabZajistX Z ON (Z.IDPrKVaz=PrKV.ID1) 
                WHERE I.StavPrikazu=60 
            OPEN crSezPolKZajisteni 
            FETCH NEXT FROM crSezPolKZajisteni INTO @IDZajisteni 
            WHILE @@fetch_status=0 
              BEGIN 
                EXEC hp_NZB_SmazZajisteni @IDZajisteni 
                IF @@error<>0  GOTO CHYBA 
                FETCH NEXT FROM crSezPolKZajisteni INTO @IDZajisteni 
              END 
            CLOSE crSezPolKZajisteni 
            DEALLOCATE crSezPolKZajisteni 
          END 
    END 
  IF @IsUpdate=1 AND (UPDATE(kusy_zive) OR UPDATE(StavPrikazu) OR UPDATE(ukonceni)) 
    BEGIN 
      UPDATE P SET Ukonceni=getdate(), StavPrikazu=CASE WHEN P.StavPrikazu=30 THEN 50 ELSE P.StavPrikazu END 
        FROM TabPrikaz P 
        WHERE P.ID IN (SELECT I.ID FROM INSERTED I) AND 
              P.StavPrikazu>=30 AND P.kusy_zive<=0.0 AND P.ukonceni IS NULL 
      UPDATE P SET Ukonceni=NULL, StavPrikazu=CASE WHEN P.StavPrikazu=50 THEN 30 ELSE P.StavPrikazu END 
        FROM TabPrikaz P 
        WHERE P.ID IN (SELECT I.ID FROM INSERTED I) AND 
              P.kusy_zive>0.0 AND P.ukonceni IS NOT NULL 
    END 
  IF (@IsDelete=1) OR 
     UPDATE(kusy_zive) OR 
     UPDATE(StavPrikazu) OR 
     UPDATE(kusy_ciste) OR UPDATE(kusy_odved) OR 
     UPDATE(IDTabKmen) 
    BEGIN 
      INSERT INTO TabParametryKmeneZbozi (IDKmenZbozi, VyraditZKalkulace, VyraditZKontrMaxVydanehoMnozDoVyroby, VyraditZKontrNaVydejDoVyroby, IDVzorceSpotMat, PrednasFixniMnozstvi, PrednasProcZtrat, VychoziSklad, AutoGenerPozadavkuNaZajisteni, KalkSkupina) 
        SELECT I.IDTabKmen, 
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
            INNER JOIN TabKmenZbozi KZ ON (KZ.ID=I.IDTabKmen) 
            INNER JOIN TabSkupinyZbozi SZ ON (SZ.SkupZbo=KZ.SkupZbo) 
          WHERE I.IDTabKmen IS NOT NULL 
          GROUP BY I.IDTabKmen 
          HAVING NOT EXISTS(SELECT * FROM TabParametryKmeneZbozi PKZ WHERE PKZ.IDKmenZbozi=I.IDTabKmen) 
      UPDATE PKZ 
        SET zadanoVeVyrobe = PKZ.zadanoVeVyrobe - (SELECT ISNULL(SUM(CASE WHEN D.StavPrikazu<30 THEN D.kusy_ciste ELSE D.kusy_zive_ciste END),0) 
                                                      FROM DELETED D 
                                                      WHERE D.IDTabKmen=PKZ.IDKmenZbozi AND (D.StavPrikazu<30 OR D.kusy_zive>0.0) ) 
                                                + (SELECT ISNULL(SUM(CASE WHEN I.StavPrikazu<30 THEN I.kusy_ciste ELSE I.kusy_zive_ciste END),0) 
                                                      FROM INSERTED I 
                                                      WHERE I.IDTabKmen=PKZ.IDKmenZbozi AND (I.StavPrikazu<30 OR I.kusy_zive>0.0) ) 
        FROM TabParametryKmeneZbozi PKZ 
        WHERE PKZ.IDKmenZbozi IN (SELECT IDTabKmen FROM INSERTED 
                                    UNION ALL 
                                  SELECT IDTabKmen FROM DELETED) 
      UPDATE PKZ 
        SET BlokovanoProVyrobu= PKZ.BlokovanoProVyrobu - (SELECT ISNULL(SUM(PrKV.mnoz_zad-PrKV.VydanoRefMnoz), 0.0) 
                                                             FROM DELETED D 
                                                              INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=D.ID AND PrKV.nizsi=PKZ.IDKmenZbozi AND PrKV.prednastaveno=1 AND PrKV.IDOdchylkyDo IS NULL AND PrKV.Splneno=0) 
                                                             WHERE D.kusy_zive>0.0) 
                                                       + (SELECT ISNULL(SUM(PrKV.mnoz_zad-PrKV.VydanoRefMnoz), 0.0) 
                                                             FROM INSERTED I 
                                                              INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=I.ID AND PrKV.nizsi=PKZ.IDKmenZbozi AND PrKV.prednastaveno=1 AND PrKV.IDOdchylkyDo IS NULL AND PrKV.Splneno=0) 
                                                             WHERE I.kusy_zive>0.0) 
        FROM TabParametryKmeneZbozi PKZ 
        WHERE PKZ.IDKmenZbozi IN (SELECT PrKV.nizsi FROM INSERTED I INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=I.ID) 
                                    UNION ALL 
                                  SELECT PrKV.nizsi FROM DELETED D INNER JOIN TabPrKVazby PrKV ON (PrKV.IDPrikaz=D.ID))  
      UPDATE PKZ 
        SET zadanoVeVyrobe= PKZ.zadanoVeVyrobe - (SELECT ISNULL(SUM(PrVPV.mnoz_zustatkove), 0.0) 
                                                      FROM DELETED D 
                                                        INNER JOIN TabPrVPVazby PrVPV ON (PrVPV.IDPrikaz=D.ID AND PrVPV.VedProdukt=PKZ.IDKmenZbozi AND PrVPV.IDOdchylkyDo IS NULL AND PrVPV.Splneno=0) 
                                                      WHERE D.kusy_zive>0.0) 
                                               + (SELECT ISNULL(SUM(PrVPV.mnoz_zustatkove), 0.0) 
                                                      FROM INSERTED I 
                                                        INNER JOIN TabPrVPVazby PrVPV ON (PrVPV.IDPrikaz=I.ID AND PrVPV.VedProdukt=PKZ.IDKmenZbozi AND PrVPV.IDOdchylkyDo IS NULL AND PrVPV.Splneno=0) 
                                                      WHERE I.kusy_zive>0.0) 
        FROM TabParametryKmeneZbozi PKZ 
        WHERE PKZ.IDKmenZbozi IN (SELECT PrVPV.VedProdukt FROM INSERTED I INNER JOIN TabPrVPVazby PrVPV ON (PrVPV.IDPrikaz=I.ID) 
                                    UNION ALL 
                                  SELECT PrVPV.VedProdukt FROM DELETED D INNER JOIN TabPrVPVazby PrVPV ON (PrVPV.IDPrikaz=D.ID)) 
    END 
  IF @IsUpdate=1 AND (UPDATE(Plan_zadani) OR UPDATE(Plan_ukonceni) OR UPDATE(kusy_ciste) OR UPDATE(Kusy_zad)) 
    INSERT INTO TabPrikazObchodniZmeny(IDPrikaz, Plan_zadani, Plan_zadani_Old, Plan_ukonceni, Plan_ukonceni_Old, PotvrzDatDod_Obj, kusy_ciste, kusy_ciste_Old, Kusy_zad, Kusy_zad_Old) 
      SELECT I.ID, 
             CASE WHEN I.Plan_zadani<>D.Plan_zadani THEN I.Plan_zadani END, CASE WHEN I.Plan_zadani<>D.Plan_zadani THEN D.Plan_zadani END, 
             CASE WHEN I.Plan_ukonceni<>D.Plan_ukonceni THEN I.Plan_ukonceni END, CASE WHEN I.Plan_ukonceni<>D.Plan_ukonceni THEN D.Plan_ukonceni END, 
             CASE WHEN I.Plan_ukonceni<>D.Plan_ukonceni THEN 
               (SELECT MIN(ISNULL(ISNULL(PZ.PotvrzDatDod_X, ISNULL(PZ.PozadDatDod_X, DZ.TerminDodavkyDat_X)), ISNULL(DOR.PotvrzDatDod_X, ISNULL(DOR.PozadDatDod_X, DOH.DatumDodavky_X)))) 
                  FROM TabPrikazZdrojOZ Z WITH (NOLOCK) 
                    LEFT OUTER JOIN TabPohybyZbozi PZ WITH (NOLOCK) ON (PZ.ID=Z.IDRezervace) 
                    LEFT OUTER JOIN TabDokladyZbozi DZ WITH (NOLOCK) ON (DZ.ID=PZ.IDDoklad) 
                    LEFT OUTER JOIN TabDosleObjR02 DOR WITH (NOLOCK) ON (DOR.GUIDPolozky=Z.GUIDDosObjR) 
                    LEFT OUTER JOIN TabDosleObjH02 DOH WITH (NOLOCK) ON (DOH.ID=DOR.IDHlava) 
                  WHERE Z.IDPrikaz=I.ID) 
             END, 
             CASE WHEN I.kusy_ciste<>D.kusy_ciste THEN I.kusy_ciste END, CASE WHEN I.kusy_ciste<>D.kusy_ciste THEN D.kusy_ciste END, 
             CASE WHEN I.Kusy_zad<>D.Kusy_zad THEN I.Kusy_zad END, CASE WHEN I.Kusy_zad<>D.Kusy_zad THEN D.Kusy_zad END 
        FROM INSERTED I 
          INNER JOIN DELETED D ON (D.ID=I.ID) 
        WHERE D.JeNovaVetaEditor=0 AND (I.Plan_zadani<>D.Plan_zadani OR I.Plan_ukonceni<>D.Plan_ukonceni OR I.kusy_ciste<>D.kusy_ciste OR I.Kusy_zad<>D.Kusy_zad) 
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
