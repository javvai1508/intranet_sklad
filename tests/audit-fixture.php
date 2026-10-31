<?php

function createAuditFixture(Nette\Database\Explorer $db): void
{
    $schemas = $db->query('PRAGMA database_list')->fetchAll();
    if (!array_filter($schemas, fn($row) => $row->name === 'dbo')) {
        $db->query("ATTACH DATABASE ':memory:' AS dbo");
    }
    $pdo = $db->getConnection()->getPdo();
    $pdo->sqliteCreateFunction('GETDATE', fn() => date('Y-m-d H:i:s'));
    $pdo->sqliteCreateFunction('SUSER_SNAME', fn() => 'sql-test-login');
    $db->query('CREATE TABLE dbo.eTab_IntranetLog (
        ID INTEGER PRIMARY KEY AUTOINCREMENT, IDApp INT NOT NULL, IDAkce INT NOT NULL,
        DatAkce TEXT NOT NULL, Vysledek INT NOT NULL, IDOperace TEXT NOT NULL,
        IDZarizeni INT, IDUzivatel INT, IDDoklad INT, IDPolozkaDokladu INT,
        IDVyrCP INT, SSCC TEXT, IDInventura INT, IDPolozkaInventury INT,
        IDPrikaz INT, IDVyrCisPrikaz INT, Popis TEXT, Detail TEXT,
        Autor TEXT NOT NULL, DatPorizeni TEXT NOT NULL,
        Zmenil TEXT, DatZmeny TEXT, BlokovaniEditoru INT)');
}
