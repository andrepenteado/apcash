<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>

<head>
  <meta name="header" content="Dashboard" />
  <title>Dashboard</title>

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["bar"], 'language': 'pt_BR'});
      google.charts.setOnLoadCallback(graficoPendentesPorDia);
      google.charts.setOnLoadCallback(graficoConsolidadosPorDia);
      function graficoPendentesPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Dias', 'Receita', 'Despesa', 'Saldo']
            <c:forEach var="total" items="${graficoPendentesPorDia}">
                ,['<fmt:formatDate value="${total.key}" pattern="dd/MM"/>', ${total.value[0]}, ${total.value[1]}, ${total.value[0] - total.value[1]} ]
            </c:forEach>
          ]);
          var options = { bars: 'horizontal' };
          var chart = new google.charts.Bar(document.getElementById('graficoPendentesPorDia'));
          chart.draw(data, options);
      }
      function graficoConsolidadosPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Dias', 'Receita', 'Despesa', 'Saldo']
            <c:forEach var="total" items="${graficoConsolidadosPorDia}">
                ,['<fmt:formatDate value="${total.key}" pattern="dd/MM"/>', ${total.value[0]}, ${total.value[1]}, ${total.value[0] - total.value[1]} ]
            </c:forEach>
          ]);
          var options = { bars: 'horizontal' };
          var chart = new google.charts.Bar(document.getElementById('graficoConsolidadosPorDia'));
          chart.draw(data, options);
      }
  </script>
</head>

<body>
  <div class="page-header" style="margin-top: -10px;">
    <h4>Previsão de Saldo Diário</h4>
  </div>
  <div class="row">
    <c:set var="tamanhoGrafico">${graficoPendentesPorDia.size()*60 < 150 ? 150 : graficoPendentesPorDia.size()*60}</c:set>
    <div class="col-xs-12 col-md-12" id="graficoPendentesPorDia" style="height: ${tamanhoGrafico}px;"></div>
  </div>

  <div class="page-header">
    <h4>Consolidados últimos 30 dias</h4>
  </div>
  <div class="row">
    <c:set var="tamanhoGrafico">${graficoConsolidadosPorDia.size()*60 < 150 ? 150 : graficoConsolidadosPorDia.size()*60}</c:set>
    <div class="col-xs-12 col-md-12" id="graficoConsolidadosPorDia" style="height: ${tamanhoGrafico}px;"></div>
  </div>

</body>

</html>
