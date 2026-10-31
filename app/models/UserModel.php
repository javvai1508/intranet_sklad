<?php

namespace App\Models;

use Nette\Security\AuthenticationException;
use Nette\Security\Authenticator;
use Nette\Security\SimpleIdentity;

class UserModel extends BaseModel implements Authenticator
{
    public function authenticate(string $username, string $password): SimpleIdentity
    {
        // Keep PIN as text: leading zeroes are significant.
        if (!preg_match('/^[0-9]{4}$/D', $username)) {
            throw new AuthenticationException('Zadejte čtyřmístný PIN.', self::INVALID_CREDENTIAL);
        }
        $rows = $this->db->query("SELECT u.ID, u.ZamestnanecId, u.JmenoPrijmeni,
            u.Stav, u.PravaAdmin, u.PravaSklad, u.PravaInventura, u.PravaVyroba,
            zam.Cislo AS cislozam, zam.Jmeno, zam.Prijmeni
            FROM dbo.eTab_IntranetUziv u
            LEFT JOIN dbo.TabCisZam zam ON zam.ID = u.ZamestnanecId
            WHERE u.PIN = ?", $username)->fetchAll();
        // Ambiguous PINs fail closed, including duplicates on inactive accounts.
        if (count($rows) !== 1 || $rows[0]->Stav === null || (int) $rows[0]->Stav !== 0) {
            throw new AuthenticationException('Neplatný PIN nebo neaktivní účet.', self::INVALID_CREDENTIAL);
        }
        $auth = $rows[0];
        $roles = [];
        foreach (['PravaAdmin' => 'admin', 'PravaSklad' => 'sklad',
            'PravaInventura' => 'inventura', 'PravaVyroba' => 'vyroba'] as $column => $role) {
            if ((int) $auth->$column === 1) { $roles[] = $role; }
        }
        if (!$roles) {
            throw new AuthenticationException('Uživatel nemá přidělená oprávnění.', self::NOT_APPROVED);
        }
        return new SimpleIdentity($auth->ID, $roles, [
            'fullname' => trim((string) $auth->JmenoPrijmeni) ?: trim($auth->Jmeno . ' ' . $auth->Prijmeni),
            'zamestnanecId' => $auth->ZamestnanecId,
            'cislozam' => $auth->cislozam,
            'authVersion' => 2,
        ]);
    }
}
