package com.cinema.controllers;

import com.cinema.models.Salle;
import com.cinema.models.ConfigSalles;
import com.cinema.models.TypePlace;
import com.cinema.services.SalleService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/salles")
public class SalleController {

    @Autowired
    private SalleService salleService;
    
    @GetMapping
    public String listSalles(
            @RequestParam(required = false) String search,
            Model model
    ) {
        
        List<Salle> salles;
        if (search != null && !search.isEmpty()) {
            salles = salleService.rechercherSalles(search);
        } else {
            salles = salleService.getAllSalles();
        }
        
        model.addAttribute("salles", salles);
        model.addAttribute("search", search);
        return "salles/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauSalleForm(Model model) {
        
        List<TypePlace> typesPlaces = salleService.getAllTypesPlaces();
        
        model.addAttribute("typesPlaces", typesPlaces);
        model.addAttribute("salle", new Salle());
        model.addAttribute("action", "create");
        // map vide pour la vue (Ã©vite null checks)
        model.addAttribute("salleConfigMap", new java.util.HashMap<Long,Integer>());
        
        return "salles/form";
    }
    
    @PostMapping("/nouveau")
    public String creerSalle(
            @RequestParam String nom,
            @RequestParam Integer capacite,
            @RequestParam(required = false) List<Long> idTypePlaces,
            @RequestParam(required = false) List<Integer> nombres,
            RedirectAttributes redirectAttributes
    ) {
        
        try {
            Salle salle = salleService.creerSalleAvecConfig(nom, capacite, idTypePlaces, nombres);
            redirectAttributes.addFlashAttribute("success", "Salle crÃ©Ã©e avec succÃ¨s");
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/salles/nouveau";
        }
    }

    @GetMapping("/{id}")
    public String detailSalle(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        var opt = salleService.getSalleById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Salle non trouvÃ©e");
            return "redirect:/salles";
        }
        Salle salle = opt.get();
        var configurations = salleService.getConfigurationsBySalle(salle);

        // gainPotentiel calcul simplifiÃ© (placeholder)
        double gainPotentiel = 0.0;

        model.addAttribute("salle", salle);
        model.addAttribute("configurations", configurations);
        model.addAttribute("gainPotentiel", gainPotentiel);
        return "salles/detail";
    }

    @GetMapping("/{id}/plan")
    public String planSalle(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        var opt = salleService.getSalleById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Salle non trouvÃ©e");
            return "redirect:/salles";
        }
        Salle salle = opt.get();
        var configurations = salleService.getConfigurationsBySalle(salle);

        // GÃ©nÃ©rer les siÃ¨ges Ã  la volÃ©e Ã  partir des configurations
        var sieges = salleService.genererSiegesDepuisConfig(salle);
        var types = salleService.getAllTypesPlaces(); // utilisÃ© pour le dropdown

        model.addAttribute("salle", salle);
        model.addAttribute("configurations", configurations);
        model.addAttribute("sieges", sieges);
        model.addAttribute("typesSiege", types);
        return "salles/plan";
    }

    @GetMapping("/{id}/modifier")
    public String modifierSalleForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        var opt = salleService.getSalleById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Salle non trouvÃ©e");
            return "redirect:/salles";
        }
        Salle salle = opt.get();
        var typesPlaces = salleService.getAllTypesPlaces();
        var configurations = salleService.getConfigurationsBySalle(salle);

        java.util.Map<Long, Integer> salleConfigMap = new java.util.HashMap<>();
        for (var c : configurations) {
            salleConfigMap.put(c.getTypePlace().getId(), c.getNombre());
        }

        model.addAttribute("typesPlaces", typesPlaces);
        model.addAttribute("salle", salle);
        model.addAttribute("action", "edit");
        model.addAttribute("salleConfigMap", salleConfigMap);

        return "salles/form";
    }

    @PostMapping("/{id}/modifier")
    public String modifierSalle(
            @PathVariable Long id,
            @RequestParam String nom,
            @RequestParam Integer capacite,
            @RequestParam(required = false) List<Long> idTypePlaces,
            @RequestParam(required = false) List<Integer> nombres,
            RedirectAttributes redirectAttributes
    ) {
        try {
            salleService.modifierSalle(id, nom, capacite, idTypePlaces, nombres);
            redirectAttributes.addFlashAttribute("success", "Salle modifiÃ©e avec succÃ¨s");
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/salles/" + id + "/modifier";
        }
    }

    @GetMapping("/types-salles")
    public String gotoConfTypes(Model model){
        List<TypePlace> types = salleService.getAllTypesPlaces();
        model.addAttribute("typesPlaces", types);
        return "salles/TypePlace";
    }
}