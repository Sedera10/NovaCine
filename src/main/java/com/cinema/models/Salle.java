package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "salles")
public class Salle {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_salle")
    private Long idSalle;
    
    @Column(name = "nom", length = 30)
    private String nom;
    
    @Column(name = "capacite", nullable = false)
    private Integer capacite;
    
    @Column(name = "dt_creation", nullable = false)
    private LocalDateTime dtCreation;
    
    @OneToMany(mappedBy = "salle")
    private List<Seance> seances;

    // Constructeurs
    public Salle() {
        this.dtCreation = LocalDateTime.now();
    }

    public Salle(String nom, Integer capacite) {
        this.nom = nom;
        this.capacite = capacite;
        this.dtCreation = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getIdSalle() {
        return idSalle;
    }

    public void setIdSalle(Long idSalle) {
        this.idSalle = idSalle;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public Integer getCapacite() {
        return capacite;
    }
    
    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }
    
    public LocalDateTime getDtCreation() {
        return dtCreation;
    }
    
    public void setDtCreation(LocalDateTime dtCreation) {
        this.dtCreation = dtCreation;
    }
    
    public List<Seance> getSeances() {
        return seances;
    }
    
    public void setSeances(List<Seance> seances) {
        this.seances = seances;
    }
}
