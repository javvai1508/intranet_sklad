# Společný protokol intranetu

Aplikace Sklad – evidence používá IDApp = 1. Jednotlivé moduly (expedice, převody,
inventura, výroba, nastavení) nejsou samostatné aplikace. Další aplikace dostanou
jiné stabilní IDApp. Číselník akcí je společný pro celý intranet: ID se nemění ani
znovu nepoužívají. Zdroj číselníku: `app/audit/Action.php`.

| IDAkce | Událost |
|---|---|
| 100 | Přihlášení (úspěch i neúspěch) |
| 101 | Ruční odhlášení |
| 102 | Odmítnutí přístupu |
| 200 | Registrace zařízení |
| 201 | Nahrazení registrace zařízení |
| 300 | Výběr dodacího listu |
| 301 | Zrušení výběru / změna dodacího listu |
| 310 | Přidání palety na dodací list |
| 311 | Odebrání palety z dodacího listu |
| 320 | Uzavření přípravy dodacího listu |
| 400 | Založení převodky |
| 401 | Pokračování v existující převodce |
| 410 | Přidání palety na převodku |
| 411 | Odebrání palety z převodky |
| 412 | Odebrání všech palet položky převodky |
| 413 | Potvrzení přípravy palety |
| 414 | Zrušení potvrzení přípravy palety |
| 415 | Zrušení potvrzení přípravy celé položky |
| 420 | Uzavření převodky v aplikaci |
| 430 | Převod palety do prodejny |
| 500 | Výběr převodky ke kontrole příjmu |
| 510 | Potvrzení přijaté palety |
| 520 | Uzavření kontroly příjmu |
| 600 | Výběr inventury |
| 601 | Vyhledání palety v inventuře |
| 610 | Potvrzení inventurního množství |
| 611 | Oprava inventurního množství |
| 620 | Nahlášení palety mimo inventuru |
| 700 | Odvedení palety z výroby |

Vysledek: 1 = úspěch, 2 = odmítnutí kontrolou nebo formulářem,
3 = technická chyba. IDOperace je UUID jedné operace. Přesměrování po změně
nevytváří další úspěšný log. Běžná zobrazení a aktualizace aktivity zařízení se
nelogují. Výběr inventury se zaznamená při změně inventury v session, nikoli při
každém obnovení její stránky. Automatické vypršení přihlášení není ruční odhlášení.

SSCC je text bez úvodního GS1 identifikátoru 00; vlastní počáteční nuly se zachovají.
Při odstraňování celé položky je seznam palet uložen v JSON Detail.palety pod jedním
logem operace. Před smazáním se zachytí IDVyrCP, SSCC a množství. IDVyrCP je historický
údaj: nelze na něm vynucovat vazbu na dosud existující řádek. Inventurní logy ukládají
původní/nové množství, MJ a IDVyrCS do Detail. Výroba používá IDPrikaz,
IDVyrCisPrikaz a po odvedení IDDoklad příjemky. Převod do prodejny převezme ID příjemky
z návratové hodnoty stávající SQL procedury. Směr převodu je v Detail.smer.

Při registraci IDZarizeni označuje registrované cílové zařízení; Detail.ciloveZarizeni
ho obsahuje i u odmítnutého pokusu. U ostatních událostí se zařízení zjišťuje z platné
cookie a Povoleno = 1. Pokud zařízení není rozpoznáno, IDZarizeni je NULL.
Neúspěšné přihlášení má IDUzivatel = NULL, úspěšné ID přihlášeného pracovníka.

## Sloupce Heliosu

Záznam se vkládá do existující `dbo.eTab_IntranetLog`. Kromě dohodnutých sloupců
INSERT explicitně vyplňuje Autor = SUSER_SNAME(), DatPorizeni = GETDATE(),
Zmenil = NULL, DatZmeny = NULL, BlokovaniEditoru = NULL. DatAkce = GETDATE().
Čas tedy pochází z SQL Serveru. Počítané sloupce DatPorizeni_D/M/Y/Q/W/X a
DatZmeny_D/M/Y/Q/W/X se do INSERT nezařazují, vypočítá je SQL Server.
Referenční struktura je v `database/helios/reference/dbo.eTab_IntranetLog.sql`.
Není potřeba přidávat další sloupce ani spouštět CREATE TABLE nad existující tabulkou.

## Transakce a oprávnění

Databázový účet aplikace potřebuje INSERT na eTab_IntranetLog, SELECT na zařízení
a na tabulky potřebné pro dohledání rozpisů palet (již používané aplikací).
Log se nemění ani nemaže. Úspěšný log změny je součástí stejné transakce jako změna
dat: chyba zápisu do logu zabrání dokončení operace. Po rollbacku se samostatně
zapíše odmítnutí/chyba. Pokud není databáze vůbec dostupná, uložení chyby do stejné
DB není možné; chyba zápisu skončí v Tracy. Nezaznamenávají se PINy, session,
registrační tokeny ani celé požadavky. SQL výjimky se do tabulky nekopírují.

Aktualizace obsahuje nové PSR-4 mapování App\\Audit\\; při nasazení spusťte
`composer install --no-dev` (nebo `composer dump-autoload`, pokud jsou závislosti
již nainstalované) a vymažte cache Nette standardním postupem nasazení.

## Ověření

`tests/action-logging.php`: skutečný logger a transakce nad SQLite, systémové SQL
funkce jsou nahrazeny testovacími funkcemi. Ověřuje identitu, smazané palety,
přesnost množství, rollback dat, rollback při chybě logování, anonymní odmítnuté
přihlášení a skutečné směrování formuláře v Nette.

Na SQL Serveru následně ověřte: přihlášení, chybný PIN, přidání/odebrání palety,
uzavření dokladu, kontrolu příjmu, opravu inventury, odvedení výroby a registraci
zařízení. Zkontrolujte zejména návratovou hodnotu procedury převodu do prodejny,
Autor podle SQL účtu a IDUzivatel podle pracovníka. Nasazené Helios procedury
mohou být novější než jejich referenční kopie v repozitáři.
