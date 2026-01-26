package com.cinema.repositories;

import com.cinema.models.PaiementPub;
import com.cinema.models.Societe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PaiementPubRepository extends JpaRepository<PaiementPub, Long> {
    
    List<PaiementPub> findBySociete(Societe societe);
    
    /**
     * Récupère tous les paiements d'une société entre deux dates
     */
    @Query("SELECT p FROM PaiementPub p WHERE p.societe = :societe " +
           "AND p.dtPaiement BETWEEN :debut AND :fin " +
           "ORDER BY p.dtPaiement DESC")
    List<PaiementPub> findBySocieteAndPeriod(@Param("societe") Societe societe,
                                              @Param("debut") LocalDate debut,
                                              @Param("fin") LocalDate fin);
    
    /**
     * Calcule le total des paiements d'une société entre deux dates
     */
    @Query("SELECT COALESCE(SUM(p.montant), 0) FROM PaiementPub p " +
           "WHERE p.societe = :societe " +
           "AND p.dtPaiement BETWEEN :debut AND :fin")
    java.math.BigDecimal sumBySocieteAndPeriod(@Param("societe") Societe societe,
                                                @Param("debut") LocalDate debut,
                                                @Param("fin") LocalDate fin);
    
    /**
     * Récupère tous les paiements d'une société jusqu'à une date donnée
     */
    @Query("SELECT p FROM PaiementPub p WHERE p.societe = :societe " +
           "AND p.dtPaiement <= :date " +
           "ORDER BY p.dtPaiement DESC")
    List<PaiementPub> findBySocieteUntilDate(@Param("societe") Societe societe,
                                              @Param("date") LocalDate date);
}
