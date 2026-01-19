CREATE TABLE salles(
   id_salle SERIAL PRIMARY KEY,
   capacite INTEGER NOT NULL CHECK (capacite > 0),
   nom VARCHAR(50) NOT NULL,
   dt_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE films(
   id_film SERIAL PRIMARY KEY,
   titre VARCHAR(200) NOT NULL,
   dt_sortie DATE NOT NULL,
   synopsis VARCHAR(500),
   poster VARCHAR(255),
   duree INTEGER NOT NULL CHECK (duree > 0), -- durée en minutes
   dt_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seances(
   id_seance SERIAL PRIMARY KEY,
   date_seance DATE NOT NULL,
   heure_seance TIME NOT NULL,
   dt_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   id_film INTEGER NOT NULL,
   id_salle INTEGER NOT NULL,
   FOREIGN KEY(id_film) REFERENCES films(id_film),
   FOREIGN KEY(id_salle) REFERENCES salles(id_salle)
);

CREATE TABLE reservations(
   id_reservation SERIAL PRIMARY KEY,
   dt_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   nom_client VARCHAR(100),
   id_seance INTEGER NOT NULL,
   FOREIGN KEY(id_seance) REFERENCES seances(id_seance)
);

CREATE TABLE type_places(
   id_type_place SERIAL PRIMARY KEY,
   nom VARCHAR(100) NOT NULL
);

CREATE TABLE salles_configs(
   id_salle_config SERIAL PRIMARY KEY,
   nombre INTEGER NOT NULL CHECK (nombre > 0),
   id_type_place INTEGER NOT NULL,
   id_salle INTEGER NOT NULL,
   FOREIGN KEY(id_type_place) REFERENCES type_places(id_type_place),
   FOREIGN KEY(id_salle) REFERENCES salles(id_salle)
);

CREATE TABLE type_clients(
   id_type_client SERIAL PRIMARY KEY,
   nom VARCHAR(100) NOT NULL
);

CREATE TABLE tarifs(
   id_tarif SERIAL PRIMARY KEY,

   id_seance INTEGER NOT NULL,
   id_type_place INTEGER NOT NULL,
   id_type_client INTEGER NOT NULL,
   valeur NUMERIC(15,2) NOT NULL,
   id_type_client_ref INTEGER,

   FOREIGN KEY(id_seance) REFERENCES seances(id_seance),
   FOREIGN KEY(id_type_place) REFERENCES type_places(id_type_place),
   FOREIGN KEY(id_type_client) REFERENCES type_clients(id_type_client),
   FOREIGN KEY(id_type_client_ref) REFERENCES type_clients(id_type_client)
);

-- Gestion Achat billet 
CREATE TABLE achats(
   id_achat SERIAL PRIMARY KEY,
   dt_achat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   montant_total NUMERIC(15,2) NOT NULL,
   statut VARCHAR(20) NOT NULL DEFAULT 'EN_COURS', -- EN_COURS | PAYE | ANNULE
   nom_client VARCHAR(100),
   id_seance INTEGER NOT NULL,
   FOREIGN KEY(id_seance) REFERENCES seances(id_seance)
);

CREATE TABLE achat_lignes(
   id_achat_ligne SERIAL PRIMARY KEY,
   id_achat INTEGER NOT NULL,
   id_type_place INTEGER NOT NULL,
   id_type_client INTEGER NOT NULL,
   quantite INTEGER NOT NULL CHECK (quantite > 0),
   prix_unitaire NUMERIC(15,2) NOT NULL,
   FOREIGN KEY(id_achat) REFERENCES achats(id_achat),
   FOREIGN KEY(id_type_place) REFERENCES type_places(id_type_place),
   FOREIGN KEY(id_type_client) REFERENCES type_clients(id_type_client)
);


