# Uživatelské sloupce

Výpis všech uživatelských sloupců v zahrnutých EXT tabulkách ze schématu z 18. 10. 2026.
Výpis je referenční, obsahuje i sloupce jiných funkcí Heliosu. Úplné definice tabulek, včetně exportovaných omezení, jsou v `../reference/tables/`.

## dbo.TabCisZam_EXT

```sql
[_intranet_exp] [bit] NULL
[_intranet_sklad] [bit] NULL
[_intranet_vychozi] [int] NULL
[_intranet_vyroba] [bit] NULL
[_intranet_odvadeni] [bit] NULL
```

## dbo.TabDokladyZbozi_EXT

```sql
[_cisteni] [datetime] NULL
[_vlek] [bit] NULL
[_plomby] [nvarchar](200) NULL
[_paletyDodane] [numeric](19, 6) NULL
[_paletyVracene] [numeric](19, 6) NULL
[_faktoring_soubor] [nvarchar](20) NULL
[_faktoring_vyber] [bit] NULL
[_ext_labo] [int] NULL
[_tisk_sscc] [bit] NULL
[_mdlz_export_datum] [datetime] NULL
[_tn_opravna_faktura] [bit] NULL
[_exp_ma_rozbor] [bit] NULL
[_vyr_do_cislosmeny] [int] NULL
[_exp_schenker_blokovano] [bit] NULL
[_exp_schenker_datzprac] [datetime] NULL
[_exp_schenker_odeslani] [datetime] NULL
[_exp_dat_ktisku] [datetime] NULL
[_exp_dat_tisku] [datetime] NULL
[_exp_dat_uzavreno] [datetime] NULL
[_skl_token] [nvarchar](255) NULL
[_skl_druh_pohybu_inet] [nvarchar](30) NULL
[_exp_schenker_datporizeni_puv] [datetime] NULL
[_exp_nefakturovat] [bit] NULL
[_exp_edi_datprij] [datetime] NULL
[_edi_doctype] [nvarchar](10) NULL
[_puvdatporizeni] [datetime] NULL
[_pozn_wrk] [ntext] NULL
[_DatumMailu] [datetime] NULL
[_DatumPredani] [datetime] NULL
[_eshop_placeno] [bit] NULL
[_eshop_cust_mail] [nvarchar](100) NULL
[_eshop_cust_tel] [nvarchar](50) NULL
[_eshop_cust_jmeno] [nvarchar](100) NULL
[_eshop_cust_firma] [nvarchar](100) NULL
[_eshop_cust_ulice] [nvarchar](100) NULL
[_eshop_cust_misto] [nvarchar](100) NULL
[_eshop_cust_psc] [nvarchar](10) NULL
[_eshop_cust_zeme] [nvarchar](100) NULL
[_eshop_cust_ic] [nvarchar](20) NULL
[_eshop_cust_dic] [nvarchar](20) NULL
[_eshop_ship_jmeno] [nvarchar](100) NULL
[_eshop_ship_firma] [nvarchar](100) NULL
[_eshop_ship_ulice] [nvarchar](100) NULL
[_eshop_ship_misto] [nvarchar](100) NULL
[_eshop_ship_psc] [nvarchar](20) NULL
[_eshop_ship_zeme] [nvarchar](100) NULL
[_eshop_status] [nvarchar](100) NULL
[_tn_suffix] [nvarchar](5) NULL
[_exp_je_cenik] [bit] NULL
[_eshop_ep_zpracuj] [bit] NULL
[_faktoring_datum] [datetime] NULL
[_DatumSamoFa] [datetime] NULL
[_ISDOCGUID] [varchar](36) NULL
[_ISDOC_Extensions] [ntext] NULL
[_HcvFaktFinancovatKB] [smallint] NULL
[_exp_schenker_generovani] [datetime] NULL
[_mdlz_storeloc] [nvarchar](30) NULL
[_LidlEPDavka] [int] NULL
```

## dbo.TabKmenZbozi_EXT

```sql
[_ncena] [numeric](19, 6) NULL
[_rlvyber] [bit] NULL
[_ext_kodPDP] [int] NULL
[_fa_ean_tesco] [nvarchar](20) NULL
[_fa_tpn_tesco] [nvarchar](20) NULL
[_vlvyber] [bit] NULL
[_poznamka_en] [ntext] NULL
[_kod_da] [nvarchar](5) NULL
[_expok] [int] NULL
[_ext_NuloveMnozstviPDP] [bit] NULL
[_hmotnost_paleta] [numeric](19, 6) NULL
[_irvyber] [bit] NULL
[_ir_a_energie_min] [numeric](19, 6) NULL
[_ir_a_energie_max] [numeric](19, 6) NULL
[_ir_vlhkost_min] [numeric](19, 6) NULL
[_ir_vlhkost_max] [numeric](19, 6) NULL
[_ir_popel_min] [numeric](19, 6) NULL
[_ir_popel_max] [numeric](19, 6) NULL
[_ir_lepek_min] [numeric](19, 6) NULL
[_ir_lepek_max] [numeric](19, 6) NULL
[_ir_n_latky_min] [numeric](19, 6) NULL
[_ir_n_latky_max] [numeric](19, 6) NULL
[_ir_zeleny_test_min] [numeric](19, 6) NULL
[_ir_zeleny_test_max] [numeric](19, 6) NULL
[_ir_padc_min] [numeric](19, 6) NULL
[_ir_padc_max] [numeric](19, 6) NULL
[_ir_f_vaznost_min] [numeric](19, 6) NULL
[_ir_f_vaznost_max] [numeric](19, 6) NULL
[_ir_a_pl_min] [numeric](19, 6) NULL
[_ir_a_pl_max] [numeric](19, 6) NULL
[_ir_poskozeny_skrob_max] [numeric](19, 6) NULL
[_ir_poskozeny_skrob_min] [numeric](19, 6) NULL
[_ir_e_taznost_min] [numeric](19, 6) NULL
[_ir_e_taznost_max] [numeric](19, 6) NULL
[_ir_e_maximum_min] [numeric](19, 6) NULL
[_ir_e_maximum_max] [numeric](19, 6) NULL
[_ir_e_energie_min] [numeric](19, 6) NULL
[_ir_e_energie_max] [numeric](19, 6) NULL
[_vl_typ_zadavani] [int] NULL
[_vyr_mnoz_v_obalu] [numeric](19, 6) NULL
[_vyr_kmen_material] [int] NULL
[_vyr_material_jazyk] [nvarchar](20) NULL
[_PocetSpotrMjVeFaktMJ] [float] NULL
[_vyr_nazev_pl] [nvarchar](500) NULL
[_ro_bio] [bit] NULL
[_ro_surovina] [int] NULL
[_ro_clzr] [bit] NULL
[_ro_ost_ml3] [bit] NULL
[_expok_aut_dopln_sklad] [bit] NULL
[_ro_druh] [int] NULL
[_exp_karton_polozka] [int] NULL
[_vyr_linka] [int] NULL
[_bezlepku] [bit] NULL
[_ro_druh_baleni] [int] NULL
[_expok_zalozka] [int] NULL
[_expok_zalozka_poradi] [int] NULL
[_vyr_kmen_typ_palety] [int] NULL
```

## dbo.TabPohybyZbozi_EXT

```sql
[_exp_id_rozbor] [int] NULL
[_exp_mnozstvi_pozad_puvodni] [numeric](19, 6) NULL
[_exp_mnozstvi_vc] [numeric](19, 6) NULL
[_exp_edi_mnozprij] [numeric](19, 6) NULL
[_exp_cenik_chyba_ceny] [bit] NULL
[_ISDOC_Extensions] [ntext] NULL
[_exp_mnoz_import] [numeric](19, 6) NULL
```

## dbo.TabPrikaz_EXT

```sql
[_vyr_pr_cislosmeny] [int] NULL
[_vyr_pr_datexpirace] [datetime] NULL
[_vyr_pr_idstroje] [int] NULL
[_vyr_pr_odberatel_mu] [int] NULL
[_vyr_pr_sarze] [nvarchar](50) NULL
[_vyr_pr_zeme_urceni] [nvarchar](3) NULL
[_vyr_pr_obal_id] [int] NULL
[_vyr_pr_hmotnost_na_palete] [numeric](19, 6) NULL
[_vyr_pr_typ_palety] [int] NULL
[_vyr_pr_mnozstvi_na_pal] [numeric](19, 6) NULL
[_vyr_pr_karton] [int] NULL
[_vyr_pr_dat_vyroby] [datetime] NULL
[_vyr_pr_objednavka] [nvarchar](50) NULL
```

## dbo.TabVyrCK_EXT

```sql
[_vlhkost_km] [numeric](19, 6) NULL
[_grana_km] [numeric](19, 6) NULL
[_granb_km] [numeric](19, 6) NULL
[_popel_km] [numeric](19, 6) NULL
[_vlak_km] [numeric](19, 6) NULL
[_bobt_km] [numeric](19, 6) NULL
[_ocko_km] [numeric](19, 6) NULL
[_lepek_km] [numeric](19, 6) NULL
[_padc_km] [numeric](19, 6) NULL
[_sarze_km] [nvarchar](20) NULL
[_datPytlovani_km] [datetime] NULL
[_rlfirma_km] [int] NULL
[_rlarchiv_km] [bit] NULL
[_vl_btto_km] [numeric](19, 6) NULL
[_vl_tara_km] [numeric](19, 6) NULL
[_vl_firma_km] [int] NULL
[_vl_datum_km] [datetime] NULL
[_vl_pozn_km] [nvarchar](100) NULL
[_vl_pocet_dod_km] [int] NULL
[_vl_vlhkost_km] [numeric](19, 6) NULL
[_vl_necistoty_km] [numeric](19, 6) NULL
[_vl_primes_km] [numeric](19, 6) NULL
[_vl_lepek_km] [numeric](19, 6) NULL
[_vl_objhm_km] [numeric](19, 6) NULL
[_vl_padc_km] [numeric](19, 6) NULL
[_vl_n_latky_km] [numeric](19, 6) NULL
[_vl_spz_km] [nvarchar](20) NULL
[_gran250_km] [numeric](19, 6) NULL
[_gran160_km] [numeric](19, 6) NULL
[_gran106_km] [numeric](19, 6) NULL
[_vyhovuje_km] [bit] NULL
[_vl_cislovl_km] [int] NULL
[_vl_tvrdost_km] [numeric](19, 6) NULL
[_vl_sedi_km] [numeric](19, 6) NULL
[_vl_senzor_km] [bit] NULL
[_vl_ok_spec_km] [bit] NULL
[_vl_ok_term_km] [bit] NULL
[_vl_odruda_km] [nvarchar](20) NULL
[_vl_ridic_km] [nvarchar](50) NULL
[_vl_id_dod_km] [int] NULL
[_vl_dodavatel_km] [varchar](100) NULL
[_vl_dodavatel_novy_km] [nvarchar](100) NULL
[_ir_vlhkost_km] [numeric](19, 6) NULL
[_ir_popel_km] [numeric](19, 6) NULL
[_ir_lepek_km] [numeric](19, 6) NULL
[_ir_mouka_km] [nvarchar](50) NULL
[_ir_n_latky_km] [numeric](19, 6) NULL
[_ir_zeleny_test_km] [numeric](19, 6) NULL
[_ir_padc_km] [numeric](19, 6) NULL
[_ir_f_vaznost_km] [numeric](19, 6) NULL
[_ir_f_vyvin_km] [numeric](19, 6) NULL
[_ir_f_stabilita_km] [numeric](19, 6) NULL
[_ir_f_pokles_km] [numeric](19, 6) NULL
[_ir_e_taznost_km] [numeric](19, 6) NULL
[_ir_e_maximum_km] [numeric](19, 6) NULL
[_ir_e_energie_km] [numeric](19, 6) NULL
[_ir_a_energie_km] [numeric](19, 6) NULL
[_ir_a_pl_km] [numeric](19, 6) NULL
[_ir_poskozeny_skrob_km] [numeric](19, 6) NULL
[_ir_src_mlecna_km] [numeric](19, 6) NULL
[_ir_src_sacharoza_km] [numeric](19, 6) NULL
[_ir_src_uhlicitan_km] [numeric](19, 6) NULL
[_ir_src_voda_km] [numeric](19, 6) NULL
[_ir_kodlab_km] [nvarchar](30) NULL
[_vl_kod_umisteni_km] [nvarchar](15) NULL
[_vl_kod_umisteni_log_km] [ntext] NULL
[_vl_nasklad_km] [bit] NULL
[_vl_zeskladu_km] [bit] NULL
[_vl_jinymlyn_km] [bit] NULL
```

## dbo.TabVyrCP_EXT

```sql
[_exp_schenker_mnoz] [numeric](19, 6) NULL
[_exp_schenker_datcas] [datetime] NULL
[_exp_schenker_datcas_import] [datetime] NULL
[_exp_mnoz_potvrz] [numeric](19, 6) NULL
[_exp_edi_mnozprij_vyrc] [numeric](19, 6) NULL
[_SSCC_cisterna] [nvarchar](30) NULL
```
