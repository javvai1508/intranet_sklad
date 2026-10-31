<?php

declare(strict_types=1);

namespace App\Audit;

use Nette\Database\Explorer;
use Nette\Http\IRequest;
use Nette\Security\User;

class AuditLog
{
    public const APP = 1;
    private ?int $action = null;
    private array $fields = [];
    private array $detail = [];
    private string $operation = '';
    private bool $finished = false;
    private ?int $actor = null;
    private ?int $device = null;

    public function __construct(private readonly Explorer $db, private readonly User $user,
        private readonly IRequest $request) {}

    public function begin(int $action, array $fields = [], array $detail = []): void
    {
        $this->action = $action;
        $this->fields = [];
        $this->detail = [];
        $this->finished = false;
        $hex = bin2hex(random_bytes(16));
        $this->operation = substr($hex, 0, 8) . '-' . substr($hex, 8, 4) . '-4' . substr($hex, 13, 3)
            . '-8' . substr($hex, 17, 3) . '-' . substr($hex, 20);
        $this->actor = $this->user->isLoggedIn() ? (int) $this->user->getId() : null;
        $this->device = null;
        $token = $this->request->getCookie('intranet_device');
        if (is_string($token) && preg_match('/^[a-f0-9]{64}$/D', $token)) {
            try {
                $value = $this->db->query('SELECT ID FROM dbo.eTab_IntranetZarizeni
                    WHERE Povoleno = 1 AND TokenHash = ?', hash('sha256', $token))->fetchField();
                $this->device = $value ? (int) $value : null;
            } catch (\Nette\Database\DriverException $e) {
                \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            }
        }
        $this->enrich($fields, $detail);
    }

    public function pending(): bool { return $this->action !== null && !$this->finished; }

    public function setAction(int $action): void { if ($this->pending()) $this->action = $action; }

    public function enrich(array $fields = [], array $detail = []): void
    {
        if (!$this->pending()) return;
        foreach ($fields as $key => $value) {
            if (in_array($key, ['IDZarizeni', 'IDUzivatel', 'IDDoklad', 'IDPolozkaDokladu', 'IDVyrCP',
                'SSCC', 'IDInventura', 'IDPolozkaInventury', 'IDPrikaz', 'IDVyrCisPrikaz'], true)) {
                if ($key === 'SSCC') {
                    // Only normalized numeric pallet identifiers, never arbitrary request contents.
                    $value = is_string($value) && preg_match('/^[0-9]{1,100}$/D', $value) ? $value : null;
                } else {
                    $value = filter_var($value, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]) ?: null;
                }
                $this->fields[$key] = $value;
            }
        }
        $this->detail = array_replace($this->detail, $detail);
    }

    /** Snapshot pallet identity before deletion, or resolve the newly created document allocation. */
    public function capturePallets(): void
    {
        if (!$this->pending()) return;
        $where = null;
        $params = [];
        if (!empty($this->fields['IDVyrCP'])) {
            $where = 'cp.ID = ?'; $params = [$this->fields['IDVyrCP']];
        } elseif (!empty($this->fields['IDPolozkaDokladu'])) {
            $where = 'cp.IDPolozkaDokladu = ?'; $params = [$this->fields['IDPolozkaDokladu']];
        } elseif (!empty($this->fields['IDDoklad']) && !empty($this->fields['SSCC'])) {
            $where = 'p.IDDoklad = ? AND cs.Nazev1 = ?';
            $params = [$this->fields['IDDoklad'], $this->fields['SSCC']];
        }
        if ($where === null) return;
        $rows = $this->db->query('SELECT cp.ID, cp.IDPolozkaDokladu, cs.Nazev1 AS SSCC,
            CAST(cp.Mnozstvi AS varchar(40)) AS Mnozstvi
            FROM TabVyrCP cp JOIN TabPohybyZbozi p ON p.ID = cp.IDPolozkaDokladu
            LEFT JOIN TabVyrCS cs ON cs.ID = cp.IDVyrCis WHERE ' . $where, ...$params)->fetchAll();
        if (count($rows) === 1) {
            $this->enrich(['IDVyrCP' => $rows[0]->ID, 'IDPolozkaDokladu' => $rows[0]->IDPolozkaDokladu,
                'SSCC' => $rows[0]->SSCC]);
        }
        if ($rows && !isset($this->detail['palety'])) {
            $this->detail['palety'] = array_map(fn($row) => (array) $row, $rows);
        }
    }

    /** Must run INSIDE the business transaction. Failure aborts the business operation. */
    public function writeSuccess(): void { if ($this->pending()) $this->write(1, null); }
    public function accept(): void { $this->finished = true; }

    public function complete(): void
    {
        if (!$this->pending()) return;
        $this->writeSuccess();
        $this->accept();
    }

    public function failure(string $message, int $result = 2): void
    {
        if (!$this->pending()) return;
        try { $this->write($result, $message); }
        catch (\Throwable $e) { \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION); }
        $this->accept();
    }

    private function write(int $result, ?string $message): void
    {
        $fields = $this->fields;
        // The login event is begun anonymously; use the authenticated identity only on success.
        $actor = $this->action === Action::LOGIN ? ($result === 1 ? $this->user->getId() : null) : $this->actor;
        $fields += ['IDUzivatel' => $actor, 'IDZarizeni' => $this->device];
        $json = $this->detail ? json_encode($this->detail, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE | JSON_THROW_ON_ERROR) : null;
        if ($message !== null) $message = \Nette\Utils\Strings::substring($message, 0, 1000);
        // Autor is the SQL login, not the intranet user. Computed Helios columns are never inserted.
        $columns = ['IDApp', 'IDAkce', 'DatAkce', 'Vysledek', 'IDOperace', 'Autor', 'DatPorizeni',
            'Zmenil', 'DatZmeny', 'BlokovaniEditoru', 'Popis', 'Detail', ...array_keys($fields)];
        $values = ['?', '?', 'GETDATE()', '?', '?', 'SUSER_SNAME()', 'GETDATE()',
            'NULL', 'NULL', 'NULL', '?', '?', ...array_fill(0, count($fields), '?')];
        $this->db->query('INSERT INTO dbo.eTab_IntranetLog (' . implode(', ', $columns)
            . ') VALUES (' . implode(', ', $values) . ')',
            self::APP, $this->action, $result, $this->operation, $message, $json, ...array_values($fields));
    }
}
