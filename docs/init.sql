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
VALUES ('manager', 'manager123', 'Rabe', 'Marie', '0340000002', 
        (SELECT id_role FROM roles WHERE nom_role = 'MANAGER'), TRUE);
INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) 
VALUES ('caissier', 'caissier123', 'Rasoa', 'Paul', '0340000003', 
        (SELECT id_role FROM roles WHERE nom_role = 'CAISSIER'), TRUE);



insert into type_places (nom, prix) values
('Standard', 20000.00),
('Premium', 50000.00);