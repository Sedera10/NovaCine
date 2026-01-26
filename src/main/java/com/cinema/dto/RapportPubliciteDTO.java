package com.cinema.dto;

import java.math.BigDecimal;

public class RapportPubliciteDTO {
    
    private String societe;
    private Integer annee;
    private Integer mois;
    private Long nombreDiffusions;
    private Integer quota;
    private BigDecimal chiffreAffaires;
    private BigDecimal tarifUnitaire;

    public RapportPubliciteDTO() {
    }

    public RapportPubliciteDTO(String societe, Integer annee, Integer mois, 
                               Long nombreDiffusions, Integer quota, 
                               BigDecimal chiffreAffaires, BigDecimal tarifUnitaire) {
        this.societe = societe;
        this.annee = annee;
        this.mois = mois;
        this.nombreDiffusions = nombreDiffusions;
        this.quota = quota;
        this.chiffreAffaires = chiffreAffaires;
        this.tarifUnitaire = tarifUnitaire;
    }

    // Getters et Setters
    public String getSociete() {
        return societe;
    }

    public void setSociete(String societe) {
        this.societe = societe;
    }

    public Integer getAnnee() {
        return annee;
    }

    public void setAnnee(Integer annee) {
        this.annee = annee;
    }

    public Integer getMois() {
        return mois;
    }

    public void setMois(Integer mois) {
        this.mois = mois;
    }

    public Long getNombreDiffusions() {
        return nombreDiffusions;
    }

    public void setNombreDiffusions(Long nombreDiffusions) {
        this.nombreDiffusions = nombreDiffusions;
    }

    public Integer getQuota() {
        return quota;
    }

    public void setQuota(Integer quota) {
        this.quota = quota;
    }

    public BigDecimal getChiffreAffaires() {
        return chiffreAffaires;
    }

    public void setChiffreAffaires(BigDecimal chiffreAffaires) {
        this.chiffreAffaires = chiffreAffaires;
    }

    public BigDecimal getTarifUnitaire() {
        return tarifUnitaire;
    }

    public void setTarifUnitaire(BigDecimal tarifUnitaire) {
        this.tarifUnitaire = tarifUnitaire;
    }

    /**
     * Calcule le pourcentage d'utilisation du quota
     */
    public Double getPourcentageQuota() {
        if (quota == null || quota == 0) {
            return 0.0;
        }
        return (nombreDiffusions.doubleValue() / quota) * 100;
    }

    /**
     * Vérifie si le quota est dépassé
     */
    public boolean isQuotaDepasse() {
        if (quota == null) {
            return false;
        }
        return nombreDiffusions > quota;
    }
}
