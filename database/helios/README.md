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
| Typ aplikace | `toSchenker` | `toLoukov` | samostatná operace |
| Zdrojový sklad | `00100304` | `00100304` | `00100304` |
| Řada výdejky | `372` | `384` | `372` |
| Druh pohybu výdejky | `4` | `4` (stejný postup jako Schenker) | `4` |
| Cílový sklad | `00100303` | `00100308` | `00100305` |
| Řada příjemky | `351` | `351` | `351` |
| Druh pohybu příjemky | `0` | `0` (stejný postup jako Schenker) | `0` |

Schenker a prodejna jsou ověřené z exportovaných procedur. Sklady a řady Loukova zadal uživatel 18. 10. 2026; podpora Loukova je implementovaná v PHP aplikaci a v migraci `migrations/20261020_loukov.sql`. Historický snímek v `procedures/` zůstává beze změny.

U převodu do Schenkeru a převodu do Loukova provádí tisk a realizaci uživatel ručně v Heliosu (potvrzeno 18. 10. 2026). Aplikace při uzavření volá `hpx_agrafa_sklad_uzavrit_vydej`, která přepočítá množství/ceny a nastaví `_exp_dat_uzavreno`, `_exp_dat_ktisku` a `_exp_dat_tisku`. Volání realizace je v této proceduře zakomentované. Samostatný převod do prodejny má jiný postup: jeho procedura realizuje výdejku a vytváří příjemku.

## Nasazení převodu do Loukova

1. V cílové databázi Heliosu ověřit sklad `00100308`, výdejovou řadu `384` pro druh pohybu `4` a příjmovou řadu `351` pro druh pohybu `0`. Konfigurace číselníků není součástí schématu bez dat.
2. V SSMS spustit [migrations/20261020_loukov.sql](migrations/20261020_loukov.sql) v této databázi. Skript mění pouze proceduru založení hlavičky, nevytváří provozní doklady.
3. Nasadit PHP aplikaci a vymazat cache Nette v `temp/cache`.
4. Na testovací databázi otevřít současně Schenker a Loukov. Každá volba musí pokračovat ve vlastní rozpracované výdejce (řady `372` / `384`).
5. Ověřit načtení palety, odmítnutí duplicitního skenu, odebrání palety, uzavření, ruční tisk a realizaci v Heliosu včetně návazné příjemky do správného skladu.

Převody sdílejí zpracování načtení, odebrání i uzavření. Nový doklad se kontroluje podle zdrojového a cílového skladu, obou řad a druhů pohybu; při nesouladu se transakce vrátí zpět. Rozpracované doklady se vyhledávají podle řady a zdrojového skladu. Při více rozpracovaných výdejkách stejného typu se další doklad nezaloží.

Původní SQL definice a kontrolní součty v `manifest.json` dokumentují export z 18. 10. 2026. Migrace je samostatná následná změna a není součástí tohoto historického manifestu. Pro návrat k původní aplikaci lze obnovit původní definici procedury ze snímku (jako ALTER PROCEDURE); již vytvořené doklady tím nejsou odstraněny.

## Pravidlo dodacích listů

U dodacího listu nelze v aplikaci mazat celou položku ani hromadně odebírat všechny její palety. Lze odebírat pouze jednotlivé palety z otevřeného dokladu. Z aplikace byly odstraněny modelové metody pro hromadné odebrání i příslušný signál presenteru. Tím zaniká i odkaz této funkce na sloupec `_exp_mnozstvi_vc_pozad`, který dodaný export neobsahuje. Odebrání jednotlivé palety používá stávající opravenou metodu `removeDeliveryNoteItemSNInternal()`.

## Společná kontrola příjmu převodů

V nabídce skladu je společná volba **Kontrola příjmu převodů** (`TransferReceiptPresenter`, `TransferReceiptModel`) pro roli `sklad`. Seznam obsahuje nezkontrolované výdejky obou směrů: `00100304` → `00100308`, řada `384`, a `00100308` → `00100304`, řada `381`; v obou případech je příjmová řada `351`. Doklad musí být uzavřený nebo realizovaný ve zdrojovém skladu. Lze zobrazit oba sklady nebo filtrovat podle cílového skladu. Výdejku lze vybrat ze seznamu nebo načíst/zadat její párovací znak. Směr, zdroj a cíl jsou viditelné také v detailu kontroly. Číslo dokladu se vždy vyhledává v obou podporovaných směrech; při nejednoznačnosti se musí vybrat konkrétní doklad ze seznamu.

Při načtení kódu palety s prefixem `00` se vyhledá právě jeden záznam palety na vybrané výdejce. Do `TabVyrCP_EXT._exp_schenker_datcas` se uloží `GETDATE()` a do `_exp_schenker_mnoz` se přesně překopíruje `TabVyrCP.Mnozstvi` v SQL, bez převodu na celé číslo. Cizí, duplicitně uvedená nebo již načtená paleta je odmítnuta. Množství se nepřebírá z prohlížeče. Palety se nepřidávají na jiné doklady a nemění se původní množství výdejky.

Uzavření je možné jen u neprázdné výdejky po potvrzení všech palet, při shodě potvrzených množství s aktuálními množstvími palet a při shodě součtů palet s množstvím každé položky. Do `TabDokladyZbozi_EXT._exp_schenker_datzprac` se zapíše datum a čas uzavření kontroly v příslušném cílovém skladu. Uzavřená kontrola je pouze pro čtení. Každý zápis má transakci, společný zámek aplikace a opakované ověření stavu a příslušnosti dokladu; realizace výdejky ve výchozím skladu příjmové kontrole nebrání.

Kontrola otevřené výdejky `toLoukov` i `fromLoukov` sleduje `_exp_schenker_datzprac IS NULL`, tedy i výdejku již uzavřenou nebo realizovanou ve zdrojovém skladu. Dokud není dokončen příjem v cílovém skladu, nelze založit další výdejku stejného směru. Oba směry se posuzují samostatně podle řady a zdrojového skladu. Schenker zachovává původní podmínku otevření.

Používají se existující sloupce z dodaného schématu; další SQL migrace není potřeba. Přístup účtu aplikace musí umožňovat SELECT/INSERT/UPDATE na uvedených EXT tabulkách. Jde o fyzickou kontrolu proti původní výdejce, nikoliv o vytvoření nebo realizaci účetní příjemky. Tisk a realizace zůstávají ruční.

Před nasazením ověřit na testovací kopii Heliosu: příjem proti uzavřené i realizované výdejce; cizí a opakovaný sken; přerušení a pokračování; dvě čtečky; neúplné uzavření; změnu množství v Heliosu mezi načtením a uzavřením; blokování změn po uzavření a možnost založit další výdejku až po dokončení příjmu.

## Převod z Loukova

V nabídce skladu je volba **Převod z Loukova** (`fromLoukov`).

| Parametr | Hodnota |
|---|---|
| Zdrojový sklad | `00100308` |
| Řada výdejky / druh pohybu | `381` / `4` |
| Cílový sklad | `00100304` |
| Řada příjemky / druh pohybu | `351` / `0` |

Volba sdílí založení a opětovné otevření výdejky, načítání palet, odebrání palety či položky a uzavření s ostatními převody. Dostupnost palety se kontroluje ve zdrojovém skladu z hlavičky dokladu. Otevřená výdejka se vyhledává samostatně podle skladu `00100308` a řady `381`. Nový zpětný převod lze založit až po dokončení příjmové kontroly ve skladu `00100304`, podle `_exp_schenker_datzprac`. Společná příjmová kontrola zpracovává oba směry.

### Nasazení zpětného převodu

1. Ověřit v Heliosu výdejovou řadu `381` pro sklad `00100308` a cílový sklad `00100304` s příjmovou řadou `351`.
2. V cílové databázi spustit [migrations/20261020_loukov_return.sql](migrations/20261020_loukov_return.sql). Skript nahrazuje celou definici procedury založení hlavičky a obsahuje i dřívější podporu převodu do Loukova, takže jej lze použít i bez předchozího spuštění `20261020_loukov.sql`. Po tomto skriptu již nespouštět starší migraci, která by podporu zpětného převodu odstranila.
3. Nasadit aplikaci a vymazat cache Nette.
4. Ověřit na testovací databázi založení výdejky řady `381`, načtení palety ze skladu `00100308`, odmítnutí palety z jiného skladu, odebrání, pokračování v rozpracované výdejce a uzavření. Ověřit i souběžně otevřené směry a následný ruční tisk a realizaci včetně správného cílového skladu příjemky.

Tisk a realizaci provádí uživatel ručně stejně jako u ostatních převodů. Historické definice a předchozí migrace zůstávají zachované.

### Přechod na společnou kontrolu

Nejsou potřeba další databázové sloupce ani migrace navíc k `20261020_loukov_return.sql`. Záznamy potvrzení zůstávají na původních výdejkách v existujících EXT sloupcích. Při nasazení aktualizovat také `config/services.neon` a vymazat cache Nette. Staré adresy `LoukovReceipt:default` a `LoukovReceipt:showReceipt` přesměrují na společnou obrazovku; existující session výběru je zachovaná.

Ověření zahrnuje seznam obou směrů a filtr každého cíle, výběr číslem i ze seznamu, potvrzení a uzavření ve skladu `00100308` i `00100304`, odmítnutí cizí palety/dokladu a neměnnost uzavřené kontroly. Po potvrzení příjmu se má odblokovat pouze příslušný směr výdeje.
