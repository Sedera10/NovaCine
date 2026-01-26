-- data_example.sql
-- Données d'exemple pour tester l'application
-- À exécuter APRÈS reset_data.sql
-- Ce script n'est PAS nécessaire pour le fonctionnement de base

BEGIN;

-- ============================================
-- FILMS D'EXEMPLE
-- ============================================

INSERT INTO films (titre, dt_sortie, synopsis, poster, duree) VALUES
  ('Titanic', '1997-12-19', 
   'Une aristocrate de dix-sept ans tombe amoureuse d''un artiste gentil mais pauvre à bord du luxueux et malheureux R.M.S. Titanic. Un des plus grands films romantiques de tous les temps.', 
   'Titanic.jpg', 194),
  
  ('Avatar', '2009-12-18', 
   'Un Marine paraplégique envoyé sur la lune Pandora dans une mission unique devient déchiré entre suivre ses ordres et protéger le monde qu''il considère comme son foyer.', 
   'Avatar.jpeg', 162),
  
  ('Avengers : End Game', '2019-04-26', 
   'Après les événements dévastateurs d''Infinity War, les Avengers s''assemblent une fois de plus pour inverser les actions de Thanos et restaurer l''équilibre de l''univers.', 
   'AvangersEndgame.webp', 181),
  
  ('Inception', '2010-07-16', 
   'Un voleur qui s''infiltre dans les rêves pour voler des secrets se voit offrir une chance de racheter ses crimes en implantant une idée dans l''esprit d''un PDG.', 
   'Inception.webp', 148),
  
  ('Interstellar', '2014-11-07', 
   'Une équipe d''explorateurs voyage à travers un trou de ver dans l''espace dans une tentative d''assurer la survie de l''humanité face à sa disparition imminente.', 
   'Interstellar.jpg', 169),
  
  ('Roofman', '2024-10-04', 
   'Un cambrioleur évadé de prison trouve refuge dans un cinéma fermé où il vit en secret, regardant des films et se cachant du monde extérieur tout en reconstituant sa vie.', 
   'Roofman.jpg', 119);

-- ============================================
-- SALLES D'EXEMPLE
-- ============================================

INSERT INTO salles (nom, capacite) VALUES
  ('Salle 1', 100),
  ('Salle 2', 150),
  ('Salle 3', 80);

-- Configuration des places par salle
-- Salle 1 : 50 Standard, 30 Premium, 20 VIP
INSERT INTO salles_configs (nombre, id_type_place, id_salle) VALUES
  (50, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 1),
  (30, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 1),
  (20, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 1);

-- Salle 2 : 70 Standard, 50 Premium, 30 VIP
INSERT INTO salles_configs (nombre, id_type_place, id_salle) VALUES
  (70, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 2),
  (50, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 2),
  (30, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 2);

-- Salle 3 : 40 Standard, 25 Premium, 15 VIP
INSERT INTO salles_configs (nombre, id_type_place, id_salle) VALUES
  (40, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 3),
  (25, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 3),
  (15, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 3);

-- ============================================
-- SÉANCES D'EXEMPLE (Janvier 2026)
-- ============================================

INSERT INTO seances (date_seance, heure_seance, id_film, id_salle) VALUES
  -- Titanic - 22/01/2026
  ('2026-01-22', '14:00', (SELECT id_film FROM films WHERE titre = 'Titanic'), 1),
  ('2026-01-22', '19:00', (SELECT id_film FROM films WHERE titre = 'Titanic'), 1),
  
  -- Avatar - 23/01/2026
  ('2026-01-23', '15:00', (SELECT id_film FROM films WHERE titre = 'Avatar'), 2),
  ('2026-01-23', '20:00', (SELECT id_film FROM films WHERE titre = 'Avatar'), 2),
  
  -- Avengers - 24/01/2026
  ('2026-01-24', '16:00', (SELECT id_film FROM films WHERE titre = 'Avengers : End Game'), 3),
  ('2026-01-24', '21:00', (SELECT id_film FROM films WHERE titre = 'Avengers : End Game'), 3);

-- ============================================
-- TARIFS D'EXEMPLE
-- ============================================

-- Tarifs pour toutes les séances (exemple simplifié)
-- Standard : Enfant 5000, Ado 7000, Adulte 10000
-- Premium : Enfant 7000, Ado 10000, Adulte 15000
-- VIP : Enfant 10000, Ado 15000, Adulte 20000

DO $$
DECLARE
    seance_rec RECORD;
BEGIN
    FOR seance_rec IN SELECT id_seance FROM seances LOOP
        -- Standard
        INSERT INTO tarifs (id_seance, id_type_place, id_type_client, valeur) VALUES
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Enfant'), 5000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adolescent'), 7000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 10000);
        
        -- Premium
        INSERT INTO tarifs (id_seance, id_type_place, id_type_client, valeur) VALUES
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Enfant'), 7000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adolescent'), 10000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 15000);
        
        -- VIP
        INSERT INTO tarifs (id_seance, id_type_place, id_type_client, valeur) VALUES
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Enfant'), 10000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adolescent'), 15000),
            (seance_rec.id_seance, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 
             (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 20000);
    END LOOP;
END $$;

-- ============================================
-- SOCIÉTÉS DE PUBLICITÉ D'EXEMPLE
-- ============================================

INSERT INTO societes (nom) VALUES
  ('Vaniala'),
  ('Lewis'),
  ('Star Pub'),
  ('Media Plus');

-- ============================================
-- CONTRATS PUBLICITÉ (Janvier 2026)
-- ============================================

INSERT INTO contrats_pubs (dt_contrat, quota, id_societe, id_prix) VALUES
  ('2026-01-01', 20, (SELECT id_societe FROM societes WHERE nom = 'Vaniala'), 
   (SELECT id_prix FROM prix_pubs LIMIT 1)),
  ('2026-01-01', 15, (SELECT id_societe FROM societes WHERE nom = 'Lewis'), 
   (SELECT id_prix FROM prix_pubs LIMIT 1)),
  ('2026-01-01', 10, (SELECT id_societe FROM societes WHERE nom = 'Star Pub'), 
   (SELECT id_prix FROM prix_pubs LIMIT 1));

-- ============================================
-- DIFFUSIONS PUBLICITÉ D'EXEMPLE
-- ============================================

-- Diffusions pour Vaniala
INSERT INTO diffusions (dt_diffusion, nombre_diffusions, id_seance, id_societe) VALUES
  ('2026-01-22 13:45:00', 2, 
   (SELECT id_seance FROM seances WHERE date_seance = '2026-01-22' AND heure_seance = '14:00' LIMIT 1),
   (SELECT id_societe FROM societes WHERE nom = 'Vaniala')),
  ('2026-01-22 18:45:00', 3, 
   (SELECT id_seance FROM seances WHERE date_seance = '2026-01-22' AND heure_seance = '19:00' LIMIT 1),
   (SELECT id_societe FROM societes WHERE nom = 'Vaniala'));

-- Diffusions pour Lewis
INSERT INTO diffusions (dt_diffusion, nombre_diffusions, id_seance, id_societe) VALUES
  ('2026-01-23 14:45:00', 2, 
   (SELECT id_seance FROM seances WHERE date_seance = '2026-01-23' AND heure_seance = '15:00' LIMIT 1),
   (SELECT id_societe FROM societes WHERE nom = 'Lewis'));

-- ============================================
-- PAIEMENTS PUBLICITÉ D'EXEMPLE
-- ============================================

-- Paiement partiel pour Vaniala (250000 sur 1000000)
INSERT INTO paiement_pubs (montant, dt_paiement, id_societe) VALUES
  (250000.00, '2026-01-15', (SELECT id_societe FROM societes WHERE nom = 'Vaniala'));

-- Paiement complet pour Lewis (750000 = 15 * 50000)
INSERT INTO paiement_pubs (montant, dt_paiement, id_societe) VALUES
  (750000.00, '2026-01-10', (SELECT id_societe FROM societes WHERE nom = 'Lewis'));

-- ============================================
-- ACHATS/VENTES D'EXEMPLE
-- ============================================

-- Achat 1 : Titanic 22/01 - 14h00
INSERT INTO achats (dt_achat, montant_total, statut, nom_client, id_seance) VALUES
  ('2026-01-22 13:30:00', 45000, 'PAYE', 'Rakoto Jean',
   (SELECT id_seance FROM seances WHERE date_seance = '2026-01-22' AND heure_seance = '14:00' LIMIT 1));

INSERT INTO achat_lignes (id_achat, id_type_place, id_type_client, quantite, prix_unitaire) VALUES
  (1, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 
   (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 2, 10000),
  (1, (SELECT id_type_place FROM type_places WHERE nom = 'Premium'), 
   (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 1, 15000),
  (1, (SELECT id_type_place FROM type_places WHERE nom = 'Standard'), 
   (SELECT id_type_client FROM type_clients WHERE nom = 'Enfant'), 1, 5000);

-- Achat 2 : Avatar 23/01 - 15h00
INSERT INTO achats (dt_achat, montant_total, statut, nom_client, id_seance) VALUES
  ('2026-01-23 14:00:00', 60000, 'PAYE', 'Rasoa Marie',
   (SELECT id_seance FROM seances WHERE date_seance = '2026-01-23' AND heure_seance = '15:00' LIMIT 1));

INSERT INTO achat_lignes (id_achat, id_type_place, id_type_client, quantite, prix_unitaire) VALUES
  (2, (SELECT id_type_place FROM type_places WHERE nom = 'VIP'), 
   (SELECT id_type_client FROM type_clients WHERE nom = 'Adulte'), 3, 20000);

COMMIT;

-- ============================================
-- Pour exécuter ce script :
-- psql -U postgres -d novacine_db -f docs/data_example.sql
-- ============================================
