#  NovaCine - Système de Gestion de Cinéma

##  Description du Projet
Application web complète de gestion de salle de cinéma développée avec **Spring Boot** et **JSP**.  
Ce système permet la gestion intégrale d'un cinéma : des utilisateurs aux statistiques, en passant par les réservations et les paiements.

---

## Charte Graphique
- **Couleur Principale** : `#0B1D3A` (Bleu nuit)
- **Couleur Secondaire** : `#FFC107` (Jaune)
- **Fond** : `#FFFFFF` (Blanc)

---

## Technologies Utilisées
- **Backend** : Spring Boot 4.0.1, Spring Data JPA
- **Frontend** : JSP, Bootstrap 5, Bootstrap Icons
- **Base de données** : PostgreSQL
- **Build** : Maven
- **Serveur** : Tomcat Embarqué

=====================================
=====================================

## Fonctionnalités Principales

### 1. 👥 Gestion des Utilisateurs
#### Clients
- Inscription et authentification
- Profil utilisateur (informations personnelles)
- Historique des réservations
- Favoris et préférences

#### Employés (Users)
- **Caissier** : Vente de billets au guichet, gestion des encaissements
- **Manager** : Gestion des séances, programmation, rapports
- **Admin** : Gestion complète du système, utilisateurs, paramètres

#### Système de Rôles
- Gestion des permissions par rôle
- Accès sécurisé selon le profil
- Authentification et autorisation

---

### 2. 🏛️ Gestion des Salles
- Création et configuration des salles
  - Capacité totale
  - Type de salle (standard, VIP, 3D, IMAX)
  - Disposition des sièges (plan interactif)
- Numérotation et catégorisation des places
- État en temps réel (disponible, occupé, réservé, hors service)
- Maintenance et indisponibilité

---

### 3. 🎥 Gestion des Films et Projections
#### Films
- Catalogue complet de films
  - Titre, synopsis, durée
  - Genre, classification (tout public, +13, +18)
  - Réalisateur, acteurs principaux
  - Affiche, bande-annonce (lien YouTube)
  - Date de sortie
- Mise à jour et archivage

#### Séances/Projections
- Programmation des séances
  - Date et heure
  - Film associé
  - Salle assignée
  - Tarif appliqué
- Gestion des horaires
- Planning hebdomadaire/mensuel

---

### 4. 🎫 Gestion des Billets et Réservations
#### Vente de Billets
- Multi-canal : guichet, web, mobile
- Réservation en ligne avec paiement sécurisé
- Choix interactif des sièges (plan de salle)

#### Tarification Flexible
- **Tarifs standards** : adulte, enfant
- **Tarifs spéciaux** : étudiant, senior, VIP
- **Promotions** : horaires creuses, jours spéciaux
- **Packs** : famille, duo, groupe

#### Gestion des Réservations
- Confirmation instantanée
- Génération de billets électroniques
  - QR Code / Code-barres
  - PDF téléchargeable
- Annulation et remboursement
- Politique de remboursement configurable

---

### 5. 🍿 Gestion des Concessions (Snacks & Boissons)
- Catalogue de produits
  - Popcorn (S, M, L, XL)
  - Boissons (sodas, jus, eau)
  - Confiseries et snacks
- Vente combinée avec billets (combos)
- Gestion du stock
- Alertes de réapprovisionnement
- Tarification et promotions

---

### 6. 💳 Système de Paiement
- Intégration multiple
  - Carte bancaire (Visa, Mastercard)
  - Mobile Money (Orange Money, MVola, Airtel Money)
  - Espèces (guichet)
- Sécurité des transactions
- Historique des paiements
- Génération de factures électroniques
- Remboursements automatisés

---

### 7. 🎁 Programme de Fidélité
- Système de points
  - Accumulation par achat
  - Conversion en réductions
- Cartes de fidélité (physiques/virtuelles)
- Niveaux d'adhésion (Bronze, Silver, Gold, Platinum)
- Avantages exclusifs
  - Réservations prioritaires
  - Invitations avant-premières
  - Réductions personnalisées

---

### 8. 📧 Notifications et Communications
#### Notifications Automatiques
- Email de confirmation de réservation
- SMS/Email de rappel (24h avant séance)
- Notification de changement/annulation

#### Communications Marketing
- Newsletter hebdomadaire
- Promotions et offres spéciales
- Annonces nouveaux films
- Invitations événements spéciaux

---

### 9. 📊 Statistiques et Rapports
#### Analyses de Performance
- **Films**
  - Films les plus vus
  - Revenus par film
  - Tendances par genre
- **Salles**
  - Taux de remplissage
  - Occupation moyenne
  - Salles les plus rentables
- **Revenus**
  - Chiffre d'affaires par période
  - Répartition (billets vs concessions)
  - Évolution mensuelle/annuelle
- **Fréquentation**
  - Heures de pointe
  - Jours les plus fréquentés
  - Profil des clients

#### Rapports de Gestion
- Rapports journaliers (recettes, fréquentation)
- Rapports mensuels (synthèse)
- Rapports financiers (comptabilité)
- Export Excel/PDF

---

### 10. 📱 Dashboard Temps Réel
- Vue d'ensemble instantanée
  - Séances en cours
  - Taux d'occupation actuel
  - Ventes du jour
- Alertes et notifications
  - Salle complète
  - Incidents techniques
  - Stocks faibles
- Monitoring système
- Statistiques live

---

## 📁 Structure du Projet
```
NovaCine/
├── src/main/
│   ├── java/com/cinema/
│   │   ├── controllers/      # Contrôleurs Spring MVC
│   │   ├── models/           # Entités JPA
│   │   ├── repositories/     # Repositories Spring Data
│   │   ├── services/         # Logique métier
│   │   └── NovaCine/         # Application principale
│   ├── resources/
│   │   ├── static/           # Fichiers statiques (CSS, JS, images)
│   │   └── application.properties
│   └── webapp/
│       └── WEB-INF/views/    # Pages JSP
└── pom.xml
```

---

## 🛠️ Installation et Démarrage

### Prérequis
- Java 17 ou supérieur
- Maven 3.8+
- PostgreSQL 12+

### Configuration Base de Données
1. Créer une base de données PostgreSQL :
```sql
CREATE DATABASE novacine;
```

2. Configurer `application.properties` :
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/novacine
spring.datasource.username=votre_user
spring.datasource.password=votre_password
```

### Lancement
```bash
# Compiler le projet
mvn clean install

# Démarrer l'application
mvn spring-boot:run
```

Accéder à l'application : `http://localhost:8080`

---

## 👨‍💻 Auteurs
Projet développé dans le cadre du cursus à l'**ITU (Institut de Technologie Universitaire)**  
Semestre 5 - Baovola

---

## 📝 Licence
Ce projet est développé à des fins éducatives.

---

## 🎯 Roadmap Future
- [ ] Application mobile native (Android/iOS)
- [ ] API REST pour intégrations tierces
- [ ] Système de recommandations IA
- [ ] Multi-cinéma (réseau de salles)
- [ ] Intégration réseaux sociaux
- [ ] Live streaming événements spéciaux