package com.cinema.repositories;

import com.cinema.models.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    
    /**
     * Recherche un rôle par son nom
     */
    Optional<Role> findByNomRole(String nomRole);
    
    /**
     * Vérifie si un rôle existe par son nom
     */
    boolean existsByNomRole(String nomRole);
}
