package com.cinema.repositories;

import com.cinema.models.TypePlace;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypePlaceRepository extends JpaRepository<TypePlace, Long> {

}
