package com.cinema.services;

import com.cinema.models.Billet;
import com.cinema.models.ConfigSalles;
import com.cinema.models.Place;
import com.cinema.models.ConfigSeance;
import com.cinema.models.Salle;
import com.cinema.models.Seance;
import com.cinema.repositories.BilletRepository;
import com.cinema.repositories.ConfigSallesRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class BilletService {
    
    @Autowired
    private BilletRepository billetRepository;

    @Autowired
    private ConfigSallesRepository configSallesRepository;
    
    @Autowired
    private com.cinema.repositories.ConfigSeanceRepository configSeanceRepository;
    
    @Autowired
    private PlaceService placeService;
    
    public List<Billet> getAllBillets() {
        return billetRepository.findAll();
    }
    
    public Billet getBilletById(Long id) {
        return billetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Billet non trouvé avec l'ID: " + id));
    }
    
    public List<Billet> getBilletsBySeance(Long idSeance) {
        return billetRepository.findBySeanceIdSeance(idSeance);
    }
    
    public List<Billet> getBilletsDisponiblesBySeance(Long idSeance) {
        return billetRepository.findBilletsDisponiblesBySeance(idSeance);
    }
    
    public boolean isPlaceDisponible(Long idPlace, Long idSeance) {
        return !billetRepository.existsByPlaceIdPlaceAndSeanceIdSeance(idPlace, idSeance);
    }
    
    public Long countBilletsTotal(Long idSeance) {
        return billetRepository.countBySeanceIdSeance(idSeance);
    }
    
    public Long countBilletsVendus(Long idSeance) {
        return billetRepository.countBilletsVendusBySeance(idSeance);
    }
    
    public Long countBilletsDisponibles(Long idSeance) {
        Long total = countBilletsTotal(idSeance);
        Long vendus = countBilletsVendus(idSeance);
        return total - vendus;
    }
    
    @Transactional
    public Billet createBillet(Place place, Seance seance, BigDecimal prix) {
        if (billetRepository.existsByPlaceIdPlaceAndSeanceIdSeance(place.getIdPlace(), seance.getIdSeance())) {
            throw new RuntimeException("Un billet existe déjà pour cette place et séance");
        }
        
        Billet billet = new Billet(place, seance, prix);
        return billetRepository.save(billet);
    }
    
    @Transactional
    public List<Billet> genererBilletsPourSeance(Seance seance) {
        List<Place> places = placeService.getPlacesBySalle(seance.getSalle().getIdSalle());
        List<Billet> billets = new ArrayList<>();

        Salle salle = seance.getSalle();
        List<ConfigSalles> configs = configSallesRepository.findBySalle(salle);
        List<BigDecimal> prixParPlace = new ArrayList<>();
        
        for (ConfigSalles config : configs) {
            if (config.getTypePlace() != null) {
                // Try to find a ConfigSeance for this seance and typePlace to get the base price
                ConfigSeance cfg = configSeanceRepository.findBySeanceIdSeanceAndTypePlaceId(seance.getIdSeance(), config.getTypePlace().getId());
                BigDecimal prix = BigDecimal.ZERO;
                if (cfg != null && cfg.getPrix() != null) {
                    prix = cfg.getPrix();
                }
                int nombrePlaces = config.getNombrePlaces();

                for (int i = 0; i < nombrePlaces; i++) {
                    prixParPlace.add(prix);
                }
            }
        }
        
        // Générer les billets avec le prix correspondant à chaque place
        int index = 0;
        for (Place place : places) {
            if (!billetRepository.existsByPlaceIdPlaceAndSeanceIdSeance(place.getIdPlace(), seance.getIdSeance())) {
                // Récupérer le prix selon l'index de la place, ou prix par défaut si pas de config
                BigDecimal prixBillet = BigDecimal.ZERO;
                if (index < prixParPlace.size()) {
                    prixBillet = prixParPlace.get(index);
                } else if (!prixParPlace.isEmpty()) {
                    // Si plus d'index disponible, utiliser le dernier prix
                    prixBillet = prixParPlace.get(prixParPlace.size() - 1);
                }
                
                Billet billet = new Billet(place, seance, prixBillet);
                billets.add(billetRepository.save(billet));
            }
            index++;
        }
        
        return billets;
    }
    
    @Transactional
    public void deleteBillet(Long id) {
        billetRepository.deleteById(id);
    }
}
