-- Script de renitalisation de la base de données novacine_db
-- Désactiver les contraintes de clés étrangères temporairement
SET session_replication_role = 'replica';

-- Vider toutes les tables (ordre inverse des dépendances)
TRUNCATE TABLE achat_billets CASCADE;
TRUNCATE TABLE achats CASCADE;
TRUNCATE TABLE billets CASCADE;
TRUNCATE TABLE seances CASCADE;
TRUNCATE TABLE places CASCADE;
TRUNCATE TABLE config_salles CASCADE;
TRUNCATE TABLE films CASCADE;
TRUNCATE TABLE salles CASCADE;
TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE roles CASCADE;
TRUNCATE TABLE type_places CASCADE;

-- Réactiver les contraintes de clés étrangères
SET session_replication_role = 'origin';

-- Réinitialiser les séquences pour les clés primaires
ALTER SEQUENCE roles_id_role_seq RESTART WITH 1;
ALTER SEQUENCE users_id_user_seq RESTART WITH 1;
ALTER SEQUENCE salles_id_salle_seq RESTART WITH 1;
ALTER SEQUENCE films_id_film_seq RESTART WITH 1;
ALTER SEQUENCE places_id_place_seq RESTART WITH 1;
ALTER SEQUENCE seances_id_seance_seq RESTART WITH 1;
ALTER SEQUENCE billets_id_billet_seq RESTART WITH 1;
ALTER SEQUENCE achats_id_achat_seq RESTART WITH 1;
ALTER SEQUENCE type_places_id_type_place_seq RESTART WITH 1;
ALTER SEQUENCE config_salles_id_config_salle_seq RESTART WITH 1;

-- Insertion des données par défaut
INSERT INTO roles (nom_role, capacite, description) VALUES
('ADMIN', 22, 'Administrateur système - Accès complet'),
('MANAGER', 11, 'Manager - Gestion des séances et rapports'),
('CAISSIER', 1, 'Caissier - Vente de billets au guichet');

INSERT INTO type_places (nom, prix) VALUES
('Standard', 20000.00),
('Premium', 50000.00),
('VIP', 90000.00);

INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) VALUES
('admin', 'admin', 'Valisoa', 'Sedera', '0381322871', 
    (SELECT id_role FROM roles WHERE nom_role = 'ADMIN'), TRUE),
('anjara', '', 'Koloina', 'Anjara', '0342365016', 
    (SELECT id_role FROM roles WHERE nom_role = 'MANAGER'), TRUE);

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE '✅ Base de données novacine_db réinitialisée avec succès !';
END $$;
