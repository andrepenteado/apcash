<!-- No JSP que tem o link:
<a href="#" onclick="confirmarExclusao('Deseja realmente excluir a categoria ${categoria.descricao}?', '${linkController}/excluir/${categoria.id}'); return false;">
<span class='fas fa-trash-alt'></span> Excluir</a>
-->

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://github.com/dandelion" prefix="dandelion"%>
<dandelion:bundle includes="sweetalert2,font-awesome5" />

<script type="text/javascript">
    function confirmarAlteracao(mensagem, url) {
        swal({
            title: "Confirmar?",
            text: mensagem,
            type: "question",
            showCloseButton: true,
            showCancelButton: true,
            confirmButtonText: "<span class='fas fa-save'></span> Sim",
            cancelButtonText: "Cancelar",
            reverseButtons: true
        }).then(function() {
            $(location).attr("href", url);
        });
    }
    function confirmarExclusao(mensagem, url) {
        swal({
            title: "Atenção!",
            text: mensagem,
            type: "question",
            showCloseButton: true,
            showCancelButton: true,
            focusConfirm: false,
            confirmButtonText: "<span class='fas fa-trash-alt'></span> Excluir",
            confirmButtonColor: "#c9302c",
            cancelButtonText: "Cancelar",
            reverseButtons: true
        }).then(function() {
            $(location).attr("href", url);
        });
    }
</script>