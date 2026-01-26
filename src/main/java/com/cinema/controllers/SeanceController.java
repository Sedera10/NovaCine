package com.cinema.controllers;

import com.cinema.models.Achat;
import com.cinema.models.Salle;
import com.cinema.models.Seance;
import com.cinema.models.Tarif;
import com.cinema.models.TypePlace;
import com.cinema.models.TypePersonne;
import com.cinema.services.AchatService;
import com.cinema.services.SeanceService;
import com.cinema.services.SalleService;
import com.cinema.services.FilmService;
import com.cinema.dto.TarifDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/seances")
public class SeanceController {

    @Autowired
    private SeanceService seanceService;

    @Autowired
    private FilmService filmService;

    @Autowired
    private SalleService salleService;
    
    @Autowired
    private AchatService achatService;

    @GetMapping
    public String listSeances(@RequestParam(required = false) Long filmId,
                             @RequestParam(required = false) Long salleId,
                             @RequestParam(required = false) String date,
                             @RequestParam(required = false) String periode,
                             Model model) {
        
        List<Seance> seances;
        LocalDate dateDebut = null;
        LocalDate dateFin = null;
        
        // Déterminer la période à afficher
        String periodeActive = (periode != null && !periode.isEmpty()) ? periode : "aujourd_hui";
        
        LocalDate maintenant = LocalDate.now();
        
        switch (periodeActive) {
            case "demain":
                dateDebut = maintenant.plusDays(1);
                dateFin = maintenant.plusDays(1);
                break;
            case "semaine":
                dateDebut = maintenant;
                dateFin = maintenant.plusDays(6); // Aujourd'hui + 6 jours = 7 jours
                break;
            case "semaine_prochaine":
                dateDebut = maintenant.plusDays(7);
                dateFin = maintenant.plusDays(13);
                break;
            case "tous":
                dateDebut = null;
                dateFin = null;
                break;
            case "aujourd_hui":
            default:
                dateDebut = maintenant;
                dateFin = maintenant;
                periodeActive = "aujourd_hui";
                break;
        }
        
        // Si un filtre de date manuel est fourni, l'utiliser à la place
        if (date != null && !date.isEmpty()) {
            try {
                LocalDate dateManuelle = LocalDate.parse(date);
                dateDebut = dateManuelle;
                dateFin = dateManuelle;
                periodeActive = "custom";
            } catch (Exception e) {
                // Ignorer les dates invalides
            }
        }
        
        // Récupérer les séances avec filtres
        if (dateDebut != null && dateFin != null) {
            seances = seanceService.getSeancesByFilters(filmId, salleId, dateDebut, dateFin);
        } else {
            seances = seanceService.getSeancesByFilters(filmId, salleId, null, null);
        }
        
        model.addAttribute("seances", seances);
        model.addAttribute("salles", salleService.getAllSalles());
        model.addAttribute("films", filmService.getAllFilms());
        model.addAttribute("filmId", filmId);
        model.addAttribute("salleId", salleId);
        model.addAttribute("date", date);
        model.addAttribute("periodeActive", periodeActive);
        
        return "seances/liste";
    }

    @GetMapping("/nouveau")
    public String nouveauForm(Model model) {
        model.addAttribute("films", filmService.getAllFilms());
        model.addAttribute("salles", salleService.getAllSalles());
        model.addAttribute("typePlaces", salleService.getAllTypesPlaces());
        model.addAttribute("typeClients", seanceService.getAllTypeClients());
        return "seances/form";
    }
    
    /**
     * Affiche les détails d'une séance
     */
    @GetMapping("/{id}")
    public String detailSeance(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Seance seance = seanceService.getSeanceById(id);
        
        if (seance == null) {
            redirectAttributes.addFlashAttribute("error", "Séance introuvable");
            return "redirect:/seances";
        }
        
        // Calculer l'heure de fin (heure début + durée film + 15 min nettoyage)
        LocalTime heureFin = seance.getHeureSeance()
                .plusMinutes(seance.getFilm().getDuree())
                .plusMinutes(15);
        
        // Déterminer le statut de la séance
        String statut = determinerStatut(seance);
        
        // Récupérer les tarifs organisés par type de place et type de client
        List<Tarif> tarifs = seanceService.getTarifsBySeance(id);
        List<TypePlace> typePlaces = salleService.getAllTypesPlaces();
        List<TypePersonne> typeClients = seanceService.getAllTypeClients();
        
        // Créer une map pour accéder facilement aux tarifs: Map<idTypePlace, Map<idTypeClient, Tarif>>
        Map<Long, Map<Long, BigDecimal>> tarifMap = new HashMap<>();
        for (Tarif t : tarifs) {
            Long placeId = t.getTypePlace().getId();
            Long clientId = t.getTypeClient().getIdTypeClient();
            tarifMap.computeIfAbsent(placeId, k -> new HashMap<>()).put(clientId, t.getValeur());
        }

        BigDecimal gainsPotentiel = seanceService.gainsPotentielDefault(id);
        
        
        model.addAttribute("seance", seance);
        model.addAttribute("heureFin", heureFin);
        model.addAttribute("statut", statut);
        model.addAttribute("tarifs", tarifs);
        model.addAttribute("gainsPotentiel", gainsPotentiel);
        model.addAttribute("typePlaces", typePlaces);
        model.addAttribute("typeClients", typeClients);
        model.addAttribute("tarifMap", tarifMap);
        
        return "seances/detail";
    }
    
    /**
     * Détermine le statut d'une séance selon la date/heure actuelle
     */
    private String determinerStatut(Seance seance) {
        LocalDateTime maintenant = LocalDateTime.now();
        LocalDate dateSeance = seance.getDateSeance();
        LocalTime heureDebut = seance.getHeureSeance();
        
        // Calculer heure de fin
        int dureeFilm = seance.getFilm().getDuree();
        LocalTime heureFin = heureDebut.plusMinutes(dureeFilm).plusMinutes(15);
        
        LocalDateTime debutSeance = LocalDateTime.of(dateSeance, heureDebut);
        LocalDateTime finSeance = LocalDateTime.of(dateSeance, heureFin);
        
        // Si heure de fin passe minuit, ajouter un jour
        if (heureFin.isBefore(heureDebut)) {
            finSeance = finSeance.plusDays(1);
        }
        
        if (maintenant.isBefore(debutSeance)) {
            return "A_VENIR";
        } else if (maintenant.isAfter(finSeance)) {
            return "TERMINEE";
        } else {
            return "EN_COURS";
        }
    }

    /**
     * Crée une nouvelle séance avec ses tarifs.
     * 
     * Paramètres du formulaire:
     * - idFilm, idSalle, dtSeance, heureDebut : infos de base
     * - modeTarif : "base" ou "specifique"
     * 
     * Si modeTarif = "base":
     *   - prix_{idTypePlace} : prix unique pour chaque type de place
     * 
     * Si modeTarif = "specifique":
     *   - tarif_{idPlace}_{idClient} : prix pour chaque combinaison
     *   - tarifMode_{idPlace}_{idClient} : "fixe" ou "dependant"
     *   - tarifRef_{idPlace}_{idClient} : id du type client de référence (si dépendant)
     *   - tarifPct_{idPlace}_{idClient} : pourcentage de variation (si dépendant)
     */
    @PostMapping("/nouveau")
    public String saveSeance(HttpServletRequest request, RedirectAttributes redirectAttributes) {
        try {
            // 1. Récupérer les informations de base
            Long filmId = Long.parseLong(request.getParameter("idFilm"));
            Long salleId = Long.parseLong(request.getParameter("idSalle"));
            LocalDate date = LocalDate.parse(request.getParameter("dtSeance"));
            LocalTime time = LocalTime.parse(request.getParameter("heureDebut"));
            
            // 2. Déterminer le mode de tarification
            String modeTarif = request.getParameter("modeTarif");
            boolean isModePrixBase = "base".equals(modeTarif);
            
            if (isModePrixBase) {
                // Mode prix de base : un prix par type de place
                Map<Long, BigDecimal> prixParTypePlace = extractPrixBase(request);
                
                if (prixParTypePlace.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Veuillez définir au moins un prix");
                    return "redirect:/seances/nouveau";
                }
                
                seanceService.createSeanceWithBasePrices(filmId, salleId, date, time, prixParTypePlace);
                
            } else {
                // Mode tarification spécifique : prix par type de place ET type de client
                List<TarifDTO> tarifsDTO = extractTarifsSpecifiques(request);
                
                if (tarifsDTO.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Veuillez définir au moins un tarif");
                    return "redirect:/seances/nouveau";
                }
                
                seanceService.createSeanceWithTarifs(filmId, salleId, date, time, tarifsDTO);
            }

            redirectAttributes.addFlashAttribute("success", "Séance créée avec succès");
            return "redirect:/seances";
            
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur: " + ex.getMessage());
            return "redirect:/seances/nouveau";
        }
    }
    
    /**
     * Extrait les prix de base depuis les paramètres (prix_{idTypePlace})
     */
    private Map<Long, BigDecimal> extractPrixBase(HttpServletRequest request) {
        Map<Long, BigDecimal> prixMap = new HashMap<>();
        
        for (String paramName : request.getParameterMap().keySet()) {
            if (paramName.startsWith("prix_")) {
                try {
                    Long idTypePlace = Long.parseLong(paramName.substring(5));
                    String valeurStr = request.getParameter(paramName);
                    
                    if (valeurStr != null && !valeurStr.trim().isEmpty()) {
                        BigDecimal prix = new BigDecimal(valeurStr.trim());
                        if (prix.compareTo(BigDecimal.ZERO) > 0) {
                            prixMap.put(idTypePlace, prix);
                        }
                    }
                } catch (NumberFormatException e) {
                    // Ignorer les valeurs invalides
                }
            }
        }
        
        return prixMap;
    }
    
    /**
     * Extrait les tarifs spécifiques depuis les paramètres:
     * - tarif_{idPlace}_{idClient}
     * - tarifMode_{idPlace}_{idClient}
     * - tarifRef_{idPlace}_{idClient}
     * - tarifPct_{idPlace}_{idClient}
     */
    private List<TarifDTO> extractTarifsSpecifiques(HttpServletRequest request) {
        List<TarifDTO> tarifs = new ArrayList<>();
        
        for (String paramName : request.getParameterMap().keySet()) {
            // Chercher les paramètres tarif_{placeId}_{clientId}
            if (paramName.startsWith("tarif_") && !paramName.startsWith("tarifMode_") 
                    && !paramName.startsWith("tarifRef_") && !paramName.startsWith("tarifPct_")) {
                
                try {
                    // Extraire placeId et clientId depuis "tarif_1_2"
                    String[] parts = paramName.substring(6).split("_");
                    if (parts.length != 2) continue;
                    
                    Long idTypePlace = Long.parseLong(parts[0]);
                    Long idTypeClient = Long.parseLong(parts[1]);
                    String key = idTypePlace + "_" + idTypeClient;
                    
                    // Récupérer la valeur du tarif
                    String valeurStr = request.getParameter(paramName);
                    if (valeurStr == null || valeurStr.trim().isEmpty()) continue;
                    
                    BigDecimal valeur = new BigDecimal(valeurStr.trim());
                    if (valeur.compareTo(BigDecimal.ZERO) <= 0) continue;
                    
                    // Récupérer le mode (fixe ou dependant)
                    String mode = request.getParameter("tarifMode_" + key);
                    boolean isDependant = "dependant".equals(mode);
                    
                    // Créer le DTO
                    TarifDTO dto = new TarifDTO();
                    dto.setIdTypePlace(idTypePlace);
                    dto.setIdTypeClient(idTypeClient);
                    dto.setValeur(valeur);
                    
                    if (isDependant) {
                        // Récupérer la référence et le pourcentage
                        String refStr = request.getParameter("tarifRef_" + key);
                        if (refStr != null && !refStr.trim().isEmpty()) {
                            dto.setIdTypeClientRef(Long.parseLong(refStr.trim()));
                        }
                        // Le pourcentage est stocké pour info (le calcul est déjà fait côté JS)
                    }
                    
                    tarifs.add(dto);
                    
                } catch (NumberFormatException e) {
                    // Ignorer les valeurs invalides
                }
            }
        }
        
        return tarifs;
    }

    @GetMapping("/check")
    @ResponseBody
    public Map<String, Object> checkConflict(@RequestParam Long salleId, @RequestParam String date, @RequestParam String time) {
        Map<String, Object> res = new HashMap<>();
        try {
            LocalDate d = LocalDate.parse(date);
            LocalTime t = LocalTime.parse(time);
            var conflict = seanceService.checkConflict(salleId, d, t);
            res.put("conflict", conflict != null);
            res.put("message", conflict != null ? "Chevauchement avec la séance id=" + conflict.getIdSeance() : "Pas de conflit");
            return res;
        } catch (Exception e) {
            res.put("conflict", true);
            res.put("message", "Erreur: " + e.getMessage());
            return res;
        }
    }
    
    //Modification d'une seance
    @GetMapping("/{id}/modifier")
    public String modifierForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Seance seance = seanceService.getSeanceById(id);
        
        if (seance == null) {
            redirectAttributes.addFlashAttribute("error", "Séance introuvable");
            return "redirect:/seances";
        }
        
        // Récupérer les tarifs existants organisés par type de place et type de client
        List<Tarif> tarifs = seanceService.getTarifsBySeance(id);
        Map<Long, Map<Long, BigDecimal>> tarifMap = new HashMap<>();
        Map<Long, Map<Long, Long>> tarifRefMap = new HashMap<>(); // Pour les références dépendantes
        
        // Pour le mode prix de base : calculer un prix moyen/représentatif par type de place
        Map<Long, BigDecimal> prixParTypePlace = new HashMap<>();
        
        for (Tarif t : tarifs) {
            Long placeId = t.getTypePlace().getId();
            Long clientId = t.getTypeClient().getIdTypeClient();
            tarifMap.computeIfAbsent(placeId, k -> new HashMap<>()).put(clientId, t.getValeur());
            
            // Si tarif dépendant, stocker la référence
            if (t.getTypeClientRef() != null) {
                tarifRefMap.computeIfAbsent(placeId, k -> new HashMap<>()).put(clientId, t.getTypeClientRef().getIdTypeClient());
            }
            
            // Prendre le premier prix trouvé pour chaque type de place (pour le mode base)
            if (!prixParTypePlace.containsKey(placeId)) {
                prixParTypePlace.put(placeId, t.getValeur());
            }
        }
        
        model.addAttribute("seance", seance);
        model.addAttribute("films", filmService.getAllFilms());
        model.addAttribute("salles", salleService.getAllSalles());
        model.addAttribute("typePlaces", salleService.getAllTypesPlaces());
        model.addAttribute("typeClients", seanceService.getAllTypeClients());
        model.addAttribute("tarifMap", tarifMap);
        model.addAttribute("tarifRefMap", tarifRefMap);
        model.addAttribute("prixParTypePlace", prixParTypePlace);
        model.addAttribute("isModification", true);
        
        return "seances/form";
    }
    
    /**
     * Traite la modification d'une séance
     */
    @PostMapping("/{id}/modifier")
    public String updateSeance(@PathVariable("id") Long id, HttpServletRequest request, 
                               RedirectAttributes redirectAttributes) {
        try {
            Seance seance = seanceService.getSeanceById(id);
            if (seance == null) {
                redirectAttributes.addFlashAttribute("error", "Séance introuvable");
                return "redirect:/seances";
            }
            
            // 1. Récupérer les informations de base (date et heure modifiables)
            LocalDate date = LocalDate.parse(request.getParameter("dtSeance"));
            LocalTime time = LocalTime.parse(request.getParameter("heureDebut"));
            
            // 2. Déterminer le mode de tarification
            String modeTarif = request.getParameter("modeTarif");
            boolean isModePrixBase = "base".equals(modeTarif);
            
            if (isModePrixBase) {
                // Mode prix de base : un prix par type de place
                Map<Long, BigDecimal> prixParTypePlace = extractPrixBase(request);
                
                if (prixParTypePlace.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Veuillez définir au moins un prix");
                    return "redirect:/seances/" + id + "/modifier";
                }
                
                seanceService.updateSeanceWithBasePrices(id, date, time, prixParTypePlace);
                
            } else {
                // Mode tarification spécifique : prix par type de place ET type de client
                List<TarifDTO> tarifsDTO = extractTarifsSpecifiques(request);
                
                if (tarifsDTO.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Veuillez définir au moins un tarif");
                    return "redirect:/seances/" + id + "/modifier";
                }
                
                seanceService.updateSeanceWithTarifs(id, date, time, tarifsDTO);
            }

            redirectAttributes.addFlashAttribute("success", "Séance modifiée avec succès");
            return "redirect:/seances/" + id;
            
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur: " + ex.getMessage());
            return "redirect:/seances/" + id + "/modifier";
        }
    }

    // Les ventes d'une seance
    @GetMapping("/{id}/ventes")
    public String ventesSeance(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Seance seance = seanceService.getSeanceById(id);
        
        if (seance == null) {
            redirectAttributes.addFlashAttribute("error", "Séance introuvable");
            return "redirect:/seances";
        }
        
        Salle salle = seance.getSalle();
        List<Achat> achats = seanceService.getAchatsBySeance(id);
        
        // Calculer les totaux dynamiquement pour chaque achat
        Map<Long, BigDecimal> totauxAchats = new HashMap<>();
        Map<Long, Integer> nbBilletsAchats = new HashMap<>();
        BigDecimal totalVentes = BigDecimal.ZERO;
        int totalBilletsVendus = 0;
        
        for (Achat achat : achats) {
            BigDecimal total = achatService.calculerTotalAchat(achat);
            int nbBillets = achatService.calculerNbBillets(achat);
            
            totauxAchats.put(achat.getIdAchat(), total);
            nbBilletsAchats.put(achat.getIdAchat(), nbBillets);
            
            totalVentes = totalVentes.add(total);
            totalBilletsVendus += nbBillets;
        }
        
        // Calculer les statistiques
        int capaciteTotale = salle.getCapacite();
        int billetsDisponibles = capaciteTotale - totalBilletsVendus;
        double tauxRemplissage = capaciteTotale > 0 ? (double) totalBilletsVendus / capaciteTotale * 100 : 0;
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("capaciteTotale", capaciteTotale);
        stats.put("billetsVendus", totalBilletsVendus);
        stats.put("billetsDisponibles", billetsDisponibles);
        stats.put("tauxRemplissage", tauxRemplissage);
        
        model.addAttribute("achats", achats);
        model.addAttribute("seance", seance);
        model.addAttribute("salle", salle);
        model.addAttribute("stats", stats);
        model.addAttribute("totauxAchats", totauxAchats);
        model.addAttribute("nbBilletsAchats", nbBilletsAchats);
        model.addAttribute("totalVentes", totalVentes);
        
        return "achats/ventes-seance";
    }
}
