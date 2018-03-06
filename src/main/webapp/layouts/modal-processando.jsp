<%@taglib prefix="dandelion" uri="http://github.com/dandelion" %>
<dandelion:bundle includes="font-awesome4"/>

<!-- Mensagem "Processando..." -->
<script type="text/javascript">
  $(function() {
      $("#processando").modal('hide');
  });
  $("form").submit(function() {
      $("#processando").modal('show');
      return true;
  });
</script>

<div class="modal fade" id="processando" tabindex="-1" role="dialog" aria-labelledby="processandolLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="processandoLabel">Processando ...</h4>
      </div>
      <div class="modal-body">
        <p align="center" style="text-decoration: blink;">
          <i class="fa fa-circle-o-notch fa-spin fa-2x fa-fw"></i> Aguarde, em processamento ... <br><br>
        </p>
      </div>
    </div>
  </div>
</div>