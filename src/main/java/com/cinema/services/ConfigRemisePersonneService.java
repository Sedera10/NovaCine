package com.cinema.services;

import com.cinema.models.ConfigRemisePersonne;
import com.cinema.models.TypePersonne;
import com.cinema.repositories.ConfigRemisePersonneRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ConfigRemisePersonneService {
    
    @Autowired
    private ConfigRemisePersonneRepository configRemisePersonneRepository;
    
    public List<ConfigRemisePersonne> getAllRemises() {
        return configRemisePersonneRepository.findAll();
    }
    
    public ConfigRemisePersonne getRemiseByTypePersonne(Long idTypePersonne) {
        return configRemisePersonneRepository.findByTypePersonneIdTypePersonne(idTypePersonne);
    }
    
    /**
     * Calcule le prix après remise pour un type de personne
     * @param prixBase Le prix de base (adulte)
     * @param idTypePersonne L'ID du type de personne (null = adulte, pas de remise)
     * @return Le prix après remise
     */
    public BigDecimal calculerPrixAvecRemise(BigDecimal prixBase, Long idTypePersonne) {
        if (prixBase == null) return BigDecimal.ZERO;
        if (idTypePersonne == null) return prixBase; // Adulte = prix de base
        
        ConfigRemisePersonne remise = configRemisePersonneRepository.findByTypePersonneIdTypePersonne(idTypePersonne);
        if (remise != null) {
            return remise.calculerPrixAvecRemise(prixBase);
        }
        return prixBase;
    }
    
    @Transactional
    public ConfigRemisePersonne saveOrUpdate(TypePersonne typePersonne, BigDecimal remisePourcentage) {
        ConfigRemisePersonne existing = configRemisePersonneRepository.findByTypePersonneIdTypePersonne(typePersonne.getIdTypePersonne());
        
        if (existing != null) {
            existing.setRemise(remisePourcentage);
            return configRemisePersonneRepository.save(existing);
        } else {
            ConfigRemisePersonne newRemise = new ConfigRemisePersonne(typePersonne, remisePourcentage);
            return configRemisePersonneRepository.save(newRemise);
        }
    }
    
    @Transactional
    public void delete(Long id) {
        configRemisePersonneRepository.deleteById(id);
    }
}
