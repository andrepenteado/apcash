<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/clientes"/></c:set>

<spring:eval var="labelCliente" expression="@environment.getProperty('label.cliente')"/>

<dandelion:bundle includes="datatables.extended,floating.button,font-awesome5,jquery.validation"/>

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
  <%@include file="/layouts/modal-confirmacoes.jsp"%>

  <a href="${linkController}/incluir" class="float-button"><i class="fa fa-plus"></i></a>

  <datatables:table data="${listagemClientes}" row="cliente" id="GridDatatable">
    <datatables:column title="#" property="id" cssClass="text-center" cssCellClass="text-center"/>
    <datatables:column title="Nome" property="nome" sortInitDirection="asc"/>
    <datatables:column title="Bairro" property="bairro"/>
    <datatables:column title="Telefone" property="telefone" sortable="false"/>
    <datatables:column title="Celular" property="celular" sortable="false"/>
    <datatables:column title="Opções" filterable="false" searchable="false" sortable="false" cssClass="text-center" cssCellClass="text-center">
      <div class="btn-group">
        <button type="button" class="btn btn-default btn-circle dropdown-toggle" data-toggle="dropdown">
          <span class='fas fa-ellipsis-v'></span>
        </button>
        <ul class="dropdown-menu dropdown-menu-right">
          <li><a href="${linkController}/editar/${cliente.id}"><span class='fas fa-pencil-alt'></span> Editar</a></li>
          <li><a href="${linkController}/prontuario/${cliente.id}"><span class='fas fa-inbox'></span> Prontuário</a></li>
          <li>
            <a href="#" onclick="confirmarExclusao('Deseja realmente excluir o ${labelCliente} ${cliente.nome}?', '${linkController}/excluir/${cliente.id}'); return false;">
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