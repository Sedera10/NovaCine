package com.cinema.repositories;

import com.cinema.models.PaiementDetail;
import com.cinema.models.Diffusion;
import com.cinema.models.PaiementPub;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaiementDetailRepository extends JpaRepository<PaiementDetail, Long> {
    
    List<PaiementDetail> findByPaiement(PaiementPub paiement);
    
    List<PaiementDetail> findByDiffusion(Diffusion diffusion);
    
    @Query("SELECT pd FROM PaiementDetail pd WHERE pd.paiement.societe.idSociete = :idSociete")
    List<PaiementDetail> findBySociete(@Param("idSociete") Long idSociete);
}
