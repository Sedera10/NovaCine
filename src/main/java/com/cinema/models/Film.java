package com.cinema.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "films")
public class Film {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_film")
    private Long idFilm;
    
    @Column(name = "titre", nullable = false, length = 200)
    private String titre;
    
    @Column(name = "dt_sortie")
    private LocalDate dtSortie;
    
    @Column(name = "synopsis", length = 500)
    private String synopsis;
    
    @Column(name = "duree")
    private Integer duree;

    @Column(name = "poster_path", length = 255)
    private String posterPath;
    
    @Column(name = "dt_creation", nullable = false)
    private LocalDateTime dtCreation;
    
    @OneToMany(mappedBy = "film")
    private List<Seance> seances;

    // Constructeurs
    public Film() {
        this.dtCreation = LocalDateTime.now();
    }

    public Film(String titre, LocalDate dtSortie, String synopsis, Integer duree, String posterPath) {
        this.titre = titre;
        this.dtSortie = dtSortie;
        this.synopsis = synopsis;
        this.duree = duree;
        this.posterPath = posterPath;
        this.dtCreation = LocalDateTime.now();
    }
    
    // Getters et Setters
    public Long getIdFilm() {
        return idFilm;
    }
    
    public void setIdFilm(Long idFilm) {
        this.idFilm = idFilm;
    }
    
    public String getTitre() {
        return titre;
    }
    
    public void setTitre(String titre) {
        this.titre = titre;
    }
    
    public LocalDate getDtSortie() {
        return dtSortie;
    }
    
    public void setDtSortie(LocalDate dtSortie) {
        this.dtSortie = dtSortie;
    }
    
    public String getSynopsis() {
        return synopsis;
    }
    
    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }
    
    public Integer getDuree() {
        return duree;
    }
    
    public void setDuree(Integer duree) {
        this.duree = duree;
    }
    
    public LocalDateTime getDtCreation() {
        return dtCreation;
    }
    
    public void setDtCreation(LocalDateTime dtCreation) {
        this.dtCreation = dtCreation;
    }
    
    public String getPosterPath() {
        return posterPath;
    }
    
    public void setPosterPath(String posterPath) {
        this.posterPath = posterPath;
    }
    
    public List<Seance> getSeances() {
        return seances;
    }
    
    public void setSeances(List<Seance> seances) {
        this.seances = seances;
    }
}

