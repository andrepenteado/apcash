
package com.andrepenteado.apscott.controllers;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.andrepenteado.apscott.models.Categoria;
import com.andrepenteado.apscott.repositories.CategoriaRepository;

@Controller
@RequestMapping("/categorias")
public class CategoriaController {

	@Autowired
	private CategoriaRepository repository;

	@GetMapping
	public String pesquisar(Model model) {
		model.addAttribute("listagemCategorias", repository.findAll());
		return "/categorias/pesquisar";
	}

	@GetMapping("/incluir")
	public String incluir(Model model) {
		model.addAttribute("categoria", new Categoria());
		return "/categorias/cadastro";
	}

	@GetMapping("/editar/{id}")
	public String editar(Model model, @PathVariable Long id) {
		Categoria categoria = repository.findOne(id);
		model.addAttribute("categoria", categoria);
		return "/categorias/cadastro";
	}

	@PostMapping("/gravar")
	public String gravar(Model model, @ModelAttribute("categoria") @Valid Categoria categoria, BindingResult result) {
		if (result.hasErrors())
			return "/categorias/cadastro";
		repository.save(categoria);
		model.addAttribute("mensagemInfo", "Categoria gravada com sucesso");
		return "/categorias/cadastro";
	}

	@GetMapping("/excluir/{id}")
	public String excluir(RedirectAttributes ra, @PathVariable Long id) {
		repository.delete(id);
		ra.addFlashAttribute("mensagemInfo", "Categoria excluída com sucesso");
		return "redirect:/categorias";
	}
}
