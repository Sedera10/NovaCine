package com.cinema.repositories;

import com.cinema.models.Billet;
import com.cinema.models.Place;
import com.cinema.models.Seance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BilletRepository extends JpaRepository<Billet, Long> {
    
    List<Billet> findBySeance(Seance seance);
    
    List<Billet> findBySeanceIdSeance(Long idSeance);
    
    Optional<Billet> findByPlaceAndSeance(Place place, Seance seance);
    
    boolean existsByPlaceIdPlaceAndSeanceIdSeance(Long idPlace, Long idSeance);
    
    @Query("SELECT b FROM Billet b WHERE b.seance.idSeance = :idSeance AND b NOT IN " +
           "(SELECT ab FROM Achat a JOIN a.billets ab WHERE a.idAchat IS NOT NULL)")
    List<Billet> findBilletsDisponiblesBySeance(@Param("idSeance") Long idSeance);
    
    @Query("SELECT COUNT(b) FROM Billet b WHERE b.seance.idSeance = :idSeance")
    Long countBySeanceIdSeance(@Param("idSeance") Long idSeance);
    
    @Query("SELECT COUNT(ab) FROM Achat a JOIN a.billets ab WHERE ab.seance.idSeance = :idSeance")
    Long countBilletsVendusBySeance(@Param("idSeance") Long idSeance);
}
