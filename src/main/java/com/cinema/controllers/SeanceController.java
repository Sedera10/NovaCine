package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/seances")
public class SeanceController {
    
    @Autowired
    private SeanceService seanceService;
    
    @Autowired
    private FilmService filmService;
    
    @Autowired
    private SalleService salleService;
    
    @Autowired
    private TypePlaceService typePlaceService;
    
    @Autowired
    private ConfigSeanceService configSeanceService;
    
    /**
     * Page d'accueil : Liste des séances avec filtres
     */
    @GetMapping({"", "/liste"})
    public String listeSeances(
            @RequestParam(required = false) Long idFilm,
            @RequestParam(required = false) Long idSalle,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            Model model) {
        
        List<Seance> seances;
        
        // Filtrage
        if (idFilm != null) {
            seances = seanceService.getSeancesByFilm(idFilm);
        } else if (idSalle != null) {
            seances = seanceService.getSeancesBySalle(idSalle);
        } else if (date != null) {
            seances = seanceService.getSeancesByDate(date);
        } else {
            seances = seanceService.getSeancesAVenir();
        }
        
        // Calculer le total d'argent pour chaque séance
        Map<Long, Double> totauxArgent = new HashMap<>();
        for (Seance seance : seances) {
            Double totalArgent = seanceService.getArgentGenere(seance.getIdSeance());
            totauxArgent.put(seance.getIdSeance(), totalArgent);
        }
        
        // Pour les filtres
        List<Film> films = filmService.getAllFilms();
        List<Salle> salles = salleService.getAllSalles();
        
        model.addAttribute("seances", seances);
        model.addAttribute("totauxArgent", totauxArgent);
        model.addAttribute("films", films);
        model.addAttribute("salles", salles);
        model.addAttribute("idFilm", idFilm);
        model.addAttribute("idSalle", idSalle);
        model.addAttribute("date", date);
        
        return "seances/liste";
    }
    
    /**
     * Détails d'une séance
     */
    @GetMapping("/{id}")
    public String detailSeance(@PathVariable Long id, Model model) {
        Seance seance = seanceService.getSeanceById(id);
        Map<String, Object> stats = seanceService.getStatistiquesSeance(id);

        Double totalargent = seanceService.getArgentGenere(id);
        
        model.addAttribute("seance", seance);
        model.addAttribute("stats", stats);

        model.addAttribute("totalargent", totalargent);
        
        return "seances/detail";
    }
    
    /**
     * Formulaire de création de séance
     */
    @GetMapping("/nouveau")
    public String nouveauSeanceForm(Model model) {
        List<Film> films = filmService.getAllFilms();
        List<Salle> salles = salleService.getAllSalles();
        List<TypePlace> typePlaces = typePlaceService.getAllTypesPlaces();
        LocalDate daty = LocalDate.now();
        
        model.addAttribute("films", films);
        model.addAttribute("salles", salles);
        model.addAttribute("typePlaces", typePlaces);
        model.addAttribute("seance", new Seance());
        model.addAttribute("defaultDate", daty);
        
        return "seances/form";
    }
    
    /**
     * Création d'une séance
     */
    @PostMapping("/nouveau")
    public String creerSeance(
            @RequestParam Long idFilm,
            @RequestParam Long idSalle,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dtSeance,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime heureDebut,
            @RequestParam(required = false) Map<String, String> allParams,
            RedirectAttributes redirectAttributes) {
        
        try {
            Seance seance = seanceService.createSeance(idFilm, idSalle, dtSeance, heureDebut);
            
            // Enregistrer les prix par type de place
            List<TypePlace> typePlaces = typePlaceService.getAllTypesPlaces();
            for (TypePlace tp : typePlaces) {
                String prixParam = allParams.get("prix_" + tp.getId());
                if (prixParam != null && !prixParam.trim().isEmpty()) {
                    BigDecimal prix = new BigDecimal(prixParam);
                    configSeanceService.saveOrUpdate(seance, tp, prix);
                }
            }
            
            redirectAttributes.addFlashAttribute("success", "Séance créée avec succès");
            return "redirect:/seances";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/seances/nouveau";
        }
    }
    
    /**
     * Formulaire de modification
     */
    @GetMapping("/{id}/modifier")
    public String modifierSeanceForm(@PathVariable Long id, Model model) {
        Seance seance = seanceService.getSeanceById(id);
        List<Film> films = filmService.getAllFilms();
        List<Salle> salles = salleService.getAllSalles();
        List<TypePlace> typePlaces = typePlaceService.getAllTypesPlaces();
        
        // Récupérer les prix existants
        List<ConfigSeance> configSeances = configSeanceService.getConfigsBySeance(id);
        Map<Long, BigDecimal> prixParTypePlace = new HashMap<>();
        for (ConfigSeance cs : configSeances) {
            prixParTypePlace.put(cs.getTypePlace().getId(), cs.getPrix());
        }
        
        model.addAttribute("seance", seance);
        model.addAttribute("films", films);
        model.addAttribute("salles", salles);
        model.addAttribute("typePlaces", typePlaces);
        model.addAttribute("prixParTypePlace", prixParTypePlace);
        
        return "seances/form";
    }
    
    /**
     * Modification d'une séance
     */
    @PostMapping("/{id}/modifier")
    public String modifierSeance(
            @PathVariable Long id,
            @RequestParam Long idFilm,
            @RequestParam Long idSalle,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate daty,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime heure,
            @RequestParam(required = false) Map<String, String> allParams,
            RedirectAttributes redirectAttributes) {
        
        try {
            Seance seance = seanceService.updateSeance(id, daty, heure, idFilm, idSalle);
            
            // Mettre à jour les prix par type de place
            List<TypePlace> typePlaces = typePlaceService.getAllTypesPlaces();
            for (TypePlace tp : typePlaces) {
                String prixParam = allParams.get("prix_" + tp.getId());
                if (prixParam != null && !prixParam.trim().isEmpty()) {
                    BigDecimal prix = new BigDecimal(prixParam);
                    configSeanceService.saveOrUpdate(seance, tp, prix);
                }
            }
            
            redirectAttributes.addFlashAttribute("success", "Séance modifiée avec succès");
            return "redirect:/seances/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/seances/" + id + "/modifier";
        }
    }
    
    /**
     * Suppression d'une séance
     */
    @PostMapping("/{id}/supprimer")
    public String supprimerSeance(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            seanceService.deleteSeance(id);
            redirectAttributes.addFlashAttribute("success", "Séance supprimée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/seances";
    }
}
