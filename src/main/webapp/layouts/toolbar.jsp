<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<li><a href="<c:url value="/dashboard"/>"><span class="glyphicon glyphicon-dashboard"></span> Dashboard</a></li>
<li><a href="<c:url value="/categorias"/>"><span class="glyphicon glyphicon-tag"></span> Categorias</a></li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="glyphicon glyphicon-plus"></span> Recebimentos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/recebimentos/pendentes"/>"><span class="glyphicon glyphicon-ban-circle"></span> Pendentes</a></li>
    <li><a href="<c:url value="/recebimentos/consolidados"/>"><span class="glyphicon glyphicon-ok-circle"></span> Consolidados</a></li>
  </ul>
</li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="glyphicon glyphicon-minus"></span> Pagamentos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/pagamentos/pendentes"/>"><span class="glyphicon glyphicon-ban-circle"></span> Pendentes</a></li>
    <li><a href="<c:url value="/pagamentos/consolidados"/>"><span class="glyphicon glyphicon-ok-circle"></span> Consolidados</a></li>
  </ul>
</li>