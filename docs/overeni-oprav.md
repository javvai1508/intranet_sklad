# Opravy skladové aplikace

Přihlášení číslem zaměstnance zůstává zachované. Účet musí mít alespoň jednu z rolí aplikace. Ověření heslem je samostatná plánovaná změna.

## Změny

- Mazání, skenování a uzavírání kontroluje existenci a otevřený stav dokladu. Detail a mazání ověřují příslušnost položky a palety.
- Formuláře nepoužívají klientem zaslané ID jako autoritu; kontrolují shodu se zvoleným dokladem v session.
- Aktivní zápisové operace mají transakci a společný databázový `sp_getapplock` s čekáním nejvýše 10 sekund. Kontroly před zápisem se opakují uvnitř transakce. Zámek koordinuje tuto aplikaci; jiné klienty automaticky nekoordinuje.
- Doplněny obsluhy odebrání celé položky převodky a odebrání z balíku. U přípravy se ruší potvrzení, nikoliv plánované množství.
- Uzavření se ověřuje načtením stavu dokladu, odvedení výroby podle výstupního ID příjemky. Neúspěch vrátí transakci zpět a zobrazí chybu.
- Změnové signály vyžadují POST a token session, formuláře mají ochranu Nette. JavaScript zajistí odeslání odkazu přes POST i potvrzení mazání.
- Vypnut veřejný debug, odstraněno phpinfo, opraven typ výsledku databáze, SQL placeholdery a neaktuální role na úvodní stránce.

## Automatické kontroly

```sh
composer install
find app www tests -name '*.php' -print0 | xargs -0 -n1 php -l
php tests/warehouse.php
php tests/framework.php
node --check www/js/main.js
node tests/signals.js
```

Testy modelů používají databázový testovací objekt. Ověřují zamítnutí uzavřených dokladů a cizích položek, rollback po chybě mazání, odmítnutí opakovaného skenu a potvrzení výsledku uzavření. Test frameworku sestaví DI kontejner, vytvoří všechny aktivní presentery a zkompiluje všechny Latte šablony. Nenahrazují integrační test nad SQL Serverem.

## Ověření na testovací kopii Heliosu před nasazením

1. Přihlásit zaměstnance se skladovou a výrobní rolí, případně pouze expedicí. Účet bez role musí být odmítnut.
2. Vytvořit převodku, načíst paletu, otevřít detail, odebrat paletu a celou položku, znovu doplnit a uzavřít. U přípravy zkontrolovat zachování plánovaných množství.
3. Připravit dodací list, načíst paletu, ověřit odmítnutí duplicitního skenu a překročení množství. Vyzkoušet odebrání palety, položky a obsahu balíku.
4. Změnit ID v požadavku na položku jiného dokladu; požadavek nesmí nic změnit. Stejně ověřit uzavřený a realizovaný doklad.
5. Dvěma čtečkami současně načíst stejnou paletu a současně založit novou převodku. Operace musí mít jediný výsledek. Ověřit také paralelní práci v Heliosu.
6. Ověřit převod do prodejny, odvedení výroby a zprávy při neúspěchu. Procedura převodu musí změnit disponibilní množství zdrojové palety a uzavírací procedury stav dokladu; jinak aplikace operaci vrátí zpět.
7. Na Androidu ověřit Enter ze čtečky, návrat fokusu po chybě, potvrzení mazání a chování při výpadku sítě. Po nejasném výsledku nejprve zkontrolovat stav dokladu.

Definice SQL procedur a triggerů nejsou součástí repozitáře. Je nutné ověřit, že respektují vnější transakci, neprovádějí její nekontrolovaný COMMIT/ROLLBACK a správně řeší souběh se zápisy z Heliosu. Testovat s účtem a nastavením odpovídajícím produkci. Nasazení nemění databázové schéma.
