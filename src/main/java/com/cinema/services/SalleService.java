package com.cinema.services;

import com.cinema.models.Salle;
import com.cinema.repositories.SalleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SalleService {
    
    @Autowired
    private SalleRepository salleRepository;
    
    @Autowired
    private PlaceService placeService;
    
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }
    
    public Salle getSalleById(Long id) {
        return salleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée avec l'ID: " + id));
    }
    
    public List<Salle> getSallesOrderByNom() {
        return salleRepository.findAllOrderByNom();
    }
    
    public Salle getSalleByNom(String nom) {
        return salleRepository.findByNom(nom)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée avec le nom: " + nom));
    }
    
    @Transactional
    public Salle saveSalle(Salle salle) {
        return salleRepository.save(salle);
    }
    
    @Transactional
    public Salle addSalle(String nom, Integer capacite, Integer nbRangee, Integer nbColonne) {
        if (nbRangee * nbColonne != capacite) {
            throw new RuntimeException("La capacité doit être égale à nbRangee * nbColonne");
        }
        
        Salle salle = new Salle(nom, capacite, nbRangee, nbColonne);
        Salle savedSalle = salleRepository.save(salle);
        
        // Générer automatiquement les places
        placeService.genererPlacesPourSalle(savedSalle);
        
        return savedSalle;
    }
    
    @Transactional
    public Salle updateSalle(Long id, Salle salleData) {
        Salle salle = getSalleById(id);
        salle.setNom(salleData.getNom());
        salle.setCapacite(salleData.getCapacite());
        salle.setNbRangee(salleData.getNbRangee());
        salle.setNbColonne(salleData.getNbColonne());
        return salleRepository.save(salle);
    }
    
    @Transactional
    public void deleteSalle(Long id) {
        salleRepository.deleteById(id);
    }
}
