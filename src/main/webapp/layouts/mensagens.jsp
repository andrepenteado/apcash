<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>

<dandelion:bundle includes="font-awesome5" />

<c:if test="${not empty mensagemErro}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <strong><span class="fas fa-exclamation-triangle"></span> ${mensagemErro}</strong>
  </div>
</c:if>
<c:if test="${not empty mensagemInfo}">
  <div class="alert alert-info alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <strong><span class="fas fa-exclamation-circle"></span> ${mensagemInfo}</strong>
  </div>
</c:if>

<%-- Erros de validação --%>
<spring:hasBindErrors name="${param.model}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <c:forEach var="error" items="${errors.allErrors}">
      <strong><span class="fas fa-exclamation-triangle"></span> <spring:message message="${error}" /></strong><br/>
    </c:forEach>
  </div>
</spring:hasBindErrors>