package com.cinema.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class SeanceDTO {
    
    private String idSeance;
    private String idFilm;
    private String idSalle;
    private LocalDate dtSeance;
    private LocalTime heureDebut;
    private BigDecimal prixBase;
    private String statut;
    
    // Constructors
    public SeanceDTO() {}
    
    // Getters and Setters
    public String getIdSeance() {
        return idSeance;
    }
    
    public void setIdSeance(String idSeance) {
        this.idSeance = idSeance;
    }
    
    public String getIdFilm() {
        return idFilm;
    }
    
    public void setIdFilm(String idFilm) {
        this.idFilm = idFilm;
    }
    
    public String getIdSalle() {
        return idSalle;
    }
    
    public void setIdSalle(String idSalle) {
        this.idSalle = idSalle;
    }
    
    public LocalDate getDtSeance() {
        return dtSeance;
    }
    
    public void setDtSeance(LocalDate dtSeance) {
        this.dtSeance = dtSeance;
    }
    
    public LocalTime getHeureDebut() {
        return heureDebut;
    }
    
    public void setHeureDebut(LocalTime heureDebut) {
        this.heureDebut = heureDebut;
    }
    
    public BigDecimal getPrixBase() {
        return prixBase;
    }
    
    public void setPrixBase(BigDecimal prixBase) {
        this.prixBase = prixBase;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
}
