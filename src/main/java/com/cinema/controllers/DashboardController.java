package com.cinema.controllers;

import com.cinema.models.Achat;
import com.cinema.services.AchatService;
import com.cinema.services.PubliciteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private PubliciteService publiciteService;

    @Autowired
    private AchatService achatService;

    /**
     * GET /dashboard?annee=2026&mois=1
     * Affiche le dashboard global avec CA ventes + CA publicité
     */
    @GetMapping
    public String afficherDashboard(@RequestParam(required = false) Integer annee,
                                    @RequestParam(required = false) Integer mois,
                                    Model model) {
        if (annee == null) annee = LocalDate.now().getYear();
        if (mois == null) mois = LocalDate.now().getMonthValue();
        
        List<Achat> achats = publiciteService.getAchatsMonth(mois, annee);
        achats.sort((a, b) -> b.getDtAchat().compareTo(a.getDtAchat()));

        Map<Long, BigDecimal> totauxAchats = new HashMap<>();
        Map<Long, Integer> nbBilletsAchats = new HashMap<>();
        BigDecimal chiffreAffaires = BigDecimal.ZERO;
        int totalBillets = 0;
        
        for (Achat achat : achats) {
            BigDecimal total = achatService.calculerTotalAchat(achat);
            int nbBillets = achatService.calculerNbBillets(achat);
            
            totauxAchats.put(achat.getIdAchat(), total);
            nbBilletsAchats.put(achat.getIdAchat(), nbBillets);
            
            chiffreAffaires = chiffreAffaires.add(total);
            totalBillets += nbBillets;
        }

        // CA Ventes
        BigDecimal caVentes = chiffreAffaires;
        
        // CA Publicité (réel) vo jerena 
        BigDecimal caPublicite = publiciteService.calculerCAReelPublicite(annee, mois);
        
        // CA Total
        BigDecimal caTotal = caVentes.add(caPublicite);
        
        // Rapport publicité détaillé
        Map<String, Object> rapportPub = publiciteService.getRapportMensuel(annee, mois);
        
        model.addAttribute("annee", annee);
        model.addAttribute("mois", mois);
        model.addAttribute("caVentes", caVentes);
        model.addAttribute("caPublicite", caPublicite);
        model.addAttribute("caTotal", caTotal);
        model.addAttribute("rapportPub", rapportPub);
        
        return "dashboard/index";
    }

    public String test(@RequestParam(required = false) Integer annee,
                                    @RequestParam(required = false) Integer mois,
                                    Model model) {
        List<Achat> achats = achatService.getAllAchats();
        achats.sort((a, b) -> b.getDtAchat().compareTo(a.getDtAchat()));

        
        
        // Calculer les totaux dynamiquement pour chaque achat
        Map<Long, BigDecimal> totauxAchats = new HashMap<>();
        Map<Long, Integer> nbBilletsAchats = new HashMap<>();
        BigDecimal chiffreAffaires = BigDecimal.ZERO;
        int totalBillets = 0;
        
        for (Achat achat : achats) {
            BigDecimal total = achatService.calculerTotalAchat(achat);
            int nbBillets = achatService.calculerNbBillets(achat);
            
            totauxAchats.put(achat.getIdAchat(), total);
            nbBilletsAchats.put(achat.getIdAchat(), nbBillets);
            
            chiffreAffaires = chiffreAffaires.add(total);
            totalBillets += nbBillets;
        }
        
        model.addAttribute("achats", achats);
        model.addAttribute("totauxAchats", totauxAchats);
        model.addAttribute("nbBilletsAchats", nbBilletsAchats);
        model.addAttribute("chiffreAffaires", chiffreAffaires);
        model.addAttribute("totalBillets", totalBillets);
        
        return "dashboard/index";
    }

    /**
     * API: Données pour le diagramme annuel
     * GET /dashboard/api/annee/{annee}
     */
    @GetMapping("/api/annee/{annee}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDonneesAnnuelles(@PathVariable Integer annee) {
        Map<String, Object> donnees = new HashMap<>();
        
        BigDecimal[] caVentes = new BigDecimal[12];
        BigDecimal[] caPublicite = new BigDecimal[12];
        BigDecimal[] caTotal = new BigDecimal[12];
        
        for (int mois = 1; mois <= 12; mois++) {
            caVentes[mois - 1] = publiciteService.calculerCAVentes(annee, mois);
            caPublicite[mois - 1] = publiciteService.calculerCAReelPublicite(annee, mois);
            caTotal[mois - 1] = caVentes[mois - 1].add(caPublicite[mois - 1]);
        }
        
        donnees.put("annee", annee);
        donnees.put("caVentes", caVentes);
        donnees.put("caPublicite", caPublicite);
        donnees.put("caTotal", caTotal);
        donnees.put("mois", new String[]{"Jan", "Fév", "Mar", "Avr", "Mai", "Jun", 
                                         "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"});
        
        return ResponseEntity.ok(donnees);
    }

    /**
     * API: CA pour un mois donné
     * GET /dashboard/api/ca?annee=2026&mois=1
     */
    @GetMapping("/api/ca")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCAMensuel(
            @RequestParam(required = false) Integer annee,
            @RequestParam(required = false) Integer mois) {
        
        if (annee == null) annee = LocalDate.now().getYear();
        if (mois == null) mois = LocalDate.now().getMonthValue();
        
        Map<String, Object> ca = new HashMap<>();
        
        BigDecimal caVentes = publiciteService.calculerCAVentes(annee, mois);
        BigDecimal caPublicite = publiciteService.calculerCAReelPublicite(annee, mois);
        BigDecimal caTotal = caVentes.add(caPublicite);
        
        ca.put("annee", annee);
        ca.put("mois", mois);
        ca.put("caVentes", caVentes);
        ca.put("caPublicite", caPublicite);
        ca.put("caTotal", caTotal);
        
        return ResponseEntity.ok(ca);
    }
}
