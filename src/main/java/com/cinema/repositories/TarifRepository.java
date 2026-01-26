package com.cinema.repositories;

import com.cinema.models.Tarif;
import com.cinema.models.Seance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface TarifRepository extends JpaRepository<Tarif, Long> {
    
    /**
     * Récupère tous les tarifs d'une séance
     */
    List<Tarif> findBySeance(Seance seance);
    
    /**
     * Récupère tous les tarifs d'une séance par son ID
     */
    List<Tarif> findBySeanceIdSeance(Long idSeance);
    
    /**
     * Récupère le tarif pour une combinaison séance/typePlace/typeClient
     */
    @Query("SELECT t FROM Tarif t WHERE t.seance.idSeance = :idSeance " +
           "AND t.typePlace.id = :idTypePlace AND t.typeClient.idTypeClient = :idTypeClient")
    Optional<Tarif> findBySeanceAndTypePlaceAndTypeClient(
            @Param("idSeance") Long idSeance,
            @Param("idTypePlace") Long idTypePlace,
            @Param("idTypeClient") Long idTypeClient);
    
    /**
     * Récupère la valeur du tarif (pour API AJAX)
     */
    @Query("SELECT t.valeur FROM Tarif t WHERE t.seance.idSeance = :idSeance " +
           "AND t.typePlace.id = :idTypePlace AND t.typeClient.idTypeClient = :idTypeClient")
    Optional<BigDecimal> findValeurBySeanceAndTypePlaceAndTypeClient(
            @Param("idSeance") Long idSeance,
            @Param("idTypePlace") Long idTypePlace,
            @Param("idTypeClient") Long idTypeClient);
}
