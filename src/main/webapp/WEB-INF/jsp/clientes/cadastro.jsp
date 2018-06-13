<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="actionGravar"><c:url value="/clientes/gravar"/></c:set>

<spring:eval var="labelCliente" expression="@environment.getProperty('label.cliente')"/>

<dandelion:bundle includes="jquery.validation,jquery.maskedinput,bootstrap3.datetimepicker,font-awesome5" />

<html>
<head>
  <title>Cadastro de ${labelCliente}s</title>
  <meta name="header" content="Cadastro" />
  <meta name="previouspage" content="<li><a href='<c:url value="/clientes"/>'>${labelCliente}s</a></li>" />
</head>
<body>
<script type="text/javascript">
    $(document).ready(function() {
        var formValidator = $("#cliente").validate({
            rules : {
                nome : { required : true },
                cpf : { required : true, cpf : 'both' },
                email : { email : true }
            }
        });
        $("#btn_buscar_endereco").click(function() {
            var cep = $("#cep").val();
            if (cep != "") {
                $("#buscando_endereco").show();
                $.getJSON("<%=request.isSecure() ? "https://" : "http://"%>viacep.com.br/ws/" + cep + "/json/unicode/", function(endereco) {
                    if (!("erro" in endereco)) {
                        $("#logradouro").val(endereco.logradouro);
                        $("#bairro").val(endereco.bairro);
                        $("#complemento").val("");
                        $("#cidade").val(endereco.localidade);
                        $("#estado").val(endereco.uf);
                        $("#numero").focus();
                        $("#buscando_endereco").hide();
                    }
                    else {
                        $("#numero").val("");
                        $("#logradouro").val("");
                        $("#bairro").val("");
                        $("#complemento").val("");
                        $("#cidade").val("");
                        $("#estado").val("");
                        formValidator.showErrors({"cep" : "CEP inválido"});
                        $("#cep").focus();
                        $("#buscando_endereco").hide();
                    }
                });
            }
            else {
                formValidator.showErrors({"cep" : "Campo Obrigatório"});
                $("#cep").focus();
            }
        });
        $("#nome").focus();
        $("#cpf").mask("999.999.999-99");
        $("#telefone").mask("(99) 9999-9999");
        $("#celular").mask("(99) 9 9999-9999");
        $("#dataNascimento").mask("99/99/9999");
        $("#cep").mask("99999999")
        $("#txt_data_nascimento").datetimepicker({locale: "pt-br", format: "DD/MM/YYYY"});
    });
</script>
<form:form action="${actionGravar}" modelAttribute="cliente">
  <form:hidden path="id" />
  <form:hidden path="dataCadastro" />
  <form:hidden path="dataUltimaAtualizacao" />
  <div class="panel panel-primary col-xs-12 col-md-8 col-md-offset-2">
    <div class="panel-body">
      <div class="page-header" style="margin-top: 10px;">
        <jsp:include page="/layouts/modal-mensagens.jsp"><jsp:param name="model" value="cliente"/></jsp:include>
        <h3>
          Cadastro de ${labelCliente}
          <small>
            </br>Desde: ${cliente.dataCadastroFormatada} - Última atualização: ${cliente.dataUltimaAtualizacaoFormatada}
          </small>
        </h3>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-12">
          <label for="nome" class="control-label">* Nome</label>
          <form:input path="nome" class="form-control" placeholder="Digite o nome do ${labelCliente}"/>
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-6">
          <label for="cpf" class="control-label">* CPF</label>
          <form:input path="cpf" class="form-control" placeholder="Digite o CPF do ${labelCliente}"/>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <label for="dataNascimento" class="control-label">Data de Nascimento</label>
          <div class="input-group date" id="txt_data_nascimento">
            <form:input path="dataNascimento" class="form-control" />
            <span class="input-group-addon"><span class="fas fa-calendar-alt"></span></span>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-6">
          <label for="telefone" class="control-label">Telefone</label>
          <form:input path="telefone" class="form-control" placeholder="Telefone residencial do ${labelCliente}"/>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <label for="celular" class="control-label">Celular</label>
          <div class="input-group">
            <form:input path="celular" class="form-control" placeholder="Telefone celular do ${labelCliente}"/>
            <span class="input-group-addon">
              <span class="fab fa-whatsapp fa-lg"></span>&nbsp;&nbsp;<form:checkbox path="whatsapp"/>
            </span>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-6">
          <label for="email" class="control-label">E-mail</label>
          <form:input path="email" class="form-control" placeholder="E-mail para contato do ${labelCliente}"/>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <label for="profissao" class="control-label">Profissão</label>
          <form:input path="profissao" class="form-control" placeholder="Profissão do ${labelCliente}"/>
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-10 col-md-6">
          <label for="cep" class="control-label">CEP</label>
          <div class="input-group">
            <form:input path="cep" class="form-control" />
            <span class="input-group-btn">
              <button type="button" class="btn btn-default" id="btn_buscar_endereco" name="btn_buscar_endereco">
                <span class="fas fa-search"></span> Buscar
              </button>
            </span>
          </div>
        </div>
        <div id="buscando_endereco" style="display: none; margin-top: 27px; margin-left: -14px;"><span class="fas fa-spinner fa-pulse fa-fw fa-lg"></span></div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-9">
          <label for="logradouro" class="control-label">Logradouro</label>
          <form:input path="logradouro" placeholder="Descrição do logradouro" class="form-control" />
        </div>
        <div class="form-group col-xs-6 col-md-3">
          <label for="numero" class="control-label">Número</label>
          <form:input path="numero" placeholder="Número do local" class="form-control" />
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-6">
          <label for="bairro" class="control-label">Bairro</label>
          <form:input path="bairro" placeholder="Bairro" class="form-control" />
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <label for="complemento" class="control-label">Complemento</label>
          <form:input path="complemento" placeholder="Complemento do endereço" class="form-control" />
        </div>
      </div>
      <div class="row">
        <div class="form-group col-xs-12 col-md-6">
          <label for="cidade" class="control-label">Cidade</label>
          <form:input path="cidade" placeholder="Cidade" class="form-control" />
        </div>
        <div class="form-group col-xs-4 col-md-3">
          <label for="estado" class="control-label">Estado</label>
          <form:input path="estado" placeholder="Estado" class="form-control" />
        </div>
      </div>
    </div>
    <div class="form-group col-x-12 col-md-12" style="text-align: center; margin-top: 25px;">
      <button type="submit" class="btn btn-primary"><span class="fas fa-save"></span> Gravar</button>
    </div>
  </div>
</form:form>
</body>
</html>