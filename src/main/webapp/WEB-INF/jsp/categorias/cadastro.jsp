<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="actionGravar"><c:url value="/categorias/gravar"/></c:set>

<dandelion:bundle includes="jquery.validation" />

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
              descricao : { required : true }
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
          <jsp:include page="/layouts/mensagens.jsp"><jsp:param name="model" value="categoria"/></jsp:include>
          <h3>
            <strong>Categoria de Contas</strong>
          </h3>
        </div>
        <div class="row">
          <spring:bind path="descricao">
            <div class="form-group col-xs-12 col-md-12 ${status.error ? 'has-error' : ''}">
	          <label for="descricao" class="control-label">Descrição</label>
	          <form:input path="descricao" class="form-control" placeholder="Digite a descrição da categoria de contas"/>
	          <span class="has-error"><form:errors path="descricao" class="help-block"/></span>
	        </div>
	      </spring:bind>
        </div>
      </div>
      <div class="form-group col-x-12 col-md-12" style="text-align: center; margin-top: 25px;">
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span> Gravar</button>
      </div>
    </div>
  </form:form>
</body>
</html>