
package com.andrepenteado.apscott.controllers;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.data.domain.Sort;
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
import com.andrepenteado.apscott.models.DespesaReceita;
import com.andrepenteado.apscott.repositories.CategoriaRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    private CategoriaRepository repository;

    @Autowired
    private MessageSource config;

    @GetMapping
    public String pesquisar(Model model) {
        model.addAttribute("listagemCategorias", repository.findAll(new Sort(Sort.Direction.ASC, "descricao")));
        return "/categorias/pesquisar";
    }

    @GetMapping("/incluir")
    public String incluir(Model model) {
        model.addAttribute("categoria", new Categoria());
        return abrirCadastroCategoria(model);
    }

    @GetMapping("/editar/{id}")
    public String editar(Model model, @PathVariable Long id) {
        Categoria categoria = repository.findOne(id);
        model.addAttribute("categoria", categoria);
        return abrirCadastroCategoria(model);
    }

    public String abrirCadastroCategoria(Model model) {
        model.addAttribute("tipos", DespesaReceita.values());
        return "/categorias/cadastro";
    }

    @PostMapping("/gravar")
    public String gravar(Model model, @ModelAttribute("categoria") @Valid Categoria categoria, BindingResult result) {
        try {
            if (!result.hasErrors()) {
                Categoria categoriaAtualizada = repository.save(categoria);
                log.info(categoriaAtualizada.toString() + " gravada com sucesso");
                model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "a categoria" }, null));
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return abrirCadastroCategoria(model);
    }

    @GetMapping("/excluir/{id}")
    public String excluir(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.delete(id);
            log.info("Categoria #" + id + " excluída com sucesso");
            ra.addFlashAttribute("mensagemInfo", config.getMessage("excluidoSucesso", new Object[] { "a categoria" }, null));
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/categorias";
    }
}
