package com.cinema.models;

import jakarta.persistence.*;

@Entity
@Table(name = "type_clients")
public class TypePersonne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_type_client")
    private Long idTypeClient;

    @Column(name = "nom", nullable = false, length = 100)
    private String nom;

    public TypePersonne() {}

    public TypePersonne(String nom) {
        this.nom = nom;
    }

    public Long getIdTypeClient() {
        return idTypeClient;
    }

    public void setIdTypeClient(Long idTypeClient) {
        this.idTypeClient = idTypeClient;
    }

    public Long getId() {
        return this.idTypeClient;
    }

    public void setId(Long id) {
        this.idTypeClient = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
