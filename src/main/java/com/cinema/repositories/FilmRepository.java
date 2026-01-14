package com.cinema.repositories;

import com.cinema.models.Film;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface FilmRepository extends JpaRepository<Film, Long> {
    
    List<Film> findByTitreContainingIgnoreCase(String titre);
    
    List<Film> findByDtSortieBetween(LocalDate debut, LocalDate fin);
    
    @Query("SELECT f FROM Film f ORDER BY f.dtSortie DESC")
    List<Film> findAllOrderByDateSortieDesc();
    
    @Query("SELECT f FROM Film f WHERE f.dtSortie <= CURRENT_DATE ORDER BY f.dtSortie DESC")
    List<Film> findFilmsSortis();
}
