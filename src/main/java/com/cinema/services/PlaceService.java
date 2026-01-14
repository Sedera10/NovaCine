package com.cinema.services;

import com.cinema.models.Place;
import com.cinema.models.Salle;
import com.cinema.repositories.PlaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class PlaceService {
    
    @Autowired
    private PlaceRepository placeRepository;
    
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
        
        for (int rangee = 0; rangee < salle.getNbRangee(); rangee++) {
            for (int colonne = 1; colonne <= salle.getNbColonne(); colonne++) {
                String codePlace = lettres[rangee] + String.valueOf(colonne);
                
                if (!placeRepository.existsByCodePlaceAndSalleIdSalle(codePlace, salle.getIdSalle())) {
                    Place place = new Place(codePlace, salle);
                    places.add(placeRepository.save(place));
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
