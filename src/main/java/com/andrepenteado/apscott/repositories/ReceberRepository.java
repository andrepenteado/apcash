
package com.andrepenteado.apscott.repositories;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.andrepenteado.apscott.models.Receber;
import com.andrepenteado.apscott.models.Recebido;

public interface ReceberRepository extends JpaRepository<Receber, Long> {

    @Query("SELECT r FROM Receber r WHERE r.recebimentos IS EMPTY ORDER BY r.dataVencimento")
    List<Receber> pesquisarRecebimentosPendentes();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.recebimentos IS EMPTY")
    BigDecimal somarTotalReceber();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento < CURRENT_DATE AND r.recebimentos IS EMPTY GROUP BY r.dataVencimento")
    BigDecimal somarTotalVencido();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento = CURRENT_DATE AND r.recebimentos IS EMPTY")
    BigDecimal somarTotalVencendo();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento > CURRENT_DATE AND r.recebimentos IS EMPTY")
    BigDecimal somarTotalVencer();

    @Query("SELECT r FROM Recebido r WHERE lower(r.receber.descricao) LIKE concat('%', lower(?1), '%') AND r.dataRecebimento BETWEEN ?2 AND ?3 ORDER BY r.dataRecebimento")
    List<Recebido> pesquisarRecebidoPorDescricaoPorData(String descricao, Date dataInicio, Date dataFim);

    @Query("SELECT SUM(r.valorRecebido) FROM Recebido r WHERE UPPER(r.receber.descricao) LIKE concat('%', lower(?1), '%') AND r.dataRecebimento BETWEEN ?2 AND ?3")
    BigDecimal somarRecebidoPorDescricaoPorData(String descricao, Date dataInicio, Date dataFim);

    @Modifying
    @Transactional
    @Query("DELETE FROM Recebido WHERE id = :id")
    void excluirRecebimentoPorId(@Param("id") Long id);
}
