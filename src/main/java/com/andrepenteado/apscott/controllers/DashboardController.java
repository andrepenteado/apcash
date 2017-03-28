
package com.andrepenteado.apscott.controllers;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.andrepenteado.apscott.repositories.PagarRepository;
import com.andrepenteado.apscott.repositories.ReceberRepository;

@Controller
public class DashboardController {

    @Autowired
    private ReceberRepository receberRepository;

    @Autowired
    private PagarRepository pagarRepository;

    @GetMapping(value = { "/index" })
    public String paginaInicial() {
        return "/pagina-inicial";
    }

    @GetMapping(value = { "/dashboard" })
    public String dashboard(Model model) {
        Map<Date, BigDecimal[]> graficoPorDia = new TreeMap<Date, BigDecimal[]>();
        List<Object[]> receberPorDia = receberRepository.somarTotalPendenteAgrupadoPorDia();
        List<Object[]> pagarPorDia = pagarRepository.somarTotalPendenteAgrupadoPorDia();

        // Coloca os valores a receber com chave data e valor na posição do array 0
        for (Object[] receber : receberPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)receber[0];

            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)receber[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de receber [posição 0]
            if (itemGrafico != null)
                itemGrafico[0] = currVal;
            else
                itemGrafico = new BigDecimal[] { currVal, new BigDecimal(0) };
            graficoPorDia.put(currDay, itemGrafico);
        }

        // Coloca os valores a receber com chave data e valor na posição do array 1
        for (Object[] pagar : pagarPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)pagar[0];
            
            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)pagar[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de pagar [posição 1]
            if (itemGrafico != null)
                itemGrafico[1] = currVal;
            else
                itemGrafico = new BigDecimal[] { new BigDecimal(0), currVal };
            graficoPorDia.put(currDay, itemGrafico);
        }

        // Acerta Map do grafico, somando os valores conforme as datas passam [eliminam os 0]
        BigDecimal somadoPagar = new BigDecimal(0);
        BigDecimal somadoReceber = new BigDecimal(0);
        for (Date dia : graficoPorDia.keySet()) {
            BigDecimal[] receberPagar = graficoPorDia.get(dia);
            somadoReceber = somadoReceber.add(receberPagar[0]);
            somadoPagar = somadoPagar.add(receberPagar[1]);
            graficoPorDia.put(dia, new BigDecimal[] { somadoReceber, somadoPagar });
        }

        model.addAttribute("graficoPorDia", graficoPorDia);
        return "/dashboard";
    }
}
