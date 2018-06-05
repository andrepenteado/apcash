<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/clientes"/></c:set>

<spring:eval var="labelCliente" expression="@environment.getProperty('label.cliente')"/>

<dandelion:bundle includes="datatables.extended,floating.button,font-awesome4,jquery.validation"/>

<html>
<head>
  <title>${labelCliente}s</title>
  <meta name="header" content="${labelCliente}s" />
</head>
<body>
  <script type="text/javascript">
      $(document).ready(function() {
          $('[data-toggle="tooltip"]').tooltip();
      });
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <a href="${linkController}/incluir" class="float-button"><i class="fa fa-plus"></i></a>

  <datatables:table data="${listagemClientes}" row="cliente" id="GridDatatable">
    <datatables:column title="#" property="id" cssClass="text-center" cssCellClass="text-center"/>
    <datatables:column title="Nome" property="nome" sortInitDirection="asc"/>
    <datatables:column title="Bairro" property="bairro"/>
    <datatables:column title="Telefone" property="telefone" sortable="false"/>
    <datatables:column title="Celular" property="celular" sortable="false"/>
    <datatables:column title="Opções" filterable="false" searchable="false" sortable="false" cssClass="text-center" cssCellClass="text-center">
      <span class="dropdown clearfix">
        <button class="btn btn-sm" type="button" id="dropdownMenuBottomLeft"
                data-toggle="dropdown" aria-expanded="true"><span class='glyphicon glyphicon-option-vertical'></span>
        </button>
        <ul aria-labelledby="dropdownMenu2" role="menu" class="dropdown-menu">
            <li role="presentation">
              <a href="${linkController}/editar/${cliente.id}" tabindex="-1" role="menuitem"><span class='glyphicon glyphicon-pencil'></span> Editar</a>
            </li>
            <li role="presentation">
              <a href="#" data-href="${linkController}/excluir/${cliente.id}"
                 data-mensagem-exclusao="Deseja realmente excluir a categoria ${cliente.nome}?"
                 data-toggle="modal" data-target="#janela-exclusao-modal" tabindex="-1" role="menuitem"><span class='glyphicon glyphicon-trash'></span> Excluir
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