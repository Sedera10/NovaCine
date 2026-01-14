package com.cinema.services;

import com.cinema.models.Billet;
import com.cinema.models.Place;
import com.cinema.models.Seance;
import com.cinema.repositories.BilletRepository;
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
    public List<Billet> genererBilletsPourSeance(Seance seance, BigDecimal prixUnitaire) {
        List<Place> places = placeService.getPlacesBySalle(seance.getSalle().getIdSalle());
        List<Billet> billets = new ArrayList<>();
        
        for (Place place : places) {
            if (!billetRepository.existsByPlaceIdPlaceAndSeanceIdSeance(place.getIdPlace(), seance.getIdSeance())) {
                Billet billet = new Billet(place, seance, prixUnitaire);
                billets.add(billetRepository.save(billet));
            }
        }
        
        return billets;
    }
    
    @Transactional
    public void deleteBillet(Long id) {
        billetRepository.deleteById(id);
    }
}
