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

    @Column(name = "prix")
    private float prix;

    // Constructeurs
    public TypePlace() {
    }

    public TypePlace(long id_type_place, String nom, float prix) {
        this.id_type_place = id_type_place;
        this.nom = nom;
        this.prix = prix;
    }

    public TypePlace(String nom, float prix) {
        this.nom = nom;
        this.prix = prix;
    }

    // Getters et Setters
    public Long getId_type_place() {
        return id_type_place;
    }

    public void setId_type_place(Long id_type_place) {
        this.id_type_place = id_type_place;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public float getPrix() {
        return prix;
    }

    public void setPrix(float prix) {
        this.prix = prix;
    }
}
