-- Insertion des données de référence nécessaires
INSERT INTO pays (id_pays, nom) VALUES ('USA', 'États-Unis') ON CONFLICT (id_pays) DO NOTHING;
INSERT INTO pays (id_pays, nom) VALUES ('MDG', 'Madagascar') ON CONFLICT (id_pays) DO NOTHING;

INSERT INTO langues (id_langue, nom) VALUES ('EN', 'Anglais') ON CONFLICT (id_langue) DO NOTHING;
INSERT INTO langues (id_langue, nom) VALUES ('FR', 'Français') ON CONFLICT (id_langue) DO NOTHING;

INSERT INTO classification (id_classification, nom, signification) 
VALUES ('PG13', 'PG-13', 'Parental Guidance - 13 ans et plus') ON CONFLICT (id_classification) DO NOTHING;

INSERT INTO categories (id_categorie, nom)
VALUES ('SCIFI', 'Science-Fiction') ON CONFLICT (id_categorie) DO NOTHING;

-- Insertion du film Avatar
INSERT INTO films (
    id_film, 
    titre, 
    synopsis, 
    dt_sortie, 
    duree, 
    realisateur, 
    statut, 
    poster,
    id_pays_origine, 
    id_langue_originale, 
    id_langue_doublage, 
    id_classification
) VALUES (
    'FIL0001',
    'Avatar',
    'Sur la lointaine planète de Pandora, Jake Sully, un ancien marine paralysé, est recruté pour infiltrer le peuple des Na''vi. Mais en découvrant la beauté de leur monde et de leur culture, il se retrouve face à un choix déchirant.',
    '2009-12-18',
    162,
    'James Cameron',
    'EN_SALLE',
    '/images/avatar.jpg',
    'USA',
    'EN',
    'FR',
    'PG13'
) ON CONFLICT (id_film) DO NOTHING;

-- Associer le film à une catégorie
INSERT INTO films_categories (id_film, id_categorie)
VALUES ('FIL0001', 'SCIFI') ON CONFLICT (id_film, id_categorie) DO NOTHING;

-- Insertion d'un nouveau client
INSERT INTO clients (
    id_client,
    nom,
    prenom,
    email,
    telephone,
    dt_naissance,
    type_client,
    nombre_visites
) VALUES (
    'CLI0001',
    'Rakoto',
    'Jean',
    'jean.rakoto@email.com',
    '034 12 345 67',
    '1995-05-15',
    'STANDARD',
    0
) ON CONFLICT (id_client) DO NOTHING;

-- Vérification des insertions
SELECT 'Film inséré:' as info;
SELECT id_film, titre, realisateur, duree, statut FROM films WHERE id_film = 'FIL0001';

SELECT 'Client inséré:' as info;
SELECT id_client, nom, prenom, email, telephone FROM clients WHERE id_client = 'CLI0001';


