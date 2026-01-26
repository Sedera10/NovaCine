package com.cinema.dto;

import com.cinema.models.TypePlace;

public class SiegeDTO {
    private Long idSiege;
    private String rangee; // ex: A
    private Integer numero; // ex: 1
    private String position; // ex: A1
    private String statut; // DISPONIBLE, HORS_SERVICE, ...
    private TypePlace typeSiege; // réutilise TypePlace pour le nom/id

    public SiegeDTO() {}

    public SiegeDTO(Long idSiege, String rangee, Integer numero, String position, String statut, TypePlace typeSiege) {
        this.idSiege = idSiege;
        this.rangee = rangee;
        this.numero = numero;
        this.position = position;
        this.statut = statut;
        this.typeSiege = typeSiege;
    }

    public Long getIdSiege() {
        return idSiege;
    }

    public void setIdSiege(Long idSiege) {
        this.idSiege = idSiege;
    }

    public String getRangee() {
        return rangee;
    }

    public void setRangee(String rangee) {
        this.rangee = rangee;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public TypePlace getTypeSiege() {
        return typeSiege;
    }

    public void setTypeSiege(TypePlace typeSiege) {
        this.typeSiege = typeSiege;
    }
}
