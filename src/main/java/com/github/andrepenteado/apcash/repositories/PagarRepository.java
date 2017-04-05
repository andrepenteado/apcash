
package com.github.andrepenteado.apcash.repositories;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.github.andrepenteado.apcash.models.Pagar;
import com.github.andrepenteado.apcash.models.Pago;

public interface PagarRepository extends JpaRepository<Pagar, Long> {

    @Query("SELECT p FROM Pagar p WHERE p.pagamentos IS EMPTY AND p.dataVencimento <= ?1 ORDER BY p.dataVencimento")
    List<Pagar> pesquisarPendentesAteData(Date data);

    @Query("SELECT SUM(p.valor) FROM Pagar p WHERE p.pagamentos IS EMPTY AND p.dataVencimento <= ?1")
    BigDecimal totalPendenteAteData(Date data);

    @Query("SELECT SUM(p.valor), p.categoria.descricao FROM Pagar p WHERE p.pagamentos IS EMPTY AND p.dataVencimento <= ?1 GROUP BY p.categoria.descricao")
    List<Object[]> totalPendenteAgrupadoPorCategoriaAteData(Date data);

    @Query("SELECT SUM(p.valor), p.dataVencimento FROM Pagar p WHERE p.pagamentos IS EMPTY AND p.dataVencimento <= ?1 GROUP BY p.dataVencimento ORDER BY p.dataVencimento")
    List<Object[]> totalPendenteAgrupadoPorDiaAteData(Date date);

    @Query("SELECT p FROM Pago p WHERE p.dataPagamento BETWEEN ?1 AND ?2 ORDER BY p.dataPagamento")
    List<Pago> pesquisarLiquidadosPorDescricaoPorData(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(p.valorPago) FROM Pago p WHERE p.dataPagamento BETWEEN ?1 AND ?2")
    BigDecimal totalLiquidadoPorDescricaoPorData(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(p.valorPago), p.pagar.categoria.descricao FROM Pago p WHERE p.dataPagamento BETWEEN ?1 AND ?2 GROUP BY p.pagar.categoria.descricao")
    List<Object[]> totalLiquidadoAgrupadoPorCategoria(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(p.valorPago), p.dataPagamento FROM Pago p WHERE p.dataPagamento BETWEEN ?1 AND ?2 GROUP BY p.dataPagamento ORDER BY p.dataPagamento")
    List<Object[]> totalLiquidadoAgrupadoPorDia(Date dataInicio, Date dataFim);

    @Modifying
    @Transactional
    @Query("DELETE FROM Pago WHERE id = :id")
    void excluirPagamentoPorId(@Param("id") Long id);
}
