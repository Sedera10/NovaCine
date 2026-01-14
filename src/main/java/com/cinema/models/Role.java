package com.cinema.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "roles")
public class Role {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_role")
    private Long idRole;
    
    @Column(name = "nom_role", nullable = false, unique = true, length = 50)
    private String nomRole;
    
    @Column(name = "capacite", nullable = false)
    private Integer capacite = 1;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @OneToMany(mappedBy = "role")
    private List<User> users;
    
    // Constructeurs
    public Role() {
    }
    
    public Role(String nomRole, Integer capacite, String description) {
        this.nomRole = nomRole;
        this.capacite = capacite;
        this.description = description;
    }
    
    // Getters et Setters
    public Long getIdRole() {
        return idRole;
    }
    
    public void setIdRole(Long idRole) {
        this.idRole = idRole;
    }
    
    public String getNomRole() {
        return nomRole;
    }
    
    public void setNomRole(String nomRole) {
        this.nomRole = nomRole;
    }
    
    public Integer getCapacite() {
        return capacite;
    }
    
    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<User> getUsers() {
        return users;
    }
    
    public void setUsers(List<User> users) {
        this.users = users;
    }
    
    @Override
    public String toString() {
        return "Role{" +
                "idRole=" + idRole +
                ", nomRole='" + nomRole + '\'' +
                ", capacite=" + capacite +
                ", description='" + description + '\'' +
                '}';
    }
}
