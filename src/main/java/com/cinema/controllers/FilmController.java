package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.FilmService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.HashSet;

@Controller
@RequestMapping("/films")
public class FilmController {
    
    @Autowired
    private FilmService filmService;
    
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
    public String listFilms(
            @RequestParam(required = false) String statut,
            @RequestParam(required = false) String search,
            Model model, 
            HttpSession session
    ) {
        // Vérification session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
        List<Film> films;
        if (search != null && !search.isEmpty()) {
            films = filmService.getAllFilms().stream()
                .filter(f -> f.getTitre().toLowerCase().contains(search.toLowerCase()))
                .toList();
        } 
        else {
            films = filmService.getAllFilms();
        }
        model.addAttribute("films", films);
        model.addAttribute("search", search);
        
        return "films/list";
    }
    
    /**
     * Fiche détaillée d'un film
     */
    @GetMapping("/{id}")
    public String detailFilm(@PathVariable Long id, Model model, HttpSession session) {
        // Vérification session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
        Film film = filmService.getFilmById(id);
        if (film == null) {
            return "redirect:/films?error=notfound";
        }
        model.addAttribute("film", film);
        return "films/detail";
    }
    
    /**
     * Formulaire nouveau film
     */
    @GetMapping("/nouveau")
    public String nouveauFilmForm(Model model, HttpSession session) {
        // Vérification session et rôle
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        String roleName = user.getRole().getNomRole();
        if (!"Admin".equals(roleName) && !"Manager".equals(roleName)) {
            return "redirect:/films?error=unauthorized";
        }
        model.addAttribute("film", new Film());
        model.addAttribute("mode", "create");
        
        return "films/form";
    }
    
    /**
     * Formulaire modification film
     */
    @GetMapping("/{id}/modifier")
    public String modifierFilmForm(@PathVariable Long id, Model model, HttpSession session) {
        // Vérification session et rôle
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        String roleName = user.getRole().getNomRole();
        if (!"Admin".equals(roleName) && !"Manager".equals(roleName)) {
            return "redirect:/films?error=unauthorized";
        }
        
        Film film = filmService.getFilmById(id);
        if (film == null) {
            return "redirect:/films?error=notfound";
        }
        model.addAttribute("film", film);
        model.addAttribute("mode", "edit");
        
        return "films/form";
    }
    
    // create and modif
    @PostMapping("/save")
    public String saveFilm(
            @ModelAttribute Film film,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Vérification session et rôle
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        String roleName = user.getRole().getNomRole();
        if (!"Admin".equals(roleName) && !"Manager".equals(roleName)) {
            return "redirect:/films?error=unauthorized";
        }
        
        try {
            // Save
            if (film.getIdFilm() == null) {
                filmService.saveFilm(film);
                redirectAttributes.addFlashAttribute("success", "Film créé avec succès!");
            } else {
                filmService.updateFilm(film.getIdFilm(), film);
                redirectAttributes.addFlashAttribute("success", "Film mis à jour avec succès!");
            }
            
            return "redirect:/films";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/films/nouveau";
        }
    }
    
    // delete
    @GetMapping("/{id}/supprimer")
    public String deleteFilm(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        // Vérification session et rôle
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        if (!"Admin".equals(user.getRole().getNomRole())) {
            redirectAttributes.addFlashAttribute("error", "Accès non autorisé!");
            return "redirect:/films";
        }
        try {
            filmService.deleteFilm(id);
            redirectAttributes.addFlashAttribute("success", "Film supprimé avec succès!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/films";
    }
}
