package com.cinema.services;

import com.cinema.models.*;
import com.cinema.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class PubliciteService {

    @Autowired
    private SocieteRepository societeRepository;

    @Autowired
    private ContratPubRepository contratPubRepository;

    @Autowired
    private DiffusionRepository DiffusionRepository;

    @Autowired
    private SeanceRepository seanceRepository;

    @Autowired
    private AchatRepository achatRepository;

    @Autowired
    private PaiementPubRepository paiementPubRepository;

    @Autowired
    private PrixPubRepository prixPubRepository;
    
    @Autowired
    private DiffusionRepository diffusionRepository;
    
    @Autowired
    private PaiementDetailRepository paiementDetailRepository;

    // ============ CALCULS CA PUBLICITÉ ============
    
    /**
     * Helper pour récupérer le premier contrat (le plus récent) d'une liste
     */
    private ContratPub getPremierContrat(List<ContratPub> contrats) {
        return contrats.isEmpty() ? null : contrats.get(0);
    }

    /**
     * Calcule le CA réel des diffusions pour un mois donné (utilise la méthode du repository)
     */
    public BigDecimal calculerCAReelPublicite(int annee, int mois) {
        LocalDate date = LocalDate.of(annee, mois, 1);
        return diffusionRepository.calculerCAReelParMois(date);
    }
    
    /**
     * Calcule le CA maximum (théorique) des contrats pour un mois donné
     */
    public BigDecimal calculerCAMaximumPublicite(int annee, int mois) {
        LocalDate date = LocalDate.of(annee, mois, 1);
        return contratPubRepository.calculerCAMaximumParMois(date);
    }
    
    /**
     * Calcule le reste à payer pour une séance (toutes les diffusions de publicité de cette séance)
     */
    public BigDecimal calculerResteAPayerParSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        
        List<Diffusion> diffusions = diffusionRepository.findBySeance(seance);
        BigDecimal totalAPayer = BigDecimal.ZERO;
        BigDecimal totalPaye = BigDecimal.ZERO;
        
        for (Diffusion diffusion : diffusions) {
            // Récupérer le contrat pour avoir le prix unitaire
            List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                diffusion.getSociete(), 
                seance.getDateSeance()
            );
            
            ContratPub contrat = getPremierContrat(contrats);
            if (contrat != null) {
                BigDecimal prixUnitaire = contrat.getPrix().getValeur();
                BigDecimal montantDiffusion = prixUnitaire.multiply(new BigDecimal(diffusion.getNombreDiffusions()));
                totalAPayer = totalAPayer.add(montantDiffusion);
                
                // Calculer le montant déjà payé pour cette diffusion
                BigDecimal dejaPaye = calculerMontantPayePourDiffusion(diffusion);
                totalPaye = totalPaye.add(dejaPaye);
            }
        }
        
        return totalAPayer.subtract(totalPaye);
    }
    
    /**
     * Calcule le total déjà payé pour une séance (toutes les diffusions)
     */
    public BigDecimal calculerTotalPayeParSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        
        List<Diffusion> diffusions = diffusionRepository.findBySeance(seance);
        BigDecimal totalPaye = BigDecimal.ZERO;
        
        for (Diffusion diffusion : diffusions) {
            BigDecimal dejaPaye = calculerMontantPayePourDiffusion(diffusion);
            totalPaye = totalPaye.add(dejaPaye);
        }
        
        return totalPaye;
    }
    
    /**
     * Calcule le pourcentage déjà payé pour une séance
     */
    public BigDecimal calculerPourcentagePayeParSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        
        List<Diffusion> diffusions = diffusionRepository.findBySeance(seance);
        BigDecimal totalAPayer = BigDecimal.ZERO;
        BigDecimal totalPaye = BigDecimal.ZERO;
        
        for (Diffusion diffusion : diffusions) {
            // Récupérer le contrat pour avoir le prix unitaire
            List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                diffusion.getSociete(), 
                seance.getDateSeance()
            );
            
            ContratPub contrat = getPremierContrat(contrats);
            if (contrat != null) {
                BigDecimal prixUnitaire = contrat.getPrix().getValeur();
                BigDecimal montantDiffusion = prixUnitaire.multiply(new BigDecimal(diffusion.getNombreDiffusions()));
                totalAPayer = totalAPayer.add(montantDiffusion);
                
                // Calculer le montant déjà payé pour cette diffusion
                BigDecimal dejaPaye = calculerMontantPayePourDiffusion(diffusion);
                totalPaye = totalPaye.add(dejaPaye);
            }
        }
        
        // Éviter la division par zéro
        if (totalAPayer.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        
        // Calculer le pourcentage: (totalPaye / totalAPayer) × 100
        return totalPaye
            .multiply(new BigDecimal("100"))
            .divide(totalAPayer, 2, BigDecimal.ROUND_HALF_UP);
    }

    
    // ============ RAPPORT MENSUEL ============

    /**
     * Génère un rapport complet pour un mois donné
     */
    public Map<String, Object> getRapportMensuel(int annee, int mois) {
        Map<String, Object> rapport = new HashMap<>();
        LocalDate dateMois = LocalDate.of(annee, mois, 1);
        YearMonth yearMonth = YearMonth.of(annee, mois);
        
        List<Societe> societes = societeRepository.findAll();
        List<Map<String, Object>> detailsSocietes = societes.stream()
            .map(societe -> {
                Map<String, Object> detail = new HashMap<>();
                detail.put("societe", societe.getNom());
                detail.put("idSociete", societe.getIdSociete());
                
                // Récupérer le contrat
                List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(societe, dateMois);
                ContratPub contrat = getPremierContrat(contrats);
                
                if (contrat != null) {
                    ContratPub c = contrat;
                    detail.put("quota", c.getQuota());
                    
                    // Montant du contrat = quota × prix
                    BigDecimal montantContrat = new BigDecimal(c.getQuota())
                        .multiply(c.getPrix().getValeur());
                    detail.put("montantContrat", montantContrat);
                    
                    // Nombre de diffusions effectuées
                    Long nbDiffusions = diffusionRepository.countDiffusionsByMonth(
                        societe, dateMois);
                    detail.put("nombreDiffusions", nbDiffusions);
                    
                    // Total payé
                    BigDecimal totalPaye = paiementPubRepository.sumBySocieteAndPeriod(
                        societe, yearMonth.atDay(1), yearMonth.atEndOfMonth());
                    detail.put("totalPaye", totalPaye);
                    
                    // Reste à payer = montantContrat - totalPaye
                    BigDecimal resteAPayer = montantContrat.subtract(totalPaye);
                    detail.put("resteAPayer", resteAPayer);
                } else {
                    detail.put("quota", 0);
                    detail.put("montantContrat", BigDecimal.ZERO);
                    detail.put("nombreDiffusions", 0L);
                    detail.put("totalPaye", BigDecimal.ZERO);
                    detail.put("resteAPayer", BigDecimal.ZERO);
                }
                
                return detail;
            })
            .toList();
        
        // Totaux globaux
        BigDecimal caReel = calculerCAReelPublicite(annee, mois);
        BigDecimal caMaximum = calculerCAMaximumPublicite(annee, mois);
        
        BigDecimal totalPayeGlobal = societes.stream()
            .map(s -> paiementPubRepository.sumBySocieteAndPeriod(
                s, yearMonth.atDay(1), yearMonth.atEndOfMonth()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        BigDecimal resteAPayerGlobal = caMaximum.subtract(totalPayeGlobal);
        
        rapport.put("annee", annee);
        rapport.put("mois", mois);
        rapport.put("societes", detailsSocietes);
        rapport.put("caReel", caReel);
        rapport.put("caMaximum", caMaximum);
        rapport.put("totalPaye", totalPayeGlobal);
        rapport.put("resteAPayer", resteAPayerGlobal);
        
        return rapport;
    }

    
    // ============ GESTION DIFFUSIONS ============

    /**
     * Enregistre une nouvelle diffusion après validation du quota
     */
    public Diffusion enregistrerDiffusion(Long idSeance, Long idSociete, Integer nombreDiffusions) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        
        LocalDate dateDiffusion = seance.getDateSeance();
        
        // Vérifier le contrat et le quota
        List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(societe, dateDiffusion);
        ContratPub contrat = getPremierContrat(contrats);
        if (contrat == null) {
            throw new IllegalStateException("Aucun contrat actif pour cette société ce mois-ci");
        }
        
        Long diffusionsActuelles = diffusionRepository.countDiffusionsByMonth(
            societe, dateDiffusion);
        
        if (diffusionsActuelles + nombreDiffusions > contrat.getQuota()) {
            throw new IllegalStateException(
                String.format("Quota dépassé ! Utilisé: %d, Demandé: %d, Quota: %d",
                    diffusionsActuelles, nombreDiffusions, contrat.getQuota()));
        }
        
        LocalDateTime dtDiffusion = seance.getDateSeance().atTime(seance.getHeureSeance());
        Diffusion diffusion = new Diffusion(dtDiffusion, nombreDiffusions, seance, societe);
        return diffusionRepository.save(diffusion);
    }
    
    public List<Diffusion> getDiffusionsBySeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        return diffusionRepository.findBySeance(seance);
    }
    
    // ============ GESTION PAIEMENTS ============

    /**
     * Enregistre un paiement avec gestion automatique de l'excédent sur le mois suivant
     */
    public Map<String, Object> enregistrerPaiement(Long idSociete, BigDecimal montant, LocalDate dtPaiement) {
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        
        Map<String, Object> resultat = new HashMap<>();
        int mois = dtPaiement.getMonthValue();
        int annee = dtPaiement.getYear();
        
        // Calculer le reste à payer pour le mois en cours
        BigDecimal resteAPayer = calculerResteAPayer(societe, annee, mois);
        
        if (montant.compareTo(resteAPayer) <= 0) {
            // Montant <= reste : un seul paiement
            PaiementPub paiement = new PaiementPub(montant, dtPaiement, societe, "Paiement de societe " + societe.getNom());
            paiementPubRepository.save(paiement);
            
            resultat.put("success", true);
            resultat.put("message", "Paiement enregistré");
            resultat.put("montantMoisActuel", montant);
            resultat.put("montantMoisSuivant", BigDecimal.ZERO);
        } else {
            // Montant > reste : répartir sur 2 mois
            BigDecimal excedent = montant.subtract(resteAPayer);
            
            // Paiement 1 : solde du mois actuel
            if (resteAPayer.compareTo(BigDecimal.ZERO) > 0) {
                PaiementPub paiement1 = new PaiementPub(resteAPayer, dtPaiement, societe, "Paiement de societe " + societe.getNom());
                paiementPubRepository.save(paiement1);
            }
            
            // Vérifier qu'un contrat existe pour le mois suivant
            LocalDate moisSuivant = dtPaiement.plusMonths(1);
            List<ContratPub> contratsSuivants = contratPubRepository.findBySocieteAndMonth(
                societe, moisSuivant);
            ContratPub contratSuivant = getPremierContrat(contratsSuivants);
            
            if (contratSuivant == null) {
                resultat.put("success", false);
                resultat.put("message", "Excédent de paiement mais pas de contrat pour le mois suivant");
                resultat.put("montantMoisActuel", resteAPayer);
                resultat.put("excedentNonAffecte", excedent);
            } else {
                // Paiement 2 : excédent sur le mois suivant
                PaiementPub paiement2 = new PaiementPub(excedent, moisSuivant, societe, "Paiement de societe " + societe.getNom());
                paiementPubRepository.save(paiement2);
                
                resultat.put("success", true);
                resultat.put("message", "Paiement réparti sur 2 mois");
                resultat.put("montantMoisActuel", resteAPayer);
                resultat.put("montantMoisSuivant", excedent);
            }
        }
        
        return resultat;
    }
    
    public List<PaiementPub> getPaiementsBySociete(Long idSociete) {
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        return paiementPubRepository.findBySociete(societe);
    }

    public List<PaiementPub> getAllPaiements() {
        return paiementPubRepository.findAll()
            .stream()
            .sorted((p1, p2) -> p2.getDtPaiement().compareTo(p1.getDtPaiement()))
            .toList();
    }
    
    /**
     * Calcule le reste à payer d'une société pour un mois donné
     */
    public BigDecimal calculerResteAPayer(Societe societe, int annee, int mois) {
        LocalDate dateMois = LocalDate.of(annee, mois, 1);
        YearMonth yearMonth = YearMonth.of(annee, mois);
        
        List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(societe, dateMois);
        ContratPub contrat = getPremierContrat(contrats);
        if (contrat == null) {
            return BigDecimal.ZERO;
        }
        
        // Montant du contrat = quota × prix
        BigDecimal montantContrat = new BigDecimal(contrat.getQuota())
            .multiply(contrat.getPrix().getValeur());
        
        // Total payé
        BigDecimal totalPaye = paiementPubRepository.sumBySocieteAndPeriod(
            societe, yearMonth.atDay(1), yearMonth.atEndOfMonth());
        
        return montantContrat.subtract(totalPaye);
    }
    
    // ============ NOUVEAU SYSTÈME DE PAIEMENT AVEC DÉTAILS ============
    
    /**
     * Enregistre un paiement avec répartition par diffusion
     * @param idSociete ID de la société
     * @param montant Montant payé
     * @param dtPaiement Date du paiement
     * @return Résultat avec détails
     */
    public Map<String, Object> enregistrerPaiementAvecDetails(Long idSociete, BigDecimal montant, LocalDate dtPaiement) {
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        
        Map<String, Object> resultat = new HashMap<>();
        
        // Étape 1: Calculer le total à payer (toutes les diffusions non payées)
        BigDecimal totalAPayer = calculerTotalAPayer(societe, dtPaiement);
        
        if (totalAPayer.compareTo(BigDecimal.ZERO) == 0) {
            resultat.put("success", false);
            resultat.put("message", "Aucune diffusion à payer pour cette société");
            return resultat;
        }
        
        // Étape 2: Calculer le pourcentage
        BigDecimal pourcentage = montant.multiply(new BigDecimal("100"))
            .divide(totalAPayer, 2, BigDecimal.ROUND_HALF_UP);
        
        // Étape 3: Créer le paiement mère
        PaiementPub paiement = new PaiementPub(
            montant, 
            dtPaiement, 
            societe, 
            "Paiement de " + montant + " Ar sur " + totalAPayer + " Ar", 
            pourcentage
        );
        
        // Étape 4: Répartir le paiement sur les diffusions
        repartirPaiementSurDiffusions(paiement, societe, dtPaiement, pourcentage);
        
        // Sauvegarder (cascade va sauvegarder les détails)
        paiementPubRepository.save(paiement);
        
        resultat.put("success", true);
        resultat.put("message", "Paiement enregistré avec " + paiement.getDetails().size() + " détails");
        resultat.put("montant", montant);
        resultat.put("totalAPayer", totalAPayer);
        resultat.put("pourcentage", pourcentage);
        resultat.put("nbDetails", paiement.getDetails().size());
        
        return resultat;
    }
    
    /**
     * Calcule le total à payer pour une société (toutes diffusions non entièrement payées)
     */
    private BigDecimal calculerTotalAPayer(Societe societe, LocalDate dateReference) {
        // Récupérer toutes les diffusions de la société
        List<Diffusion> diffusions = diffusionRepository.findBySociete(societe);
        
        BigDecimal total = BigDecimal.ZERO;
        
        for (Diffusion diffusion : diffusions) {
            // Récupérer le prix unitaire via le contrat
            List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                societe, 
                diffusion.getSeance().getDateSeance()
            );
            
            ContratPub contrat = getPremierContrat(contrats);
            if (contrat != null) {
                BigDecimal prixUnitaire = contrat.getPrix().getValeur();
                BigDecimal montantDiffusion = prixUnitaire.multiply(new BigDecimal(diffusion.getNombreDiffusions()));
                
                // Calculer ce qui a déjà été payé pour cette diffusion
                BigDecimal dejaPaye = calculerMontantPayePourDiffusion(diffusion);
                BigDecimal resteAPayer = montantDiffusion.subtract(dejaPaye);
                
                if (resteAPayer.compareTo(BigDecimal.ZERO) > 0) {
                    total = total.add(resteAPayer);
                }
            }
        }
        
        return total;
    }
    
    /**
     * Calcule le montant déjà payé pour une diffusion
     */
    private BigDecimal calculerMontantPayePourDiffusion(Diffusion diffusion) {
        List<PaiementDetail> details = paiementDetailRepository.findByDiffusion(diffusion);
        return details.stream()
            .map(PaiementDetail::getMontant)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    /**
     * Répartit le paiement sur les diffusions selon le pourcentage
     */
    private void repartirPaiementSurDiffusions(PaiementPub paiement, Societe societe, LocalDate dateReference, BigDecimal pourcentage) {
        // Récupérer toutes les diffusions de la société
        List<Diffusion> diffusions = diffusionRepository.findBySociete(societe);
        
        // Grouper les diffusions par séance
        Map<Seance, List<Diffusion>> diffusionsParSeance = new HashMap<>();
        for (Diffusion diffusion : diffusions) {
            diffusionsParSeance
                .computeIfAbsent(diffusion.getSeance(), k -> new java.util.ArrayList<>())
                .add(diffusion);
        }
        
        // Pour chaque séance, calculer le montant à payer
        for (Map.Entry<Seance, List<Diffusion>> entry : diffusionsParSeance.entrySet()) {
            Seance seance = entry.getKey();
            List<Diffusion> diffusionsSeance = entry.getValue();
            
            // Calculer le sous-total de la séance
            BigDecimal sousTotal = BigDecimal.ZERO;
            
            // Récupérer le prix unitaire
            List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                societe, 
                seance.getDateSeance()
            );
            
            ContratPub contrat = getPremierContrat(contrats);
            if (contrat == null) continue;
            
            BigDecimal prixUnitaire = contrat.getPrix().getValeur();
            
            // Pour chaque diffusion de cette séance
            for (Diffusion diffusion : diffusionsSeance) {
                BigDecimal montantDiffusion = prixUnitaire.multiply(new BigDecimal(diffusion.getNombreDiffusions()));
                BigDecimal dejaPaye = calculerMontantPayePourDiffusion(diffusion);
                BigDecimal resteAPayer = montantDiffusion.subtract(dejaPaye);
                
                if (resteAPayer.compareTo(BigDecimal.ZERO) > 0) {
                    // Appliquer le pourcentage au reste à payer
                    BigDecimal montantDetail = resteAPayer
                        .multiply(pourcentage)
                        .divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP);
                    
                    // Créer le détail de paiement
                    PaiementDetail detail = new PaiementDetail(montantDetail, diffusion, paiement);
                    paiement.addDetail(detail);
                }
            }
        }
    }

    
    // ============ GESTION CONFIGURATIONS (CRUD) ============
    
    // Sociétés
    public Societe createSociete(String nom) {
        Societe societe = new Societe(nom);
        return societeRepository.save(societe);
    }
    
    public List<Societe> getAllSocietes() {
        return societeRepository.findAll();
    }

    public Optional<Societe> getSocieteById(Long id) {
        return societeRepository.findById(id);
    }
    
    public Societe updateSociete(Long id, String nom) {
        Societe societe = societeRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        societe.setNom(nom);
        return societeRepository.save(societe);
    }
    
    public void deleteSociete(Long id) {
        societeRepository.deleteById(id);
    }
    
    // Prix de publicité
    public PrixPub createPrixPub(BigDecimal valeur) {
        PrixPub prix = new PrixPub(valeur);
        return prixPubRepository.save(prix);
    }
    
    public List<PrixPub> getAllPrixPub() {
        return prixPubRepository.findAll();
    }
    
    public Optional<PrixPub> getPrixPubById(Long id) {
        return prixPubRepository.findById(id);
    }
    
    public PrixPub updatePrixPub(Long id, BigDecimal valeur) {
        PrixPub prix = prixPubRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Prix inexistant"));
        prix.setValeur(valeur);
        return prixPubRepository.save(prix);
    }
    
    public void deletePrixPub(Long id) {
        prixPubRepository.deleteById(id);
    }
    
    // Contrats
    public ContratPub createContrat(Long idSociete, Long idPrix, LocalDate dtContrat, Integer quota) {
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        PrixPub prix = prixPubRepository.findById(idPrix)
            .orElseThrow(() -> new IllegalArgumentException("Prix inexistant"));
        
        ContratPub contrat = new ContratPub(dtContrat, quota, societe, prix);
        return contratPubRepository.save(contrat);
    }
    
    public List<ContratPub> getAllContrats() {
        return contratPubRepository.findAll();
    }
    
    public List<ContratPub> getContratsBySociete(Long idSociete) {
        Societe societe = societeRepository.findById(idSociete)
            .orElseThrow(() -> new IllegalArgumentException("Société inexistante"));
        return contratPubRepository.findBySociete(societe);
    }
    
    public Optional<ContratPub> getContratById(Long id) {
        return contratPubRepository.findById(id);
    }
    
    public ContratPub updateContrat(Long id, Long idPrix, LocalDate dtContrat, Integer quota) {
        ContratPub contrat = contratPubRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Contrat inexistant"));
        
        if (idPrix != null) {
            PrixPub prix = prixPubRepository.findById(idPrix)
                .orElseThrow(() -> new IllegalArgumentException("Prix inexistant"));
            contrat.setPrix(prix);
        }
        if (dtContrat != null) contrat.setDtContrat(dtContrat);
        if (quota != null) contrat.setQuota(quota);
        
        return contratPubRepository.save(contrat);
    }
    
    public void deleteContrat(Long id) {
        contratPubRepository.deleteById(id);
    }

    // ============ AUTRES ============

    /**
     * Calcule le CA des ventes pour un mois donné (TOUS les achats, payés ou non)
     * Utilise la date de séance pour le filtre
     */
    public BigDecimal calculerCAVentes(int annee, int mois) {
        YearMonth yearMonth = YearMonth.of(annee, mois);
        LocalDate debut = yearMonth.atDay(1);
        LocalDate fin = yearMonth.atEndOfMonth();
        
        List<Achat> achats = achatRepository.findBySeanceDateSeanceBetween(debut, fin);
        
        BigDecimal total = BigDecimal.ZERO;
        for (Achat achat : achats) {
            if (achat.getMontantTotal() != null) {
                total = total.add(achat.getMontantTotal());
            }
        }
        
        return total;
    }

    public List<Achat> getAchatsMonth(int mois, int annee) {
        YearMonth yearMonth = YearMonth.of(annee, mois);
        LocalDate debut = yearMonth.atDay(1);
        LocalDate fin = yearMonth.atEndOfMonth();

        // Retourner les achats filtrés par date de séance (cohérent avec calculerCAVentes)
        return achatRepository.findBySeanceDateSeanceBetween(debut, fin);
    }

    /**
     * Récupère toutes les séances d'un mois donné
     */
    public List<Seance> getSeancesDuMois(int annee, int mois) {
        YearMonth yearMonth = YearMonth.of(annee, mois);
        LocalDate debut = yearMonth.atDay(1);
        LocalDate fin = yearMonth.atEndOfMonth();
        
        return seanceRepository.findByDateSeanceBetween(debut, fin);
    }
    
    /**
     * Récupère toutes les séances
     */
    public List<Seance> getAllSeances() {
        return seanceRepository.findAll();
    }

    public List<Achat> getAchatsSeance(Long idSeance) {
        return achatRepository.findBySeanceIdSeance(idSeance);
    }

    /**
     * Calcule le chiffre d'affaires de publicité généré par une séance spécifique
     * @param idSeance L'identifiant de la séance
     * @return Le CA publicité (nombre de diffusions × prix unitaire)
     */
    public BigDecimal calculerCAParSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
            .orElseThrow(() -> new IllegalArgumentException("Séance inexistante"));
        
        List<Diffusion> diffusions = diffusionRepository.findBySeance(seance);
        
        BigDecimal total = BigDecimal.ZERO;
        for (Diffusion diffusion : diffusions) {
            // Récupérer le prix unitaire du contrat de la société
            List<ContratPub> contrats = contratPubRepository.findBySocieteAndMonth(
                diffusion.getSociete(), 
                seance.getDateSeance()
            );
            
            ContratPub contrat = getPremierContrat(contrats);
            if (contrat != null) {
                BigDecimal prixUnitaire = contrat.getPrix().getValeur();
                BigDecimal caDiffusion = prixUnitaire.multiply(new BigDecimal(diffusion.getNombreDiffusions()));
                total = total.add(caDiffusion);
            }
        }
        
        return total;
    }
}
