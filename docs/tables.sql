
CREATE TABLE roles (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) NOT NULL UNIQUE,
    capacite INT NOT NULL DEFAULT 1, 
    description TEXT
);

CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Hash bcrypt (60+ caractères)
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20),
    id_role INTEGER NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_user_role FOREIGN KEY (id_role) 
        REFERENCES roles(id_role) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE salles (
   id_salle SERIAL PRIMARY KEY,
   nom VARCHAR(30),
   capacite INTEGER NOT NULL,
   nb_rangee INTEGER NOT NULL,
   nb_colonne INTEGER NOT NULL,
   dt_creation TIMESTAMP NOT NULL DEFAULT NOW(),
   CHECK (nb_rangee * nb_colonne = capacite)
);

CREATE TABLE films (
   id_film SERIAL PRIMARY KEY,
   titre VARCHAR(200) NOT NULL,
   dt_sortie DATE,
   synopsis VARCHAR(500),
   duree INTEGER,
   poster_path VARCHAR(255),
   dt_creation TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE places (
   id_place SERIAL PRIMARY KEY,
   code_place VARCHAR(10) NOT NULL, -- ex: A1, B3
   id_salle INTEGER NOT NULL,
   id_type_place INTEGER,
   dt_creation TIMESTAMP DEFAULT NOW(),
   UNIQUE (code_place, id_salle),
   FOREIGN KEY (id_salle) REFERENCES salles(id_salle) 
       ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (id_type_place) REFERENCES type_places(id_type_place)
       ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE seances (
   id_seance SERIAL PRIMARY KEY,
   daty DATE NOT NULL,
   heure TIME NOT NULL,
   dt_creation TIMESTAMP NOT NULL DEFAULT NOW(),
   id_film INTEGER NOT NULL,
   id_salle INTEGER NOT NULL,
   FOREIGN KEY (id_film) REFERENCES films(id_film) 
       ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (id_salle) REFERENCES salles(id_salle) 
       ON DELETE RESTRICT ON UPDATE CASCADE,
   UNIQUE (daty, heure, id_salle)
);

CREATE TABLE achats (
   id_achat SERIAL PRIMARY KEY,
   dt_achat TIMESTAMP NOT NULL DEFAULT NOW(),
   nom_acheteur VARCHAR(100),
   total NUMERIC(10,2) NOT NULL
);

CREATE TABLE achats_billets(
   id_achat_billet SERIAL,
   id_place INTEGER NOT NULL,
   id_seance INTEGER NOT NULL,
   id_achat INTEGER NOT NULL,
   PRIMARY KEY(id_achat_billet),
   FOREIGN KEY(id_place) REFERENCES places(id_place),
   FOREIGN KEY(id_seance) REFERENCES seances(id_seance),
   FOREIGN KEY(id_achat) REFERENCES achats(id_achat)
);


-- projet 15 janvier

CREATE TABLE type_places (
   id_type_place SERIAL PRIMARY KEY,
   nom VARCHAR(50) NOT NULL
);

CREATE TABLE config_salles (
   id_config_salle SERIAL PRIMARY KEY,
   id_salle INTEGER NOT NULL,
   id_type_place INTEGER NOT NULL,
   nombre_places INTEGER NOT NULL,

   FOREIGN KEY (id_salle) REFERENCES salles(id_salle),
   FOREIGN KEY (id_type_place) REFERENCES type_places(id_type_place),

   UNIQUE (id_salle, id_type_place)
);

CREATE TABLE type_personnes (
   id_type_personne SERIAL PRIMARY KEY,
   nom VARCHAR(50) NOT NULL
);

CREATE TABLE config_seances (
   id_config_seance SERIAL PRIMARY KEY,
   id_seance INTEGER NOT NULL,
   id_type_place INTEGER NOT NULL,
   prix NUMERIC(15,2) NOT NULL,

   FOREIGN KEY (id_seance) REFERENCES seances(id_seance) ON DELETE CASCADE,
   FOREIGN KEY (id_type_place) REFERENCES type_places(id_type_place),

   UNIQUE (id_seance, id_type_place)
);

CREATE TABLE config_remise_personnes(
   id_config_remise_personne SERIAL PRIMARY KEY,
   id_type_personne INTEGER NOT NULL,
   remise NUMERIC(5,2) NOT NULL DEFAULT 0, -- Pourcentage de remise (ex: 50 pour -50%)
   
   FOREIGN KEY(id_type_personne) REFERENCES type_personnes(id_type_personne),
   UNIQUE (id_type_personne)
);



