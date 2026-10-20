<?php
require __DIR__ . '/bootstrap.php';

$root = dirname(__DIR__);
$container = createTestContainer();
$factory = $container->getByType(Nette\Application\IPresenterFactory::class);
foreach (['Sign', 'Homepage', 'Material', 'LoukovReceipt', 'DeliveryNote', 'Production'] as $name) {
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
