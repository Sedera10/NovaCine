package com.cinema.repositories;

import com.cinema.models.ConfigSalles;
import com.cinema.models.Salle;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigSallesRepository extends JpaRepository<ConfigSalles, Long>{
    List<ConfigSalles> findBySalle(Salle salle);
    List<ConfigSalles> findBySalleIdSalle(Long idSalle);
    
    @Query("SELECT SUM(c.nombrePlaces) FROM ConfigSalles c WHERE c.salle.idSalle = :idSalle")
    Integer sumNombrePlacesByIdSalle(@Param("idSalle") Long idSalle);
}
