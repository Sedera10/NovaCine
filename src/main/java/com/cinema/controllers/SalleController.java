package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.SalleService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashSet;

@Controller
@RequestMapping("/salles")
public class SalleController {
    
    @Autowired
    private SalleService salleService;
    
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
        // Vérification session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
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

    @GetMapping("/nouveau")
    public String nouvelleSalleForm(Model model) {
        // List<Film> films = salleService.getAllFilms();
        // List<Salle> salles = salleService.getAllSalles();
        // LocalDate daty = LocalDate.now();
        
        // model.addAttribute("films", films);
        // model.addAttribute("salles", salles);
        // model.addAttribute("seance", new Seance());
        // model.addAttribute("defaultDate",daty);
        
        return "salles/form";
    }

    // create
    @PostMapping("/nouveau")
    public String addSalle(
            @RequestParam String nom,
            @RequestParam Integer capacite,
            @RequestParam Integer nbRangees,
            @RequestParam Integer nbColonnes,
            RedirectAttributes redirectAttributes) {
        
        try {
            Salle seance = salleService.addSalle(nom, capacite, nbRangees, nbColonnes);
            redirectAttributes.addFlashAttribute("success", "Nouvelle salle créée avec succès");
            return "redirect:/salles";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/salles/nouveau";
        }
    }

}
