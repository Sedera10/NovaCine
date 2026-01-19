package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "billets",
       uniqueConstraints = @UniqueConstraint(columnNames = {"id_place", "id_seance"}))
public class Billet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_billet")
    private Long idBillet;
    
    @ManyToOne
    @JoinColumn(name = "id_place", nullable = false)
    private Place place;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;
    
    @Column(name = "prix", nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;
    
    @Column(name = "dt_creation", nullable = false)
    private LocalDateTime dtCreation;
    
    @ManyToMany(mappedBy = "billets")
    private List<Achat> achats;

    // Constructeurs
    public Billet() {
        this.dtCreation = LocalDateTime.now();
    }

    public Billet(Place place, Seance seance, BigDecimal prix) {
        this.place = place;
        this.seance = seance;
        this.prix = prix;
        this.dtCreation = LocalDateTime.now();
    }

    // Méthode utilitaire pour obtenir le type de place via la place
    public TypePlace getTypePlace() {
        return place != null ? place.getTypePlace() : null;
    }

    // Getters et Setters
    public Long getIdBillet() {
        return idBillet;
    }

    public void setIdBillet(Long idBillet) {
        this.idBillet = idBillet;
    }

    public Place getPlace() {
        return place;
    }

    public void setPlace(Place place) {
        this.place = place;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public BigDecimal getPrix() {
        return prix;
    }

    public void setPrix(BigDecimal prix) {
        this.prix = prix;
    }

    public LocalDateTime getDtCreation() {
        return dtCreation;
    }

    public void setDtCreation(LocalDateTime dtCreation) {
        this.dtCreation = dtCreation;
    }

    public List<Achat> getAchats() {
        return achats;
    }

    public void setAchats(List<Achat> achats) {
        this.achats = achats;
    }
}
