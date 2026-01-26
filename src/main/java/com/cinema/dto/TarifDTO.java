package com.cinema.dto;

import java.math.BigDecimal;

/**
 * DTO pour transférer les informations de tarif depuis le formulaire.
 * 
 * Représente un tarif pour une combinaison:
 * - Type de place (Standard, Premium, etc.)
 * - Type de client (Adulte, Enfant, Étudiant, etc.)
 * 
 * Un tarif peut être:
 * - Fixe: valeur définie directement
 * - Dépendant: calculé à partir d'un autre type de client (référence) avec un pourcentage
 */
public class TarifDTO {
    
    private Long idTypePlace;
    private Long idTypeClient;
    private BigDecimal valeur;
    
    // Pour les tarifs dépendants
    private Long idTypeClientRef;  // ID du type client de référence (ex: Adulte)
    
    // Constructeurs
    public TarifDTO() {
    }
    
    public TarifDTO(Long idTypePlace, Long idTypeClient, BigDecimal valeur) {
        this.idTypePlace = idTypePlace;
        this.idTypeClient = idTypeClient;
        this.valeur = valeur;
    }
    
    public TarifDTO(Long idTypePlace, Long idTypeClient, BigDecimal valeur, Long idTypeClientRef) {
        this.idTypePlace = idTypePlace;
        this.idTypeClient = idTypeClient;
        this.valeur = valeur;
        this.idTypeClientRef = idTypeClientRef;
    }

    // Getters et Setters
    public Long getIdTypePlace() {
        return idTypePlace;
    }

    public void setIdTypePlace(Long idTypePlace) {
        this.idTypePlace = idTypePlace;
    }

    public Long getIdTypeClient() {
        return idTypeClient;
    }

    public void setIdTypeClient(Long idTypeClient) {
        this.idTypeClient = idTypeClient;
    }

    public BigDecimal getValeur() {
        return valeur;
    }

    public void setValeur(BigDecimal valeur) {
        this.valeur = valeur;
    }

    public Long getIdTypeClientRef() {
        return idTypeClientRef;
    }

    public void setIdTypeClientRef(Long idTypeClientRef) {
        this.idTypeClientRef = idTypeClientRef;
    }
    
    /**
     * Vérifie si ce tarif est dépendant d'un autre type de client
     */
    public boolean isDependant() {
        return idTypeClientRef != null;
    }

    @Override
    public String toString() {
        return "TarifDTO{" +
                "idTypePlace=" + idTypePlace +
                ", idTypeClient=" + idTypeClient +
                ", valeur=" + valeur +
                ", idTypeClientRef=" + idTypeClientRef +
                '}';
    }
}
