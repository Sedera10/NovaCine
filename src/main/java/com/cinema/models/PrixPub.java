package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "prix_pubs")
public class PrixPub {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prix")
    private Long idPrix;
    
    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal valeur;

    // Constructeurs
    public PrixPub() {}

    public PrixPub(BigDecimal valeur) {
        this.valeur = valeur;
    }

    // Getters et Setters
    public Long getIdPrix() {
        return idPrix;
    }

    public void setIdPrix(Long idPrix) {
        this.idPrix = idPrix;
    }

    public BigDecimal getValeur() {
        return valeur;
    }

    public void setValeur(BigDecimal valeur) {
        this.valeur = valeur;
    }
}
