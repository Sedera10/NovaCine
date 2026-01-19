package com.cinema.services;

import com.cinema.models.ConfigSalles;
import com.cinema.models.Place;
import com.cinema.models.Salle;
import com.cinema.models.TypePlace;
import com.cinema.repositories.ConfigSallesRepository;
import com.cinema.repositories.PlaceRepository;
import com.cinema.repositories.TypePlaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class PlaceService {
    
    @Autowired
    private PlaceRepository placeRepository;
    
    @Autowired
    private ConfigSallesRepository configSallesRepository;
    
    @Autowired
    private TypePlaceRepository typePlaceRepository;
    
    public List<Place> getAllPlaces() {
        return placeRepository.findAll();
    }
    
    public Place getPlaceById(Long id) {
        return placeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Place non trouvée avec l'ID: " + id));
    }
    
    public List<Place> getPlacesBySalle(Long idSalle) {
        return placeRepository.findBySalleIdSalle(idSalle);
    }
    
    @Transactional
    public Place savePlace(Place place) {
        return placeRepository.save(place);
    }
    
    @Transactional
    public List<Place> genererPlacesPourSalle(Salle salle) {
        List<Place> places = new ArrayList<>();
        char[] lettres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
        
        // Récupérer la configuration de la salle pour assigner les types de places
        List<ConfigSalles> configs = configSallesRepository.findBySalleIdSalle(salle.getIdSalle());
        
        // Créer une liste de types de places à assigner selon la config
        List<TypePlace> typePlacesAAfficher = new ArrayList<>();
        for (ConfigSalles config : configs) {
            for (int i = 0; i < config.getNombrePlaces(); i++) {
                typePlacesAAfficher.add(config.getTypePlace());
            }
        }
        
        // Type par défaut (Standard) si pas de config ou plus de places que prévu
        TypePlace typeDefaut = typePlaceRepository.findByNom("Standard");
        if (typeDefaut == null) {
            typeDefaut = typePlaceRepository.findAll().stream().findFirst().orElse(null);
        }
        
        int indexTypePlace = 0;
        for (int rangee = 0; rangee < salle.getNbRangee(); rangee++) {
            for (int colonne = 1; colonne <= salle.getNbColonne(); colonne++) {
                String codePlace = lettres[rangee] + String.valueOf(colonne);
                
                if (!placeRepository.existsByCodePlaceAndSalleIdSalle(codePlace, salle.getIdSalle())) {
                    // Assigner le type de place selon la config ou le type par défaut
                    TypePlace typePlace = typeDefaut;
                    if (indexTypePlace < typePlacesAAfficher.size()) {
                        typePlace = typePlacesAAfficher.get(indexTypePlace);
                    }
                    
                    Place place = new Place(codePlace, salle, typePlace);
                    places.add(placeRepository.save(place));
                    indexTypePlace++;
                }
            }
        }
        
        return places;
    }
    
    @Transactional
    public void deletePlace(Long id) {
        placeRepository.deleteById(id);
    }
}
