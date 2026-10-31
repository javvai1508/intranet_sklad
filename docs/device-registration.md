# Registrace zařízení

V Heliosu připravte tabulku `dbo.eTab_IntranetZarizeni` podle dohodnuté struktury.
Aplikace používá sloupce `ID`, `Kod`, `Nazev`, `Model`, `VyrobniCislo`, `Povoleno`,
`TokenHash` (VARCHAR(64) nebo NVARCHAR(64), NULL), `DatumRegistrace` a `DatumPosledniAktivity`.
Záznamy a popisné údaje se spravují v Heliosu; aplikace je nevytváří.
Zařízení bez registrace musí mít `TokenHash = NULL` a povolené zařízení `Povoleno = 1`.
Doporučené unikátní indexy na `Kod` a nenulový `TokenHash` odpovídají návrhu tabulky.
Databázový účet aplikace potřebuje SELECT a UPDATE těchto tří registračních sloupců.

Na čtečce se přihlaste uživatelem s `PravaAdmin = 1`, otevřete **Nastavení**,
vyberte odpovídající zařízení a stiskněte **Zaregistrovat tento přístroj**.
U již registrovaného záznamu musíte potvrdit nahrazení: původní token přestane platit.
Menu i všechny požadavky stránky Nastavení kontrolují roli admin.
Formulář používá ochranu Nette proti CSRF. Registrační token má 256 bitů náhodnosti;
v databázi se ukládá pouze jeho SHA-256 v hexadecimálním formátu.

Cookie `intranet_device` má platnost 180 dnů, HttpOnly, SameSite=Lax a na HTTPS Secure.
Je omezena na základní cestu aplikace a není součástí přihlašovací session.
Pro provoz používejte HTTPS. Odhlášení pracovníka registraci nemaže.
Vymazání dat prohlížeče, změna prohlížeče nebo expirace vyžaduje novou registraci.
Při výběru jiného zařízení se cookie přepíše; původní záznam zůstává v evidenci
s původním hashem a pro jeho další použití bude potřeba registraci nahradit.

V menu se zobrazuje kód rozpoznaného zařízení. Povoleno = 0 zabrání jeho rozpoznání.
Poslední aktivita se zapisuje při vykreslení stránky přihlášenému uživateli,
nejvýše jednou za pět minut. Bez cookie se tabulka zařízení nečte.
Zatím není vyžadována registrace pro skladové operace ani se nemění jejich zápisy.
Pro budoucí evidenci je dostupná služba `App\Helpers\DeviceIdentity::getDevice()`.

Ověření na serveru: zaregistrovat TC21/TC7, odhlásit/přihlásit jiného pracovníka,
zkontrolovat kód v menu, nahradit registraci jiným prohlížečem a ověřit neplatnost
původní cookie. Ověřit blokaci Povoleno = 0 a nepřístupnost Nastavení bez Admin.
