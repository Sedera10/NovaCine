package com.cinema.services;

import com.cinema.models.TypePlace;
import com.cinema.repositories.TypePlaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TypePlaceService {
    
    @Autowired
    private TypePlaceRepository typePlaceRepository;
    
    public List<TypePlace> getAllTypesPlaces() {
        return typePlaceRepository.findAll();
    }
    
    public TypePlace getTypePlaceById(Long id) {
        return typePlaceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type de place non trouvé avec l'ID: " + id));
    }
    
    public TypePlace saveTypePlace(TypePlace typePlace) {
        return typePlaceRepository.save(typePlace);
    }
}
