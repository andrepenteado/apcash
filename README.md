# Apresentação
Projeto web de controle financeiro pessoal. Desenvolvido em java, utiliza vários sub-projetos spring [spring-boot, spring-data-jpa, spring-mvc, etc].

Você pode acessar o manual de uso pelo link https://andrepenteado.github.io/apcash

Para acessar o ambiente de testes, visitar https://apcash.herokuapp.com

## Instalação
Os requisitos necessários para a instalação da aplicação é um servidor de aplicação JEE e um banco dados relacional. Os passos a serem seguidos são:
* Baixar o projeto do github.com
* Criar o banco de dados, através do script abaixo
* Configurar a credencial de acesso ao banco de dados através do arquivo ***application-dev.properties***
* Gerar o arquivo ***war*** do projeto
* Fazer o deploy no servidor de aplicação, por exemplo o tomcat.

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

## Deploy no tomcat
A partir do momento que as credenciais de acesso ao banco de dados foram configuradas  no arquivo ***application-dev.properties***, o tomcat deve iniciar com o paramêtro a seguir:

```bash
-Dspring.profiles.active=dev
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
keroku config:set JAVA_OPTS="-Ddandelion.profile.active='prod' -Dspring.profiles.active='heroku'" --app apcash
heroku war:deploy <caminho-do-arquivo-war> --app apcash
```

Pela interface web, na aba resources, habilitar o Dynos criado.

Acessar a aplicação pelo endereço https://apcash.herokuapp.com/
