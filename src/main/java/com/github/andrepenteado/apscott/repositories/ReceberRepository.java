
package com.github.andrepenteado.apscott.repositories;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.github.andrepenteado.apscott.models.Receber;
import com.github.andrepenteado.apscott.models.Recebido;

public interface ReceberRepository extends JpaRepository<Receber, Long> {

    @Query("SELECT r FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 ORDER BY r.dataVencimento")
    List<Receber> pesquisarPendentesAteData(Date data);

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1")
    BigDecimal totalPendenteAteData(Date data);

    @Query("SELECT SUM(r.valor), r.categoria.descricao FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 GROUP BY r.categoria.descricao")
    List<Object[]> totalPendenteAgrupadoPorCategoriaAteData(Date data);

    @Query("SELECT SUM(r.valor), r.dataVencimento FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 GROUP BY r.dataVencimento ORDER BY r.dataVencimento")
    List<Object[]> totalPendenteAgrupadoPorDiaAteData(Date date);

    @Query("SELECT r FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 ORDER BY r.dataRecebimento")
    List<Recebido> pesquisarLiquidadosPorDescricaoPorData(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(r.valorRecebido) FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2")
    BigDecimal totalLiquidadoPorDescricaoPorData(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(r.valorRecebido), r.receber.categoria.descricao FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 GROUP BY r.receber.categoria.descricao")
    List<Object[]> totalLiquidadoAgrupadoPorCategoria(Date dataInicio, Date dataFim);

    @Query("SELECT SUM(r.valorRecebido), r.dataRecebimento FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 GROUP BY r.dataRecebimento ORDER BY r.dataRecebimento")
    List<Object[]> totalLiquidadoAgrupadoPorDia(Date dataInicio, Date dataFim);

    @Modifying
    @Transactional
    @Query("DELETE FROM Recebido WHERE id = :id")
    void excluirRecebimentoPorId(@Param("id") Long id);
}
