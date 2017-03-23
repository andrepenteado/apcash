
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
	BigDecimal totalReceber();

	@Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento < CURRENT_DATE AND r.recebimentos IS EMPTY GROUP BY r.dataVencimento")
	BigDecimal totalVencido();

	@Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento = CURRENT_DATE AND r.recebimentos IS EMPTY")
	BigDecimal totalVencendo();

	@Query("SELECT SUM(r.valor) FROM Receber r WHERE r.dataVencimento > CURRENT_DATE AND r.recebimentos IS EMPTY")
	BigDecimal totalVencer();

	@Query("SELECT r FROM Recebido r WHERE r.dataRecebimento BETWEEN :dataInicio AND :dataFim ORDER BY r.dataRecebimento")
	List<Recebido> pesquisarRecebimentosConsolidadosPorData(@Param("dataInicio") Date dataInicio,
			@Param("dataFim") Date dataFim);

	@Modifying
	@Transactional
	@Query("DELETE FROM Recebido WHERE id = :id")
	void excluirRecebimentoPorId(@Param("id") Long id);
}
