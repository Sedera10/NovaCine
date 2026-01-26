package com.cinema.services;

import com.cinema.models.ConfigSeance;
import com.cinema.models.Seance;
import com.cinema.models.TypePlace;
import com.cinema.repositories.ConfigSeanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ConfigSeanceService {
    
    @Autowired
    private ConfigSeanceRepository configSeanceRepository;
    
    public List<ConfigSeance> getConfigsBySeance(Long idSeance) {
        return configSeanceRepository.findBySeanceIdSeance(idSeance);
    }
    
    public ConfigSeance getConfigBySeanceAndTypePlace(Long idSeance, Long idTypePlace) {
        return configSeanceRepository.findBySeanceIdSeanceAndTypePlaceId(idSeance, idTypePlace);
    }
    
    @Transactional
    public ConfigSeance saveOrUpdate(Seance seance, TypePlace typePlace, BigDecimal prix) {
        ConfigSeance existing = configSeanceRepository.findBySeanceIdSeanceAndTypePlaceId(
                seance.getIdSeance(), typePlace.getId());
        
        if (existing != null) {
            existing.setPrix(prix);
            return configSeanceRepository.save(existing);
        } else {
            ConfigSeance cfg = new ConfigSeance(seance, typePlace, prix);
            return configSeanceRepository.save(cfg);
        }
    }
    
    @Transactional
    public void deleteBySeance(Long idSeance) {
        List<ConfigSeance> configs = configSeanceRepository.findBySeanceIdSeance(idSeance);
        configSeanceRepository.deleteAll(configs);
    }
}
