package com.cinema.controllers;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cinema.services.AchatService;
import com.cinema.services.PubliciteService;
import com.cinema.services.SeanceService;
import com.cinema.repositories.ContratPubRepository;
import com.cinema.repositories.PaiementDetailRepository;
import com.cinema.repositories.DiffusionRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.cinema.models.Achat;
import com.cinema.models.ContratPub;
import com.cinema.models.Diffusion;
import com.cinema.models.PaiementDetail;
import com.cinema.models.Seance;
import com.cinema.models.Societe;

@Controller
@RequestMapping("/statistiques")

public class StatistiquesController {
    @Autowired
    private PubliciteService publiciteService;

    @Autowired
    private AchatService achatService;

    @Autowired
    private SeanceService seanceService;
    
    @Autowired
    private ContratPubRepository contratPubRepository;
    
    @Autowired
    private PaiementDetailRepository paiementDetailRepository;
    
    @Autowired
    private DiffusionRepository diffusionRepository;

    @GetMapping("/seances")
    public String afficherStatsSeance(@RequestParam(required = false) Long idSeance,
                                    Model model) {
        
        List<Seance> seances = seanceService.getAllSeances();
        
        // Maps pour stocker les résultats financiers de chaque séance
        Map<Long, BigDecimal> caVentesParSeance = new HashMap<>();
        Map<Long, BigDecimal> caPubliciteParSeance = new HashMap<>();
        Map<Long, BigDecimal> caTotalParSeance = new HashMap<>();
        Map<Long, Integer> nbBilletsParSeance = new HashMap<>();
        Map<Long, BigDecimal> resteAPayerParSeance = new HashMap<>();
        Map<Long, BigDecimal> totalPayeParSeance = new HashMap<>();
        Map<Long, BigDecimal> pourcentagePayeParSeance = new HashMap<>();
        
        for (Seance s : seances) {
            // CA Ventes de la séance
            List<Achat> achats = publiciteService.getAchatsSeance(s.getIdSeance());
            BigDecimal caVentes = BigDecimal.ZERO;
            int totalBillets = 0;
            
            for (Achat achat : achats) {
                BigDecimal total = achatService.calculerTotalAchat(achat);
                int nbBillets = achatService.calculerNbBillets(achat);
                
                caVentes = caVentes.add(total);
                totalBillets += nbBillets;
            }
            
            // CA Publicité de la séance
            BigDecimal caPublicite = publiciteService.calculerCAParSeance(s.getIdSeance());
            
            // CA Total de la séance
            BigDecimal caTotal = caVentes.add(caPublicite);
            
            // Reste à payer pour la publicité de la séance
            BigDecimal resteAPayer = publiciteService.calculerResteAPayerParSeance(s.getIdSeance());
            
            // Total déjà payé pour la publicité de la séance
            BigDecimal totalPaye = publiciteService.calculerTotalPayeParSeance(s.getIdSeance());
            
            // Pourcentage déjà payé pour la publicité de la séance
            BigDecimal pourcentagePaye = publiciteService.calculerPourcentagePayeParSeance(s.getIdSeance());
            
            // Stocker les résultats
            caVentesParSeance.put(s.getIdSeance(), caVentes);
            caPubliciteParSeance.put(s.getIdSeance(), caPublicite);
            caTotalParSeance.put(s.getIdSeance(), caTotal);
            nbBilletsParSeance.put(s.getIdSeance(), totalBillets);
            resteAPayerParSeance.put(s.getIdSeance(), resteAPayer);
            totalPayeParSeance.put(s.getIdSeance(), totalPaye);
            pourcentagePayeParSeance.put(s.getIdSeance(), pourcentagePaye);
        }
        
        // Calculer les totaux par société
        List<Societe> societes = publiciteService.getAllSocietes();
        Map<String, BigDecimal> totalAPayerParSociete = new HashMap<>();
        Map<String, BigDecimal> totalPayeParSociete = new HashMap<>();
        Map<String, BigDecimal> resteAPayerParSociete = new HashMap<>();
        
        for (Societe societe : societes) {
            BigDecimal totalAPayer = BigDecimal.ZERO;
            BigDecimal totalPaye = BigDecimal.ZERO;
            
            // Parcourir toutes les séances pour calculer les totaux de cette société
            for (Seance seance : seances) {
                List<Diffusion> diffusions = publiciteService.getDiffusionsBySeance(seance.getIdSeance());
                
                // Filtrer les diffusions de cette société pour cette séance
                for (Diffusion diffusion : diffusions) {
                    if (diffusion.getSociete().getIdSociete().equals(societe.getIdSociete())) {
                        // Récupérer le prix du contrat pour calculer précisément
                        List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                            societe, seance.getDateSeance()
                        );
                        
                        if (!contrats.isEmpty()) {
                            ContratPub contrat = contrats.get(0);
                            BigDecimal prixUnitaire = contrat.getPrix().getValeur();
                            
                            // CA exact de cette diffusion
                            BigDecimal caDiffusionExact = prixUnitaire.multiply(
                                new BigDecimal(diffusion.getNombreDiffusions())
                            );
                            
                            // Montant déjà payé pour cette diffusion précise
                            List<PaiementDetail> details = paiementDetailRepository.findByDiffusion(diffusion);
                            BigDecimal payeDiffusion = details.stream()
                                .map(PaiementDetail::getMontant)
                                .reduce(BigDecimal.ZERO, BigDecimal::add);
                            
                            totalAPayer = totalAPayer.add(caDiffusionExact);
                            totalPaye = totalPaye.add(payeDiffusion);
                        }
                    }
                }
            }
            
            BigDecimal reste = totalAPayer.subtract(totalPaye);
            
            totalAPayerParSociete.put(societe.getNom(), totalAPayer);
            totalPayeParSociete.put(societe.getNom(), totalPaye);
            resteAPayerParSociete.put(societe.getNom(), reste);
        }

        model.addAttribute("seances", seances);
        model.addAttribute("caVentesParSeance", caVentesParSeance);
        model.addAttribute("caPubliciteParSeance", caPubliciteParSeance);
        model.addAttribute("caTotalParSeance", caTotalParSeance);
        model.addAttribute("nbBilletsParSeance", nbBilletsParSeance);
        model.addAttribute("resteAPayerParSeance", resteAPayerParSeance);
        model.addAttribute("totalPayeParSeance", totalPayeParSeance);
        model.addAttribute("pourcentagePayeParSeance", pourcentagePayeParSeance);
        
        model.addAttribute("societes", societes);
        model.addAttribute("totalAPayerParSociete", totalAPayerParSociete);
        model.addAttribute("totalPayeParSociete", totalPayeParSociete);
        model.addAttribute("resteAPayerParSociete", resteAPayerParSociete);
        
        return "statistiques/seances";
    }
}
