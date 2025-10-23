<?php

namespace App\Models;

use Nette,
    Nette\Security\SimpleIdentity;

class UserModel extends BaseModel implements Nette\Security\Authenticator {

    /**
     * Performs an authentication.
     * @return Nette\Security\SimpleIdentity
     * @throws Nette\Security\AuthenticationException
     */
    public function authenticate(string $username, string $password): SimpleIdentity {

        $auth = $this->db->query("SELECT zam.ID AS id, "
                        . "zam.Cislo AS cislozam, "
                        . "CONCAT(zam.Jmeno, ' ', zam.Prijmeni) AS fullname,"
                        . "CASE WHEN ISNULL(zame._intranet_exp, 0) = 1 THEN 'expedice' ELSE '' END AS exp,"
                        . "CASE WHEN ISNULL(zame._intranet_vyroba, 0) = 1 THEN 'vyroba' ELSE '' END AS vyroba,"
                        . "CASE WHEN ISNULL(zame._intranet_sklad, 0) = 1 THEN 'sklad' ELSE '' END AS sklad,"
                        . "zame._intranet_vychozi AS vychozi "
                        . "FROM TabCisZam zam "
                        . "LEFT JOIN TabCisZam_EXT zame ON zam.ID = zame.ID "
                        . "WHERE zam.Cislo = ?", $username)->fetch();

        if (!$auth) {
            throw new Nette\Security\AuthenticationException('Zaměstnanec nemá potřebná oprávnění.', self::IDENTITY_NOT_FOUND);
        }
        $roles = array();
        if ($auth->exp != "") {
            array_push($roles, $auth->exp);
        }
        if ($auth->vyroba != "") {
            array_push($roles, $auth->vyroba);
        }
        if ($auth->sklad != "") {
            array_push($roles, $auth->sklad);
        }
        
        $data = array('fullname' => $auth->fullname, 'vychozi' => $auth->vychozi, 'cislozam' => $auth->cislozam);
        return new SimpleIdentity(
            $auth->id, 
            $roles, 
            $data
        );
    }

}
