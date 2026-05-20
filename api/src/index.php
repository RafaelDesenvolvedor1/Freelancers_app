<?php

    require_once 'config.php';

    require_once 'initTables.php';

    // Estabelecendo a conexão e criando as tabelas
    $pdo = connect();
    createTables($pdo);

    