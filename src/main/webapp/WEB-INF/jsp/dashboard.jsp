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
      google.charts.setOnLoadCallback(graficoPorDia);
      function graficoPorDia() {
          var data = google.visualization.arrayToDataTable([
            ['Dia', 'Receita', 'Despesa', 'Saldo']
            <c:forEach var="total" items="${graficoPorDia}">
                ,['<fmt:formatDate value="${total.key}" pattern="dd/MM"/>', ${total.value[0]}, ${total.value[1]}, ${total.value[0] - total.value[1]}]
            </c:forEach>
          ]);
          var options = {
              legend: { position: 'bottom' },
              chartArea: { top: 10 },
              seriesType: 'bars',
              series: { 2: { type: 'line' } },
              vAxis: { format: 'currency' }
          };
          var chart = new google.visualization.ComboChart(document.getElementById('graficoPorDia'));
          chart.draw(data, options);
      }
  </script>
</head>

<body>
  <div class="page-header" style="margin-top: -10px;">
    <h4>Previsão de Saldo Diário</h4>
  </div>
  <div class="col-xs-12 col-md-12" id="graficoPorDia" style="height: 250px;"></div>
</body>

</html>
