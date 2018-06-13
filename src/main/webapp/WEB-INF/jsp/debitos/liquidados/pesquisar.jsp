<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/debitos/liquidados"/></c:set>

<dandelion:bundle includes="datatables.extended,jquery.validation,jquery.inputmask,bootstrap3.datetimepicker,font-awesome5"/>

<html>

<head>
  <title>Débitos Liquidados</title>
  <meta name="header" content="Débitos Liquidados" />

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(graficoPorCategoria);
      function graficoPorCategoria() {
          var data = google.visualization.arrayToDataTable([
            ['Categoria', 'Valor']
            <c:forEach var="total" items="${totalPorCategoria}">
                ,['${total[1]}: <fmt:formatNumber value="${total[0]}" type="currency"/>', ${total[0]}]
            </c:forEach>
          ]);
          var options = { is3D: true, legend: { alignment: 'center' }, chartArea: { width: '100%', height: '100%' } };
          var chart = new google.visualization.PieChart(document.getElementById('graficoPorCategoria'));
          chart.draw(data, options);
      }
  </script>

</head>

<body>
  <script type="text/javascript">
      $(document).ready(function() {
          var formValidator = $("#form-pesquisar-pagos").validate({
              rules : {
            	  txt_data_inicio : { required : true },
            	  txt_data_fim : { required : true }
              }
          });
          $("#btn_pesquisar").click(function() {
              var form = $("#form-pesquisar-pagos"); 
              form.validate();
              if (form.valid()) {
                  form.submit();
              }
          });
          $("#txt_data_inicio").focus();
          $("#txt_data_inicio").inputmask("99/99/9999");
          $("#txt_data_fim").inputmask("99/99/9999");
          $("#data_inicio").datetimepicker({locale: "pt-br", format: "DD/MM/YYYY"});
          $("#data_fim").datetimepicker({locale: "pt-br", format: "DD/MM/YYYY"});
          $('[data-toggle="tooltip"]').tooltip();
      });
      function fnFooterCallback( row, data, start, end, display ) {
          var totalPage = 0;
          for (var i = start; i < end; i++) {
              totalPage += Number(data[display[i]].valorPago.replace('R$', '').replace('.', '').replace(',', '.'));
          }
          $("#totalAnalitico").html("Valor total exibido: R$ " + totalPage.toFixed(2));
      };
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-confirmacoes.jsp"%>

  <form name="form-pesquisar-pagos" id="form-pesquisar-pagos" action="${linkController}">
    <%@include file="/layouts/modal-processando.jsp" %>
    <div class="row">
      <div class="form-group col-xs-12 col-md-3">
        <label for="txt_data_inicio" class="control-label">Data Início</label>
        <div class="input-group date" id="data_inicio">
          <input type="text" name="txt_data_inicio" id="txt_data_inicio" class="form-control" value="${txt_data_inicio}"/>
          <span class="input-group-addon">
            <span class="fas fa-calendar-alt"></span>
          </span>
        </div>
      </div>
      <div class="form-group col-xs-12 col-md-4">
        <label for="txt_data_inicio" class="control-label">Data Fim</label>
        <div class="input-group date" id="data_fim">
          <input type="text" name="txt_data_fim" id="txt_data_fim" class="form-control" value="${txt_data_fim}"/>
          <span class="input-group-addon">
            <span class="fas fa-calendar-alt"></span>
          </span>
          <span class="input-group-btn">
            <button type="button" class="btn btn-primary" name="btn_pesquisar" id="btn_pesquisar"><span class="fas fa-search"></span> Pesquisar</button>
          </span>
        </div>
      </div>
    </div>
  </form>

  <div class="page-header" style="margin-top: -10px;">
    <h4>Relatório sintético: <small>Valor total: <fmt:formatNumber value="${total}" type="currency"/></small></h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoPorCategoria" style="height: 150px;"></div>
  </div>

  <div class="page-header">
    <h4>Relatório analítico: <small id="totalAnalitico"></small></h4>
  </div>

  <datatables:table data="${listagemLiquidados}" row="pago" id="GridDatatable" pageable="false">
    <datatables:column title="Descrição" property="pagar.descricao"/>
    <datatables:column title="Categoria" property="pagar.categoria.descricao"/>
    <datatables:column title="Pagamento" property="dataPagamentoJsp" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center"/>
    <datatables:column title="Valor" property="valorPago" format="R$ {0,number,#,##0.00}" cssCellClass="text-right"/>
    <datatables:column title="Extornar" filterable="false" searchable="false" sortable="false" cssCellClass="text-center">
      <a href="#" onclick="confirmarExclusao('Extornar o pagamento do débito de ${pago.pagar.valor} do item ${pago.pagar.descricao}?', '${linkController}/excluir/${pago.id}'); return false;">
      <span class='fas fa-trash-alt'></span></a>
    </datatables:column>
    <datatables:callback function="fnFooterCallback" type="footer"/>
    <datatables:extraJs bundles="datatables.extended.config" placeholder="before_start_document_ready" />
  </datatables:table>
  <br/>
  <br/>
</body>

</html>
