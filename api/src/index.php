<?php
// ADICIONE ESSAS TRÊS LINHAS NO TOPO DO SEU INDEX.PHP:
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

header("Content-Type: application/json");

$host = getenv('DB_HOST') ?: 'db';
// ... resto do seu código igual
header("Content-Type: application/json");

$host = getenv('DB_HOST') ?: 'db';
$dbname = getenv('DB_NAME') ?: 'facul_db';
$user = getenv('DB_USER') ?: 'flutter_user';
$password = getenv('DB_PASSWORD') ?: 'flutter_password';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);    
    
    echo json_stream(["status" => "sucesso", "mensagem" => "Conectado ao MySQL com sucesso via Docker!"]);
} catch (PDOException $e) {
    echo json_encode(["status" => "erro", "mensagem" => "Falha na conexão: " . $e->getMessage()]);
}

function json_stream($array) { return json_encode($array, JSON_UNESCAPED_UNICODE); }