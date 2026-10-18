-- Referencni struktura; nespoustet nad existujici databazi Heliosu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabHGlob](
	[ID] [tinyint] NOT NULL,
	[KonverzePZ] [tinyint] NOT NULL,
	[VerzeDanovehoPriznani] [tinyint] NOT NULL,
	[PlatceDPH] [tinyint] NULL,
	[PoziceZaokrDPH] [tinyint] NOT NULL,
	[HraniceZaokrDPH] [tinyint] NOT NULL,
	[DruhSkladu] [tinyint] NOT NULL,
	[ShodaZakazek] [nchar](1) NOT NULL,
	[NulovyVydej] [nchar](1) NOT NULL,
	[Legislativa] [tinyint] NOT NULL,
	[DruhSlev] [tinyint] NULL,
	[VlastnostSlev] [tinyint] NULL,
	[SlevaSkupZbo] [tinyint] NULL,
	[SlevaKmenZbo] [tinyint] NULL,
	[SlevaStavSkladu] [tinyint] NULL,
	[SlevaZbozi] [tinyint] NULL,
	[SlevaOrg] [tinyint] NULL,
	[SlevaSozNa] [tinyint] NULL,
	[CenovaUroven] [int] NULL,
	[PlatnostNabCen] [tinyint] NOT NULL,
	[KontrolaStornaPrijmu] [tinyint] NOT NULL,
	[CasRozliseniSplatnosti] [smallint] NOT NULL,
	[CasRozliseniSplatnosti2] [smallint] NOT NULL,
	[CasRozliseniSplatnosti3] [smallint] NOT NULL,
	[CasRozliseniSplatnosti4] [smallint] NOT NULL,
	[CasRozliseniSplatnosti5] [smallint] NOT NULL,
	[CasRozliseniSplatnosti6] [smallint] NOT NULL,
	[ModeNapoctuCasRozliseni] [bit] NOT NULL,
	[ArchivaceZmenDenik] [bit] NOT NULL,
	[ArchivaceZmenKmenZbozi] [bit] NOT NULL,
	[ArchivaceZmenDokZbo] [bit] NOT NULL,
	[DelkaRegCislaZbozi] [tinyint] NOT NULL,
	[VerzeEXE] [nvarchar](12) NOT NULL,
	[VelikostEXE] [int] NOT NULL,
	[DatumEXE] [datetime] NOT NULL,
	[DatumPosledniKontroly] [datetime] NOT NULL,
	[DatumDistribTiskForm] [datetime] NOT NULL,
	[DatumDistribGenSes] [datetime] NOT NULL,
	[DatumDistribGenMzdy] [datetime] NOT NULL,
	[DatumDistribGenPers] [datetime] NOT NULL,
	[DatumDistribFiltru] [datetime] NOT NULL,
	[DatumDistribOpisu] [datetime] NOT NULL,
	[DatumDistribFIAVykazy] [datetime] NOT NULL,
	[DatumDistribFIAUkazatel] [datetime] NOT NULL,
	[DatumDistribFIABLegis] [datetime] NOT NULL,
	[DatumDistribFIABSkupDok] [datetime] NOT NULL,
	[SkladSluzeb] [nvarchar](30) NULL,
	[U2N_XAPI_Server] [nvarchar](30) NOT NULL,
	[U2N_XAPI_Port] [int] NOT NULL,
	[U2N_XAPI_Timeout] [int] NOT NULL,
	[U2N_XAPI_User] [nvarchar](20) NOT NULL,
	[U2N_XAPI_Password] [nvarchar](20) NOT NULL,
	[U2N_XAPI_AutoHlidani] [bit] NOT NULL,
	[HlidatKonstSym] [bit] NOT NULL,
	[BankaKonstSymbPovinny] [bit] NOT NULL,
	[BankaMinOffExpSplatnoZa] [smallint] NOT NULL,
	[BankaMinOffExpSplatnoTu] [smallint] NOT NULL,
	[BankaMaxPocetRadkuTu] [smallint] NOT NULL,
	[BankaOpisPoExpTu] [bit] NOT NULL,
	[BankaOpisPoExpZa] [bit] NOT NULL,
	[BankaPruvodkaPoExpTu] [bit] NOT NULL,
	[BankaPruvodkaPoExpZa] [bit] NOT NULL,
	[BankaVypisCisloDokladu] [tinyint] NOT NULL,
	[BankaVypisDatumPripadu] [tinyint] NOT NULL,
	[BankaVypisStopPriChybe] [bit] NOT NULL,
	[BankaVypisNenalezenUcet] [tinyint] NOT NULL,
	[BankaVypisSpecUcet] [nvarchar](30) NULL,
	[BankaVypisHledatUcetZam] [tinyint] NOT NULL,
	[BankaVypisHledatCastku] [tinyint] NOT NULL,
	[BankaVypisPrepocetMeny] [bit] NOT NULL,
	[BankaVypisHledatVarSym] [bit] NOT NULL,
	[BanVypHledatVSKdyzViceBS] [bit] NOT NULL,
	[BankaVypisOdkudKurzProR] [tinyint] NOT NULL,
	[BankaVypisKdeBratKurzR] [tinyint] NOT NULL,
	[BankaVypisJakHledatKurz] [tinyint] NOT NULL,
	[BankaVypisJakTretiMenu] [tinyint] NOT NULL,
	[BankaVypisJakSumace] [tinyint] NOT NULL,
	[BankaPouzivatDispSymb] [bit] NOT NULL,
	[ZarovnaniRegCislaZbozi] [tinyint] NOT NULL,
	[Davka] [tinyint] NOT NULL,
	[Tarif] [tinyint] NOT NULL,
	[MaxVnoreni] [int] NOT NULL,
	[Proc_ztrat] [numeric](5, 2) NOT NULL,
	[Prub_doba] [numeric](19, 6) NOT NULL,
	[Davka_TEC] [tinyint] NOT NULL,
	[DelkaPoziceKV] [tinyint] NOT NULL,
	[ZarovnaniPoziceKV] [tinyint] NOT NULL,
	[DatumUcUzavNV] [datetime] NULL,
	[FiltrNaCislo] [tinyint] NOT NULL,
	[MaxZaokrouhleniPokl] [numeric](19, 6) NOT NULL,
	[LhutaSplatnosti] [smallint] NOT NULL,
	[DUDProPreuctovani] [nvarchar](3) NULL,
	[AppRole] [nvarchar](128) NOT NULL,
	[AppRoleP] [nvarchar](255) NOT NULL,
	[TrideniPolozekVTiskuDokladu] [tinyint] NOT NULL,
	[NenalezenoSozNa] [tinyint] NOT NULL,
	[SlevaSoucetAnoNe] [tinyint] NOT NULL,
	[TypPrevoduVydejkyPrevodky] [tinyint] NOT NULL,
	[OblibenyTypPolozkovehoPrevodu] [tinyint] NOT NULL,
	[PevnaCastCarovehoKodu] [nvarchar](12) NOT NULL,
	[TypCarovehoKodu] [tinyint] NULL,
	[CisloOrgMin] [int] NULL,
	[CisloOrgMax] [int] NULL,
	[BlokovatMimoRozsah] [bit] NOT NULL,
	[MzdovaSlozUkolMzd] [int] NULL,
	[MzdovaSlozUhradZmet] [int] NULL,
	[ZdrojTarifuProMzdy_Nor] [tinyint] NOT NULL,
	[ZdrojTarifuProMzdy_Cas] [tinyint] NOT NULL,
	[UctovaniZapoctu] [tinyint] NOT NULL,
	[AutomatPoklDokl] [tinyint] NOT NULL,
	[DatumSplatnostiPrFa] [tinyint] NOT NULL,
	[KumulaceObratu] [tinyint] NOT NULL,
	[KumulaceObratuMesic] [bit] NOT NULL,
	[PovolitNevyrovnane] [bit] NOT NULL,
	[PovolitStareVykazy] [bit] NOT NULL,
	[Penale] [tinyint] NOT NULL,
	[VerzeSyntet] [nvarchar](10) NOT NULL,
	[NapocetSaldoOrg] [tinyint] NOT NULL,
	[DeIdentifikaceUhrad] [tinyint] NOT NULL,
	[RezimPenalizace] [tinyint] NOT NULL,
	[DERezimPreuctovani] [bit] NOT NULL,
	[RefreshDeniku] [bit] NOT NULL,
	[MinRozdilDanUcEv] [numeric](19, 6) NOT NULL,
	[ECDataLoaderPath] [nvarchar](255) NOT NULL,
	[ECUseDataLoader] [bit] NOT NULL,
	[OZSouvisNakl1] [nvarchar](30) NULL,
	[OZSouvisNakl2] [nvarchar](30) NULL,
	[OZSouvisNakl3] [nvarchar](30) NULL,
	[OZSouvisNakl4] [nvarchar](30) NULL,
	[OZSouvisNakl5] [nvarchar](30) NULL,
	[OZSouvisNakl6] [nvarchar](30) NULL,
	[OZSouvisNakl7] [nvarchar](30) NULL,
	[OZSouvisNaklProc1] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc2] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc3] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc4] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc5] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc6] [numeric](5, 2) NOT NULL,
	[OZSouvisNaklProc7] [numeric](5, 2) NOT NULL,
	[OZSNHlidatZadani] [bit] NOT NULL,
	[OZSNPrevod] [int] NOT NULL,
	[OZSNTypRozpousteni1] [tinyint] NOT NULL,
	[OZSNTypRozpousteni2] [tinyint] NOT NULL,
	[OZSNTypRozpousteni3] [tinyint] NOT NULL,
	[OZSNTypRozpousteni4] [tinyint] NOT NULL,
	[OZSNTypRozpousteni5] [tinyint] NOT NULL,
	[OZSNTypRozpousteni6] [tinyint] NOT NULL,
	[OZSNTypRozpousteni7] [tinyint] NOT NULL,
	[RuznySkladNaPolAHla] [tinyint] NOT NULL,
	[PozicePrvnihoZnakuCarovehoKodu] [tinyint] NOT NULL,
	[DelkaVarCastiCarovehoKodu] [tinyint] NOT NULL,
	[KdeVzitCarovyKod] [tinyint] NOT NULL,
	[HistorickeCenyNakup] [nchar](1) NOT NULL,
	[HistorickeCenyProdej] [nchar](1) NOT NULL,
	[MjVydejEvCena] [tinyint] NOT NULL,
	[EmailHotline] [nvarchar](50) NOT NULL,
	[RezimPrav] [bit] NOT NULL,
	[EditaceNegPrava] [bit] NOT NULL,
	[LogovatPrava] [bit] NOT NULL,
	[BlokovaniUcDokFaze] [bit] NOT NULL,
	[ModeImportDenikDOS] [tinyint] NOT NULL,
	[ImportDenikVazbaOZ] [bit] NOT NULL,
	[RozdilDatPripadDUZP] [int] NOT NULL,
	[ZadaniPolozekDokladOZ] [int] NOT NULL,
	[PolPrevodPrenosCislaSkladu] [nchar](1) NOT NULL,
	[KompletPrevod] [nchar](1) NOT NULL,
	[DoplneniObdobiStavuOZ] [tinyint] NOT NULL,
	[ZaokrDPHvaluty] [tinyint] NOT NULL,
	[OZHromadnaRealizace_DruhDatumu] [tinyint] NOT NULL,
	[Intr_KontrolovatCN] [bit] NOT NULL,
	[MnozstviNovehoVC] [tinyint] NOT NULL,
	[StinRezim] [tinyint] NOT NULL,
	[ArchivaceZmenPokladna] [bit] NOT NULL,
	[ArchivaceZmenNC] [bit] NOT NULL,
	[ZobrPoctuDMNabCen] [tinyint] NOT NULL,
	[ZobrPoctuDMMnozstvi] [tinyint] NULL,
	[ClaExpCisloDleNastPar] [bit] NOT NULL,
	[NCTSAllowDelete] [bit] NOT NULL,
	[ClaAutoClose] [bit] NOT NULL,
	[DatSplatPocitatOd] [tinyint] NOT NULL,
	[FakPoziceZaokrDPH] [tinyint] NOT NULL,
	[FakHraniceZaokrDPH] [tinyint] NOT NULL,
	[UctPoziceZaokrDPH] [tinyint] NOT NULL,
	[UctHraniceZaokrDPH] [tinyint] NOT NULL,
	[PokPoziceZaokrDPH] [tinyint] NOT NULL,
	[PokHraniceZaokrDPH] [tinyint] NOT NULL,
	[OddelenaDatabaze] [tinyint] NOT NULL,
	[DatumDeleniDat] [datetime] NULL,
	[ArchivaceZmenKontaktJednani] [bit] NOT NULL,
	[FakKoeficientDPH] [bit] NOT NULL,
	[ZaokrPoklDokNa50] [nchar](1) NOT NULL,
	[PrevodSluzebNaVYDzEXP] [nchar](1) NOT NULL,
	[RozhodneMnozstviNaVYDzEXP] [tinyint] NOT NULL,
	[PoklProdZaokrouhlitNa50] [smallint] NOT NULL,
	[PoklProdCenUrovenProdej] [int] NULL,
	[PoklProdCenUrovenEtalon] [int] NULL,
	[PoklProdHledatPLUKod] [bit] NOT NULL,
	[PoklProdZpusobZadani] [tinyint] NOT NULL,
	[PoklProdVychoziMnozstvi] [tinyint] NOT NULL,
	[PoklProdTestMnozstvi] [tinyint] NOT NULL,
	[PoklProdUlozBezUhrad] [bit] NOT NULL,
	[PoklProdZpusobUhrady1] [nvarchar](30) NULL,
	[PoklProdZpusobUhrady2] [nvarchar](30) NULL,
	[PoklProdZpusobUhrady3] [nvarchar](30) NULL,
	[PoklProdZpusobUhrady4] [nvarchar](30) NULL,
	[PoklProdZpusobUhrady5] [nvarchar](30) NULL,
	[PoklProdOdberatel] [int] NULL,
	[PoklProdOrgPovinna] [bit] NOT NULL,
	[PoklProdOrgPredDokladem] [bit] NOT NULL,
	[PoklProdOrgZmenaDoklad] [bit] NOT NULL,
	[PoklProdOrgPoradiPoli] [tinyint] NOT NULL,
	[PoklProdBKPlatbaLimit] [int] NOT NULL,
	[PoklProdBKPlatbaMaxProc] [numeric](5, 2) NOT NULL,
	[PoklProdBKPrvniBody] [int] NOT NULL,
	[PoklProdBKTypProEI] [tinyint] NOT NULL,
	[PoklProdBKBylEI] [bit] NOT NULL,
	[PoklProdBKIdent] [nvarchar](36) NOT NULL,
	[UctoJakHledatKurzProDPH] [tinyint] NOT NULL,
	[UctoJakHledatKurzProZap] [tinyint] NOT NULL,
	[OddelovacExportDenik] [tinyint] NOT NULL,
	[NeaktEvMnozstviEvStav] [tinyint] NOT NULL,
	[MaxPocetRadkuPD] [smallint] NOT NULL,
	[CRMKontaktyPrenos] [smallint] NOT NULL,
	[GenerovatStornoDobropisDatum] [tinyint] NOT NULL,
	[PouzitPrednastavenouCU] [tinyint] NOT NULL,
	[ExtEd_EditovatVEditoru] [bit] NOT NULL,
	[OZFiltrujNSCtrlEnter] [bit] NOT NULL,
	[OZFiltrujNSCtrlN] [bit] NOT NULL,
	[DohledatCenyDle] [tinyint] NOT NULL,
	[ZaokrDPHMalaCisla] [tinyint] NOT NULL,
	[BankaVypisDatumUhrady] [tinyint] NOT NULL,
	[OldCelSazImport] [datetime] NULL,
	[PoklProdRegCisPodleOZ] [bit] NOT NULL,
	[PoklProdDelkaRegCisBal] [tinyint] NOT NULL,
	[PoklProdZarovRegCisBal] [tinyint] NOT NULL,
	[PoklProdCKPodleOZ] [bit] NOT NULL,
	[PoklProdCKPevnaCast] [nvarchar](12) NOT NULL,
	[PoklProdCKTyp] [tinyint] NULL,
	[PoklProdCKPozice1Znaku] [tinyint] NOT NULL,
	[PoklProdCKDelkaVarCasti] [tinyint] NOT NULL,
	[PoklProdCKKdeVzit] [tinyint] NOT NULL,
	[IntervalObnovyWF] [int] NOT NULL,
	[OZUmistMetodaVydej] [tinyint] NOT NULL,
	[FakZalohyDleVal] [tinyint] NOT NULL,
	[KontrolaPZUcto] [bit] NOT NULL,
	[FazeEuro] [tinyint] NOT NULL,
	[ArchivaceZmenBankSp] [bit] NOT NULL,
	[ArchivaceZmenZamMzd] [bit] NOT NULL,
	[ArchivaceZmenCisZam] [bit] NOT NULL,
	[MzAlias] [bit] NOT NULL,
	[MzAliasLen] [tinyint] NOT NULL,
	[Intr_HlidatShoduSoudku] [bit] NOT NULL,
	[BankaVypisUctovani] [tinyint] NOT NULL,
	[DatSkontaPocitatOd] [tinyint] NOT NULL,
	[PoklProdKontrolaZadaniVC] [bit] NOT NULL,
	[GenerovaniZNerealFakt] [nchar](1) NOT NULL,
	[PoklProdUzaverkaAktCas] [bit] NOT NULL,
	[DatumPrechoduNaEuro] [datetime] NOT NULL,
	[DUOkurz] [numeric](19, 6) NOT NULL,
	[ArchivaceZmenMzdOdpPolMzd] [bit] NOT NULL,
	[ZaokrouhleniUhradyPokl] [smallint] NOT NULL,
	[BankaUhradyHledatProti] [bit] NOT NULL,
	[ECertByName] [nvarchar](128) NOT NULL,
	[ECertToName] [nvarchar](128) NOT NULL,
	[ECertSN] [nvarchar](128) NOT NULL,
	[ECertStoreLocation] [tinyint] NOT NULL,
	[ECertStoreName] [tinyint] NOT NULL,
	[BankaExportUdajuZamTu] [bit] NOT NULL,
	[BankaExportZmenaZamTu] [bit] NOT NULL,
	[BankaExportUdajuZamZa] [bit] NOT NULL,
	[BankaExportZmenaZamZa] [bit] NOT NULL,
	[BankaVypisDotahovatZam] [bit] NOT NULL,
	[PoklProdKurzHMNaBody] [numeric](19, 6) NOT NULL,
	[DruhSkladuSN] [tinyint] NOT NULL,
	[OZStoPBezEdiSN] [bit] NOT NULL,
	[CRMCestaKSouboru] [nvarchar](255) NOT NULL,
	[CRMSaveToDBOrToDoc] [bit] NOT NULL,
	[CRMSledovatHistorii] [bit] NOT NULL,
	[CRMReplaceFile] [bit] NOT NULL,
	[ArchivaceZmenDosleObjH20] [bit] NOT NULL,
	[OdpocetDaneRoky] [bit] NOT NULL,
	[OZUmistJenPV] [tinyint] NOT NULL,
	[OZPrepMJnaVC] [bit] NOT NULL,
	[CRMUseDynFolder] [bit] NOT NULL,
	[CRMDynFolder] [nvarchar](100) NOT NULL,
	[OZDSNPrevod] [int] NOT NULL,
	[PoklProdVzdyZobrazVratit] [bit] NOT NULL,
	[MzPDF1] [int] NULL,
	[MzPDF2] [int] NULL,
	[MzPDF3] [int] NULL,
	[MzPDF4] [int] NULL,
	[ECertLDAPQuery] [nvarchar](255) NOT NULL,
	[CRMPovinnaKat] [tinyint] NOT NULL,
	[CRMDatumUzaverkyPlneni] [datetime] NULL,
	[CRMVychoziStavPodkladu] [tinyint] NOT NULL,
	[BankaExportTestSouborTu] [bit] NOT NULL,
	[BankaExportTestSouborZa] [bit] NOT NULL,
	[ClaAutoCloseCRPRO] [bit] NOT NULL,
	[UctovaniTXTPolozekFA] [bit] NOT NULL,
	[TypZmenyZapocty] [int] NULL,
	[OZRozUmiDleVC] [bit] NOT NULL,
	[BankaVypisTypZmenyKredit] [int] NULL,
	[BankaVypisTypZmenyDebet] [int] NULL,
	[DobaMeziPrikazy] [numeric](19, 6) NOT NULL,
	[TypPlanovaciDoby] [tinyint] NOT NULL,
	[TypZmenyDebet] [int] NULL,
	[ZpravyLogovani] [bit] NOT NULL,
	[AutoCislovaniPoziceKV] [bit] NOT NULL,
	[NevyrovnanyZapocet] [bit] NOT NULL,
	[ZadaniPolozekSkladOZ] [int] NOT NULL,
	[OZVypocetSumaKcPoZao] [tinyint] NOT NULL,
	[PoklProdVypocetSumaKcPoZao] [tinyint] NOT NULL,
	[OZZapoctiStornoDoOdebMnoz] [bit] NOT NULL,
	[CertDatumOd] [datetime] NULL,
	[CertDatumDo] [datetime] NULL,
	[SmazatKurzovniListek] [bit] NOT NULL,
	[BankaUhradyDejNaUhrazene] [tinyint] NOT NULL,
	[BankaVypisTypZmenyBUKredit] [int] NULL,
	[BankaVypisTypZmenyBUDebet] [int] NULL,
	[KartoveCentrumUctovaniDatum] [tinyint] NOT NULL,
	[ClaImportCiselniku] [datetime] NULL,
	[OZPovolZaporMnozPol] [bit] NOT NULL,
	[OZOdebMnozNekonRetez] [bit] NOT NULL,
	[OZInvItemZpusobZadani] [tinyint] NOT NULL,
	[NavazDokMaxLevel] [tinyint] NOT NULL,
	[ObdStavuUctoSkladu] [tinyint] NOT NULL,
	[ZastavitRealizaciOZ] [bit] NOT NULL,
	[ArchivaceZmenSkupinaZbozi] [bit] NOT NULL,
	[BankaUhradyLeasing] [bit] NOT NULL,
	[BankaVypisRuzneOrgZam] [bit] NOT NULL,
	[AplikovatKVOPouzeNaTAC] [bit] NOT NULL,
	[KompletEdit] [bit] NOT NULL,
	[MzSeskupeniRC] [bit] NOT NULL,
	[CRMHlidaniPoctuHodin] [tinyint] NOT NULL,
	[FakPouzitOpravuUSkonta] [bit] NOT NULL,
	[OZStornoCastecneMnozSN] [bit] NOT NULL,
	[KartoveCentrumUctovaniDatumKurz] [tinyint] NOT NULL,
	[KartoveCentrumPoplatkyTypUhrady] [tinyint] NOT NULL,
	[KartoveCentrumPoplatkyUcetVazba] [int] NULL,
	[DOBJZapoctiStornoCiDobropis] [bit] NOT NULL,
	[ZajisteniDPHPovolitSledovaniNespolehPlatcuABankUctu] [bit] NOT NULL,
	[ZajisteniDPHAutoOnlineOvereniNaDokladu] [bit] NOT NULL,
	[ZajisteniDPHZpusobOznacProKontroluNespolehPlatce] [tinyint] NOT NULL,
	[ZajisteniDPHZpusobOznacProKontroluZverejBankUcty] [tinyint] NOT NULL,
	[ZajisteniDPHInfoPriVystTuzPP] [bit] NOT NULL,
	[ZajisteniDPHLogovatPouziti] [bit] NOT NULL,
	[PAPDokladyPS] [bit] NOT NULL,
	[PAPDokladyDruhyUcet] [bit] NOT NULL,
	[PAPDokladyPAP] [bit] NOT NULL,
	[PAPDokladyStranaTZ] [bit] NOT NULL,
	[PAPDokladyPartnerT] [bit] NOT NULL,
	[PAPDokladySpoustet] [bit] NOT NULL,
	[PAPDokladyICO] [bit] NOT NULL,
	[PAPVykazy] [bit] NOT NULL,
	[PAPVykazyPrilohy] [bit] NOT NULL,
	[PAPVykazyPAP] [bit] NOT NULL,
	[PAPVykazyPouzeChyby] [bit] NOT NULL,
	[PAPICONazev] [nvarchar](40) NOT NULL,
	[LhutaSplatnostiDodavatel] [smallint] NOT NULL,
	[BankaUhradyPrirazeniVydFak] [tinyint] NOT NULL,
	[VychoziStavBlokaceVyroby] [tinyint] NOT NULL,
	[UzavObdEditovatText] [bit] NOT NULL,
	[UzavObdEditovatPZ] [bit] NOT NULL,
	[UzavObdEditovatOrg] [bit] NOT NULL,
	[OZPovolEditVyrCS] [bit] NOT NULL,
	[PAPDokladyNevyplPol] [bit] NOT NULL,
	[UzavObdEditovatDD] [bit] NOT NULL,
	[BrowseImpDenik] [bit] NOT NULL,
	[OZCopyRozpisUmist] [tinyint] NOT NULL,
	[KontrVykDPH] [bit] NOT NULL,
	[ArchivaceZmenDosleObjH02] [bit] NOT NULL,
	[LimitPDP] [numeric](19, 6) NOT NULL,
	[KontrolaDPH] [bit] NOT NULL,
	[OZVykazLihu] [tinyint] NOT NULL,
	[OZVykazLihuPodleData] [tinyint] NOT NULL,
	[CRMVychoziPlneniFakturace] [tinyint] NOT NULL,
	[ZajisteniDPHLimitUplaty] [numeric](19, 6) NOT NULL,
	[NulovyVydejUct] [nchar](1) NOT NULL,
	[ZaplaceneFakturyZohlednovatK] [tinyint] NOT NULL,
	[FakZalohyAutomat] [bit] NOT NULL,
	[OvereniDICLogovatKazdeOvereni] [bit] NOT NULL,
	[OvereniDICVyzadatUnikCisloKonzultace] [bit] NOT NULL,
	[BankaImpPouzeVypisUctuVlastniFirmy] [bit] NOT NULL,
	[FakZalohyKraceni] [bit] NOT NULL,
	[DohledatScontoDle] [tinyint] NOT NULL,
	[BlokDenikStavy] [bit] NOT NULL,
	[CLAImportyOrgNeurcitaZalozitOrg] [bit] NOT NULL,
	[OZGetSazbuDPHOldKme] [bit] NOT NULL,
	[OZRezimKurzuDPHFaktur] [tinyint] NOT NULL,
	[CRMVychoziMenaPodkladuZS] [tinyint] NOT NULL,
	[CRMGenerovatPodkladZS] [tinyint] NOT NULL,
	[CisloOrgSSCC] [nvarchar](10) NOT NULL,
	[KurzPriGenerPolozDokladu] [tinyint] NOT NULL,
	[FaktZapoctyGenerKurzRozdilyPriUhrade] [tinyint] NOT NULL,
	[FaktZapoctyCastecKurzRozdily] [tinyint] NOT NULL,
	[DruhDokladuPenFak] [nvarchar](3) NOT NULL,
	[BankaUhradyPenFak] [bit] NOT NULL,
	[UcetZaokrNaklad] [nvarchar](30) NULL,
	[UcetZaokrVynos] [nvarchar](30) NULL,
	[MaskaDK] [nvarchar](8) NOT NULL,
	[KontrHlaDPH] [bit] NOT NULL,
	[ZvlastniUpravaSK] [bit] NOT NULL,
	[CenovaUrovenNakup] [int] NULL,
	[PouzivatDanoveKlice] [bit] NOT NULL,
	[NapocetSaldoSloupce] [bit] NOT NULL,
	[OZVisibleDPHOldKme] [bit] NOT NULL,
	[PouzitPrednastaCUNakup] [tinyint] NOT NULL,
	[ZarovnaniOperaceTechPos] [tinyint] NOT NULL,
	[KHNaslKontrola] [bit] NOT NULL,
	[BankaVypisUcetProPrevodMeziVlastnimiBU] [nvarchar](30) NULL,
	[MetodaSkladu] [tinyint] NOT NULL,
	[KHKontrolaDenik] [bit] NOT NULL,
	[KVKontrolaDenik] [bit] NOT NULL,
	[PouzivatEET] [int] NOT NULL,
	[EETOverovaciRezim] [bit] NOT NULL,
	[EETPokladniProdej] [nvarchar](16) NOT NULL,
	[EETPokladna] [nvarchar](16) NOT NULL,
	[EETUhradaFaktury] [nvarchar](13) NOT NULL,
	[EETIDCertifikatu] [int] NULL,
	[PouzivatDic_Poverujiciho] [bit] NOT NULL,
	[PouzivatCestovniSluzbu] [bit] NOT NULL,
	[PouzivatPouziteZbozi] [bit] NOT NULL,
	[PouzivatCerpani] [bit] NOT NULL,
	[EETProdukcni] [bit] NOT NULL,
	[ProxyServer] [nvarchar](255) NOT NULL,
	[ProxyUser] [nvarchar](128) NOT NULL,
	[ProxyPassword] [nvarchar](255) NOT NULL,
	[ArchivaceZmenMzPaus] [bit] NOT NULL,
	[MetodaEvidCeny] [tinyint] NOT NULL,
	[QR_MSGPlatba] [int] NOT NULL,
	[QR_MSGPlatbaText] [nvarchar](60) NOT NULL,
	[QR_MSGFaktura] [int] NOT NULL,
	[QR_MSGFakturaText] [nvarchar](40) NOT NULL,
	[BankaUhradyPrirazeniVydFak1] [tinyint] NOT NULL,
	[BankaUhradyPrirazeniVydFak2] [tinyint] NULL,
	[BankaUhradyPrirazeniVydFak3] [tinyint] NULL,
	[CenySlevyNakup] [tinyint] NOT NULL,
	[BankaVUcelPlatPrenosPZ2] [bit] NOT NULL,
	[BankaUhradyNeprirazovatFakturyPoSplatnosti] [int] NOT NULL,
	[BankaUhradyHledatVSvUceluPlatby] [bit] NOT NULL,
	[PreucCZ] [bit] NOT NULL,
	[PouzivatOrgBankSpojArch] [bit] NOT NULL,
	[PouzivatPZ2] [bit] NOT NULL,
	[DoplnDenikPZ2] [bit] NOT NULL,
	[NeExportZamKOs] [bit] NOT NULL,
	[OZNCdleMJ] [bit] NOT NULL,
	[OZNahPlneni] [tinyint] NOT NULL,
	[CRMRozsireneCenySlevy] [tinyint] NOT NULL,
	[RozkopDatum] [datetime] NULL,
	[RozkopJeMzdObd] [bit] NOT NULL,
	[RozkopMzdDatum] [datetime] NULL,
	[RozkopMazatLOG] [bit] NOT NULL,
	[ZalSkladSolo] [bit] NOT NULL,
	[IntrDatumPrevoduCNMinRok] [datetime] NULL,
	[ZapoctyPosuzovat] [tinyint] NOT NULL,
	[ZapoctyRuzneMeny] [tinyint] NOT NULL,
	[ZapoctyNeFaPoSpla] [int] NOT NULL,
	[ZapoctyUctoFA] [bit] NOT NULL,
	[ZapoctyDUDFA] [nvarchar](3) NULL,
	[ZapoctyObdStavuFA] [tinyint] NOT NULL,
	[ZapoctyUctoSAL] [bit] NOT NULL,
	[ZapoctyDUDSAL] [nvarchar](3) NULL,
	[ZapoctyObdStavuSAL] [tinyint] NOT NULL,
	[UzavObdEditovatUtv] [bit] NOT NULL,
	[UzavObdEditovatZak] [bit] NOT NULL,
	[UzavObdEditovatNO] [bit] NOT NULL,
	[UzavObdEditovatVoz] [bit] NOT NULL,
	[UzavObdEditovatZam] [bit] NOT NULL,
	[KontrolaDuplPZObdobi] [tinyint] NULL,
	[KontrolaDuplPZPocetO] [int] NOT NULL,
	[KontrolaDuplPZUcty] [tinyint] NOT NULL,
	[PouzivatPomerKoef] [tinyint] NOT NULL,
	[OprPolPredSpla] [bit] NOT NULL,
	[OZDSNKontrolaTrg] [bit] NOT NULL,
	[OZVykazLihuOrgBezICO] [tinyint] NOT NULL,
	[OZPovolEditVyrCSNovy] [bit] NOT NULL,
	[OZPrevDrziCCEvid] [bit] NOT NULL,
	[DatumZrusKoefDPH] [datetime] NOT NULL,
	[CRMKategorieCRM] [nvarchar](3) NULL,
	[LogSestavZapnout] [bit] NOT NULL,
	[LogSestavCasLimit] [int] NOT NULL,
	[ZajisteniDPHAutoZalozeniZverejBankUctu] [bit] NOT NULL,
	[OZMarze] [bit] NOT NULL,
	[OZMarze_Doklad] [bit] NOT NULL,
	[OZMarze_Polozka] [bit] NOT NULL,
	[Zal30] [bit] NOT NULL,
	[UpozornovatNaNenavazanouZalohu] [bit] NOT NULL,
	[ZajisteniDPHtabSKPlatciDPHNaZruseni] [bit] NOT NULL,
	[ZajisteniDPHtabSKPlatciDPHVymazani] [bit] NOT NULL,
	[ZajisteniDPHtabSKPlatciDPHOsobUprava] [bit] NOT NULL,
	[ZajisteniDPHtabSKDanDluznici] [bit] NOT NULL,
	[ZajisteniDPHtabSKDanSubjRegSD] [bit] NOT NULL,
	[ZajisteniDPHKontrolovatPlatceNaZruseni] [bit] NOT NULL,
	[AktMnozKVyr_VsechnySkl] [bit] NOT NULL,
	[PK_MaxPocetZnakuMnozstvi] [tinyint] NOT NULL,
	[SeskupitCasRozliseni] [bit] NOT NULL,
	[FiltrGlobal] [bit] NOT NULL,
	[ZalSkladPK] [bit] NOT NULL,
	[UhrKartaFakEET] [bit] NOT NULL,
	[PoklProdHledatEANKod] [bit] NOT NULL,
	[PoklProdHledatVahaKod] [bit] NOT NULL,
	[OZSkladPriDatumHist] [datetime] NOT NULL,
	[OZSlepaProcCena] [tinyint] NOT NULL,
	[PoklProdVychoziZUStorno] [tinyint] NOT NULL,
	[PoklProdVychoziZUVratka] [tinyint] NOT NULL,
	[AplikujSlevyIProMinusovePolozky] [tinyint] NOT NULL,
	[BankaUhradyVysledekAPU] [bit] NOT NULL,
	[BankaUhradyVysledekPrUcto] [bit] NOT NULL,
	[OZTrgInsertVyrCK] [bit] NOT NULL,
	[MzIRDblCheck] [bit] NOT NULL,
	[KHAktualUzav] [tinyint] NOT NULL,
	[KVAktualUzav] [tinyint] NOT NULL,
	[KontrolaDuplicityPZ2] [tinyint] NOT NULL,
	[KontrolaSmerPlneni] [tinyint] NOT NULL,
	[OZShodaVCSVyrCK] [bit] NOT NULL,
	[OZDSNMetodaStoV] [bit] NOT NULL,
	[PoklLimitPlatebHotovCastka] [numeric](19, 6) NOT NULL,
	[PoklLimitPlatebHotovKontrola] [tinyint] NOT NULL,
	[OvereniDICAktualniDIC] [bit] NOT NULL,
	[PoziceZaokrPriPrepoctuCasuTechPos] [tinyint] NOT NULL,
	[ZajisteniDPHSKRegistrovaneSubjekty] [bit] NOT NULL,
	[ZajisteniDPHSKKontrolovatSubjekty] [bit] NOT NULL,
	[UctoJakHledatKurzProNZ] [tinyint] NOT NULL,
	[BankaUhradyPresnaCastka] [bit] NOT NULL,
	[OZNoveVCProExistVyrCK] [bit] NOT NULL,
	[OZTrgHlidaZaporneVC] [bit] NOT NULL,
	[BankaBSHledatTu] [bit] NOT NULL,
	[BankaPrenosFakturyZvs] [bit] NOT NULL,
	[PoklProdHledatNazev] [bit] NOT NULL,
	[PoklProdTestMnozTyp] [tinyint] NOT NULL,
	[FakOdpocetZaloh] [tinyint] NOT NULL,
	[DatumPoslednihoLogu] [datetime] NOT NULL,
	[OrgPravniForma] [tinyint] NOT NULL,
	[OZMakeSkladPriNewVC] [bit] NOT NULL,
	[NZB] [bit] NOT NULL,
	[DatumDistribLayoutDef] [datetime] NOT NULL,
	[NotifikaceProdlevaMazani] [int] NOT NULL,
	[NotifikaceIntervalCheckovani] [int] NOT NULL,
	[Notifikace_TypPushNotifikace] [smallint] NOT NULL,
	[StromNS] [bit] NOT NULL,
	[KontrolaDuplPZZapnuta]  AS (CONVERT([bit],case when [KontrolaDuplPZObdobi] IS NOT NULL then (1) else (0) end)),
	[BankaAutoUhrDleSym] [bit] NOT NULL,
	[ZalHalKorekce] [bit] NOT NULL,
	[PoklProdHledatZakaznik] [bit] NOT NULL,
	[DatumBrexitXI] [datetime] NULL,
	[BankaBSHledatProti] [bit] NOT NULL,
	[BankaBSHledatJedin] [bit] NOT NULL,
	[BankaUhradyPresnaCastkaLea] [bit] NOT NULL,
	[OZStromVC] [bit] NOT NULL,
	[OZFilNulVC] [bit] NOT NULL,
	[OZNCdleDatumOdDo] [bit] NOT NULL,
	[PovolitDoValutHM] [bit] NOT NULL,
	[BanVypHledatPomText] [bit] NOT NULL,
	[OZStromVcetneUmi] [bit] NOT NULL,
	[OZPohybyVCPodPolo] [bit] NOT NULL,
	[NavazDokInfoPanelMaxLevel] [tinyint] NOT NULL,
	[PoklProdHledatNazObsah] [bit] NOT NULL,
	[PoklProdHledatVouchery] [bit] NOT NULL,
	[PoklProdKartNevybVouch] [int] NULL,
	[PoklProdVychoziUhrada] [tinyint] NOT NULL,
	[PoklProdVychoziVyplnit] [bit] NOT NULL,
	[RezimMOSSDatumDo] [datetime] NOT NULL,
	[LogMonitorActionFrekvence] [smallint] NOT NULL,
	[GenDDPPRealFaPosuzovat] [tinyint] NOT NULL,
	[BankaVUcelPlatPrenosPZ] [bit] NOT NULL,
	[BankaVUcelPlatPrenosOrgZam] [bit] NOT NULL,
	[BankaVUcelPlatPrenosPopisDod] [bit] NOT NULL,
	[BankaVUcelPlatPrenosObjednavka] [bit] NOT NULL,
	[MazatDenUzavVykaz] [bit] NOT NULL,
	[OZMetodaVCRealKD] [tinyint] NOT NULL,
	[OZSlevyBezRecykl] [bit] NOT NULL,
	[HlidatVazbyUctuDimenze] [tinyint] NOT NULL,
	[HlidatVazbyUctuUcet] [tinyint] NOT NULL,
	[PovolitVazbyUctuPred] [bit] NOT NULL,
	[PovolitVazbyUctuFiltr] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky1] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky2] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky3] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky4] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky5] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky6] [bit] NOT NULL,
	[OZSNPolozkaDoFaPZPrijemky7] [bit] NOT NULL,
	[OZSNKmenKarta1] [int] NULL,
	[OZSNKmenKarta2] [int] NULL,
	[OZSNKmenKarta3] [int] NULL,
	[OZSNKmenKarta4] [int] NULL,
	[OZSNKmenKarta5] [int] NULL,
	[OZSNKmenKarta6] [int] NULL,
	[OZSNKmenKarta7] [int] NULL,
	[OZSNSkladVyber1] [tinyint] NOT NULL,
	[OZSNSkladVyber2] [tinyint] NOT NULL,
	[OZSNSkladVyber3] [tinyint] NOT NULL,
	[OZSNSkladVyber4] [tinyint] NOT NULL,
	[OZSNSkladVyber5] [tinyint] NOT NULL,
	[OZSNSkladVyber6] [tinyint] NOT NULL,
	[OZSNSkladVyber7] [tinyint] NOT NULL,
	[OZSNSklad1] [nvarchar](30) NULL,
	[OZSNSklad2] [nvarchar](30) NULL,
	[OZSNSklad3] [nvarchar](30) NULL,
	[OZSNSklad4] [nvarchar](30) NULL,
	[OZSNSklad5] [nvarchar](30) NULL,
	[OZSNSklad6] [nvarchar](30) NULL,
	[OZSNSklad7] [nvarchar](30) NULL,
	[ZpusobGenerovaniCarovehoKodu] [tinyint] NOT NULL,
	[OZMetodaSD] [bit] NOT NULL,
	[OZJenZUmisteniNaVydejce] [bit] NOT NULL,
	[FakZalohyRekapEnergie] [bit] NOT NULL,
	[ZajisteniDPHSKPovolitSledovaniBankUctu] [bit] NOT NULL,
	[ZajisteniDPHSKAutoOnlineOvereniNaDokladu] [bit] NOT NULL,
	[ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty] [tinyint] NOT NULL,
	[ZajisteniDPHSKAutoZalozeniZverejBankUctu] [bit] NOT NULL,
	[ZajisteniDPHSKInfoPriVystTuzPP] [bit] NOT NULL,
	[ZajisteniDPHSKSeznamPlatcu] [bit] NOT NULL,
	[PoklProdHlasitBlokZbozi] [bit] NOT NULL,
	[RootPathForDocs] [nvarchar](255) NOT NULL,
	[ZajisteniDPHSKAPIKlic] [nvarchar](255) NOT NULL,
	[NerusitVDosleObjNavazTxt02] [bit] NOT NULL,
	[AutoUPOMPF_EmailProfil] [int] NULL,
	[AutoUPOMPF_UpomText] [ntext] NULL,
	[AutoUPOMPF_PenalText] [ntext] NULL,
	[BankaSchvalovaniBS] [bit] NOT NULL,
	[BankaSchvaleniZverejnenych] [bit] NOT NULL,
	[PoklProdZpozdenyPrepoc] [bit] NOT NULL,
	[AutoUPOMPF_Vystavovani] [tinyint] NOT NULL,
	[AutoUPOMPF_CoGener] [tinyint] NOT NULL,
	[AutoUPOMPF_UkoncitPrg] [bit] NOT NULL,
	[AutoUPOMPF_TiskFormat] [int] NULL,
	[AutoUPOMPF_DatSchrOdes] [int] NULL,
	[AutoUPOMPF_UpomTiskForm] [int] NULL,
	[AutoUPOMPF_UpomPeriod] [smallint] NOT NULL,
	[AutoUPOMPF_UpomMaxPocet] [smallint] NOT NULL,
	[AutoUPOMPF_UpomPoDnu] [smallint] NOT NULL,
	[AutoUPOMPF_PenalTiskForm] [int] NULL,
	[AutoUPOMPF_PenalPoDnu] [smallint] NOT NULL,
	[OZPrepMJStanJC] [bit] NOT NULL,
	[DatumDistribDashboardu] [datetime] NOT NULL,
	[KraceniDanVydajuSK] [bit] NOT NULL,
	[CLAECR2023] [bit] NOT NULL,
	[OZZpusobRealizace] [tinyint] NOT NULL,
	[VydejEvCenaSSCC] [bit] NOT NULL,
	[PoklProdZmenaCenVratka] [bit] NOT NULL,
	[PoklProdMnozstviHvezda] [bit] NOT NULL,
	[BankaVUcelOddelovac] [tinyint] NOT NULL,
	[PoklProdNewStorno] [bit] NOT NULL,
	[OZFinRealJeDrivMnoReal] [tinyint] NOT NULL,
	[OZFinRealJeDrivNezReal] [tinyint] NOT NULL,
	[OZMnoRealJePoteFinReal] [tinyint] NOT NULL,
	[OZMnoRealTestMnozstvi] [tinyint] NOT NULL,
	[InventuraPohybPrijem] [tinyint] NULL,
	[InventuraRadaPrijem] [nvarchar](3) NULL,
	[InventuraPohybVydej] [tinyint] NULL,
	[InventuraRadaVydej] [nvarchar](3) NULL,
	[OZAktualizaceSlevPolozky] [tinyint] NOT NULL,
	[IdDruhyUzivKurzuBanka] [int] NULL,
	[ZpusobPevneKurzyBanka] [tinyint] NOT NULL,
	[UctoZapoctuUtvar] [nvarchar](30) NULL,
	[ProxyIESettings] [bit] NOT NULL,
	[RozsireneKurzy] [bit] NOT NULL,
	[PoklProdHledatVyrCis] [bit] NOT NULL,
	[IdDruhyUzivKurzuDPH] [int] NULL,
	[IdDruhyUzivKurzuZap] [int] NULL,
	[IdDruhyUzivKurzuNZ] [int] NULL,
	[ZpusobPevneKurzyDPH] [tinyint] NOT NULL,
	[ZpusobPevneKurzyZap] [tinyint] NOT NULL,
	[ZpusobPevneKurzyNZ] [tinyint] NOT NULL,
	[FinStatAPIKlic] [nvarchar](32) NOT NULL,
	[PokladnaJakHledatKurz] [tinyint] NOT NULL,
	[PokladnaZpusobPevneKurzy] [tinyint] NOT NULL,
	[PokladnaIdDruhyUzivKurzu] [int] NULL,
	[BankaUhradyFakturyNehradit] [tinyint] NOT NULL,
	[FaSklJakHledatKurz] [tinyint] NOT NULL,
	[FaSklZpusobPevneKurzy] [tinyint] NOT NULL,
	[FaSklIdDruhyUzivKurzu] [int] NULL,
	[AresNovy] [bit] NOT NULL,
	[AutoUPOMPF_PFIDTextEmail] [int] NULL,
	[AutoUPOMPF_UpomIDTextEmail] [int] NULL,
	[AutoUPOMPF_FaktOdeslat] [tinyint] NOT NULL,
	[AutoUPOMPF_FaktTiskForm] [int] NULL,
	[AutoUPOMPF_FaktFormat] [int] NULL,
	[DOBJStavVCVEditoruPol] [bit] NOT NULL,
	[PouzivatPomerKoefPuvodni] [tinyint] NOT NULL,
	[PomerKoefDatumPlatnosti] [datetime] NULL,
	[eFaktura] [bit] NOT NULL,
	[OZTypGenStov] [tinyint] NOT NULL,
	[PoklProdNikdyZobrazVratit] [bit] NOT NULL,
	[OZZapoctiFaPDoOdebMnoz] [tinyint] NOT NULL,
	[OZZapoctiFaVDoOdebMnoz] [tinyint] NOT NULL,
	[AutoUPOMPF_FARokyZpet] [smallint] NOT NULL,
	[IDAutTypDoSouboru] [int] NULL,
	[RespektovatNastaveniKontrolVC] [tinyint] NOT NULL,
	[BankaMenaBSTuP] [bit] NOT NULL,
	[BankaBSHledatZa] [bit] NOT NULL,
	[BankaUhradyNaOrgBS] [tinyint] NOT NULL,
	[OZDSNNavDok] [tinyint] NOT NULL,
	[OZDSNAutoReal] [tinyint] NOT NULL,
	[ZpusobZruseniKRBilDen] [tinyint] NOT NULL,
	[ZobrazitPlatnyKurz] [bit] NOT NULL,
	[FakZalohyPrepocitatKurzemUhrady] [bit] NOT NULL,
	[FakZalohyRekap10CZ] [bit] NOT NULL,
	[NotifikaceGlobalStopCheckovani] [bit] NOT NULL,
	[AutomatizaceOdesilatelJmeno] [nvarchar](100) NOT NULL,
	[AutomatizaceOdesilatelEmail] [nvarchar](100) NOT NULL,
	[AutUlozitDoDB] [bit] NOT NULL,
	[AutZahrnoutDoVseobDok] [tinyint] NOT NULL,
	[AutDoSouboruCesta] [nvarchar](255) NOT NULL,
	[AutVytvorAdresar] [bit] NOT NULL,
	[AutIDDokumStrom] [int] NULL,
	[AutPDFElPodpisOffsetX] [smallint] NOT NULL,
	[AutPDFElPodpisOffsetY] [smallint] NOT NULL,
	[AutPDFZobrazitElPodpis] [bit] NOT NULL,
	[AutoUPOMPF_PrednOrg] [tinyint] NOT NULL,
	[AutoUPOMPF_UpoUlozenoDB] [tinyint] NOT NULL,
	[AutoUPOMPF_UpoVseobDok] [tinyint] NOT NULL,
	[AutoUPOMPF_LimitMBEmail] [float] NOT NULL,
	[AutoUPOMPF_Vyrizuje] [tinyint] NOT NULL,
	[AutoUctoEditace] [nchar](1) NOT NULL,
	[AutoUctoObdobi] [tinyint] NOT NULL,
	[AutoUctoObdobiLeas] [tinyint] NOT NULL,
	[AutoUctoRefresh] [bit] NOT NULL,
	[AutoUctoExtProc] [tinyint] NOT NULL,
	[AutoUctoUkoncitPrg] [bit] NOT NULL,
	[DenikMenaDatumOd] [datetime] NOT NULL,
	[BankaVypisDatumSalda] [bit] NOT NULL,
	[PovolitZajisteniDilcu] [bit] NOT NULL,
	[MzAutomatUcto] [bit] NOT NULL,
	[AutoUctoObdobiMaj] [tinyint] NOT NULL,
	[AutoUctoExtProc05] [tinyint] NOT NULL,
	[PoklProdRychlaPlatba1] [nvarchar](15) NOT NULL,
	[PoklProdRychlaPlatba2] [nvarchar](15) NOT NULL,
	[PoklProdRychlaPlatba3] [nvarchar](15) NOT NULL,
	[PoklProdRychlaPlatba4] [nvarchar](15) NOT NULL,
	[PoklProdRychlaPlatba5] [nvarchar](15) NOT NULL,
	[PoklProdBarvaPlatba1] [int] NULL,
	[PoklProdBarvaPlatba2] [int] NULL,
	[PoklProdBarvaPlatba3] [int] NULL,
	[PoklProdBarvaPlatba4] [int] NULL,
	[PoklProdBarvaPlatba5] [int] NULL,
	[DatumDistribAutDef] [datetime] NOT NULL,
	[ZapoctySaldoVPriprave] [bit] NOT NULL,
	[FakZalohyRekap1020SK] [bit] NOT NULL,
	[HighNotif_SkipPingTest] [bit] NOT NULL,
	[AutZobrazitInfoUkonceni] [bit] NOT NULL,
	[AutSpoustetOpakovane] [bit] NOT NULL,
	[AutArchivovatEmaily] [bit] NOT NULL,
	[AutEmailOpakovane] [bit] NOT NULL,
	[LimitObratu] [bit] NOT NULL,
	[AutoUPOMPF_PredmetUPO] [tinyint] NOT NULL,
	[AutoUPOMPF_PredmetPenFak] [tinyint] NOT NULL,
	[PoklProdVratkaNewSklad] [bit] NOT NULL,
	[OZHlidatRealizujVydej] [bit] NOT NULL,
	[CLANCTSPrechodneObdobi] [bit] NOT NULL,
	[DnyToleranceScontaFaV] [smallint] NOT NULL,
	[HighNotif_Logovani] [bit] NOT NULL,
	[VerzeProgramu] [nvarchar](12) NOT NULL,
	[JakZajistovatStinovePolozky] [tinyint] NOT NULL,
	[OZZpusobZapStoren] [tinyint] NOT NULL,
	[ZajisteniDPHLimitHotovost] [numeric](19, 6) NOT NULL,
	[PoklProdKurzOdvod] [tinyint] NOT NULL,
	[DruhSkladuDSN] [tinyint] NOT NULL,
	[PosunSamovymereniKH] [bit] NOT NULL,
	[DanFinancniTransakce] [tinyint] NOT NULL,
	[PripravnyRezimDK] [bit] NOT NULL,
	[AutoUPOMPF_UpomDoDnu] [smallint] NOT NULL,
	[OZOddelovacVC] [nvarchar](1) NOT NULL,
	[OZVyrCPInfoPanelDokumentyZdroj] [tinyint] NOT NULL,
	[BankaVypisNepovolPripravu] [bit] NOT NULL,
	[HlidatPovinnosti] [tinyint] NOT NULL,
	[SKVykaz411] [bit] NULL,
	[AVAOrgUnitParentSend] [bit] NOT NULL,
	[BankaUhradyPrirazeniVydDob] [bit] NOT NULL,
	[CLAECSPrechodneObdobi] [bit] NOT NULL,
	[PoklProdKartSlevaVouch] [int] NULL,
	[FakZalohyDetail] [bit] NOT NULL,
	[AVAAgentIntervalCheckovani] [int] NOT NULL,
	[OZRespektovatPolSplneno] [tinyint] NOT NULL,
	[OprPolCMSaldo] [bit] NOT NULL,
	[PrenosKoefDPHVozidla] [bit] NOT NULL,
	[AutoUPOMPF_UpomVarianta] [tinyint] NOT NULL,
	[AutoUPOMPF_PenalVarianta] [tinyint] NOT NULL,
	[ZajisteniDPHSkupRegistrNezverejnovat] [bit] NOT NULL,
	[DatumDistribAutExtAkce] [datetime] NOT NULL,
	[NapocetSaldoOrgNew] [tinyint] NOT NULL,
	[OZVCTestMnoz] [tinyint] NOT NULL,
	[CLAICSPrechodneObdobi] [bit] NOT NULL,
	[PrepoctiMnozstviVC] [tinyint] NOT NULL,
	[DatumDistribUcetKodyKontace] [datetime] NOT NULL,
	[BankaUctovatNuloveBV] [bit] NOT NULL,
	[RV_CisloKontace_PrirustekNV] [int] NULL,
	[RV_CisloKontace_UbytekNV] [int] NULL,
	[DPHPrvDoklad] [bit] NOT NULL,
	[EETEICPoplatnika] [nvarchar](15) NOT NULL,
	[EETPovereniVicePopl] [bit] NOT NULL,
	[SalSkPohlCZ] [nvarchar](3) NULL,
	[SalSkPohlSK] [nvarchar](3) NULL,
	[PohlDotazAktual] [bit] NOT NULL,
	[SaldoDotazAktual] [bit] NOT NULL,
	[AutoUPOMPF_UpomDobropis] [bit] NOT NULL,
	[AutoUPOMPF_UpomZapFakP] [bit] NOT NULL,
	[PokladnaUcetPrevodJinaPokladna] [nvarchar](30) NULL,
 CONSTRAINT [PK__TabHGlob__ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KonverzePZ]  DEFAULT ((0)) FOR [KonverzePZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VerzeDanovehoPriznani]  DEFAULT ((1)) FOR [VerzeDanovehoPriznani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PlatceDPH]  DEFAULT ((0)) FOR [PlatceDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoziceZaokrDPH]  DEFAULT ((2)) FOR [PoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HraniceZaokrDPH]  DEFAULT ((4)) FOR [HraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DruhSkladu]  DEFAULT ((2)) FOR [DruhSkladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ShodaZakazek]  DEFAULT (N'N') FOR [ShodaZakazek]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NulovyVydej]  DEFAULT (N'N') FOR [NulovyVydej]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Legislativa]  DEFAULT ((0)) FOR [Legislativa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PlatnostNabCen]  DEFAULT ((1)) FOR [PlatnostNabCen]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaStornaPrijmu]  DEFAULT ((0)) FOR [KontrolaStornaPrijmu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti]  DEFAULT ((14)) FOR [CasRozliseniSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti2]  DEFAULT ((30)) FOR [CasRozliseniSplatnosti2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti3]  DEFAULT ((60)) FOR [CasRozliseniSplatnosti3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti4]  DEFAULT ((90)) FOR [CasRozliseniSplatnosti4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti5]  DEFAULT ((120)) FOR [CasRozliseniSplatnosti5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CasRozliseniSplatnosti6]  DEFAULT ((365)) FOR [CasRozliseniSplatnosti6]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ModeNapoctuCasRozliseni]  DEFAULT ((0)) FOR [ModeNapoctuCasRozliseni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenDenik]  DEFAULT ((0)) FOR [ArchivaceZmenDenik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenKmenZbozi]  DEFAULT ((0)) FOR [ArchivaceZmenKmenZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenDokZbo]  DEFAULT ((0)) FOR [ArchivaceZmenDokZbo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DelkaRegCislaZbozi]  DEFAULT ((5)) FOR [DelkaRegCislaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VerzeEXE]  DEFAULT (N'000000000000') FOR [VerzeEXE]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VelikostEXE]  DEFAULT ((0)) FOR [VelikostEXE]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumEXE]  DEFAULT ('19000101') FOR [DatumEXE]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumPosledniKontroly]  DEFAULT ('19000101') FOR [DatumPosledniKontroly]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribTiskForm]  DEFAULT ('19000101') FOR [DatumDistribTiskForm]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribGenSes]  DEFAULT ('19000101') FOR [DatumDistribGenSes]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribGenMzdy]  DEFAULT ('19000101') FOR [DatumDistribGenMzdy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribGenPers]  DEFAULT ('19000101') FOR [DatumDistribGenPers]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribFiltru]  DEFAULT ('19000101') FOR [DatumDistribFiltru]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribOpisu]  DEFAULT ('19000101') FOR [DatumDistribOpisu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribFIAVykazy]  DEFAULT ('19000101') FOR [DatumDistribFIAVykazy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribFIAUkazatel]  DEFAULT ('19000101') FOR [DatumDistribFIAUkazatel]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribFIABLegis]  DEFAULT ('19000101') FOR [DatumDistribFIABLegis]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribFIABSkupDok]  DEFAULT ('19000101') FOR [DatumDistribFIABSkupDok]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_Server]  DEFAULT ('') FOR [U2N_XAPI_Server]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_Port]  DEFAULT ((6800)) FOR [U2N_XAPI_Port]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_Timeout]  DEFAULT ((5000)) FOR [U2N_XAPI_Timeout]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_User]  DEFAULT ('') FOR [U2N_XAPI_User]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_Password]  DEFAULT ('') FOR [U2N_XAPI_Password]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__U2N_XAPI_AutoHlidani]  DEFAULT ((0)) FOR [U2N_XAPI_AutoHlidani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HlidatKonstSym]  DEFAULT ((0)) FOR [HlidatKonstSym]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaKonstSymbPovinny]  DEFAULT ((0)) FOR [BankaKonstSymbPovinny]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaMinOffExpSplatnoZa]  DEFAULT ((0)) FOR [BankaMinOffExpSplatnoZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaMinOffExpSplatnoTu]  DEFAULT ((0)) FOR [BankaMinOffExpSplatnoTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaMaxPocetRadkuTu]  DEFAULT ((999)) FOR [BankaMaxPocetRadkuTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaOpisPoExpTu]  DEFAULT ((1)) FOR [BankaOpisPoExpTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaOpisPoExpZa]  DEFAULT ((1)) FOR [BankaOpisPoExpZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaPruvodkaPoExpTu]  DEFAULT ((1)) FOR [BankaPruvodkaPoExpTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaPruvodkaPoExpZa]  DEFAULT ((1)) FOR [BankaPruvodkaPoExpZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisCisloDokladu]  DEFAULT ((0)) FOR [BankaVypisCisloDokladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisDatumPripadu]  DEFAULT ((0)) FOR [BankaVypisDatumPripadu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisStopPriChybe]  DEFAULT ((0)) FOR [BankaVypisStopPriChybe]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisNenalezenUcet]  DEFAULT ((0)) FOR [BankaVypisNenalezenUcet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisHledatUcetZam]  DEFAULT ((0)) FOR [BankaVypisHledatUcetZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisHledatCastku]  DEFAULT ((1)) FOR [BankaVypisHledatCastku]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisPrepocetMeny]  DEFAULT ((0)) FOR [BankaVypisPrepocetMeny]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisHledatVarSym]  DEFAULT ((1)) FOR [BankaVypisHledatVarSym]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BanVypHledatVSKdyzViceBS]  DEFAULT ((1)) FOR [BanVypHledatVSKdyzViceBS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisOdkudKurzProR]  DEFAULT ((0)) FOR [BankaVypisOdkudKurzProR]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisKdeBratKurzR]  DEFAULT ((1)) FOR [BankaVypisKdeBratKurzR]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisJakHledatKurz]  DEFAULT ((0)) FOR [BankaVypisJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisJakTretiMenu]  DEFAULT ((1)) FOR [BankaVypisJakTretiMenu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisJakSumace]  DEFAULT ((1)) FOR [BankaVypisJakSumace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaPouzivatDispSymb]  DEFAULT ((0)) FOR [BankaPouzivatDispSymb]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZarovnaniRegCislaZbozi]  DEFAULT ((2)) FOR [ZarovnaniRegCislaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Davka]  DEFAULT ((3)) FOR [Davka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Tarif]  DEFAULT ((1)) FOR [Tarif]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MaxVnoreni]  DEFAULT ((15)) FOR [MaxVnoreni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Proc_ztrat]  DEFAULT ((0.0)) FOR [Proc_ztrat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Prub_doba]  DEFAULT ((0)) FOR [Prub_doba]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Davka_TEC]  DEFAULT ((3)) FOR [Davka_TEC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DelkaPoziceKV]  DEFAULT ((6)) FOR [DelkaPoziceKV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZarovnaniPoziceKV]  DEFAULT ((1)) FOR [ZarovnaniPoziceKV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FiltrNaCislo]  DEFAULT ((1)) FOR [FiltrNaCislo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MaxZaokrouhleniPokl]  DEFAULT ((1.0)) FOR [MaxZaokrouhleniPokl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LhutaSplatnosti]  DEFAULT ((10)) FOR [LhutaSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AppRole]  DEFAULT ('') FOR [AppRole]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AppRoleP]  DEFAULT ('') FOR [AppRoleP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__TrideniPolozekVTiskuDokladu]  DEFAULT ((0)) FOR [TrideniPolozekVTiskuDokladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NenalezenoSozNa]  DEFAULT ((0)) FOR [NenalezenoSozNa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__SlevaSoucetAnoNe]  DEFAULT ((0)) FOR [SlevaSoucetAnoNe]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__TypPrevoduVydejkyPrevodky]  DEFAULT ((1)) FOR [TypPrevoduVydejkyPrevodky]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OblibenyTypPolozkovehoPrevodu]  DEFAULT ((0)) FOR [OblibenyTypPolozkovehoPrevodu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PevnaCastCarovehoKodu]  DEFAULT ('') FOR [PevnaCastCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BlokovatMimoRozsah]  DEFAULT ((0)) FOR [BlokovatMimoRozsah]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZdrojTarifuProMzdy_Nor]  DEFAULT ((0)) FOR [ZdrojTarifuProMzdy_Nor]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZdrojTarifuProMzdy_Cas]  DEFAULT ((0)) FOR [ZdrojTarifuProMzdy_Cas]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctovaniZapoctu]  DEFAULT ((1)) FOR [UctovaniZapoctu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutomatPoklDokl]  DEFAULT ((0)) FOR [AutomatPoklDokl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumSplatnostiPrFa]  DEFAULT ((0)) FOR [DatumSplatnostiPrFa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KumulaceObratu]  DEFAULT ((1)) FOR [KumulaceObratu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KumulaceObratuMesic]  DEFAULT ((1)) FOR [KumulaceObratuMesic]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitNevyrovnane]  DEFAULT ((0)) FOR [PovolitNevyrovnane]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitStareVykazy]  DEFAULT ((0)) FOR [PovolitStareVykazy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Penale]  DEFAULT ((0)) FOR [Penale]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VerzeSyntet]  DEFAULT ('') FOR [VerzeSyntet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NapocetSaldoOrg]  DEFAULT ((1)) FOR [NapocetSaldoOrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DeIdentifikaceUhrad]  DEFAULT ((0)) FOR [DeIdentifikaceUhrad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RezimPenalizace]  DEFAULT ((0)) FOR [RezimPenalizace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DERezimPreuctovani]  DEFAULT ((0)) FOR [DERezimPreuctovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RefreshDeniku]  DEFAULT ((0)) FOR [RefreshDeniku]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MinRozdilDanUcEv]  DEFAULT ((0.0)) FOR [MinRozdilDanUcEv]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECDataLoaderPath]  DEFAULT ('') FOR [ECDataLoaderPath]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECUseDataLoader]  DEFAULT ((0)) FOR [ECUseDataLoader]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNakl1]  DEFAULT (N'Dopravné') FOR [OZSouvisNakl1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNakl2]  DEFAULT (N'Clo') FOR [OZSouvisNakl2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNakl3]  DEFAULT (N'Pojistné') FOR [OZSouvisNakl3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc1]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc2]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc3]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc4]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc5]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc6]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc6]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSouvisNaklProc7]  DEFAULT ((0.0)) FOR [OZSouvisNaklProc7]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNHlidatZadani]  DEFAULT ((0)) FOR [OZSNHlidatZadani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPrevod]  DEFAULT ((2)) FOR [OZSNPrevod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni1]  DEFAULT ((0)) FOR [OZSNTypRozpousteni1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni2]  DEFAULT ((0)) FOR [OZSNTypRozpousteni2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni3]  DEFAULT ((0)) FOR [OZSNTypRozpousteni3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni4]  DEFAULT ((0)) FOR [OZSNTypRozpousteni4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni5]  DEFAULT ((0)) FOR [OZSNTypRozpousteni5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni6]  DEFAULT ((0)) FOR [OZSNTypRozpousteni6]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNTypRozpousteni7]  DEFAULT ((0)) FOR [OZSNTypRozpousteni7]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RuznySkladNaPolAHla]  DEFAULT ((1)) FOR [RuznySkladNaPolAHla]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PozicePrvnihoZnakuCarovehoKodu]  DEFAULT ((1)) FOR [PozicePrvnihoZnakuCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DelkaVarCastiCarovehoKodu]  DEFAULT ((5)) FOR [DelkaVarCastiCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KdeVzitCarovyKod]  DEFAULT ((0)) FOR [KdeVzitCarovyKod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HistorickeCenyNakup]  DEFAULT (N'A') FOR [HistorickeCenyNakup]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HistorickeCenyProdej]  DEFAULT (N'A') FOR [HistorickeCenyProdej]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MjVydejEvCena]  DEFAULT ((0)) FOR [MjVydejEvCena]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EmailHotline]  DEFAULT (N'hotline.inuvio-cz@assecosol.com') FOR [EmailHotline]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RezimPrav]  DEFAULT ((0)) FOR [RezimPrav]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EditaceNegPrava]  DEFAULT ((0)) FOR [EditaceNegPrava]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LogovatPrava]  DEFAULT ((0)) FOR [LogovatPrava]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BlokovaniUcDokFaze]  DEFAULT ((0)) FOR [BlokovaniUcDokFaze]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ModeImportDenikDOS]  DEFAULT ((0)) FOR [ModeImportDenikDOS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ImportDenikVazbaOZ]  DEFAULT ((0)) FOR [ImportDenikVazbaOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RozdilDatPripadDUZP]  DEFAULT ((0)) FOR [RozdilDatPripadDUZP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZadaniPolozekDokladOZ]  DEFAULT ((0)) FOR [ZadaniPolozekDokladOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PolPrevodPrenosCislaSkladu]  DEFAULT (N'N') FOR [PolPrevodPrenosCislaSkladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KompletPrevod]  DEFAULT (N'N') FOR [KompletPrevod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DoplneniObdobiStavuOZ]  DEFAULT ((0)) FOR [DoplneniObdobiStavuOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZaokrDPHvaluty]  DEFAULT ((0)) FOR [ZaokrDPHvaluty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZHromadnaRealizace_DruhDatumu]  DEFAULT ((0)) FOR [OZHromadnaRealizace_DruhDatumu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Intr_KontrolovatCN]  DEFAULT ((1)) FOR [Intr_KontrolovatCN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MnozstviNovehoVC]  DEFAULT ((0)) FOR [MnozstviNovehoVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__StinRezim]  DEFAULT ((0)) FOR [StinRezim]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenPokladna]  DEFAULT ((0)) FOR [ArchivaceZmenPokladna]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenNC]  DEFAULT ((0)) FOR [ArchivaceZmenNC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZobrPoctuDMNabCen]  DEFAULT ((2)) FOR [ZobrPoctuDMNabCen]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ClaExpCisloDleNastPar]  DEFAULT ((0)) FOR [ClaExpCisloDleNastPar]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NCTSAllowDelete]  DEFAULT ((0)) FOR [NCTSAllowDelete]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ClaAutoClose]  DEFAULT ((0)) FOR [ClaAutoClose]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatSplatPocitatOd]  DEFAULT ((0)) FOR [DatSplatPocitatOd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakPoziceZaokrDPH]  DEFAULT ((2)) FOR [FakPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakHraniceZaokrDPH]  DEFAULT ((4)) FOR [FakHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctPoziceZaokrDPH]  DEFAULT ((2)) FOR [UctPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctHraniceZaokrDPH]  DEFAULT ((4)) FOR [UctHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PokPoziceZaokrDPH]  DEFAULT ((2)) FOR [PokPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PokHraniceZaokrDPH]  DEFAULT ((4)) FOR [PokHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OddelenaDatabaze]  DEFAULT ((0)) FOR [OddelenaDatabaze]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenKontaktJednani]  DEFAULT ((0)) FOR [ArchivaceZmenKontaktJednani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakKoeficientDPH]  DEFAULT ((1)) FOR [FakKoeficientDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZaokrPoklDokNa50]  DEFAULT (N'N') FOR [ZaokrPoklDokNa50]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PrevodSluzebNaVYDzEXP]  DEFAULT (N'A') FOR [PrevodSluzebNaVYDzEXP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RozhodneMnozstviNaVYDzEXP]  DEFAULT ((2)) FOR [RozhodneMnozstviNaVYDzEXP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdZaokrouhlitNa50]  DEFAULT ((0)) FOR [PoklProdZaokrouhlitNa50]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatPLUKod]  DEFAULT ((0)) FOR [PoklProdHledatPLUKod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdZpusobZadani]  DEFAULT ((0)) FOR [PoklProdZpusobZadani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVychoziMnozstvi]  DEFAULT ((2)) FOR [PoklProdVychoziMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdTestMnozstvi]  DEFAULT ((1)) FOR [PoklProdTestMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdUlozBezUhrad]  DEFAULT ((0)) FOR [PoklProdUlozBezUhrad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdOrgPovinna]  DEFAULT ((0)) FOR [PoklProdOrgPovinna]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdOrgPredDokladem]  DEFAULT ((0)) FOR [PoklProdOrgPredDokladem]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdOrgZmenaDoklad]  DEFAULT ((0)) FOR [PoklProdOrgZmenaDoklad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdOrgPoradiPoli]  DEFAULT ((0)) FOR [PoklProdOrgPoradiPoli]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKPlatbaLimit]  DEFAULT ((0)) FOR [PoklProdBKPlatbaLimit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKPlatbaMaxProc]  DEFAULT ((100.0)) FOR [PoklProdBKPlatbaMaxProc]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKPrvniBody]  DEFAULT ((0)) FOR [PoklProdBKPrvniBody]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKTypProEI]  DEFAULT ((0)) FOR [PoklProdBKTypProEI]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKBylEI]  DEFAULT ((0)) FOR [PoklProdBKBylEI]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBKIdent]  DEFAULT ('') FOR [PoklProdBKIdent]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctoJakHledatKurzProDPH]  DEFAULT ((0)) FOR [UctoJakHledatKurzProDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctoJakHledatKurzProZap]  DEFAULT ((0)) FOR [UctoJakHledatKurzProZap]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OddelovacExportDenik]  DEFAULT ((0)) FOR [OddelovacExportDenik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NeaktEvMnozstviEvStav]  DEFAULT ((1)) FOR [NeaktEvMnozstviEvStav]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MaxPocetRadkuPD]  DEFAULT ((3)) FOR [MaxPocetRadkuPD]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMKontaktyPrenos]  DEFAULT ((0)) FOR [CRMKontaktyPrenos]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__GenerovatStornoDobropisDatum]  DEFAULT ((0)) FOR [GenerovatStornoDobropisDatum]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzitPrednastavenouCU]  DEFAULT ((2)) FOR [PouzitPrednastavenouCU]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ExtEd_EditovatVEditoru]  DEFAULT ((1)) FOR [ExtEd_EditovatVEditoru]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZFiltrujNSCtrlEnter]  DEFAULT ((1)) FOR [OZFiltrujNSCtrlEnter]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZFiltrujNSCtrlN]  DEFAULT ((1)) FOR [OZFiltrujNSCtrlN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DohledatCenyDle]  DEFAULT ((0)) FOR [DohledatCenyDle]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZaokrDPHMalaCisla]  DEFAULT ((0)) FOR [ZaokrDPHMalaCisla]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisDatumUhrady]  DEFAULT ((1)) FOR [BankaVypisDatumUhrady]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRegCisPodleOZ]  DEFAULT ((1)) FOR [PoklProdRegCisPodleOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdDelkaRegCisBal]  DEFAULT ((5)) FOR [PoklProdDelkaRegCisBal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdZarovRegCisBal]  DEFAULT ((2)) FOR [PoklProdZarovRegCisBal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdCKPodleOZ]  DEFAULT ((1)) FOR [PoklProdCKPodleOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdCKPevnaCast]  DEFAULT ('') FOR [PoklProdCKPevnaCast]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdCKPozice1Znaku]  DEFAULT ((1)) FOR [PoklProdCKPozice1Znaku]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdCKDelkaVarCasti]  DEFAULT ((5)) FOR [PoklProdCKDelkaVarCasti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdCKKdeVzit]  DEFAULT ((0)) FOR [PoklProdCKKdeVzit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__IntervalObnovyWF]  DEFAULT ((30)) FOR [IntervalObnovyWF]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZUmistMetodaVydej]  DEFAULT ((0)) FOR [OZUmistMetodaVydej]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyDleVal]  DEFAULT ((1)) FOR [FakZalohyDleVal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaPZUcto]  DEFAULT ((1)) FOR [KontrolaPZUcto]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FazeEuro]  DEFAULT ((0)) FOR [FazeEuro]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenBankSp]  DEFAULT ((0)) FOR [ArchivaceZmenBankSp]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenZamMzd]  DEFAULT ((0)) FOR [ArchivaceZmenZamMzd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenCisZam]  DEFAULT ((0)) FOR [ArchivaceZmenCisZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MzAlias]  DEFAULT ((0)) FOR [MzAlias]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MzAliasLen]  DEFAULT ((6)) FOR [MzAliasLen]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Intr_HlidatShoduSoudku]  DEFAULT ((1)) FOR [Intr_HlidatShoduSoudku]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisUctovani]  DEFAULT ((1)) FOR [BankaVypisUctovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatSkontaPocitatOd]  DEFAULT ((0)) FOR [DatSkontaPocitatOd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdKontrolaZadaniVC]  DEFAULT ((1)) FOR [PoklProdKontrolaZadaniVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__GenerovaniZNerealFakt]  DEFAULT (N'N') FOR [GenerovaniZNerealFakt]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdUzaverkaAktCas]  DEFAULT ((0)) FOR [PoklProdUzaverkaAktCas]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumPrechoduNaEuro]  DEFAULT ('20090101') FOR [DatumPrechoduNaEuro]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DUOkurz]  DEFAULT ((1)) FOR [DUOkurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenMzdOdpPolMzd]  DEFAULT ((0)) FOR [ArchivaceZmenMzdOdpPolMzd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZaokrouhleniUhradyPokl]  DEFAULT ((0)) FOR [ZaokrouhleniUhradyPokl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyHledatProti]  DEFAULT ((1)) FOR [BankaUhradyHledatProti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertByName]  DEFAULT ('') FOR [ECertByName]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertToName]  DEFAULT ('') FOR [ECertToName]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertSN]  DEFAULT ('') FOR [ECertSN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertStoreLocation]  DEFAULT ((2)) FOR [ECertStoreLocation]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertStoreName]  DEFAULT ((1)) FOR [ECertStoreName]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportUdajuZamTu]  DEFAULT ((1)) FOR [BankaExportUdajuZamTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportZmenaZamTu]  DEFAULT ((1)) FOR [BankaExportZmenaZamTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportUdajuZamZa]  DEFAULT ((1)) FOR [BankaExportUdajuZamZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportZmenaZamZa]  DEFAULT ((1)) FOR [BankaExportZmenaZamZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisDotahovatZam]  DEFAULT ((1)) FOR [BankaVypisDotahovatZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdKurzHMNaBody]  DEFAULT ((0)) FOR [PoklProdKurzHMNaBody]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DruhSkladuSN]  DEFAULT ((2)) FOR [DruhSkladuSN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZStoPBezEdiSN]  DEFAULT ((0)) FOR [OZStoPBezEdiSN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMCestaKSouboru]  DEFAULT ('') FOR [CRMCestaKSouboru]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMSaveToDBOrToDoc]  DEFAULT ((1)) FOR [CRMSaveToDBOrToDoc]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMSledovatHistorii]  DEFAULT ((1)) FOR [CRMSledovatHistorii]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMReplaceFile]  DEFAULT ((0)) FOR [CRMReplaceFile]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenDosleObjH20]  DEFAULT ((0)) FOR [ArchivaceZmenDosleObjH20]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OdpocetDaneRoky]  DEFAULT ((0)) FOR [OdpocetDaneRoky]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZUmistJenPV]  DEFAULT ((1)) FOR [OZUmistJenPV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPrepMJnaVC]  DEFAULT ((1)) FOR [OZPrepMJnaVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMUseDynFolder]  DEFAULT ((0)) FOR [CRMUseDynFolder]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMDynFolder]  DEFAULT ('') FOR [CRMDynFolder]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZDSNPrevod]  DEFAULT ((1)) FOR [OZDSNPrevod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVzdyZobrazVratit]  DEFAULT ((0)) FOR [PoklProdVzdyZobrazVratit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ECertLDAPQuery]  DEFAULT ('') FOR [ECertLDAPQuery]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMPovinnaKat]  DEFAULT ((1)) FOR [CRMPovinnaKat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMVychoziStavPodkladu]  DEFAULT ((1)) FOR [CRMVychoziStavPodkladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportTestSouborTu]  DEFAULT ((0)) FOR [BankaExportTestSouborTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaExportTestSouborZa]  DEFAULT ((0)) FOR [BankaExportTestSouborZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ClaAutoCloseCRPRO]  DEFAULT ((0)) FOR [ClaAutoCloseCRPRO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctovaniTXTPolozekFA]  DEFAULT ((1)) FOR [UctovaniTXTPolozekFA]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZRozUmiDleVC]  DEFAULT ((1)) FOR [OZRozUmiDleVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DobaMeziPrikazy]  DEFAULT ((1)) FOR [DobaMeziPrikazy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__TypPlanovaciDoby]  DEFAULT ((0)) FOR [TypPlanovaciDoby]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpravyLogovani]  DEFAULT ((0)) FOR [ZpravyLogovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoCislovaniPoziceKV]  DEFAULT ((1)) FOR [AutoCislovaniPoziceKV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NevyrovnanyZapocet]  DEFAULT ((0)) FOR [NevyrovnanyZapocet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZadaniPolozekSkladOZ]  DEFAULT ((0)) FOR [ZadaniPolozekSkladOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVypocetSumaKcPoZao]  DEFAULT ((0)) FOR [OZVypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVypocetSumaKcPoZao]  DEFAULT ((1)) FOR [PoklProdVypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZZapoctiStornoDoOdebMnoz]  DEFAULT ((1)) FOR [OZZapoctiStornoDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__SmazatKurzovniListek]  DEFAULT ((0)) FOR [SmazatKurzovniListek]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyDejNaUhrazene]  DEFAULT ((2)) FOR [BankaUhradyDejNaUhrazene]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KartoveCentrumUctovaniDatum]  DEFAULT ((0)) FOR [KartoveCentrumUctovaniDatum]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPovolZaporMnozPol]  DEFAULT ((0)) FOR [OZPovolZaporMnozPol]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZOdebMnozNekonRetez]  DEFAULT ((0)) FOR [OZOdebMnozNekonRetez]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZInvItemZpusobZadani]  DEFAULT ((0)) FOR [OZInvItemZpusobZadani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NavazDokMaxLevel]  DEFAULT ((0)) FOR [NavazDokMaxLevel]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ObdStavuUctoSkladu]  DEFAULT ((0)) FOR [ObdStavuUctoSkladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZastavitRealizaciOZ]  DEFAULT ((0)) FOR [ZastavitRealizaciOZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenSkupinaZbozi]  DEFAULT ((0)) FOR [ArchivaceZmenSkupinaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyLeasing]  DEFAULT ((0)) FOR [BankaUhradyLeasing]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisRuzneOrgZam]  DEFAULT ((1)) FOR [BankaVypisRuzneOrgZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AplikovatKVOPouzeNaTAC]  DEFAULT ((0)) FOR [AplikovatKVOPouzeNaTAC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KompletEdit]  DEFAULT ((0)) FOR [KompletEdit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MzSeskupeniRC]  DEFAULT ((1)) FOR [MzSeskupeniRC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMHlidaniPoctuHodin]  DEFAULT ((0)) FOR [CRMHlidaniPoctuHodin]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakPouzitOpravuUSkonta]  DEFAULT ((1)) FOR [FakPouzitOpravuUSkonta]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZStornoCastecneMnozSN]  DEFAULT ((1)) FOR [OZStornoCastecneMnozSN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KartoveCentrumUctovaniDatumKurz]  DEFAULT ((1)) FOR [KartoveCentrumUctovaniDatumKurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KartoveCentrumPoplatkyTypUhrady]  DEFAULT ((0)) FOR [KartoveCentrumPoplatkyTypUhrady]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DOBJZapoctiStornoCiDobropis]  DEFAULT ((1)) FOR [DOBJZapoctiStornoCiDobropis]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHPovolitSledovaniNespolehPlatcuABankUctu]  DEFAULT ((0)) FOR [ZajisteniDPHPovolitSledovaniNespolehPlatcuABankUctu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHAutoOnlineOvereniNaDokladu]  DEFAULT ((1)) FOR [ZajisteniDPHAutoOnlineOvereniNaDokladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]  DEFAULT ((2)) FOR [ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]  DEFAULT ((2)) FOR [ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHInfoPriVystTuzPP]  DEFAULT ((0)) FOR [ZajisteniDPHInfoPriVystTuzPP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHLogovatPouziti]  DEFAULT ((0)) FOR [ZajisteniDPHLogovatPouziti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyPS]  DEFAULT ((0)) FOR [PAPDokladyPS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyDruhyUcet]  DEFAULT ((1)) FOR [PAPDokladyDruhyUcet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyPAP]  DEFAULT ((0)) FOR [PAPDokladyPAP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyStranaTZ]  DEFAULT ((0)) FOR [PAPDokladyStranaTZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyPartnerT]  DEFAULT ((0)) FOR [PAPDokladyPartnerT]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladySpoustet]  DEFAULT ((0)) FOR [PAPDokladySpoustet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyICO]  DEFAULT ((0)) FOR [PAPDokladyICO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPVykazy]  DEFAULT ((1)) FOR [PAPVykazy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPVykazyPrilohy]  DEFAULT ((0)) FOR [PAPVykazyPrilohy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPVykazyPAP]  DEFAULT ((0)) FOR [PAPVykazyPAP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPVykazyPouzeChyby]  DEFAULT ((0)) FOR [PAPVykazyPouzeChyby]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPICONazev]  DEFAULT ('') FOR [PAPICONazev]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LhutaSplatnostiDodavatel]  DEFAULT ((10)) FOR [LhutaSplatnostiDodavatel]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPrirazeniVydFak]  DEFAULT ((0)) FOR [BankaUhradyPrirazeniVydFak]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VychoziStavBlokaceVyroby]  DEFAULT ((0)) FOR [VychoziStavBlokaceVyroby]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatText]  DEFAULT ((0)) FOR [UzavObdEditovatText]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatPZ]  DEFAULT ((0)) FOR [UzavObdEditovatPZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatOrg]  DEFAULT ((0)) FOR [UzavObdEditovatOrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPovolEditVyrCS]  DEFAULT ((0)) FOR [OZPovolEditVyrCS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PAPDokladyNevyplPol]  DEFAULT ((0)) FOR [PAPDokladyNevyplPol]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatDD]  DEFAULT ((0)) FOR [UzavObdEditovatDD]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BrowseImpDenik]  DEFAULT ((0)) FOR [BrowseImpDenik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZCopyRozpisUmist]  DEFAULT ((1)) FOR [OZCopyRozpisUmist]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrVykDPH]  DEFAULT ((0)) FOR [KontrVykDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenDosleObjH02]  DEFAULT ((0)) FOR [ArchivaceZmenDosleObjH02]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LimitPDP]  DEFAULT ((5000.0)) FOR [LimitPDP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaDPH]  DEFAULT ((1)) FOR [KontrolaDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVykazLihu]  DEFAULT ((0)) FOR [OZVykazLihu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVykazLihuPodleData]  DEFAULT ((0)) FOR [OZVykazLihuPodleData]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMVychoziPlneniFakturace]  DEFAULT ((0)) FOR [CRMVychoziPlneniFakturace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHLimitUplaty]  DEFAULT ((0)) FOR [ZajisteniDPHLimitUplaty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NulovyVydejUct]  DEFAULT (N'A') FOR [NulovyVydejUct]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZaplaceneFakturyZohlednovatK]  DEFAULT ((0)) FOR [ZaplaceneFakturyZohlednovatK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyAutomat]  DEFAULT ((1)) FOR [FakZalohyAutomat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OvereniDICLogovatKazdeOvereni]  DEFAULT ((1)) FOR [OvereniDICLogovatKazdeOvereni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OvereniDICVyzadatUnikCisloKonzultace]  DEFAULT ((1)) FOR [OvereniDICVyzadatUnikCisloKonzultace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaImpPouzeVypisUctuVlastniFirmy]  DEFAULT ((1)) FOR [BankaImpPouzeVypisUctuVlastniFirmy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyKraceni]  DEFAULT ((1)) FOR [FakZalohyKraceni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DohledatScontoDle]  DEFAULT ((0)) FOR [DohledatScontoDle]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BlokDenikStavy]  DEFAULT ((0)) FOR [BlokDenikStavy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CLAImportyOrgNeurcitaZalozitOrg]  DEFAULT ((0)) FOR [CLAImportyOrgNeurcitaZalozitOrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZGetSazbuDPHOldKme]  DEFAULT ((0)) FOR [OZGetSazbuDPHOldKme]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZRezimKurzuDPHFaktur]  DEFAULT ((1)) FOR [OZRezimKurzuDPHFaktur]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMVychoziMenaPodkladuZS]  DEFAULT ((0)) FOR [CRMVychoziMenaPodkladuZS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMGenerovatPodkladZS]  DEFAULT ((1)) FOR [CRMGenerovatPodkladZS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CisloOrgSSCC]  DEFAULT ('') FOR [CisloOrgSSCC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KurzPriGenerPolozDokladu]  DEFAULT ((0)) FOR [KurzPriGenerPolozDokladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FaktZapoctyGenerKurzRozdilyPriUhrade]  DEFAULT ((2)) FOR [FaktZapoctyGenerKurzRozdilyPriUhrade]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FaktZapoctyCastecKurzRozdily]  DEFAULT ((0)) FOR [FaktZapoctyCastecKurzRozdily]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DruhDokladuPenFak]  DEFAULT ('') FOR [DruhDokladuPenFak]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPenFak]  DEFAULT ((0)) FOR [BankaUhradyPenFak]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MaskaDK]  DEFAULT ('') FOR [MaskaDK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrHlaDPH]  DEFAULT ((1)) FOR [KontrHlaDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZvlastniUpravaSK]  DEFAULT ((0)) FOR [ZvlastniUpravaSK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatDanoveKlice]  DEFAULT ((0)) FOR [PouzivatDanoveKlice]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NapocetSaldoSloupce]  DEFAULT ((0)) FOR [NapocetSaldoSloupce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVisibleDPHOldKme]  DEFAULT ((0)) FOR [OZVisibleDPHOldKme]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzitPrednastaCUNakup]  DEFAULT ((2)) FOR [PouzitPrednastaCUNakup]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZarovnaniOperaceTechPos]  DEFAULT ((0)) FOR [ZarovnaniOperaceTechPos]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KHNaslKontrola]  DEFAULT ((0)) FOR [KHNaslKontrola]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MetodaSkladu]  DEFAULT ((3)) FOR [MetodaSkladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KHKontrolaDenik]  DEFAULT ((1)) FOR [KHKontrolaDenik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KVKontrolaDenik]  DEFAULT ((1)) FOR [KVKontrolaDenik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatEET]  DEFAULT ((0)) FOR [PouzivatEET]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETOverovaciRezim]  DEFAULT ((0)) FOR [EETOverovaciRezim]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETPokladniProdej]  DEFAULT ('Pokladni prodej') FOR [EETPokladniProdej]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETPokladna]  DEFAULT ('Pokladna') FOR [EETPokladna]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETUhradaFaktury]  DEFAULT ('Uhrada faktur') FOR [EETUhradaFaktury]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatDic_Poverujiciho]  DEFAULT ((0)) FOR [PouzivatDic_Poverujiciho]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatCestovniSluzbu]  DEFAULT ((0)) FOR [PouzivatCestovniSluzbu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatPouziteZbozi]  DEFAULT ((0)) FOR [PouzivatPouziteZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatCerpani]  DEFAULT ((0)) FOR [PouzivatCerpani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETProdukcni]  DEFAULT ((0)) FOR [EETProdukcni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ProxyServer]  DEFAULT ('') FOR [ProxyServer]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ProxyUser]  DEFAULT ('') FOR [ProxyUser]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ProxyPassword]  DEFAULT ('') FOR [ProxyPassword]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ArchivaceZmenMzPaus]  DEFAULT ((0)) FOR [ArchivaceZmenMzPaus]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MetodaEvidCeny]  DEFAULT ((0)) FOR [MetodaEvidCeny]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__QR_MSGPlatba]  DEFAULT ((0)) FOR [QR_MSGPlatba]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__QR_MSGPlatbaText]  DEFAULT ('') FOR [QR_MSGPlatbaText]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__QR_MSGFaktura]  DEFAULT ((0)) FOR [QR_MSGFaktura]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__QR_MSGFakturaText]  DEFAULT ('') FOR [QR_MSGFakturaText]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPrirazeniVydFak1]  DEFAULT ((0)) FOR [BankaUhradyPrirazeniVydFak1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPrirazeniVydFak2]  DEFAULT (NULL) FOR [BankaUhradyPrirazeniVydFak2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPrirazeniVydFak3]  DEFAULT (NULL) FOR [BankaUhradyPrirazeniVydFak3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CenySlevyNakup]  DEFAULT ((1)) FOR [CenySlevyNakup]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelPlatPrenosPZ2]  DEFAULT ((0)) FOR [BankaVUcelPlatPrenosPZ2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyNeprirazovatFakturyPoSplatnosti]  DEFAULT ((0)) FOR [BankaUhradyNeprirazovatFakturyPoSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyHledatVSvUceluPlatby]  DEFAULT ((0)) FOR [BankaUhradyHledatVSvUceluPlatby]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PreucCZ]  DEFAULT ((0)) FOR [PreucCZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatOrgBankSpojArch]  DEFAULT ((1)) FOR [PouzivatOrgBankSpojArch]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatPZ2]  DEFAULT ((0)) FOR [PouzivatPZ2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DoplnDenikPZ2]  DEFAULT ((0)) FOR [DoplnDenikPZ2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NeExportZamKOs]  DEFAULT ((0)) FOR [NeExportZamKOs]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZNCdleMJ]  DEFAULT ((0)) FOR [OZNCdleMJ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZNahPlneni]  DEFAULT ((0)) FOR [OZNahPlneni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CRMRozsireneCenySlevy]  DEFAULT ((2)) FOR [CRMRozsireneCenySlevy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RozkopJeMzdObd]  DEFAULT ((0)) FOR [RozkopJeMzdObd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RozkopMazatLOG]  DEFAULT ((0)) FOR [RozkopMazatLOG]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZalSkladSolo]  DEFAULT ((0)) FOR [ZalSkladSolo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyPosuzovat]  DEFAULT ((0)) FOR [ZapoctyPosuzovat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyRuzneMeny]  DEFAULT ((0)) FOR [ZapoctyRuzneMeny]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyNeFaPoSpla]  DEFAULT ((0)) FOR [ZapoctyNeFaPoSpla]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyUctoFA]  DEFAULT ((0)) FOR [ZapoctyUctoFA]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyObdStavuFA]  DEFAULT ((0)) FOR [ZapoctyObdStavuFA]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyUctoSAL]  DEFAULT ((0)) FOR [ZapoctyUctoSAL]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctyObdStavuSAL]  DEFAULT ((0)) FOR [ZapoctyObdStavuSAL]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatUtv]  DEFAULT ((0)) FOR [UzavObdEditovatUtv]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatZak]  DEFAULT ((0)) FOR [UzavObdEditovatZak]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatNO]  DEFAULT ((0)) FOR [UzavObdEditovatNO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatVoz]  DEFAULT ((0)) FOR [UzavObdEditovatVoz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UzavObdEditovatZam]  DEFAULT ((0)) FOR [UzavObdEditovatZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaDuplPZPocetO]  DEFAULT ((1)) FOR [KontrolaDuplPZPocetO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaDuplPZUcty]  DEFAULT ((1)) FOR [KontrolaDuplPZUcty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatPomerKoef]  DEFAULT ((0)) FOR [PouzivatPomerKoef]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OprPolPredSpla]  DEFAULT ((0)) FOR [OprPolPredSpla]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZDSNKontrolaTrg]  DEFAULT ((1)) FOR [OZDSNKontrolaTrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVykazLihuOrgBezICO]  DEFAULT ((0)) FOR [OZVykazLihuOrgBezICO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPovolEditVyrCSNovy]  DEFAULT ((0)) FOR [OZPovolEditVyrCSNovy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPrevDrziCCEvid]  DEFAULT ((1)) FOR [OZPrevDrziCCEvid]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumZrusKoefDPH]  DEFAULT ('20190401') FOR [DatumZrusKoefDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LogSestavZapnout]  DEFAULT ((0)) FOR [LogSestavZapnout]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LogSestavCasLimit]  DEFAULT ((1000)) FOR [LogSestavCasLimit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHAutoZalozeniZverejBankUctu]  DEFAULT ((0)) FOR [ZajisteniDPHAutoZalozeniZverejBankUctu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMarze]  DEFAULT ((0)) FOR [OZMarze]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMarze_Doklad]  DEFAULT ((0)) FOR [OZMarze_Doklad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMarze_Polozka]  DEFAULT ((0)) FOR [OZMarze_Polozka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Zal30]  DEFAULT ((1)) FOR [Zal30]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UpozornovatNaNenavazanouZalohu]  DEFAULT ((1)) FOR [UpozornovatNaNenavazanouZalohu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHtabSKPlatciDPHNaZruseni]  DEFAULT ((0)) FOR [ZajisteniDPHtabSKPlatciDPHNaZruseni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHtabSKPlatciDPHVymazani]  DEFAULT ((0)) FOR [ZajisteniDPHtabSKPlatciDPHVymazani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHtabSKPlatciDPHOsobUprava]  DEFAULT ((0)) FOR [ZajisteniDPHtabSKPlatciDPHOsobUprava]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHtabSKDanDluznici]  DEFAULT ((0)) FOR [ZajisteniDPHtabSKDanDluznici]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHtabSKDanSubjRegSD]  DEFAULT ((0)) FOR [ZajisteniDPHtabSKDanSubjRegSD]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHKontrolovatPlatceNaZruseni]  DEFAULT ((0)) FOR [ZajisteniDPHKontrolovatPlatceNaZruseni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AktMnozKVyr_VsechnySkl]  DEFAULT ((0)) FOR [AktMnozKVyr_VsechnySkl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PK_MaxPocetZnakuMnozstvi]  DEFAULT ((12)) FOR [PK_MaxPocetZnakuMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__SeskupitCasRozliseni]  DEFAULT ((0)) FOR [SeskupitCasRozliseni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FiltrGlobal]  DEFAULT ((1)) FOR [FiltrGlobal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZalSkladPK]  DEFAULT ((0)) FOR [ZalSkladPK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UhrKartaFakEET]  DEFAULT ((0)) FOR [UhrKartaFakEET]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatEANKod]  DEFAULT ((1)) FOR [PoklProdHledatEANKod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatVahaKod]  DEFAULT ((0)) FOR [PoklProdHledatVahaKod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSkladPriDatumHist]  DEFAULT ('20200101') FOR [OZSkladPriDatumHist]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSlepaProcCena]  DEFAULT ((0)) FOR [OZSlepaProcCena]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVychoziZUStorno]  DEFAULT ((0)) FOR [PoklProdVychoziZUStorno]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVychoziZUVratka]  DEFAULT ((2)) FOR [PoklProdVychoziZUVratka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AplikujSlevyIProMinusovePolozky]  DEFAULT ((0)) FOR [AplikujSlevyIProMinusovePolozky]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyVysledekAPU]  DEFAULT ((1)) FOR [BankaUhradyVysledekAPU]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyVysledekPrUcto]  DEFAULT ((1)) FOR [BankaUhradyVysledekPrUcto]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZTrgInsertVyrCK]  DEFAULT ((1)) FOR [OZTrgInsertVyrCK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MzIRDblCheck]  DEFAULT ((0)) FOR [MzIRDblCheck]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KHAktualUzav]  DEFAULT ((2)) FOR [KHAktualUzav]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KVAktualUzav]  DEFAULT ((2)) FOR [KVAktualUzav]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaDuplicityPZ2]  DEFAULT ((0)) FOR [KontrolaDuplicityPZ2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KontrolaSmerPlneni]  DEFAULT ((0)) FOR [KontrolaSmerPlneni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZShodaVCSVyrCK]  DEFAULT ((0)) FOR [OZShodaVCSVyrCK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZDSNMetodaStoV]  DEFAULT ((1)) FOR [OZDSNMetodaStoV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklLimitPlatebHotovCastka]  DEFAULT ((0)) FOR [PoklLimitPlatebHotovCastka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklLimitPlatebHotovKontrola]  DEFAULT ((0)) FOR [PoklLimitPlatebHotovKontrola]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OvereniDICAktualniDIC]  DEFAULT ((0)) FOR [OvereniDICAktualniDIC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoziceZaokrPriPrepoctuCasuTechPos]  DEFAULT ((6)) FOR [PoziceZaokrPriPrepoctuCasuTechPos]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKRegistrovaneSubjekty]  DEFAULT ((0)) FOR [ZajisteniDPHSKRegistrovaneSubjekty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKKontrolovatSubjekty]  DEFAULT ((0)) FOR [ZajisteniDPHSKKontrolovatSubjekty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__UctoJakHledatKurzProNZ]  DEFAULT ((0)) FOR [UctoJakHledatKurzProNZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPresnaCastka]  DEFAULT ((0)) FOR [BankaUhradyPresnaCastka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZNoveVCProExistVyrCK]  DEFAULT ((0)) FOR [OZNoveVCProExistVyrCK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZTrgHlidaZaporneVC]  DEFAULT ((0)) FOR [OZTrgHlidaZaporneVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaBSHledatTu]  DEFAULT ((0)) FOR [BankaBSHledatTu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaPrenosFakturyZvs]  DEFAULT ((1)) FOR [BankaPrenosFakturyZvs]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatNazev]  DEFAULT ((0)) FOR [PoklProdHledatNazev]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdTestMnozTyp]  DEFAULT ((0)) FOR [PoklProdTestMnozTyp]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakOdpocetZaloh]  DEFAULT ((1)) FOR [FakOdpocetZaloh]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumPoslednihoLogu]  DEFAULT ('19000101') FOR [DatumPoslednihoLogu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OrgPravniForma]  DEFAULT ((0)) FOR [OrgPravniForma]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMakeSkladPriNewVC]  DEFAULT ((1)) FOR [OZMakeSkladPriNewVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NZB]  DEFAULT ((0)) FOR [NZB]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribLayoutDef]  DEFAULT ('19000101') FOR [DatumDistribLayoutDef]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NotifikaceProdlevaMazani]  DEFAULT ((7)) FOR [NotifikaceProdlevaMazani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NotifikaceIntervalCheckovani]  DEFAULT ((10)) FOR [NotifikaceIntervalCheckovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__Notifikace_TypPushNotifikace]  DEFAULT ((0)) FOR [Notifikace_TypPushNotifikace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__StromNS]  DEFAULT ((1)) FOR [StromNS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaAutoUhrDleSym]  DEFAULT ((0)) FOR [BankaAutoUhrDleSym]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZalHalKorekce]  DEFAULT ((0)) FOR [ZalHalKorekce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatZakaznik]  DEFAULT ((0)) FOR [PoklProdHledatZakaznik]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaBSHledatProti]  DEFAULT ((1)) FOR [BankaBSHledatProti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaBSHledatJedin]  DEFAULT ((0)) FOR [BankaBSHledatJedin]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPresnaCastkaLea]  DEFAULT ((0)) FOR [BankaUhradyPresnaCastkaLea]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZStromVC]  DEFAULT ((0)) FOR [OZStromVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZFilNulVC]  DEFAULT ((0)) FOR [OZFilNulVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZNCdleDatumOdDo]  DEFAULT ((0)) FOR [OZNCdleDatumOdDo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitDoValutHM]  DEFAULT ((1)) FOR [PovolitDoValutHM]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BanVypHledatPomText]  DEFAULT ((0)) FOR [BanVypHledatPomText]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZStromVcetneUmi]  DEFAULT ((0)) FOR [OZStromVcetneUmi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPohybyVCPodPolo]  DEFAULT ((0)) FOR [OZPohybyVCPodPolo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NavazDokInfoPanelMaxLevel]  DEFAULT ((1)) FOR [NavazDokInfoPanelMaxLevel]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatNazObsah]  DEFAULT ((1)) FOR [PoklProdHledatNazObsah]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatVouchery]  DEFAULT ((0)) FOR [PoklProdHledatVouchery]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdKartNevybVouch]  DEFAULT ((0)) FOR [PoklProdKartNevybVouch]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVychoziUhrada]  DEFAULT ((1)) FOR [PoklProdVychoziUhrada]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVychoziVyplnit]  DEFAULT ((0)) FOR [PoklProdVychoziVyplnit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RezimMOSSDatumDo]  DEFAULT ('20210701') FOR [RezimMOSSDatumDo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LogMonitorActionFrekvence]  DEFAULT ((1)) FOR [LogMonitorActionFrekvence]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__GenDDPPRealFaPosuzovat]  DEFAULT ((0)) FOR [GenDDPPRealFaPosuzovat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelPlatPrenosPZ]  DEFAULT ((1)) FOR [BankaVUcelPlatPrenosPZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelPlatPrenosOrgZam]  DEFAULT ((1)) FOR [BankaVUcelPlatPrenosOrgZam]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelPlatPrenosPopisDod]  DEFAULT ((0)) FOR [BankaVUcelPlatPrenosPopisDod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelPlatPrenosObjednavka]  DEFAULT ((0)) FOR [BankaVUcelPlatPrenosObjednavka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MazatDenUzavVykaz]  DEFAULT ((0)) FOR [MazatDenUzavVykaz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMetodaVCRealKD]  DEFAULT ((0)) FOR [OZMetodaVCRealKD]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSlevyBezRecykl]  DEFAULT ((0)) FOR [OZSlevyBezRecykl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HlidatVazbyUctuDimenze]  DEFAULT ((0)) FOR [HlidatVazbyUctuDimenze]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HlidatVazbyUctuUcet]  DEFAULT ((0)) FOR [HlidatVazbyUctuUcet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitVazbyUctuPred]  DEFAULT ((0)) FOR [PovolitVazbyUctuPred]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitVazbyUctuFiltr]  DEFAULT ((0)) FOR [PovolitVazbyUctuFiltr]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky1]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky2]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky3]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky4]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky5]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky6]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky6]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNPolozkaDoFaPZPrijemky7]  DEFAULT ((0)) FOR [OZSNPolozkaDoFaPZPrijemky7]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber1]  DEFAULT ((0)) FOR [OZSNSkladVyber1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber2]  DEFAULT ((0)) FOR [OZSNSkladVyber2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber3]  DEFAULT ((0)) FOR [OZSNSkladVyber3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber4]  DEFAULT ((0)) FOR [OZSNSkladVyber4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber5]  DEFAULT ((0)) FOR [OZSNSkladVyber5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber6]  DEFAULT ((0)) FOR [OZSNSkladVyber6]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZSNSkladVyber7]  DEFAULT ((0)) FOR [OZSNSkladVyber7]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobGenerovaniCarovehoKodu]  DEFAULT ((0)) FOR [ZpusobGenerovaniCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMetodaSD]  DEFAULT ((0)) FOR [OZMetodaSD]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZJenZUmisteniNaVydejce]  DEFAULT ((0)) FOR [OZJenZUmisteniNaVydejce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyRekapEnergie]  DEFAULT ((0)) FOR [FakZalohyRekapEnergie]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKPovolitSledovaniBankUctu]  DEFAULT ((1)) FOR [ZajisteniDPHSKPovolitSledovaniBankUctu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKAutoOnlineOvereniNaDokladu]  DEFAULT ((1)) FOR [ZajisteniDPHSKAutoOnlineOvereniNaDokladu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]  DEFAULT ((1)) FOR [ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKAutoZalozeniZverejBankUctu]  DEFAULT ((0)) FOR [ZajisteniDPHSKAutoZalozeniZverejBankUctu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKInfoPriVystTuzPP]  DEFAULT ((1)) FOR [ZajisteniDPHSKInfoPriVystTuzPP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKSeznamPlatcu]  DEFAULT ((1)) FOR [ZajisteniDPHSKSeznamPlatcu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHlasitBlokZbozi]  DEFAULT ((1)) FOR [PoklProdHlasitBlokZbozi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RootPathForDocs]  DEFAULT ('') FOR [RootPathForDocs]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSKAPIKlic]  DEFAULT ('') FOR [ZajisteniDPHSKAPIKlic]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NerusitVDosleObjNavazTxt02]  DEFAULT ((0)) FOR [NerusitVDosleObjNavazTxt02]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaSchvalovaniBS]  DEFAULT ((0)) FOR [BankaSchvalovaniBS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaSchvaleniZverejnenych]  DEFAULT ((0)) FOR [BankaSchvaleniZverejnenych]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdZpozdenyPrepoc]  DEFAULT ((1)) FOR [PoklProdZpozdenyPrepoc]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_Vystavovani]  DEFAULT ((0)) FOR [AutoUPOMPF_Vystavovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_CoGener]  DEFAULT ((2)) FOR [AutoUPOMPF_CoGener]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UkoncitPrg]  DEFAULT ((1)) FOR [AutoUPOMPF_UkoncitPrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomPeriod]  DEFAULT ((14)) FOR [AutoUPOMPF_UpomPeriod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomMaxPocet]  DEFAULT ((3)) FOR [AutoUPOMPF_UpomMaxPocet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomPoDnu]  DEFAULT ((7)) FOR [AutoUPOMPF_UpomPoDnu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_PenalPoDnu]  DEFAULT ((3)) FOR [AutoUPOMPF_PenalPoDnu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZPrepMJStanJC]  DEFAULT ((1)) FOR [OZPrepMJStanJC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribDashboardu]  DEFAULT ('19000101') FOR [DatumDistribDashboardu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__KraceniDanVydajuSK]  DEFAULT ((0)) FOR [KraceniDanVydajuSK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CLAECR2023]  DEFAULT ((1)) FOR [CLAECR2023]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZZpusobRealizace]  DEFAULT ((0)) FOR [OZZpusobRealizace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VydejEvCenaSSCC]  DEFAULT ((0)) FOR [VydejEvCenaSSCC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdZmenaCenVratka]  DEFAULT ((0)) FOR [PoklProdZmenaCenVratka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdMnozstviHvezda]  DEFAULT ((0)) FOR [PoklProdMnozstviHvezda]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVUcelOddelovac]  DEFAULT ((0)) FOR [BankaVUcelOddelovac]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdNewStorno]  DEFAULT ((0)) FOR [PoklProdNewStorno]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZFinRealJeDrivMnoReal]  DEFAULT ((0)) FOR [OZFinRealJeDrivMnoReal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZFinRealJeDrivNezReal]  DEFAULT ((0)) FOR [OZFinRealJeDrivNezReal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMnoRealJePoteFinReal]  DEFAULT ((0)) FOR [OZMnoRealJePoteFinReal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZMnoRealTestMnozstvi]  DEFAULT ((0)) FOR [OZMnoRealTestMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZAktualizaceSlevPolozky]  DEFAULT ((1)) FOR [OZAktualizaceSlevPolozky]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobPevneKurzyBanka]  DEFAULT ((0)) FOR [ZpusobPevneKurzyBanka]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ProxyIESettings]  DEFAULT ((0)) FOR [ProxyIESettings]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RozsireneKurzy]  DEFAULT ((0)) FOR [RozsireneKurzy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdHledatVyrCis]  DEFAULT ((0)) FOR [PoklProdHledatVyrCis]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobPevneKurzyDPH]  DEFAULT ((0)) FOR [ZpusobPevneKurzyDPH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobPevneKurzyZap]  DEFAULT ((0)) FOR [ZpusobPevneKurzyZap]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobPevneKurzyNZ]  DEFAULT ((0)) FOR [ZpusobPevneKurzyNZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FinStatAPIKlic]  DEFAULT ('') FOR [FinStatAPIKlic]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PokladnaJakHledatKurz]  DEFAULT ((11)) FOR [PokladnaJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PokladnaZpusobPevneKurzy]  DEFAULT ((0)) FOR [PokladnaZpusobPevneKurzy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyFakturyNehradit]  DEFAULT ((1)) FOR [BankaUhradyFakturyNehradit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FaSklJakHledatKurz]  DEFAULT ((1)) FOR [FaSklJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FaSklZpusobPevneKurzy]  DEFAULT ((0)) FOR [FaSklZpusobPevneKurzy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AresNovy]  DEFAULT ((1)) FOR [AresNovy]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_FaktOdeslat]  DEFAULT ((0)) FOR [AutoUPOMPF_FaktOdeslat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DOBJStavVCVEditoruPol]  DEFAULT ((0)) FOR [DOBJStavVCVEditoruPol]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PouzivatPomerKoefPuvodni]  DEFAULT ((0)) FOR [PouzivatPomerKoefPuvodni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__eFaktura]  DEFAULT ((0)) FOR [eFaktura]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZTypGenStov]  DEFAULT ((0)) FOR [OZTypGenStov]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdNikdyZobrazVratit]  DEFAULT ((0)) FOR [PoklProdNikdyZobrazVratit]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZZapoctiFaPDoOdebMnoz]  DEFAULT ((0)) FOR [OZZapoctiFaPDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZZapoctiFaVDoOdebMnoz]  DEFAULT ((0)) FOR [OZZapoctiFaVDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_FARokyZpet]  DEFAULT ((3)) FOR [AutoUPOMPF_FARokyZpet]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__RespektovatNastaveniKontrolVC]  DEFAULT ((0)) FOR [RespektovatNastaveniKontrolVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaMenaBSTuP]  DEFAULT ((0)) FOR [BankaMenaBSTuP]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaBSHledatZa]  DEFAULT ((0)) FOR [BankaBSHledatZa]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyNaOrgBS]  DEFAULT ((0)) FOR [BankaUhradyNaOrgBS]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZDSNNavDok]  DEFAULT ((0)) FOR [OZDSNNavDok]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZDSNAutoReal]  DEFAULT ((0)) FOR [OZDSNAutoReal]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZpusobZruseniKRBilDen]  DEFAULT ((0)) FOR [ZpusobZruseniKRBilDen]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZobrazitPlatnyKurz]  DEFAULT ((0)) FOR [ZobrazitPlatnyKurz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyPrepocitatKurzemUhrady]  DEFAULT ((0)) FOR [FakZalohyPrepocitatKurzemUhrady]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyRekap10CZ]  DEFAULT ((1)) FOR [FakZalohyRekap10CZ]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NotifikaceGlobalStopCheckovani]  DEFAULT ((0)) FOR [NotifikaceGlobalStopCheckovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutomatizaceOdesilatelJmeno]  DEFAULT ('') FOR [AutomatizaceOdesilatelJmeno]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutomatizaceOdesilatelEmail]  DEFAULT ('') FOR [AutomatizaceOdesilatelEmail]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutUlozitDoDB]  DEFAULT ((0)) FOR [AutUlozitDoDB]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutZahrnoutDoVseobDok]  DEFAULT ((3)) FOR [AutZahrnoutDoVseobDok]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutDoSouboruCesta]  DEFAULT ('') FOR [AutDoSouboruCesta]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutVytvorAdresar]  DEFAULT ((0)) FOR [AutVytvorAdresar]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutPDFElPodpisOffsetX]  DEFAULT ((0)) FOR [AutPDFElPodpisOffsetX]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutPDFElPodpisOffsetY]  DEFAULT ((0)) FOR [AutPDFElPodpisOffsetY]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutPDFZobrazitElPodpis]  DEFAULT ((0)) FOR [AutPDFZobrazitElPodpis]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_PrednOrg]  DEFAULT ((0)) FOR [AutoUPOMPF_PrednOrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpoUlozenoDB]  DEFAULT ((0)) FOR [AutoUPOMPF_UpoUlozenoDB]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpoVseobDok]  DEFAULT ((0)) FOR [AutoUPOMPF_UpoVseobDok]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_LimitMBEmail]  DEFAULT ((0.0)) FOR [AutoUPOMPF_LimitMBEmail]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_Vyrizuje]  DEFAULT ((0)) FOR [AutoUPOMPF_Vyrizuje]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoEditace]  DEFAULT (N'N') FOR [AutoUctoEditace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoObdobi]  DEFAULT ((0)) FOR [AutoUctoObdobi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoObdobiLeas]  DEFAULT ((0)) FOR [AutoUctoObdobiLeas]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoRefresh]  DEFAULT ((1)) FOR [AutoUctoRefresh]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoExtProc]  DEFAULT ((0)) FOR [AutoUctoExtProc]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoUkoncitPrg]  DEFAULT ((1)) FOR [AutoUctoUkoncitPrg]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DenikMenaDatumOd]  DEFAULT (CONVERT([datetime],CONVERT([int],CONVERT([float],getdate())))) FOR [DenikMenaDatumOd]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisDatumSalda]  DEFAULT ((0)) FOR [BankaVypisDatumSalda]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PovolitZajisteniDilcu]  DEFAULT ((0)) FOR [PovolitZajisteniDilcu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__MzAutomatUcto]  DEFAULT ((0)) FOR [MzAutomatUcto]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoObdobiMaj]  DEFAULT ((0)) FOR [AutoUctoObdobiMaj]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUctoExtProc05]  DEFAULT ((0)) FOR [AutoUctoExtProc05]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRychlaPlatba1]  DEFAULT ('') FOR [PoklProdRychlaPlatba1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRychlaPlatba2]  DEFAULT ('') FOR [PoklProdRychlaPlatba2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRychlaPlatba3]  DEFAULT ('') FOR [PoklProdRychlaPlatba3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRychlaPlatba4]  DEFAULT ('') FOR [PoklProdRychlaPlatba4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdRychlaPlatba5]  DEFAULT ('') FOR [PoklProdRychlaPlatba5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBarvaPlatba1]  DEFAULT ((0)) FOR [PoklProdBarvaPlatba1]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBarvaPlatba2]  DEFAULT ((0)) FOR [PoklProdBarvaPlatba2]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBarvaPlatba3]  DEFAULT ((0)) FOR [PoklProdBarvaPlatba3]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBarvaPlatba4]  DEFAULT ((0)) FOR [PoklProdBarvaPlatba4]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdBarvaPlatba5]  DEFAULT ((0)) FOR [PoklProdBarvaPlatba5]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribAutDef]  DEFAULT ('19000101') FOR [DatumDistribAutDef]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZapoctySaldoVPriprave]  DEFAULT ((0)) FOR [ZapoctySaldoVPriprave]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyRekap1020SK]  DEFAULT ((1)) FOR [FakZalohyRekap1020SK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HighNotif_SkipPingTest]  DEFAULT ((0)) FOR [HighNotif_SkipPingTest]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutZobrazitInfoUkonceni]  DEFAULT ((0)) FOR [AutZobrazitInfoUkonceni]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutSpoustetOpakovane]  DEFAULT ((1)) FOR [AutSpoustetOpakovane]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutArchivovatEmaily]  DEFAULT ((0)) FOR [AutArchivovatEmaily]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutEmailOpakovane]  DEFAULT ((0)) FOR [AutEmailOpakovane]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__LimitObratu]  DEFAULT ((0)) FOR [LimitObratu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_PredmetUPO]  DEFAULT ((0)) FOR [AutoUPOMPF_PredmetUPO]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_PredmetPenFak]  DEFAULT ((0)) FOR [AutoUPOMPF_PredmetPenFak]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdVratkaNewSklad]  DEFAULT ((1)) FOR [PoklProdVratkaNewSklad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZHlidatRealizujVydej]  DEFAULT ((1)) FOR [OZHlidatRealizujVydej]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CLANCTSPrechodneObdobi]  DEFAULT ((0)) FOR [CLANCTSPrechodneObdobi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DnyToleranceScontaFaV]  DEFAULT ((0)) FOR [DnyToleranceScontaFaV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HighNotif_Logovani]  DEFAULT ((0)) FOR [HighNotif_Logovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__VerzeProgramu]  DEFAULT (N'000000000000') FOR [VerzeProgramu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__JakZajistovatStinovePolozky]  DEFAULT ((1)) FOR [JakZajistovatStinovePolozky]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZZpusobZapStoren]  DEFAULT ((0)) FOR [OZZpusobZapStoren]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHLimitHotovost]  DEFAULT ((270000)) FOR [ZajisteniDPHLimitHotovost]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdKurzOdvod]  DEFAULT ((1)) FOR [PoklProdKurzOdvod]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DruhSkladuDSN]  DEFAULT ((2)) FOR [DruhSkladuDSN]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PosunSamovymereniKH]  DEFAULT ((0)) FOR [PosunSamovymereniKH]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DanFinancniTransakce]  DEFAULT ((0)) FOR [DanFinancniTransakce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PripravnyRezimDK]  DEFAULT ((0)) FOR [PripravnyRezimDK]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomDoDnu]  DEFAULT ((0)) FOR [AutoUPOMPF_UpomDoDnu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZOddelovacVC]  DEFAULT ('Ť') FOR [OZOddelovacVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVyrCPInfoPanelDokumentyZdroj]  DEFAULT ((0)) FOR [OZVyrCPInfoPanelDokumentyZdroj]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaVypisNepovolPripravu]  DEFAULT ((0)) FOR [BankaVypisNepovolPripravu]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__HlidatPovinnosti]  DEFAULT ((0)) FOR [HlidatPovinnosti]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__SKVykaz411]  DEFAULT ((0)) FOR [SKVykaz411]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AVAOrgUnitParentSend]  DEFAULT ((1)) FOR [AVAOrgUnitParentSend]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUhradyPrirazeniVydDob]  DEFAULT ((0)) FOR [BankaUhradyPrirazeniVydDob]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CLAECSPrechodneObdobi]  DEFAULT ((0)) FOR [CLAECSPrechodneObdobi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PoklProdKartSlevaVouch]  DEFAULT ((0)) FOR [PoklProdKartSlevaVouch]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__FakZalohyDetail]  DEFAULT ((1)) FOR [FakZalohyDetail]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AVAAgentIntervalCheckovani]  DEFAULT ((1800)) FOR [AVAAgentIntervalCheckovani]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZRespektovatPolSplneno]  DEFAULT ((0)) FOR [OZRespektovatPolSplneno]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OprPolCMSaldo]  DEFAULT ((0)) FOR [OprPolCMSaldo]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PrenosKoefDPHVozidla]  DEFAULT ((0)) FOR [PrenosKoefDPHVozidla]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomVarianta]  DEFAULT ((0)) FOR [AutoUPOMPF_UpomVarianta]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_PenalVarianta]  DEFAULT ((0)) FOR [AutoUPOMPF_PenalVarianta]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__ZajisteniDPHSkupRegistrNezverejnovat]  DEFAULT ((1)) FOR [ZajisteniDPHSkupRegistrNezverejnovat]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribAutExtAkce]  DEFAULT ('19000101') FOR [DatumDistribAutExtAkce]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__NapocetSaldoOrgNew]  DEFAULT ((1)) FOR [NapocetSaldoOrgNew]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__OZVCTestMnoz]  DEFAULT ((0)) FOR [OZVCTestMnoz]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__CLAICSPrechodneObdobi]  DEFAULT ((0)) FOR [CLAICSPrechodneObdobi]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PrepoctiMnozstviVC]  DEFAULT ((1)) FOR [PrepoctiMnozstviVC]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DatumDistribUcetKodyKontace]  DEFAULT ('19000101') FOR [DatumDistribUcetKodyKontace]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__BankaUctovatNuloveBV]  DEFAULT ((0)) FOR [BankaUctovatNuloveBV]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__DPHPrvDoklad]  DEFAULT ((1)) FOR [DPHPrvDoklad]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETEICPoplatnika]  DEFAULT ('') FOR [EETEICPoplatnika]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__EETPovereniVicePopl]  DEFAULT ((0)) FOR [EETPovereniVicePopl]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__PohlDotazAktual]  DEFAULT ((1)) FOR [PohlDotazAktual]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__SaldoDotazAktual]  DEFAULT ((1)) FOR [SaldoDotazAktual]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomDobropis]  DEFAULT ((0)) FOR [AutoUPOMPF_UpomDobropis]
GO
ALTER TABLE [dbo].[TabHGlob] ADD  CONSTRAINT [DF__TabHGlob__AutoUPOMPF_UpomZapFakP]  DEFAULT ((0)) FOR [AutoUPOMPF_UpomZapFakP]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutIDDokumStrom] FOREIGN KEY([AutIDDokumStrom])
REFERENCES [dbo].[TabDokumStrom] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutIDDokumStrom]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_DatSchrOdes] FOREIGN KEY([AutoUPOMPF_DatSchrOdes])
REFERENCES [dbo].[TabEvPSchranky] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_DatSchrOdes]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_EmailProfil] FOREIGN KEY([AutoUPOMPF_EmailProfil])
REFERENCES [dbo].[TabEMailProfil] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_EmailProfil]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_FaktFormat] FOREIGN KEY([AutoUPOMPF_FaktFormat])
REFERENCES [dbo].[TabEDocEngineNastaveni] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_FaktFormat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_FaktTiskForm] FOREIGN KEY([AutoUPOMPF_FaktTiskForm])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_FaktTiskForm]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_PenalTiskForm] FOREIGN KEY([AutoUPOMPF_PenalTiskForm])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_PenalTiskForm]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_PFIDTextEmail] FOREIGN KEY([AutoUPOMPF_PFIDTextEmail])
REFERENCES [dbo].[TabEMailText] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_PFIDTextEmail]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_TiskFormat] FOREIGN KEY([AutoUPOMPF_TiskFormat])
REFERENCES [dbo].[TabEDocEngineNastaveni] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_TiskFormat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_UpomIDTextEmail] FOREIGN KEY([AutoUPOMPF_UpomIDTextEmail])
REFERENCES [dbo].[TabEMailText] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_UpomIDTextEmail]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__AutoUPOMPF_UpomTiskForm] FOREIGN KEY([AutoUPOMPF_UpomTiskForm])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__AutoUPOMPF_UpomTiskForm]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisSpecUcet] FOREIGN KEY([BankaVypisSpecUcet])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisSpecUcet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyBUDebet] FOREIGN KEY([BankaVypisTypZmenyBUDebet])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyBUDebet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyBUKredit] FOREIGN KEY([BankaVypisTypZmenyBUKredit])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyBUKredit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyDebet] FOREIGN KEY([BankaVypisTypZmenyDebet])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyDebet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyKredit] FOREIGN KEY([BankaVypisTypZmenyKredit])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisTypZmenyKredit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__BankaVypisUcetProPrevodMeziVlastnimiBU] FOREIGN KEY([BankaVypisUcetProPrevodMeziVlastnimiBU])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__BankaVypisUcetProPrevodMeziVlastnimiBU]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__CenovaUroven] FOREIGN KEY([CenovaUroven])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__CenovaUroven]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__CenovaUrovenNakup] FOREIGN KEY([CenovaUrovenNakup])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__CenovaUrovenNakup]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__CRMKategorieCRM] FOREIGN KEY([CRMKategorieCRM])
REFERENCES [dbo].[TabKategKontJed] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__CRMKategorieCRM]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__DUDProPreuctovani] FOREIGN KEY([DUDProPreuctovani])
REFERENCES [dbo].[TabSbornik] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__DUDProPreuctovani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__FaSklIdDruhyUzivKurzu] FOREIGN KEY([FaSklIdDruhyUzivKurzu])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__FaSklIdDruhyUzivKurzu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__IDAutTypDoSouboru] FOREIGN KEY([IDAutTypDoSouboru])
REFERENCES [dbo].[TabEDocEngineNastaveni] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__IDAutTypDoSouboru]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuBanka] FOREIGN KEY([IdDruhyUzivKurzuBanka])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuBanka]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuDPH] FOREIGN KEY([IdDruhyUzivKurzuDPH])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuNZ] FOREIGN KEY([IdDruhyUzivKurzuNZ])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuNZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuZap] FOREIGN KEY([IdDruhyUzivKurzuZap])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__IdDruhyUzivKurzuZap]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__KartoveCentrumPoplatkyUcetVazba] FOREIGN KEY([KartoveCentrumPoplatkyUcetVazba])
REFERENCES [dbo].[TabBankSpojUcto] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__KartoveCentrumPoplatkyUcetVazba]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__MzPDF1] FOREIGN KEY([MzPDF1])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__MzPDF1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__MzPDF2] FOREIGN KEY([MzPDF2])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__MzPDF2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__MzPDF3] FOREIGN KEY([MzPDF3])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__MzPDF3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__MzPDF4] FOREIGN KEY([MzPDF4])
REFERENCES [dbo].[TabFormDef] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__MzPDF4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta1] FOREIGN KEY([OZSNKmenKarta1])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta2] FOREIGN KEY([OZSNKmenKarta2])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta3] FOREIGN KEY([OZSNKmenKarta3])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta4] FOREIGN KEY([OZSNKmenKarta4])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta5] FOREIGN KEY([OZSNKmenKarta5])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta6] FOREIGN KEY([OZSNKmenKarta6])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta6]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNKmenKarta7] FOREIGN KEY([OZSNKmenKarta7])
REFERENCES [dbo].[TabKmenZbozi] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNKmenKarta7]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad1] FOREIGN KEY([OZSNSklad1])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad2] FOREIGN KEY([OZSNSklad2])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad3] FOREIGN KEY([OZSNSklad3])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad4] FOREIGN KEY([OZSNSklad4])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad5] FOREIGN KEY([OZSNSklad5])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad6] FOREIGN KEY([OZSNSklad6])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad6]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__OZSNSklad7] FOREIGN KEY([OZSNSklad7])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__OZSNSklad7]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PokladnaIdDruhyUzivKurzu] FOREIGN KEY([PokladnaIdDruhyUzivKurzu])
REFERENCES [dbo].[TabDruhyUzivKurzu] ([ID])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PokladnaIdDruhyUzivKurzu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PokladnaUcetPrevodJinaPokladna] FOREIGN KEY([PokladnaUcetPrevodJinaPokladna])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PokladnaUcetPrevodJinaPokladna]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdCenUrovenEtalon] FOREIGN KEY([PoklProdCenUrovenEtalon])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdCenUrovenEtalon]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdCenUrovenProdej] FOREIGN KEY([PoklProdCenUrovenProdej])
REFERENCES [dbo].[TabCisNC] ([CenovaUroven])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdCenUrovenProdej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdOdberatel] FOREIGN KEY([PoklProdOdberatel])
REFERENCES [dbo].[TabCisOrg] ([CisloOrg])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdOdberatel]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady1] FOREIGN KEY([PoklProdZpusobUhrady1])
REFERENCES [dbo].[TabUctenkaZpusobUhrady] ([ZpusobUhrady])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady2] FOREIGN KEY([PoklProdZpusobUhrady2])
REFERENCES [dbo].[TabUctenkaZpusobUhrady] ([ZpusobUhrady])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady3] FOREIGN KEY([PoklProdZpusobUhrady3])
REFERENCES [dbo].[TabUctenkaZpusobUhrady] ([ZpusobUhrady])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady4] FOREIGN KEY([PoklProdZpusobUhrady4])
REFERENCES [dbo].[TabUctenkaZpusobUhrady] ([ZpusobUhrady])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady5] FOREIGN KEY([PoklProdZpusobUhrady5])
REFERENCES [dbo].[TabUctenkaZpusobUhrady] ([ZpusobUhrady])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__PoklProdZpusobUhrady5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__RV_CisloKontace_PrirustekNV] FOREIGN KEY([RV_CisloKontace_PrirustekNV])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__RV_CisloKontace_PrirustekNV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__RV_CisloKontace_UbytekNV] FOREIGN KEY([RV_CisloKontace_UbytekNV])
REFERENCES [dbo].[TabUKod] ([CisloKontace])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__RV_CisloKontace_UbytekNV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__SalSkPohlCZ] FOREIGN KEY([SalSkPohlCZ])
REFERENCES [dbo].[TabSalSk] ([CisloSalSk])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__SalSkPohlCZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__SalSkPohlSK] FOREIGN KEY([SalSkPohlSK])
REFERENCES [dbo].[TabSalSk] ([CisloSalSk])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__SalSkPohlSK]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__SkladSluzeb] FOREIGN KEY([SkladSluzeb])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__SkladSluzeb]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__TypZmenyDebet] FOREIGN KEY([TypZmenyDebet])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__TypZmenyDebet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__TypZmenyZapocty] FOREIGN KEY([TypZmenyZapocty])
REFERENCES [dbo].[TabTypyZmen] ([TypZmeny])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__TypZmenyZapocty]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__UcetZaokrNaklad] FOREIGN KEY([UcetZaokrNaklad])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__UcetZaokrNaklad]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__UcetZaokrVynos] FOREIGN KEY([UcetZaokrVynos])
REFERENCES [dbo].[TabCisUct] ([CisloUcet])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__UcetZaokrVynos]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__UctoZapoctuUtvar] FOREIGN KEY([UctoZapoctuUtvar])
REFERENCES [dbo].[TabStrom] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__UctoZapoctuUtvar]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__ZapoctyDUDFA] FOREIGN KEY([ZapoctyDUDFA])
REFERENCES [dbo].[TabSbornik] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__ZapoctyDUDFA]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [FK__TabHGlob__ZapoctyDUDSAL] FOREIGN KEY([ZapoctyDUDSAL])
REFERENCES [dbo].[TabSbornik] ([Cislo])
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [FK__TabHGlob__ZapoctyDUDSAL]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AplikujSlevyIProMinusovePolozky] CHECK  (([AplikujSlevyIProMinusovePolozky]>=(0) AND [AplikujSlevyIProMinusovePolozky]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AplikujSlevyIProMinusovePolozky]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutomatPoklDokl] CHECK  (([AutomatPoklDokl]=(2) OR [AutomatPoklDokl]=(1) OR [AutomatPoklDokl]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutomatPoklDokl]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoEditace] CHECK  ((ascii([AutoUctoEditace])=(65) OR ascii([AutoUctoEditace])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoEditace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoExtProc] CHECK  (([AutoUctoExtProc]>=(0) AND [AutoUctoExtProc]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoExtProc]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoExtProc05] CHECK  (([AutoUctoExtProc05]>=(0) AND [AutoUctoExtProc05]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoExtProc05]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoObdobi] CHECK  (([AutoUctoObdobi]>=(0) AND [AutoUctoObdobi]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoObdobi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoObdobiLeas] CHECK  (([AutoUctoObdobiLeas]>=(0) AND [AutoUctoObdobiLeas]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoObdobiLeas]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUctoObdobiMaj] CHECK  (([AutoUctoObdobiMaj]>=(0) AND [AutoUctoObdobiMaj]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUctoObdobiMaj]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_CoGener] CHECK  (([AutoUPOMPF_CoGener]=(2) OR [AutoUPOMPF_CoGener]=(1) OR [AutoUPOMPF_CoGener]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_CoGener]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_FaktOdeslat] CHECK  (([AutoUPOMPF_FaktOdeslat]>=(0) AND [AutoUPOMPF_FaktOdeslat]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_FaktOdeslat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_FARokyZpet] CHECK  (([AutoUPOMPF_FARokyZpet]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_FARokyZpet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_LimitMBEmail] CHECK  (([AutoUPOMPF_LimitMBEmail]>=(0.0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_LimitMBEmail]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PenalPoDnu] CHECK  (([AutoUPOMPF_PenalPoDnu]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PenalPoDnu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PenalVarianta] CHECK  (([AutoUPOMPF_PenalVarianta]=(1) OR [AutoUPOMPF_PenalVarianta]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PenalVarianta]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PredmetPenFak] CHECK  (([AutoUPOMPF_PredmetPenFak]>=(0) AND [AutoUPOMPF_PredmetPenFak]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PredmetPenFak]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PredmetUPO] CHECK  (([AutoUPOMPF_PredmetUPO]>=(0) AND [AutoUPOMPF_PredmetUPO]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PredmetUPO]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PrednOrg] CHECK  (([AutoUPOMPF_PrednOrg]=(3) OR [AutoUPOMPF_PrednOrg]=(2) OR [AutoUPOMPF_PrednOrg]=(1) OR [AutoUPOMPF_PrednOrg]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_PrednOrg]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomDoDnu] CHECK  (([AutoUPOMPF_UpomDoDnu]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomDoDnu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomMaxPocet] CHECK  (([AutoUPOMPF_UpomMaxPocet]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomMaxPocet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomPeriod] CHECK  (([AutoUPOMPF_UpomPeriod]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomPeriod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomPoDnu] CHECK  (([AutoUPOMPF_UpomPoDnu]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomPoDnu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomVarianta] CHECK  (([AutoUPOMPF_UpomVarianta]=(1) OR [AutoUPOMPF_UpomVarianta]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpomVarianta]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpoUlozenoDB] CHECK  (([AutoUPOMPF_UpoUlozenoDB]>=(0) AND [AutoUPOMPF_UpoUlozenoDB]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpoUlozenoDB]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpoVseobDok] CHECK  (([AutoUPOMPF_UpoVseobDok]>=(0) AND [AutoUPOMPF_UpoVseobDok]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_UpoVseobDok]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_Vyrizuje] CHECK  (([AutoUPOMPF_Vyrizuje]>=(0) AND [AutoUPOMPF_Vyrizuje]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_Vyrizuje]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutoUPOMPF_Vystavovani] CHECK  (([AutoUPOMPF_Vystavovani]=(2) OR [AutoUPOMPF_Vystavovani]=(1) OR [AutoUPOMPF_Vystavovani]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutoUPOMPF_Vystavovani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AutZahrnoutDoVseobDok] CHECK  (([AutZahrnoutDoVseobDok]>=(1) AND [AutZahrnoutDoVseobDok]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AutZahrnoutDoVseobDok]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__AVAAgentIntervalCheckovani] CHECK  (([AVAAgentIntervalCheckovani]>=(0) AND [AVAAgentIntervalCheckovani]<=((60)*(60))*(24)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__AVAAgentIntervalCheckovani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaMaxPocetRadkuTu] CHECK  (([BankaMaxPocetRadkuTu]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaMaxPocetRadkuTu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaMinOffExpSplatnoTu] CHECK  (([BankaMinOffExpSplatnoTu]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaMinOffExpSplatnoTu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaMinOffExpSplatnoZa] CHECK  (([BankaMinOffExpSplatnoZa]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaMinOffExpSplatnoZa]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyDejNaUhrazene] CHECK  (([BankaUhradyDejNaUhrazene]>=(0) AND [BankaUhradyDejNaUhrazene]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyDejNaUhrazene]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyFakturyNehradit] CHECK  (([BankaUhradyFakturyNehradit]>=(0) AND [BankaUhradyFakturyNehradit]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyFakturyNehradit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyNaOrgBS] CHECK  (([BankaUhradyNaOrgBS]=(2) OR [BankaUhradyNaOrgBS]=(1) OR [BankaUhradyNaOrgBS]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyNaOrgBS]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyNeprirazovatFakturyPoSplatnosti] CHECK  (([BankaUhradyNeprirazovatFakturyPoSplatnosti]>=(0) AND [BankaUhradyNeprirazovatFakturyPoSplatnosti]<=(50000)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyNeprirazovatFakturyPoSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyPrirazeniVydFak] CHECK  (([BankaUhradyPrirazeniVydFak]>=(0) AND [BankaUhradyPrirazeniVydFak]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyPrirazeniVydFak]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaUhradyPrirazeniVydFak1] CHECK  (([BankaUhradyPrirazeniVydFak1]>=(0) AND [BankaUhradyPrirazeniVydFak1]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaUhradyPrirazeniVydFak1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVUcelOddelovac] CHECK  (([BankaVUcelOddelovac]=(3) OR [BankaVUcelOddelovac]=(2) OR [BankaVUcelOddelovac]=(1) OR [BankaVUcelOddelovac]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVUcelOddelovac]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisCisloDokladu] CHECK  (([BankaVypisCisloDokladu]=(1) OR [BankaVypisCisloDokladu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisCisloDokladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisDatumPripadu] CHECK  (([BankaVypisDatumPripadu]=(1) OR [BankaVypisDatumPripadu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisDatumPripadu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisDatumUhrady] CHECK  (([BankaVypisDatumUhrady]=(1) OR [BankaVypisDatumUhrady]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisDatumUhrady]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisHledatCastku] CHECK  (([BankaVypisHledatCastku]=(2) OR [BankaVypisHledatCastku]=(1) OR [BankaVypisHledatCastku]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisHledatCastku]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisHledatUcetZam] CHECK  (([BankaVypisHledatUcetZam]=(2) OR [BankaVypisHledatUcetZam]=(1) OR [BankaVypisHledatUcetZam]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisHledatUcetZam]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisJakHledatKurz] CHECK  (([BankaVypisJakHledatKurz]>=(0) AND [BankaVypisJakHledatKurz]<=(9)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisJakSumace] CHECK  (([BankaVypisJakSumace]>=(0) AND [BankaVypisJakSumace]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisJakSumace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisJakTretiMenu] CHECK  (([BankaVypisJakTretiMenu]=(1) OR [BankaVypisJakTretiMenu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisJakTretiMenu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisKdeBratKurzR] CHECK  (([BankaVypisKdeBratKurzR]=(1) OR [BankaVypisKdeBratKurzR]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisKdeBratKurzR]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisNenalezenUcet] CHECK  (([BankaVypisNenalezenUcet]=(1) OR [BankaVypisNenalezenUcet]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisNenalezenUcet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisOdkudKurzProR] CHECK  (([BankaVypisOdkudKurzProR]=(1) OR [BankaVypisOdkudKurzProR]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisOdkudKurzProR]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__BankaVypisUctovani] CHECK  (([BankaVypisUctovani]=(1) OR [BankaVypisUctovani]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__BankaVypisUctovani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti] CHECK  (([CasRozliseniSplatnosti]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti2] CHECK  (([CasRozliseniSplatnosti2]>[CasRozliseniSplatnosti]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti3] CHECK  (([CasRozliseniSplatnosti3]>[CasRozliseniSplatnosti2]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti4] CHECK  (([CasRozliseniSplatnosti4]>[CasRozliseniSplatnosti3]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti5] CHECK  (([CasRozliseniSplatnosti5]>[CasRozliseniSplatnosti4]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti6] CHECK  (([CasRozliseniSplatnosti6]>[CasRozliseniSplatnosti5]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CasRozliseniSplatnosti6]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CenySlevyNakup] CHECK  (([CenySlevyNakup]<(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CenySlevyNakup]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CisloOrgMax] CHECK  (([CisloOrgMax]>=[CisloOrgMin]))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CisloOrgMax]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CisloOrgMin] CHECK  (([CisloOrgMin]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CisloOrgMin]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMGenerovatPodkladZS] CHECK  (([CRMGenerovatPodkladZS]=(1) OR [CRMGenerovatPodkladZS]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMGenerovatPodkladZS]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMHlidaniPoctuHodin] CHECK  (([CRMHlidaniPoctuHodin]>=(0) AND [CRMHlidaniPoctuHodin]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMHlidaniPoctuHodin]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMKontaktyPrenos] CHECK  (([CRMKontaktyPrenos]>=(0) AND [CRMKontaktyPrenos]<=(4)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMKontaktyPrenos]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMPovinnaKat] CHECK  (([CRMPovinnaKat]=(1) OR [CRMPovinnaKat]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMPovinnaKat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMRozsireneCenySlevy] CHECK  (([CRMRozsireneCenySlevy]=(2) OR [CRMRozsireneCenySlevy]=(1) OR [CRMRozsireneCenySlevy]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMRozsireneCenySlevy]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMVychoziMenaPodkladuZS] CHECK  (([CRMVychoziMenaPodkladuZS]=(1) OR [CRMVychoziMenaPodkladuZS]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMVychoziMenaPodkladuZS]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMVychoziPlneniFakturace] CHECK  (([CRMVychoziPlneniFakturace]=(1) OR [CRMVychoziPlneniFakturace]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMVychoziPlneniFakturace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__CRMVychoziStavPodkladu] CHECK  (([CRMVychoziStavPodkladu]=(1) OR [CRMVychoziStavPodkladu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__CRMVychoziStavPodkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DanFinancniTransakce] CHECK  (([DanFinancniTransakce]=(3) OR [DanFinancniTransakce]=(2) OR [DanFinancniTransakce]=(1) OR [DanFinancniTransakce]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DanFinancniTransakce]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DatSkontaPocitatOd] CHECK  (([DatSkontaPocitatOd]>=(0) AND [DatSkontaPocitatOd]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DatSkontaPocitatOd]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DatSplatPocitatOd] CHECK  (([DatSplatPocitatOd]>=(0) AND [DatSplatPocitatOd]<=(6)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DatSplatPocitatOd]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DatumSplatnostiPrFa] CHECK  (([DatumSplatnostiPrFa]=(1) OR [DatumSplatnostiPrFa]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DatumSplatnostiPrFa]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DeIdentifikaceUhrad] CHECK  (([DeIdentifikaceUhrad]=(1) OR [DeIdentifikaceUhrad]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DeIdentifikaceUhrad]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DelkaPoziceKV] CHECK  (([DelkaPoziceKV]>=(2) AND [DelkaPoziceKV]<=(100)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DelkaPoziceKV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DelkaRegCislaZbozi] CHECK  (([DelkaRegCislaZbozi]>=(5) AND [DelkaRegCislaZbozi]<=(30)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DelkaRegCislaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DelkaVarCastiCarovehoKodu] CHECK  (([DelkaVarCastiCarovehoKodu]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DelkaVarCastiCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DnyToleranceScontaFaV] CHECK  (([DnyToleranceScontaFaV]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DnyToleranceScontaFaV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DobaMeziPrikazy] CHECK  (([DobaMeziPrikazy]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DobaMeziPrikazy]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DohledatCenyDle] CHECK  (([DohledatCenyDle]=(2) OR [DohledatCenyDle]=(1) OR [DohledatCenyDle]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DohledatCenyDle]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DohledatScontoDle] CHECK  (([DohledatScontoDle]=(1) OR [DohledatScontoDle]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DohledatScontoDle]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DoplneniObdobiStavuOZ] CHECK  (([DoplneniObdobiStavuOZ]=(1) OR [DoplneniObdobiStavuOZ]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DoplneniObdobiStavuOZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DruhSkladu] CHECK  (([DruhSkladu]>=(2) AND [DruhSkladu]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DruhSkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DruhSkladuDSN] CHECK  (([DruhSkladuDSN]>=(2) AND [DruhSkladuDSN]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DruhSkladuDSN]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DruhSkladuSN] CHECK  (([DruhSkladuSN]>=(2) AND [DruhSkladuSN]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DruhSkladuSN]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__DruhSlev] CHECK  (([DruhSlev]=(2) OR [DruhSlev]=(1) OR [DruhSlev]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__DruhSlev]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ECertStoreLocation] CHECK  (([ECertStoreLocation]>=(1) AND [ECertStoreLocation]<=(4)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ECertStoreLocation]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ECertStoreName] CHECK  (([ECertStoreName]>=(0) AND [ECertStoreName]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ECertStoreName]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__EETPokladna] CHECK  ((ascii([EETPokladna])>=(48) AND ascii([EETPokladna])<=(57) OR ascii([EETPokladna])>=(65) AND ascii([EETPokladna])<=(90) OR ascii([EETPokladna])>=(97) AND ascii([EETPokladna])<=(122) OR ascii([EETPokladna])=(92) OR ascii([EETPokladna])=(46) OR ascii([EETPokladna])=(44) OR ascii([EETPokladna])=(58) OR ascii([EETPokladna])=(59) OR ascii([EETPokladna])=(47) OR ascii([EETPokladna])=(35) OR ascii([EETPokladna])=(45) OR ascii([EETPokladna])=(95) OR ascii([EETPokladna])=(32)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__EETPokladna]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__EETPokladniProdej] CHECK  ((ascii([EETPokladniProdej])>=(48) AND ascii([EETPokladniProdej])<=(57) OR ascii([EETPokladniProdej])>=(65) AND ascii([EETPokladniProdej])<=(90) OR ascii([EETPokladniProdej])>=(97) AND ascii([EETPokladniProdej])<=(122) OR ascii([EETPokladniProdej])=(92) OR ascii([EETPokladniProdej])=(46) OR ascii([EETPokladniProdej])=(44) OR ascii([EETPokladniProdej])=(58) OR ascii([EETPokladniProdej])=(59) OR ascii([EETPokladniProdej])=(47) OR ascii([EETPokladniProdej])=(35) OR ascii([EETPokladniProdej])=(45) OR ascii([EETPokladniProdej])=(95) OR ascii([EETPokladniProdej])=(32)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__EETPokladniProdej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__EETUhradaFaktury] CHECK  ((ascii([EETUhradaFaktury])>=(48) AND ascii([EETUhradaFaktury])<=(57) OR ascii([EETUhradaFaktury])>=(65) AND ascii([EETUhradaFaktury])<=(90) OR ascii([EETUhradaFaktury])>=(97) AND ascii([EETUhradaFaktury])<=(122) OR ascii([EETUhradaFaktury])=(92) OR ascii([EETUhradaFaktury])=(46) OR ascii([EETUhradaFaktury])=(44) OR ascii([EETUhradaFaktury])=(58) OR ascii([EETUhradaFaktury])=(59) OR ascii([EETUhradaFaktury])=(47) OR ascii([EETUhradaFaktury])=(35) OR ascii([EETUhradaFaktury])=(45) OR ascii([EETUhradaFaktury])=(95) OR ascii([EETUhradaFaktury])=(32)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__EETUhradaFaktury]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FakHraniceZaokrDPH] CHECK  (([FakHraniceZaokrDPH]=(5) OR [FakHraniceZaokrDPH]=(4) OR [FakHraniceZaokrDPH]=(3) OR [FakHraniceZaokrDPH]=(2) OR [FakHraniceZaokrDPH]=(1) OR [FakHraniceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FakHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FakOdpocetZaloh] CHECK  (([FakOdpocetZaloh]=(1) OR [FakOdpocetZaloh]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FakOdpocetZaloh]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FakPoziceZaokrDPH] CHECK  (([FakPoziceZaokrDPH]=(127) OR [FakPoziceZaokrDPH]=(2) OR [FakPoziceZaokrDPH]=(1) OR [FakPoziceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FakPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FaktZapoctyCastecKurzRozdily] CHECK  (([FaktZapoctyCastecKurzRozdily]>=(0) AND [FaktZapoctyCastecKurzRozdily]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FaktZapoctyCastecKurzRozdily]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FaktZapoctyGenerKurzRozdilyPriUhrade] CHECK  (([FaktZapoctyGenerKurzRozdilyPriUhrade]>=(0) AND [FaktZapoctyGenerKurzRozdilyPriUhrade]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FaktZapoctyGenerKurzRozdilyPriUhrade]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FakZalohyDleVal] CHECK  (([FakZalohyDleVal]=(1) OR [FakZalohyDleVal]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FakZalohyDleVal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FaSklJakHledatKurz] CHECK  (([FaSklJakHledatKurz]=(11) OR [FaSklJakHledatKurz]=(9) OR [FaSklJakHledatKurz]=(8) OR [FaSklJakHledatKurz]=(7) OR [FaSklJakHledatKurz]=(6) OR [FaSklJakHledatKurz]=(5) OR [FaSklJakHledatKurz]=(4) OR [FaSklJakHledatKurz]=(3) OR [FaSklJakHledatKurz]=(2) OR [FaSklJakHledatKurz]=(1) OR [FaSklJakHledatKurz]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FaSklJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FaSklZpusobPevneKurzy] CHECK  (([FaSklZpusobPevneKurzy]=(2) OR [FaSklZpusobPevneKurzy]=(1) OR [FaSklZpusobPevneKurzy]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FaSklZpusobPevneKurzy]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FazeEuro] CHECK  (([FazeEuro]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FazeEuro]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__FiltrNaCislo] CHECK  (([FiltrNaCislo]=(1) OR [FiltrNaCislo]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__FiltrNaCislo]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__GenDDPPRealFaPosuzovat] CHECK  (([GenDDPPRealFaPosuzovat]>=(0) AND [GenDDPPRealFaPosuzovat]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__GenDDPPRealFaPosuzovat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__GenerovaniZNerealFakt] CHECK  ((ascii([GenerovaniZNerealFakt])=(65) OR ascii([GenerovaniZNerealFakt])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__GenerovaniZNerealFakt]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__GenerovatStornoDobropisDatum] CHECK  (([GenerovatStornoDobropisDatum]>=(0) AND [GenerovatStornoDobropisDatum]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__GenerovatStornoDobropisDatum]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HistorickeCenyNakup] CHECK  ((ascii([HistorickeCenyNakup])=(65) OR ascii([HistorickeCenyNakup])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HistorickeCenyNakup]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HistorickeCenyProdej] CHECK  ((ascii([HistorickeCenyProdej])=(65) OR ascii([HistorickeCenyProdej])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HistorickeCenyProdej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HlidatPovinnosti] CHECK  (([HlidatPovinnosti]=(2) OR [HlidatPovinnosti]=(1) OR [HlidatPovinnosti]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HlidatPovinnosti]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HlidatVazbyUctuDimenze] CHECK  (([HlidatVazbyUctuDimenze]=(2) OR [HlidatVazbyUctuDimenze]=(1) OR [HlidatVazbyUctuDimenze]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HlidatVazbyUctuDimenze]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HlidatVazbyUctuUcet] CHECK  (([HlidatVazbyUctuUcet]=(1) OR [HlidatVazbyUctuUcet]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HlidatVazbyUctuUcet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__HraniceZaokrDPH] CHECK  (([HraniceZaokrDPH]=(5) OR [HraniceZaokrDPH]=(4) OR [HraniceZaokrDPH]=(3) OR [HraniceZaokrDPH]=(2) OR [HraniceZaokrDPH]=(1) OR [HraniceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__HraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ID] CHECK  (([ID]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ID]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__IntervalObnovyWF] CHECK  (([IntervalObnovyWF]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__IntervalObnovyWF]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Intr_HlidatShoduSoudku] CHECK  (([Intr_HlidatShoduSoudku]=(1) OR [Intr_HlidatShoduSoudku]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Intr_HlidatShoduSoudku]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Intr_KontrolovatCN] CHECK  (([Intr_KontrolovatCN]=(1) OR [Intr_KontrolovatCN]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Intr_KontrolovatCN]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__InventuraPohybPrijem] CHECK  (([InventuraPohybPrijem]>=(0) AND [InventuraPohybPrijem]<=(73)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__InventuraPohybPrijem]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__InventuraPohybVydej] CHECK  (([InventuraPohybVydej]>=(0) AND [InventuraPohybVydej]<=(73)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__InventuraPohybVydej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__JakZajistovatStinovePolozky] CHECK  (([JakZajistovatStinovePolozky]=(1) OR [JakZajistovatStinovePolozky]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__JakZajistovatStinovePolozky]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KartoveCentrumPoplatkyTypUhrady] CHECK  (([KartoveCentrumPoplatkyTypUhrady]=(1) OR [KartoveCentrumPoplatkyTypUhrady]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KartoveCentrumPoplatkyTypUhrady]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KartoveCentrumUctovaniDatum] CHECK  (([KartoveCentrumUctovaniDatum]=(1) OR [KartoveCentrumUctovaniDatum]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KartoveCentrumUctovaniDatum]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KartoveCentrumUctovaniDatumKurz] CHECK  (([KartoveCentrumUctovaniDatumKurz]=(1) OR [KartoveCentrumUctovaniDatumKurz]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KartoveCentrumUctovaniDatumKurz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KdeVzitCarovyKod] CHECK  (([KdeVzitCarovyKod]>=(0) AND [KdeVzitCarovyKod]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KdeVzitCarovyKod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KHAktualUzav] CHECK  (([KHAktualUzav]=(2) OR [KHAktualUzav]=(1) OR [KHAktualUzav]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KHAktualUzav]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KompletPrevod] CHECK  ((ascii([KompletPrevod])=(65) OR ascii([KompletPrevod])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KompletPrevod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KontrolaDuplicityPZ2] CHECK  (([KontrolaDuplicityPZ2]=(1) OR [KontrolaDuplicityPZ2]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KontrolaDuplicityPZ2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KontrolaDuplPZObdobi] CHECK  (([KontrolaDuplPZObdobi]=(3) OR [KontrolaDuplPZObdobi]=(2) OR [KontrolaDuplPZObdobi]=(1) OR [KontrolaDuplPZObdobi]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KontrolaDuplPZObdobi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KontrolaDuplPZUcty] CHECK  (([KontrolaDuplPZUcty]=(2) OR [KontrolaDuplPZUcty]=(1) OR [KontrolaDuplPZUcty]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KontrolaDuplPZUcty]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KontrolaSmerPlneni] CHECK  (([KontrolaSmerPlneni]=(2) OR [KontrolaSmerPlneni]=(1) OR [KontrolaSmerPlneni]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KontrolaSmerPlneni]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KontrolaStornaPrijmu] CHECK  (([KontrolaStornaPrijmu]>=(0) AND [KontrolaStornaPrijmu]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KontrolaStornaPrijmu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KonverzePZ] CHECK  (([KonverzePZ]=(1) OR [KonverzePZ]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KonverzePZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KumulaceObratu] CHECK  (([KumulaceObratu]=(2) OR [KumulaceObratu]=(1) OR [KumulaceObratu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KumulaceObratu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KurzPriGenerPolozDokladu] CHECK  (([KurzPriGenerPolozDokladu]>=(0) AND [KurzPriGenerPolozDokladu]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KurzPriGenerPolozDokladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__KVAktualUzav] CHECK  (([KVAktualUzav]=(2) OR [KVAktualUzav]=(1) OR [KVAktualUzav]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__KVAktualUzav]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Legislativa] CHECK  (([Legislativa]>=(0) AND [Legislativa]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Legislativa]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__LhutaSplatnosti] CHECK  (([LhutaSplatnosti]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__LhutaSplatnosti]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__LhutaSplatnostiDodavatel] CHECK  (([LhutaSplatnostiDodavatel]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__LhutaSplatnostiDodavatel]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__LogMonitorActionFrekvence] CHECK  (([LogMonitorActionFrekvence]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__LogMonitorActionFrekvence]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__LogSestavCasLimit] CHECK  (([LogSestavCasLimit]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__LogSestavCasLimit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MaxPocetRadkuPD] CHECK  (([MaxPocetRadkuPD]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MaxPocetRadkuPD]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MaxVnoreni] CHECK  (([MaxVnoreni]>(10)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MaxVnoreni]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MetodaEvidCeny] CHECK  (([MetodaEvidCeny]>=(0) AND [MetodaEvidCeny]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MetodaEvidCeny]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MetodaEvidCeny__OZTypGenStov] CHECK  (([OZTypGenStov]=(0) OR [MetodaEvidCeny]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MetodaEvidCeny__OZTypGenStov]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MetodaSkladu] CHECK  (([MetodaSkladu]>=(0) AND [MetodaSkladu]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MetodaSkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MnozstviNovehoVC] CHECK  (([MnozstviNovehoVC]>=(0) AND [MnozstviNovehoVC]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MnozstviNovehoVC]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ModeImportDenikDOS] CHECK  (([ModeImportDenikDOS]=(3) OR [ModeImportDenikDOS]=(2) OR [ModeImportDenikDOS]=(1) OR [ModeImportDenikDOS]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ModeImportDenikDOS]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MzAliasLen] CHECK  (([MzAliasLen]<=(15)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MzAliasLen]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MzdovaSlozUhradZmet] CHECK  (([MzdovaSlozUhradZmet]>=(0) AND [MzdovaSlozUhradZmet]<=(999)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MzdovaSlozUhradZmet]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__MzdovaSlozUkolMzd] CHECK  (([MzdovaSlozUkolMzd]>=(0) AND [MzdovaSlozUkolMzd]<=(999)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__MzdovaSlozUkolMzd]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NapocetSaldoOrg] CHECK  (([NapocetSaldoOrg]=(1) OR [NapocetSaldoOrg]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NapocetSaldoOrg]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NapocetSaldoOrgNew] CHECK  (([NapocetSaldoOrgNew]=(1) OR [NapocetSaldoOrgNew]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NapocetSaldoOrgNew]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NavazDokInfoPanelMaxLevel] CHECK  (([NavazDokInfoPanelMaxLevel]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NavazDokInfoPanelMaxLevel]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NavazDokMaxLevel] CHECK  (([NavazDokMaxLevel]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NavazDokMaxLevel]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NeaktEvMnozstviEvStav] CHECK  (([NeaktEvMnozstviEvStav]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NeaktEvMnozstviEvStav]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NenalezenoSozNa] CHECK  (([NenalezenoSozNa]=(2) OR [NenalezenoSozNa]=(1) OR [NenalezenoSozNa]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NenalezenoSozNa]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Notifikace_TypPushNotifikace] CHECK  (([Notifikace_TypPushNotifikace]>=(0) AND [Notifikace_TypPushNotifikace]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Notifikace_TypPushNotifikace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NotifikaceIntervalCheckovani] CHECK  (([NotifikaceIntervalCheckovani]>=(0) AND [NotifikaceIntervalCheckovani]<=(60)*(60)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NotifikaceIntervalCheckovani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NotifikaceProdlevaMazani] CHECK  (([NotifikaceProdlevaMazani]>=(-1) AND [NotifikaceProdlevaMazani]<=(365)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NotifikaceProdlevaMazani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NulovyVydej] CHECK  ((ascii([NulovyVydej])=(65) OR ascii([NulovyVydej])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NulovyVydej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__NulovyVydejUct] CHECK  ((ascii([NulovyVydejUct])=(65) OR ascii([NulovyVydejUct])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__NulovyVydejUct]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ObdStavuUctoSkladu] CHECK  (([ObdStavuUctoSkladu]>=(0) AND [ObdStavuUctoSkladu]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ObdStavuUctoSkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OblibenyTypPolozkovehoPrevodu] CHECK  (([OblibenyTypPolozkovehoPrevodu]=(2) OR [OblibenyTypPolozkovehoPrevodu]=(1) OR [OblibenyTypPolozkovehoPrevodu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OblibenyTypPolozkovehoPrevodu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OddelenaDatabaze] CHECK  (([OddelenaDatabaze]=(1) OR [OddelenaDatabaze]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OddelenaDatabaze]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OddelovacExportDenik] CHECK  (([OddelovacExportDenik]>=(0) AND [OddelovacExportDenik]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OddelovacExportDenik]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OrgPravniForma] CHECK  (([OrgPravniForma]>=(0) AND [OrgPravniForma]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OrgPravniForma]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZAktualizaceSlevPolozky] CHECK  (([OZAktualizaceSlevPolozky]>=(0) AND [OZAktualizaceSlevPolozky]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZAktualizaceSlevPolozky]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZCopyRozpisUmist] CHECK  (([OZCopyRozpisUmist]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZCopyRozpisUmist]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZDSNAutoReal] CHECK  (([OZDSNAutoReal]>=(0) AND [OZDSNAutoReal]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZDSNAutoReal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZDSNNavDok] CHECK  (([OZDSNNavDok]>=(0) AND [OZDSNNavDok]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZDSNNavDok]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZDSNPrevod] CHECK  (([OZDSNPrevod]>=(0) AND [OZDSNPrevod]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZDSNPrevod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZFinRealJeDrivMnoReal] CHECK  (([OZFinRealJeDrivMnoReal]>=(0) AND [OZFinRealJeDrivMnoReal]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZFinRealJeDrivMnoReal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZFinRealJeDrivNezReal] CHECK  (([OZFinRealJeDrivNezReal]>=(0) AND [OZFinRealJeDrivNezReal]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZFinRealJeDrivNezReal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZHromadnaRealizace_DruhDatumu] CHECK  (([OZHromadnaRealizace_DruhDatumu]>=(0) AND [OZHromadnaRealizace_DruhDatumu]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZHromadnaRealizace_DruhDatumu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZInvItemZpusobZadani] CHECK  (([OZInvItemZpusobZadani]>=(0) AND [OZInvItemZpusobZadani]<=(6)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZInvItemZpusobZadani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZMetodaVCRealKD] CHECK  (([OZMetodaVCRealKD]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZMetodaVCRealKD]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZMnoRealJePoteFinReal] CHECK  (([OZMnoRealJePoteFinReal]>=(0) AND [OZMnoRealJePoteFinReal]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZMnoRealJePoteFinReal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZMnoRealTestMnozstvi] CHECK  (([OZMnoRealTestMnozstvi]>=(0) AND [OZMnoRealTestMnozstvi]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZMnoRealTestMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZNahPlneni] CHECK  (([OZNahPlneni]=(2) OR [OZNahPlneni]=(1) OR [OZNahPlneni]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZNahPlneni]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZRespektovatPolSplneno] CHECK  (([OZRespektovatPolSplneno]=(3) OR [OZRespektovatPolSplneno]=(2) OR [OZRespektovatPolSplneno]=(1) OR [OZRespektovatPolSplneno]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZRespektovatPolSplneno]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZRezimKurzuDPHFaktur] CHECK  (([OZRezimKurzuDPHFaktur]=(1) OR [OZRezimKurzuDPHFaktur]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZRezimKurzuDPHFaktur]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSlepaProcCena] CHECK  (([OZSlepaProcCena]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSlepaProcCena]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNHlidatZadani] CHECK  (([OZSNHlidatZadani]=(1) OR [OZSNHlidatZadani]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNHlidatZadani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNPrevod] CHECK  (([OZSNPrevod]>=(0) AND [OZSNPrevod]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNPrevod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber1] CHECK  (([OZSNSkladVyber1]=(1) OR [OZSNSkladVyber1]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber2] CHECK  (([OZSNSkladVyber2]=(1) OR [OZSNSkladVyber2]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber3] CHECK  (([OZSNSkladVyber3]=(1) OR [OZSNSkladVyber3]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber4] CHECK  (([OZSNSkladVyber4]=(1) OR [OZSNSkladVyber4]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber5] CHECK  (([OZSNSkladVyber5]=(1) OR [OZSNSkladVyber5]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber6] CHECK  (([OZSNSkladVyber6]=(1) OR [OZSNSkladVyber6]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber6]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNSkladVyber7] CHECK  (([OZSNSkladVyber7]=(1) OR [OZSNSkladVyber7]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNSkladVyber7]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni1] CHECK  (([OZSNTypRozpousteni1]=(2) OR [OZSNTypRozpousteni1]=(1) OR [OZSNTypRozpousteni1]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni1]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni2] CHECK  (([OZSNTypRozpousteni2]=(2) OR [OZSNTypRozpousteni2]=(1) OR [OZSNTypRozpousteni2]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni2]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni3] CHECK  (([OZSNTypRozpousteni3]=(2) OR [OZSNTypRozpousteni3]=(1) OR [OZSNTypRozpousteni3]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni3]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni4] CHECK  (([OZSNTypRozpousteni4]=(2) OR [OZSNTypRozpousteni4]=(1) OR [OZSNTypRozpousteni4]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni4]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni5] CHECK  (([OZSNTypRozpousteni5]=(2) OR [OZSNTypRozpousteni5]=(1) OR [OZSNTypRozpousteni5]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni5]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni6] CHECK  (([OZSNTypRozpousteni6]=(2) OR [OZSNTypRozpousteni6]=(1) OR [OZSNTypRozpousteni6]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni6]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni7] CHECK  (([OZSNTypRozpousteni7]=(2) OR [OZSNTypRozpousteni7]=(1) OR [OZSNTypRozpousteni7]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZSNTypRozpousteni7]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZStoPBezEdiSN] CHECK  (([OZStoPBezEdiSN]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZStoPBezEdiSN]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZTypGenStov] CHECK  (([OZTypGenStov]>=(0) AND [OZTypGenStov]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZTypGenStov]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZUmistJenPV] CHECK  (([OZUmistJenPV]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZUmistJenPV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZUmistMetodaVydej] CHECK  (([OZUmistMetodaVydej]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZUmistMetodaVydej]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVCTestMnoz] CHECK  (([OZVCTestMnoz]=(1) OR [OZVCTestMnoz]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVCTestMnoz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVykazLihu] CHECK  (([OZVykazLihu]>=(0) AND [OZVykazLihu]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVykazLihu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVykazLihuOrgBezICO] CHECK  (([OZVykazLihuOrgBezICO]>=(0) AND [OZVykazLihuOrgBezICO]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVykazLihuOrgBezICO]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVykazLihuPodleData] CHECK  (([OZVykazLihuPodleData]>=(0) AND [OZVykazLihuPodleData]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVykazLihuPodleData]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVypocetSumaKcPoZao] CHECK  (([OZVypocetSumaKcPoZao]>=(0) AND [OZVypocetSumaKcPoZao]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZVyrCPInfoPanelDokumentyZdroj] CHECK  (([OZVyrCPInfoPanelDokumentyZdroj]=(2) OR [OZVyrCPInfoPanelDokumentyZdroj]=(1) OR [OZVyrCPInfoPanelDokumentyZdroj]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZVyrCPInfoPanelDokumentyZdroj]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZZapoctiFaPDoOdebMnoz] CHECK  (([OZZapoctiFaPDoOdebMnoz]>=(0) AND [OZZapoctiFaPDoOdebMnoz]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZZapoctiFaPDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZZapoctiFaVDoOdebMnoz] CHECK  (([OZZapoctiFaVDoOdebMnoz]>=(0) AND [OZZapoctiFaVDoOdebMnoz]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZZapoctiFaVDoOdebMnoz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZZpusobRealizace] CHECK  (([OZZpusobRealizace]>=(0) AND [OZZpusobRealizace]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZZpusobRealizace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__OZZpusobZapStoren] CHECK  (([OZZpusobZapStoren]=(1) OR [OZZpusobZapStoren]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__OZZpusobZapStoren]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PlatceDPH] CHECK  (([PlatceDPH]=(1) OR [PlatceDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PlatceDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PlatnostNabCen] CHECK  (([PlatnostNabCen]>=(0) AND [PlatnostNabCen]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PlatnostNabCen]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PokHraniceZaokrDPH] CHECK  (([PokHraniceZaokrDPH]=(5) OR [PokHraniceZaokrDPH]=(4) OR [PokHraniceZaokrDPH]=(3) OR [PokHraniceZaokrDPH]=(2) OR [PokHraniceZaokrDPH]=(1) OR [PokHraniceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PokHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PokladnaJakHledatKurz] CHECK  (([PokladnaJakHledatKurz]>=(0) AND [PokladnaJakHledatKurz]<=(11)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PokladnaJakHledatKurz]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PokladnaZpusobPevneKurzy] CHECK  (([PokladnaZpusobPevneKurzy]=(2) OR [PokladnaZpusobPevneKurzy]=(1) OR [PokladnaZpusobPevneKurzy]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PokladnaZpusobPevneKurzy]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklLimitPlatebHotovKontrola] CHECK  (([PoklLimitPlatebHotovKontrola]=(1) OR [PoklLimitPlatebHotovKontrola]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklLimitPlatebHotovKontrola]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdBKPlatbaLimit] CHECK  (([PoklProdBKPlatbaLimit]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdBKPlatbaLimit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdBKPlatbaMaxProc] CHECK  (([PoklProdBKPlatbaMaxProc]>=(0) AND [PoklProdBKPlatbaMaxProc]<=(100)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdBKPlatbaMaxProc]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdBKPrvniBody] CHECK  (([PoklProdBKPrvniBody]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdBKPrvniBody]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdBKTypProEI] CHECK  (([PoklProdBKTypProEI]>=(0) AND [PoklProdBKTypProEI]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdBKTypProEI]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdCKDelkaVarCasti] CHECK  (([PoklProdCKDelkaVarCasti]>(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdCKDelkaVarCasti]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdCKKdeVzit] CHECK  (([PoklProdCKKdeVzit]>=(0) AND [PoklProdCKKdeVzit]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdCKKdeVzit]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdCKPozice1Znaku] CHECK  (([PoklProdCKPozice1Znaku]>=(0) AND [PoklProdCKPozice1Znaku]<=(25)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdCKPozice1Znaku]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdCKTyp] CHECK  (([PoklProdCKTyp]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdCKTyp]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdDelkaRegCisBal] CHECK  (([PoklProdDelkaRegCisBal]>=(5) AND [PoklProdDelkaRegCisBal]<=(30)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdDelkaRegCisBal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdKurzOdvod] CHECK  (([PoklProdKurzOdvod]>=(0) AND [PoklProdKurzOdvod]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdKurzOdvod]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdOrgPoradiPoli] CHECK  (([PoklProdOrgPoradiPoli]=(2) OR [PoklProdOrgPoradiPoli]=(1) OR [PoklProdOrgPoradiPoli]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdOrgPoradiPoli]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdTestMnozstvi] CHECK  (([PoklProdTestMnozstvi]>=(0) AND [PoklProdTestMnozstvi]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdTestMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdTestMnozTyp] CHECK  (([PoklProdTestMnozTyp]>=(0) AND [PoklProdTestMnozTyp]<=(7)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdTestMnozTyp]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdVychoziMnozstvi] CHECK  (([PoklProdVychoziMnozstvi]>=(0) AND [PoklProdVychoziMnozstvi]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdVychoziMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdVychoziUhrada] CHECK  (([PoklProdVychoziUhrada]>=(0) AND [PoklProdVychoziUhrada]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdVychoziUhrada]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdVychoziZUStorno] CHECK  (([PoklProdVychoziZUStorno]>=(0) AND [PoklProdVychoziZUStorno]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdVychoziZUStorno]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdVychoziZUVratka] CHECK  (([PoklProdVychoziZUVratka]>=(1) AND [PoklProdVychoziZUVratka]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdVychoziZUVratka]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdVypocetSumaKcPoZao] CHECK  (([PoklProdVypocetSumaKcPoZao]>=(0) AND [PoklProdVypocetSumaKcPoZao]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdVypocetSumaKcPoZao]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdZaokrouhlitNa50] CHECK  (([PoklProdZaokrouhlitNa50]>=(0) AND [PoklProdZaokrouhlitNa50]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdZaokrouhlitNa50]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdZarovRegCisBal] CHECK  (([PoklProdZarovRegCisBal]>=(0) AND [PoklProdZarovRegCisBal]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdZarovRegCisBal]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoklProdZpusobZadani] CHECK  (([PoklProdZpusobZadani]>=(0) AND [PoklProdZpusobZadani]<=(6)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoklProdZpusobZadani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PokPoziceZaokrDPH] CHECK  (([PokPoziceZaokrDPH]=(127) OR [PokPoziceZaokrDPH]=(2) OR [PokPoziceZaokrDPH]=(1) OR [PokPoziceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PokPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PolPrevodPrenosCislaSkladu] CHECK  ((ascii([PolPrevodPrenosCislaSkladu])=(65) OR ascii([PolPrevodPrenosCislaSkladu])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PolPrevodPrenosCislaSkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PouzitPrednastaCUNakup] CHECK  (([PouzitPrednastaCUNakup]=(3) OR [PouzitPrednastaCUNakup]=(2) OR [PouzitPrednastaCUNakup]=(1) OR [PouzitPrednastaCUNakup]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PouzitPrednastaCUNakup]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PouzitPrednastavenouCU] CHECK  (([PouzitPrednastavenouCU]=(3) OR [PouzitPrednastavenouCU]=(2) OR [PouzitPrednastavenouCU]=(1) OR [PouzitPrednastavenouCU]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PouzitPrednastavenouCU]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PouzivatEET] CHECK  (([PouzivatEET]=(3) OR [PouzivatEET]=(2) OR [PouzivatEET]=(1) OR [PouzivatEET]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PouzivatEET]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PouzivatPomerKoef] CHECK  (([PouzivatPomerKoef]=(2) OR [PouzivatPomerKoef]=(1) OR [PouzivatPomerKoef]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PouzivatPomerKoef]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PouzivatPomerKoefPuvodni] CHECK  (([PouzivatPomerKoefPuvodni]=(1) OR [PouzivatPomerKoefPuvodni]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PouzivatPomerKoefPuvodni]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PozicePrvnihoZnakuCarovehoKodu] CHECK  (([PozicePrvnihoZnakuCarovehoKodu]>=(0) AND [PozicePrvnihoZnakuCarovehoKodu]<=(25)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PozicePrvnihoZnakuCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoziceZaokrDPH] CHECK  (([PoziceZaokrDPH]=(127) OR [PoziceZaokrDPH]=(126) OR [PoziceZaokrDPH]=(3) OR [PoziceZaokrDPH]=(2) OR [PoziceZaokrDPH]=(1) OR [PoziceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PoziceZaokrPriPrepoctuCasuTechPos] CHECK  (([PoziceZaokrPriPrepoctuCasuTechPos]=(6) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(5) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(4) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(3) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(2) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(1) OR [PoziceZaokrPriPrepoctuCasuTechPos]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PoziceZaokrPriPrepoctuCasuTechPos]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PrepoctiMnozstviVC] CHECK  (([PrepoctiMnozstviVC]>=(0) AND [PrepoctiMnozstviVC]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PrepoctiMnozstviVC]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__PrevodSluzebNaVYDzEXP] CHECK  ((ascii([PrevodSluzebNaVYDzEXP])=(65) OR ascii([PrevodSluzebNaVYDzEXP])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__PrevodSluzebNaVYDzEXP]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Proc_ztrat] CHECK  (([Proc_ztrat]>=(0) AND [Proc_ztrat]<=(100)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Proc_ztrat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__Prub_doba] CHECK  (([Prub_doba]>=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__Prub_doba]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__QR_MSGFaktura] CHECK  (([QR_MSGFaktura]>=(0) AND [QR_MSGFaktura]<=(4)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__QR_MSGFaktura]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__QR_MSGPlatba] CHECK  (([QR_MSGPlatba]>=(0) AND [QR_MSGPlatba]<=(4)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__QR_MSGPlatba]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__RespektovatNastaveniKontrolVC] CHECK  (([RespektovatNastaveniKontrolVC]>=(0) AND [RespektovatNastaveniKontrolVC]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__RespektovatNastaveniKontrolVC]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__RezimPenalizace] CHECK  (([RezimPenalizace]=(2) OR [RezimPenalizace]=(1) OR [RezimPenalizace]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__RezimPenalizace]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__RozhodneMnozstviNaVYDzEXP] CHECK  (([RozhodneMnozstviNaVYDzEXP]>=(0) AND [RozhodneMnozstviNaVYDzEXP]<=(8)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__RozhodneMnozstviNaVYDzEXP]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__RuznySkladNaPolAHla] CHECK  (([RuznySkladNaPolAHla]>=(0) AND [RuznySkladNaPolAHla]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__RuznySkladNaPolAHla]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ShodaZakazek] CHECK  ((ascii([ShodaZakazek])=(65) OR ascii([ShodaZakazek])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ShodaZakazek]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaKmenZbo] CHECK  (([SlevaKmenZbo]=(1) OR [SlevaKmenZbo]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaKmenZbo]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaOrg] CHECK  (([SlevaOrg]=(1) OR [SlevaOrg]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaOrg]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaSkupZbo] CHECK  (([SlevaSkupZbo]=(1) OR [SlevaSkupZbo]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaSkupZbo]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaSoucetAnoNe] CHECK  (([SlevaSoucetAnoNe]>=(0) AND [SlevaSoucetAnoNe]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaSoucetAnoNe]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaSozNa] CHECK  (([SlevaSozNa]=(1) OR [SlevaSozNa]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaSozNa]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaStavSkladu] CHECK  (([SlevaStavSkladu]=(1) OR [SlevaStavSkladu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaStavSkladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__SlevaZbozi] CHECK  (([SlevaZbozi]=(1) OR [SlevaZbozi]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__SlevaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__StinRezim] CHECK  (([StinRezim]>=(0) AND [StinRezim]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__StinRezim]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__TrideniPolozekVTiskuDokladu] CHECK  (([TrideniPolozekVTiskuDokladu]>=(0) AND [TrideniPolozekVTiskuDokladu]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__TrideniPolozekVTiskuDokladu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__TypCarovehoKodu] CHECK  (([TypCarovehoKodu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__TypCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__TypPlanovaciDoby] CHECK  (([TypPlanovaciDoby]>=(0) AND [TypPlanovaciDoby]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__TypPlanovaciDoby]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__TypPrevoduVydejkyPrevodky] CHECK  (([TypPrevoduVydejkyPrevodky]=(1) OR [TypPrevoduVydejkyPrevodky]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__TypPrevoduVydejkyPrevodky]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctHraniceZaokrDPH] CHECK  (([UctHraniceZaokrDPH]=(5) OR [UctHraniceZaokrDPH]=(4) OR [UctHraniceZaokrDPH]=(3) OR [UctHraniceZaokrDPH]=(2) OR [UctHraniceZaokrDPH]=(1) OR [UctHraniceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctHraniceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProDPH] CHECK  (([UctoJakHledatKurzProDPH]>=(0) AND [UctoJakHledatKurzProDPH]<=(9)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProNZ] CHECK  (([UctoJakHledatKurzProNZ]>=(0) AND [UctoJakHledatKurzProNZ]<=(9)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProNZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProZap] CHECK  (([UctoJakHledatKurzProZap]>=(0) AND [UctoJakHledatKurzProZap]<=(9)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctoJakHledatKurzProZap]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctovaniZapoctu] CHECK  (([UctovaniZapoctu]=(1) OR [UctovaniZapoctu]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctovaniZapoctu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__UctPoziceZaokrDPH] CHECK  (([UctPoziceZaokrDPH]=(127) OR [UctPoziceZaokrDPH]=(2) OR [UctPoziceZaokrDPH]=(1) OR [UctPoziceZaokrDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__UctPoziceZaokrDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__VerzeDanovehoPriznani] CHECK  (([VerzeDanovehoPriznani]=(1) OR [VerzeDanovehoPriznani]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__VerzeDanovehoPriznani]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__VerzeEXE] CHECK  ((len([VerzeEXE])=(12)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__VerzeEXE]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__VerzeProgramu] CHECK  ((len([VerzeProgramu])=(12)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__VerzeProgramu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__VlastnostSlev] CHECK  (([VlastnostSlev]=(1) OR [VlastnostSlev]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__VlastnostSlev]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__VychoziStavBlokaceVyroby] CHECK  (([VychoziStavBlokaceVyroby]>=(0) AND [VychoziStavBlokaceVyroby]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__VychoziStavBlokaceVyroby]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZadaniPolozekDokladOZ] CHECK  (([ZadaniPolozekDokladOZ]>=(0) AND [ZadaniPolozekDokladOZ]<=(5)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZadaniPolozekDokladOZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZadaniPolozekSkladOZ] CHECK  (([ZadaniPolozekSkladOZ]>=(0) AND [ZadaniPolozekSkladOZ]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZadaniPolozekSkladOZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty] CHECK  (([ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]=(2) OR [ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]=(1) OR [ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZajisteniDPHSKZpusobOznacProKontroluZverejBankUcty]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZajisteniDPHZpusobOznacProKontroluNespolehPlatce] CHECK  (([ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]=(2) OR [ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]=(1) OR [ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZajisteniDPHZpusobOznacProKontroluNespolehPlatce]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZajisteniDPHZpusobOznacProKontroluZverejBankUcty] CHECK  (([ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]=(2) OR [ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]=(1) OR [ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZajisteniDPHZpusobOznacProKontroluZverejBankUcty]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZaokrDPHMalaCisla] CHECK  (([ZaokrDPHMalaCisla]>=(0) AND [ZaokrDPHMalaCisla]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZaokrDPHMalaCisla]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZaokrDPHvaluty] CHECK  (([ZaokrDPHvaluty]>=(0) AND [ZaokrDPHvaluty]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZaokrDPHvaluty]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZaokrouhleniUhradyPokl] CHECK  (([ZaokrouhleniUhradyPokl]=(2) OR [ZaokrouhleniUhradyPokl]=(1) OR [ZaokrouhleniUhradyPokl]=(0) OR [ZaokrouhleniUhradyPokl]=(-1) OR [ZaokrouhleniUhradyPokl]=(-2) OR [ZaokrouhleniUhradyPokl]=(-3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZaokrouhleniUhradyPokl]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZaokrPoklDokNa50] CHECK  ((ascii([ZaokrPoklDokNa50])=(65) OR ascii([ZaokrPoklDokNa50])=(78)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZaokrPoklDokNa50]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZaplaceneFakturyZohlednovatK] CHECK  (([ZaplaceneFakturyZohlednovatK]>=(0) AND [ZaplaceneFakturyZohlednovatK]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZaplaceneFakturyZohlednovatK]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZapoctyNeFaPoSpla] CHECK  (([ZapoctyNeFaPoSpla]>(-1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZapoctyNeFaPoSpla]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZapoctyObdStavuFA] CHECK  (([ZapoctyObdStavuFA]=(1) OR [ZapoctyObdStavuFA]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZapoctyObdStavuFA]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZapoctyObdStavuSAL] CHECK  (([ZapoctyObdStavuSAL]=(1) OR [ZapoctyObdStavuSAL]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZapoctyObdStavuSAL]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZapoctyPosuzovat] CHECK  (([ZapoctyPosuzovat]=(1) OR [ZapoctyPosuzovat]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZapoctyPosuzovat]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZapoctyRuzneMeny] CHECK  (([ZapoctyRuzneMeny]=(1) OR [ZapoctyRuzneMeny]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZapoctyRuzneMeny]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZarovnaniOperaceTechPos] CHECK  (([ZarovnaniOperaceTechPos]>=(0) AND [ZarovnaniOperaceTechPos]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZarovnaniOperaceTechPos]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZarovnaniPoziceKV] CHECK  (([ZarovnaniPoziceKV]>=(0) AND [ZarovnaniPoziceKV]<=(2)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZarovnaniPoziceKV]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZarovnaniRegCislaZbozi] CHECK  (([ZarovnaniRegCislaZbozi]>=(0) AND [ZarovnaniRegCislaZbozi]<=(3)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZarovnaniRegCislaZbozi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZobrPoctuDMMnozstvi] CHECK  (([ZobrPoctuDMMnozstvi] IS NULL OR [ZobrPoctuDMMnozstvi]>=(0) AND [ZobrPoctuDMMnozstvi]<=(6)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZobrPoctuDMMnozstvi]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZobrPoctuDMNabCen] CHECK  (([ZobrPoctuDMNabCen]>=(0) AND [ZobrPoctuDMNabCen]<=(6)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZobrPoctuDMNabCen]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobGenerovaniCarovehoKodu] CHECK  (([ZpusobGenerovaniCarovehoKodu]>=(0) AND [ZpusobGenerovaniCarovehoKodu]<=(1)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobGenerovaniCarovehoKodu]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyBanka] CHECK  (([ZpusobPevneKurzyBanka]=(2) OR [ZpusobPevneKurzyBanka]=(1) OR [ZpusobPevneKurzyBanka]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyBanka]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyDPH] CHECK  (([ZpusobPevneKurzyDPH]=(2) OR [ZpusobPevneKurzyDPH]=(1) OR [ZpusobPevneKurzyDPH]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyDPH]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyNZ] CHECK  (([ZpusobPevneKurzyNZ]=(2) OR [ZpusobPevneKurzyNZ]=(1) OR [ZpusobPevneKurzyNZ]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyNZ]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyZap] CHECK  (([ZpusobPevneKurzyZap]=(2) OR [ZpusobPevneKurzyZap]=(1) OR [ZpusobPevneKurzyZap]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobPevneKurzyZap]
GO
ALTER TABLE [dbo].[TabHGlob]  WITH CHECK ADD  CONSTRAINT [CK__TabHGlob__ZpusobZruseniKRBilDen] CHECK  (([ZpusobZruseniKRBilDen]=(1) OR [ZpusobZruseniKRBilDen]=(0)))
GO
ALTER TABLE [dbo].[TabHGlob] CHECK CONSTRAINT [CK__TabHGlob__ZpusobZruseniKRBilDen]
GO
ALTER TABLE [dbo].[TabHGlob] ENABLE TRIGGER [hp_VynutKontroluStrukturyDB]
GO
