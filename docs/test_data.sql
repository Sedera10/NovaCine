-- Données de test pour NovaCine

-- Rôles
INSERT INTO roles (nom_role, capacite, description) VALUES 
('Admin', 5, 'Administrateur système'),
('Manager', 3, 'Gestionnaire'),
('Caissier', 1, 'Caissier/Vendeur');

-- Utilisateurs
INSERT INTO users (username, password, nom, prenom, telephone, id_role) VALUES 
('admin', 'admin123', 'Rakoto', 'Jean', '0341234567', 1),
('manager', 'manager123', 'Rasoa', 'Marie', '0341234568', 2),
('caissier', 'caissier123', 'Rabe', 'Paul', '0341234569', 3);

-- Salles
INSERT INTO salles (nom, capacite, nb_rangee, nb_colonne) VALUES 
('Salle A', 100, 10, 10),
('Salle B', 80, 8, 10),
('Salle C', 60, 6, 10);

-- Films
INSERT INTO films (titre, dt_sortie, synopsis, duree) VALUES 
('Avatar 2', '2023-12-14', 'Jake Sully vit désormais avec sa famille sur Pandora...', 192),
('Avengers: Endgame', '2019-04-24', 'Les Avengers restants doivent trouver un moyen de récupérer leurs alliés...', 181),
('Titanic', '1997-12-19', 'Un jeune artiste pauvre et une jeune femme de la haute société...', 195),
('Inception', '2010-07-16', 'Dom Cobb est un voleur expérimenté...', 148),
('Interstellar', '2014-11-05', 'Un groupe d''explorateurs utilise un trou de ver...', 169);

-- Séances (pour aujourd'hui et demain)
INSERT INTO seances (daty, heure, id_film, id_salle) VALUES 
-- Aujourd'hui
(CURRENT_DATE, '14:00:00', 1, 1),
(CURRENT_DATE, '17:00:00', 2, 2),
(CURRENT_DATE, '20:00:00', 3, 3),
-- Demain
(CURRENT_DATE + INTERVAL '1 day', '14:00:00', 4, 1),
(CURRENT_DATE + INTERVAL '1 day', '17:00:00', 5, 2),
(CURRENT_DATE + INTERVAL '1 day', '20:00:00', 1, 3);

-- Générer les places pour chaque salle
DO $$
DECLARE
    v_salle RECORD;
    v_rangee INTEGER;
    v_colonne INTEGER;
    v_code_place VARCHAR(10);
BEGIN
    FOR v_salle IN SELECT id_salle, nb_rangee, nb_colonne FROM salles LOOP
        FOR v_rangee IN 1..v_salle.nb_rangee LOOP
            FOR v_colonne IN 1..v_salle.nb_colonne LOOP
                v_code_place := CHR(64 + v_rangee) || v_colonne; -- A1, A2, B1, B2...
                INSERT INTO places (code_place, id_salle) 
                VALUES (v_code_place, v_salle.id_salle);
            END LOOP;
        END LOOP;
    END LOOP;
END $$;

-- Générer les billets pour chaque séance
DO $$
DECLARE
    v_seance RECORD;
    v_place RECORD;
    v_prix DECIMAL(10,2);
BEGIN
    FOR v_seance IN SELECT id_seance, id_salle FROM seances LOOP
        -- Prix différent selon l'heure (14h=15000, 17h=15000, 20h=18000)
        v_prix := 15000;
        
        FOR v_place IN SELECT id_place FROM places WHERE id_salle = v_seance.id_salle LOOP
            INSERT INTO billets (prix, id_place, id_seance) 
            VALUES (v_prix, v_place.id_place, v_seance.id_seance);
        END LOOP;
    END LOOP;
END $$;

-- Quelques achats de test
INSERT INTO achats (nom_acheteur, total, dt_achat) VALUES 
('Rakoto Jean', 45000, NOW() - INTERVAL '2 hours'),
('Rasoa Marie', 30000, NOW() - INTERVAL '1 hour'),
('Rabe Paul', 15000, NOW() - INTERVAL '30 minutes');

-- Associer des billets aux achats
-- Achat 1: 3 billets séance 1 (places A1, A2, A3)
INSERT INTO achat_billets (id_achat, id_billet)
SELECT 1, b.id_billet 
FROM billets b
JOIN places p ON b.id_place = p.id_place
WHERE b.id_seance = 1 AND p.code_place IN ('A1', 'A2', 'A3')
LIMIT 3;

-- Achat 2: 2 billets séance 2 (places B1, B2)
INSERT INTO achat_billets (id_achat, id_billet)
SELECT 2, b.id_billet 
FROM billets b
JOIN places p ON b.id_place = p.id_place
WHERE b.id_seance = 2 AND p.code_place IN ('B1', 'B2')
LIMIT 2;

-- Achat 3: 1 billet séance 3 (place C1)
INSERT INTO achat_billets (id_achat, id_billet)
SELECT 3, b.id_billet 
FROM billets b
JOIN places p ON b.id_place = p.id_place
WHERE b.id_seance = 3 AND p.code_place = 'C1'
LIMIT 1;
