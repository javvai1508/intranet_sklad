<?php

namespace App\Models;

use Nette;
use Nette\Security\Passwords;

class BaseModel
{

    /** @var Nette\Security\Passwords */
    public $passwords;

    /** @var Nette\Database\Explorer */
    public $db;

    // pass Nette\Database\Explorer to work with the Database Explorer layer
	public function __construct(
		private Nette\Database\Explorer $database,
		private Nette\Security\Passwords $password,
	) {
        $this->db = $database;
        $this->passwords = $password;
	}

}