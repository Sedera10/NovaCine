package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_user")
    private Long idUser;
    
    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;
    
    @Column(name = "password", nullable = false, length = 255)
    private String password;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;
    
    @Column(name = "prenom", nullable = false, length = 100)
    private String prenom;
    
    @Column(name = "telephone", length = 20)
    private String telephone;
    
    @ManyToOne
    @JoinColumn(name = "id_role", nullable = false, 
                foreignKey = @ForeignKey(name = "fk_user_role"))
    private Role role;
    
    @Column(name = "actif")
    private Boolean actif = true;
    
    @Column(name = "date_creation")
    private LocalDateTime dateCreation;

    // Constructeurs
    public User() {
        this.dateCreation = LocalDateTime.now();
    }
    
    public User(String username, String password, String nom, String prenom, String telephone, Role role) {
        this.username = username;
        this.password = password;
        this.nom = nom;
        this.prenom = prenom;
        this.telephone = telephone;
        this.role = role;
        this.actif = true;
        this.dateCreation = LocalDateTime.now();
    }
    
    // Getters et Setters
    public Long getIdUser() { return idUser;}
    public void setIdUser(Long idUser) { this.idUser = idUser;}
    
    public String getUsername() { return username;}
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getNom() { return nom;}
    public void setNom(String nom) { this.nom = nom; }
    
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    
    public Role getRole() { return role; }
    
    public void setRole(Role role) { this.role = role; }
    
    public Boolean getActif() { return actif; } 
    public void setActif(Boolean actif) { this.actif = actif; }
    
    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }
    
    
    @Override
    public String toString() {
        return "User{" +
                "idUser=" + idUser +
                ", username='" + username + '\'' +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", telephone='" + telephone + '\'' +
                ", role=" + (role != null ? role.getNomRole() : "null") +
                ", actif=" + actif +
                ", dateCreation=" + dateCreation +
                '}';
    }
}
