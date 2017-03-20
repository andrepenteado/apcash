<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="actionGravar"><c:url value="/recebimentos/pendentes/gravar"/></c:set>

<dandelion:bundle includes="jquery.validation,jquery.inputmask,jquery.datetimepicker" />

<html>
<head>
  <title>Cadastro de Conta à Receber</title>
  <meta name="header" content="Cadastro" />
  <meta name="previouspage" content="<li><a href='<c:url value="/recebimentos/pendentes"/>'>Recebimentos Pendentes</a></li>" />
</head>
<body>
  <script type="text/javascript">
  $(document).ready(function() {
      var formValidator = $("#receber").validate({
          rules : {
              descricao : { required : true },
              dataVencimento : { required : true },
              valor : { required : true },
              categoria : { required : true }
          }
      });
      $("#descricao").focus();
      $("#div-data-vencimento").datetimepicker({locale: "pt-br", format: "DD/MM/YYYY"});
      $("#dataVencimento").inputmask("99/99/9999");
      $("#valor").maskMoney({
          //prefix: "R$ ",
          decimal: ",",
          thousands: "."
      });
  });
  </script>
  <form:form action="${actionGravar}" modelAttribute="receber">
    <form:hidden path="id" />
    <div class="panel panel-primary col-xs-12 col-md-8 col-md-offset-2">
      <div class="panel-body">
        <div class="page-header" style="margin-top: 10px;">
          <jsp:include page="/layouts/mensagens.jsp"><jsp:param name="model" value="receber"/></jsp:include>
          <h3><strong>Conta à Receber</strong></h3>
        </div>
        <div class="row">
          <div class="form-group col-xs-12 col-md-12">
            <label for="descricao" class="control-label">Descrição</label>
            <form:input path="descricao" class="form-control" placeholder="Digite a descrição da categoria de contas"/>
          </div>
        </div>
        <div class="row">
          <div class="form-group col-xs-12 col-md-6">
            <label for="dataVencimento" class="control-label">Data de Vencimento</label>
            <div class="input-group date" id="div-data-vencimento">
              <form:input path="dataVencimento" class="form-control" extra="placeholder=Data de vencimento da conta" />
              <span class="input-group-addon">
                <span class="glyphicon glyphicon-calendar"></span>
              </span>
            </div>
          </div>
          <div class="form-group col-xs-12 col-md-6">
            <label for="valor" class="control-label">Valor Total (R$)</label>
            <form:input path="valor" class="form-control" placeholder="Digite o valor total da conta"/>
          </div>
        </div>
        <div class="row">
          <div class="form-group col-xs-12 col-md-6">
            <label for="txt_descricao" class="control-label">Categoria</label>
            <form:select path="categoria" class="form-control">
              <form:option value="" label="----- Selecione uma categoria -----"/>
              <form:options items="${listagemCategorias}" itemLabel="descricao" itemValue="id" />
            </form:select>
          </div>
        </div>
        <div class="row">
          <div class="form-group col-xs-12 col-md-12">
            <label for="txt_descricao" class="control-label">Observações</label>
            <form:textarea path="observacao" rows="4" class="form-control" placeholder="Digite possíveis observações relacionada a conta"/>
          </div>
        </div>
        <div class="row">
          <div class="form-group col-x-12 col-md-12" style="text-align: center; margin-top: 25px;">
	        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span> Gravar</button>
          </div>
	    </div>
      </div>
    </div>
  </form:form>
</body>
</html>