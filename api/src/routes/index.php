<?php

require_once __DIR__ . '/../controllers/ResourceController.php';

$resources = [
    'clientes' => [
        'table' => 'clientes',
        'id' => 'id_cliente',
        'fields' => ['nome', 'telefone', 'email'],
        'required' => ['nome']
    ],
    'freelancers' => [
        'table' => 'freelancers',
        'id' => 'id_freelancer',
        'fields' => ['nome', 'telefone', 'email'],
        'required' => ['nome']
    ],
    'projetos' => [
        'table' => 'projetos',
        'id' => 'id_projeto',
        'fields' => ['nome', 'descricao', 'status', 'id_cliente', 'id_freelancer'],
        'required' => ['nome']
    ],
    'pagamentos' => [
        'table' => 'pagamentos',
        'id' => 'id_pagamento',
        'fields' => ['nome', 'descricao', 'status', 'id_projeto'],
        'required' => ['nome']
    ],
    'avaliacoes' => [
        'table' => 'avaliacoes',
        'id' => 'id_avaliacao',
        'fields' => ['nome', 'descricao', 'status', 'id_cliente'],
        'required' => ['nome']
    ]
];

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$scriptPath = dirname($_SERVER['SCRIPT_NAME']);
if ($scriptPath !== '/' && strpos($path, $scriptPath) === 0) {
    $path = substr($path, strlen($scriptPath));
}
$path = trim($path, '/');
$segments = $path === '' ? [] : explode('/', $path);

$resource = $segments[0] ?? null;
$id = $segments[1] ?? null;

$controller = new ResourceController($pdo, $resources);
$controller->dispatch($resource, $id, $_SERVER['REQUEST_METHOD']);
