package com.cinema.repositories;

import com.cinema.models.Achat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AchatRepository extends JpaRepository<Achat, Long> {
    
    List<Achat> findByNomAcheteur(String nomAcheteur);
    
    List<Achat> findByDtAchatBetween(LocalDateTime debut, LocalDateTime fin);
    
    @Query("SELECT a FROM Achat a JOIN a.billets b WHERE b.seance.idSeance = :idSeance")
    List<Achat> findAchatsBySeance(@Param("idSeance") Long idSeance);
    
    @Query("SELECT SUM(DISTINCT a.total) FROM Achat a JOIN a.billets b WHERE b.seance.idSeance = :idSeance")
    BigDecimal sumTotalBySeance(@Param("idSeance") Long idSeance);
    
    @Query("SELECT SUM(a.total) FROM Achat a WHERE a.dtAchat BETWEEN :debut AND :fin")
    BigDecimal sumTotalByPeriode(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);
    
    @Query("SELECT COUNT(a) FROM Achat a JOIN a.billets b WHERE b.seance.idSeance = :idSeance")
    Long countAchatsBySeance(@Param("idSeance") Long idSeance);
}
