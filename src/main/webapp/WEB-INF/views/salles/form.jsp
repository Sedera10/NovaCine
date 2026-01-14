<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${action == 'edit' ? 'Modifier' : 'Nouvelle'} Salle - NovaCine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
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
            margin-top: 20px;
            margin-left: 240px;
            min-height: 100vh;
            background-color: white;
        }

        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            margin: 0;
        }

        .form-container {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .form-label {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(11, 29, 58, 0.1);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-weight: bold;
        }

        .btn-primary:hover {
            background-color: #162d52;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-weight: bold;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .info-box {
            background-color: #e7f3ff;
            border-left: 3px solid var(--primary-color);
            padding: 0.8rem;
            margin-bottom: 1.2rem;
            border-radius: 4px;
        }

        .info-box i {
            color: var(--primary-color);
        }

        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="page-header">
                <h1 class="page-title">
                    <i class="bi bi-door-open"></i> 
                    ${action == 'edit' ? 'Modifier la Salle' : 'Nouvelle Salle'}
                </h1>
            </div>

            <!-- Formulaire -->
            <div class="form-container">
                <c:if test="${action != 'edit'}">
                    <div class="info-box">
                        <i class="bi bi-info-circle"></i>
                        <strong>Information:</strong> Les sièges seront générés automatiquement lors de la création de la salle.
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/salles/nouveau">
                    <input type="hidden" name="action" value="${action}">
                    
                    <c:if test="${action == 'edit'}">
                        <input type="hidden" name="idSalle" value="${salle.idSalle}">
                    </c:if>

                    <div class="row">
                        <!-- Nom de la salle -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label">
                                <i class="bi bi-door-closed"></i> Nom de la Salle <span class="required">*</span>
                            </label>
                            <input type="text" class="form-control" name="nom" 
                                   value="${salle.nom}" required 
                                   placeholder="Ex: Salle Premium 1">
                        </div>

                        <!-- Type de salle -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label">
                                <i class="bi bi-tag"></i> Type de Salle 
                            </label>
                            <select class="form-select" name="typeSalle.idTypeSalle">
                                <option value="">-- Sélectionnez un type --</option>
                                
                            </select>
                        </div>

                        <c:choose>
                            <c:when test="${action == 'edit'}">
                                <!-- En mode édition: nb_rangees et nb_colonnes en lecture seule -->
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-grid-3x3"></i> Nombre de Rangées
                                    </label>
                                    <input type="number" class="form-control" 
                                           value="${salle.nbRangees}" disabled>
                                    <small class="text-muted">Non modifiable après création</small>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-grid-3x3"></i> Nombre de Colonnes
                                    </label>
                                    <input type="number" class="form-control" 
                                           value="${salle.nbColonnes}" disabled>
                                    <small class="text-muted">Non modifiable après création</small>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-people-fill"></i> Capacité Totale
                                    </label>
                                    <input type="number" class="form-control" 
                                           value="${salle.capaciteTotale}" disabled>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- En mode création: champs modifiables -->
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-grid-3x3"></i> Nombre de Rangées
                                    </label>
                                    <input type="number" class="form-control" name="nbRangees" 
                                           value="${salle.nbRangees}" min="1" max="26"
                                           placeholder="Ex: 10">
                                    <small class="text-muted">Maximum 26 rangées (A-Z)</small>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-grid-3x3"></i> Nombre de Colonnes
                                    </label>
                                    <input type="number" class="form-control" name="nbColonnes" 
                                           value="${salle.nbColonnes}" min="1" max="50"
                                           placeholder="Ex: 15">
                                    <small class="text-muted">Maximum 50 colonnes</small>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-people-fill"></i> Capacité Totale
                                    </label>
                                    <input type="text" class="form-control" id="capaciteCalculee"
                                           value="0" disabled>
                                    <!-- Champ hidden pour envoyer la valeur au serveur -->
                                    <input type="hidden" name="capacite" id="capaciteHidden" value="0">
                                    <small class="text-muted">Calculé automatiquement</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Boutons -->
                    <div class="text-end mt-4">
                        <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle"></i> 
                            ${action == 'edit' ? 'Modifier' : 'Créer la Salle'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calculer automatiquement la capacité totale lors de la saisie
        const nbRangeesInput = document.querySelector('input[name="nbRangees"]');
        const nbColonnesInput = document.querySelector('input[name="nbColonnes"]');
        const capaciteField = document.getElementById('capaciteCalculee');
        const capaciteHidden = document.getElementById('capaciteHidden');

        if (nbRangeesInput && nbColonnesInput && capaciteField) {
            function updateCapacite() {
                const rangees = parseInt(nbRangeesInput.value) || 0;
                const colonnes = parseInt(nbColonnesInput.value) || 0;
                const total = rangees * colonnes;
                
                capaciteField.value = total + ' places';
                
                // Mettre à jour le champ hidden avec la valeur numérique
                if (capaciteHidden) {
                    capaciteHidden.value = total;
                }
            }

            nbRangeesInput.addEventListener('input', updateCapacite);
            nbColonnesInput.addEventListener('input', updateCapacite);
            
            // Calculer au chargement si valeurs présentes
            updateCapacite();
        }
    </script>
</body>
</html>
