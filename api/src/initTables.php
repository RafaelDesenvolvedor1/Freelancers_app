<?php 

    function createTables($pdo) {
        try {
            $models = [
                'cliente',
                'freelancer',
                'projeto',
                'pagamento',
                'avaliacao'
            ];

            foreach ($models as $model) {
                require_once __DIR__ . "/models/{$model}.php";
                $sql = $model::getCreateTableSQL();
                $pdo->exec($sql);
            }
        } catch (PDOException $e) {
            echo json_encode(["status" => "erro", "mensagem" => "Erro ao criar tabelas: " . $e->getMessage()]);
            die;
        }

    }