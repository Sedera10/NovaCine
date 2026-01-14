package com.cinema.repositories;

import com.cinema.models.Seance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface SeanceRepository extends JpaRepository<Seance, Long> {
    
    List<Seance> findByFilmIdFilm(Long idFilm);
    
    List<Seance> findBySalleIdSalle(Long idSalle);
    
    List<Seance> findByDaty(LocalDate date);
    
    List<Seance> findByDatyBetween(LocalDate debut, LocalDate fin);
    
    @Query("SELECT s FROM Seance s WHERE s.daty >= :dateDebut ORDER BY s.daty ASC, s.heure ASC")
    List<Seance> findSeancesAVenir(@Param("dateDebut") LocalDate dateDebut);
    
    @Query("SELECT s FROM Seance s WHERE s.film.idFilm = :idFilm AND s.daty >= :dateMin ORDER BY s.daty, s.heure")
    List<Seance> findByFilmEtDateMin(@Param("idFilm") Long idFilm, @Param("dateMin") LocalDate dateMin);
    
    boolean existsByDatyAndHeureAndSalleIdSalle(LocalDate daty, LocalTime heure, Long idSalle);
}
