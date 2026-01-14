package com.cinema.repositories;

import com.cinema.models.Place;
import com.cinema.models.Salle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlaceRepository extends JpaRepository<Place, Long> {
    
    List<Place> findBySalle(Salle salle);
    
    List<Place> findBySalleIdSalle(Long idSalle);
    
    Optional<Place> findByCodePlaceAndSalleIdSalle(String codePlace, Long idSalle);
    
    @Query("SELECT COUNT(p) FROM Place p WHERE p.salle.idSalle = :idSalle")
    Long countBySalleIdSalle(Long idSalle);
    
    boolean existsByCodePlaceAndSalleIdSalle(String codePlace, Long idSalle);
}
