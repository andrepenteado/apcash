<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/recebimentos/consolidados"/></c:set>

<dandelion:bundle includes="datatables.extended,jquery.validation,jquery.inputmask,jquery.datetimepicker"/>

<html>

<head>
  <title>Créditos Consolidados</title>
  <meta name="header" content="Créditos Consolidados" />

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
          var options = { is3D: true, legend: { alignment: 'center' }, chartArea: { top: 0, left: 0, height: '100%' } };
          var chart = new google.visualization.PieChart(document.getElementById('graficoPorCategoria'));
          chart.draw(data, options);
      }
  </script>

</head>

<body>
  <script type="text/javascript">
      $(document).ready(function() {
          var formValidator = $("#form-pesquisar-recebidos").validate({
              rules : {
            	  txt_data_inicio : { required : true },
            	  txt_data_fim : { required : true }
              }
          });
          $("#btn_pesquisar").click(function() {
              var form = $("#form-pesquisar-recebidos"); 
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
              totalPage += Number(data[display[i]].valorRecebido.replace('R$', '').replace('.', '').replace(',', '.'));
          }
          $("#totalAnalitico").html("Valor total exibido: R$ " + totalPage.toFixed(2));
      };
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <div class="page-header" style="margin-top: -10px;">
    <h4>Relatório sintético: <small>Valor total: <fmt:formatNumber value="${total}" type="currency"/></small></h4>
  </div>
  <div class="row">
    <div class="col-xs-12 col-md-12" id="graficoPorCategoria" style="height: 150px;"></div>
  </div>

  <div class="page-header">
    <h4>Relatório analítico: <small id="totalAnalitico"></small></h4>
  </div>

  <form name="form-pesquisar-recebidos" id="form-pesquisar-recebidos" action="${linkController}">
    <%@include file="/layouts/modal-processando.jsp" %>
    <div class="row">
      <div class="form-group col-xs-12 col-md-3">
        <label for="txt_data_inicio" class="control-label">Data Início</label>
        <div class="input-group date" id="data_inicio">
          <input type="text" name="txt_data_inicio" id="txt_data_inicio" class="form-control" value="${txt_data_inicio}" placeholder="Pesquisar a partir desta data de recebimento"/>
          <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
      <div class="form-group col-xs-12 col-md-3">
        <label for="txt_data_inicio" class="control-label">Data Fim</label>
        <div class="input-group date" id="data_fim">
          <input type="text" name="txt_data_fim" id="txt_data_fim" class="form-control" value="${txt_data_fim}" placeholder="Pesquisar até esta data de recebimento"/>
          <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
      <div class="form-group col-xs-12 col-md-6">
        <label for=txt_chave class="control-label">Descrição</label>
        <div class="input-group">
          <input type="text" name="txt_descricao" id="txt_descricao" value="${txt_descricao}" placeholder="Descrição ou parte da descrição a ser pesquisada" class="form-control"/>
          <span class="input-group-btn">
            <button type="button" class="btn btn-primary" name="btn_pesquisar" id="btn_pesquisar"><span class="glyphicon glyphicon-search"></span> Pesquisar</button>
          </span>
        </div>
      </div>
    </div>
  </form>

  <datatables:table data="${listagemConsolidados}" row="recebido" id="GridDatatable">
    <datatables:column title="Descrição" property="receber.descricao"/>
    <datatables:column title="Categoria" property="receber.categoria.descricao"/>
    <datatables:column title="Recebimento" property="dataRecebimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center"/>
    <datatables:column title="Valor" property="valorRecebido" format="R$ {0,number,#,##0.00}" cssCellClass="text-right"/>
    <datatables:column title="Extornar" filterable="false" searchable="false" sortable="false" cssCellClass="text-center">
      <a href="#" data-href="${linkController}/excluir/${recebido.id}" class="btn btn-danger btn-xs"
                  data-mensagem-exclusao="Deseja extorno do recebimento ${recebido.receber.descricao}?"
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
