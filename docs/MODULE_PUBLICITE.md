# Module Publicité - NovaCine

## 📋 Vue d'ensemble

Module de gestion des diffusions publicitaires dans le cinéma NovaCine. Permet de :
- Gérer les contrats publicitaires avec les sociétés
- Enregistrer les diffusions de publicités lors des séances
- Calculer automatiquement le chiffre d'affaires publicitaire
- Surveiller les quotas de diffusion

## 🗂️ Structure

### Modèles JPA

- **`Societe`** : Entreprise diffusant des publicités
- **`Configuration`** : Tarif unitaire par diffusion (avec période de validité)
- **`ContratPub`** : Contrat mensuel avec quota de diffusions
- **`Diffusion`** : Enregistrement d'une diffusion lors d'une séance

### Relations

```
Societe (1) ----< (N) Configuration
Societe (1) ----< (N) ContratPub
Societe (1) ----< (N) Diffusion
Seance (1) ----< (N) Diffusion
```

## 🔌 API REST

### Obtenir le rapport mensuel

```bash
GET /publicite/api/rapport?annee=2026&mois=1
```

**Réponse JSON :**
```json
{
  "annee": 2026,
  "mois": 1,
  "totalCinema": 1120000.00,
  "societes": [
    {
      "societe": "CocaCola Madagascar",
      "nombreDiffusions": 7,
      "quota": 30,
      "chiffreAffaires": 350000.00
    }
  ]
}
```

### CA d'une séance

```bash
GET /publicite/api/ca/seance/{id}
```

### CA d'une société

```bash
GET /publicite/api/ca/societe/{id}?annee=2026&mois=1
```

### CA total du cinéma

```bash
GET /publicite/api/ca/cinema?annee=2026&mois=1
```

### Enregistrer une diffusion

```bash
POST /publicite/api/diffusion
Content-Type: application/json

{
  "idSeance": 1,
  "idSociete": 1,
  "dateDiffusion": "2026-01-15T19:00:00",
  "nombreDiffusions": 2
}
```

### Gestion des sociétés

```bash
# Lister toutes les sociétés
GET /publicite/api/societes

# Créer une société
POST /publicite/api/societe
Content-Type: application/json

{
  "nom": "Nouvelle Société"
}
```

## 📊 Interface Web

Accès au rapport visuel :
```
http://localhost:8080/publicite/rapport?annee=2026&mois=1
```

## 💡 Calcul du CA

**Formule :** `CA = Σ(tarif × nombre_diffusions)`

Le système :
1. Récupère toutes les diffusions de la période
2. Pour chaque diffusion, trouve le tarif actif à cette date
3. Multiplie `tarif × nombre_diffusions`
4. Somme tous les montants

## ⚠️ Gestion des quotas

Le service vérifie automatiquement les quotas avant d'enregistrer une diffusion :

```java
publiciteService.enregistrerDiffusion(seance, societe, dateDiffusion, nombreDiffusions);
// Lève IllegalStateException si quota dépassé
```

## 🗄️ Script SQL d'initialisation

Voir `docs/data_publicite.sql` pour des données de test.

## 📝 Exemples d'utilisation

### Dans un contrôleur

```java
@Autowired
private PubliciteService publiciteService;

// Calculer CA d'une séance
BigDecimal ca = publiciteService.calculerCASeance(seance);

// Calculer CA mensuel d'une société
BigDecimal ca = publiciteService.calculerCASociete(societe, 2026, 1);

// Obtenir rapport complet
Map<String, Object> rapport = publiciteService.getRapportMensuel(2026, 1);
```

### Dans une requête cURL

```bash
# Enregistrer une diffusion
curl -X POST http://localhost:8080/publicite/api/diffusion \
  -H "Content-Type: application/json" \
  -d '{
    "idSeance": 1,
    "idSociete": 1,
    "dateDiffusion": "2026-01-15T19:00:00",
    "nombreDiffusions": 2
  }'

# Obtenir le rapport
curl http://localhost:8080/publicite/api/rapport?annee=2026&mois=1
```

## 🔍 Requêtes personnalisées

Les repositories incluent des requêtes JPQL optimisées :

```java
// Compte les diffusions d'une société sur un mois
DiffusionRepository.countDiffusionsByMonth(societe, 2026, 1);

// Trouve le tarif actif à une date
configurationRepository.findActiveBySocieteAndDate(societe, date);

// Trouve le contrat actif pour un mois
contratPubRepository.findBySocieteAndMonth(societe, date);
```

## 🚀 Déploiement

Les tables sont créées automatiquement par JPA au démarrage.

Pour insérer les données de test :
```bash
psql -U user -d novacine -f docs/data_publicite.sql
```
