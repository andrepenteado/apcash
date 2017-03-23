
package com.andrepenteado.apscott.controllers;

import java.util.ArrayList;
import java.util.Date;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.Sort;
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

import com.andrepenteado.apscott.models.Receber;
import com.andrepenteado.apscott.models.Recebido;
import com.andrepenteado.apscott.models.TipoQuitacao;
import com.andrepenteado.apscott.repositories.CategoriaRepository;
import com.andrepenteado.apscott.repositories.ReceberRepository;
import com.google.common.base.Objects;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/recebimentos")
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
		model.addAttribute("total", Objects.firstNonNull(repository.totalReceber(), 0));
		model.addAttribute("totalVencer", Objects.firstNonNull(repository.totalVencer(), 0));
		model.addAttribute("totalVencido", Objects.firstNonNull(repository.totalVencido(), 0));
		model.addAttribute("totalVencendo", Objects.firstNonNull(repository.totalVencendo(), 0));
		return "/recebimentos/pendentes/pesquisar";
	}

	@GetMapping("/pendentes/incluir")
	public String incluirReceber(Model model) {
		model.addAttribute("receber", new Receber());
		return abrirCadastroReceber(model);
	}

	@GetMapping("/pendentes/editar/{id}")
	public String editarReceber(Model model, @PathVariable Long id) {
		Receber receber = repository.findOne(id);
		model.addAttribute("receber", receber);
		return abrirCadastroReceber(model);
	}

	@PostMapping("/pendentes/gravar")
	public String gravarReceber(Model model, @ModelAttribute("receber") @Valid Receber receber, BindingResult result) {
		try {
			if (!result.hasErrors()) {
				Receber receberAtualizado = repository.save(receber);
				log.info(receberAtualizado.toString() + " gravada com sucesso");
				model.addAttribute("mensagemInfo",
						config.getMessage("gravadoSucesso", new Object[] { "a conta à receber" }, null));
			}
		} catch (Exception ex) {
			log.error("Erro de processamento", ex);
			model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
		}
		return abrirCadastroReceber(model);
	}

	public String abrirCadastroReceber(Model model) {
		model.addAttribute("listagemCategorias",
				categoriaRepository.findAll(new Sort(Sort.Direction.ASC, "descricao")));
		return "/recebimentos/pendentes/cadastro";
	}

	@GetMapping("/pendentes/excluir/{id}")
	public String excluirReceber(RedirectAttributes ra, @PathVariable Long id) {
		try {
			repository.delete(id);
			log.info("Conta à receber #" + id + " excluída com sucesso");
			ra.addFlashAttribute("mensagemInfo",
					config.getMessage("excluidoSucesso", new Object[] { "a conta à receber" }, null));
		} catch (Exception ex) {
			log.error("Erro de processamento", ex);
			ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
		}
		return "redirect:/recebimentos/pendentes";
	}

	@GetMapping("/pendentes/consolidar/{id}")
	public String consolidarReceber(RedirectAttributes ra, @PathVariable Long id) {
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
			log.info("Conta à receber #" + id + " consolidada com sucesso");
			ra.addFlashAttribute("mensagemInfo",
					"A consolidação da conta " + receber.getDescricao() + " foi efetuada com sucesso");
		} catch (Exception ex) {
			log.error("Erro de processamento", ex);
			ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
		}
		return "redirect:/recebimentos/pendentes";
	}

	@GetMapping("/consolidados")
	public String consolidados(Model model,
			@RequestParam(value = "txt_data_inicio", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataInicio,
			@RequestParam(value = "txt_data_fim", required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") Date dataFim) {
		if (dataInicio != null && dataFim != null)
			model.addAttribute("listagemConsolidados",
					repository.pesquisarRecebimentosConsolidadosPorData(dataInicio, dataFim));
		return "/recebimentos/consolidados/pesquisar";
	}

	@GetMapping("/consolidados/excluir/{id}")
	public String excluirRecebido(RedirectAttributes ra, @PathVariable Long id) {
		try {
			repository.excluirRecebimentoPorId(id);
			log.info("Extornada consolidação de conta recebida #" + id);
			ra.addFlashAttribute("mensagemInfo", "Extornada consolidação de conta recebida");
		} catch (Exception ex) {
			log.error("Erro de processamento", ex);
			ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
		}
		return "redirect:/recebimentos/consolidados";
	}
}