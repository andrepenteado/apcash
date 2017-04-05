
package com.github.andrepenteado.apcash.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.github.andrepenteado.apcash.models.Categoria;
import com.github.andrepenteado.apcash.models.DespesaReceita;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    @Query("SELECT c FROM Categoria c WHERE c.despesaReceita = :tipo ORDER BY c.descricao")
    List<Categoria> pesquisarPorTipo(@Param("tipo") DespesaReceita despesaReceita);
}
