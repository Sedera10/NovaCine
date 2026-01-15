package com.cinema.services;

import com.cinema.models.ConfigSalles;
import com.cinema.models.Film;
import com.cinema.models.Salle;
import com.cinema.models.Seance;
import com.cinema.models.TypePlace;
import com.cinema.repositories.ConfigSallesRepository;
import com.cinema.repositories.SeanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ObjectInputFilter.Config;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class SeanceService {
    
    @Autowired
    private SeanceRepository seanceRepository;
    
    @Autowired
    private FilmService filmService;
    
    @Autowired
    private SalleService salleService;
    
    @Autowired
    private BilletService billetService;

    @Autowired
    private ConfigSallesRepository configSallesRepository;
    
    public List<Seance> getAllSeances() {
        return seanceRepository.findAll();
    }
    
    public Seance getSeanceById(Long id) {
        return seanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Séance non trouvée avec l'ID: " + id));
    }
    
    public List<Seance> getSeancesAVenir() {
        return seanceRepository.findSeancesAVenir(LocalDate.now());
    }
    
    public List<Seance> getSeancesByFilm(Long idFilm) {
        return seanceRepository.findByFilmIdFilm(idFilm);
    }
    
    public List<Seance> getSeancesByDate(LocalDate date) {
        return seanceRepository.findByDaty(date);
    }
    
    public List<Seance> getSeancesBySalle(Long idSalle) {
        return seanceRepository.findBySalleIdSalle(idSalle);
    }
    
    public Map<String, Object> getStatistiquesSeance(Long idSeance) {
        Map<String, Object> stats = new HashMap<>();
        
        Seance seance = getSeanceById(idSeance);
        Long capaciteTotale = billetService.countBilletsTotal(idSeance);
        Long billetsVendus = billetService.countBilletsVendus(idSeance);
        Long billetsDisponibles = capaciteTotale - billetsVendus;
        
        stats.put("seance", seance);
        stats.put("capaciteTotale", capaciteTotale);
        stats.put("billetsVendus", billetsVendus);
        stats.put("billetsDisponibles", billetsDisponibles);
        stats.put("tauxRemplissage", capaciteTotale > 0 ? 
                (billetsVendus * 100.0 / capaciteTotale) : 0.0);
        
        return stats;
    }
    
    @Transactional
    public Seance saveSeance(Seance seance) {
        return seanceRepository.save(seance);
    }
    
    @Transactional
    public Seance createSeance(Long idFilm, Long idSalle, LocalDate daty, LocalTime heure) throws Exception {
        Film film = filmService.getFilmById(idFilm);
        Salle salle = salleService.getSalleById(idSalle);

        if (film == null) { throw new Exception("Film non trouvé (mauvais idFilm)");}
        if (salle == null) { throw new Exception("Salle non trouvé ou invalide");}
        
        // Vérifier conflit horaire
        if (seanceRepository.existsByDatyAndHeureAndSalleIdSalle(daty, heure, idSalle)) {
            throw new RuntimeException("Une séance existe déjà à cette date et heure dans cette salle");
        }
        
        Seance seance = new Seance(daty, heure, film, salle);
        Seance savedSeance = seanceRepository.save(seance);
        // Générer automatiquement les billets avec les prix de la configuration de la salle
        billetService.genererBilletsPourSeance(savedSeance);
        
        return savedSeance;
    }
    
    @Transactional
    public Seance updateSeance(Long id, LocalDate daty, LocalTime heure, Long idFilm, Long idSalle) {
        Seance seance = getSeanceById(id);
        
        Film film = filmService.getFilmById(idFilm);
        Salle salle = salleService.getSalleById(idSalle);
        
        seance.setDaty(daty);
        seance.setHeure(heure);
        seance.setFilm(film);
        seance.setSalle(salle);
        
        return seanceRepository.save(seance);
    }
    
    @Transactional
    public void deleteSeance(Long id) {
        seanceRepository.deleteById(id);
    }

    public double getArgentGenere(Long id) {
        Seance seance = getSeanceById(id);
        Salle salle = seance.getSalle();
       
        List<ConfigSalles> configs = configSallesRepository.findBySalle(salle);
        double totalArgent = 0.0;

        for (ConfigSalles c: configs) {
            TypePlace tp = c.getTypePlace();
            totalArgent += tp.getPrix() * c.getNombrePlaces();
        }
        return totalArgent;
    }
}
