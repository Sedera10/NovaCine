package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "config_seances",
       uniqueConstraints = @UniqueConstraint(columnNames = {"id_seance", "id_type_place"}))
public class ConfigSeance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_config_seance")
    private Long idConfigSeance;

    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;

    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;

    @Column(name = "prix", nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;

    public ConfigSeance() {}

    public ConfigSeance(Seance seance, TypePlace typePlace, BigDecimal prix) {
        this.seance = seance;
        this.typePlace = typePlace;
        this.prix = prix;
    }

    public Long getIdConfigSeance() {
        return idConfigSeance;
    }

    public void setIdConfigSeance(Long idConfigSeance) {
        this.idConfigSeance = idConfigSeance;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public BigDecimal getPrix() {
        return prix;
    }

    public void setPrix(BigDecimal prix) {
        this.prix = prix;
    }
}
