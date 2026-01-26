package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "contrats_pubs")
public class ContratPub {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_contrat")
    private Long idContrat;
    
    @Column(name = "dt_contrat", nullable = false)
    private LocalDate dtContrat;
    
    @Column(name = "quota", nullable = false)
    private Integer quota;
    
    @ManyToOne
    @JoinColumn(name = "id_societe", nullable = false)
    private Societe societe;
    
    @ManyToOne
    @JoinColumn(name = "id_prix", nullable = false)
    private PrixPub prix;

    // Constructeurs
    public ContratPub() {
    }

    public ContratPub(LocalDate dtContrat, Integer quota, Societe societe, PrixPub prix) {
        this.dtContrat = dtContrat;
        this.quota = quota;
        this.societe = societe;
        this.prix = prix;
    }

    // Getters et Setters
    public Long getIdContrat() {
        return idContrat;
    }

    public void setIdContrat(Long idContrat) {
        this.idContrat = idContrat;
    }

    public LocalDate getDtContrat() {
        return dtContrat;
    }

    public void setDtContrat(LocalDate dtContrat) {
        this.dtContrat = dtContrat;
    }

    public Integer getQuota() {
        return quota;
    }

    public void setQuota(Integer quota) {
        this.quota = quota;
    }

    public Societe getSociete() {
        return societe;
    }

    public void setSociete(Societe societe) {
        this.societe = societe;
    }

    public PrixPub getPrix() {
        return prix;
    }

    public void setPrix(PrixPub prix) {
        this.prix = prix;
    }

    @Override
    public String toString() {
        return "ContratPub{" +
                "idContrat=" + idContrat +
                ", dtContrat=" + dtContrat +
                ", quota=" + quota +
                ", societe=" + (societe != null ? societe.getNom() : "null") +
                ", prix=" + (prix != null ? prix.getValeur() : "null") +
                '}';
    }
}
