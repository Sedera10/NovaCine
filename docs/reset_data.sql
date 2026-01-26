-- reset_data.sql
-- Script de réinitialisation COMPLÈTE de la base de données (PostgreSQL)
-- Supprime toutes les données et réinitialise les séquences
-- Réinsère uniquement les données par défaut nécessaires au fonctionnement

BEGIN;

-- ============================================
-- VIDAGE DE TOUTES LES TABLES
-- ============================================

TRUNCATE TABLE
  -- Tables de publicité
  paiement_pubs,
  diffusions,
  contrats_pubs,
  societes,
  prix_pubs,
  
  -- Tables de ventes
  achat_lignes,
  achats,
  
  -- Tables de configuration
  tarifs,
  salles_configs,
  reservations,
  
  -- Tables principales
  seances,
  films,
  salles,
  
  -- Tables d'authentification
  users,
  roles,
  
  -- Tables de référence
  type_places,
  type_clients
RESTART IDENTITY CASCADE;

-- ============================================
-- DONNÉES PAR DÉFAUT
-- ============================================

-- RÔLES
INSERT INTO roles (nom_role, capacite, description) VALUES
  ('Admin', 22, 'Administrateur système - Accès complet'),
  ('Manager', 11, 'Manager - Gestion des séances et rapports'),
  ('Caissier', 1, 'Caissier - Vente de billets au guichet');

-- UTILISATEURS
-- NOTE : En production, utiliser des mots de passe hashés (bcrypt)
INSERT INTO users (username, password, nom, prenom, telephone, id_role, actif) VALUES
  ('admin', 'admin', 'Valisoa', 'Sedera', '0381322871', 
   (SELECT id_role FROM roles WHERE nom_role = 'Admin'), TRUE),
  ('anjara', 'anjara', 'Koloina', 'Anjara', '0342365016', 
   (SELECT id_role FROM roles WHERE nom_role = 'Manager'), TRUE);

-- TYPES DE PLACES
INSERT INTO type_places (nom) VALUES
  ('Standard'),
  ('Premium'),
  ('VIP');

-- TYPES DE CLIENTS
INSERT INTO type_clients (nom) VALUES
  ('Enfant'),
  ('Adolescent'),
  ('Adulte');

-- PRIX PUBLICITÉ PAR DÉFAUT
INSERT INTO prix_pubs (valeur) VALUES
  (200000.00);  -- Tarif de base : 200 000 Ar par diffusion

COMMIT;

-- ============================================
-- Pour exécuter ce script :
-- psql -U postgres -d novacine_db -f docs/reset_data.sql
-- ============================================
