<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty mensagemErro}">
  <div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <strong><span class="glyphicon glyphicon-remove-sign"></span> Atenção!</strong> ${mensagemInfo}
  </div>
</c:if>
<c:if test="${not empty mensagemInfo}">
  <div class="alert alert-info alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <strong><span class="glyphicon glyphicon-info-sign"></span> Informativo:</strong> ${mensagemInfo}
  </div>
</c:if>