package com.cinema.services;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.cinema.models.Film;

@Service
public class FilmService {

    @org.springframework.beans.factory.annotation.Autowired
    private com.cinema.repositories.FilmRepository filmRepository;

    public List<Film> getAllFilms() {
        return filmRepository.findAll();
    }

    public List<Film> rechercherFilms(String search) {
        return filmRepository.findByTitreContainingIgnoreCase(search);
    }

    public Optional<Film> getFilmById(Long id) {
        return filmRepository.findById(id);
    }

    public Film saveFilm(Film film) {
        return filmRepository.save(film);
    }

    public void deleteFilm(Long id) {
        filmRepository.deleteById(id);
    }
}
