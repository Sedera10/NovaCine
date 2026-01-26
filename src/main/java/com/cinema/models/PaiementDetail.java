package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "paiement_details")
public class PaiementDetail {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paiement_detail")
    private Long idPaiementDetail;
    
    @Column(name = "montant", nullable = false, precision = 15, scale = 2)
    private BigDecimal montant;
    
    @ManyToOne
    @JoinColumn(name = "id_diffusion", nullable = false)
    private Diffusion diffusion;
    
    @ManyToOne
    @JoinColumn(name = "id_paiement", nullable = false)
    private PaiementPub paiement;

    // Constructeurs
    public PaiementDetail() {
    }

    public PaiementDetail(BigDecimal montant, Diffusion diffusion, PaiementPub paiement) {
        this.montant = montant;
        this.diffusion = diffusion;
        this.paiement = paiement;
    }

    // Getters et Setters
    public Long getIdPaiementDetail() {
        return idPaiementDetail;
    }

    public void setIdPaiementDetail(Long idPaiementDetail) {
        this.idPaiementDetail = idPaiementDetail;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public Diffusion getDiffusion() {
        return diffusion;
    }

    public void setDiffusion(Diffusion diffusion) {
        this.diffusion = diffusion;
    }

    public PaiementPub getPaiement() {
        return paiement;
    }

    public void setPaiement(PaiementPub paiement) {
        this.paiement = paiement;
    }

    @Override
    public String toString() {
        return "PaiementDetail{" +
                "idPaiementDetail=" + idPaiementDetail +
                ", montant=" + montant +
                ", diffusion=" + (diffusion != null ? diffusion.getIdDiffusion() : "null") +
                '}';
    }
}
