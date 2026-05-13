<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->group('api', ['namespace' => 'App\Controllers\Api'], static function ($routes) {
    $routes->get('health', 'Health::index');
    $routes->get('health/', 'Health::index');

    $routes->post('auth/register', 'Register::create');
    $routes->post('auth/register/', 'Register::create');

    $routes->post('auth/token', 'Auth::token');
    $routes->post('auth/token/', 'Auth::token');

    $routes->post('auth/token/refresh', 'Auth::refresh');
    $routes->post('auth/token/refresh/', 'Auth::refresh');

    $routes->get('me', 'Me::index', ['filter' => 'jwtauth']);
    $routes->get('me/', 'Me::index', ['filter' => 'jwtauth']);
});
