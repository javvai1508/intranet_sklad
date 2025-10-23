<?php

declare(strict_types=1);

namespace App\Router;

use Nette;
use Nette\Application\Routers\RouteList;


final class RouterFactory
{
	use Nette\StaticClass;

	public static function createRouter(): RouteList
	{
		$router = new RouteList;
		$router->addRoute('<presenter>/<action>[/<id>]', 'Homepage:default');
		return $router;
	}
}

/*namespace App;

use Nette;
use Nette\Application\Routers\Route;
use Nette\Application\Routers\RouteList;


class RouterFactory
{
	use Nette\StaticClass;

	public static function createRouter()
	{
		$router = new RouteList;
		$router[] = new Route('<presenter>/<action>[/<id>]', 'Homepage:default'); 
		return $router;
	}
}
*/