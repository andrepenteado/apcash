<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/categorias"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>
<head>
  <title>Categorias</title>
  <meta name="header" content="Categorias" />
</head>
<body>
  <script type="text/javascript">
      $(document).ready(function() {
          $('[data-toggle="tooltip"]').tooltip();
      });
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <button class="unespfc-floating-button" onclick="location.href='${linkController}/incluir'">+</button>
  <datatables:table data="${listagemCategorias}" row="categoria" id="GridDatatable" sortable="false">
    <datatables:column title="Descrição" property="descricao"/>
    <datatables:column title="Operações" filterable="false" searchable="false" cssCellClass="text-center">
      <a href="${linkController}/editar/${categoria.id}" class="btn btn-default btn-xs" data-toggle="tooltip" title="Alterar">
        <span class='glyphicon glyphicon-pencil'></span>
      </a>
      <a href="#" data-href="${linkController}/excluir/${categoria.id}" 
                  data-mensagem-exclusao="Deseja realmente excluir ${categoria.descricao}?" 
                  data-toggle="modal" data-target="#janela-exclusao-modal" class="btn btn-danger btn-xs">
        <span class='glyphicon glyphicon-trash' data-toggle="tooltip" title="Excluir"></span>
      </a>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>
</html>
