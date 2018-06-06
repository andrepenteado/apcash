<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>

<dandelion:bundle includes="font-awesome5" />

<li><a href="<c:url value="/dashboard"/>"><span class="fas fa-tachometer-alt"></span> Dashboard</a></li>
<li><a href="<c:url value="/categorias"/>"><span class="fas fa-tag"></span> Categorias</a></li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="fas fa-plus"></span> Créditos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/creditos/pendentes"/>"><span class="fas fa-credit-card fa-fw"></span> Pendentes</a></li>
    <li><a href="<c:url value="/creditos/liquidados"/>"><span class="fas fa-dollar-sign fa-fw"></span> Liquidados</a></li>
  </ul>
</li>
<li class="dropdown"><a href="#" class="dropdown-togle" data-toggle="dropdown"><span class="glyphicon glyphicon-minus"></span> Débitos <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li><a href="<c:url value="/debitos/pendentes"/>"><span class="fas fa-credit-card fa-fw"></span> Pendentes</a></li>
    <li><a href="<c:url value="/debitos/liquidados"/>"><span class="fas fa-dollar-sign fa-fw"></span> Liquidados</a></li>
  </ul>
</li>