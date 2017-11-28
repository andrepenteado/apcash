package com.github.andrepenteado.apcash.controllers;

import com.github.andrepenteado.apcash.models.DespesaReceita;
import com.github.andrepenteado.apcash.models.Receber;
import com.github.andrepenteado.apcash.models.Recebido;
import com.github.andrepenteado.apcash.models.TipoQuitacao;
import com.github.andrepenteado.apcash.repositories.CategoriaRepository;
import com.github.andrepenteado.apcash.repositories.ReceberRepository;
import com.google.common.base.Objects;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

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
    public String pendentes(Model model, @RequestParam(value = "txt_data", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate data) {
        if (data == null) {
            LocalDate fimMes = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());
            data = fimMes;
        }
        model.addAttribute("listagemPendentes", repository.pesquisarPendentesAteData(data));
        model.addAttribute("total", Objects.firstNonNull(repository.totalPendenteAteData(data), 0));
        model.addAttribute("totalPorCategoria", repository.totalPendenteAgrupadoPorCategoriaAteData(data));
        model.addAttribute("txt_data", data.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        return "/creditos/pendentes/pesquisar";
    }

    @GetMapping("/pendentes/incluir")
    public String incluirCredito(Model model) {
        model.addAttribute("receber", new Receber());
        return abrirCadastroCredito(model);
    }

    @GetMapping("/pendentes/editar/{id}")
    public String editarCredito(Model model, @PathVariable Long id) {
        Receber receber = repository.findById(id).get();
        model.addAttribute("receber", receber);
        return abrirCadastroCredito(model);
    }

    @PostMapping("/pendentes/gravar")
    public String gravarCredito(Model model, @ModelAttribute("receber") @Valid Receber receber, BindingResult result,
                                @RequestParam(value = "txt_parcelas", defaultValue = "1") int parcelas) {
        try {
            if (!result.hasErrors()) {
                // Sem parcelamento
                if (parcelas == 1) {
                    Receber savedObj = repository.save(receber);
                    log.info(savedObj.toString() + " gravada com sucesso");
                    model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "o crédito" }, null));
                    return abrirCadastroCredito(model);
                }
                // Parcelamento
                LocalDate primeiroVencimento = receber.getDataVencimento();
                for (int i = 0; i < parcelas; i++) {
                    // Clona objeto
                    Receber objToSave = new Receber();
                    BeanUtils.copyProperties(objToSave, receber);

                    // Atualiza info da parcela
                    objToSave.setDescricao(objToSave.getDescricao() + " (" + (i + 1) + "/" + parcelas + ")");
                    objToSave.setDataVencimento(primeiroVencimento.plusMonths(i));

                    // Grava parcela
                    Receber savedObj = repository.save(objToSave);
                    log.info(savedObj.toString() + " gravada com sucesso");
                }
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/creditos/pendentes";
    }

    public String abrirCadastroCredito(Model model) {
        model.addAttribute("listagemCategorias", categoriaRepository.pesquisarPorTipo(DespesaReceita.RECEITA));
        return "/creditos/pendentes/cadastro";
    }

    @GetMapping("/pendentes/excluir/{id}")
    public String excluirCredito(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.deleteById(id);
            log.info("Crédito #" + id + " excluído com sucesso");
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
            Receber receber = repository.findById(id).get();
            Recebido recebido = new Recebido();
            recebido.setDataRecebimento(receber.getDataVencimento());
            recebido.setValorRecebido(receber.getValor());
            recebido.setFormaRecebimento(TipoQuitacao.DINHEIRO);
            recebido.setReceber(receber);
            if (receber.getRecebimentos() == null) {
                receber.setRecebimentos(new ArrayList<Recebido>());
            }
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
    public String liquidados(Model model,
                             @RequestParam(value = "txt_data_inicio", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate dataInicio,
                             @RequestParam(value = "txt_data_fim", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate dataFim) {
        if (dataInicio == null || dataFim == null) {
            LocalDate inicioMes = LocalDate.now().withDayOfMonth(1);
            LocalDate fimMes = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());
            dataInicio = inicioMes;
            dataFim = fimMes;
        }
        model.addAttribute("total", Objects.firstNonNull(repository.totalLiquidadoPorDescricaoPorData(dataInicio, dataFim), 0));
        model.addAttribute("totalPorCategoria", repository.totalLiquidadoAgrupadoPorCategoria(dataInicio, dataFim));
        model.addAttribute("listagemLiquidados", repository.pesquisarLiquidadosPorDescricaoPorData(dataInicio, dataFim));
        model.addAttribute("txt_data_inicio", dataInicio.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        model.addAttribute("txt_data_fim", dataFim.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
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