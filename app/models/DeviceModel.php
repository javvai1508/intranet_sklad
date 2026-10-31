<?php

declare(strict_types=1);

namespace App\Models;

use Nette\Database\Row;

class DeviceModel extends BaseModel
{
    /** @return Row[] */
    public function getAvailableDevices(): array
    {
        return $this->db->query('SELECT ID, Kod, Nazev, Model, VyrobniCislo,
            CASE WHEN TokenHash IS NULL THEN 0 ELSE 1 END AS Registrovano
            FROM dbo.eTab_IntranetZarizeni WHERE Povoleno = 1 ORDER BY Kod')->fetchAll();
    }

    public function findByToken(string $token): ?Row
    {
        if (!preg_match('/^[a-f0-9]{64}$/D', $token)) {
            return null;
        }
        return $this->db->query('SELECT ID, Kod, Nazev, Model, VyrobniCislo
            FROM dbo.eTab_IntranetZarizeni WHERE Povoleno = 1 AND TokenHash = ?',
            hash('sha256', $token))->fetch() ?: null;
    }

    public function register(int $id, bool $replace): string
    {
        $device = $this->db->query('SELECT ID, TokenHash FROM dbo.eTab_IntranetZarizeni
            WHERE ID = ? AND Povoleno = 1', $id)->fetch();
        if (!$device) {
            throw new \RuntimeException('Zařízení neexistuje nebo není povolené.');
        }
        if ($device->TokenHash !== null && !$replace) {
            throw new \RuntimeException('Zařízení je již registrované. Potvrďte nahrazení původní registrace.');
        }
        $token = bin2hex(random_bytes(32));
        $now = new \DateTimeImmutable;
        // Compare-and-set prevents two administrators from silently overwriting a concurrent registration.
        $condition = $device->TokenHash === null ? 'TokenHash IS NULL' : 'TokenHash = ?';
        $params = [hash('sha256', $token), $now, $now, $id];
        if ($device->TokenHash !== null) {
            $params[] = $device->TokenHash;
        }
        $result = $this->db->query('UPDATE dbo.eTab_IntranetZarizeni
            SET TokenHash = ?, DatRegistrace = ?, DatPosledniAktivity = ?
            WHERE ID = ? AND Povoleno = 1 AND ' . $condition, ...$params);
        if ($result->getRowCount() !== 1) {
            throw new \RuntimeException('Registrace zařízení se mezitím změnila. Obnovte stránku a opakujte akci.');
        }
        return $token;
    }

    public function touch(string $token): void
    {
        $this->db->query('UPDATE dbo.eTab_IntranetZarizeni SET DatPosledniAktivity = ?
            WHERE TokenHash = ? AND Povoleno = 1
            AND (DatPosledniAktivity IS NULL OR DatPosledniAktivity < ?)',
            new \DateTimeImmutable, hash('sha256', $token), new \DateTimeImmutable('-5 minutes'));
    }
}
