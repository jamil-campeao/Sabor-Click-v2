# Sabor & Clic
**Sistema de Gestão para Dark Kitchens e Espaços Gastronômicos**

Projeto Integrador — 2026  
Instituto Federal de Educação, Ciência e Tecnologia de São Paulo — Campus São Paulo

## 1. Sobre o projeto

O Sabor & Clic é um sistema web desenvolvido para auxiliar na gestão de espaços gastronômicos e dark kitchens. O sistema permite o gerenciamento de pratos, pedidos, usuários, reservas e estoque.

O projeto utiliza:
- **Frontend:** HTML5, CSS3 e JavaScript.
- **Backend:** Python com Flask.
- **Banco de dados:** MySQL.
- **Comunicação:** Fetch API e JSON.

## 2. Organização dos arquivos

Todos os arquivos do projeto ficam na pasta principal do repositório.

Estrutura simplificada:

```text
Pasta principal/
├── run.py
├── requirements.txt
├── README.md
├── .env.example
├── CONFIGURACAO_MYSQL.txt
├── configurar_senhas_demo.py
├── database/
│   └── sabor_clic_banco.sql
└── app/
    ├── controllers/
    ├── models/
    ├── static/
    │   ├── css/
    │   └── js/
    └── views/
```

## 3. Requisitos para execução

Antes de iniciar, instale:
- Python 3;
- MySQL Server;
- Um navegador atualizado.

## 4. Instalação das dependências

Abra o terminal na **pasta principal** do projeto.

Crie e ative o ambiente virtual:

```bash
python -m venv .venv
.venv\Scripts\activate
```

Instale as dependências:

```bash
python -m pip install -r requirements.txt
```

## 5. Configuração do banco de dados

1. Inicie o serviço do MySQL.
2. Abra o MySQL Workbench ou o DBeaver e conecte em `localhost`, porta `3306`.
3. Crie o banco de dados (o script SQL cria apenas as tabelas, não o banco):

```sql
CREATE DATABASE sabor_clic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

4. Selecione o banco `sabor_clic` e abra o arquivo `database/sabor_clic_banco.sql`.
5. Execute o script inteiro para criar as tabelas e inserir os dados iniciais (no DBeaver, use **Alt+X**).

Consulte o arquivo `CONFIGURACAO_MYSQL.txt`, localizado na raiz do projeto, para orientações adicionais.

## 6. Configuração do arquivo .env

Copie o arquivo `.env.example` e renomeie a cópia para `.env`.

Configure as variáveis de ambiente com os dados do seu computador:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=SUA_SENHA_DO_MYSQL
DB_NAME=sabor_clic
SECRET_KEY=SUA_CHAVE_SECRETA
FERNET_KEY=CHAVE_FERNET_FORNECIDA_PELA_EQUIPE
```

**Atenção:** a chave `FERNET_KEY` precisa ser a mesma utilizada pela equipe para criptografar os endereços armazenados no banco de dados. Ela deve ser compartilhada separadamente e com segurança. Não utilize uma chave aleatória diferente.

O arquivo `.env` contém informações confidenciais e não deve ser compartilhado publicamente.

## 7. Execução do sistema

Após instalar as dependências e configurar o banco de dados e o arquivo `.env`:

1. Execute a aplicação:

```bash
python run.py
```

2. Com o servidor iniciado, acesse no navegador:

```text
http://127.0.0.1:5000/
```

O MySQL precisa permanecer em execução durante o uso do sistema.

## 8. Execução com Docker (servidor)

Com Docker, o sistema e o MySQL sobem juntos em containers. Não é preciso instalar Python nem MySQL no servidor, nem importar o banco manualmente.

1. Instale o Docker no servidor.
2. Crie o arquivo `.env` a partir do `.env.example` e preencha também a variável `MYSQL_ROOT_PASSWORD`.
3. Na pasta `Projeto-Sabor-Click-main`, onde fica o `docker-compose.yml`, suba os containers:

```bash
docker compose up -d --build
```

4. Acesse `http://IP_DO_SERVIDOR:8000/`. Para usar outra porta, defina `APP_PORT` no `.env`.

Como funciona:

- Na primeira subida, o MySQL cria o banco `sabor_clic` e executa o `database/sabor_clic_banco.sql` automaticamente.
- O sistema se conecta ao banco com o usuário `sabor_app` e a senha definida em `DB_PASSWORD`. Os valores de `DB_HOST` e `DB_USER` do `.env` são ignorados no Docker.
- Os dados ficam no volume `dados_mysql` e não se perdem ao reiniciar ou atualizar os containers.
- O script do banco só roda quando o volume está vazio. Para recriar o banco do zero, use `docker compose down -v` (isso apaga todos os dados).

Para atualizar o sistema depois de um `git pull`, execute novamente `docker compose up -d --build`.

Em produção, coloque um proxy com HTTPS (como o Caddy) na frente da porta 8000, defina `COOKIE_SECURE=true` no `.env` e não exponha a porta 3306 do MySQL.

### Acessar o banco do Docker pelo DBeaver (apenas testes locais)

O MySQL do Docker não fica acessível fora dos containers. Para conectar pelo DBeaver no seu computador, crie um arquivo `docker-compose.override.yml` na mesma pasta do `docker-compose.yml`:

```yaml
services:
  db:
    ports:
      - "127.0.0.1:3307:3306"
```

Depois execute `docker compose up -d` e conecte no DBeaver em `localhost`, porta `3307`, banco `sabor_clic`, usuário `sabor_app` (senha do `DB_PASSWORD`) ou `root` (senha do `MYSQL_ROOT_PASSWORD`).

Esse arquivo está no `.gitignore` e não deve ser criado no servidor, para o banco continuar protegido.

## 9. Observações

- O ambiente virtual `.venv` é criado localmente e não precisa ser enviado na entrega.
- O arquivo `.env` deve ser configurado individualmente em cada computador.
- O arquivo `.env.example` serve como modelo de configuração.
- O banco de dados deve ser importado antes de iniciar a aplicação.
