package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tarifs")
public class Tarif {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tarif")
    private Long idTarif;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;
    
    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;
    
    @ManyToOne
    @JoinColumn(name = "id_type_client", nullable = false)
    private TypePersonne typeClient;
    
    @Column(name = "valeur", nullable = false, precision = 15, scale = 2)
    private BigDecimal valeur;
    
    @ManyToOne
    @JoinColumn(name = "id_type_client_ref")
    private TypePersonne typeClientRef;

    // Constructeurs
    public Tarif() {
    }

    public Tarif(Seance seance, TypePlace typePlace, TypePersonne typeClient, BigDecimal valeur) {
        this.seance = seance;
        this.typePlace = typePlace;
        this.typeClient = typeClient;
        this.valeur = valeur;
    }

    public Tarif(Seance seance, TypePlace typePlace, TypePersonne typeClient, BigDecimal valeur, TypePersonne typeClientRef) {
        this.seance = seance;
        this.typePlace = typePlace;
        this.typeClient = typeClient;
        this.valeur = valeur;
        this.typeClientRef = typeClientRef;
    }

    // Getters et Setters
    public Long getIdTarif() {
        return idTarif;
    }

    public void setIdTarif(Long idTarif) {
        this.idTarif = idTarif;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public TypePersonne getTypeClient() {
        return typeClient;
    }

    public void setTypeClient(TypePersonne typeClient) {
        this.typeClient = typeClient;
    }

    public BigDecimal getValeur() {
        return valeur;
    }

    public void setValeur(BigDecimal valeur) {
        this.valeur = valeur;
    }

    public TypePersonne getTypeClientRef() {
        return typeClientRef;
    }

    public void setTypeClientRef(TypePersonne typeClientRef) {
        this.typeClientRef = typeClientRef;
    }
}
