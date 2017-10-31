<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<c:if test="${not empty mensagemErro || not empty mensagemInfo}">
  <script type="text/javascript">
    $(document).ready(function() {
        $('#janela-mensagens-modal').modal('show');
    });
  </script>

  <div class="modal fade" id="janela-mensagens-modal" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <div class="modal-title">
            <c:if test="${not empty mensagemErro}">
              <h4>${mensagemErro}</h4>
            </c:if>
            <c:if test="${not empty mensagemInfo}">
              <h4>${mensagemInfo}</h4>
            </c:if>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-dismiss="modal">Fechar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</c:if>

<%-- Erros de validação --%>
<spring:hasBindErrors name="${param.model}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <c:forEach var="error" items="${errors.allErrors}">
      <strong><span class="glyphicon glyphicon-alert"></span> <spring:message message="${error}" /></strong><br/>
    </c:forEach>
  </div>
</spring:hasBindErrors>