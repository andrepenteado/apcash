<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal fade" id="janela-confirmacao-modal" tabindex="-1" role="dialog" aria-labelledby="mensagemJanelaConfirmacao">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="mensagemJanelaConfirmacao">Deseja realmente confirmar?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Não</button>
        <a class="btn btn-success"><span class='glyphicon glyphicon-ok'></span> Confirmar</a>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$('#janela-confirmacao-modal').on('show.bs.modal', function (event) {
    var link = $(event.relatedTarget)
    var mensagem = link.data('mensagem-confirmacao')
    var href = link.data('href')
    var modal = $(this)
    modal.find('.modal-title').text(mensagem)
    modal.find('.btn-success').attr("href", href)
})
</script>