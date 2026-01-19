package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "places", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"code_place", "id_salle"}))
public class Place {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_place")
    private Long idPlace;
    
    @Column(name = "code_place", nullable = false, length = 10)
    private String codePlace;
    
    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;
    
    @ManyToOne
    @JoinColumn(name = "id_type_place")
    private TypePlace typePlace;
    
    @Column(name = "dt_creation")
    private LocalDateTime dtCreation;
    
    @OneToMany(mappedBy = "place", cascade = CascadeType.ALL)
    private List<Billet> billets;

    // Constructeurs
    public Place() {
        this.dtCreation = LocalDateTime.now();
    }

    public Place(String codePlace, Salle salle) {
        this.codePlace = codePlace;
        this.salle = salle;
        this.dtCreation = LocalDateTime.now();
    }
    
    public Place(String codePlace, Salle salle, TypePlace typePlace) {
        this.codePlace = codePlace;
        this.salle = salle;
        this.typePlace = typePlace;
        this.dtCreation = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getIdPlace() {
        return idPlace;
    }

    public void setIdPlace(Long idPlace) {
        this.idPlace = idPlace;
    }

    public String getCodePlace() {
        return codePlace;
    }

    public void setCodePlace(String codePlace) {
        this.codePlace = codePlace;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }
    
    public TypePlace getTypePlace() {
        return typePlace;
    }
    
    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public LocalDateTime getDtCreation() {
        return dtCreation;
    }

    public void setDtCreation(LocalDateTime dtCreation) {
        this.dtCreation = dtCreation;
    }

    public List<Billet> getBillets() {
        return billets;
    }

    public void setBillets(List<Billet> billets) {
        this.billets = billets;
    }
}
