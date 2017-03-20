<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/recebimentos/pendentes"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>

<head>
  <title>Contas à Receber</title>
  <meta name="header" content="Recebimentos Pendentes" />
</head>

<body>
  <%@include file="/layouts/mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <div class="row">
    <div class="col-xs-12 col-md-3 alert alert-danger"><b>Vencidas:</b> <fmt:formatNumber value="${totalVencido}" type="currency"/></div>
    <div class="col-xs-12 col-md-3 alert alert-warning"><b>Vencendo:</b> <fmt:formatNumber value="${totalVencendo}" type="currency"/></div>
    <div class="col-xs-12 col-md-3 alert alert-success"><b>A vencer:</b> <fmt:formatNumber value="${totalVencer}" type="currency"/></div>
    <div class="col-xs-12 col-md-3 alert alert-info"><b>Total:</b> <fmt:formatNumber value="${total}" type="currency"/></div>
  </div>

  <button class="unespfc-floating-button" onclick="location.href='${linkController}/incluir'">+</button>
  <datatables:table data="${listagemPendentes}" row="receber" id="GridDatatable">
    <c:set var="cssLinha">${receber.vencida ? 'danger' : receber.vencendo ? 'warning' : ''}</c:set>
    <datatables:column title="Descrição" property="descricao" cssCellClass="${cssLinha}"/>
    <datatables:column title="Vencimento" property="dataVencimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center ${cssLinha}"/>
    <datatables:column title="Valor" property="valor" format="R$ {0,number,#,##0.00}" cssCellClass="text-right ${cssLinha}"/>
    <datatables:column title="Operações" filterable="false" searchable="false" cssCellClass="text-center ${cssLinha}">
      <a href="${linkController}/editar/${receber.id}"><span class='glyphicon glyphicon-pencil'></span></a>
      <a href="#" data-href="${linkController}/excluir/${receber.id}" data-mensagem-exclusao="Deseja realmente excluir ${receber.descricao}?" data-toggle="modal" data-target="#janela-exclusao-modal">
        <span class='glyphicon glyphicon-remove'></span>
      </a>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>

</html>
