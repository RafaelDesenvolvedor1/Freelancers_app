<?php

class ResourceController {
    private PDO $pdo;
    private array $resources;

    public function __construct(PDO $pdo, array $resources) {
        $this->pdo = $pdo;
        $this->resources = $resources;
    }

    public function dispatch(?string $resource, ?string $id, string $method): void {
        if (!$resource) {
            $this->sendJson([
                'status' => 'ok',
                'mensagem' => 'API de CRUD ativa. Use rotas: ' . implode(', ', array_keys($this->resources)) . '.',
                'endpoints' => array_keys($this->resources)
            ]);
        }

        if (!array_key_exists($resource, $this->resources)) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Recurso não encontrado.'], 404);
        }

        $config = $this->resources[$resource];

        switch ($method) {
            case 'GET':
                $this->handleGet($config, $id);
                break;
            case 'POST':
                $this->handlePost($config);
                break;
            case 'PUT':
                $this->handlePut($config, $id);
                break;
            case 'DELETE':
                $this->handleDelete($config, $id);
                break;
            default:
                $this->sendJson(['status' => 'erro', 'mensagem' => 'Método não suportado.'], 405);
                break;
        }
    }

    private function handleGet(array $config, ?string $id): void {
        if (!$id) {
            $stmt = $this->pdo->query('SELECT * FROM ' . $config['table']);
            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $this->sendJson(['status' => 'ok', 'data' => $result]);
        }

        $id = $this->sanitizeId($id);
        if (!$id) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'ID inválido.'], 400);
        }

        $stmt = $this->pdo->prepare('SELECT * FROM ' . $config['table'] . ' WHERE ' . $config['id'] . ' = ?');
        $stmt->execute([$id]);
        $item = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$item) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Registro não encontrado.'], 404);
        }

        $this->sendJson(['status' => 'ok', 'data' => $item]);
    }

    private function handlePost(array $config): void {
        $body = $this->getRequestBody();
        $missing = $this->validateRequiredFields($body, $config['required']);
        if ($missing) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Campos obrigatórios ausentes: ' . implode(', ', $missing)], 400);
        }

        $fields = [];
        $placeholders = [];
        $values = [];

        foreach ($config['fields'] as $field) {
            if (array_key_exists($field, $body)) {
                $fields[] = $field;
                $placeholders[] = '?';
                $values[] = $body[$field];
            }
        }

        if (empty($fields)) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Nenhum campo válido enviado.'], 400);
        }

        $sql = sprintf(
            'INSERT INTO %s (%s) VALUES (%s)',
            $config['table'],
            implode(', ', $fields),
            implode(', ', $placeholders)
        );

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($values);

        $this->sendJson([
            'status' => 'ok',
            'mensagem' => 'Registro criado com sucesso.',
            'id' => $this->pdo->lastInsertId()
        ], 201);
    }

    private function handlePut(array $config, ?string $id): void {
        if (!$id) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'ID de recurso obrigatório para atualização.'], 400);
        }

        $id = $this->sanitizeId($id);
        if (!$id) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'ID inválido.'], 400);
        }

        $body = $this->getRequestBody();
        $updates = [];
        $values = [];

        foreach ($config['fields'] as $field) {
            if (array_key_exists($field, $body)) {
                $updates[] = "$field = ?";
                $values[] = $body[$field];
            }
        }

        if (empty($updates)) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Nenhum campo válido para atualizar.'], 400);
        }

        $values[] = $id;

        $sql = sprintf(
            'UPDATE %s SET %s WHERE %s = ?',
            $config['table'],
            implode(', ', $updates),
            $config['id']
        );

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($values);

        if ($stmt->rowCount() === 0) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Registro não encontrado ou sem alterações.'], 404);
        }

        $this->sendJson(['status' => 'ok', 'mensagem' => 'Registro atualizado com sucesso.']);
    }

    private function handleDelete(array $config, ?string $id): void {
        if (!$id) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'ID de recurso obrigatório para exclusão.'], 400);
        }

        $id = $this->sanitizeId($id);
        if (!$id) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'ID inválido.'], 400);
        }

        $stmt = $this->pdo->prepare('DELETE FROM ' . $config['table'] . ' WHERE ' . $config['id'] . ' = ?');
        $stmt->execute([$id]);

        if ($stmt->rowCount() === 0) {
            $this->sendJson(['status' => 'erro', 'mensagem' => 'Registro não encontrado.'], 404);
        }

        $this->sendJson(['status' => 'ok', 'mensagem' => 'Registro excluído com sucesso.']);
    }

    private function getRequestBody(): array {
        $raw = file_get_contents('php://input');
        if (empty($raw)) {
            return [];
        }
        $data = json_decode($raw, true);
        return is_array($data) ? $data : [];
    }

    private function validateRequiredFields(array $body, array $required): array {
        $missing = [];
        foreach ($required as $field) {
            if (!array_key_exists($field, $body) || $body[$field] === '') {
                $missing[] = $field;
            }
        }
        return $missing;
    }

    private function sanitizeId($value): ?int {
        if (!is_numeric($value) || intval($value) <= 0) {
            return null;
        }
        return intval($value);
    }

    private function sendJson(array $payload, int $statusCode = 200): void {
        http_response_code($statusCode);
        echo json_encode($payload, JSON_UNESCAPED_UNICODE);
        exit;
    }
}
