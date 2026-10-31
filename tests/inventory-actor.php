<?php
require __DIR__ . '/bootstrap.php';
ini_set('session.save_path', sys_get_temp_dir());
if (function_exists('mb_substr') || function_exists('mb_strlen')) {
    throw new RuntimeException('Run this regression with mb_substr and mb_strlen disabled.');
}
$container = createTestContainer();
$user = $container->getByType(Nette\Security\User::class);
$user->login(new Nette\Security\SimpleIdentity(123, ['inventura']));
$presenter = $container->getByType(Nette\Application\IPresenterFactory::class)->createPresenter('Inventory');
// Exercise the production actor independently of unrelated Tracy error rendering.
$actor = new ReflectionMethod(App\Presenters\InventoryPresenter::class, 'actor');
if ($actor->invoke($presenter) !== '123') {
    throw new RuntimeException('Inventory actor must preserve the employee ID without mbstring.');
}
echo "PASS: inventory actor works without mb_substr or mb_strlen\n";
