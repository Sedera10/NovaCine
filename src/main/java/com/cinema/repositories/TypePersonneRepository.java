package com.cinema.repositories;

import com.cinema.models.TypePersonne;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypePersonneRepository extends JpaRepository<TypePersonne, Long> {
    // TODO: Ajouter les méthodes personnalisées]
    TypePersonne findByNom(String nom);
}
