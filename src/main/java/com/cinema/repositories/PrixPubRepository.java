package com.cinema.repositories;

import com.cinema.models.PrixPub;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PrixPubRepository extends JpaRepository<PrixPub, Long> {
}
