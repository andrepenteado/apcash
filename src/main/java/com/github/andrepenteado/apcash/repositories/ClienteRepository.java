package com.github.andrepenteado.apcash.repositories;

import com.github.andrepenteado.apcash.models.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {
}
