package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "achat_lignes")
public class AchatLigne {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_achat_ligne")
    private Long idAchatLigne;
    
    @ManyToOne
    @JoinColumn(name = "id_achat", nullable = false)
    private Achat achat;
    
    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;
    
    @ManyToOne
    @JoinColumn(name = "id_type_client", nullable = false)
    private TypePersonne typeClient;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "prix_unitaire", nullable = true, precision = 15, scale = 2)
    private BigDecimal prixUnitaire;

    // Constructeurs
    public AchatLigne() {
    }

    public AchatLigne(Achat achat, TypePlace typePlace, TypePersonne typeClient, Integer quantite, BigDecimal prixUnitaire) {
        this.achat = achat;
        this.typePlace = typePlace;
        this.typeClient = typeClient;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
    }

    // Méthode utile
    public BigDecimal getSousTotal() {
        return prixUnitaire.multiply(new BigDecimal(quantite));
    }

    // Getters et Setters
    public Long getIdAchatLigne() {
        return idAchatLigne;
    }

    public void setIdAchatLigne(Long idAchatLigne) {
        this.idAchatLigne = idAchatLigne;
    }

    public Achat getAchat() {
        return achat;
    }

    public void setAchat(Achat achat) {
        this.achat = achat;
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

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
}
