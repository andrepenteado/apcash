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

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Recebimentos Pendentes', 'Valor (R$)'],
          ['Vencidas: <fmt:formatNumber value="${totalVencido}" type="currency"/>', ${totalVencido}],
          ['Vencendo: <fmt:formatNumber value="${totalVencendo}" type="currency"/>', ${totalVencendo}],
          ['A vencer: <fmt:formatNumber value="${totalVencer}" type="currency"/>', ${totalVencer}]
        ]);
        var options = {
          is3D: true,
          colors: [ '#a94442', 'orange', 'blue' ],
          legend: { alignment: 'center' },
          chartArea: { top: 0, left: 0, height: '100%' }
        };
        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
        chart.draw(data, options);
      }
  </script>

</head>

<body>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <div class="page-header" style="margin-top: -10px;">
    <h4>Relatório sintético: <small>Valor total: <fmt:formatNumber value="${total}" type="currency"/></small></h4>
  </div>
  <div id="piechart_3d" style="height: 150px;"></div>

  <div class="page-header">
    <h4>Relatório analítico</h4>
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
