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
    <datatables:column title="Operações" filterable="false" searchable="false" sortable="false" cssClass="text-center" cssCellClass="text-center">
      <a href="${linkController}/editar/${cliente.id}" class="btn btn-default btn-xs" data-toggle="tooltip" title="Alterar">
        <span class='glyphicon glyphicon-pencil'></span>
      </a>
      <a href="#" data-href="${linkController}/excluir/${cliente.id}"
         data-mensagem-exclusao="Deseja realmente excluir ${cliente.nome}?"
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