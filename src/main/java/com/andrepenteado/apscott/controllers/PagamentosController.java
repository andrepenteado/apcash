
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
import com.andrepenteado.apscott.models.Pagar;
import com.andrepenteado.apscott.models.Pago;
import com.andrepenteado.apscott.models.TipoQuitacao;
import com.andrepenteado.apscott.repositories.CategoriaRepository;
import com.andrepenteado.apscott.repositories.PagarRepository;
import com.google.common.base.Objects;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/pagamentos")
public class PagamentosController {

    @Autowired
    private PagarRepository repository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    @Autowired
    private MessageSource config;

    @GetMapping("/pendentes")
    public String pendentes(Model model) {
        model.addAttribute("listagemPendentes", repository.pesquisarPagamentosPendentes());
        model.addAttribute("total", Objects.firstNonNull(repository.somarTotal(), 0));
        model.addAttribute("totalPorCategoria", repository.somarTotalPendenteAgrupadoPorCategoria());
        /*model.addAttribute("totalPorDia", repository.somarTotalPendenteAgrupadoPorDia());*/
        model.addAttribute("totalVencer", Objects.firstNonNull(repository.somarTotalVencer(), 0));
        model.addAttribute("totalVencido", Objects.firstNonNull(repository.somarTotalVencido(), 0));
        model.addAttribute("totalVencendo", Objects.firstNonNull(repository.somarTotalVencendo(), 0));
        return "/pagamentos/pendentes/pesquisar";
    }

    @GetMapping("/pendentes/incluir")
    public String incluirPagar(Model model) {
        model.addAttribute("pagar", new Pagar());
        return abrirCadastroPagar(model);
    }

    @GetMapping("/pendentes/editar/{id}")
    public String editarPagar(Model model, @PathVariable Long id) {
        Pagar pagar = repository.findOne(id);
        model.addAttribute("pagar", pagar);
        return abrirCadastroPagar(model);
    }

    @PostMapping("/pendentes/gravar")
    public String gravarPagar(Model model, @ModelAttribute("pagar") @Valid Pagar pagar, BindingResult result) {
        try {
            if (!result.hasErrors()) {
                Pagar pagarAtualizado = repository.save(pagar);
                log.info(pagarAtualizado.toString() + " gravado com sucesso");
                model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "a conta à pagar" }, null));
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return abrirCadastroPagar(model);
    }

    public String abrirCadastroPagar(Model model) {
        model.addAttribute("listagemCategorias", categoriaRepository.pesquisarPorTipo(DespesaReceita.DESPESA));
        return "/pagamentos/pendentes/cadastro";
    }

    @GetMapping("/pendentes/excluir/{id}")
    public String excluirPagar(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.delete(id);
            log.info("Conta à pagar #" + id + " excluída com sucesso");
            ra.addFlashAttribute("mensagemInfo", config.getMessage("excluidoSucesso", new Object[] { "a conta à pagar" }, null));
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/pagamentos/pendentes";
    }

    @GetMapping("/pendentes/consolidar/{id}")
    public String consolidarPagar(RedirectAttributes ra, @PathVariable Long id) {
        try {
            Pagar pagar = repository.findOne(id);
            Pago pago = new Pago();
            pago.setDataPagamento(pagar.getDataVencimento());
            pago.setValorPago(pagar.getValor());
            pago.setFormaPagamento(TipoQuitacao.DINHEIRO);
            pago.setPagar(pagar);
            if (pagar.getPagamentos() == null)
                pagar.setPagamentos(new ArrayList<Pago>());
            pagar.getPagamentos().add(pago);
            repository.save(pagar);
            log.info("Conta à pagar #" + id + " consolidada com sucesso");
            ra.addFlashAttribute("mensagemInfo", "A consolidação da conta " + pagar.getDescricao() + " foi efetuada com sucesso");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/pagamentos/pendentes";
    }

    @GetMapping("/consolidados")
    public String consolidados(Model model, @RequestParam(value = "txt_descricao", required = false) String descricao,
                    @RequestParam(value = "txt_data_inicio", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataInicio,
                    @RequestParam(value = "txt_data_fim", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataFim) {
        if (dataInicio != null && dataFim != null) {
            model.addAttribute("total", Objects.firstNonNull(repository.somarPagoPorDescricaoPorData(descricao, dataInicio, dataFim), 0));
            model.addAttribute("totalPorCategoria", repository.somarTotalPagoAgrupadoPorCategoria(descricao, dataInicio, dataFim));
            /*model.addAttribute("totalPorDia", repository.somarTotalPagoAgrupadoPorDia(descricao, dataInicio, dataFim));*/
            model.addAttribute("listagemConsolidados", repository.pesquisarPagoPorDescricaoPorData(descricao, dataInicio, dataFim));
            model.addAttribute("txt_data_inicio", new SimpleDateFormat("dd/MM/yyyy").format(dataInicio));
            model.addAttribute("txt_data_fim", new SimpleDateFormat("dd/MM/yyyy").format(dataFim));
            model.addAttribute("txt_descricao", descricao);
        }
        else {
            model.addAttribute("total", "0");
        }
        return "/pagamentos/consolidados/pesquisar";
    }

    @GetMapping("/consolidados/excluir/{id}")
    public String excluirPago(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.excluirPagamentoPorId(id);
            log.info("Extornada consolidação de conta recebida #" + id);
            ra.addFlashAttribute("mensagemInfo", "Extornada consolidação de conta recebida");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/pagamentos/consolidados";
    }
}