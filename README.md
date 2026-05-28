# � Freelancers App

Plataforma mobile para conectar **clientes** e **freelancers**, com gestão completa de projetos, pagamentos e avaliações.

Desenvolvido com **Flutter** no front-end e **PHP** no back-end, com banco de dados **MySQL** e infraestrutura via **Docker**.

> � O app Flutter roda dentro de um **Dev Container** — não é necessário ter o Flutter instalado nativamente na sua máquina.

---

## � Tecnologias Utilizadas

| Camada       | Tecnologia          |
|--------------|---------------------|
| Mobile       | Flutter (Web)       |
| API          | PHP                 |
| Banco de dados | MySQL 8.0         |
| Infraestrutura | Docker + Docker Compose |
| Ambiente de dev | Dev Container (VS Code) |
| Admin DB     | Adminer             |

---

## � Como Executar

### Pré-requisitos

- [Docker](https://www.docker.com/) instalado
- [Docker Compose](https://docs.docker.com/compose/) instalado
- [VS Code](https://code.visualstudio.com/) com a extensão [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) instalada

> Flutter **não precisa** estar instalado na máquina — o ambiente de desenvolvimento roda inteiramente dentro do container.

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/Freelancers_app.git
cd Freelancers_app
```

### 2. Subir a API e o banco de dados

```bash
docker-compose up -d
```

Os seguintes serviços sobem automaticamente:

| Serviço    | URL                        |
|------------|----------------------------|
| API (PHP)  | http://localhost:8000      |
| Adminer    | http://localhost:8080      |
| MySQL      | localhost:3306             |

> As tabelas são criadas automaticamente na inicialização da API.

### 3. Rodar o app Flutter via Dev Container

O projeto utiliza um **Dev Container** com Flutter SDK já configurado, dispensando instalação local.

**Passo a passo:**

1. Abra a pasta do projeto no VS Code
2. Quando aparecer o prompt *"Reopen in Container"*, clique nele — ou use o comando `Dev Containers: Reopen in Container` pela paleta (`Ctrl+Shift+P`)
3. Aguarde o container ser construído (apenas na primeira vez — o Flutter SDK é baixado automaticamente)
4. Ao finalizar, o `flutter pub get` roda automaticamente via `postCreateCommand`
5. No terminal integrado do VS Code (já dentro do container), execute:

```bash
cd freelancers_app
flutter run -d web-server --web-port=8085 --web-hostname=0.0.0.0
```

6. O app estará disponível em **http://localhost:8085** — o VS Code abrirá o navegador automaticamente

**Como funciona:**

- O Dev Container sobe na mesma rede Docker da API (`plataformafreelancers_app-network`), então o app consegue se comunicar com o back-end normalmente
- A porta `8085` é exposta e mapeada pelo `devcontainer.json`
- O usuário dentro do container é `developer` (sem privilégios de root)

---

## � API — Rotas Disponíveis

Base URL: `http://localhost:8000`

Todos os endpoints seguem o padrão REST com `Content-Type: application/json`.

### Recursos

| Recurso        | Endpoints disponíveis                         |
|----------------|-----------------------------------------------|
| `clientes`     | GET, GET /{id}, POST, PUT /{id}, DELETE /{id} |
| `freelancers`  | GET, GET /{id}, POST, PUT /{id}, DELETE /{id} |
| `projetos`     | GET, GET /{id}, POST, PUT /{id}, DELETE /{id} |
| `pagamentos`   | GET, GET /{id}, POST, PUT /{id}, DELETE /{id} |
| `avaliacoes`   | GET, GET /{id}, POST, PUT /{id}, DELETE /{id} |

### Exemplos de uso

**Criar um cliente:**
```http
POST http://localhost:8000/clientes
Content-Type: application/json

{
  "nome": "João Silva",
  "telefone": "(11) 99999-9999",
  "email": "joao@example.com"
}
```

**Listar todos os projetos:**
```http
GET http://localhost:8000/projetos
```

**Atualizar um pagamento:**
```http
PUT http://localhost:8000/pagamentos/3
Content-Type: application/json

{
  "status": "pago",
  "descricao": "Pagamento finalizado"
}
```

**Excluir uma avaliação:**
```http
DELETE http://localhost:8000/avaliacoes/5
```

Para a documentação completa de campos e rotas, consulte o arquivo [`ROUTES.md`](./ROUTES.md).

---

## � Telas do Aplicativo

| Tela                  | Descrição                                           |
|-----------------------|-----------------------------------------------------|
| Descobrir Freelancers | Listagem e busca de freelancers cadastrados         |
| Detalhes do Freelancer | Perfil completo com e-mail e telefone              |
| Meus Projetos         | Lista de projetos com status e filtros              |
| Novo Projeto          | Formulário de criação de projeto                    |
| Pagamentos            | Histórico de pagamentos por etapa do projeto        |
| Avaliações            | Avaliações recebidas com status de aprovação        |

---

## �️ Banco de Dados

- **SGBD:** MySQL 8.0
- **Database:** `facul_db`
- **Usuário:** `flutter_user`
- **Senha:** `flutter_password`

Acesse o Adminer em [http://localhost:8080](http://localhost:8080) para inspecionar o banco diretamente no navegador.

---

## � Variáveis de Ambiente (API)

Configuradas no `docker-compose.yml`:

```env
DB_HOST=db
DB_NAME=facul_db
DB_USER=flutter_user
DB_PASSWORD=flutter_password
```

---

## � Licença

Este projeto foi desenvolvido para fins acadêmicos.