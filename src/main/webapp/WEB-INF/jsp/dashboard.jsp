<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
    <h4>Previsão de Saldo Diário</h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoPendentesPorDia" style="height: 300px;"></div>
  </div>

  <div class="page-header">
    <h4>Liquidados últimos 90 dias</h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoLiquidadosPorDia" style="height: 300px;"></div>
  </div>

</body>

</html>
