<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkEditar"><c:url value="/categorias/editar"/></c:set>
<c:set var="linkExcluir"><c:url value="/categorias/excluir"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>
<head>
  <title>Categorias</title>
  <meta name="header" content="Categorias" />
</head>
<body>
  <%@include file="/layouts/mensagens.jsp"%>
  <button class="unespfc-floating-button" onclick="location.href='<c:url value="/categorias/incluir"/>'">+</button>
  <datatables:table data="${listagemCategorias}" row="categoria" id="GridDatatable">
    <datatables:column title="Nome" property="descricao" sortInitDirection="ASC"/>
    <datatables:column title="Alterar" sortable="false" filterable="false" searchable="false">
      <center><a href="${linkEditar}/${categoria.id}"><span class='glyphicon glyphicon-pencil'></span></a></center>
    </datatables:column>
    <datatables:column title="Excluir" sortable="false" filterable="false" searchable="false">
      <center><a href="${linkExcluir}/${categoria.id}"><span class='glyphicon glyphicon-remove'></span></a></center>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>
</html>
