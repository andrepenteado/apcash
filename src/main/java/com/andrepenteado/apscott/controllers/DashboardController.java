
package com.andrepenteado.apscott.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping(value = { "", "/", "/dashboard" })
    public String paginaInicial() {
        return "/dashboard";
    }
}
