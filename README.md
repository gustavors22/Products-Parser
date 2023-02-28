# Product Parser

O projeto consiste em uma REST API utilizando os dados do Open Food Facts

## Endpoints

 - `GET api/`: Detalhes da API, se conexão leitura e escritura com a base de dados está OK, horário da última vez que o CRON foi executado, tempo online e uso de memória.
 - `PUT api/products/:code`: Atualiza um produto
 - `DELETE api/products/:code`: Muda o status do produto para `trash`
 - `GET api/products/:code`: Obtém a informação somente de um produto da base de dados
 - `GET api/products`: Lista todos os produtos da base de dados

# Tecnologias
- Laravel e Php
- Mysql
- Bash Script
# Como rodar o projeto

## Clonando o Projeto

Execute os comandos no seu terminal

```bash
git clone https://github.com/gustavors22/Products-Parser.git
```

```bash
cd Product-Parser
```

## Configurando e Executando a api

Na raiz do projeto uma pasta chamada product_parser_api. Entre nela e execute os seguintes passos:

```
cd product_parser_api
```

1. instalando dependências:

```bash
composer install
```

2. Abra a pasta "product_parser_api" com seu editor de código.

3. Crie um arquivo ".env" e cole o conteúdo do arquivo ".env.example" dentro.

4. Crie um banco de dados mysql.

5. Coloque as informações do seu banco de dados nos seus respectivos campos no arquivo ".env"

```
DB_CONNECTION=mysql // SGBD
DB_HOST=127.0.0.1 // IP do seu SGBD
DB_PORT=3306 // porta que seu banco está rodando
DB_DATABASE=products // nome do banco dados criado
DB_USERNAME=root // usuário de conexão do banco
DB_PASSWORD=root // senha de conexão do banco (caso não tenha senha deixe em branco)
```

6. Execute o seguinte comando para executar a migrations

```bash
php artisan migrate
```

7. Execute o seguinte comando para popular o banco com alguns dados

```
php artisan db:seed
```

8. Execute o comando para finalmente ter a api rodando

```
php artisan serve
```
## Executando Cron para população do banco de dados

1. Entre na pasta scripts localizado na raiz do projeto.

``` 
cd scripts/
```

2. Adicione as informações do seu banco de dados na primeira parte do database_insertion_script.sh como mostrado abaixo.

```bash
# Define database credentials
DB_USER="root"
DB_PASSWORD="root"
DB_HOST="127.0.0.1"
DB_NAME="products_db"
TABLE_NAME="products"
```

3. Execute o seguinte comando para dar a permissão de execução para o arquivo database_insertion_script.sh.

```bash
chmod +x ./database_insertion_script.sh
````

4. Caso queira que o script seja executado apenas uma vez, basta executar o seguinte comando.

```bash
./database_insertion_script.sh
```
5. Caso queira que o script execute todos os dias as 3 horas da manhã, execute o comando abaixo.

```bash
crontab -e
```

6. Se você nunca definiu uma tarefa cron antes, o sistema pode pedir para escolher o editor de texto padrão. Escolha o editor de sua preferência e prossiga. No final do arquivo, adicione a seguinte linha:

```cron
0 3 * * * /caminho/para/scripts/database_insertion_script.sh
```


>  This is a challenge by [Coodesh](https://coodesh.com/)
