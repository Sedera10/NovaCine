package com.cinema.repositories;

import com.cinema.models.ContratPub;
import com.cinema.models.Societe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ContratPubRepository extends JpaRepository<ContratPub, Long> {
    
    List<ContratPub> findBySociete(Societe societe);
    
    /**
     * Trouve un contrat actif pour une société à un mois donné
     * Si plusieurs contrats existent, retourne le plus récent
     */
    @Query("SELECT c FROM ContratPub c WHERE c.societe = :societe " +
           "AND FUNCTION('date_trunc', 'month', CAST(c.dtContrat AS timestamp)) = " +
           "FUNCTION('date_trunc', 'month', CAST(:date AS timestamp)) " +
           "ORDER BY c.dtContrat DESC")
    List<ContratPub> findBySocieteAndMonth(@Param("societe") Societe societe, 
                                            @Param("date") LocalDate date);
    
    /**
     * Calcule le CA maximum (théorique) des contrats pour un mois donné
     * CA maximum = Somme de (quota × prix) pour tous les contrats du mois
     */
    @Query(value = "SELECT COALESCE(SUM(c.quota * p.valeur), 0) " +
           "FROM contrats_pubs c " +
           "JOIN prix_pubs p ON c.id_prix = p.id_prix " +
           "WHERE EXTRACT(YEAR FROM c.dt_contrat) = EXTRACT(YEAR FROM CAST(:date AS DATE)) " +
           "AND EXTRACT(MONTH FROM c.dt_contrat) = EXTRACT(MONTH FROM CAST(:date AS DATE))", 
           nativeQuery = true)
    BigDecimal calculerCAMaximumParMois(@Param("date") LocalDate date);
}
