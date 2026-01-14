
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
   dt_creation TIMESTAMP DEFAULT NOW(),
   UNIQUE (code_place, id_salle),
   FOREIGN KEY (id_salle) REFERENCES salles(id_salle) 
       ON DELETE CASCADE ON UPDATE CASCADE
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

CREATE TABLE billets (
   id_billet SERIAL PRIMARY KEY,
   id_place INTEGER NOT NULL,
   id_seance INTEGER NOT NULL,
   prix NUMERIC(10,2) NOT NULL,
   dt_creation TIMESTAMP NOT NULL DEFAULT NOW(),
   UNIQUE (id_place, id_seance),
   FOREIGN KEY (id_place) REFERENCES places(id_place) 
       ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (id_seance) REFERENCES seances(id_seance) 
       ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE achats (
   id_achat SERIAL PRIMARY KEY,
   dt_achat TIMESTAMP NOT NULL DEFAULT NOW(),
   nom_acheteur VARCHAR(100),
   total NUMERIC(10,2) NOT NULL
);
CREATE TABLE achat_billets (
   id_achat INTEGER NOT NULL,
   id_billet INTEGER NOT NULL,
   PRIMARY KEY (id_achat, id_billet),
   FOREIGN KEY (id_achat) REFERENCES achats(id_achat) 
       ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (id_billet) REFERENCES billets(id_billet) 
       ON DELETE CASCADE ON UPDATE CASCADE
);
