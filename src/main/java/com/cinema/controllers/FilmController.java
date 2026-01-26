package com.cinema.controllers;

import com.cinema.models.Film;
import com.cinema.services.FilmService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/films")
public class FilmController {

    @Autowired
    private FilmService filmService;

    @GetMapping
    public String listFilms(@RequestParam(required = false) String search,
                            @RequestParam(required = false) String statut,
                            Model model) {
        List<Film> films;
        if (search != null && !search.isEmpty()) {
            films = filmService.rechercherFilms(search);
        } else {
            films = filmService.getAllFilms();
        }

        model.addAttribute("films", films);
        model.addAttribute("search", search);
        model.addAttribute("statut", statut);
        // placeholders pour les filtres (évite NPE dans la vue)
        model.addAttribute("categories", java.util.Collections.emptyList());
        model.addAttribute("pays", java.util.Collections.emptyList());
        model.addAttribute("classifications", java.util.Collections.emptyList());
        return "films/list";
    }

    @GetMapping("/nouveau")
    public String nouveauFilmForm(Model model) {
        model.addAttribute("mode", "create");
        model.addAttribute("film", new Film());
        return "films/form";
    }

    @PostMapping("/save")
    public String saveFilm(
            @RequestParam(required = false) Long idFilm,
            @RequestParam String titre,
            @RequestParam(required = false) String synopsis,
            @RequestParam(required = false) Integer duree,
            @RequestParam(required = false) String dtSortie,
            @RequestParam(required = false) String poster,
            RedirectAttributes redirectAttributes
    ) {
        try {
            Film film;
            if (idFilm != null) {
                film = filmService.getFilmById(idFilm).orElse(new Film());
            } else {
                film = new Film();
            }
            film.setTitre(titre);
            film.setSynopsis(synopsis);
            if (duree != null) film.setDuree(duree);
            if (dtSortie != null && !dtSortie.isBlank()) film.setDtSortie(java.time.LocalDate.parse(dtSortie));
            film.setPoster(poster);

            filmService.saveFilm(film);
            redirectAttributes.addFlashAttribute("success", idFilm == null ? "Film créé" : "Film mis à jour");
            return "redirect:/films";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/films";
        }
    }

    @GetMapping("/{id}")
    public String detailFilm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        var opt = filmService.getFilmById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Film non trouvé");
            return "redirect:/films";
        }
        model.addAttribute("film", opt.get());
        return "films/detail";
    }

    @GetMapping("/{id}/modifier")
    public String modifierFilmForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        var opt = filmService.getFilmById(id);
        if (opt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Film non trouvé");
            return "redirect:/films";
        }
        model.addAttribute("mode", "edit");
        model.addAttribute("film", opt.get());
        return "films/form";
    }

    @GetMapping("/{id}/supprimer")
    public String supprimerFilm(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            filmService.deleteFilm(id);
            redirectAttributes.addFlashAttribute("success", "Film supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/films";
    }
}
