package com.cinema.models;

import jakarta.persistence.*;

@Entity
@Table(name = "type_personnes")
public class TypePersonne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_type_personne")
    private Long idTypePersonne;

    @Column(name = "nom", nullable = false)
    private String nom;

    public TypePersonne() {}

    public TypePersonne(String nom) {
        this.nom = nom;
    }

    public Long getIdTypePersonne() {
        return idTypePersonne;
    }

    public void setIdTypePersonne(Long idTypePersonne) {
        this.idTypePersonne = idTypePersonne;
    }

    public Long getId() {
        return this.idTypePersonne;
    }

    public void setId(Long id) {
        this.idTypePersonne = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
