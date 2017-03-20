
package com.andrepenteado.apscott.repositories;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.andrepenteado.apscott.models.Receber;

public interface ReceberRepository extends JpaRepository<Receber, Long> {

    @Query("SELECT r FROM Receber r WHERE r.recebimentos IS EMPTY ORDER BY r.dataVencimento")
    List<Receber> pesquisarReceber();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.recebimentos IS EMPTY")
    BigDecimal totalReceber();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento < CURRENT_DATE AND r.recebimentos IS EMPTY GROUP BY r.dataVencimento")
    BigDecimal totalVencido();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento = CURRENT_DATE AND r.recebimentos IS EMPTY")
    BigDecimal totalVencendo();

    @Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento > CURRENT_DATE AND r.recebimentos IS EMPTY")
    BigDecimal totalVencer();
}
