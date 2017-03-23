<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="datatables" uri="http://github.com/dandelion/datatables" %>
<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>

<c:set var="linkController"><c:url value="/recebimentos/consolidados"/></c:set>

<dandelion:bundle includes="datatables.extended,jquery.validation,jquery.inputmask,jquery.datetimepicker"/>

<html>

<head>
  <title>Recebimentos Consolidados</title>
  <meta name="header" content="Recebimentos Consolidados" />
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
  </script>

  <%@include file="/layouts/modal-mensagens.jsp"%>
  <%@include file="/layouts/modal-exclusao.jsp"%>

  <form name="form-pesquisar-recebidos" id="form-pesquisar-recebidos" action="${linkController}">
    <%@include file="/layouts/modal-processando.jsp" %>
    <div class="row">
      <div class="form-group col-xs-12 col-md-4 col-md-offset-2">
        <label for="txt_data_inicio" class="control-label">Data Início</label>
        <div class="input-group date" id="data_inicio">
          <input type="text" name="txt_data_inicio" id="txt_data_inicio" class="form-control" placeholder="Pesquisar a partir desta data de recebimento"/>
          <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
      <div class="form-group col-xs-12 col-md-4">
        <label for="txt_data_inicio" class="control-label">Data Fim</label>
        <div class="input-group date" id="data_fim">
          <input type="text" name="txt_data_fim" id="txt_data_fim" class="form-control" placeholder="Pesquisar até esta data de recebimento"/>
          <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="form-group col-xs-12 col-md-12 text-center">
        <button type="button" class="btn btn-primary" name="btn_pesquisar" id="btn_pesquisar"><span class="glyphicon glyphicon-search"></span> Pesquisar</button>
      </div>
    </div>
  </form>

  <datatables:table data="${listagemConsolidados}" row="recebido" id="GridDatatable">
    <datatables:column title="Descrição" property="receber.descricao"/>
    <datatables:column title="Recebimento" property="dataRecebimento" format="{0,date,dd/MM/yyyy}" sortType="date-uk" sortInitDirection="asc" cssCellClass="text-center"/>
    <datatables:column title="Valor" property="valorRecebido" format="R$ {0,number,#,##0.00}" cssCellClass="text-right"/>
    <datatables:column title="Extornar" filterable="false" searchable="false" sortable="false" cssCellClass="text-center">
      <a href="#" data-href="${linkController}/excluir/${recebido.id}" class="btn btn-danger btn-xs"
                  data-mensagem-exclusao="Deseja extorno do recebimento ${recebido.receber.descricao}?"
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
