# Inventura palet – nasazení a ověření

## Co připravit v Heliosu

1. Nejprve na testovací kopii databáze spusťte `migrations/20261021_inventory.sql`.
   V SSMS zvolte správnou databázi Heliosu. Skript zakládá dvě vlastní tabulky:
   `dbo.eTab_IntranetInvCheck` (historie potvrzení a oprav množství) a
   `dbo.eTab_IntranetInvDiscrepancy` (nenalezené palety a poznámky).
   Opakované spuštění existující tabulky ponechá. Nejde o synchronizaci libovolných
   starších definic. Standardní tabulky, triggery ani procedury Heliosu nemění.
2. SQL účtu aplikace zajistěte SELECT na `TabInvHead`, `TabInvItem`, `TabVyrCS`,
   `TabStavSkladu`, `TabKmenZbozi`; UPDATE sloupců `MnozstviInv`, `MnozstviMJ`,
   `Zmenil`, `DatZmeny` v `TabInvItem`; SELECT a INSERT na obou nových tabulkách.
   Stávající oprávnění mohou být dostačující. Aplikace používá stávající transakční
   `sp_getapplock` jako ostatní skladové operace. DDL spouští správce, nikoli aplikace.
3. V Heliosu připravte množstevní inventuru (`TypInv = 0`) s výrobními čísly
   (`VC = 1`) a vygenerujte její řádky. Musí mít `DatumClose IS NULL`, `Stav = 0`,
   bez `DatumDoklady`, `IdPrijem`, `IdVydej`. Řádky k zadání musí mít `Uzav = 0`.
   Inventury finanční a bez výrobních čísel aplikace nenabízí.
4. Ověřte na reálné testovací paletě číslo v `TabVyrCS.Nazev1`, sklad, evidenční
   jednotku a inventurní jednotku. Připravte i případ s `PrepMnozstvi <> 1`, pokud
   jej používáte. Zadává se evidenční množství: `MnozstviInv = zadání`,
   `MnozstviMJ = zadání / PrepMnozstvi` (zaokrouhleno na šest míst).
5. Připravte známou paletu mimo inventuru, paletu v jiném skladu a neznámý kód.
   Pokud používáte inventuru podle umístění, připravte více řádků stejné palety.
6. Po ověření zopakujte instalaci tabulek a nasazení aplikace v provozní databázi.
   Zajistěte zálohování vlastních tabulek spolu s databází Heliosu.

Není třeba zakládat EXT sloupce, měnit standardní procedury ani používat
`Uzav` jako příznak načtení. Nové tabulky lze podle vašich pravidel registrovat
jako uživatelské tabulky Heliosu; aplikace vyžaduje uvedená fyzická SQL jména
a definice. Jejich zobrazení v přehledech Heliosu není pro aplikaci nutné.

## Chování aplikace

V nabídce skladu je volba **Inventura**. Výběr inventury je součástí URL;
nezávisí na sdíleném výběru v session, takže různé panely mohou mít různé inventury.
Čtečka předává `00` + číslo palety; odstraní se přesně první dvě nuly.

Po načtení jediné odpovídající položky se otevře množství předvyplněné skladovým
stavem při inventuře. U již kontrolované položky se předvyplní aktuální inventurní
množství a oprava vyžaduje výslovné zaškrtnutí. Nula vyžaduje samostatné potvrzení.
Zrušení nic nezapisuje. Při více řádcích obsluha nejprve vybere konkrétní řádek;
ID umístění je zobrazeno pro jejich rozlišení. Uzavřený řádek nelze měnit.

Množství není omezené skladovým stavem (inventura může zjistit přebytek).
Záporné hodnoty a více než šest desetinných míst jsou odmítnuty. Číselné řetězce
se validují v PHP, výpočty a zápis probíhají v SQL. Množství se nikdy nepřičítá.

Potvrzení se zapisuje spolu s historií v jedné transakci. Hlavička a položka
se zamknou, zopakuje se kontrola otevření a kontrola verze formuláře. Pokud mezitím
jiná čtečka či Helios změnily množství, převod nebo poslední kontrolu, starý
formulář se odmítne. Uživatel je ID přihlášeného účtu aplikace (`TabCisZam` dle
stávajícího přihlašování), čas je čas SQL serveru. Zápis standardních auditních
sloupců `Zmenil`, `DatZmeny` doplňuje vlastní historii.

Přehled potvrzených položek porovnává poslední kontrolu s aktuálními množstvími,
skladovým stavem, jednotkou a převodem. Změna v Heliosu proto může vrátit řádek
mezi nepotvrzené. Stejné hodnoty zapsané mimo aplikaci nelze jen ze schématu odlišit.
Uzavření a opětovné otevření stejné inventury automaticky nemaže historii;
nové inventurní kolo zakládejte jako novou inventuru.

Nenalezená paleta se dohledá v celé evidenci palet. Aplikace ukáže sklad nebo
upozorní na neznámé číslo a nabídne poznámku a zápis nesrovnalosti. Jeden kód
se v téže inventuře nahlásí nejvýše jednou (opakovaný pokus nezmění poznámku).
Nesrovnalosti zůstávají v přehledu i po ručním doplnění položky a slouží jako
historická evidence; jejich vypořádání provádí odpovědný uživatel v Heliosu.
Žádná položka inventury se automaticky nezakládá.

Počet potvrzených řádků zahrnuje pouze řádky s paletou; inventura může obsahovat
navíc řádky bez výrobního čísla. Aplikace inventuru neuzavírá, nerealizuje doklady
ani nemění ceny. Konečné vyhodnocení a uzavření provádí uživatel v Heliosu.

## Test na SQL Serveru před nasazením

- Běžná paleta: zadání, zrušení bez zápisu, opakované čtení, výslovná oprava.
- Nula s potvrzením a bez něj; desetinná čárka; šest desetinných míst; přebytek.
- Rozdílné jednotky: porovnat oba množstevní sloupce a zobrazení v Heliosu.
- Více řádků stejné palety: vybrat správné umístění, ostatní řádky beze změny.
- Neznámá paleta, jiný sklad, známá paleta mimo inventuru; opakované nahlášení.
- Dvě čtečky: obě otevřou stejnou položku, první uloží, druhá musí být odmítnuta.
- Mezi otevřením formuláře a uložením uzavřít řádek nebo inventuru v Heliosu.
- Změnit množství v Heliosu po potvrzení: přehled vyžaduje novou kontrolu.
- Ověřit, že při chybě zápisu historie nedojde ani k částečné změně množství.

Automatické testy používají databázový dvojník a Nette/Latte. Nenahrazují výše
uvedenou integrační zkoušku na SQL Serveru a kontrolu v editoru Heliosu.

## Referenční SQL podklady

Adresář `inventory-reference/` obsahuje původní definice obou tabulek včetně
omezení a výchozích hodnot, generovací/uzavírací proceduru, přepínání `Uzav`,
dvě vlastní pomocné procedury a oba nalezené triggery. Jsou to reference
z exportu 18. 10. 2026, nikoli instalační skripty.
