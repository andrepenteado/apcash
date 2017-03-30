
package com.andrepenteado.apscott.controllers;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
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
@RequestMapping("/debitos")
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
        return "/debitos/pendentes/pesquisar";
    }

    @GetMapping("/pendentes/incluir")
    public String incluirDebito(Model model) {
        model.addAttribute("pagar", new Pagar());
        return abrirCadastroDebito(model);
    }

    @GetMapping("/pendentes/editar/{id}")
    public String editarDebito(Model model, @PathVariable Long id) {
        Pagar pagar = repository.findOne(id);
        model.addAttribute("pagar", pagar);
        return abrirCadastroDebito(model);
    }

    @PostMapping("/pendentes/gravar")
    public String gravarDebito(Model model, @ModelAttribute("pagar") @Valid Pagar pagar, BindingResult result) {
        try {
            if (!result.hasErrors()) {
                Pagar pagarAtualizado = repository.save(pagar);
                log.info(pagarAtualizado.toString() + " gravado com sucesso");
                model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "o débito" }, null));
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return abrirCadastroDebito(model);
    }

    public String abrirCadastroDebito(Model model) {
        model.addAttribute("listagemCategorias", categoriaRepository.pesquisarPorTipo(DespesaReceita.DESPESA));
        return "/debitos/pendentes/cadastro";
    }

    @GetMapping("/pendentes/excluir/{id}")
    public String excluirDebito(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.delete(id);
            log.info("Débito #" + id + " excluído com sucesso");
            ra.addFlashAttribute("mensagemInfo", config.getMessage("excluidoSucesso", new Object[] { "o débito" }, null));
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/debitos/pendentes";
    }

    @GetMapping("/pendentes/liquidar/{id}")
    public String liquidarDebito(RedirectAttributes ra, @PathVariable Long id) {
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
            log.info("Débito #" + id + " liquidado com sucesso");
            ra.addFlashAttribute("mensagemInfo", "O débito " + pagar.getDescricao() + " foi liquidado com sucesso");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/debitos/pendentes";
    }

    @GetMapping("/liquidados")
    public String liquidados(Model model,
                    @RequestParam(value = "txt_data_inicio", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataInicio,
                    @RequestParam(value = "txt_data_fim", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataFim) {
        if (dataInicio == null || dataFim == null) {
            LocalDate inicioMes = LocalDate.now().withDayOfMonth(1);
            LocalDate fimMes = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());
            dataInicio = java.sql.Date.valueOf(inicioMes);
            dataFim = java.sql.Date.valueOf(fimMes);
        }
        model.addAttribute("total", Objects.firstNonNull(repository.somarPagoPorDescricaoPorData(dataInicio, dataFim), 0));
        model.addAttribute("totalPorCategoria", repository.somarTotalPagoAgrupadoPorCategoria(dataInicio, dataFim));
        model.addAttribute("listagemLiquidados", repository.pesquisarPagoPorDescricaoPorData(dataInicio, dataFim));
        model.addAttribute("txt_data_inicio", new SimpleDateFormat("dd/MM/yyyy").format(dataInicio));
        model.addAttribute("txt_data_fim", new SimpleDateFormat("dd/MM/yyyy").format(dataFim));
        return "/debitos/liquidados/pesquisar";
    }

    @GetMapping("/liquidados/excluir/{id}")
    public String excluirDebitoLiquidado(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.excluirPagamentoPorId(id);
            log.info("Extornado o débito liquidados #" + id);
            ra.addFlashAttribute("mensagemInfo", "Extornado o débito liquidado");
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/debitos/liquidados";
    }
}