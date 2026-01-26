package com.cinema.models;
import jakarta.persistence.*;

@Entity
@Table(name = "salles_configs")
public class ConfigSalles {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_salle_config")
    private Long idSalleConfig;

    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;

    @Column(name = "nombre", nullable = false)
    private Integer nombre;

    // Constructeurs
    public ConfigSalles() {
    }

    public ConfigSalles(Salle salle, TypePlace typePlace, Integer nombre) {
        this.salle = salle;
        this.typePlace = typePlace;
        this.nombre = nombre;
    }

    // Getters et Setters
    public Long getIdSalleConfig() {
        return idSalleConfig;
    }

    public void setIdSalleConfig(Long idSalleConfig) {
        this.idSalleConfig = idSalleConfig;
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

    public Integer getNombre() {
        return nombre;
    }

    public void setNombre(Integer nombre) {
        this.nombre = nombre;
    }
}
