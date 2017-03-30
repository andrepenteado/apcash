
package com.andrepenteado.apscott.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.andrepenteado.apscott.models.DespesaReceita;
import com.andrepenteado.apscott.models.Receber;
import com.andrepenteado.apscott.models.Recebido;
import com.andrepenteado.apscott.models.TipoQuitacao;
import com.andrepenteado.apscott.repositories.CategoriaRepository;
import com.andrepenteado.apscott.repositories.ReceberRepository;
import com.google.common.base.Objects;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/creditos")
public class RecebimentosController {

    @Autowired
    private ReceberRepository repository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    @Autowired
    private MessageSource config;

    @GetMapping("/pendentes")
    public String pendentes(Model model) {
        model.addAttribute("listagemPendentes", repository.pesquisarRecebimentosPendentes());
        model.addAttribute("total", Objects.firstNonNull(repository.somarTotal(), 0));
        model.addAttribute("totalPorCategoria", repository.somarTotalPendenteAgrupadoPorCategoria());
        return "/creditos/pendentes/pesquisar";
    }

    @GetMapping("/pendentes/incluir")
    public String incluirCredito(Model model) {
        model.addAttribute("receber", new Receber());
        return abrirCadastroCredito(model);
    }

    @GetMapping("/pendentes/editar/{id}")
    public String editarCredito(Model model, @PathVariable Long id) {
        Receber receber = repository.findOne(id);
        model.addAttribute("receber", receber);
        return abrirCadastroCredito(model);
    }

    @PostMapping("/pendentes/gravar")
    public String gravarCredito(Model model, @ModelAttribute("receber") @Valid Receber receber, BindingResult result) {
        try {
            if (!result.hasErrors()) {
                Receber receberAtualizado = repository.save(receber);
                log.info(receberAtualizado.toString() + " gravada com sucesso");
                model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "o crédito" }, null));
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return abrirCadastroCredito(model);
    }

    public String abrirCadastroCredito(Model model) {
        model.addAttribute("listagemCategorias", categoriaRepository.pesquisarPorTipo(DespesaReceita.RECEITA));
        return "/creditos/pendentes/cadastro";
    }

    @GetMapping("/pendentes/excluir/{id}")
    public String excluirCredito(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.delete(id);
            log.info("Conta à receber #" + id + " excluída com sucesso");
            ra.addFlashAttribute("mensagemInfo", config.getMessage("excluidoSucesso", new Object[] { "o crédito" }, null));
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/creditos/pendentes";
    }

    @GetMapping("/pendentes/liquidar/{id}")
    public String liquidarCredito(RedirectAttributes ra, @PathVariable Long id) {
        try {
            Receber receber = repository.findOne(id);
            Recebido recebido = new Recebido();
            recebido.setDataRecebimento(receber.getDataVencimento());
            recebido.setValorRecebido(receber.getValor());
            recebido.setFormaRecebimento(TipoQuitacao.DINHEIRO);
            recebido.setReceber(receber);
            if (receber.getRecebimentos() == null)
                receber.setRecebimentos(new ArrayList<Recebido>());
            receber.getRecebimentos().add(recebido);
            repository.save(receber);
            log.info("Crédito #" + id + " foi liquidado com sucesso");
            ra.addFlashAttribute("mensagemInfo", "O crédito " + receber.getDescricao() + " foi liquidado com sucesso");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/creditos/pendentes";
    }

    @GetMapping("/liquidados")
    public String liquidados(Model model, @RequestParam(value = "txt_descricao", required = false) String descricao,
                    @RequestParam(value = "txt_data_inicio", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataInicio,
                    @RequestParam(value = "txt_data_fim", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataFim) {
        if (dataInicio != null && dataFim != null) {
            model.addAttribute("total", Objects.firstNonNull(repository.somarRecebidoPorDescricaoPorData(descricao, dataInicio, dataFim), 0));
            model.addAttribute("totalPorCategoria", repository.somarTotalRecebidoAgrupadoPorCategoria(descricao, dataInicio, dataFim));
            model.addAttribute("listagemLiquidados", repository.pesquisarRecebidoPorDescricaoPorData(descricao, dataInicio, dataFim));
            model.addAttribute("txt_data_inicio", new SimpleDateFormat("dd/MM/yyyy").format(dataInicio));
            model.addAttribute("txt_data_fim", new SimpleDateFormat("dd/MM/yyyy").format(dataFim));
            model.addAttribute("txt_descricao", descricao);
        }
        else {
            model.addAttribute("total", "0");
        }
        return "/creditos/liquidados/pesquisar";
    }

    @GetMapping("/liquidados/excluir/{id}")
    public String excluirRecebido(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.excluirRecebimentoPorId(id);
            log.info("Extornado o crédito liquidado #" + id);
            ra.addFlashAttribute("mensagemInfo", "Extornado o crédito liquidado");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/creditos/liquidados";
    }
}