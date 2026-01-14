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
    
    @Column(name = "nom_acheteur", length = 100)
    private String nomAcheteur;
    
    @Column(name = "total", nullable = false, precision = 10, scale = 2)
    private BigDecimal total;
    
    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
        name = "achat_billets",
        joinColumns = @JoinColumn(name = "id_achat"),
        inverseJoinColumns = @JoinColumn(name = "id_billet")
    )
    private List<Billet> billets = new ArrayList<>();

    // Constructeurs
    public Achat() {
        this.dtAchat = LocalDateTime.now();
        this.total = BigDecimal.ZERO;
    }

    public Achat(String nomAcheteur, BigDecimal total) {
        this.nomAcheteur = nomAcheteur;
        this.total = total;
        this.dtAchat = LocalDateTime.now();
    }

    // Méthodes utiles
    public void addBillet(Billet billet) {
        this.billets.add(billet);
    }

    public void removeBillet(Billet billet) {
        this.billets.remove(billet);
    }

    public void calculerTotal() {
        this.total = billets.stream()
            .map(Billet::getPrix)
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

    public String getNomAcheteur() {
        return nomAcheteur;
    }

    public void setNomAcheteur(String nomAcheteur) {
        this.nomAcheteur = nomAcheteur;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public List<Billet> getBillets() {
        return billets;
    }

    public void setBillets(List<Billet> billets) {
        this.billets = billets;
    }
}
