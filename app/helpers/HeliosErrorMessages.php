<?php

declare(strict_types=1);

namespace App\Helpers;

use Nette\Database\DriverException;
use Nette\Database\Explorer;

final class HeliosErrorMessages
{
    public function __construct(private readonly Explorer $db) {}

    /** Call only AFTER the failed business transaction has been rolled back. */
    public function translate(DriverException $error): ?HeliosException
    {
        $payload = $error->getMessage();
        // PDO prefixes are diagnostic metadata, not the Helios message number.
        if (preg_match('/\[SQL Server\](.*)/s', $payload, $match)) {
            $payload = trim($match[1]);
        }
        $numbers = [];
        $arguments = [];
        // Helios also raises generic SQL error 50000 with "Cislo|parameters" as text.
        if (preg_match('/^\s*([1-9][0-9]{0,9})\s*\|(.*)$/sD', $payload, $match)) {
            $number = filter_var($match[1], FILTER_VALIDATE_INT, ['options' => ['min_range' => 1, 'max_range' => 2147483647]]);
            if ($number !== false) {
                $numbers[] = $number;
                $arguments = array_map('trim', explode('|', $match[2]));
            }
        }
        $driverCode = filter_var($error->getDriverCode(), FILTER_VALIDATE_INT,
            ['options' => ['min_range' => 1, 'max_range' => 2147483647]]);
        if ($driverCode !== false) $numbers[] = $driverCode;
        foreach (array_unique($numbers) as $number) {
            try {
                $template = $this->db->query('SELECT Hlaska FROM dbo.TabInterniHlasky WHERE Cislo = ?', $number)->fetchField();
            } catch (DriverException $lookupError) {
                \Tracy\Debugger::log($lookupError, \Tracy\Debugger::EXCEPTION);
                return null;
            }
            if (!is_string($template) || trim($template) === '') continue;
            // Do not guess parameters from arbitrary SQL diagnostic text.
            $index = 0;
            $text = preg_replace_callback('/%%|%s/', static function ($match) use ($arguments, &$index) {
                if ($match[0] === '%%') return '%';
                return $arguments[$index++] ?? (count($arguments) === 1 ? $arguments[0] : '%s');
            }, trim($template));
            // Unknown formatting cannot be rendered faithfully; keep the safe generic fallback.
            if (preg_match('/%(?:[-+0-9.*]*)(?:s|d|i|u|f|ls)/', $text)) continue;
            return new HeliosException($text, $number, $error);
        }
        return null;
    }
}
