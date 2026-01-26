package com.cinema.repositories;

import com.cinema.models.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    // TODO: Ajouter les méthodes personnalisées
}
