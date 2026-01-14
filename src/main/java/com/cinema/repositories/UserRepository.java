package com.cinema.repositories;

import com.cinema.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
    Optional<User> findByUsernameAndActif(String username, Boolean actif);
    boolean existsByUsername(String username);
    List<User> findByActif(Boolean actif);
    
    @Query("SELECT u FROM User u WHERE u.role.nomRole = :nomRole")
    List<User> findByRoleName(@Param("nomRole") String nomRole);
    
    @Query("SELECT u FROM User u WHERE u.role.nomRole = :nomRole AND u.actif = :actif")
    List<User> findByRoleNameAndActif(@Param("nomRole") String nomRole, @Param("actif") Boolean actif);
}
