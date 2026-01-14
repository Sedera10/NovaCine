package com.cinema.services;

import com.cinema.models.Film;
import com.cinema.repositories.FilmRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class FilmService {
    
    @Autowired
    private FilmRepository filmRepository;
    
    public List<Film> getAllFilms() {
        return filmRepository.findAll();
    }
    
    public Film getFilmById(Long id) {
        return filmRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Film non trouvé avec l'ID: " + id));
    }
    
    public List<Film> searchFilmsByTitre(String titre) {
        return filmRepository.findByTitreContainingIgnoreCase(titre);
    }
    
    public List<Film> getFilmsSortis() {
        return filmRepository.findFilmsSortis();
    }
    
    public List<Film> getFilmsOrderByDateDesc() {
        return filmRepository.findAllOrderByDateSortieDesc();
    }
    
    @Transactional
    public Film saveFilm(Film film) {
        return filmRepository.save(film);
    }
    
    @Transactional
    public Film createFilm(String titre, LocalDate dtSortie, String synopsis, Integer duree, String posterPath) {
        Film film = new Film(titre, dtSortie, synopsis, duree, posterPath);
        return filmRepository.save(film);
    }
    
    @Transactional
    public Film updateFilm(Long id, Film filmData) {
        Film film = getFilmById(id);
        film.setTitre(filmData.getTitre());
        film.setDtSortie(filmData.getDtSortie());
        film.setSynopsis(filmData.getSynopsis());
        film.setDuree(filmData.getDuree());
        film.setPosterPath(filmData.getPosterPath());
        return filmRepository.save(film);
    }
    
    @Transactional
    public void deleteFilm(Long id) {
        filmRepository.deleteById(id);
    }
}
