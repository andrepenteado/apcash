<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<li><a href="<c:url value="/categorias"/>"><span class="glyphicon glyphicon-tag" aria-hidden="true"></span> Categorias</a></li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown">Recebimentos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/recebimentos/pendentes"/>">Pendentes</a></li>
    <li><a href="<c:url value="/recebimentos/consolidados"/>">Consolidados</a></li>
  </ul>
</li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown">Pagamentos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/pagamentos/pendentes"/>">Pendentes</a></li>
    <li><a href="<c:url value="/pagamentos/consolidados"/>">Consolidados</a></li>
  </ul>
</li>