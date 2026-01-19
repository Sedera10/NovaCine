package com.cinema.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "config_remise_personnes",
       uniqueConstraints = @UniqueConstraint(columnNames = {"id_type_personne"}))
public class ConfigRemisePersonne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_config_remise_personne")
    private Long idConfigRemise;

    @ManyToOne
    @JoinColumn(name = "id_type_personne", nullable = false)
    private TypePersonne typePersonne;

    @Column(name = "remise", nullable = false, precision = 5, scale = 2)
    private BigDecimal remise = BigDecimal.ZERO; // Pourcentage de remise (ex: 50 pour -50%)

    public ConfigRemisePersonne() {}

    public ConfigRemisePersonne(TypePersonne typePersonne, BigDecimal remise) {
        this.typePersonne = typePersonne;
        this.remise = remise;
    }

    public Long getIdConfigRemise() {
        return idConfigRemise;
    }

    public void setIdConfigRemise(Long idConfigRemise) {
        this.idConfigRemise = idConfigRemise;
    }

    public TypePersonne getTypePersonne() {
        return typePersonne;
    }

    public void setTypePersonne(TypePersonne typePersonne) {
        this.typePersonne = typePersonne;
    }

    public BigDecimal getRemise() {
        return remise;
    }

    public void setRemise(BigDecimal remise) {
        this.remise = remise;
    }
    
    /**
     * Calcule le prix après remise
     * @param prixBase Le prix de base (adulte)
     * @return Le prix après application de la remise
     */
    public BigDecimal calculerPrixAvecRemise(BigDecimal prixBase) {
        if (prixBase == null || remise == null) return prixBase;
        // Prix = prixBase * (1 - remise/100)
        BigDecimal facteur = BigDecimal.ONE.subtract(remise.divide(new BigDecimal("100")));
        return prixBase.multiply(facteur).setScale(2, java.math.RoundingMode.HALF_UP);
    }
}
