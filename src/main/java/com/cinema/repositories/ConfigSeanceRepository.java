package com.cinema.repositories;

import com.cinema.models.ConfigSeance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigSeanceRepository extends JpaRepository<ConfigSeance, Long> {
    List<ConfigSeance> findBySeanceIdSeance(Long seanceId);
    ConfigSeance findBySeanceIdSeanceAndTypePlaceId(Long seanceId, Long typePlaceId);
}
