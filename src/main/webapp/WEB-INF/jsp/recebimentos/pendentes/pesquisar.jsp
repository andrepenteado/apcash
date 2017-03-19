<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/recebimentos/pendentes"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>
<head>
  <title>Contas à Receber</title>
  <meta name="header" content="Contas à Receber" />
</head>
<body>
  <%@include file="/layouts/mensagens.jsp"%>
  <button class="unespfc-floating-button" onclick="location.href='${linkController}/incluir'">+</button>
  <datatables:table data="${listagemPendentes}" row="receber" id="GridDatatable">
    <datatables:column title="Descrição" property="descricao"/>
    <datatables:column title="Vencimento" property="dataVencimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc"/>
    <datatables:column title="Valor" property="valor" format="{0,number,#,##0.00}"/>
    <datatables:column title="Operações" filterable="false" searchable="false">
      <div class="text-center">
        <a href="${linkController}/editar/${receber.id}"><span class='glyphicon glyphicon-pencil'></span></a>
        <a href="${linkController}/excluir/${receber.id}"><span class='glyphicon glyphicon-remove'></span></a>
      </div>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>
</html>
