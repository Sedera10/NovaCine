INSERT INTO roles (nom_role, capacite, description) VALUES
('Admin', 22 , 'Administrateur système - Accès complet'),
('Manager', 11 , 'Manager - Gestion des séances et rapports'),
('Caissier', 1 , 'Caissier - Vente de billets au guichet');

-- Utilisateurs
INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) 
VALUES ('admin', 'admin', 'Valisoa', 'Sedera', '0381322871', 
        (SELECT id_role FROM roles WHERE nom_role = 'Admin'), TRUE);

INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) 
VALUES ('anjara', '', 'Koloina', 'Anjara', '0342365016', 
        (SELECT id_role FROM roles WHERE nom_role = 'Manager'), TRUE);

INSERT INTO type_places(nom) VALUES 
('Standard'),
('Prenium'),
('VIP');

INSERT INTO type_clients (nom) VALUES 
('Enfant'),
('Adolescent'),
('Adulte');

INSERT INTO societes (nom) VALUES 
('Vaniala'),
('Lewis');