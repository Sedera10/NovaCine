package com.cinema.repositories;

import com.cinema.models.Achat;
import com.cinema.models.Seance;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AchatRepository extends JpaRepository<Achat, Long> {
    List<Achat> findBySeanceIdSeance(Long idSeance);
    
    /**
     * Récupère les achats entre deux dates de séance
     */
    @Query("SELECT a FROM Achat a WHERE a.seance.dateSeance BETWEEN :debut AND :fin")
    List<Achat> findBySeanceDateSeanceBetween(
        @Param("debut") LocalDate debut,
        @Param("fin") LocalDate fin
    );

    // @Query("SELECT a FROM Achat a WHERE a.seance.dateSeance BETWEEN :debut AND :fin")
    // List<Achat> findBySeanceDateSeanceBetween(Seance seance,
    //     @Param("debut") LocalDate debut,
    //     @Param("fin") LocalDate fin
    // );
    
    /**
     * Récupère les achats entre deux dates d'achat (TOUS les achats, payés ou non)
     */
    @Query("SELECT a FROM Achat a WHERE a.dtAchat BETWEEN :debut AND :fin")
    List<Achat> findByDtAchatBetween(
        @Param("debut") LocalDateTime debut,
        @Param("fin") LocalDateTime fin
    );
}
