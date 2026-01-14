package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "seances",
       uniqueConstraints = @UniqueConstraint(columnNames = {"daty", "heure", "id_salle"}))
public class Seance {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_seance")
    private Long idSeance;
    
    @Column(name = "daty", nullable = false)
    private LocalDate daty;
    
    @Column(name = "heure", nullable = false)
    private LocalTime heure;
    
    @Column(name = "dt_creation", nullable = false)
    private LocalDateTime dtCreation;
    
    @ManyToOne
    @JoinColumn(name = "id_film", nullable = false)
    private Film film;
    
    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;
    
    @OneToMany(mappedBy = "seance", cascade = CascadeType.ALL)
    private List<Billet> billets;

    // Constructeurs
    public Seance() {
        this.dtCreation = LocalDateTime.now();
    }

    public Seance(LocalDate daty, LocalTime heure, Film film, Salle salle) {
        this.daty = daty;
        this.heure = heure;
        this.film = film;
        this.salle = salle;
        this.dtCreation = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getIdSeance() {
        return idSeance;
    }
    
    public void setIdSeance(Long idSeance) {
        this.idSeance = idSeance;
    }
    
    public LocalDate getDaty() {
        return daty;
    }
    
    public void setDaty(LocalDate daty) {
        this.daty = daty;
    }
    
    public LocalTime getHeure() {
        return heure;
    }
    
    public void setHeure(LocalTime heure) {
        this.heure = heure;
    }
    
    public LocalDateTime getDtCreation() {
        return dtCreation;
    }
    
    public void setDtCreation(LocalDateTime dtCreation) {
        this.dtCreation = dtCreation;
    }
    
    public Film getFilm() {
        return film;
    }
    
    public void setFilm(Film film) {
        this.film = film;
    }
    
    public Salle getSalle() {
        return salle;
    }
    
    public void setSalle(Salle salle) {
        this.salle = salle;
    }
    
    public List<Billet> getBillets() {
        return billets;
    }
    
    public void setBillets(List<Billet> billets) {
        this.billets = billets;
    }
}

