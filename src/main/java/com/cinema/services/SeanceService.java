package com.cinema.services;

import com.cinema.dto.TarifDTO;
import com.cinema.models.Achat;
import com.cinema.models.ConfigSalles;
import com.cinema.models.Film;
import com.cinema.models.Seance;
import com.cinema.models.Salle;
import com.cinema.models.Tarif;
import com.cinema.models.TypePlace;
import com.cinema.models.TypePersonne;
import com.cinema.repositories.AchatRepository;
import com.cinema.repositories.ConfigSallesRepository;
import com.cinema.repositories.FilmRepository;
import com.cinema.repositories.SeanceRepository;
import com.cinema.repositories.SalleRepository;
import com.cinema.repositories.TarifRepository;
import com.cinema.repositories.TypePlaceRepository;
import com.cinema.repositories.TypePersonneRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SeanceService {

    @Autowired
    private SeanceRepository seanceRepository;

    @Autowired
    private FilmRepository filmRepository;

    @Autowired
    private SalleRepository salleRepository;

    @Autowired
    private TarifRepository tarifRepository;

    @Autowired
    private TypePlaceRepository typePlaceRepository;

    @Autowired
    private TypePersonneRepository typePersonneRepository;

    @Autowired
    private ConfigSallesRepository configSallesRepository;

    @Autowired
    private AchatRepository achatRepository;

    public List<TypePersonne> getAllTypeClients() {
        return typePersonneRepository.findAll();
    }

    public List<Seance> getAllSeances() {
        return seanceRepository.findAll();
    }

    public Seance getSeanceById(Long id) {
        return seanceRepository.findById(id).orElse(null);
    }
    
    /**
     * Récupère les séances avec filtres
     */
    public List<Seance> getSeancesByFilters(Long filmId, Long salleId, LocalDate dateDebut, LocalDate dateFin) {
        List<Seance> seances = seanceRepository.findAll();
        
        return seances.stream()
            .filter(s -> filmId == null || s.getFilm().getIdFilm().equals(filmId))
            .filter(s -> salleId == null || s.getSalle().getIdSalle().equals(salleId))
            .filter(s -> {
                if (dateDebut == null || dateFin == null) return true;
                LocalDate dateSeance = s.getDateSeance();
                return !dateSeance.isBefore(dateDebut) && !dateSeance.isAfter(dateFin);
            })
            .sorted((s1, s2) -> {
                int dateCompare = s1.getDateSeance().compareTo(s2.getDateSeance());
                if (dateCompare != 0) return dateCompare;
                return s1.getHeureSeance().compareTo(s2.getHeureSeance());
            })
            .toList();
    }
    
    /**
     * Récupère tous les tarifs d'une séance
     */
    public List<Tarif> getTarifsBySeance(Long idSeance) {
        return tarifRepository.findBySeanceIdSeance(idSeance);
    }

    // =========================================================================
    // CRÉATION DE SÉANCE AVEC TARIFS SPÉCIFIQUES (Liste de TarifDTO)
    // =========================================================================
    
    /**
     * Crée une séance avec des tarifs spécifiques par type de place ET type de client.
     * Supporte les tarifs dépendants (référence vers un autre type de client).
     * 
     * @param filmId ID du film
     * @param salleId ID de la salle
     * @param date Date de la séance
     * @param time Heure de début
     * @param tarifsDTO Liste des tarifs à créer
     * @return La séance créée
     */
    @Transactional
    public Seance createSeanceWithTarifs(Long filmId, Long salleId, LocalDate date, LocalTime time, 
                                          List<TarifDTO> tarifsDTO) {
        // Récupérer le film et la salle
        Film film = filmRepository.findById(filmId)
                .orElseThrow(() -> new IllegalArgumentException("Film introuvable (id=" + filmId + ")"));
        Salle salle = salleRepository.findById(salleId)
                .orElseThrow(() -> new IllegalArgumentException("Salle introuvable (id=" + salleId + ")"));

        // Vérifier les conflits de planning
        Seance conflict = checkConflict(salleId, date, time);
        if (conflict != null) {
            throw new IllegalArgumentException("Conflit de planning avec la séance id=" + conflict.getIdSeance());
        }

        // Créer et sauvegarder la séance
        Seance seance = new Seance(date, time, film, salle);
        seance = seanceRepository.save(seance);
        
        System.out.println("=== Séance créée: id=" + seance.getIdSeance() + " ===");
        System.out.println("Nombre de tarifs à créer: " + tarifsDTO.size());

        // Créer les tarifs
        for (TarifDTO dto : tarifsDTO) {
            createTarifFromDTO(seance, dto);
        }

        return seance;
    }
    
    /**
     * Crée un tarif à partir d'un DTO
     */
    private void createTarifFromDTO(Seance seance, TarifDTO dto) {
        TypePlace typePlace = typePlaceRepository.findById(dto.getIdTypePlace())
                .orElseThrow(() -> new IllegalArgumentException("Type de place introuvable (id=" + dto.getIdTypePlace() + ")"));
        
        TypePersonne typeClient = typePersonneRepository.findById(dto.getIdTypeClient())
                .orElseThrow(() -> new IllegalArgumentException("Type de client introuvable (id=" + dto.getIdTypeClient() + ")"));
        
        // Récupérer le type client de référence si dépendant
        TypePersonne typeClientRef = null;
        if (dto.getIdTypeClientRef() != null) {
            typeClientRef = typePersonneRepository.findById(dto.getIdTypeClientRef()).orElse(null);
        }
        
        Tarif tarif = new Tarif(seance, typePlace, typeClient, dto.getValeur(), typeClientRef);
        tarifRepository.save(tarif);
        
        System.out.println("  Tarif créé: " + typePlace.getNom() + " / " + typeClient.getNom() + 
                          " = " + dto.getValeur() + " Ar" + 
                          (typeClientRef != null ? " (ref: " + typeClientRef.getNom() + ")" : ""));
    }

    // =========================================================================
    // CRÉATION DE SÉANCE AVEC PRIX DE BASE (même prix pour tous les clients)
    // =========================================================================
    
    /**
     * Crée une séance avec un prix de base par type de place.
     * Le même prix est appliqué à tous les types de clients.
     * 
     * @param filmId ID du film
     * @param salleId ID de la salle  
     * @param date Date de la séance
     * @param time Heure de début
     * @param prixParTypePlace Map: idTypePlace -> prix de base
     * @return La séance créée
     */
    @Transactional
    public Seance createSeanceWithBasePrices(Long filmId, Long salleId, LocalDate date, LocalTime time, 
                                              Map<Long, BigDecimal> prixParTypePlace) {
        // Récupérer le film et la salle
        Film film = filmRepository.findById(filmId)
                .orElseThrow(() -> new IllegalArgumentException("Film introuvable (id=" + filmId + ")"));
        Salle salle = salleRepository.findById(salleId)
                .orElseThrow(() -> new IllegalArgumentException("Salle introuvable (id=" + salleId + ")"));

        // Vérifier les conflits de planning
        Seance conflict = checkConflict(salleId, date, time);
        if (conflict != null) {
            throw new IllegalArgumentException("Conflit de planning avec la séance id=" + conflict.getIdSeance());
        }

        // Créer et sauvegarder la séance
        Seance seance = new Seance(date, time, film, salle);
        seance = seanceRepository.save(seance);
        
        System.out.println("=== Séance créée (mode base): id=" + seance.getIdSeance() + " ===");
        
        // Récupérer tous les types de clients
        List<TypePersonne> typeClients = typePersonneRepository.findAll();
        
        // Pour chaque type de place avec un prix défini
        for (Map.Entry<Long, BigDecimal> entry : prixParTypePlace.entrySet()) {
            Long idTypePlace = entry.getKey();
            BigDecimal prixBase = entry.getValue();
            
            TypePlace typePlace = typePlaceRepository.findById(idTypePlace)
                    .orElseThrow(() -> new IllegalArgumentException("Type de place introuvable (id=" + idTypePlace + ")"));
            
            // Créer un tarif pour chaque type de client avec le même prix
            for (TypePersonne typeClient : typeClients) {
                Tarif tarif = new Tarif(seance, typePlace, typeClient, prixBase);
                tarifRepository.save(tarif);
                
                System.out.println("  Tarif créé: " + typePlace.getNom() + " / " + typeClient.getNom() + 
                                  " = " + prixBase + " Ar");
            }
        }

        return seance;
    }

    // =========================================================================
    // VÉRIFICATION DES CONFLITS DE PLANNING
    // =========================================================================
    
    /**
     * @return La séance en conflit, ou null si pas de conflit
     */
    public Seance checkConflict(Long salleId, LocalDate date, LocalTime time) {
        List<Seance> seances = seanceRepository.findAll();
        
        for (Seance s : seances) {
            // Ignorer si ce n'est pas la même salle ou la même date
            if (!s.getSalle().getIdSalle().equals(salleId)) continue;
            if (!s.getDateSeance().equals(date)) continue;

            // Calculer l'intervalle de la séance existante
            int dureeExistante = s.getFilm().getDuree();
            int debutExistant = s.getHeureSeance().getHour() * 60 + s.getHeureSeance().getMinute();
            int finExistante = debutExistant + dureeExistante + 15; // +15 min de nettoyage

            int nouveauDebut = time.getHour() * 60 + time.getMinute();

            // Vérifier si la nouvelle heure tombe dans l'intervalle de la séance existante
            if (nouveauDebut >= debutExistant && nouveauDebut < finExistante) {
                return s;
            }
            
            // Vérifier aussi si les débuts sont trop proches (moins de 5 minutes)
            if (Math.abs(nouveauDebut - debutExistant) < 5) {
                return s;
            }
        }
        
        return null;
    }
    
    /**
     * Vérifie les conflits en excluant une séance spécifique (pour les modifications)
     */
    public Seance checkConflictExcluding(Long salleId, LocalDate date, LocalTime time, Long excludeSeanceId) {
        List<Seance> seances = seanceRepository.findAll();
        
        for (Seance s : seances) {
            // Ignorer la séance qu'on modifie
            if (s.getIdSeance().equals(excludeSeanceId)) continue;
            
            // Ignorer si ce n'est pas la même salle ou la même date
            if (!s.getSalle().getIdSalle().equals(salleId)) continue;
            if (!s.getDateSeance().equals(date)) continue;

            int dureeExistante = s.getFilm().getDuree();
            int debutExistant = s.getHeureSeance().getHour() * 60 + s.getHeureSeance().getMinute();
            int finExistante = debutExistant + dureeExistante + 15;

            int nouveauDebut = time.getHour() * 60 + time.getMinute();

            if (nouveauDebut >= debutExistant && nouveauDebut < finExistante) {
                return s;
            }
            
            if (Math.abs(nouveauDebut - debutExistant) < 5) {
                return s;
            }
        }
        
        return null;
    }
    
    // Modification seance avec tarifs spécifiques
    @Transactional
    public Seance updateSeanceWithTarifs(Long seanceId, LocalDate date, LocalTime time, 
                                          List<TarifDTO> tarifsDTO) {
        Seance seance = seanceRepository.findById(seanceId)
                .orElseThrow(() -> new IllegalArgumentException("Séance introuvable (id=" + seanceId + ")"));

        // Vérifier les conflits (en excluant cette séance)
        Seance conflict = checkConflictExcluding(seance.getSalle().getIdSalle(), date, time, seanceId);
        if (conflict != null) {
            throw new IllegalArgumentException("Conflit de planning avec la séance id=" + conflict.getIdSeance());
        }

        // Mettre à jour les infos de base
        seance.setDateSeance(date);
        seance.setHeureSeance(time);
        seance = seanceRepository.save(seance);
        
        System.out.println("=== Séance modifiée: id=" + seance.getIdSeance() + " ===");
        
        // Supprimer les anciens tarifs
        List<Tarif> anciensTarifs = tarifRepository.findBySeanceIdSeance(seanceId);
        tarifRepository.deleteAll(anciensTarifs);
        System.out.println("Anciens tarifs supprimés: " + anciensTarifs.size());

        // Créer les nouveaux tarifs
        System.out.println("Nouveaux tarifs à créer: " + tarifsDTO.size());
        for (TarifDTO dto : tarifsDTO) {
            createTarifFromDTO(seance, dto);
        }

        return seance;
    }
    

    // Modification séance avec des prix de base
    @Transactional
    public Seance updateSeanceWithBasePrices(Long seanceId, LocalDate date, LocalTime time, 
                                              Map<Long, BigDecimal> prixParTypePlace) {
        Seance seance = seanceRepository.findById(seanceId)
                .orElseThrow(() -> new IllegalArgumentException("Séance introuvable (id=" + seanceId + ")"));

        // Vérifier les conflits (en excluant cette séance)
        Seance conflict = checkConflictExcluding(seance.getSalle().getIdSalle(), date, time, seanceId);
        if (conflict != null) {
            throw new IllegalArgumentException("Conflit de planning avec la séance id=" + conflict.getIdSeance());
        }

        // Mettre à jour les infos de base
        seance.setDateSeance(date);
        seance.setHeureSeance(time);
        seance = seanceRepository.save(seance);
        
        System.out.println("=== Séance modifiée (mode base): id=" + seance.getIdSeance() + " ===");
        
        // Supprimer les anciens tarifs
        List<Tarif> anciensTarifs = tarifRepository.findBySeanceIdSeance(seanceId);
        tarifRepository.deleteAll(anciensTarifs);
        System.out.println("Anciens tarifs supprimés: " + anciensTarifs.size());
        
        // Récupérer tous les types de clients
        List<TypePersonne> typeClients = typePersonneRepository.findAll();
        
        // Pour chaque type de place avec un prix défini
        for (Map.Entry<Long, BigDecimal> entry : prixParTypePlace.entrySet()) {
            Long idTypePlace = entry.getKey();
            BigDecimal prixBase = entry.getValue();
            
            TypePlace typePlace = typePlaceRepository.findById(idTypePlace)
                    .orElseThrow(() -> new IllegalArgumentException("Type de place introuvable (id=" + idTypePlace + ")"));
            
            // Créer un tarif pour chaque type de client avec le même prix
            for (TypePersonne typeClient : typeClients) {
                Tarif tarif = new Tarif(seance, typePlace, typeClient, prixBase);
                tarifRepository.save(tarif);
                
                System.out.println("  Tarif créé: " + typePlace.getNom() + " / " + typeClient.getNom() + 
                                  " = " + prixBase + " Ar");
            }
        }

        return seance;
    }

    // Gain potentiel par défaut
    public BigDecimal gainsPotentielDefault(Long idSeance){
        Seance seance = seanceRepository.findById(idSeance).orElse(null);
        Salle salle = seance.getSalle();
        List<ConfigSalles> confs = configSallesRepository.findBySalle(salle);
        TypePersonne adulte = typePersonneRepository.findByNom("Adulte");
        BigDecimal total = null;
        for (ConfigSalles c : confs){
            BigDecimal prixPlace = tarifRepository.findValeurBySeanceAndTypePlaceAndTypeClient(
                idSeance,
                c.getTypePlace().getId(),
                adulte.getIdTypeClient()
            ).orElse(BigDecimal.ZERO);
            BigDecimal nbPlace = new BigDecimal(c.getNombre());
            BigDecimal gainPlace = prixPlace.multiply(nbPlace);
            if (total == null){
                total = gainPlace;
            } else {
                total = total.add(gainPlace);
            }
        }
        return total;
    }

    // Ventes pour une seance 
    public List<Achat> getAchatsBySeance(Long idSeance){
        return achatRepository.findBySeanceIdSeance(idSeance);
    }
}