package com.github.andrepenteado.apcash.controllers;

import com.github.andrepenteado.apcash.models.Cliente;
import com.github.andrepenteado.apcash.repositories.ClienteRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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

import javax.validation.Valid;
import java.time.LocalDateTime;

@Slf4j
@Controller
@RequestMapping("/clientes")
public class ClientesController {

    @Autowired
    private MessageSource config;

    @Autowired
    private ClienteRepository repository;

    @Value("${label.cliente}")
    private String labelCliente;

    @GetMapping
    private String pesquisar(Model model) {
        model.addAttribute("listagemClientes", repository.findAll(new Sort(Sort.Direction.ASC, "nome")));
        return "/clientes/pesquisar";
    }

    @GetMapping("/incluir")
    public String incluir(Model model) {
        model.addAttribute("cliente", new Cliente());
        return abrirCadastroCliente(model);
    }

    @GetMapping("/editar/{id}")
    public String editar(Model model, @PathVariable Long id) {
        model.addAttribute("cliente", repository.findById(id).get());
        return abrirCadastroCliente(model);
    }

    public String abrirCadastroCliente(Model model) {
        return "/clientes/cadastro";
    }

    @PostMapping("/gravar")
    public String gravar(Model model, @ModelAttribute("cliente") @Valid Cliente cliente, BindingResult result) {
        try {
            if (!result.hasErrors()) {
                if (cliente.getId() != null && cliente.getId() > 0l) {
                    cliente.setDataUltimaAtualizacao(LocalDateTime.now());
                }
                else {
                    cliente.setDataCadastro(LocalDateTime.now());
                }
                Cliente clienteAtualizado = repository.save(cliente);
                log.info(clienteAtualizado.toString() + " gravado com sucesso");
                model.addAttribute("mensagemInfo", config.getMessage("gravadoSucesso", new Object[] { "o " + labelCliente }, null));
            }
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            model.addAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return abrirCadastroCliente(model);
    }

    @GetMapping("/excluir/{id}")
    public String excluir(RedirectAttributes ra, @PathVariable Long id) {
        try {
            repository.deleteById(id);
            log.info(labelCliente + " #" + id + " excluído com sucesso");
            ra.addFlashAttribute("mensagemInfo", config.getMessage("excluidoSucesso", new Object[] { "o " + labelCliente }, null));
        }
        catch (Exception ex) {
            log.error("Erro de processamento", ex);
            ra.addFlashAttribute("mensagemErro", config.getMessage("erroProcessamento", null, null));
        }
        return "redirect:/clientes";
    }
}
