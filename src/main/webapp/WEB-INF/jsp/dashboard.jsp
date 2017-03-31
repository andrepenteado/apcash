<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<dandelion:bundle includes="font-awesome"/>

<c:set var="totalReceitaPendente" value="0"/>
<c:set var="totalDespesaPendente" value="0"/>
<c:set var="saldoPendente" value="0"/>
<c:set var="totalReceitaLiquidado" value="0"/>
<c:set var="totalDespesaPendente" value="0"/>
<c:set var="saldoPendente" value="0"/>

<html>

<head>
  <meta name="header" content="Dashboard" />
  <title>Dashboard</title>

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"], 'language': 'pt_BR'});
      google.charts.setOnLoadCallback(graficoPendentesPorDia);
      google.charts.setOnLoadCallback(graficoLiquidadosPorDia);
      function graficoPendentesPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Dias', 'Receita', 'Despesa', 'Saldo']
            <c:forEach var="total" items="${graficoPendentesPorDia}">
                ,[
                    { v: new Date('<fmt:formatDate value="${total.key}" pattern="yyyy-MM-dd"/>'), f: 'Dia: <fmt:formatDate value="${total.key}" pattern="dd/MM/yyyy"/>' },
                    { v: ${total.value[0]}, f: '<fmt:formatNumber value="${total.value[0]}" type="currency"/>' },
                    { v: ${total.value[1]}, f: '<fmt:formatNumber value="${total.value[1]}" type="currency"/>' },
                    { v: ${total.value[0] - total.value[1]}, f: '<fmt:formatNumber value="${total.value[0] - total.value[1]}" type="currency"/>' }
                 ]
                <c:set var="totalReceitaPendente">${total.value[0]}</c:set>
                <c:set var="totalDespesaPendente">${total.value[1]}</c:set>
                <c:set var="saldoPendente">${total.value[0] - total.value[1]}</c:set>
            </c:forEach>
          ]);
          var options = { 
              legend: { position: 'top', maxLines: 3 }, 
              animation: { duration: 1000, startup: true, easing: 'out' }, 
              chartArea: { width: '90%', height: '88%' }, 
              focusTarget: 'category',
              vAxis: { format: 'short' },
              hAxis: { format: 'dd/MM' },
              orientation: 'horizontal'
          };
          var chart = new google.visualization.AreaChart(document.getElementById('graficoPendentesPorDia'));
          chart.draw(data, options);
      }
      function graficoLiquidadosPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Dias', 'Receita', 'Despesa', 'Saldo']
            <c:forEach var="total" items="${graficoLiquidadosPorDia}">
                ,[
                    { v: new Date('<fmt:formatDate value="${total.key}" pattern="yyyy-MM-dd"/>'), f: 'Dia: <fmt:formatDate value="${total.key}" pattern="dd/MM/yyyy"/>' },
                    { v: ${total.value[0]}, f: '<fmt:formatNumber value="${total.value[0]}" type="currency"/>' },
                    { v: ${total.value[1]}, f: '<fmt:formatNumber value="${total.value[1]}" type="currency"/>' },
                    { v: ${total.value[0] - total.value[1]}, f: '<fmt:formatNumber value="${total.value[0] - total.value[1]}" type="currency"/>' }  
                 ]
                <c:set var="totalReceitaLiquidado">${total.value[0]}</c:set>
                <c:set var="totalDespesaLiquidado">${total.value[1]}</c:set>
                <c:set var="saldoLiquidado">${total.value[0] - total.value[1]}</c:set>
            </c:forEach>
          ]);
          var options = { 
              legend: { position: 'top', maxLines: 3 }, 
              animation: { duration: 1000, startup: true, easing: 'out' }, 
              chartArea: { width: '90%', height: '88%' }, 
              focusTarget: 'category',
              vAxis: { format: 'short' },
              hAxis: { format: 'dd/MM' },
              orientation: 'horizontal'
          };
          var chart = new google.visualization.AreaChart(document.getElementById('graficoLiquidadosPorDia'));
          chart.draw(data, options);
      }
  </script>
</head>

<body>
  <div class="page-header" style="margin-top: -10px;">
    <h4>Saldo Próximos 30 dias</h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoPendentesPorDia" style="height: 200px;"></div>
  </div>
  <div class="row text-center text-primary">
    <div class="cols-xs-6 col-md-4">
      <i class="fa fa-2x fa-plus-circle"></i>
      <h3><fmt:formatNumber value="${totalReceitaPendente}" type="currency"/></h3>
    </div>
    <div class="cols-xs-6 col-md-4 text-danger">
      <i class="fa fa-2x fa-minus-circle"></i>
      <h3><fmt:formatNumber value="${totalDespesaPendente}" type="currency"/></h3>
    </div>
    <div class="cols-xs-12 col-md-4 text-warning">
      <i class="fa fa-2x fa-usd"></i>
      <h3><fmt:formatNumber value="${saldoPendente}" type="currency"/></h3>
    </div>
  </div>

  <div class="page-header">
    <h4>Liquidados últimos 90 dias</h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoLiquidadosPorDia" style="height: 200px;"></div>
  </div>
  <div class="row text-center text-primary">
    <div class="cols-xs-6 col-md-4">
      <i class="fa fa-2x fa-plus-circle"></i>
      <h3><fmt:formatNumber value="${totalReceitaLiquidado}" type="currency"/></h3>
    </div>
    <div class="cols-xs-6 col-md-4 text-danger">
      <i class="fa fa-2x fa-minus-circle"></i>
      <h3><fmt:formatNumber value="${totalDespesaLiquidado}" type="currency"/></h3>
    </div>
    <div class="cols-xs-12 col-md-4 text-warning">
      <i class="fa fa-2x fa-usd"></i>
      <h3><fmt:formatNumber value="${saldoLiquidado}" type="currency"/></h3>
    </div>
  </div>

</body>

</html>
