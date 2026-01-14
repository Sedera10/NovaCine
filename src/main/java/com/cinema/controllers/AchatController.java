package com.cinema.controllers;

import com.cinema.models.Achat;
import com.cinema.models.Billet;
import com.cinema.models.Seance;
import com.cinema.services.AchatService;
import com.cinema.services.BilletService;
import com.cinema.services.SeanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
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
    
    /**
     * Page d'achat de billets pour une séance
     */
    @GetMapping("/seance/{idSeance}")
    public String pageAchat(@PathVariable Long idSeance, Model model) {
        Seance seance = seanceService.getSeanceById(idSeance);
        List<Billet> billetsDisponibles = billetService.getBilletsDisponiblesBySeance(idSeance);
        List<Billet> billets = billetService.getBilletsBySeance(idSeance);
        
        model.addAttribute("seance", seance);
        model.addAttribute("billets", billets);
        model.addAttribute("billetsDisponibles", billetsDisponibles);
        
        return "achats/achat";
    }
    
    /**
     * Confirmer l'achat
     */
    @PostMapping("/confirmer")
    public String confirmerAchat(@RequestParam String nomAcheteur,
                                  @RequestParam List<Long> idsBillets,
                                  RedirectAttributes redirectAttributes) {
        try {
            Achat achat = achatService.createAchat(nomAcheteur, idsBillets);
            redirectAttributes.addFlashAttribute("success", 
                "Achat confirmé ! Total: " + achat.getTotal() + " Ar");
            redirectAttributes.addFlashAttribute("achatId", achat.getIdAchat());
            return "redirect:/achats/confirmation/" + achat.getIdAchat();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/achats/seance/" + idsBillets.get(0);
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
