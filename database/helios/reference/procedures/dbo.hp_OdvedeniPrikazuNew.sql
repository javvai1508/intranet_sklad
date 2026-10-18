-- Snapshot Helios002.zip, 2026-10-18; nejde o automatickou migraci.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[hp_OdvedeniPrikazuNew] 
  @RadaDokladu nvarchar(3)=NULL, 
  @KonecneOdvedeni bit=0, 
  @DatPorizeni datetime=NULL, 
  @SekejZakazky bit=1, 
  @SekejPrikazy bit=0 
AS  
BEGIN 
 SET NOCOUNT ON 
 DECLARE @ret int, @dnes datetime, @DatPorizeni_X datetime, @StredNaklad nvarchar(30), @IDHlavicky integer, @RadaDok nvarchar(3), 
         @IDZakazka int, @Sklad nvarchar(30), @CisloZakazky NVARCHAR(15), @IDDilce int, @IDZboSklad INT, @CisloNOkruh nvarchar(15), 
         @IDPrikaz INT, @IDOdvedeni int, @GenerOdvVyrobkuVMJEvid bit, @IDStavUmisteni int, @OZPrepMJnaVC bit, @DatumProVypocetExpirace datetime, 
         @errID int, @errMsg nvarchar(500), 
         @IDPlan int, @IDKmeneZbozi_Plan int, @JeTopPrikaz bit, 
         @mnozstviPoz numeric(20,6), @mnozstviDok numeric(20,6), @MJ nvarchar(10), @PrepMnozstvi float, 
         @OsvobozenaPlneni int, @VstupniCena int, @DruhMeny nvarchar(10), @Kurz numeric(19,6), @KurzEuro numeric(19,6), @JednotkaMeny numeric(19,6), @SazbaDPH numeric(19,6), 
         @IDVyrCisP_VC int, @IDVyrCK_VC int, @VyrCislo_VC nvarchar(100), @Popis_VC nvarchar(100), @DatExpirace_VC datetime, @VypDatExpirace_VC datetime, @DatVyroby_VC datetime, @Mnozstvi_VC numeric(20,6), @OdvedenoNow_VC numeric(20,6), @ID_TabVyrCS int, 
         @IDPolozky int, @IDOldPolozka int, @TranCountPred int, @IDVyrCisProGen int, @IDVyrCP int, @IDZakazModif int 
 DELETE #tabOdved WHERE mnozstvi<=0.0 
 IF NOT EXISTS(SELECT * FROM #tabOdved) RETURN 0 
 SET @TranCountPred=@@trancount 
  IF @DatPorizeni IS NULL SET @DatPorizeni=GETDATE() 
  EXEC hp_TruncDate @DatPorizeni OUTPUT 
  SELECT @dnes=getDate(), @DatPorizeni_X=@DatPorizeni, @errID=NULL, @errMsg='' 
  SET @DatPorizeni=@DatPorizeni+convert(Datetime,convert(FLOAT,@dnes)-convert(int,convert(FLOAT,@dnes))) 
  SELECT @OZPrepMJnaVC=OZPrepMJnaVC FROM TabHGlob 
  SELECT TOP 1 @ErrID=2004343, @ErrMsg=RTRIM(P.rada)+N' '+CONVERT(nvarchar(10),P.prikaz)+NCHAR(13)+KZ.SkupZbo+N' '+KZ.RegCis 
    FROM #TabOdved O 
      INNER JOIN TabPrikaz P ON (P.ID=O.IDPrikaz) 
      INNER JOIN TabRadyPrikazu RP ON (RP.rada=P.rada) 
      INNER JOIN TabKmenZbozi KZ ON (KZ.ID=O.IDDilec) 
      LEFT OUTER JOIN TabParKmZ ParD ON (ParD.IDKmenZbozi=KZ.ID) 
    WHERE ISNULL(ParD.ZpusobOdvedeniDilceZVyroby,RP.ZpusobOdvedeniDilceZVyroby) NOT IN (0,1) 
  IF @ErrID IS NOT NULL GOTO CHYBA 
  INSERT INTO tabStavSkladu (IDKmenZbozi,IDSklad)  
     SELECT DISTINCT O.IDDilec, O.Sklad 
       FROM #TabOdved O 
         INNER JOIN TabKmenZbozi KZ ON (KZ.ID=O.IDDilec AND KZ.sluzba=0) 
       WHERE NOT EXISTS(SELECT * FROM TabStavSkladu SS WHERE SS.IDSklad=O.Sklad AND SS.IDKmenZbozi=O.IDDilec) 
  IF (@@ERROR<>0) GOTO CHYBA  
  INSERT INTO TabUmisteni(IDSklad, Kod, Nazev)  
     SELECT DISTINCT O.Sklad, O.KodUmisteni, '' 
       FROM #TabOdved O 
       WHERE LEN(O.KodUmisteni)>0 AND 
             NOT EXISTS(SELECT * FROM TabUmisteni U WHERE U.IDSklad=O.Sklad AND U.Kod=O.KodUmisteni) 
  IF (@@ERROR<>0) GOTO CHYBA  
  INSERT INTO TabVStavUmisteni(IDStav, IDUmisteni)  
     SELECT DISTINCT SS.ID, U.ID 
       FROM #TabOdved O 
         INNER JOIN TabStavSkladu SS ON (SS.IDSklad=O.Sklad AND SS.IDKmenZbozi=O.IDDilec) 
         INNER JOIN TabUmisteni U ON (U.IDSklad=O.Sklad AND U.Kod=O.KodUmisteni) 
       WHERE LEN(O.KodUmisteni)>0 AND 
             NOT EXISTS(SELECT * FROM TabVStavUmisteni SU WHERE SU.IDStav=SS.ID AND SU.IDUmisteni=U.ID) 
  IF (@@ERROR<>0) GOTO CHYBA  
  DECLARE curSkladZak CURSOR FAST_FORWARD LOCAL FOR 
         SELECT ISNULL(@RadaDokladu, RP.RadaDokl_OdvedeniPrikazu), 
                ISNULL(RP.PrijemVyrDil_SkladProGenHlavDZ, O.Sklad), MAX(O.IDZakazka), MAX(O.IDPrikaz) 
           FROM #TabOdved O 
             INNER JOIN TabPrikaz P ON (P.ID=O.IDPrikaz) 
             INNER JOIN TabRadyPrikazu RP ON (RP.rada=P.rada) 
           GROUP BY ISNULL(@RadaDokladu, RP.RadaDokl_OdvedeniPrikazu), 
                    ISNULL(RP.PrijemVyrDil_SkladProGenHlavDZ, O.Sklad), 
                    CASE WHEN @SekejZakazky=1 THEN O.IDZakazka END, CASE WHEN @SekejPrikazy=1 THEN O.IDPrikaz END 
  OPEN curSkladZak 
  FETCH NEXT FROM curSkladZak INTO @RadaDok, @Sklad, @IDZakazka, @IDPrikaz 
  WHILE @@fetch_status=0  
    BEGIN 
       IF @RadaDok IS NULL 
         BEGIN 
           SET @errID=2002953 
           GOTO CHYBA 
         END 
      SET @IDHlavicky=NULL 
      EXEC hp_InsertHlavickyOZ_Full @IDHlavicky OUTPUT, @Sklad, 0, @RadaDok, @CisloOrg=0, @DatumPorizeni=@DatPorizeni 
      IF (@@ERROR<>0) OR (@IDHlavicky IS NULL) GOTO CHYBA 
      UPDATE TabDokladyZbozi SET BlokovaniEditoru=0, VstupniCena=CASE WHEN VstupniCena<>0 THEN 2 ELSE VstupniCena END 
        WHERE ID=@IDHlavicky 
      IF (@@ERROR<>0) GOTO CHYBA 
      INSERT INTO #TabGenPrijem (ID) VALUES(@IDHlavicky) 
      SELECT @OsvobozenaPlneni=DD.OsvobozenaPlneni, @SazbaDPH=DZ.SazbaDPH, 
             @VstupniCena=DZ.VstupniCena, @DruhMeny=DZ.Mena, @Kurz=DZ.Kurz, @JednotkaMeny=DZ.JednotkaMeny, @KurzEuro=DZ.KurzEuro 
        FROM TabDokladyZbozi DZ 
          INNER JOIN TabDruhDokZbo DD ON (DD.RadaDokladu=DZ.radaDokladu AND DD.DruhPohybuZbo=DZ.DruhPohybuZbo) 
        WHERE DZ.ID=@IDHlavicky 
      DECLARE polozky CURSOR FAST_FORWARD LOCAL FOR 
           SELECT O.ID, KZ.ID, SS.ID, O.IDPrikaz, O.mnozstvi, CASE WHEN PZ.druhPohybuZbo=6 THEN PZ.ID END, 
                  Z.CisloZakazky, CASE RP.ZdrojNakladStredProPrijem WHEN 0 THEN NULL WHEN 1 THEN P.KmenoveStredisko ELSE S.NakladoveStredisko END, 
                  KZ.MJEvidence, RP.GenerOdvVyrobkuVMJEvid, NO.Cislo, SU.ID, O.IDZakazModif, 
                  CASE ISNULL(ParD.DatumProVypocetExpirace,0) WHEN 1 THEN P.Plan_zadani_X WHEN 2 THEN P.Plan_ukonceni_X WHEN 3 THEN P.Zadani_X ELSE @DatPorizeni_X END, 
                  JeTopPrikaz=CASE WHEN P.IDPrikazVyssi IS NULL THEN 1 ELSE 0 END 
               FROM #tabOdved O 
                 INNER JOIN TabPrikaz P ON (P.ID=O.IDPrikaz) 
                 INNER JOIN TabRadyPrikazu RP ON (RP.rada=P.rada) 
                 INNER JOIN TabKmenZbozi KZ ON (KZ.ID=O.IDDilec) 
                 INNER JOIN TabStavSkladu SS ON (SS.IDSklad=O.Sklad AND SS.IDKmenZbozi=O.IDDilec) 
                 LEFT OUTER JOIN TabParKmZ ParD ON (ParD.IDKmenZbozi=KZ.ID) 
                 LEFT OUTER JOIN TabStrom S ON (S.Cislo=P.KmenoveStredisko) 
                 LEFT OUTER JOIN TabZakazka Z ON (Z.ID=O.IDZakazka) 
                 LEFT OUTER JOIN TabNakladovyOkruh NO ON (NO.ID=P.IDNaklOkruh) 
                 LEFT OUTER JOIN TabPohybyZbozi PZ ON (PZ.ID=P.IDRezervace) 
                 LEFT OUTER JOIN TabUmisteni U ON (U.IDSklad=O.Sklad AND U.Kod=O.KodUmisteni) 
                 LEFT OUTER JOIN TabVStavUmisteni SU ON (SU.IDStav=SS.ID AND SU.IDUmisteni=U.ID) 
               WHERE ISNULL(@RadaDokladu, RP.RadaDokl_OdvedeniPrikazu) = @RadaDok AND 
                     ISNULL(RP.PrijemVyrDil_SkladProGenHlavDZ, O.Sklad)=@Sklad AND (@SekejZakazky=0 OR ISNULL(O.IDZakazka,0)=ISNULL(@IDZakazka,0)) AND (@SekejPrikazy=0 OR O.IDPrikaz=@IDPrikaz) 
      OPEN polozky 
      FETCH NEXT FROM polozky INTO @IDOdvedeni, @IDDilce, @IDZboSklad, @IDPrikaz, @mnozstviPoz, @IDOldPolozka, @CisloZakazky, @StredNaklad, @MJ, @GenerOdvVyrobkuVMJEvid, @CisloNOkruh, @IDStavUmisteni, @IDZakazModif, 
                                   @DatumProVypocetExpirace, @JeTopPrikaz 
      WHILE @@FETCH_STATUS=0 
       BEGIN  
         SET @mnozstviDok=@mnozstviPoz 
           IF @GenerOdvVyrobkuVMJEvid=0 
             BEGIN 
               EXEC hp_PrepoctiMJDleDruhu 0, @IDDilce, @mnozstviDok OUTPUT, @MJ OUTPUT 
               IF (@@ERROR<>0) GOTO CHYBA 
             END 
         SET @mnozstviDok=ROUND(@mnozstviDok,4,1) 
         SET @IDPolozky=NULL 
         EXEC hp_InsertPolozkyOZ @IDPolozky OUT, @IDHlavicky, 0, 0, @IDZboSklad, @DruhMeny, @Kurz, @JednotkaMeny, @KurzEuro, @SazbaSD=0, @SazbaDPH=@SazbaDPH, @ZakazanoDPH=@OsvobozenaPlneni, @VstupniCena=@VstupniCena, @PovolitDuplicitu=1, @PovolitBlokovane=1, @Mnozstvi=@mnozstviDok, @JCbezDaniKC=0.0, @VstupniCenaProPrepocet=0, @DatPorizeni=@DatPorizeni, @MJ=@MJ, @IDOldPolozka=@IDOldPolozka 
         IF (@@ERROR<>0) OR (@IDPolozky IS NULL) GOTO CHYBA 
         UPDATE TabPohybyZbozi SET CisloZakazky=@CisloZakazky, CisloNOkruh=@CisloNOkruh, StredNaklad=@StredNaklad, IdUmisteni=ISNULL(@IDStavUmisteni,IdUmisteni), 
                                   IDPrikaz=@IDPrikaz, TypVyrobnihoDokladu=0, DokladPrikazu=(CASE WHEN @KonecneOdvedeni=1 THEN -1 ELSE NULL END), 
                                   IDZakazModif=@IDZakazModif 
            WHERE ID=@IDPolozky 
         IF (@@ERROR<>0) GOTO CHYBA 
         UPDATE #TabOdved SET IDPohZbo=@IDPolozky WHERE ID=@IDOdvedeni 
         EXEC @ret=hp_NapoctiOdvadeciCenu @IDPolozky 
         IF @@error<>0 OR @ret<>0 GOTO CHYBA 
         IF OBJECT_ID(N'tempdb..#TabVyrCisProGenOdv') IS NOT NULL AND (@OZPrepMJnaVC=1 OR @GenerOdvVyrobkuVMJEvid=1) 
           BEGIN 
             SELECT @PrepMnozstvi=PrepMnozstvi FROM TabPohybyZbozi WHERE ID=@IDPolozky 
             DECLARE VyrCisNaPr CURSOR FAST_FORWARD LOCAL FOR 
                 SELECT G.ID, VC.ID, G.VyrCislo, VC.Popis, G.Mnozstvi / @PrepMnozstvi, VC.DatExpirace, 
                        CASE WHEN KZ.ZarukaVystup>0 THEN 
                          CASE KZ.TypZarukaVystup WHEN 0 THEN DATEADD(Day, KZ.ZarukaVystup, @DatumProVypocetExpirace) 
                                                  WHEN 1 THEN DATEADD(Month, KZ.ZarukaVystup, @DatumProVypocetExpirace) 
                                                  ELSE DATEADD(Year, KZ.ZarukaVystup, @DatumProVypocetExpirace) 
                          END 
                        END, 
                        DatVyroby=@DatumProVypocetExpirace 
                      FROM #TabVyrCisProGenOdv G 
                        INNER JOIN TabVyrCisPrikaz VC ON (VC.IDPrikaz=G.IDPrikaz AND VC.VyrCislo=G.VyrCislo) 
                        INNER JOIN TabKmenZbozi KZ ON (KZ.ID=@IDDilce) 
                      WHERE G.IDOdvedeni=@IDOdvedeni AND G.mnozstvi>0.0 
             OPEN VyrCisNaPr 
             FETCH NEXT FROM VyrCisNaPr INTO @IDVyrCisProGen, @IDVyrCisP_VC, @VyrCislo_VC, @Popis_VC, @Mnozstvi_VC, @DatExpirace_VC, @VypDatExpirace_VC, @DatVyroby_VC 
             WHILE (@@FETCH_STATUS=0) 
               BEGIN  
                 SET @Mnozstvi_VC=ROUND(@Mnozstvi_VC,4,1) 
                 IF @Mnozstvi_VC>@mnozstviDok SET @Mnozstvi_VC=@mnozstviDok 
                 IF @DatExpirace_VC IS NULL AND @VypDatExpirace_VC IS NOT NULL 
                   BEGIN 
                     SET @DatExpirace_VC=@VypDatExpirace_VC 
                     UPDATE TabVyrCisPrikaz SET DatExpirace=@VypDatExpirace_VC WHERE ID=@IDVyrCisP_VC 
                   END 
                 SELECT @ID_TabVyrCS=NULL, @IDVyrCK_VC=NULL 
                 SELECT @ID_TabVyrCS=ID, @IDVyrCK_VC=IDVyrCK FROM TabVyrCS WHERE IDStavSkladu=@IDZboSklad AND Nazev1=@VyrCislo_VC 
                 IF (@ID_TabVyrCS IS NULL) 
                   BEGIN 
                     EXEC hp_OZInsertVyrCS @IDVyrCS=@ID_TabVyrCS OUT, @IDVyrCK=@IDVyrCK_VC OUT, @IDZboSklad=@IDZboSklad, @IDZakazModif=@IDZakazModif, @Nazev1=@VyrCislo_VC, @Nazev2=@Popis_VC, @DatVstup=@DatumProVypocetExpirace, @DatExpirace=@DatExpirace_VC  
                     IF (@@ERROR<>0) GOTO CHYBA 
                   END ELSE 
                   BEGIN 
                     UPDATE TabVyrCS SET IDZakazModif=@IDZakazModif WHERE ID=@ID_TabVyrCS AND ISNULL(IDZakazModif,0)<>ISNULL(@IDZakazModif,0) 
                   END 
                 UPDATE TabVyrCK SET DatVyroby=@DatVyroby_VC WHERE ID=@IDVyrCK_VC AND DatVyroby IS NULL 
                 UPDATE TabVyrCK SET IDZakazModif=@IDZakazModif WHERE ID=@IDVyrCK_VC AND ISNULL(IDZakazModif,0)<>ISNULL(@IDZakazModif,0) 
                 INSERT INTO TabVyrCP (IDPolozkaDokladu, IDVyrCis, Nazev, DatVstup, DatVystup, DatExpirace, Mnozstvi, Poznamka) 
                    SELECT @IDPolozky, VC.ID, VC.nazev2, VC.DatVstup, VC.DatVystup, VC.DatExpirace, @Mnozstvi_VC, VCP.poznamka 
                       FROM TabVyrCS VC 
                         INNER JOIN TabVyrCisPrikaz VCP ON (VCP.ID=@IDVyrCisP_VC) 
                       WHERE VC.ID=@ID_TabVyrCS 
                 IF (@@ERROR<>0) GOTO CHYBA 
                 SET @IDVyrCP=SCOPE_IDENTITY() 
                 UPDATE #TabVyrCisProGenOdv SET IDVyrCP=@IDVyrCP WHERE ID=@IDVyrCisProGen 
                 SET @mnozstviDok=@mnozstviDok - @Mnozstvi_VC 
                 IF @mnozstviDok<=0.0 BREAK 
                 FETCH NEXT FROM VyrCisNaPr INTO @IDVyrCisProGen, @IDVyrCisP_VC, @VyrCislo_VC, @Popis_VC, @Mnozstvi_VC, @DatExpirace_VC, @VypDatExpirace_VC, @DatVyroby_VC 
               END  
             CLOSE VyrCisNaPr 
             DEALLOCATE VyrCisNaPr 
           END 
         IF @IDOldPolozka IS NOT NULL 
           BEGIN 
             EXEC dbo.hp_OZGenPotvrPrijmyPrevod @IDPolozky 
             IF (@@ERROR<>0) GOTO CHYBA 
           END 
         IF OBJECT_ID(N'tempDB..#TabOdved_IDMzdy') IS NOT NULL 
           BEGIN 
             INSERT INTO TabPrikazMzdyAZmetkyGenPZ(IDMzdy, TypGen, IDPohybu) 
               SELECT G.IDMzdy, 2, @IDPolozky 
                 FROM #TabOdved_IDMzdy G 
                   INNER JOIN TabPrikazMzdyAZmetky MZ ON (MZ.ID=G.IDMzdy) 
                 WHERE G.IDPrikaz=@IDPrikaz 
           END 
         IF (@JeTopPrikaz=1) 
           IF EXISTS(SELECT*FROM TabHGlob WHERE NZB=1) 
           BEGIN 
             DECLARE crSezPlanu CURSOR FAST_FORWARD LOCAL FOR 
               SELECT PL.ID, PL.IDTabKmen 
                 FROM TabPrikazZdrojVyrPlan ZVP 
                   INNER JOIN TabPlan PL ON (PL.ID=ZVP.IDPlan) 
                 WHERE ZVP.IDPrikaz=@IDPrikaz AND 
                       EXISTS(SELECT*FROM TabZajistKryX WHERE Zpusob = 4 AND IDVyrPlan = PL.ID) 
             OPEN crSezPlanu 
             FETCH NEXT FROM crSezPlanu INTO @IDPlan, @IDKmeneZbozi_Plan 
             WHILE (@@fetch_status=0) AND (@MnozstviPoz>0.0) 
               BEGIN 
                 EXEC dbo.hp_NZB_DilciPrijemZVyroby @IDVyrPl=@IDPlan, @IDKmene=@IDKmeneZbozi_Plan, @IDPolozky=@IDPolozky, @Mnozstvi=@MnozstviPoz OUT 
                 FETCH NEXT FROM crSezPlanu INTO @IDPlan, @IDKmeneZbozi_Plan 
               END 
             CLOSE crSezPlanu 
             DEALLOCATE crSezPlanu 
           END 
           ELSE 
           BEGIN 
             DECLARE crSezPlanu CURSOR FAST_FORWARD LOCAL FOR 
               SELECT PL.ID, PL.IDTabKmen 
                 FROM TabPrikazZdrojVyrPlan ZVP 
                   INNER JOIN TabPlan PL ON (PL.ID=ZVP.IDPlan) 
                 WHERE ZVP.IDPrikaz=@IDPrikaz AND 
                       EXISTS(SELECT * FROM TabPlanZdrojOZ PlZ WHERE PlZ.IDPlan=PL.ID AND PlZ.GUIDDosObjR IS NOT NULL) 
             OPEN crSezPlanu 
             FETCH NEXT FROM crSezPlanu INTO @IDPlan, @IDKmeneZbozi_Plan 
             WHILE (@@fetch_status=0) AND (@MnozstviPoz>0.0) 
               BEGIN 
                 EXEC dbo.hp_DosleObj_DilciPrijemZVyroby @IDVyrPl=@IDPlan, @IDKmene=@IDKmeneZbozi_Plan, @IDPolozky=@IDPolozky, @Mnozstvi=@MnozstviPoz OUT 
                 FETCH NEXT FROM crSezPlanu INTO @IDPlan, @IDKmeneZbozi_Plan 
               END 
             CLOSE crSezPlanu 
             DEALLOCATE crSezPlanu 
           END 
         FETCH NEXT FROM polozky INTO @IDOdvedeni, @IDDilce, @IDZboSklad, @IDPrikaz, @mnozstviPoz, @IDOldPolozka, @CisloZakazky, @StredNaklad, @MJ, @GenerOdvVyrobkuVMJEvid, @CisloNOkruh, @IDStavUmisteni, @IDZakazModif, 
                                      @DatumProVypocetExpirace, @JeTopPrikaz 
       END 
      CLOSE polozky 
      DEALLOCATE polozky 
      EXEC hp_VypCenOZPolozek_IDDokladu @IDHlavicky, 0 
      IF (@@ERROR<>0) GOTO CHYBA 
      UPDATE DZ SET 
          StredNaklad=S.StredNaklad, 
          CisloZakazky=S.CisZak, 
          IDPrikaz=S.IDPrikaz, 
          NOkruhCislo=S.CisloNOkruh, 
          NavaznaObjednavka=ISNULL(S.NavaznaObjednavka, ''), 
          BlokovaniEditoru=NULL 
        FROM TabDokladyZbozi DZ 
          LEFT OUTER JOIN (SELECT CisZak=CASE WHEN MIN(ISNULL(PZ.CisloZakazky,''))=MAX(ISNULL(PZ.CisloZakazky,'')) THEN MIN(PZ.CisloZakazky) END, 
                                  StredNaklad=CASE WHEN MIN(ISNULL(PZ.StredNaklad,''))=MAX(ISNULL(PZ.StredNaklad,'')) THEN MIN(PZ.StredNaklad) END, 
                                  IDPrikaz=CASE WHEN MIN(ISNULL(PZ.IDPrikaz,0))=MAX(ISNULL(PZ.IDPrikaz,0)) THEN MIN(PZ.IDPrikaz) END, 
                                  CisloNOkruh=CASE WHEN MIN(ISNULL(PZ.CisloNOkruh,''))=MAX(ISNULL(PZ.CisloNOkruh,'')) THEN MIN(PZ.CisloNOkruh) END, 
                                  NavaznaObjednavka=CASE WHEN MIN(ISNULL(P.NavaznaObjednavka,''))=MAX(ISNULL(P.NavaznaObjednavka,'')) THEN MIN(P.NavaznaObjednavka) END 
                             FROM TabPohybyZbozi PZ 
                               LEFT OUTER JOIN TabPrikaz P ON (P.ID=PZ.IDPrikaz) 
                             WHERE PZ.IDDoklad=@IDHlavicky) S ON (1=1) 
        WHERE DZ.ID=@IDHlavicky 
      IF (@@ERROR<>0) GOTO CHYBA 
      INSERT INTO TabVKonJedDokZbo(IDKonJed, IDDokZbo) 
        SELECT V.IDKonJed, @IDHlavicky 
          FROM TabPohybyZbozi PZ 
            INNER JOIN TabPohybyZbozi PZ_Old ON (PZ_Old.ID=PZ.IDOldPolozka) 
            INNER JOIN TabVKonJedDokZbo V ON (V.IDDokZbo=PZ_Old.IDDoklad) 
          WHERE PZ.IDDoklad=@IDHlavicky 
          GROUP BY V.IDKonJed 
          HAVING NOT EXISTS(SELECT * FROM TabVKonJedDokZbo V2 WHERE V2.IDKonJed=V.IDKonJed AND V2.IDDokZbo=@IDHlavicky) 
      IF (@@ERROR<>0) GOTO CHYBA 
       IF OBJECT_ID(N'dbo.ep_GenerovaniDokladuOZ',N'P') IS NOT NULL 
         BEGIN 
           EXEC @Ret=dbo.ep_GenerovaniDokladuOZ @IDHlavicky 
           IF @@error<>0 OR @Ret<>0 GOTO CHYBA 
         END 
      FETCH NEXT FROM curSkladZak INTO @RadaDok, @Sklad, @IDZakazka, @IDPrikaz 
    END    
  CLOSE curSkladZak 
  DEALLOCATE curSkladZak 
 RETURN 0 
 CHYBA: 
   SELECT ID INTO #TabPomSeznamDZProDel FROM #TabGenPrijem 
   EXEC hp_SmazSeznamDokZbozi 
   DELETE #TabGenPrijem 
   UPDATE #TabOdved SET IDPohZbo=NULL 
   IF OBJECT_ID(N'TempDB..#TabVyrCisProGenOdv') IS NOT NULL  UPDATE #TabVyrCisProGenOdv SET IDVyrCP=NULL 
   IF @ErrID IS NOT NULL 
     BEGIN 
       SET @ErrMsg = dbo.hf_FormatError(@ErrID, @ErrMsg) 
       RAISERROR(@ErrMsg, 16, 1) 
     END 
   RETURN 1 
END
GO
