<?php

declare(strict_types=1);

namespace App\Helpers;

use App\Models\DeviceModel;
use Nette\Database\Row;
use Nette\Http\IRequest;
use Nette\Http\IResponse;

final class DeviceIdentity
{
    public const COOKIE = 'intranet_device';

    public function __construct(
        private readonly DeviceModel $model,
        private readonly IRequest $request,
        private readonly IResponse $response,
    ) {
    }

    public function getDevice(): ?Row
    {
        $token = $this->request->getCookie(self::COOKIE);
        if (!is_string($token)) {
            return null;
        }
        try {
            $device = $this->model->findByToken($token);
            if ($device) {
                $this->model->touch($token);
            }
            return $device;
        } catch (\Nette\Database\DriverException $e) {
            // Device identification must not interrupt warehouse work if its table is unavailable.
            \Tracy\Debugger::log($e, \Tracy\Debugger::EXCEPTION);
            return null;
        }
    }

    public function register(int $id, bool $replace): void
    {
        $token = $this->model->register($id, $replace);
        $this->response->setCookie(self::COOKIE, $token, '180 days',
            $this->request->getUrl()->getBasePath(), null, $this->request->isSecured(), true, 'Lax');
    }
}
