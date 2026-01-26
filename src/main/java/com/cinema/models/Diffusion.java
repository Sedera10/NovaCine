package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "diffusions")
public class Diffusion {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_diffusion")
    private Long idDiffusion;
    
    @Column(name = "dt_diffusion", nullable = false)
    private LocalDateTime dtDiffusion;
    
    @Column(name = "nombre_diffusions", nullable = false)
    private Integer nombreDiffusions;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;
    
    @ManyToOne
    @JoinColumn(name = "id_societe", nullable = false)
    private Societe societe;

    // Constructeurs
    public Diffusion() {}

    public Diffusion(LocalDateTime dtDiffusion, Integer nombreDiffusions, Seance seance, Societe societe) {
        this.dtDiffusion = dtDiffusion;
        this.nombreDiffusions = nombreDiffusions;
        this.seance = seance;
        this.societe = societe;
    }

    // Getters et Setters
    public Long getIdDiffusion() {
        return idDiffusion;
    }

    public void setIdDiffusion(Long idDiffusion) {
        this.idDiffusion = idDiffusion;
    }

    public LocalDateTime getDtDiffusion() {
        return dtDiffusion;
    }

    public void setDtDiffusion(LocalDateTime dtDiffusion) {
        this.dtDiffusion = dtDiffusion;
    }

    public Integer getNombreDiffusions() {
        return nombreDiffusions;
    }

    public void setNombreDiffusions(Integer nombreDiffusions) {
        this.nombreDiffusions = nombreDiffusions;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }
}
