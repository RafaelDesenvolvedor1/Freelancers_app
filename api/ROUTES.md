# API de Rotas - Plataforma Freelancers

Base URL: `http://localhost:8000`

A API disponibiliza rotas CRUD para os seguintes recursos:
- `clientes`
- `freelancers`
- `projetos`
- `pagamentos`
- `avaliacoes`

## Formato de requisição

- Cabeçalho: `Content-Type: application/json`
- Corpo: JSON para `POST` e `PUT`

## Recursos e rotas

### Clientes
- `GET /clientes` - listar todos os clientes
- `GET /clientes/{id}` - obter cliente por ID
- `POST /clientes` - criar cliente
- `PUT /clientes/{id}` - atualizar cliente
- `DELETE /clientes/{id}` - excluir cliente

Campos para `POST` / `PUT`:
- `nome` (obrigatório)
- `telefone`
- `email`

### Freelancers
- `GET /freelancers`
- `GET /freelancers/{id}`
- `POST /freelancers`
- `PUT /freelancers/{id}`
- `DELETE /freelancers/{id}`

Campos para `POST` / `PUT`:
- `nome` (obrigatório)
- `telefone`
- `email`

### Projetos
- `GET /projetos`
- `GET /projetos/{id}`
- `POST /projetos`
- `PUT /projetos/{id}`
- `DELETE /projetos/{id}`

Campos para `POST` / `PUT`:
- `nome` (obrigatório)
- `descricao`
- `status`
- `id_cliente`
- `id_freelancer`

### Pagamentos
- `GET /pagamentos`
- `GET /pagamentos/{id}`
- `POST /pagamentos`
- `PUT /pagamentos/{id}`
- `DELETE /pagamentos/{id}`

Campos para `POST` / `PUT`:
- `nome` (obrigatório)
- `descricao`
- `status`
- `id_projeto`

### Avaliações
- `GET /avaliacoes`
- `GET /avaliacoes/{id}`
- `POST /avaliacoes`
- `PUT /avaliacoes/{id}`
- `DELETE /avaliacoes/{id}`

Campos para `POST` / `PUT`:
- `nome` (obrigatório)
- `descricao`
- `status`
- `id_cliente`

## Exemplos de uso

### Criar um cliente

POST `http://localhost:8000/clientes`

```json
{
  "nome": "João Silva",
  "telefone": "(11) 99999-9999",
  "email": "joao@example.com"
}
```

### Listar todos os projetos

GET `http://localhost:8000/projetos`

### Atualizar um pagamento

PUT `http://localhost:8000/pagamentos/3`

```json
{
  "status": "pago",
  "descricao": "Pagamento finalizado"
}
```

### Excluir uma avaliação

DELETE `http://localhost:8000/avaliacoes/5`

## Observações

- As tabelas são criadas automaticamente na inicialização da API.
- O serviço da API está configurado em `docker-compose.yml` na porta `8000`.
- O Adminer está disponível em `http://localhost:8080` para inspeção do banco de dados.
