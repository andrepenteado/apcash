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
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <a href="${linkController}/incluir" class="float-button"><span class="fas fa-plus fa-lg"></span></a>
  <ul class="float-menu">
    <li><a href="#"><span class="fas fa-home fa-lg"></span></a></li>
  </ul>

  <datatables:table data="${listagemCategorias}" row="categoria" id="GridDatatable" sortable="false">
    <datatables:column title="Descrição" property="descricao"/>
    <datatables:column title="Tipo" property="despesaReceita"/>
    <datatables:column title="Opções" filterable="false" searchable="false" cssCellClass="text-center" cssStyle="width: 1%">
      <span class="dropdown clearfix">
        <button class="btn btn-sm" type="button" id="dropdownMenuBottomLeft"
                data-toggle="dropdown" aria-expanded="true"><span class='fas fa-ellipsis-v'></span>
        </button>
        <ul aria-labelledby="dropdownMenu2" role="menu" class="dropdown-menu">
            <li role="presentation">
              <a href="${linkController}/editar/${categoria.id}" tabindex="-1" role="menuitem"><span class='fas fa-pencil-alt'></span> Editar</a>
            </li>
            <li role="presentation">
              <a href="#" data-href="${linkController}/excluir/${categoria.id}"
                 data-mensagem-exclusao="Deseja realmente excluir a categoria ${categoria.descricao}?"
                 data-toggle="modal" data-target="#janela-exclusao-modal" tabindex="-1" role="menuitem"><span class='fas fa-trash-alt'></span> Excluir
              </a>
            </li>
        </ul>
      </span>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>
</html>