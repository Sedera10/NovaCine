package com.cinema.controllers;

import com.cinema.models.*;
import com.cinema.services.AchatService;
import com.cinema.services.SalleService;
import com.cinema.services.SeanceService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/achats")
public class AchatController {
    
    @Autowired
    private AchatService achatService;
    
    @Autowired
    private SeanceService seanceService;
    
    @Autowired
    private SalleService salleService;

    // =========================================================================
    // LISTE DES ACHATS
    // =========================================================================
    
    @GetMapping
    public String listeAchats(Model model) {
        List<Achat> achats = achatService.getAllAchats();
        // Trier par date décroissante
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
        
        return "ventes/liste";
    }

    // =========================================================================
    // FORMULAIRE DE CRÉATION (mode rapide - plusieurs billets)
    // =========================================================================
    
    @GetMapping("/nouveau")
    public String nouveauForm(Model model) {
        // Séances disponibles (à venir ou en cours)
        // List<Seance> seances = achatService.getSeancesDisponibles();
        List<Seance> seances = seanceService.getAllSeances();
        List<TypePlace> typePlaces = salleService.getAllTypesPlaces();
        List<TypePersonne> typeClients = seanceService.getAllTypeClients();
        
        model.addAttribute("seances", seances);
        model.addAttribute("typePlaces", typePlaces);
        model.addAttribute("typeClients", typeClients);
        
        return "ventes/form";
    }
    
    /**
     * API pour récupérer le tarif d'une combinaison séance/typePlace/typeClient
     */
    @GetMapping("/api/tarif")
    @ResponseBody
    public Map<String, Object> getTarif(
            @RequestParam Long idSeance,
            @RequestParam Long idTypePlace,
            @RequestParam Long idTypeClient) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            BigDecimal valeur = achatService.getTarifValeur(idSeance, idTypePlace, idTypeClient);
            response.put("success", true);
            response.put("valeur", valeur);
            response.put("valeurFormatted", valeur.longValue() + " Ar");
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            response.put("valeur", 0);
        }
        
        return response;
    }
    
    /**
     * API pour récupérer tous les tarifs d'une séance
     */
    @GetMapping("/api/tarifs-seance/{idSeance}")
    @ResponseBody
    public Map<String, Object> getTarifsSeance(@PathVariable Long idSeance) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Tarif> tarifs = achatService.getTarifsBySeance(idSeance);
            
            // Organiser par typePlace et typeClient
            Map<String, BigDecimal> tarifMap = new HashMap<>();
            for (Tarif t : tarifs) {
                String key = t.getTypePlace().getId() + "_" + t.getTypeClient().getIdTypeClient();
                tarifMap.put(key, t.getValeur());
            }
            
            response.put("success", true);
            response.put("tarifs", tarifMap);
            
            // Aussi inclure les infos de la séance
            Seance seance = seanceService.getSeanceById(idSeance);
            if (seance != null) {
                Map<String, Object> seanceInfo = new HashMap<>();
                seanceInfo.put("film", seance.getFilm().getTitre());
                seanceInfo.put("salle", seance.getSalle().getNom());
                seanceInfo.put("date", seance.getDateSeance().toString());
                seanceInfo.put("heure", seance.getHeureSeance().toString());
                response.put("seance", seanceInfo);
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
    
    /**
     * API pour récupérer les types de places d'une salle (pour une séance)
     */
    @GetMapping("/api/types-places-seance/{idSeance}")
    @ResponseBody
    public Map<String, Object> getTypesPlacesSeance(@PathVariable Long idSeance) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Seance seance = seanceService.getSeanceById(idSeance);
            if (seance == null) {
                response.put("success", false);
                response.put("error", "Séance introuvable");
                return response;
            }
            
            // Récupérer les tarifs pour savoir quels types de places sont configurés
            List<Tarif> tarifs = achatService.getTarifsBySeance(idSeance);
            Set<Long> typePlaceIds = new HashSet<>();
            for (Tarif t : tarifs) {
                typePlaceIds.add(t.getTypePlace().getId());
            }
            
            // Récupérer les types de places correspondants
            List<Map<String, Object>> typePlaces = new ArrayList<>();
            for (TypePlace tp : salleService.getAllTypesPlaces()) {
                if (typePlaceIds.contains(tp.getId())) {
                    Map<String, Object> tpMap = new HashMap<>();
                    tpMap.put("id", tp.getId());
                    tpMap.put("nom", tp.getNom());
                    typePlaces.add(tpMap);
                }
            }
            
            response.put("success", true);
            response.put("typePlaces", typePlaces);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Traitement du formulaire d'achat
     */
    @PostMapping("/nouveau")
    public String saveAchat(HttpServletRequest request, RedirectAttributes redirectAttributes) {
        try {
            // 1. Récupérer les paramètres de base
            String idSeanceStr = request.getParameter("idSeance");
            String nomClient = request.getParameter("nomClient");
            
            if (idSeanceStr == null || idSeanceStr.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner une séance");
                return "redirect:/achats/nouveau";
            }
            
            Long idSeance = Long.parseLong(idSeanceStr.trim());
            
            if (nomClient == null || nomClient.trim().isEmpty()) {
                nomClient = "Client anonyme";
            }
            
            // 2. Extraire les lignes d'achat
            List<AchatLigne> lignes = extractLignes(request);
            
            if (lignes.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez ajouter au moins une ligne d'achat");
                return "redirect:/achats/nouveau";
            }
            
            // 3. Créer l'achat
            Achat achat = achatService.creerAchat(idSeance, nomClient.trim(), lignes);
            
            // Calculer le total dynamiquement
            BigDecimal total = achatService.calculerTotalAchat(achat);
            
            redirectAttributes.addFlashAttribute("success", 
                "Achat #" + achat.getIdAchat() + " créé avec succès ! Total: " + total + " Ar");
            return "redirect:/achats/" + achat.getIdAchat();
            
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur: " + ex.getMessage());
            return "redirect:/achats/nouveau";
        }
    }
    
    /**
     * Extrait les lignes d'achat depuis les paramètres du formulaire
     * Format: ligne_{index}_typePlace, ligne_{index}_typeClient, ligne_{index}_quantite
     * Retourne une liste de AchatLigne (sans achat ni prix, juste typePlace, typeClient, quantite)
     */
    private List<AchatLigne> extractLignes(HttpServletRequest request) {
        List<AchatLigne> lignes = new ArrayList<>();
        Map<Integer, AchatLigne> ligneMap = new TreeMap<>();
        
        for (String paramName : request.getParameterMap().keySet()) {
            if (paramName.startsWith("ligne_") && paramName.contains("_typePlace")) {
                try {
                    // Extraire l'index depuis "ligne_0_typePlace"
                    String[] parts = paramName.split("_");
                    int index = Integer.parseInt(parts[1]);
                    
                    String typePlaceStr = request.getParameter("ligne_" + index + "_typePlace");
                    String typeClientStr = request.getParameter("ligne_" + index + "_typeClient");
                    String quantiteStr = request.getParameter("ligne_" + index + "_quantite");
                    
                    if (typePlaceStr == null || typePlaceStr.isEmpty()) continue;
                    if (typeClientStr == null || typeClientStr.isEmpty()) continue;
                    if (quantiteStr == null || quantiteStr.isEmpty()) continue;
                    
                    Long idTypePlace = Long.parseLong(typePlaceStr);
                    Long idTypeClient = Long.parseLong(typeClientStr);
                    Integer quantite = Integer.parseInt(quantiteStr);
                    
                    if (quantite > 0) {
                        // Récupérer les entités TypePlace et TypePersonne
                        TypePlace typePlace = achatService.getTypePlaceById(idTypePlace);
                        TypePersonne typeClient = achatService.getTypeClientById(idTypeClient);
                        
                        if (typePlace != null && typeClient != null) {
                            AchatLigne ligne = new AchatLigne();
                            ligne.setTypePlace(typePlace);
                            ligne.setTypeClient(typeClient);
                            ligne.setQuantite(quantite);
                            ligneMap.put(index, ligne);
                        }
                    }
                    
                } catch (NumberFormatException e) {
                    // Ignorer les valeurs invalides
                }
            }
        }
        
        lignes.addAll(ligneMap.values());
        return lignes;
    }
    
    // =========================================================================
    // DÉTAIL D'UN ACHAT
    // =========================================================================
    
    @GetMapping("/{id}")
    public String detailAchat(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Achat achat = achatService.getAchatById(id);
        
        if (achat == null) {
            redirectAttributes.addFlashAttribute("error", "Achat introuvable");
            return "redirect:/achats";
        }
        
        // Calculer dynamiquement les prix
        BigDecimal totalCalcule = achatService.calculerTotalAchat(achat);
        int nbBillets = achatService.calculerNbBillets(achat);
        Map<Long, Map<String, BigDecimal>> detailsLignes = achatService.getDetailsCalculAchat(achat);
        
        model.addAttribute("achat", achat);
        model.addAttribute("totalCalcule", totalCalcule);
        model.addAttribute("nbBillets", nbBillets);
        model.addAttribute("detailsLignes", detailsLignes);
        
        return "ventes/detail";
    }
    
    // =========================================================================
    // ACHAT AVEC SÉLECTION DE PLACES (mode visuel)
    // =========================================================================
    
    /**
     * Affiche le formulaire d'achat avec plan de salle pour une séance
     */
    @GetMapping("/seance/{idSeance}")
    public String achatAvecPlan(@PathVariable Long idSeance, Model model, RedirectAttributes redirectAttributes) {
        Seance seance = seanceService.getSeanceById(idSeance);
        
        if (seance == null) {
            redirectAttributes.addFlashAttribute("error", "Séance introuvable");
            return "redirect:/seances";
        }
        
        Salle salle = seance.getSalle();
        
        // Configuration de la salle (nombre de places par type)
        List<ConfigSalles> configSalle = salleService.getConfigurationsBySalle(salle);
        
        // Map: idTypePlace -> nombre de places configurées
        Map<Long, Integer> capaciteParTypePlace = new HashMap<>();
        for (ConfigSalles config : configSalle) {
            capaciteParTypePlace.put(config.getTypePlace().getId(), config.getNombre());
        }
        
        // Nombre de places déjà vendues par type de place
        Map<Long, Integer> vendusParTypePlace = achatService.getBilletsVendusParTypePlace(idSeance);
        
        // Types de places et types de clients
        List<TypePlace> typePlaces = salleService.getAllTypesPlaces();
        List<TypePersonne> typeClients = seanceService.getAllTypeClients();
        
        // Tarifs pour cette séance: Map<"idTypePlace_idTypeClient", valeur>
        List<Tarif> tarifs = achatService.getTarifsBySeance(idSeance);
        Map<String, BigDecimal> tarifMap = new HashMap<>();
        for (Tarif t : tarifs) {
            String key = t.getTypePlace().getId() + "_" + t.getTypeClient().getIdTypeClient();
            tarifMap.put(key, t.getValeur());
        }
        
        model.addAttribute("seance", seance);
        model.addAttribute("salle", salle);
        model.addAttribute("configSalle", configSalle);
        model.addAttribute("capaciteParTypePlace", capaciteParTypePlace);
        model.addAttribute("vendusParTypePlace", vendusParTypePlace);
        model.addAttribute("typePlaces", typePlaces);
        model.addAttribute("typeClients", typeClients);
        model.addAttribute("tarifMap", tarifMap);
        
        return "achats/achat-places";
    }
    
    /**
     * Traite l'achat avec sélection de places
     * Le formulaire envoie les mêmes données que le mode rapide
     */
    @PostMapping("/seance/{idSeance}")
    public String saveAchatAvecPlan(@PathVariable Long idSeance, HttpServletRequest request, 
                                     RedirectAttributes redirectAttributes) {
        try {
            String nomClient = request.getParameter("nomClient");
            
            if (nomClient == null || nomClient.trim().isEmpty()) {
                nomClient = "Client anonyme";
            }
            
            // Extraire les lignes d'achat (même format que mode rapide)
            List<AchatLigne> lignes = extractLignes(request);
            
            if (lignes.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner au moins une place");
                return "redirect:/achats/seance/" + idSeance;
            }
            
            // Créer l'achat
            Achat achat = achatService.creerAchat(idSeance, nomClient.trim(), lignes);
            
            BigDecimal total = achatService.calculerTotalAchat(achat);
            
            redirectAttributes.addFlashAttribute("success", 
                "Achat #" + achat.getIdAchat() + " créé avec succès ! Total: " + total + " Ar");
            return "redirect:/achats/" + achat.getIdAchat();
            
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur: " + ex.getMessage());
            return "redirect:/achats/seance/" + idSeance;
        }
    }
}
