package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "achats")
public class Achat {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_achat")
    private Long idAchat;
    
    @Column(name = "dt_achat", nullable = false)
    private LocalDateTime dtAchat;
    
    @Column(name = "montant_total", nullable = true, precision = 15, scale = 2)
    private BigDecimal montantTotal;
    
    @Column(name = "statut", nullable = false, length = 20)
    private String statut = "EN_COURS"; // EN_COURS | PAYE | ANNULE
    
    @Column(name = "nom_client", length = 100)
    private String nomClient;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;
    
    @OneToMany(mappedBy = "achat", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AchatLigne> lignes = new ArrayList<>();

    // Constructeurs
    public Achat() {
        this.dtAchat = LocalDateTime.now();
        this.montantTotal = BigDecimal.ZERO;
        this.statut = "EN_COURS";
    }

    public Achat(Seance seance, String nomClient) {
        this.seance = seance;
        this.nomClient = nomClient;
        this.dtAchat = LocalDateTime.now();
        this.montantTotal = BigDecimal.ZERO;
        this.statut = "EN_COURS";
    }

    // Méthodes utiles
    public void addLigne(AchatLigne ligne) {
        this.lignes.add(ligne);
        ligne.setAchat(this);
    }

    public void removeLigne(AchatLigne ligne) {
        this.lignes.remove(ligne);
        ligne.setAchat(null);
    }

    public void calculerTotal() {
        this.montantTotal = lignes.stream()
            .map(ligne -> ligne.getPrixUnitaire().multiply(new BigDecimal(ligne.getQuantite())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Getters et Setters
    public Long getIdAchat() {
        return idAchat;
    }

    public void setIdAchat(Long idAchat) {
        this.idAchat = idAchat;
    }

    public LocalDateTime getDtAchat() {
        return dtAchat;
    }

    public void setDtAchat(LocalDateTime dtAchat) {
        this.dtAchat = dtAchat;
    }

    public BigDecimal getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(BigDecimal montantTotal) {
        this.montantTotal = montantTotal;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getNomClient() {
        return nomClient;
    }

    public void setNomClient(String nomClient) {
        this.nomClient = nomClient;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public List<AchatLigne> getLignes() {
        return lignes;
    }

    public void setLignes(List<AchatLigne> lignes) {
        this.lignes = lignes;
    }
}
