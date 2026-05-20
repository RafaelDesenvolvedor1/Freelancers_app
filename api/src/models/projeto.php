<?php 

require_once __DIR__ . '/../interfaces/ModelInterface.php';

class Projeto implements ModelInterface {

    public static function getCreateTableSQL(): string {
        return "
            CREATE TABLE IF NOT EXISTS projetos (
                id_projeto INT AUTO_INCREMENT PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                descricao TEXT,
                status VARCHAR(30),
                id_cliente INT,
                id_freelancer INT,
                FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
                FOREIGN KEY (id_freelancer) REFERENCES freelancers(id_freelancer) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ";
    }
}

