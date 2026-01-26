package com.cinema.repositories;

import com.cinema.models.Diffusion;
import com.cinema.models.Seance;
import com.cinema.models.Societe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface DiffusionRepository extends JpaRepository<Diffusion, Long> {
    
    List<Diffusion> findBySociete(Societe societe);
    
    List<Diffusion> findBySeance(Seance seance);
    
    @Query("SELECT d FROM Diffusion d WHERE d.dtDiffusion BETWEEN :debut AND :fin")
    List<Diffusion> findByPeriod(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);
    
    @Query(value = "SELECT COALESCE(SUM(d.nombre_diffusions), 0) FROM diffusions d " +
           "WHERE d.id_societe = :#{#societe.idSociete} " +
           "AND EXTRACT(YEAR FROM d.dt_diffusion) = EXTRACT(YEAR FROM CAST(:date AS DATE)) " +
           "AND EXTRACT(MONTH FROM d.dt_diffusion) = EXTRACT(MONTH FROM CAST(:date AS DATE))", 
           nativeQuery = true)
    Long countDiffusionsByMonth(@Param("societe") Societe societe, @Param("date") LocalDate date);
    
    /**
     * Calcule le CA réel des diffusions pour un mois donné
     * CA = Somme de (nombreDiffusions × prix du contrat)
     */
    @Query(value = "SELECT COALESCE(SUM(d.nombre_diffusions * p.valeur), 0) " +
           "FROM diffusions d " +
           "JOIN contrats_pubs c ON d.id_societe = c.id_societe " +
           "JOIN prix_pubs p ON c.id_prix = p.id_prix " +
           "WHERE EXTRACT(YEAR FROM d.dt_diffusion) = EXTRACT(YEAR FROM CAST(:date AS DATE)) " +
           "AND EXTRACT(MONTH FROM d.dt_diffusion) = EXTRACT(MONTH FROM CAST(:date AS DATE)) " +
           "AND EXTRACT(YEAR FROM c.dt_contrat) = EXTRACT(YEAR FROM CAST(:date AS DATE)) " +
           "AND EXTRACT(MONTH FROM c.dt_contrat) = EXTRACT(MONTH FROM CAST(:date AS DATE))", 
           nativeQuery = true)
    BigDecimal calculerCAReelParMois(@Param("date") LocalDate date);
}
