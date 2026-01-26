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
   montant_total NUMERIC(15,2),
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
   -- places VARCHAR(500), tsy nety
   prix_unitaire NUMERIC(15,2),
   FOREIGN KEY(id_achat) REFERENCES achats(id_achat),
   FOREIGN KEY(id_type_place) REFERENCES type_places(id_type_place),
   FOREIGN KEY(id_type_client) REFERENCES type_clients(id_type_client)
);


-- Diffision publicitaire :

CREATE TABLE prix_pubs (
   id_prix SERIAL,
   valeur NUMERIC(15,2) NOT NULL,
   PRIMARY KEY (id_prix)
);

CREATE TABLE societes (
   id_societe SERIAL,
   nom VARCHAR(200) NOT NULL,
   PRIMARY KEY (id_societe)
);

CREATE TABLE contrats_pubs (
   id_contrat SERIAL,
   quota INTEGER NOT NULL CHECK (quota > 0),
   dt_contrat DATE NOT NULL,
   id_societe INTEGER NOT NULL,
   id_prix INTEGER NOT NULL,  -- ← AJOUT
   PRIMARY KEY (id_contrat),
   FOREIGN KEY (id_societe) REFERENCES societes(id_societe),
   FOREIGN KEY (id_prix) REFERENCES prix_pubs(id_prix)  -- ← AJOUT
);

CREATE TABLE diffusions (
   id_diffusion SERIAL,
   dt_diffusion TIMESTAMP NOT NULL,
   id_seance INTEGER NOT NULL,
   id_societe INTEGER NOT NULL,
   nombre_diffusions INTEGER NOT NULL DEFAULT 1,
   PRIMARY KEY (id_diffusion),
   FOREIGN KEY (id_societe) REFERENCES societes(id_societe),
   FOREIGN KEY (id_seance) REFERENCES seances(id_seance)
);

CREATE TABLE paiement_pubs (
   id_paiement SERIAL,
   montant NUMERIC(15,2) NOT NULL,
   dt_paiement DATE NOT NULL,
   id_societe INTEGER NOT NULL,
   description TEXT,
   pourcentage NUMERIC(15,2),
   PRIMARY KEY (id_paiement),
   FOREIGN KEY (id_societe) REFERENCES societes(id_societe)
);

CREATE TABLE paiement_details(
   id_paiement_detail SERIAL,
   montant NUMERIC(15,2)   NOT NULL,
   id_diffusion INTEGER NOT NULL,
   id_paiement INTEGER NOT NULL,
   PRIMARY KEY(id_paiement_detail),
   FOREIGN KEY(id_diffusion) REFERENCES diffusions(id_diffusion),
   FOREIGN KEY(id_paiement) REFERENCES paiement_pubs(id_paiement)
);
