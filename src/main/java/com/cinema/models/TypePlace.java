package com.cinema.models;

import jakarta.persistence.*;

@Entity
@Table(name = "type_places")
public class TypePlace {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_type_place")
    private Long id_type_place;

    @Column(name = "nom")
    private String nom;
    

    // Constructeurs
    public TypePlace() {
    }

    public TypePlace(long id_type_place, String nom) {
        this.id_type_place = id_type_place;
        this.nom = nom;
    }

    public TypePlace(String nom) {
        this.nom = nom;
    }

    // Getters et Setters
    public Long getId_type_place() {
        return id_type_place;
    }

    public void setId_type_place(Long id_type_place) {
        this.id_type_place = id_type_place;
    }

    // Standard id accessor for Spring Data property paths
    public Long getId() {
        return this.id_type_place;
    }

    public void setId(Long id) {
        this.id_type_place = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

}
