package com.cinema.repositories;

import com.cinema.models.ConfigSalles;
import com.cinema.models.Salle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigSallesRepository extends JpaRepository<ConfigSalles, Long> {
    List<ConfigSalles> findBySalle(Salle salle);
    List<ConfigSalles> findBySalleIdSalle(Long idSalle);
    
    @Modifying
    @Query("DELETE FROM ConfigSalles c WHERE c.salle.idSalle = ?1")
    void deleteBySalleIdSalle(Long idSalle);
}
