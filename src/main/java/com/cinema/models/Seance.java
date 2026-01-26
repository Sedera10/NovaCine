package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "seances")
public class Seance {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_seance")
    private Long idSeance;
    
    @Column(name = "date_seance", nullable = false)
    private LocalDate dateSeance;
    
    @Column(name = "heure_seance", nullable = false)
    private LocalTime heureSeance;
    
    @Column(name = "dt_creation", nullable = false)
    private LocalDateTime dtCreation;
    
    @ManyToOne
    @JoinColumn(name = "id_film", nullable = false)
    private Film film;
    
    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;
    
    @OneToMany(mappedBy = "seance", cascade = CascadeType.ALL)
    private List<Reservation> reservations;
    
    @OneToMany(mappedBy = "seance", cascade = CascadeType.ALL)
    private List<Achat> achats;
    
    @OneToMany(mappedBy = "seance", cascade = CascadeType.ALL)
    private List<Tarif> tarifs;
    
    @OneToMany(mappedBy = "seance", cascade = CascadeType.ALL)
    private List<Diffusion> diffusionsPub;

    // Constructeurs
    public Seance() {
        this.dtCreation = LocalDateTime.now();
    }

    public Seance(LocalDate dateSeance, LocalTime heureSeance, Film film, Salle salle) {
        this.dateSeance = dateSeance;
        this.heureSeance = heureSeance;
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
    
    public LocalDate getDateSeance() {
        return dateSeance;
    }
    
    public void setDateSeance(LocalDate dateSeance) {
        this.dateSeance = dateSeance;
    }
    
    public LocalTime getHeureSeance() {
        return heureSeance;
    }
    
    public void setHeureSeance(LocalTime heureSeance) {
        this.heureSeance = heureSeance;
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
    
    public List<Reservation> getReservations() {
        return reservations;
    }
    
    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }
    
    public List<Achat> getAchats() {
        return achats;
    }
    
    public void setAchats(List<Achat> achats) {
        this.achats = achats;
    }
    
    public List<Tarif> getTarifs() {
        return tarifs;
    }
    
    public void setTarifs(List<Tarif> tarifs) {
        this.tarifs = tarifs;
    }
    
    public List<Diffusion> getDiffusionsPub() {
        return diffusionsPub;
    }
    
    public void setDiffusionsPub(List<Diffusion> diffusionsPub) {
        this.diffusionsPub = diffusionsPub;
    }
}

