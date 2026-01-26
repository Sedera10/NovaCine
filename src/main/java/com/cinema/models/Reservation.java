package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
public class Reservation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reservation")
    private Long idReservation;
    
    @Column(name = "dt_reservation", nullable = false)
    private LocalDateTime dtReservation;
    
    @Column(name = "nom_client", length = 100)
    private String nomClient;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;

    // Constructeurs
    public Reservation() {
        this.dtReservation = LocalDateTime.now();
    }

    public Reservation(String nomClient, Seance seance) {
        this.nomClient = nomClient;
        this.seance = seance;
        this.dtReservation = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(Long idReservation) {
        this.idReservation = idReservation;
    }

    public LocalDateTime getDtReservation() {
        return dtReservation;
    }

    public void setDtReservation(LocalDateTime dtReservation) {
        this.dtReservation = dtReservation;
    }

    public String getNomClient() {
        return nomClient;
    }

    public void setNomClient(String nomClient) {
        this.nomClient = nomClient;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }
}
