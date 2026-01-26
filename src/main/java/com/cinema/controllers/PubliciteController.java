package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.PubliciteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/publicite")
public class PubliciteController {

    @Autowired
    private PubliciteService publiciteService;

    // ============ RAPPORT ============

    /**
     * GET /publicite/rapport?annee=2026&mois=1
     * Affiche le rapport mensuel des diffusions publicitaires
     */
    @GetMapping("/rapport")
    public String afficherRapport(@RequestParam(required = false) Integer annee,
                                   @RequestParam(required = false) Integer mois,
                                   Model model) {
        if (annee == null) annee = LocalDate.now().getYear();
        if (mois == null) mois = LocalDate.now().getMonthValue();
        
        Map<String, Object> rapport = publiciteService.getRapportMensuel(annee, mois);
        
        model.addAttribute("rapport", rapport);
        model.addAttribute("annee", annee);
        model.addAttribute("mois", mois);
        
        return "publicite/rapport";
    }

    /**
     * API: Obtenir le rapport en JSON
     */
    @GetMapping("/api/rapport")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRapportJSON(
            @RequestParam(required = false) Integer annee,
            @RequestParam(required = false) Integer mois) {
        
        if (annee == null) annee = LocalDate.now().getYear();
        if (mois == null) mois = LocalDate.now().getMonthValue();
        
        Map<String, Object> rapport = publiciteService.getRapportMensuel(annee, mois);
        return ResponseEntity.ok(rapport);
    }

    // ============ PAIEMENTS ============

    /**
     * GET /publicite/paiements
     * Page de gestion des paiements
     */
    @GetMapping("/paiements")
    public String afficherPaiements(Model model) {
        List<Societe> societes = publiciteService.getAllSocietes();
        List<PaiementPub> paiements = publiciteService.getAllPaiements();
        
        model.addAttribute("societes", societes);
        model.addAttribute("paiements", paiements);
        
        return "publicite/paiements";
    }

    /**
     * POST /publicite/paiements/enregistrer
     * Enregistre un nouveau paiement avec détails par diffusion
     */
    @PostMapping("/paiements/enregistrer")
    public String enregistrerPaiement(@RequestParam Long idSociete,
                                      @RequestParam BigDecimal montant,
                                      @RequestParam String dtPaiement,
                                      RedirectAttributes redirectAttributes) {
        try {
            LocalDate date = LocalDate.parse(dtPaiement);
            // Utiliser la nouvelle méthode avec détails
            Map<String, Object> resultat = publiciteService.enregistrerPaiementAvecDetails(idSociete, montant, date);
            
            if ((Boolean) resultat.get("success")) {
                String message = resultat.get("message") + 
                    " (Pourcentage: " + resultat.get("pourcentage") + "%, " +
                    "Total à payer: " + resultat.get("totalAPayer") + " Ar)";
                redirectAttributes.addFlashAttribute("success", message);
            } else {
                redirectAttributes.addFlashAttribute("error", resultat.get("message"));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/publicite/paiements";
    }

    /**
     * GET /publicite/paiements/societe/{id}
     * Obtenir les paiements d'une société
     */
    @GetMapping("/paiements/societe/{id}")
    @ResponseBody
    public ResponseEntity<List<PaiementPub>> getPaiementsBySociete(@PathVariable Long id) {
        try {
            List<PaiementPub> paiements = publiciteService.getPaiementsBySociete(id);
            return ResponseEntity.ok(paiements);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // ============ CONFIGURATIONS ============

    /**
     * GET /publicite/configurations
     * Page de gestion des configurations (CRUD)
     */
    @GetMapping("/configurations")
    public String afficherConfigurations(Model model) {
        List<Societe> societes = publiciteService.getAllSocietes();
        List<PrixPub> prix = publiciteService.getAllPrixPub();
        List<ContratPub> contrats = publiciteService.getAllContrats();
        
        model.addAttribute("societes", societes);
        model.addAttribute("prixList", prix);
        model.addAttribute("contrats", contrats);
        
        return "publicite/configurations";
    }

    // ---- Sociétés ----
    
    @PostMapping("/configurations/societes/create")
    public String createSociete(@RequestParam String nom, RedirectAttributes redirectAttributes) {
        try {
            publiciteService.createSociete(nom);
            redirectAttributes.addFlashAttribute("success", "Société créée");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/societes/{id}/update")
    public String updateSociete(@PathVariable Long id, @RequestParam String nom, 
                                RedirectAttributes redirectAttributes) {
        try {
            publiciteService.updateSociete(id, nom);
            redirectAttributes.addFlashAttribute("success", "Société modifiée");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/societes/{id}/delete")
    public String deleteSociete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            publiciteService.deleteSociete(id);
            redirectAttributes.addFlashAttribute("success", "Société supprimée");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }

    // ---- Prix ----
    
    @PostMapping("/configurations/prix/create")
    public String createPrix(@RequestParam BigDecimal valeur, RedirectAttributes redirectAttributes) {
        try {
            publiciteService.createPrixPub(valeur);
            redirectAttributes.addFlashAttribute("success", "Prix créé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/prix/{id}/update")
    public String updatePrix(@PathVariable Long id, @RequestParam BigDecimal valeur, 
                            RedirectAttributes redirectAttributes) {
        try {
            publiciteService.updatePrixPub(id, valeur);
            redirectAttributes.addFlashAttribute("success", "Prix modifié");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/prix/{id}/delete")
    public String deletePrix(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            publiciteService.deletePrixPub(id);
            redirectAttributes.addFlashAttribute("success", "Prix supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }

    // ---- Contrats ----
    
    @PostMapping("/configurations/contrats/create")
    public String createContrat(@RequestParam Long idSociete,
                               @RequestParam Long idPrix,
                               @RequestParam String dtContrat,
                               @RequestParam Integer quota,
                               RedirectAttributes redirectAttributes) {
        try {
            LocalDate date = LocalDate.parse(dtContrat);
            publiciteService.createContrat(idSociete, idPrix, date, quota);
            redirectAttributes.addFlashAttribute("success", "Contrat créé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/contrats/{id}/update")
    public String updateContrat(@PathVariable Long id,
                               @RequestParam(required = false) Long idPrix,
                               @RequestParam(required = false) String dtContrat,
                               @RequestParam(required = false) Integer quota,
                               RedirectAttributes redirectAttributes) {
        try {
            LocalDate date = dtContrat != null ? LocalDate.parse(dtContrat) : null;
            publiciteService.updateContrat(id, idPrix, date, quota);
            redirectAttributes.addFlashAttribute("success", "Contrat modifié");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }
    
    @PostMapping("/configurations/contrats/{id}/delete")
    public String deleteContrat(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            publiciteService.deleteContrat(id);
            redirectAttributes.addFlashAttribute("success", "Contrat supprimé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/publicite/configurations";
    }

    // ============ DIFFUSIONS ============

    /**
     * GET /publicite/diffusions
     * Page d'enregistrement des diffusions
     */
    @GetMapping("/diffusions")
    public String afficherDiffusions(Model model) {
        List<Seance> seances = publiciteService.getAllSeances();
        List<Societe> societes = publiciteService.getAllSocietes();
        
        model.addAttribute("seances", seances);
        model.addAttribute("societes", societes);
        
        return "publicite/diffusion";
    }

    /**
     * POST /publicite/diffusions/enregistrer
     * Enregistre une nouvelle diffusion
     */
    @PostMapping("/diffusions/enregistrer")
    public String enregistrerDiffusion(@RequestParam Long idSeance,
                                       @RequestParam Long idSociete,
                                       @RequestParam Integer nombreDiffusions,
                                       RedirectAttributes redirectAttributes) {
        try {
            publiciteService.enregistrerDiffusion(idSeance, idSociete, nombreDiffusions);
            redirectAttributes.addFlashAttribute("success", "Diffusion enregistrée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/publicite/diffusions";
    }

    /**
     * API: Obtenir les diffusions d'une séance
     */
    @GetMapping("/api/diffusions/seance/{id}")
    @ResponseBody
    public ResponseEntity<List<Diffusion>> getDiffusionsBySeance(@PathVariable Long id) {
        try {
            List<Diffusion> diffusions = publiciteService.getDiffusionsBySeance(id);
            return ResponseEntity.ok(diffusions);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
