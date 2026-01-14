package com.cinema.services;

import com.cinema.models.Achat;
import com.cinema.models.Billet;
import com.cinema.repositories.AchatRepository;
import com.cinema.repositories.BilletRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class AchatService {
    
    @Autowired
    private AchatRepository achatRepository;
    
    @Autowired
    private BilletRepository billetRepository;
    
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
    
    @Transactional
    public void deleteAchat(Long id) {
        achatRepository.deleteById(id);
    }
}
