package com.cinema.services;

import com.cinema.models.Salle;
import com.cinema.models.TypePersonne;
import com.cinema.dto.SiegeDTO;
import com.cinema.models.ConfigSalles;
import com.cinema.models.TypePlace;
import com.cinema.repositories.SalleRepository;
import com.cinema.repositories.TypePersonneRepository;
import com.cinema.repositories.ConfigSallesRepository;
import com.cinema.repositories.TypePlaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class SalleService {

    @Autowired
    private SalleRepository salleRepository;
    
    @Autowired
    private ConfigSallesRepository configSallesRepository;
    
    @Autowired
    private TypePlaceRepository typePlaceRepository;

    @Autowired
    private TypePersonneRepository typePersonneRepository;
    
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }
    
    public List<Salle> rechercherSalles(String search) {
        return salleRepository.findByNomContainingIgnoreCase(search);
    }
    
    public Optional<Salle> getSalleById(Long id) {
        return salleRepository.findById(id);
    }
    
    public List<TypePlace> getAllTypesPlaces() {
        return typePlaceRepository.findAll();
    }
    
    public List<ConfigSalles> getConfigurationsBySalle(Salle salle) {
        return configSallesRepository.findBySalle(salle);
    }
    
    @Transactional
    public Salle creerSalleAvecConfig(String nom, Integer capacite, List<Long> idTypePlaces, List<Integer> nombres) {
        Salle salle = new Salle();
        salle.setNom(nom);
        salle.setCapacite(capacite);
        salle.setDtCreation(LocalDateTime.now());
        
        Salle savedSalle = salleRepository.save(salle);
        
        if (idTypePlaces != null && nombres != null) {
            for (int i = 0; i < idTypePlaces.size(); i++) {
                TypePlace typePlace = typePlaceRepository.findById(idTypePlaces.get(i))
                    .orElseThrow(() -> new IllegalArgumentException("Type de place non trouvé"));
                
                ConfigSalles config = new ConfigSalles();
                config.setSalle(savedSalle);
                config.setTypePlace(typePlace);
                config.setNombre(nombres.get(i));
                configSallesRepository.save(config);
            }
        }
        
        return savedSalle;
    }
    
    @Transactional
    public Salle modifierSalle(Long id, String nom, Integer capacite, List<Long> idTypePlaces, List<Integer> nombres) {
        Optional<Salle> existingSalle = salleRepository.findById(id);
        if (existingSalle.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }
        
        Salle salle = existingSalle.get();
        salle.setNom(nom);
        salle.setCapacite(capacite);
        
        Salle updatedSalle = salleRepository.save(salle);
        
        configSallesRepository.deleteBySalleIdSalle(id);
        
        if (idTypePlaces != null && nombres != null) {
            for (int i = 0; i < idTypePlaces.size(); i++) {
                TypePlace typePlace = typePlaceRepository.findById(idTypePlaces.get(i))
                    .orElseThrow(() -> new IllegalArgumentException("Type de place non trouvé"));
                
                ConfigSalles config = new ConfigSalles();
                config.setSalle(updatedSalle);
                config.setTypePlace(typePlace);
                config.setNombre(nombres.get(i));
                configSallesRepository.save(config);
            }
        }
        
        return updatedSalle;
    }
    
    @Transactional
    public void supprimerSalle(Long id) {
        configSallesRepository.deleteBySalleIdSalle(id);
        salleRepository.deleteById(id);
    }

    /**
     * Génère la liste des sièges (non persistés) à partir des configurations (ConfigSalles)
     * La distribution est effectuée séquentiellement en respectant les nombres par type.
     */
    public List<SiegeDTO> genererSiegesDepuisConfig(Salle salle) {
        List<SiegeDTO> sieges = new ArrayList<>();
        List<ConfigSalles> configs = getConfigurationsBySalle(salle);
        if (configs == null || configs.isEmpty()) return sieges;

        int total = configs.stream().mapToInt(ConfigSalles::getNombre).sum();
        if (total <= 0) return sieges;

        // Déterminer colonnes/ rangées (max 26 rangées A-Z)
        int colonnes = (int) Math.ceil(Math.sqrt(total));
        int rangees = (int) Math.ceil((double) total / colonnes);
        while (rangees > 26) {
            colonnes++;
            rangees = (int) Math.ceil((double) total / colonnes);
        }

        // Préparer un itérateur sur les types avec compte restant
        List<Map<String,Object>> pool = new ArrayList<>();
        for (ConfigSalles c : configs) {
            Map<String,Object> m = new HashMap<>();
            m.put("type", c.getTypePlace());
            m.put("remaining", c.getNombre());
            pool.add(m);
        }

        int seatIndex = 0;
        for (int r = 0; r < rangees; r++) {
            char rangeeChar = (char) ('A' + r);
            for (int c = 1; c <= colonnes; c++) {
                if (seatIndex >= total) break;

                // obtenir type courant
                TypePlace selectedType = null;
                for (Map<String,Object> entry : pool) {
                    int rem = (int) entry.get("remaining");
                    if (rem > 0) {
                        selectedType = (TypePlace) entry.get("type");
                        entry.put("remaining", rem - 1);
                        break;
                    }
                }

                if (selectedType == null) selectedType = configs.get(0).getTypePlace();

                String pos = String.valueOf(rangeeChar) + c;
                SiegeDTO s = new SiegeDTO(null, String.valueOf(rangeeChar), c, pos, "DISPONIBLE", selectedType);
                sieges.add(s);
                seatIndex++;
            }
            if (seatIndex >= total) break;
        }

        return sieges;
    }

}