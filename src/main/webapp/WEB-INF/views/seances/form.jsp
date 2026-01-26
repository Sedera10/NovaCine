<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - ${empty seanceDTO.idSeance ? 'Nouvelle' : 'Modifier'} Séance</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-color: #0B1D3A;
            --secondary-color: #FFC107;
        }
        
        body {
            background-color: white;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-content {
            margin-left: 240px;
            min-height: 100vh;
            background-color: white;
        }
        
        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .form-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        .btn btn-outline-secondary {
            background-color: #e0a800;
        }
        
        .form-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(11, 29, 58, 0.15);
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 12px 30px;
            font-weight: 600;
        }
        .retour {
            background-color: #e0a800;
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
        }
        
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #0066cc;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }
        
        .info-box i {
            color: #0066cc;
        }
        
        .required-star {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="mb-2">
                            <i class="bi bi-calendar-plus me-2"></i>
                            ${isModification ? 'Modifier Séance' : 'Nouvelle Séance'}
                        </h1>
                        <p class="mb-0 text-muted">
                            ${isModification ? 'Modification de la séance #'.concat(seance.idSeance) : 'Programmation d\'une projection'}
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances${isModification ? '/'.concat(seance.idSeance) : ''}" class="btn btn-outline-secondary retour">
                        <i class="bi bi-arrow-left me-2"></i>Retour
                    </a>
                </div>
            </div>
            
            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Info Box -->
            <div class="info-box">
                <i class="bi bi-info-circle me-2"></i>
                <strong>Note:</strong> L'heure de fin sera automatiquement calculée en fonction de la durée du film (+ 15 minutes de nettoyage).
                Le système vérifie également les conflits d'horaires dans la même salle.
            </div>
            
            <!-- Formulaire -->
            <div class="form-card">
                <c:set var="formAction" value="${isModification ? pageContext.request.contextPath.concat('/seances/').concat(seance.idSeance).concat('/modifier') : pageContext.request.contextPath.concat('/seances/nouveau')}" />
                <form action="${formAction}" 
                      method="post" id="seanceForm">
                    
                    <!-- Section Film & Salle -->
                    <div class="form-section">
                        <h5><i class="bi bi-film me-2"></i>Film & Salle</h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="idFilm" class="form-label">
                                        Film <span class="required-star">*</span>
                                    </label>
                                    <select class="form-select" id="idFilm" name="idFilm" required 
                                            ${isModification ? 'disabled' : ''}>
                                        <option value="">-- Sélectionner un film --</option>
                                        <c:forEach var="film" items="${films}">
                                            <option value="${film.idFilm}" 
                                                    data-duree="${film.duree}"
                                                    ${isModification ? (seance.film.idFilm == film.idFilm ? 'selected' : '') : ''}>
                                                ${film.titre} (${film.duree} min)
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${isModification}">
                                        <input type="hidden" name="idFilm" value="${seance.film.idFilm}">
                                        <small class="text-muted">Le film ne peut pas être modifié après création</small>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="idSalle" class="form-label">
                                        Salle <span class="required-star">*</span>
                                    </label>
                                    <select class="form-select" id="idSalle" name="idSalle" required
                                            ${isModification ? 'disabled' : ''}>
                                        <option value="">-- Sélectionner une salle --</option>
                                        <c:forEach var="salle" items="${salles}">
                                            <option value="${salle.idSalle}"
                                                    ${isModification ? (seance.salle.idSalle == salle.idSalle ? 'selected' : '') : ''}>
                                                ${salle.nom} (${salle.capacite} places)
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${isModification}">
                                        <input type="hidden" name="idSalle" value="${seance.salle.idSalle}">
                                        <small class="text-muted">La salle ne peut pas être modifiée après création</small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section Date & Horaire -->
                    <div class="form-section">
                        <h5><i class="bi bi-calendar-check me-2"></i>Date & Horaire</h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dtSeance" class="form-label">
                                        Date de la séance <span class="required-star">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="dtSeance" name="dtSeance" 
                                           value="${isModification ? seance.dateSeance : defaultDate}" required>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="heureDebut" class="form-label">
                                        Heure de début <span class="required-star">*</span>
                                    </label>
                                    <input type="time" class="form-control" id="heureDebut" name="heureDebut" 
                                           value="${isModification ? seance.heureSeance : defaultTime}" required>
                                    <small class="text-muted">Format 24h (ex: 14:30)</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-info" id="heureFinPreview" style="display: none;">
                            <i class="bi bi-clock me-2"></i>
                            <strong>Heure de fin calculée:</strong> <span id="heureFinText"></span>
                        </div>
                    </div>
                    
                    <!-- Section Prix par Type de Place -->
                    <div class="form-section">
                        <h5><i class="bi bi-currency-exchange me-2"></i>Configuration des Prix</h5>
                        
                        <!-- Choix du mode de tarification -->
                        <div class="mb-4">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="modeTarif" 
                                       id="modePrixBase" value="base" ${not isModification ? 'checked' : ''} onchange="toggleTarifMode()">
                                <label class="form-check-label fw-bold" for="modePrixBase">
                                    <i class="bi bi-tag me-1"></i>Prix de base (par type de place)
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="modeTarif" 
                                       id="modeSpecifique" value="specifique" ${isModification ? 'checked' : ''} onchange="toggleTarifMode()">
                                <label class="form-check-label fw-bold" for="modeSpecifique">
                                    <i class="bi bi-gear me-1"></i>Tarification spécifique (par type de place ET type de client)
                                </label>
                            </div>
                        </div>
                        
                        <!-- Section Prix de Base -->
                        <div id="sectionPrixBase">
                            <p class="text-muted mb-3">Définissez le prix pour chaque type de place pour cette séance</p>
                            
                            <div class="row">
                                <c:forEach var="typePlace" items="${typePlaces}">
                                    <div class="col-md-4 mb-3">
                                        <label for="prix_${typePlace.id}" class="form-label">
                                            <i class="bi bi-ticket-perforated me-1"></i>${typePlace.nom}
                                        </label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" 
                                                   id="prix_${typePlace.id}" 
                                                   name="prix_${typePlace.id}" 
                                                   value="${prixParTypePlace[typePlace.id]}"
                                                   min="0" step="100" placeholder="0">
                                            <span class="input-group-text">Ar</span>
                                        </div>
                                        <small class="text-muted">Prix de base pour ${typePlace.nom}</small>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <c:if test="${empty typePlaces}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                    Aucun type de place n'est configuré. 
                                    <a href="${pageContext.request.contextPath}/config/types-places">Configurer les types de places</a>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Section Tarifs Spécifiques -->
                        <div id="sectionTarifsSpecifiques" style="display: none;">
                            <p class="text-muted mb-3">
                                <i class="bi bi-info-circle me-1"></i>
                                Définissez un tarif pour chaque combinaison type de place / type de client.
                                <br><small>Un tarif peut être <strong>fixe</strong> ou <strong>dépendant</strong> d'un autre type de client (ex: Enfant = Adulte - 50%).</small>
                            </p>
                            
                            <c:if test="${not empty typePlaces and not empty typeClients}">
                                <!-- Configuration par type de place -->
                                <c:forEach var="typePlace" items="${typePlaces}" varStatus="placeStatus">
                                    <div class="card mb-4">
                                        <div class="card-header bg-dark text-white">
                                            <i class="bi bi-ticket-perforated me-2"></i>
                                            <strong>${typePlace.nom}</strong>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <c:forEach var="typeClient" items="${typeClients}" varStatus="clientStatus">
                                                    <div class="col-md-6 col-lg-4 mb-3">
                                                        <div class="border rounded p-3 h-100 tarif-card" 
                                                             id="tarifCard_${typePlace.id}_${typeClient.id}">
                                                            <label class="form-label fw-bold">
                                                                <i class="bi bi-person me-1"></i>${typeClient.nom}
                                                            </label>
                                                            
                                                            <!-- Choix: Fixe ou Dépendant -->
                                                            <div class="mb-2">
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input tarif-mode-radio" type="radio" 
                                                                           name="tarifMode_${typePlace.id}_${typeClient.id}" 
                                                                           id="tarifFixe_${typePlace.id}_${typeClient.id}"
                                                                           value="fixe" checked
                                                                           onchange="toggleTarifType(${typePlace.id}, ${typeClient.id})">
                                                                    <label class="form-check-label small" for="tarifFixe_${typePlace.id}_${typeClient.id}">
                                                                        Prix fixe
                                                                    </label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input tarif-mode-radio" type="radio" 
                                                                           name="tarifMode_${typePlace.id}_${typeClient.id}" 
                                                                           id="tarifDep_${typePlace.id}_${typeClient.id}"
                                                                           value="dependant"
                                                                           onchange="toggleTarifType(${typePlace.id}, ${typeClient.id})">
                                                                    <label class="form-check-label small" for="tarifDep_${typePlace.id}_${typeClient.id}">
                                                                        Dépendant
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Section Prix Fixe -->
                                                            <div id="fixeSection_${typePlace.id}_${typeClient.id}">
                                                                <div class="input-group input-group-sm">
                                                                    <input type="number" class="form-control tarif-input" 
                                                                           name="tarif_${typePlace.id}_${typeClient.id}"
                                                                           id="tarif_${typePlace.id}_${typeClient.id}"
                                                                           value="${tarifMap[typePlace.id][typeClient.idTypeClient]}"
                                                                           min="0" step="100" placeholder="Prix en Ar">
                                                                    <span class="input-group-text">Ar</span>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Section Dépendant (caché par défaut) -->
                                                            <div id="depSection_${typePlace.id}_${typeClient.id}" style="display: none;">
                                                                <div class="mb-2">
                                                                    <label class="form-label small">Référence:</label>
                                                                    <select class="form-select form-select-sm"
                                                                            name="tarifRef_${typePlace.id}_${typeClient.id}"
                                                                            id="tarifRef_${typePlace.id}_${typeClient.id}"
                                                                            onchange="calculateDependentPrice(${typePlace.id}, ${typeClient.id})">
                                                                        <option value="">-- Type client de référence --</option>
                                                                        <c:forEach var="refClient" items="${typeClients}">
                                                                            <c:if test="${refClient.id != typeClient.id}">
                                                                                <option value="${refClient.id}">${refClient.nom}</option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                                <div class="input-group input-group-sm">
                                                                    <input type="number" class="form-control" 
                                                                           name="tarifPct_${typePlace.id}_${typeClient.id}"
                                                                           id="tarifPct_${typePlace.id}_${typeClient.id}"
                                                                           min="-100" max="100" step="1" placeholder="Ex: -50"
                                                                           onchange="calculateDependentPrice(${typePlace.id}, ${typeClient.id})">
                                                                    <span class="input-group-text">%</span>
                                                                </div>
                                                                <small class="text-muted">Négatif = réduction, Positif = majoration</small>
                                                                <div class="mt-2">
                                                                    <span class="badge bg-info" id="calculatedPrice_${typePlace.id}_${typeClient.id}">
                                                                        Prix calculé: --
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                
                                <!-- Remplissage rapide amélioré -->
                                <div class="mt-3 p-3 bg-light rounded border">
                                    <h6><i class="bi bi-magic me-1"></i>Remplissage rapide d'une ligne</h6>
                                    <p class="small text-muted mb-3">
                                        Définissez rapidement les tarifs pour un type de place : un prix de référence et les autres en pourcentage.
                                    </p>
                                    <div class="row align-items-end">
                                        <div class="col-md-3 mb-2">
                                            <label class="form-label small">Type de place</label>
                                            <select class="form-select form-select-sm" id="quickFillPlace">
                                                <option value="">Sélectionner...</option>
                                                <c:forEach var="typePlace" items="${typePlaces}">
                                                    <option value="${typePlace.id}">${typePlace.nom}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <label class="form-label small">Type client de référence</label>
                                            <select class="form-select form-select-sm" id="quickFillRefClient">
                                                <option value="">Sélectionner...</option>
                                                <c:forEach var="typeClient" items="${typeClients}">
                                                    <option value="${typeClient.id}">${typeClient.nom}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <label class="form-label small">Prix de référence</label>
                                            <div class="input-group input-group-sm">
                                                <input type="number" class="form-control" id="quickFillPrix" 
                                                       min="0" step="100" placeholder="Ex: 20000">
                                                <span class="input-group-text">Ar</span>
                                            </div>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <button type="button" class="btn btn-sm btn-outline-primary w-100" onclick="applyQuickFill()">
                                                <i class="bi bi-check2-all me-1"></i>Appliquer
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Pourcentages pour les autres types -->
                                    <div class="mt-3 pt-3 border-top" id="quickFillOthers" style="display: none;">
                                        <label class="form-label small fw-bold">Pourcentages pour les autres types de clients:</label>
                                        <div class="row" id="quickFillOthersContainer">
                                            <!-- Rempli dynamiquement par JS -->
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${empty typePlaces or empty typeClients}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                    Configuration incomplète. Veuillez d'abord configurer :
                                    <ul class="mb-0 mt-2">
                                        <c:if test="${empty typePlaces}">
                                            <li><a href="${pageContext.request.contextPath}/config/types-places">Les types de places</a></li>
                                        </c:if>
                                        <c:if test="${empty typeClients}">
                                            <li><a href="${pageContext.request.contextPath}/config/types-clients">Les types de clients</a></li>
                                        </c:if>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                    
                    <!-- Boutons d'action -->
                    <div class="d-flex gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/seances${isModification ? '/'.concat(seance.idSeance) : ''}" class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="bi bi-check-circle me-2"></i>
                            ${isModification ? 'Enregistrer les modifications' : 'Créer la séance'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ========== Données des types de clients pour JS ==========
        const typeClients = [
            <c:forEach var="tc" items="${typeClients}" varStatus="st">
                { id: ${tc.id}, nom: '${tc.nom}' }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        
        // ========== Gestion du mode de tarification ==========
        function toggleTarifMode() {
            const modeBase = document.getElementById('modePrixBase').checked;
            const sectionBase = document.getElementById('sectionPrixBase');
            const sectionSpecifique = document.getElementById('sectionTarifsSpecifiques');
            
            if (modeBase) {
                sectionBase.style.display = 'block';
                sectionSpecifique.style.display = 'none';
                // Désactiver les inputs spécifiques
                document.querySelectorAll('#sectionTarifsSpecifiques input:not([type="radio"])').forEach(i => i.disabled = true);
                document.querySelectorAll('#sectionTarifsSpecifiques select').forEach(i => i.disabled = true);
                document.querySelectorAll('#sectionPrixBase input').forEach(i => i.disabled = false);
            } else {
                sectionBase.style.display = 'none';
                sectionSpecifique.style.display = 'block';
                // Activer les inputs spécifiques selon leur mode
                document.querySelectorAll('#sectionTarifsSpecifiques input:not([type="radio"])').forEach(i => i.disabled = false);
                document.querySelectorAll('#sectionTarifsSpecifiques select').forEach(i => i.disabled = false);
                document.querySelectorAll('#sectionPrixBase input').forEach(i => i.disabled = true);
            }
        }
        
        // ========== Basculer entre prix fixe et dépendant ==========
        function toggleTarifType(placeId, clientId) {
            const isFixe = document.getElementById('tarifFixe_' + placeId + '_' + clientId).checked;
            const fixeSection = document.getElementById('fixeSection_' + placeId + '_' + clientId);
            const depSection = document.getElementById('depSection_' + placeId + '_' + clientId);
            const tarifCard = document.getElementById('tarifCard_' + placeId + '_' + clientId);
            
            if (isFixe) {
                fixeSection.style.display = 'block';
                depSection.style.display = 'none';
                tarifCard.classList.remove('border-warning');
                tarifCard.classList.add('border');
            } else {
                fixeSection.style.display = 'none';
                depSection.style.display = 'block';
                tarifCard.classList.remove('border');
                tarifCard.classList.add('border-warning');
            }
        }
        
        // ========== Calculer le prix dépendant ==========
        function calculateDependentPrice(placeId, clientId) {
            const refClientId = document.getElementById('tarifRef_' + placeId + '_' + clientId).value;
            const pctInput = document.getElementById('tarifPct_' + placeId + '_' + clientId);
            const pct = parseFloat(pctInput.value) || 0;
            const badge = document.getElementById('calculatedPrice_' + placeId + '_' + clientId);
            const tarifInput = document.getElementById('tarif_' + placeId + '_' + clientId);
            
            if (!refClientId) {
                badge.textContent = 'Prix calculé: --';
                badge.classList.remove('bg-success');
                badge.classList.add('bg-info');
                return;
            }
            
            // Récupérer le prix de référence
            const refInput = document.getElementById('tarif_' + placeId + '_' + refClientId);
            const refPrix = parseFloat(refInput?.value) || 0;
            
            if (refPrix > 0) {
                const calculatedPrix = Math.round(refPrix * (1 + pct / 100));
                badge.textContent = 'Prix calculé: ' + calculatedPrix.toLocaleString() + ' Ar';
                badge.classList.remove('bg-info');
                badge.classList.add('bg-success');
                // Mettre à jour le champ caché
                tarifInput.value = calculatedPrix;
            } else {
                badge.textContent = 'Référence sans prix';
                badge.classList.remove('bg-success');
                badge.classList.add('bg-info');
            }
        }
        
        // ========== Recalculer tous les prix dépendants ==========
        function recalculateAllDependentPrices() {
            document.querySelectorAll('input[id^="tarifDep_"]').forEach(radio => {
                if (radio.checked) {
                    const parts = radio.id.split('_');
                    const placeId = parts[1];
                    const clientId = parts[2];
                    calculateDependentPrice(placeId, clientId);
                }
            });
        }
        
        // ========== Remplissage rapide amélioré ==========
        document.getElementById('quickFillRefClient')?.addEventListener('change', function() {
            const refClientId = this.value;
            const container = document.getElementById('quickFillOthersContainer');
            const section = document.getElementById('quickFillOthers');
            
            if (!refClientId) {
                section.style.display = 'none';
                return;
            }
            
            // Générer les inputs pour les autres types de clients
            container.innerHTML = '';
            typeClients.forEach(tc => {
                if (tc.id != refClientId) {
                    const col = document.createElement('div');
                    col.className = 'col-md-4 mb-2';
                    col.innerHTML = `
                        <label class="form-label small">${tc.nom}</label>
                        <div class="input-group input-group-sm">
                            <input type="number" class="form-control quickFillPct" 
                                   data-client-id="${tc.id}"
                                   min="-100" max="100" step="1" placeholder="Ex: -50" value="0">
                            <span class="input-group-text">%</span>
                        </div>
                    `;
                    container.appendChild(col);
                }
            });
            
            section.style.display = 'block';
        });
        
        function applyQuickFill() {
            const placeId = document.getElementById('quickFillPlace').value;
            const refClientId = document.getElementById('quickFillRefClient').value;
            const refPrix = parseFloat(document.getElementById('quickFillPrix').value) || 0;
            
            if (!placeId) {
                alert('Veuillez sélectionner un type de place');
                return;
            }
            if (!refClientId) {
                alert('Veuillez sélectionner un type de client de référence');
                return;
            }
            if (refPrix <= 0) {
                alert('Veuillez entrer un prix de référence valide');
                return;
            }
            
            // Appliquer le prix de référence
            const refTarifInput = document.getElementById('tarif_' + placeId + '_' + refClientId);
            if (refTarifInput) {
                refTarifInput.value = refPrix;
                // S'assurer que c'est en mode fixe
                const fixeRadio = document.getElementById('tarifFixe_' + placeId + '_' + refClientId);
                if (fixeRadio) fixeRadio.checked = true;
                toggleTarifType(placeId, refClientId);
            }
            
            // Appliquer les pourcentages aux autres types de clients
            document.querySelectorAll('.quickFillPct').forEach(input => {
                const clientId = input.dataset.clientId;
                const pct = parseFloat(input.value) || 0;
                const calculatedPrix = Math.round(refPrix * (1 + pct / 100));
                
                // Mettre à jour le tarif
                const tarifInput = document.getElementById('tarif_' + placeId + '_' + clientId);
                if (tarifInput) {
                    tarifInput.value = calculatedPrix;
                }
                
                // Si pourcentage != 0, configurer comme dépendant
                if (pct !== 0) {
                    const depRadio = document.getElementById('tarifDep_' + placeId + '_' + clientId);
                    if (depRadio) {
                        depRadio.checked = true;
                        toggleTarifType(placeId, clientId);
                        
                        // Configurer la référence et le pourcentage
                        const refSelect = document.getElementById('tarifRef_' + placeId + '_' + clientId);
                        const pctInput = document.getElementById('tarifPct_' + placeId + '_' + clientId);
                        if (refSelect) refSelect.value = refClientId;
                        if (pctInput) pctInput.value = pct;
                        
                        calculateDependentPrice(placeId, clientId);
                    }
                } else {
                    // Prix fixe identique
                    const fixeRadio = document.getElementById('tarifFixe_' + placeId + '_' + clientId);
                    if (fixeRadio) {
                        fixeRadio.checked = true;
                        toggleTarifType(placeId, clientId);
                    }
                }
            });
            
            alert('Tarifs appliqués avec succès pour ce type de place!');
        }
        
        // ========== Écouter les changements de prix de référence ==========
        document.querySelectorAll('.tarif-input').forEach(input => {
            input.addEventListener('change', recalculateAllDependentPrices);
            input.addEventListener('input', recalculateAllDependentPrices);
        });
        
        // ========== Calculer l'heure de fin en temps réel ==========
        const filmSelect = document.getElementById('idFilm');
        const heureDebutInput = document.getElementById('heureDebut');
        const heureFinPreview = document.getElementById('heureFinPreview');
        const heureFinText = document.getElementById('heureFinText');
        
        function calculateHeureFin() {
            const selectedFilm = filmSelect.options[filmSelect.selectedIndex];
            const duree = parseInt(selectedFilm.dataset.duree);
            const heureDebut = heureDebutInput.value;
            
            if (duree && heureDebut) {
                const [hours, minutes] = heureDebut.split(':').map(Number);
                const totalMinutes = hours * 60 + minutes + duree + 15;
                
                const heureFinHours = Math.floor(totalMinutes / 60) % 24;
                const heureFinMinutes = totalMinutes % 60;
                
                const heureFinFormatted = 
                    String(heureFinHours).padStart(2, '0') + ':' + 
                    String(heureFinMinutes).padStart(2, '0');
                
                heureFinText.textContent = heureFinFormatted;
                heureFinPreview.style.display = 'block';
            } else {
                heureFinPreview.style.display = 'none';
            }
        }
        
        filmSelect.addEventListener('change', calculateHeureFin);
        heureDebutInput.addEventListener('input', calculateHeureFin);
        
        <c:if test="${not empty seanceDTO.idSeance}">
            calculateHeureFin();
        </c:if>
        
        // ========== Validation du formulaire ==========
        document.getElementById('seanceForm').addEventListener('submit', function(e) {
            const dtSeance = new Date(document.getElementById('dtSeance').value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
        
            
            const modeBase = document.getElementById('modePrixBase').checked;
            if (modeBase) {
                let hasPrix = false;
                document.querySelectorAll('#sectionPrixBase input[type="number"]').forEach(input => {
                    if (input.value && parseFloat(input.value) > 0) hasPrix = true;
                });
                if (!hasPrix) {
                    alert('Veuillez définir au moins un prix de base');
                    e.preventDefault();
                    return false;
                }
            } else {
                let hasTarif = false;
                document.querySelectorAll('.tarif-input').forEach(input => {
                    if (input.value && parseFloat(input.value) > 0) hasTarif = true;
                });
                if (!hasTarif) {
                    alert('Veuillez définir au moins un tarif spécifique');
                    e.preventDefault();
                    return false;
                }
            }
        });
        
        // ========== Initialisation ==========
        document.addEventListener('DOMContentLoaded', function() {
            toggleTarifMode();
        });
    </script>
</body>
</html>
