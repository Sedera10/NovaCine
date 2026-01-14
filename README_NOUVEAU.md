# 🎬 NovaCine - Système de Gestion de Cinéma

## 📋 Description

NovaCine est une application web de gestion de cinéma développée avec Spring Boot, permettant de gérer les séances, les films, les salles, et les ventes de billets.

## ✨ Fonctionnalités

### 🎫 Gestion des Séances
- Liste des séances avec filtres (film, salle, date)
- Affichage en blocs avec poster, titre, date, heure et salle
- Création/modification/suppression de séances
- Génération automatique des billets lors de la création

### 🎬 Gestion des Films
- CRUD complet des films
- Informations: titre, date de sortie, synopsis, durée

### 🏛️ Gestion des Salles
- CRUD complet des salles
- Configuration: nom, capacité, rangées, colonnes
- Génération automatique des places

### 💰 Vente de Billets
- **Plan de salle interactif**
  - Visualisation des places disponibles/occupées
  - Sélection multiple de places
  - Code couleur: Vert (disponible), Rouge (occupé), Jaune (sélectionné)
- **Processus d'achat**
  - Saisie du nom de l'acheteur
  - Calcul automatique du total
  - Page de confirmation avec récapitulatif

### 📊 Statistiques et Ventes
- **Par séance**:
  - Capacité totale
  - Places vendues / disponibles
  - Taux de remplissage
  - Total des ventes
  - Liste détaillée des achats
- **Globales**:
  - Toutes les ventes
  - Top des films

## 🗂️ Structure du Projet

```
src/main/java/com/cinema/
├── models/          # Entités JPA
│   ├── Role.java
│   ├── User.java
│   ├── Film.java
│   ├── Salle.java
│   ├── Place.java
│   ├── Seance.java
│   ├── Billet.java
│   └── Achat.java
│
├── repositories/    # Repositories Spring Data JPA
│   ├── RoleRepository.java
│   ├── UserRepository.java
│   ├── FilmRepository.java
│   ├── SalleRepository.java
│   ├── PlaceRepository.java
│   ├── SeanceRepository.java
│   ├── BilletRepository.java
│   └── AchatRepository.java
│
├── services/        # Couche métier
│   ├── FilmService.java
│   ├── SalleService.java
│   ├── PlaceService.java
│   ├── SeanceService.java
│   ├── BilletService.java
│   └── AchatService.java
│
└── controllers/     # Contrôleurs MVC
    ├── HomeController.java
    ├── SeanceController.java
    ├── FilmController.java
    ├── SalleController.java
    └── AchatController.java

src/main/webapp/WEB-INF/views/
├── seances/
│   ├── liste.jsp    # Page d'accueil avec liste des séances
│   ├── detail.jsp
│   └── form.jsp
├── achats/
│   ├── achat.jsp           # Page d'achat avec plan de salle
│   ├── confirmation.jsp     # Confirmation d'achat
│   └── ventes-seance.jsp   # Statistiques par séance
└── includes/
    ├── header.jsp
    ├── footer.jsp
    └── sidebar.jsp

docs/
├── Tables.sql       # Schéma de base de données
└── views.sql        # Vues SQL pour statistiques
```

## 🗄️ Base de Données

### Tables Principales
- **roles** - Rôles utilisateurs
- **users** - Utilisateurs/employés
- **films** - Films
- **salles** - Salles de cinéma
- **places** - Places dans les salles
- **seances** - Séances de films
- **billets** - Billets pour les séances
- **achats** - Achats de billets
- **achat_billets** - Table de liaison Many-to-Many

### Vues SQL
- `v_seances_stats` - Statistiques par séance
- `v_ventes_par_seance` - Détail des ventes
- `v_places_disponibles` - État des places
- `v_statistiques_globales` - Stats globales
- `v_top_films` - Top films par ventes

## 🚀 Installation

1. **Cloner le projet**
```bash
git clone [url-du-repo]
cd NovaCine
```

2. **Configuration de la base de données**
- Créer une base PostgreSQL
- Exécuter `docs/Tables.sql`
- Exécuter `docs/views.sql`
- Configurer `src/main/resources/application.properties`

3. **Lancer l'application**
```bash
./mvnw spring-boot:run
```

4. **Accéder à l'application**
```
http://localhost:8080
```

## 🎯 Scénarios d'Utilisation

### Créer une séance
1. Sidebar → "➕ Nouvelle Séance"
2. Sélectionner film, salle, date, heure, prix
3. Les billets sont générés automatiquement

### Vendre des billets
1. Page d'accueil → Cliquer "Achat Billet" sur une séance
2. Cliquer sur les places vertes disponibles
3. Saisir le nom de l'acheteur
4. Confirmer l'achat
5. Page de confirmation avec récapitulatif

### Consulter les ventes
1. Page d'accueil → Cliquer "Ventes" sur une séance
2. Voir les statistiques (capacité, vendus, disponibles, total)
3. Liste détaillée des achats

## 🛠️ Technologies

- **Backend**: Spring Boot 3.x, Spring Data JPA
- **Frontend**: JSP, JSTL, JavaScript/CSS
- **Base de données**: PostgreSQL
- **Build**: Maven

## 📝 Notes

- Les places sont générées automatiquement lors de la création d'une salle
- Les billets sont générés automatiquement lors de la création d'une séance
- Le calcul du total des achats est automatique
- Les statistiques utilisent des vues SQL pour optimiser les performances

## 👥 Auteurs

Développé pour le projet NovaCine - ITU S5

## 📄 Licence

Ce projet est sous licence MIT.
