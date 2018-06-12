<!-- No JSP que tem o link:
<li><a href="#" data-href="/excluir/1"
data-mensagem-exclusao="Deseja realmente excluir a categoria Nome?"
data-toggle="modal" data-target="#janela-exclusao-modal"><span class='fas fa-trash-alt'></span> Excluir
</a></li>
-->

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal fade" id="janela-exclusao-modal" tabindex="-1" role="dialog" aria-labelledby="mensagemJanelaExclusao">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="mensagemJanelaExclusao">Deseja realmente excluir?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Não</button>
        <a class="btn btn-danger"><span class='glyphicon glyphicon-trash'></span> Excluir</a>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$('#janela-exclusao-modal').on('show.bs.modal', function (event) {
    var link = $(event.relatedTarget)
    var mensagem = link.data('mensagem-exclusao')
    var href = link.data('href')
    var modal = $(this)
    modal.find('.modal-title').text(mensagem)
    modal.find('.btn-danger').attr("href", href)
})
</script>