# Databázové podklady skladové aplikace

Zdroj: `Helios002.zip`, soubor `Helios002.sql`, export z 18. 10. 2026.
Verze Heliosu nebyla samostatně doložena. Export neobsahuje provozní data.

## Uspořádání

- `procedures/`: deset vlastních procedur používaných aplikací přímo nebo přes aktivní volání dalších vlastních procedur.
- `reference/procedures/`, `reference/functions/`: dostupné přímé standardní závislosti těchto vlastních procedur. Další úrovně standardních závislostí nejsou rekurzivně kopírovány.
- `reference/tables/`: tabulky přímo odkazované PHP aplikací a uvedenými vlastními procedurami, včetně souvisejících exportovaných ALTER TABLE a indexů.
- `reference/triggers/`: triggery na zahrnutých tabulkách. Názvy samy o sobě neurčují autorství; kopie jsou referenční.
- `custom-columns/README.md`: přehled uživatelských sloupců zahrnutých EXT tabulek.
- `manifest.json`: seznam SQL souborů s kontrolními součty, kontrolní součet původního exportu a verze aplikace použitá pro rozbor.

Jde o snímek existujících definic, nikoliv o instalátor nové databáze nebo automatickou migraci. SQL obsahuje původní CREATE příkazy a původní chování; neprovádí změny v Heliosu. Referenční standardní objekty se nemají automaticky nasazovat ani přepisovat při aktualizaci aplikace. Celý export databáze, uživatelé, oprávnění a provozní data nejsou součástí tohoto výběru.

Závislosti byly vybrány statickým rozborem aplikace a aktivního SQL. Volání uvnitř komentářů nejsou aktivní závislosti. Dynamické SQL, volitelné hooky, metadata Heliosu a externí programy mohou mít další závislosti; tento výběr není úplnou samostatně nasaditelnou kopií databáze. Ve vlastní proceduře `hpx_agrafa_insert_polozky_oz` je volitelný hook `dbo.ep_OZGetUmistInsPol`; jeho definice v exportu nebyla nalezena.

## Vlastní procedury a vazby

| Procedura | Volání z aplikace / vlastní návaznosti |
|---|---|
| `dbo.hpx_agrafa_sklad_zaloz_vydej_ost_hl_tablet` | MaterialModel: založení hlavičky výdejky |
| `dbo.hpx_agrafa_skl_dokl_pridej_paletu` | MaterialModel; volá `hpx_agrafa_insert_polozky_oz` |
| `dbo.hpx_agrafa_skl_dokl_priprav_paletu` | MaterialModel: potvrzení přípravy palety |
| `dbo.hpx_agrafa_sklad_uzavrit_vydej` | MaterialModel: uzavření převodu |
| `dbo.hpx_agrafa_sklad_uzavrit_vydej_priprava` | MaterialModel a DeliveryNoteModel: uzavření přípravy |
| `dbo.hpx_agrafa_skl_dokl_prevod_do_prod` | MaterialModel; volá `hpx_agrafa_insert_polozky_oz` |
| `dbo.hpx_agrafa_vyr_odvedeni_vc_tablet` | ProductionModel; volá `hpx_agrafa_vyr_odved_vc` |
| `dbo.hpx_agrafa_insert_polozky_oz` | Sdílené vložení položky dokladu |
| `dbo.hpx_agrafa_vyr_odved_vc` | Odvedení výroby; volá `hpx_agrafa_skl_prepoc_doklad` |
| `dbo.hpx_agrafa_skl_prepoc_doklad` | Přepočet výrobní příjemky |

## Nastavení převodů

| Parametr | Do Schenkeru | Do Loukova | Do prodejny |
|---|---|---|---|
| Typ aplikace | `toSchenker` | plánovaný `toLoukov` | samostatná operace |
| Zdrojový sklad | `00100304` | `00100304` | `00100304` |
| Řada výdejky | `372` | `384` | `372` |
| Druh pohybu výdejky | `4` | `4` (stejný postup jako Schenker) | `4` |
| Cílový sklad | `00100303` | `00100308` | `00100305` |
| Řada příjemky | `351` | `351` | `351` |
| Druh pohybu příjemky | `0` | `0` (stejný postup jako Schenker) | `0` |

Schenker a prodejna jsou ověřené z exportovaných procedur. Sklady a řady Loukova zadal uživatel 18. 10. 2026; podpora Loukova dosud není v uloženém snímku procedury pro založení výdejky ani v PHP aplikaci implementována.

U převodu do Schenkeru a plánovaného převodu do Loukova provádí tisk a realizaci uživatel ručně v Heliosu (potvrzeno 18. 10. 2026). Aplikace při uzavření volá `hpx_agrafa_sklad_uzavrit_vydej`, která přepočítá množství/ceny a nastaví `_exp_dat_uzavreno`, `_exp_dat_ktisku` a `_exp_dat_tisku`. Volání realizace je v této proceduře zakomentované. Samostatný převod do prodejny má jiný postup: jeho procedura realizuje výdejku a vytváří příjemku.

## Následující změna: Loukov

- Přidat volbu a společnou obsluhu s převodem do Schenkeru v MaterialPresenteru a šablonách.
- Rozlišovat otevřené doklady podle skladu a řady: Schenker `372`, Loukov `384`.
- Doplnit `toLoukov` do procedury založení hlavičky s hodnotami uvedenými výše.
- Zachovat ruční tisk a realizaci. Společné přidávání palet používá zdrojový sklad z hlavičky dokladu.

## Zjištěný nesoulad aplikace a exportu

Při ověření 18. 10. 2026 na větvi `main` (`169d4a8`) metoda `removeDeliveryNoteItemInternal()` stále používá `TabVyrCP_EXT._exp_mnozstvi_vc_pozad`, který v dodaném exportu není. Stejný odkaz je i ve větvi `fix/warehouse-integrity`. Uživatel uvedl, že metodu již opravil; jeho opravu je potřeba synchronizovat do používané větve. Tento commit mění jen databázové podklady a PHP metodu nepřepisuje. Metoda pro odebrání jediné palety `removeDeliveryNoteItemSNInternal()` již tento sloupec nepoužívá.
