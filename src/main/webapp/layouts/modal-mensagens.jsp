<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>

<dandelion:bundle includes="sweetalert2,font-awesome4" />

<%-- Mensagem de Erro --%>
<c:if test="${not empty mensagemErro}">
  <script type="text/javascript">
      $(document).ready(function() {
          swal('Erro', '${mensagemErro}','error');
      });
  </script>
</c:if>

<%-- Mensagem de Sucesso --%>
<c:if test="${not empty mensagemSucesso}">
  <script type="text/javascript">
      $(document).ready(function() {
          swal('Sucesso', '${mensagemSucesso}','success');
      });
  </script>
</c:if>

<%-- Mensagem de Informação --%>
<c:if test="${not empty mensagemInfo}">
  <script type="text/javascript">
      $(document).ready(function() {
          swal('Informação', '${mensagemInfo}','info');
      });
  </script>
</c:if>

<%-- Mensagem de Pergunta --%>
<c:if test="${not empty mensagemPergunta}">
  <script type="text/javascript">
      $(document).ready(function() {
          swal('Responda', '${mensagemPergunta}','question');
      });
  </script>
</c:if>

<%-- Mensagem de Atenção --%>
<c:if test="${not empty mensagemAtencao}">
  <script type="text/javascript">
      $(document).ready(function() {
          swal('Atenção', '${mensagemAtencao}','warning');
      });
  </script>
</c:if>

<%-- Mensagem de erros de validação --%>
<spring:hasBindErrors name="${param.model}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <c:forEach var="error" items="${errors.allErrors}">
      <strong><span class="glyphicon glyphicon-alert"></span> <spring:message message="${error}" /></strong><br/>
    </c:forEach>
  </div>
</spring:hasBindErrors>