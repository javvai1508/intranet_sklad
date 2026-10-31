# Přihlášení PINem

Přihlašovací formulář vyžaduje přesně čtyři číslice. PIN se porovnává jako text, tedy i s úvodními nulami. Zdrojem je dbo.eTab_IntranetUziv; původní oprávnění v TabCisZam_EXT se již nepoužívají.

## Oprávnění

| Příznak | Přístup |
| --- | --- |
| PravaAdmin | Všechny části aplikace |
| PravaSklad | Menu Sklad, převody, kontrola příjmu a dodací listy / expedice; bez inventury |
| PravaInventura | Menu Sklad a inventura; bez běžných skladových operací |
| PravaVyroba | Výroba |

Práva se sčítají. Kontroly platí pro menu i přímé požadavky. Identita obsahuje ID z eTab_IntranetUziv, nikoli ID zaměstnance; vazba na zaměstnance a jeho číslo jsou uloženy odděleně. Nové inventurní zápisy proto evidují ID intranetového uživatele. Starší záznamy s ID zaměstnance se nemění.

## Před nasazením

- Ověřit význam Stav: implementace považuje pouze hodnotu 0 za aktivní, NULL a ostatní hodnoty zamítá.
- Doplnit každému účtu unikátní čtyřmístný PIN a alespoň jedno oprávnění. Duplicitní PIN je zamítnut i tehdy, pokud druhý účet není aktivní.
- Pro odvádění výroby vyplnit ZamestnanecId s platnou vazbou na TabCisZam a číslem zaměstnance. Bez ní se odvedení neprovede ani administrátorovi.
- Databázový účet aplikace potřebuje SELECT na eTab_IntranetUziv a TabCisZam.
- Nasadit soubory z větve, vyčistit aplikační cache obvyklým způsobem a otestovat účty pro každou kombinaci práv. Staré relace budou automaticky odhlášeny.

Oprávnění a stav se načítají při přihlášení. Po změně údajů v Heliosu je nutné nové přihlášení; stávající relace má platnost nejvýše 12 hodin neaktivity dle nastavení Nette.

Kontrola duplicit (bez výpisu samotných PINů):

```sql
SELECT MIN(ID) AS PrvniID, COUNT(*) AS PocetUctu
FROM dbo.eTab_IntranetUziv
WHERE PIN IS NOT NULL
GROUP BY PIN
HAVING COUNT(*) > 1;
```

Automatické ověření: `php tests/pin-permissions.php` (autentizace nad SQLite testovacími tabulkami, vykreslení menu přes Nette/Latte, odmítnutí přímých skladových URL, signálů a formulářů bez příslušných práv, odmítnutí starých relací). Integraci s produkčním SQL Serverem je nutné ověřit v cílovém prostředí.
