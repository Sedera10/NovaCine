package com.cinema.services;

import com.cinema.models.Salle;
import com.cinema.models.Seance;
import com.cinema.models.ConfigSalles;
import com.cinema.models.TypePlace;
import com.cinema.repositories.SalleRepository;
import com.cinema.repositories.ConfigSallesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class SalleService {
    
    @Autowired
    private SalleRepository salleRepository;
    
    @Autowired
    private ConfigSallesRepository configSallesRepository;
    
    @Autowired
    private TypePlaceService typePlaceService;
    
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
    
    /**
     * Ajoute une salle avec configuration des types de places
     * @param nom Nom de la salle
     * @param capacite Capacité totale
     * @param nbRangee Nombre de rangées
     * @param nbColonne Nombre de colonnes
     * @param configurationsPlaces Map contenant idTypePlace -> nombrePlaces
     * @return La salle créée
     */
    @Transactional
    public Salle addSalle(String nom, Integer capacite, Integer nbRangee, Integer nbColonne, 
                          Map<Long, Integer> configurationsPlaces) {
        // Validation: nbRangee * nbColonne = capacite
        if (nbRangee * nbColonne != capacite) {
            throw new RuntimeException("La capacité doit être égale à nbRangee * nbColonne");
        }
        
        // Validation: la somme des configurations doit égaler la capacité
        int sommePlaces = configurationsPlaces.values().stream()
                .mapToInt(Integer::intValue)
                .sum();
        
        if (sommePlaces != capacite) {
            throw new RuntimeException(
                String.format("La somme des places par type (%d) doit égaler la capacité totale (%d)", 
                              sommePlaces, capacite)
            );
        }
        
        // Créer la salle
        Salle salle = new Salle(nom, capacite, nbRangee, nbColonne);
        Salle savedSalle = salleRepository.save(salle);
        
        // Créer les configurations
        for (Map.Entry<Long, Integer> entry : configurationsPlaces.entrySet()) {
            TypePlace typePlace = typePlaceService.getTypePlaceById(entry.getKey());
            ConfigSalles config = new ConfigSalles(savedSalle, typePlace, entry.getValue());
            configSallesRepository.save(config);
        }
        
        // Générer automatiquement les places
        placeService.genererPlacesPourSalle(savedSalle);
        
        return savedSalle;
    }
    
    /**
     * Version simplifiée sans configuration (pour compatibilité)
     */
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
    
    /**
     * Récupère les configurations d'une salle
     */
    public List<ConfigSalles> getConfigurationsSalle(Long idSalle) {
        Salle salle = getSalleById(idSalle);
        return configSallesRepository.findBySalle(salle);
    }

    public double getArgentGenere(Long id) {
        Salle salle = salleRepository.findById(id).orElseThrow(() -> new RuntimeException("Salle not found"));
       
        List<ConfigSalles> configs = configSallesRepository.findBySalle(salle);
        double totalArgent = 0.0;

        // Without a seance context we cannot use ConfigSeance; return 0.0 for now
        for (ConfigSalles c: configs) {
            // keep placeholders for future pricing logic
        }
        return totalArgent;
    }
}

