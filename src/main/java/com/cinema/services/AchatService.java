package com.cinema.services;

import com.cinema.models.*;
import com.cinema.repositories.AchatRepository;
import com.cinema.repositories.BilletRepository;
import com.cinema.repositories.SeanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class AchatService {
    
    @Autowired
    private AchatRepository achatRepository;
    
    @Autowired
    private BilletRepository billetRepository;
    
    @Autowired
    private SeanceRepository seanceRepository;
    
    public List<Achat> getAllAchats() {
        return achatRepository.findAll();
    }
    
    public Achat getAchatById(Long id) {
        return achatRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Achat non trouvé avec l'ID: " + id));
    }
    
    public List<Achat> getAchatsBySeance(Long idSeance) {
        return achatRepository.findAchatsBySeance(idSeance);
    }
    
    public List<Achat> getAchatsByPeriode(LocalDateTime debut, LocalDateTime fin) {
        return achatRepository.findByDtAchatBetween(debut, fin);
    }
    
    public BigDecimal getTotalVentesBySeance(Long idSeance) {
        BigDecimal total = achatRepository.sumTotalBySeance(idSeance);
        return total != null ? total : BigDecimal.ZERO;
    }
    
    public BigDecimal getTotalVentesByPeriode(LocalDateTime debut, LocalDateTime fin) {
        BigDecimal total = achatRepository.sumTotalByPeriode(debut, fin);
        return total != null ? total : BigDecimal.ZERO;
    }
    
    public Long countAchatsBySeance(Long idSeance) {
        return achatRepository.countAchatsBySeance(idSeance);
    }
    
    @Transactional
    public Achat createAchat(String nomAcheteur, List<Long> idsBillets) {
        if (idsBillets == null || idsBillets.isEmpty()) {
            throw new RuntimeException("La liste des billets ne peut pas être vide");
        }
        
        List<Billet> billets = billetRepository.findAllById(idsBillets);
        
        if (billets.size() != idsBillets.size()) {
            throw new RuntimeException("Un ou plusieurs billets n'ont pas été trouvés");
        }
        
        // Vérifier que les billets ne sont pas déjà vendus
        for (Billet billet : billets) {
            if (!billet.getAchats().isEmpty()) {
                throw new RuntimeException("Le billet " + billet.getIdBillet() + " a déjà été vendu");
            }
        }
        
        Achat achat = new Achat();
        achat.setNomAcheteur(nomAcheteur);
        achat.setBillets(billets);
        achat.calculerTotal();
        
        return achatRepository.save(achat);
    }
    
    /**
     * Créer un achat directement depuis les places (sans billets pré-générés)
     * Le prix est calculé: prix de base * (1 - remise/100)
     */
    @Transactional
    public Achat createAchatFromPlaces(String nomAcheteur, Long idSeance, List<Long> idsPlaces,
                                        List<Long> typePersonneIds,
                                        com.cinema.repositories.ConfigSeanceRepository configSeanceRepository,
                                        ConfigRemisePersonneService configRemisePersonneService,
                                        PlaceService placeService) {
        if (idsPlaces == null || idsPlaces.isEmpty()) {
            throw new RuntimeException("La liste des places ne peut pas être vide");
        }
        
        Seance seance = seanceRepository.findById(idSeance)
                .orElseThrow(() -> new RuntimeException("Séance non trouvée"));
        
        List<Billet> billets = new ArrayList<>();
        
        for (int i = 0; i < idsPlaces.size(); i++) {
            Long idPlace = idsPlaces.get(i);
            Place place = placeService.getPlaceById(idPlace);
            
            // Vérifier si un billet existe déjà pour cette place et séance
            if (billetRepository.existsByPlaceIdPlaceAndSeanceIdSeance(idPlace, idSeance)) {
                List<Billet> existingBillets = billetRepository.findBySeanceIdSeance(idSeance);
                for (Billet b : existingBillets) {
                    if (b.getPlace().getIdPlace().equals(idPlace) && !b.getAchats().isEmpty()) {
                        throw new RuntimeException("La place " + place.getCodePlace() + " a déjà été vendue");
                    }
                }
            }
            
            // Trouver le prix de base depuis ConfigSeance
            ConfigSeance cfgSeance = configSeanceRepository.findBySeanceIdSeanceAndTypePlaceId(
                    idSeance, place.getTypePlace().getId());
            
            BigDecimal prixBase = BigDecimal.ZERO;
            if (cfgSeance != null && cfgSeance.getPrix() != null) {
                prixBase = cfgSeance.getPrix();
            }
            
            // Appliquer la remise si type de personne spécifié
            Long typePersonneId = (typePersonneIds != null && i < typePersonneIds.size()) ? typePersonneIds.get(i) : null;
            BigDecimal prixFinal = configRemisePersonneService.calculerPrixAvecRemise(prixBase, typePersonneId);
            
            // Créer le billet (le typePlace est accessible via place.getTypePlace())
            Billet billet = new Billet(place, seance, prixFinal);
            billet = billetRepository.save(billet);
            billets.add(billet);
        }
        
        Achat achat = new Achat();
        achat.setNomAcheteur(nomAcheteur);
        achat.setBillets(billets);
        achat.calculerTotal();
        
        return achatRepository.save(achat);
    }
    
    @Transactional
    public void deleteAchat(Long id) {
        achatRepository.deleteById(id);
    }
}
