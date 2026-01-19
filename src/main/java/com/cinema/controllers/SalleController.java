package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.SalleService;
import com.cinema.services.TypePlaceService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/salles")
public class SalleController {
    
    @Autowired
    private SalleService salleService;
    
    @Autowired
    private TypePlaceService typePlaceService;
    
    /**
     * Injecte automatiquement l'utilisateur dans tous les modèles
     */
    @ModelAttribute("user")
    public User getUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }
    
    /**
     * Liste des films
     */
    @GetMapping
    public String listSalles(
            @RequestParam(required = false) String search,
            Model model, 
            HttpSession session
    ) {
        
        List<Salle> salles;
        if (search != null && !search.isEmpty()) {
            salles = salleService.getAllSalles().stream()
                .filter(f -> f.getNom().toLowerCase().contains(search.toLowerCase()))
                .toList();
        } 
        else {
            salles = salleService.getAllSalles();
        }
        model.addAttribute("salles", salles);
        model.addAttribute("search", search);
        
        return "salles/list";
    }

    /* ----------------------------- TypePlace CRUD (within SalleController) ----------------------------- */
    @GetMapping("/types")
    public String listTypesPlaces(@RequestParam(required = false) Long editId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }

        List<TypePlace> typesPlaces = typePlaceService.getAllTypesPlaces();
        model.addAttribute("typesPlaces", typesPlaces);

        if (editId != null) {
            TypePlace editing = typePlaceService.getTypePlaceById(editId);
            model.addAttribute("editingType", editing);
        } else {
            model.addAttribute("editingType", new TypePlace());
        }

        return "salles/TypePlace";
    }

    @PostMapping("/types")
    public String createTypePlace(@RequestParam String nom,
                                  RedirectAttributes redirectAttributes) {
        try {
            TypePlace tp = new TypePlace(nom);
            typePlaceService.saveTypePlace(tp);
            redirectAttributes.addFlashAttribute("success", "Type de place créé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/salles/types";
    }

    @PostMapping("/types/{id}/modifier")
    public String updateTypePlace(@PathVariable Long id,
                                  @RequestParam String nom,
                                  RedirectAttributes redirectAttributes) {
        try {
            TypePlace tp = typePlaceService.getTypePlaceById(id);
            tp.setNom(nom);
            typePlaceService.saveTypePlace(tp);
            redirectAttributes.addFlashAttribute("success", "Type de place mis à jour");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/salles/types";
    }

    @PostMapping("/types/{id}/supprimer")
    public String deleteTypePlace(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            typePlaceService.deleteTypePlace(id);
            redirectAttributes.addFlashAttribute("success", "Type de place supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/salles/types";
    }

    @GetMapping("/nouveau")
    public String nouvelleSalleForm(Model model) {
        // Récupérer tous les types de places
        List<TypePlace> typesPlaces = typePlaceService.getAllTypesPlaces();
        model.addAttribute("typesPlaces", typesPlaces);
        
        return "salles/form";
    }

    // create
    @PostMapping("/nouveau")
    public String addSalle(
            @RequestParam String nom,
            @RequestParam Integer capacite,
            @RequestParam Integer nbRangees,
            @RequestParam Integer nbColonnes,
            @RequestParam(required = false) Map<String, String> allParams,
            RedirectAttributes redirectAttributes) {
        
        try {
            // Extraire les configurations de types de places
            Map<Long, Integer> configurationsPlaces = new HashMap<>();
            
            for (Map.Entry<String, String> entry : allParams.entrySet()) {
                String key = entry.getKey();
                // Les paramètres de configuration ont le format: typePlace_<id>
                if (key.startsWith("typePlace_")) {
                    try {
                        Long idTypePlace = Long.parseLong(key.substring("typePlace_".length()));
                        Integer nombrePlaces = Integer.parseInt(entry.getValue());
                        
                        if (nombrePlaces != null && nombrePlaces > 0) {
                            configurationsPlaces.put(idTypePlace, nombrePlaces);
                        }
                    } catch (NumberFormatException e) {
                        // Ignorer les valeurs invalides
                    }
                }
            }
            
            // Si aucune configuration n'est fournie, utiliser la méthode simple
            if (configurationsPlaces.isEmpty()) {
                salleService.addSalle(nom, capacite, nbRangees, nbColonnes);
            } else {
                salleService.addSalle(nom, capacite, nbRangees, nbColonnes, configurationsPlaces);
            }
            
            redirectAttributes.addFlashAttribute("success", "Nouvelle salle créée avec succès");
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/salles/nouveau";
        }
    }


    @GetMapping("/{id}")
    public String getById(@PathVariable Long id, Model model, HttpSession session) {
        // Vérification session
        
        Salle salle = salleService.getSalleById(id);
        List<ConfigSalles> configurations = salleService.getConfigurationsSalle(id);
        Double gainPotentiel = salleService.getArgentGenere(id);

        model.addAttribute("salle", salle);
        model.addAttribute("configurations", configurations);
        model.addAttribute("gainPotentiel", gainPotentiel);

        return "salles/detail";
    }
}
