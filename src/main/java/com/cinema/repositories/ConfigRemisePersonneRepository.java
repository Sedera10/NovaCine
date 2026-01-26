package com.cinema.repositories;

import com.cinema.models.ConfigRemisePersonne;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigRemisePersonneRepository extends JpaRepository<ConfigRemisePersonne, Long> {
    ConfigRemisePersonne findByTypePersonneIdTypePersonne(Long idTypePersonne);
}
