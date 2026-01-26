-- =========================================
-- DONNÉES D'INITIALISATION - MODULE PUBLICITÉ
-- =========================================

-- Sociétés publicitaires
INSERT INTO societes (nom) VALUES 
('Vaniala'),
('Lewis'),
('CocaCola Madagascar'),
('Star Brasseries');

-- Configurations tarifaires
-- Vaniala : 200 000 Ar par diffusion
-- Lewis : 200 000 Ar par diffusion
INSERT INTO configurations (tarif, date_debut, date_fin, id_societe) VALUES 
(200000.00, '2024-01-01', NULL, (SELECT id_societe FROM societes WHERE nom = 'Vaniala')),
(200000.00, '2024-01-01', NULL, (SELECT id_societe FROM societes WHERE nom = 'Lewis'));

-- Contrats publicitaires (quotas mensuels)
-- Décembre 2025
INSERT INTO contrat_pubs (mois_diffusion, quota, id_societe) VALUES 
('2025-12-01', 20, (SELECT id_societe FROM societes WHERE nom = 'Vaniala')),
('2025-12-01', 10, (SELECT id_societe FROM societes WHERE nom = 'Lewis'));

-- Diffusions publicitaires
-- Vaniala : 2 diffusions en décembre 2025
-- Lewis : 1 diffusion en décembre 2025
INSERT INTO diffusion_pubs (date_diffusion, nombre_diffusions, id_seance, id_societe) VALUES 
('2025-12-16 14:00:00', 2, 3, (SELECT id_societe FROM societes WHERE nom = 'Vaniala')),
('2025-12-16 14:00:00', 1, 3, (SELECT id_societe FROM societes WHERE nom = 'Lewis'));

-- Paiements effectués par les sociétés
INSERT INTO paiements_pubs (montant, date_paiement, description, id_societe) VALUES
(1000000.00, '2025-12-15', 'Paiement 2', (SELECT id_societe FROM societes WHERE nom = 'Vaniala'));
