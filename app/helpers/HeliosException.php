<?php

declare(strict_types=1);

namespace App\Helpers;

/** A known Helios business rejection, safe to show to the operator. */
final class HeliosException extends \RuntimeException
{
    public function __construct(string $message, public readonly int $messageNumber, \Throwable $previous)
    {
        parent::__construct($message, $messageNumber, $previous);
    }
}
