package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "paiement_pubs")
public class PaiementPub {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paiement")
    private Long idPaiement;
    
    @Column(name = "montant", nullable = false, precision = 15, scale = 2)
    private BigDecimal montant;
    
    @Column(name = "dt_paiement", nullable = false)
    private LocalDate dtPaiement;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "pourcentage", precision = 15, scale = 2)
    private BigDecimal pourcentage;
    
    @ManyToOne
    @JoinColumn(name = "id_societe", nullable = false)
    private Societe societe;
    
    @OneToMany(mappedBy = "paiement", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PaiementDetail> details = new ArrayList<>();

    // Constructeurs
    public PaiementPub() {
    }

    public PaiementPub(BigDecimal montant, LocalDate dtPaiement, Societe societe, String description, BigDecimal pourcentage) {
        this.montant = montant;
        this.dtPaiement = dtPaiement;
        this.societe = societe;
        this.description = description;
        this.pourcentage = pourcentage;
    }

    // Getters et Setters
    public Long getIdPaiement() {
        return idPaiement;
    }

    public void setIdPaiement(Long idPaiement) {
        this.idPaiement = idPaiement;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public LocalDate getDtPaiement() {
        return dtPaiement;
    }

    public void setDtPaiement(LocalDate dtPaiement) {
        this.dtPaiement = dtPaiement;
    }

    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPourcentage() {
        return pourcentage;
    }

    public void setPourcentage(BigDecimal pourcentage) {
        this.pourcentage = pourcentage;
    }

    public List<PaiementDetail> getDetails() {
        return details;
    }

    public void setDetails(List<PaiementDetail> details) {
        this.details = details;
    }
    
    public void addDetail(PaiementDetail detail) {
        details.add(detail);
        detail.setPaiement(this);
    }

    @Override
    public String toString() {
        return "PaiementPub{" +
                "idPaiement=" + idPaiement +
                ", montant=" + montant +
                ", dtPaiement=" + dtPaiement +
                ", pourcentage=" + pourcentage +
                ", societe=" + (societe != null ? societe.getNom() : "null") +
                '}';
    }
}
