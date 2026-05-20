<?php 

require_once __DIR__ . '/../interfaces/ModelInterface.php';

class Freelancer implements ModelInterface {

    public static function getCreateTableSQL(): string {
        return "
            CREATE TABLE IF NOT EXISTS freelancers (
               id_freelancer	INT	PRIMARY KEY AUTO_INCREMENT,
               nome	VARCHAR(100)	NOT NULL,
               telefone	VARCHAR(20),	
               email	VARCHAR(100)	
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ";
    }
}

