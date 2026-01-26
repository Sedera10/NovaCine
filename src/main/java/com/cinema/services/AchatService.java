package com.cinema.services;

import com.cinema.models.*;
import com.cinema.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class AchatService {

    @Autowired
    private AchatRepository achatRepository;
    
    @Autowired
    private AchatLigneRepository achatLigneRepository;
    
    @Autowired
    private SeanceRepository seanceRepository;
    
    @Autowired
    private TarifRepository tarifRepository;
    
    @Autowired
    private TypePlaceRepository typePlaceRepository;
    
    @Autowired
    private TypePersonneRepository typePersonneRepository;

    // =========================================================================
    // RÉCUPÉRATION DES TARIFS
    // =========================================================================
    
    /**
     * Récupère le tarif pour une combinaison séance/typePlace/typeClient
     * @return Le tarif trouvé ou null
     */
    public Tarif getTarif(Long idSeance, Long idTypePlace, Long idTypeClient) {
        return tarifRepository.findBySeanceAndTypePlaceAndTypeClient(idSeance, idTypePlace, idTypeClient)
                .orElse(null);
    }
    
    /**
     * Récupère la valeur du tarif (juste le prix)
     * @return Le prix ou BigDecimal.ZERO si non trouvé
     */
    public BigDecimal getTarifValeur(Long idSeance, Long idTypePlace, Long idTypeClient) {
        return tarifRepository.findValeurBySeanceAndTypePlaceAndTypeClient(idSeance, idTypePlace, idTypeClient)
                .orElse(BigDecimal.ZERO);
    }
    
    /**
     * Récupère tous les tarifs d'une séance
     */
    public List<Tarif> getTarifsBySeance(Long idSeance) {
        return tarifRepository.findBySeanceIdSeance(idSeance);
    }

    // =========================================================================
    // GESTION DES ACHATS
    // =========================================================================
    
    /**
     * Récupère tous les achats
     */
    public List<Achat> getAllAchats() {
        return achatRepository.findAll();
    }
    
    /**
     * Récupère un achat par son ID
     */
    public Achat getAchatById(Long id) {
        return achatRepository.findById(id).orElse(null);
    }
    
    /**
     * Récupère les séances disponibles (à venir ou en cours)
     */
    public List<Seance> getSeancesDisponibles() {
        LocalDate today = LocalDate.now();
        return seanceRepository.findAll().stream()
                .filter(s -> !s.getDateSeance().isBefore(today))
                .sorted((a, b) -> {
                    int dateCompare = a.getDateSeance().compareTo(b.getDateSeance());
                    if (dateCompare != 0) return dateCompare;
                    return a.getHeureSeance().compareTo(b.getHeureSeance());
                })
                .toList();
    }
    
    /**
     * Crée un achat avec ses lignes (sans stocker les prix - calcul dynamique)
     * 
     * @param idSeance ID de la séance
     * @param nomClient Nom du client
     * @param lignesData Liste des lignes AchatLigne (avec typePlace, typeClient et quantite déjà définis)
     * @return L'achat créé
     */
    @Transactional
    public Achat creerAchat(Long idSeance, String nomClient, List<AchatLigne> lignesData) {
        // Récupérer la séance
        Seance seance = seanceRepository.findById(idSeance)
                .orElseThrow(() -> new IllegalArgumentException("Séance introuvable (id=" + idSeance + ")"));
        
        // Créer l'achat (statut EN_COURS par défaut, montant null)
        Achat achat = new Achat();
        achat.setSeance(seance);
        achat.setNomClient(nomClient);
        achat.setStatut("EN_COURS");
        // montantTotal reste null - sera calculé dynamiquement
        achat = achatRepository.save(achat);
        
        System.out.println("=== Achat créé: id=" + achat.getIdAchat() + " ===");
        System.out.println("Client: " + nomClient);
        System.out.println("Séance: " + seance.getFilm().getTitre() + " - " + seance.getDateSeance());
        
        // Créer les lignes d'achat (sans prix - sera calculé dynamiquement)
        for (AchatLigne ligneData : lignesData) {
            if (ligneData.getQuantite() == null || ligneData.getQuantite() <= 0) continue;
            
            TypePlace typePlace = ligneData.getTypePlace();
            TypePersonne typeClient = ligneData.getTypeClient();
            
            // Vérifier que le tarif existe
            BigDecimal prixActuel = getTarifValeur(idSeance, typePlace.getId(), typeClient.getIdTypeClient());
            if (prixActuel.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Pas de tarif configuré pour " + typePlace.getNom() + " / " + typeClient.getNom());
            }
            
            // Créer la ligne sans prix (prix_unitaire = null)
            AchatLigne ligne = new AchatLigne();
            ligne.setAchat(achat);
            ligne.setTypePlace(typePlace);
            ligne.setTypeClient(typeClient);
            ligne.setQuantite(ligneData.getQuantite());
            // prixUnitaire reste null - sera calculé dynamiquement
            
            achat.addLigne(ligne);
            achatLigneRepository.save(ligne);
            
            System.out.println("  Ligne: " + typePlace.getNom() + " / " + typeClient.getNom() + 
                              " x" + ligneData.getQuantite());
        }
        
        System.out.println("Achat créé avec statut EN_COURS (prix calculés dynamiquement)");
        
        return achat;
    }
    
    // =========================================================================
    // CALCUL DYNAMIQUE DES PRIX
    // =========================================================================
    
    /**
     * Calcule le prix unitaire actuel d'une ligne d'achat
     * basé sur les tarifs actuels de la séance
     */
    public BigDecimal calculerPrixUnitaireLigne(AchatLigne ligne) {
        if (ligne.getAchat() == null || ligne.getTypePlace() == null || ligne.getTypeClient() == null) {
            return BigDecimal.ZERO;
        }
        
        Long idSeance = ligne.getAchat().getSeance().getIdSeance();
        Long idTypePlace = ligne.getTypePlace().getId();
        Long idTypeClient = ligne.getTypeClient().getIdTypeClient();
        
        return getTarifValeur(idSeance, idTypePlace, idTypeClient);
    }
    
    /**
     * Calcule le sous-total d'une ligne d'achat
     * (prix unitaire actuel × quantité)
     */
    public BigDecimal calculerSousTotalLigne(AchatLigne ligne) {
        BigDecimal prixUnitaire = calculerPrixUnitaireLigne(ligne);
        int quantite = ligne.getQuantite() != null ? ligne.getQuantite() : 0;
        return prixUnitaire.multiply(new BigDecimal(quantite));
    }
    
    /**
     * Calcule le total dynamique d'un achat
     * basé sur les tarifs actuels de la séance
     */
    public BigDecimal calculerTotalAchat(Achat achat) {
        if (achat == null || achat.getLignes() == null) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal total = BigDecimal.ZERO;
        for (AchatLigne ligne : achat.getLignes()) {
            total = total.add(calculerSousTotalLigne(ligne));
        }
        return total;
    }
    
    /**
     * Calcule le nombre total de billets d'un achat
     */
    public int calculerNbBillets(Achat achat) {
        if (achat == null || achat.getLignes() == null) {
            return 0;
        }
        
        return achat.getLignes().stream()
                .mapToInt(l -> l.getQuantite() != null ? l.getQuantite() : 0)
                .sum();
    }
    
    /**
     * Retourne les détails de calcul pour chaque ligne d'un achat
     * Map<idLigne, {prixUnitaire, sousTotal}>
     */
    public Map<Long, Map<String, BigDecimal>> getDetailsCalculAchat(Achat achat) {
        Map<Long, Map<String, BigDecimal>> details = new HashMap<>();
        
        if (achat == null || achat.getLignes() == null) {
            return details;
        }
        
        for (AchatLigne ligne : achat.getLignes()) {
            Map<String, BigDecimal> ligneDetail = new HashMap<>();
            ligneDetail.put("prixUnitaire", calculerPrixUnitaireLigne(ligne));
            ligneDetail.put("sousTotal", calculerSousTotalLigne(ligne));
            details.put(ligne.getIdAchatLigne(), ligneDetail);
        }
        
        return details;
    }
    
    /**
     * Récupère un TypePlace par son ID
     */
    public TypePlace getTypePlaceById(Long id) {
        return typePlaceRepository.findById(id).orElse(null);
    }
    
    /**
     * Récupère un TypePersonne par son ID
     */
    public TypePersonne getTypeClientById(Long id) {
        return typePersonneRepository.findById(id).orElse(null);
    }
    
    // =========================================================================
    // GESTION DES PLACES VENDUES (pour affichage plan de salle)
    // =========================================================================
    
    /**
     * Compte le nombre de billets vendus par type de place pour une séance
     * @return Map<idTypePlace, nombreVendus>
     */
    public Map<Long, Integer> getBilletsVendusParTypePlace(Long idSeance) {
        Map<Long, Integer> result = new HashMap<>();
        List<Object[]> data = achatLigneRepository.countBilletsVendusParTypePlaceBySeance(idSeance);
        
        for (Object[] row : data) {
            Long idTypePlace = (Long) row[0];
            Long count = (Long) row[1];
            result.put(idTypePlace, count.intValue());
        }
        
        return result;
    }
    
    /**
     * Vérifie si une séance a assez de places disponibles pour un type de place
     */
    public boolean hasPlacesDisponibles(Long idSeance, Long idTypePlace, int capaciteTypePlace, int quantiteDemandee) {
        Map<Long, Integer> vendus = getBilletsVendusParTypePlace(idSeance);
        int dejaVendus = vendus.getOrDefault(idTypePlace, 0);
        return (capaciteTypePlace - dejaVendus) >= quantiteDemandee;
    }

    
}
