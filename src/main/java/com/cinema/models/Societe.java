package com.cinema.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "societes")
public class Societe {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_societe")
    private Long idSociete;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;
    
    @OneToMany(mappedBy = "societe", cascade = CascadeType.ALL)
    private List<ContratPub> contratsPub;

    @OneToMany(mappedBy = "societe", cascade = CascadeType.ALL)
    private List<Diffusion> diffusions;
    
    @OneToMany(mappedBy = "societe", cascade = CascadeType.ALL)
    private List<PaiementPub> paiements;

    // Constructeurs
    public Societe() {
    }

    public Societe(String nom) {
        this.nom = nom;
    }

    // Getters et Setters
    public Long getIdSociete() {
        return idSociete;
    }

    public void setIdSociete(Long idSociete) {
        this.idSociete = idSociete;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public List<ContratPub> getContratsPub() {
        return contratsPub;
    }

    public void setContratsPub(List<ContratPub> contratsPub) {
        this.contratsPub = contratsPub;
    }


    public List<Diffusion> getDiffusions() {
        return diffusions;
    }

    public void setDiffusions(List<Diffusion> diffusions) {
        this.diffusions = diffusions;
    }

    public List<PaiementPub> getPaiements() {
        return paiements;
    }

    public void setPaiements(List<PaiementPub> paiements) {
        this.paiements = paiements;
    }

    @Override
    public String toString() {
        return "Societe{" +
                "idSociete=" + idSociete +
                ", nom='" + nom + '\'' +
                '}';
    }
}
