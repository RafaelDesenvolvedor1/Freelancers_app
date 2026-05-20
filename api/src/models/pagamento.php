<?php 

require_once __DIR__ . '/../interfaces/ModelInterface.php';

class Pagamento implements ModelInterface {

    public static function getCreateTableSQL(): string {
        return "
            CREATE TABLE IF NOT EXISTS pagamentos (
                id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                descricao TEXT,
                status VARCHAR(30),
                id_projeto INT,
                FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ";
    }
}

