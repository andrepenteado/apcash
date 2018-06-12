<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/categorias"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button,font-awesome5"/>

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
  <%@include file="/layouts/modal-confirmacoes.jsp"%>

  <a href="${linkController}/incluir" class="float-button"><span class="fas fa-plus fa-lg"></span></a>

  <datatables:table data="${listagemCategorias}" row="categoria" id="GridDatatable" sortable="false">
    <datatables:column title="Descrição" property="descricao"/>
    <datatables:column title="Tipo" property="despesaReceita"/>
    <datatables:column title="Opções" filterable="false" searchable="false" cssCellClass="text-center" cssStyle="width: 1%">
      <div class="btn-group">
        <button type="button" class="btn btn-default btn-circle dropdown-toggle" data-toggle="dropdown">
          <span class='fas fa-ellipsis-v'></span>
        </button>
        <ul class="dropdown-menu dropdown-menu-right">
          <li><a href="${linkController}/editar/${categoria.id}"><span class='fas fa-pencil-alt'></span> Editar</a></li>
          <li>
            <a href="#" onclick="confirmarExclusao('Deseja realmente excluir a categoria ${categoria.descricao}?', '${linkController}/excluir/${categoria.id}'); return false;">
            <span class='fas fa-trash-alt'></span> Excluir</a>
          </li>
        </ul>
      </div>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>
</html>