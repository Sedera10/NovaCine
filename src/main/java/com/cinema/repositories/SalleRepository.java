package com.cinema.repositories;

import com.cinema.models.Salle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SalleRepository extends JpaRepository<Salle, Long> {
    
    Optional<Salle> findByNom(String nom);
    
    List<Salle> findByCapaciteGreaterThanEqual(Integer capaciteMin);
    
    @Query("SELECT s FROM Salle s ORDER BY s.nom ASC")
    List<Salle> findAllOrderByNom();
}

