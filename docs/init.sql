-- Insertion des rôles par défaut
INSERT INTO roles (nom_role, capacite, description) VALUES
('ADMIN', 22 , 'Administrateur système - Accès complet'),
('MANAGER', 11 , 'Manager - Gestion des séances et rapports'),
('CAISSIER', 1 , 'Caissier - Vente de billets au guichet');

-- Utilisateurs
INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) 
VALUES ('admin', 'admin', 'Valisoa', 'Sedera', '0381322871', 
        (SELECT id_role FROM roles WHERE nom_role = 'ADMIN'), TRUE);

INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) 
VALUES ('anjara', '', 'Koloina', 'Anjara', '0342365016', 
        (SELECT id_role FROM roles WHERE nom_role = 'MANAGER'), TRUE);



insert into type_places (nom, prix) values
('Standard', 20000.00),
('Premium', 50000.00);


insert into type_places (nom, prix) values
('VIP', 90000.00);

insert into type_personnes (nom) values
('Adulte'),
('Enfant');

insert into type_personnes (nom) values
('Adolescent');

-- Remises par type de personne (en pourcentage)
insert into config_remise_personnes (id_type_personne, remise) values
((SELECT id_type_personne FROM type_personnes WHERE nom = 'Adulte'), 0),
((SELECT id_type_personne FROM type_personnes WHERE nom = 'Enfant'), 50),
((SELECT id_type_personne FROM type_personnes WHERE nom = 'Adolescent'), 0);