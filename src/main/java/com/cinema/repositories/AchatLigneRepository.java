package com.cinema.repositories;

import com.cinema.models.AchatLigne;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AchatLigneRepository extends JpaRepository<AchatLigne, Long> {
    
    /**
     * Compte le nombre de billets vendus par type de place pour une séance
     */
    @Query("SELECT al.typePlace.id, SUM(al.quantite) FROM AchatLigne al " +
           "WHERE al.achat.seance.idSeance = :idSeance " +
           "GROUP BY al.typePlace.id")
    List<Object[]> countBilletsVendusParTypePlaceBySeance(@Param("idSeance") Long idSeance);
    
    /**
     * Récupère toutes les lignes d'achat pour une séance
     */
    @Query("SELECT al FROM AchatLigne al WHERE al.achat.seance.idSeance = :idSeance")
    List<AchatLigne> findBySeanceId(@Param("idSeance") Long idSeance);
}
