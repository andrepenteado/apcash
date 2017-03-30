<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<li><a href="<c:url value="/dashboard"/>"><span class="glyphicon glyphicon-dashboard"></span> Dashboard</a></li>
<li><a href="<c:url value="/categorias"/>"><span class="glyphicon glyphicon-tag"></span> Categorias</a></li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="glyphicon glyphicon-plus"></span> Créditos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/creditos/pendentes"/>"><span class="glyphicon glyphicon-credit-card"></span> Pendentes</a></li>
    <li><a href="<c:url value="/creditos/liquidados"/>"><span class="glyphicon glyphicon-usd"></span> Liquidados</a></li>
  </ul>
</li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="glyphicon glyphicon-minus"></span> Débitos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/debitos/pendentes"/>"><span class="glyphicon glyphicon-credit-card"></span> Pendentes</a></li>
    <li><a href="<c:url value="/debitos/liquidados"/>"><span class="glyphicon glyphicon-usd"></span> Liquidados</a></li>
  </ul>
</li>