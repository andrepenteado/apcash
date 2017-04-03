
package com.github.andrepenteado.apscott.controllers;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.github.andrepenteado.apscott.repositories.PagarRepository;
import com.github.andrepenteado.apscott.repositories.ReceberRepository;

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
        Calendar hoje = Calendar.getInstance();
        Calendar tresMesesAtras = Calendar.getInstance();
        Calendar proximoTrintaDias = Calendar.getInstance();
        tresMesesAtras.add(Calendar.DAY_OF_MONTH, -91);
        proximoTrintaDias.add(Calendar.DAY_OF_MONTH, 30);

        /****************** Gráfico contas pendentes **********************/

        Map<Date, BigDecimal[]> graficoPendentesPorDia = new TreeMap<Date, BigDecimal[]>();
        List<Object[]> receberPorDia = receberRepository.totalPendenteAgrupadoPorDiaAteData(proximoTrintaDias.getTime());
        List<Object[]> pagarPorDia = pagarRepository.totalPendenteAgrupadoPorDiaAteData(proximoTrintaDias.getTime());

        // Coloca os valores a receber com chave data e valor na posição do array 0
        for (Object[] receber : receberPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)receber[0];

            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)receber[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoPendentesPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de receber [posição 0]
            if (itemGrafico != null)
                itemGrafico[0] = currVal;
            else
                itemGrafico = new BigDecimal[] { currVal, new BigDecimal(0) };
            graficoPendentesPorDia.put(currDay, itemGrafico);
        }

        // Coloca os valores a receber com chave data e valor na posição do array 1
        for (Object[] pagar : pagarPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)pagar[0];

            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)pagar[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoPendentesPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de pagar [posição 1]
            if (itemGrafico != null)
                itemGrafico[1] = currVal;
            else
                itemGrafico = new BigDecimal[] { new BigDecimal(0), currVal };
            graficoPendentesPorDia.put(currDay, itemGrafico);
        }

        // Acerta Map do grafico, somando os valores conforme as datas passam [eliminam os 0]
        BigDecimal somadoPagar = new BigDecimal(0);
        BigDecimal somadoReceber = new BigDecimal(0);
        for (Date dia : graficoPendentesPorDia.keySet()) {
            BigDecimal[] receberPagar = graficoPendentesPorDia.get(dia);
            somadoReceber = somadoReceber.add(receberPagar[0]);
            somadoPagar = somadoPagar.add(receberPagar[1]);
            graficoPendentesPorDia.put(dia, new BigDecimal[] { somadoReceber, somadoPagar });
        }

        model.addAttribute("graficoPendentesPorDia", graficoPendentesPorDia);

        /****************** Gráfico liquidados últimos 30 dias ***************************/

        Map<Date, BigDecimal[]> graficoLiquidadosPorDia = new TreeMap<Date, BigDecimal[]>();
        List<Object[]> recebidoPorDia = receberRepository.totalLiquidadoAgrupadoPorDia(tresMesesAtras.getTime(), hoje.getTime());
        List<Object[]> pagoPorDia = pagarRepository.totalLiquidadoAgrupadoPorDia(tresMesesAtras.getTime(), hoje.getTime());

        // Coloca os valores a receber com chave data e valor na posição do array 0
        for (Object[] recebido : recebidoPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)recebido[0];

            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)recebido[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoLiquidadosPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de receber [posição 0]
            if (itemGrafico != null)
                itemGrafico[0] = currVal;
            else
                itemGrafico = new BigDecimal[] { currVal, new BigDecimal(0) };
            graficoLiquidadosPorDia.put(currDay, itemGrafico);
        }

        // Coloca os valores a receber com chave data e valor na posição do array 1
        for (Object[] pago : pagoPorDia) {
            // Valor atual [posição 0 da consulta JPQL é o valor]
            BigDecimal currVal = (BigDecimal)pago[0];

            // posição 1 da consulta JPQL é a data
            Date currDay = (Date)pago[1];

            // Tentar pegar os valores da data selecionada pelo for
            BigDecimal[] itemGrafico = graficoLiquidadosPorDia.get(currDay);

            // Se já existe entrada para esta data, atualiza valor de pagar [posição 1]
            if (itemGrafico != null)
                itemGrafico[1] = currVal;
            else
                itemGrafico = new BigDecimal[] { new BigDecimal(0), currVal };
            graficoLiquidadosPorDia.put(currDay, itemGrafico);
        }

        // Acerta Map do grafico, somando os valores conforme as datas passam [eliminam os 0]
        BigDecimal somadoPago = new BigDecimal(0);
        BigDecimal somadoRecebido = new BigDecimal(0);
        for (Date dia : graficoLiquidadosPorDia.keySet()) {
            BigDecimal[] recebidoPago = graficoLiquidadosPorDia.get(dia);
            somadoRecebido = somadoRecebido.add(recebidoPago[0]);
            somadoPago = somadoPago.add(recebidoPago[1]);
            graficoLiquidadosPorDia.put(dia, new BigDecimal[] { somadoRecebido, somadoPago });
        }

        model.addAttribute("graficoLiquidadosPorDia", graficoLiquidadosPorDia);
        return "/dashboard";
    }
}
