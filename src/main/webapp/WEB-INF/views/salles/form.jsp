<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${action == 'edit' ? 'Modifier' : 'Nouvelle'} Salle - NovaCine</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
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
                <c:set var="formAction" value="${action == 'edit' ? pageContext.request.contextPath.concat('/salles/').concat(salle.idSalle).concat('/modifier') : pageContext.request.contextPath.concat('/salles/nouveau')}" />
                <form method="post" action="${formAction}">
                    <input type="hidden" name="action" value="${action}">
                    
                    <c:if test="${action == 'edit'}">
                        <input type="hidden" name="idSalle" value="${salle.idSalle}">
                    </c:if>

                    <div class="row">
                        <!-- Nom de la salle -->
                        <div class="col-md-12 mb-3">
                            <label class="form-label">
                                <i class="bi bi-door-closed"></i> Nom de la Salle <span class="required">*</span>
                            </label>
                            <input type="text" class="form-control" name="nom" 
                                   value="${salle.nom}" required 
                                   placeholder="Ex: Salle Premium 1">
                        </div>

                        <!-- Capacité (directe) -->
                        <div class="col-md-4 mb-3">
                            <label class="form-label">
                                <i class="bi bi-people-fill"></i> Capacité <span class="required">*</span>
                            </label>
                            <input type="number" class="form-control" name="capacite" id="capaciteInput"
                                   value="${salle.capacite}" min="1" required
                                   placeholder="Nombre total de places">
                            <small class="text-muted">Entrez la capacité totale de la salle</small>
                        </div>

                        <!-- Configuration des types de places -->
                        <div class="col-md-12 mb-3">
                            <hr class="my-4">
                            <h5 class="mb-3">
                                <i class="bi bi-gear"></i> Configuration des Types de Places
                            </h5>
                            <div class="info-box">
                                <i class="bi bi-info-circle"></i>
                                <strong>Important:</strong> La somme des places par type doit égaler la capacité totale.
                            </div>
                        </div>

                        <c:forEach var="typePlace" items="${typesPlaces}">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="bi bi-tag-fill"></i> ${typePlace.nom}
                                </label>
                                <!-- Hidden id for controller binding as List<Long> idTypePlaces -->
                                <input type="hidden" name="idTypePlaces" value="${typePlace.id}">

                                <!-- number input bound to List<Integer> nombres -->
                                <input type="number" 
                                       class="form-control config-place" 
                                       name="nombres" 
                                       min="0" 
                                       value="${salleConfigMap[typePlace.id] != null ? salleConfigMap[typePlace.id] : 0}"
                                       placeholder="Nombre de places">
                                <small class="text-muted">Nombre de places de type ${typePlace.nom}</small>
                            </div>
                        </c:forEach>

                        <div class="col-md-12 mb-3">
                            <div class="alert alert-info" id="validationInfo">
                                <i class="bi bi-calculator"></i> 
                                <strong>Total configuré:</strong> <span id="totalConfig">0</span> places
                                <span id="validationMessage"></span>
                            </div>
                        </div>
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
        // Validation : compare la somme des nombres par type avec la capacité donnée
        const capaciteInput = document.getElementById('capaciteInput');
        const configInputs = document.querySelectorAll('.config-place');
        const totalConfigSpan = document.getElementById('totalConfig');
        const validationMessage = document.getElementById('validationMessage');
        const validationInfo = document.getElementById('validationInfo');
        const submitButton = document.querySelector('button[type="submit"]');

        function validateConfiguration() {
            const capaciteTotal = parseInt(capaciteInput.value) || 0;
            let totalConfig = 0;

            configInputs.forEach(input => {
                totalConfig += parseInt(input.value) || 0;
            });

            totalConfigSpan.textContent = totalConfig;

            if (capaciteTotal === 0) {
                validationMessage.innerHTML = ' <i class="bi bi-exclamation-triangle"></i> Veuillez définir la capacité de la salle';
                validationInfo.className = 'alert alert-warning';
                if (submitButton) submitButton.disabled = true;
            } else if (totalConfig === 0) {
                validationMessage.innerHTML = ' <i class="bi bi-exclamation-triangle"></i> Veuillez configurer les types de places';
                validationInfo.className = 'alert alert-warning';
                if (submitButton) submitButton.disabled = true;
            } else if (totalConfig === capaciteTotal) {
                validationMessage.innerHTML = ' <i class="bi bi-check-circle-fill text-success"></i> Configuration valide !';
                validationInfo.className = 'alert alert-success';
                if (submitButton) submitButton.disabled = false;
            } else {
                validationMessage.innerHTML = ' <i class="bi bi-x-circle-fill text-danger"></i> La somme (' + totalConfig + ') doit égaler la capacité totale (' + capaciteTotal + ')';
                validationInfo.className = 'alert alert-danger';
                if (submitButton) submitButton.disabled = true;
            }
        }

        // Écouter les changements
        if (capaciteInput) {
            capaciteInput.addEventListener('input', validateConfiguration);
        }
        configInputs.forEach(input => input.addEventListener('input', validateConfiguration));

        // Calculer au chargement
        validateConfiguration();
    </script>
</body>
</html>
