package com.andrepenteado.apscott.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.andrepenteado.apscott.models.Receber;

public interface ReceberRepository extends JpaRepository<Receber, Long> {

	List<Receber> findByRecebimentosIsNullOrderByDataVencimentoAsc();
}
