<?php

require_once 'config.php';
require_once 'initTables.php';

$pdo = connect();
createTables($pdo);

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/routes/index.php';

    