# Projeto Codinome APScott
Projeto de controle financeiro pessoal

## Banco de Dados
Segue comandos SQLs para a criação do banco de dados utilizado pelo sistema:

```sql
CREATE TABLE categoria (
   id serial, 
   descricao character varying NOT NULL, 
   despesa_receita character varying NOT NULL, 
   CONSTRAINT pk_categoria PRIMARY KEY (id)
);

CREATE TABLE cheque (
   id serial,
   numero integer NOT NULL,
   nome character varying NOT NULL,
   valor numeric(15,2) NOT NULL,
   data date NOT NULL, 
   situacao character varying NOT NULL,
   CONSTRAINT pk_cheque PRIMARY KEY (id) 
);

CREATE TABLE receber (
   id serial, 
   descricao character varying NOT NULL, 
   data_vencimento date NOT NULL, 
   valor numeric(15,2) NOT NULL, 
   id_categoria integer NOT NULL, 
   observacao character varying, 
   CONSTRAINT pk_receber PRIMARY KEY (id), 
   CONSTRAINT fk_receber_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE recebido (
   id serial, 
   id_receber integer NOT NULL, 
   valor_recebido numeric(15,2) NOT NULL, 
   data_recebimento date NOT NULL, 
   forma_recebimento character varying NOT NULL, 
   observacao character varying, 
   CONSTRAINT pk_recebido PRIMARY KEY (id), 
   CONSTRAINT fk_recebido_receber FOREIGN KEY (id_receber) REFERENCES receber (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE pagar (
   id serial, 
   descricao character varying NOT NULL, 
   data_vencimento date NOT NULL, 
   valor numeric(15,2) NOT NULL, 
   id_categoria integer NOT NULL, 
   observacao character varying, 
   CONSTRAINT pk_pagar PRIMARY KEY (id), 
   CONSTRAINT fk_pagar_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE pago (
   id serial, 
   id_pagar integer NOT NULL, 
   valor_pago numeric(15,2) NOT NULL, 
   data_pagamento date NOT NULL, 
   forma_pagamento character varying NOT NULL, 
   observacao character varying, 
   CONSTRAINT pk_pago PRIMARY KEY (id), 
   CONSTRAINT fk_pago_pagar FOREIGN KEY (id_pagar) REFERENCES pagar (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);
```

## Heroku

Criar aplicação pela interface web - dashboard.heroku.com - e instalar o add-on Heroku Postgres::Database na aba pela Resources do dashboard.

Instalar o aplicativo de deploy via linha de comando:

```bash
add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
apt update
apt install heroku
heroku plugins:install heroku-cli-deploy
```

Criar o banco de dados via psql do heroku:

```bash
heroku login
heroku pg:psql
```

Deploy de arquivo war:

```bash
heroku login
heroku war:deploy <caminho-do-arquivo-war> --app <nome-da-aplicação-no-heroku>
```

Pela interface web, na aba resources, habilitar o Dynos criado.

Acessar a aplicação pelo endereço https://<nome-da-aplicação-no-heroku>.herokuapp.com/