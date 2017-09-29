
package com.github.andrepenteado.apcash.repositories;

import com.github.andrepenteado.apcash.models.Receber;
import com.github.andrepenteado.apcash.models.Recebido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface ReceberRepository extends JpaRepository<Receber, Long> {

    @Query("SELECT r FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 ORDER BY r.dataVencimento")
    List<Receber> pesquisarPendentesAteData(LocalDate data);

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1")
    BigDecimal totalPendenteAteData(LocalDate data);

    @Query("SELECT SUM(r.valor), r.categoria.descricao FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 GROUP BY r.categoria.descricao")
    List<Object[]> totalPendenteAgrupadoPorCategoriaAteData(LocalDate data);

    @Query("SELECT SUM(r.valor), r.dataVencimento FROM Receber r WHERE r.recebimentos IS EMPTY AND r.dataVencimento <= ?1 GROUP BY r.dataVencimento ORDER BY r.dataVencimento")
    List<Object[]> totalPendenteAgrupadoPorDiaAteData(LocalDate date);

    @Query("SELECT r FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 ORDER BY r.dataRecebimento")
    List<Recebido> pesquisarLiquidadosPorDescricaoPorData(LocalDate dataInicio, LocalDate dataFim);

    @Query("SELECT SUM(r.valorRecebido) FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2")
    BigDecimal totalLiquidadoPorDescricaoPorData(LocalDate dataInicio, LocalDate dataFim);

    @Query("SELECT SUM(r.valorRecebido), r.receber.categoria.descricao FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 GROUP BY r.receber.categoria.descricao")
    List<Object[]> totalLiquidadoAgrupadoPorCategoria(LocalDate dataInicio, LocalDate dataFim);

    @Query("SELECT SUM(r.valorRecebido), r.dataRecebimento FROM Recebido r WHERE r.dataRecebimento BETWEEN ?1 AND ?2 GROUP BY r.dataRecebimento ORDER BY r.dataRecebimento")
    List<Object[]> totalLiquidadoAgrupadoPorDia(LocalDate dataInicio, LocalDate dataFim);

    @Modifying
    @Transactional
    @Query("DELETE FROM Recebido WHERE id = :id")
    void excluirRecebimentoPorId(@Param("id") Long id);
}
