package com.cinema.models;
import jakarta.persistence.*;

@Entity
@Table(name = "config_salles",
    uniqueConstraints = @UniqueConstraint(columnNames = {"id_salle", "id_type_place"})
)
public class ConfigSalles {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_config_salle")
    private Long idConfigSalle;

    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;

    @Column(name = "nombre_places", nullable = false)
    private Integer nombrePlaces;

    // Constructeurs
    public ConfigSalles() {
    }

    public ConfigSalles(Salle salle, TypePlace typePlace, Integer nombrePlaces) {
        this.salle = salle;
        this.typePlace = typePlace;
        this.nombrePlaces = nombrePlaces;
    }

    // Getters et Setters
    public Long getIdConfigSalle() {
        return idConfigSalle;
    }

    public void setIdConfigSalle(Long idConfigSalle) {
        this.idConfigSalle = idConfigSalle;
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

    public Integer getNombrePlaces() {
        return nombrePlaces;
    }

    public void setNombrePlaces(Integer nombrePlaces) {
        this.nombrePlaces = nombrePlaces;
    }
}
