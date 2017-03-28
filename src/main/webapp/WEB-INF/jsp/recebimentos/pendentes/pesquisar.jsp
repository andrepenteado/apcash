<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/recebimentos/pendentes"/></c:set>

<dandelion:bundle includes="datatables.extended,floating.button"/>

<html>

<head>
  <title>Créditos Pendentes</title>
  <meta name="header" content="Créditos Pendentes" />

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"], 'language': 'pt_BR'});
      google.charts.setOnLoadCallback(graficoPorCategoria);
      function graficoPorCategoria() {
          var data = google.visualization.arrayToDataTable([
            ['Categoria', 'Valor']
            <c:forEach var="total" items="${totalPorCategoria}">
                ,['${total[1]}: <fmt:formatNumber value="${total[0]}" type="currency"/>', ${total[0]}]
            </c:forEach>
          ]);
          var options = { is3D: true, legend: { alignment: 'center' }, chartArea: { top: 0, left: 0, height: '100%' } };
          var chart = new google.visualization.PieChart(document.getElementById('graficoPorCategoria'));
          chart.draw(data, options);
        }
  </script>

</head>

<body>
  <script type="text/javascript">
      $(document).ready(function() {
          $('[data-toggle="tooltip"]').tooltip();
      });
      function fnFooterCallback( row, data, start, end, display ) {
          var totalPage = 0;
          for (var i = start; i < end; i++) {
              totalPage += Number(data[display[i]].valor.replace('.', '').replace(',', '.'));
          }
          $("#totalAnalitico").html("Valor total exibido: R$ " + totalPage.toFixed(2));
      };
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>
  <%@include file="/layouts/modal-confirmacao.jsp"%>

  <div class="page-header" style="margin-top: -10px;">
    <h4>Relatório sintético: <small>Valor total: <fmt:formatNumber value="${total}" type="currency"/></small></h4>
  </div>
  
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoPorCategoria" style="height: 150px;"></div>
  </div>

  <div class="page-header">
    <h4>Relatório analítico: <small id="totalAnalitico"></small></h4>
  </div>

  <button class="unespfc-floating-button" onclick="location.href='${linkController}/incluir'">+</button>
  <datatables:table data="${listagemPendentes}" row="receber" id="GridDatatable">
    <c:set var="cssLinha">${receber.vencida ? 'danger' : receber.vencendo ? 'warning' : ''}</c:set>
    <datatables:column title="Descrição" property="descricao" cssCellClass="${cssLinha}"/>
    <datatables:column title="Categoria" property="categoria.descricao" cssCellClass="${cssLinha}"/>
    <datatables:column title="Vencimento" property="dataVencimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center ${cssLinha}"/>
    <datatables:column title="Valor(R$)" property="valor" format="{0,number,#,##0.00}" cssCellClass="text-right ${cssLinha}"/>
    <datatables:column title="Operações" filterable="false" searchable="false" sortable="false" cssCellClass="text-center ${cssLinha}">
      <a href="#" data-href="${linkController}/consolidar/${receber.id}" class="btn btn-success btn-xs"
                  data-mensagem-confirmacao="Deseja realmente consolidar a conta ${receber.descricao}?"
                  data-toggle="modal" data-target="#janela-confirmacao-modal">
        <span class='glyphicon glyphicon-usd' data-toggle="tooltip" title="Consolidar"></span>
      </a>
      <a href="${linkController}/editar/${receber.id}" class="btn btn-default btn-xs" data-toggle="tooltip" title="Alterar">
        <span class='glyphicon glyphicon-pencil'></span>
      </a>
      <a href="#" data-href="${linkController}/excluir/${receber.id}" class="btn btn-danger btn-xs"
                  data-mensagem-exclusao="Deseja realmente excluir o crédito ${receber.descricao}?"
                  data-toggle="modal" data-target="#janela-exclusao-modal">
        <span class='glyphicon glyphicon-trash' data-toggle="tooltip" title="Excluir"></span>
      </a>
    </datatables:column>
    <datatables:callback function="fnFooterCallback" type="footer"/>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>

</html>
