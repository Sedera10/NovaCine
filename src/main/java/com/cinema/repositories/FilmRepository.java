package com.cinema.repositories;

import com.cinema.models.Film;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FilmRepository extends JpaRepository<Film, Long> {
    // Recherche simple par titre
    java.util.List<Film> findByTitreContainingIgnoreCase(String titre);
}
