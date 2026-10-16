<?php
require_once __DIR__ . '/../vendor/autoload.php';

function createTestContainer(): Nette\DI\Container
{
    $root = dirname(__DIR__);
    $configurator = new Nette\Bootstrap\Configurator;
    $configurator->setDebugMode(false);
    $configurator->addStaticParameters(['appDir' => $root . '/app', 'wwwDir' => $root . '/www']);
    $configurator->setTempDirectory(sys_get_temp_dir() . '/sklad-tests-' . bin2hex(random_bytes(5)));
    $configurator->addConfig($root . '/config/common.neon');
    $configurator->addConfig($root . '/config/services.neon');
    $configurator->addConfig(['database' => ['dsn' => 'sqlite::memory:']]);
    return $configurator->createContainer();
}
