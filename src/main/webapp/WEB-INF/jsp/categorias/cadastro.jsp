<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="actionGravar"><c:url value="/categorias/gravar"/></c:set>

<dandelion:bundle includes="jquery.validation,font-awesome5" />

<html>
<head>
  <title>Cadastro de Categorias</title>
  <meta name="header" content="Cadastro" />
  <meta name="previouspage" content="<li><a href='<c:url value="/categorias"/>'>Categorias</a></li>" />
</head>
<body>
  <script type="text/javascript">
  $(document).ready(function() {
      var formValidator = $("#categoria").validate({
          rules : {
              descricao : { required : true },
              despesaReceita : { required : true }
          }
      });
      $("#descricao").focus();
  });
  </script>
  <form:form action="${actionGravar}" modelAttribute="categoria">
    <form:hidden path="id" />
    <div class="panel panel-primary col-xs-12 col-md-8 col-md-offset-2">
      <div class="panel-body">
        <div class="page-header" style="margin-top: 10px;">
          <jsp:include page="/layouts/modal-mensagens.jsp"><jsp:param name="model" value="categoria"/></jsp:include>
          <h2>
            <strong>Categoria de Contas</strong>
          </h2>
        </div>
        <div class="row">
          <spring:bind path="descricao">
            <div class="form-group col-xs-12 col-md-12 ${status.error ? 'has-error' : ''}">
              <label for="descricao" class="control-label">Descrição</label>
              <form:input path="descricao" class="form-control"/>
              <span class="has-error"><form:errors path="descricao" class="help-block"/></span>
            </div>
          </spring:bind>
        </div>
        <div class="row">
          <spring:bind path="despesaReceita">
            <div class="form-group col-xs-12 col-md-12 ${status.error ? 'has-error' : ''}">
              <form:radiobuttons path="despesaReceita" items="${tipos}" itemLabel="descricao" element="label class='radio-inline'"/>
              <span class="has-error"><form:errors path="despesaReceita" class="help-block"/></span>
            </div>
          </spring:bind>
        </div>
      </div>
      <div class="form-group col-x-12 col-md-12" style="text-align: center; margin-top: 25px;">
        <button type="submit" class="btn btn-primary"><span class="fas fa-save"></span> Gravar</button>
      </div>
    </div>
  </form:form>
</body>
</html>