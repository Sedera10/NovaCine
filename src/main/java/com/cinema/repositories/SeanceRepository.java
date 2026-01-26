package com.cinema.repositories;

import com.cinema.models.Seance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SeanceRepository extends JpaRepository<Seance, Long> {
    
    /**
     * Récupère les séances entre deux dates
     */
    List<Seance> findByDateSeanceBetween(LocalDate debut, LocalDate fin);
}
