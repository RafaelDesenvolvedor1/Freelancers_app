<?php 

require_once __DIR__ . '/../interfaces/ModelInterface.php';

class Avaliacao implements ModelInterface {

    public static function getCreateTableSQL(): string {
        return "
        CREATE TABLE IF NOT EXISTS avaliacoes (
            id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            descricao TEXT,
            status VARCHAR(30),
            id_cliente INT,
            FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    }
}

