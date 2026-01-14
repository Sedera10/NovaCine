package com.cinema.dto;

import java.math.BigDecimal;
import java.util.List;

public class VenteDTO {
    
    private String idSeance;
    private List<String> idsSieges;
    private String idClient;
    private BigDecimal prixUnitaire;
    private String canalVente;
    
    // Informations client optionnelles (si nouveau client)
    private String nomClient;
    private String prenomClient;
    private String emailClient;
    private String telephoneClient;
    
    // Constructors
    public VenteDTO() {}
    
    // Getters and Setters
    public String getIdSeance() {
        return idSeance;
    }
    
    public void setIdSeance(String idSeance) {
        this.idSeance = idSeance;
    }
    
    public List<String> getIdsSieges() {
        return idsSieges;
    }
    
    public void setIdsSieges(List<String> idsSieges) {
        this.idsSieges = idsSieges;
    }
    
    public String getIdClient() {
        return idClient;
    }
    
    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }
    
    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }
    
    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
    
    public String getCanalVente() {
        return canalVente;
    }
    
    public void setCanalVente(String canalVente) {
        this.canalVente = canalVente;
    }
    
    public String getNomClient() {
        return nomClient;
    }
    
    public void setNomClient(String nomClient) {
        this.nomClient = nomClient;
    }
    
    public String getPrenomClient() {
        return prenomClient;
    }
    
    public void setPrenomClient(String prenomClient) {
        this.prenomClient = prenomClient;
    }
    
    public String getEmailClient() {
        return emailClient;
    }
    
    public void setEmailClient(String emailClient) {
        this.emailClient = emailClient;
    }
    
    public String getTelephoneClient() {
        return telephoneClient;
    }
    
    public void setTelephoneClient(String telephoneClient) {
        this.telephoneClient = telephoneClient;
    }
}
