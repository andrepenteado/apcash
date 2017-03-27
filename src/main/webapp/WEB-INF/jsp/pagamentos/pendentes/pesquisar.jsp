<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/pagamentos/pendentes"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>

<head>
  <title>Pagamentos Pendentes</title>
  <meta name="header" content="Pagamentos Pendentes" />

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(graficoTotais);
      google.charts.setOnLoadCallback(graficoPorCategoria);
      /* google.charts.setOnLoadCallback(graficoPorDia); */
      function graficoTotais() {
        var data = google.visualization.arrayToDataTable([
          ['Pagamentos Pendentes', 'Valor (R$)'],
          ['Vencidas: <fmt:formatNumber value="${totalVencido}" type="currency"/>', ${totalVencido}],
          ['Vencendo: <fmt:formatNumber value="${totalVencendo}" type="currency"/>', ${totalVencendo}],
          ['A vencer: <fmt:formatNumber value="${totalVencer}" type="currency"/>', ${totalVencer}]
        ]);
        var options = {
          is3D: true,
          colors: [ '#a52b0e', 'orange', 'blue' ],
          legend: { alignment: 'center' },
          chartArea: { top: 0, left: 0, height: '100%' }
        };
        var chart = new google.visualization.PieChart(document.getElementById('graficoTotais'));
        chart.draw(data, options);
      }
      function graficoPorCategoria() {
          var data = google.visualization.arrayToDataTable([
            ['Pagamentos Pendentes Por Categoria', 'Valor (R$)']
            <c:forEach var="total" items="${totalPorCategoria}">
                ,['${total[1]}: <fmt:formatNumber value="${total[0]}" type="currency"/>', ${total[0]}]
            </c:forEach>
          ]);
          var options = { is3D: true, legend: { alignment: 'center' }, chartArea: { top: 0, left: 0, height: '100%' } };
          var chart = new google.visualization.PieChart(document.getElementById('graficoPorCategoria'));
          chart.draw(data, options);
        }
      /* function graficoPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Pagamentos Pendentes Por Dia', 'Valor (R$)']
            <c:forEach var="total" items="${totalPorDia}">
                ,['<fmt:formatDate value="${total[1]}" pattern="dd/MM"/>', ${total[0]}]
            </c:forEach>
          ]);
          var options = { legend: { position: 'none' } };
          var chart = new google.visualization.LineChart(document.getElementById('graficoPorDia'));
          chart.draw(data, options);
        } */
  </script>

</head>

<body>
  <script type="text/javascript">
      $(document).ready(function() {
          $('[data-toggle="tooltip"]').tooltip();
      });
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>
  <%@include file="/layouts/modal-confirmacao.jsp"%>

  <div class="page-header" style="margin-top: -10px;">
    <h4>Relatório sintético: <small>Valor total: <fmt:formatNumber value="${total}" type="currency"/></small></h4>
  </div>
  
  <div class="row">
    <div class="col-xs-12 col-md-6" id="graficoTotais" style="height: 150px;"></div>
    <div class="col-xs-12 col-md-6" id="graficoPorCategoria" style="height: 150px;"></div>
    <!-- <div class="col-xs-12 col-md-4" id="graficoPorDia" style="height: 150px;"></div> -->
  </div>

  <div class="page-header">
    <h4>Relatório analítico</h4>
  </div>

  <button class="unespfc-floating-button" onclick="location.href='${linkController}/incluir'">+</button>
  <datatables:table data="${listagemPendentes}" row="pagar" id="GridDatatable">
    <c:set var="cssLinha">${pagar.vencida ? 'danger' : pagar.vencendo ? 'warning' : ''}</c:set>
    <datatables:column title="Descrição" property="descricao" cssCellClass="${cssLinha}"/>
    <datatables:column title="Vencimento" property="dataVencimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center ${cssLinha}"/>
    <datatables:column title="Valor" property="valor" format="R$ {0,number,#,##0.00}" cssCellClass="text-right ${cssLinha}"/>
    <datatables:column title="Operações" filterable="false" searchable="false" sortable="false" cssCellClass="text-center ${cssLinha}">
      <a href="#" data-href="${linkController}/consolidar/${pagar.id}" class="btn btn-success btn-xs"
                  data-mensagem-confirmacao="Deseja realmente consolidar a conta ${pagar.descricao}?"
                  data-toggle="modal" data-target="#janela-confirmacao-modal">
        <span class='glyphicon glyphicon-usd' data-toggle="tooltip" title="Consolidar"></span>
      </a>
      <a href="${linkController}/editar/${pagar.id}" class="btn btn-default btn-xs" data-toggle="tooltip" title="Alterar">
        <span class='glyphicon glyphicon-pencil'></span>
      </a>
      <a href="#" data-href="${linkController}/excluir/${pagar.id}" class="btn btn-danger btn-xs"
                  data-mensagem-exclusao="Deseja realmente excluir ${pagar.descricao}?"
                  data-toggle="modal" data-target="#janela-exclusao-modal">
        <span class='glyphicon glyphicon-trash' data-toggle="tooltip" title="Excluir"></span>
      </a>
    </datatables:column>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>

</html>
