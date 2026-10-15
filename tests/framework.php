<?php
require __DIR__ . '/../vendor/autoload.php';

$root = dirname(__DIR__);
$configurator = new Nette\Bootstrap\Configurator;
$configurator->setDebugMode(false);
$configurator->addStaticParameters(['appDir' => $root . '/app', 'wwwDir' => $root . '/www']);
$configurator->setTempDirectory(sys_get_temp_dir() . '/sklad-tests-' . bin2hex(random_bytes(5)));
$configurator->createRobotLoader()->addDirectory($root . '/app')->register();
$configurator->addConfig($root . '/config/common.neon');
$configurator->addConfig($root . '/config/services.neon');
// Compile DI without connecting to the customer's SQL Server.
$configurator->addConfig(['database' => ['dsn' => 'sqlite::memory:']]);
$container = $configurator->createContainer();
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
foreach (['Sign', 'Homepage', 'Material', 'DeliveryNote', 'Production'] as $name) {
    $presenter = $factory->createPresenter($name);
    echo "PASS: presenter $name\n";
}
$latte = $presenter->getTemplate()->getLatte();
$count = 0;
$errors = 0;
$files = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($root . '/app/presenters/templates'));
foreach ($files as $file) {
    if ($file->isFile() && $file->getExtension() === 'latte') {
        try { $latte->compile($file->getPathname()); }
        catch (Latte\CompileException $e) { echo 'FAIL: ' . $file->getPathname() . ': ' . $e->getMessage() . PHP_EOL; $errors++; }
        $count++;
    }
}
echo ($errors ? "Checked: " : "PASS: ") . "$count Latte templates\n";

if ($errors) { exit(1); }
