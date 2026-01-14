-- ============================================
-- VUE: Statistiques des Séances
-- ============================================
CREATE OR REPLACE VIEW v_seances_stats AS
SELECT 
    s.id_seance,
    f.id_film,
    f.titre AS film_titre,
    sa.id_salle,
    sa.nom AS salle_nom,
    s.daty,
    s.heure,
    sa.capacite AS capacite_totale,
    COUNT(DISTINCT b.id_billet) AS nb_billets_generes,
    COUNT(DISTINCT ab.id_billet) AS nb_billets_vendus,
    sa.capacite - COUNT(DISTINCT CASE WHEN ab.id_billet IS NOT NULL THEN b.id_billet END) AS nb_places_disponibles,
    COALESCE(SUM(a.total), 0) AS total_ventes,
    CASE 
        WHEN sa.capacite > 0 THEN 
            ROUND((COUNT(DISTINCT CASE WHEN ab.id_billet IS NOT NULL THEN b.id_billet END)::NUMERIC / sa.capacite::NUMERIC) * 100, 2)
        ELSE 0 
    END AS taux_remplissage
FROM seances s
INNER JOIN films f ON s.id_film = f.id_film
INNER JOIN salles sa ON s.id_salle = sa.id_salle
LEFT JOIN billets b ON s.id_seance = b.id_seance
LEFT JOIN achat_billets ab ON b.id_billet = ab.id_billet
LEFT JOIN achats a ON ab.id_achat = a.id_achat
GROUP BY s.id_seance, f.id_film, f.titre, sa.id_salle, sa.nom, s.daty, s.heure, sa.capacite;

-- ============================================
-- VUE: Détail des Ventes par Séance
-- ============================================
CREATE OR REPLACE VIEW v_ventes_par_seance AS
SELECT 
    a.id_achat,
    a.nom_acheteur,
    a.dt_achat,
    a.total,
    s.id_seance,
    f.titre AS film_titre,
    s.daty,
    s.heure,
    sa.nom AS salle_nom,
    COUNT(ab.id_billet) AS nb_billets,
    STRING_AGG(p.code_place, ', ' ORDER BY p.code_place) AS places
FROM achats a
INNER JOIN achat_billets ab ON a.id_achat = ab.id_achat
INNER JOIN billets b ON ab.id_billet = b.id_billet
INNER JOIN seances s ON b.id_seance = s.id_seance
INNER JOIN films f ON s.id_film = f.id_film
INNER JOIN salles sa ON s.id_salle = sa.id_salle
INNER JOIN places p ON b.id_place = p.id_place
GROUP BY a.id_achat, a.nom_acheteur, a.dt_achat, a.total, 
         s.id_seance, f.titre, s.daty, s.heure, sa.nom;

-- ============================================
-- VUE: Places Disponibles par Séance
-- ============================================
CREATE OR REPLACE VIEW v_places_disponibles AS
SELECT 
    s.id_seance,
    f.titre AS film_titre,
    s.daty,
    s.heure,
    sa.nom AS salle_nom,
    b.id_billet,
    p.id_place,
    p.code_place,
    b.prix,
    CASE 
        WHEN ab.id_billet IS NULL THEN 'DISPONIBLE'
        ELSE 'VENDU'
    END AS statut
FROM seances s
INNER JOIN films f ON s.id_film = f.id_film
INNER JOIN salles sa ON s.id_salle = sa.id_salle
INNER JOIN billets b ON s.id_seance = b.id_seance
INNER JOIN places p ON b.id_place = p.id_place
LEFT JOIN achat_billets ab ON b.id_billet = ab.id_billet;

-- ============================================
-- VUE: Statistiques Globales des Ventes
-- ============================================
CREATE OR REPLACE VIEW v_statistiques_globales AS
SELECT 
    COUNT(DISTINCT a.id_achat) AS nb_achats_total,
    COUNT(DISTINCT ab.id_billet) AS nb_billets_vendus_total,
    COALESCE(SUM(a.total), 0) AS chiffre_affaires_total,
    COALESCE(AVG(a.total), 0) AS panier_moyen,
    COUNT(DISTINCT s.id_seance) AS nb_seances_avec_ventes,
    COUNT(DISTINCT f.id_film) AS nb_films_vendus
FROM achats a
INNER JOIN achat_billets ab ON a.id_achat = ab.id_achat
INNER JOIN billets b ON ab.id_billet = b.id_billet
INNER JOIN seances s ON b.id_seance = s.id_seance
INNER JOIN films f ON s.id_film = f.id_film;

-- ============================================
-- VUE: Top Films par Ventes
-- ============================================
CREATE OR REPLACE VIEW v_top_films AS
SELECT 
    f.id_film,
    f.titre,
    f.dt_sortie,
    COUNT(DISTINCT s.id_seance) AS nb_seances,
    COUNT(DISTINCT a.id_achat) AS nb_achats,
    COUNT(ab.id_billet) AS nb_billets_vendus,
    COALESCE(SUM(a.total), 0) AS total_ventes
FROM films f
INNER JOIN seances s ON f.id_film = s.id_film
LEFT JOIN billets b ON s.id_seance = b.id_seance
LEFT JOIN achat_billets ab ON b.id_billet = ab.id_billet
LEFT JOIN achats a ON ab.id_achat = a.id_achat
GROUP BY f.id_film, f.titre, f.dt_sortie
ORDER BY total_ventes DESC;
