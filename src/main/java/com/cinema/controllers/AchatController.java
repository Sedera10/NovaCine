package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/achats")
public class AchatController {
    
    @Autowired
    private AchatService achatService;
    
    @Autowired
    private BilletService billetService;
    
    @Autowired
    private SeanceService seanceService;
    
    @Autowired
    private TypePlaceService typePlaceService;
    
    @Autowired
    private PlaceService placeService;
    
    @Autowired
    private ConfigSeanceService configSeanceService;
    
    @Autowired
    private ConfigRemisePersonneService configRemisePersonneService;

    @Autowired
    private com.cinema.repositories.ConfigSeanceRepository configSeanceRepository;

    @Autowired
    private com.cinema.repositories.TypePersonneRepository typePersonneRepository;
    
    /**
     * Page d'achat de billets pour une séance
     */
    @GetMapping("/seance/{idSeance}")
    public String pageAchat(@PathVariable Long idSeance, Model model) {
        Seance seance = seanceService.getSeanceById(idSeance);
        List<Place> places = placeService.getPlacesBySalle(seance.getSalle().getIdSalle());
        List<TypePlace> typesPlaces = typePlaceService.getAllTypesPlaces();
        List<TypePersonne> typePersonnes = typePersonneRepository.findAll();
        List<ConfigRemisePersonne> remises = configRemisePersonneService.getAllRemises();
        
        // Récupérer les prix depuis ConfigSeance pour cette séance
        Map<Long, BigDecimal> prixParTypePlace = new HashMap<>();
        List<ConfigSeance> configSeances = configSeanceService.getConfigsBySeance(idSeance);
        for (ConfigSeance cs : configSeances) {
            prixParTypePlace.put(cs.getTypePlace().getId_type_place(), cs.getPrix());
        }
        
        // Créer une map des remises par type de personne
        Map<Long, BigDecimal> remiseParTypePersonne = new HashMap<>();
        for (ConfigRemisePersonne r : remises) {
            remiseParTypePersonne.put(r.getTypePersonne().getIdTypePersonne(), r.getRemise());
        }
        
        // Récupérer les places déjà achetées
        List<Billet> billetsVendus = billetService.getBilletsBySeance(idSeance);
        Map<Long, Boolean> placesOccupees = new HashMap<>();
        for (Billet b : billetsVendus) {
            if (!b.getAchats().isEmpty()) {
                placesOccupees.put(b.getPlace().getIdPlace(), true);
            }
        }
        
        model.addAttribute("seance", seance);
        model.addAttribute("places", places);
        model.addAttribute("typesPlaces", typesPlaces);
        model.addAttribute("typePersonnes", typePersonnes);
        model.addAttribute("prixParTypePlace", prixParTypePlace);
        model.addAttribute("remiseParTypePersonne", remiseParTypePersonne);
        model.addAttribute("placesOccupees", placesOccupees);
        
        return "achats/achat";
    }

    @GetMapping("/prix-place")
    @ResponseBody
    public String getPrixForPlaceAndTypePersonne(@RequestParam Long idSeance, 
                                                  @RequestParam Long idTypePlace,
                                                  @RequestParam(required = false) Long idTypePersonne) {
        try {
            ConfigSeance cfgSeance = configSeanceRepository.findBySeanceIdSeanceAndTypePlaceId(idSeance, idTypePlace);
            if (cfgSeance == null) return "0";
            
            BigDecimal prixBase = cfgSeance.getPrix();
            if (prixBase == null) return "0";
            
            // Appliquer la remise si type de personne spécifié
            BigDecimal prixFinal = configRemisePersonneService.calculerPrixAvecRemise(prixBase, idTypePersonne);
            return prixFinal.toString();
        } catch (Exception e) {
            return "0";
        }
    }
    
    /**
     * Confirmer l'achat
     */
    @PostMapping("/confirmer")
    public String confirmerAchat(@RequestParam String nomAcheteur,
                                  @RequestParam Long idSeance,
                                  @RequestParam List<Long> idsPlaces,
                                  @RequestParam(required = false) List<Long> typePersonneIds,
                                  RedirectAttributes redirectAttributes) {
        try {
            Achat achat = achatService.createAchatFromPlaces(nomAcheteur, idSeance, idsPlaces, typePersonneIds,
                    configSeanceRepository, configRemisePersonneService, placeService);
            redirectAttributes.addFlashAttribute("success", 
                "Achat confirmé ! Total: " + achat.getTotal() + " Ar");
            redirectAttributes.addFlashAttribute("achatId", achat.getIdAchat());
            return "redirect:/achats/confirmation/" + achat.getIdAchat();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/achats/seance/" + idSeance;
        }
    }
    
    /**
     * Page de confirmation d'achat
     */
    @GetMapping("/confirmation/{idAchat}")
    public String pageConfirmation(@PathVariable Long idAchat, Model model) {
        Achat achat = achatService.getAchatById(idAchat);
        model.addAttribute("achat", achat);
        return "achats/confirmation";
    }
    
    /**
     * Liste de tous les achats 
     */
    @GetMapping("/liste")
    public String listeAchats(Model model) {
        List<Achat> achats = achatService.getAllAchats();
        model.addAttribute("achats", achats);
        return "ventes/list";
    }
    
    /**
     * Liste des ventes pour une séance
     */
    @GetMapping("/seance/{idSeance}/ventes")
    public String ventesSeance(@PathVariable Long idSeance, Model model) {
        Seance seance = seanceService.getSeanceById(idSeance);
        List<Achat> achats = achatService.getAchatsBySeance(idSeance);
        BigDecimal totalVentes = achatService.getTotalVentesBySeance(idSeance);
        Map<String, Object> stats = seanceService.getStatistiquesSeance(idSeance);
        
        model.addAttribute("seance", seance);
        model.addAttribute("achats", achats);
        model.addAttribute("totalVentes", totalVentes);
        model.addAttribute("stats", stats);
        
        return "achats/ventes-seance";
    }
}
