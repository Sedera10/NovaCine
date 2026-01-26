<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Plan - ${salle.nom} - NovaCine</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #0B1D3A;
            --secondary-color: #FFC107;
            --white: #FFFFFF;
        }

        body {
            background-color: #f8f9fa;
        }

        .page-header {
            background: var(--white);
            border: 1px solid var(--primary-color);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .salle-title {
            color: var(--primary-color);
            font-weight: bold;
            font-size: 2rem;
            margin: 0;
        }

        .plan-container {
            background: var(--white);
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .ecran {
            background: linear-gradient(to bottom, var(--primary-color), #162d52);
            color: white;
            padding: 1rem;
            text-align: center;
            border-radius: 10px 10px 50% 50%;
            margin-bottom: 2rem;
            font-weight: bold;
            font-size: 1.2rem;
            box-shadow: 0 2px 8px rgba(11, 29, 58, 0.2);
        }

        .sieges-grid {
            display: flex;
            flex-direction: column;
            gap: 0.7rem;
            align-items: center;
        }

        .rangee-container {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .rangee-label {
            color: var(--primary-color);
            font-weight: bold;
            font-size: 1.1rem;
            width: 35px;
            text-align: center;
            background-color: rgba(11, 29, 58, 0.08);
            border-radius: 50%;
            padding: 0.4rem;
        }

        .sieges-row {
            display: flex;
            gap: 0.4rem;
        }

        .siege {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
            position: relative;
        }

        .siege:hover {
            transform: scale(1.1);
            border-color: var(--primary-color);
            box-shadow: 0 0 8px rgba(11, 29, 58, 0.3);
        }

        .siege-disponible {
            background-color: #28a745;
            color: white;
        }

        .siege-hors-service {
            background-color: #dc3545;
            color: white;
        }

        .siege-vip {
            background-color: #9c27b0;
            color: white;
        }

        .siege-premium {
            background-color: #ffc107;
            color: #0B1D3A;
        }

        .siege-handicape {
            background-color: #17a2b8;
            color: white;
        }

        .siege.selected {
            border: 3px solid var(--primary-color);
            box-shadow: 0 0 12px rgba(11, 29, 58, 0.5);
        }

        .legende {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 3rem;
            flex-wrap: wrap;
        }

        .legende-item {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            padding: 0.6rem 1.2rem;
            background: var(--white);
            border: 1px solid var(--primary-color);
            border-radius: 20px;
        }

        .legende-box {
            width: 30px;
            height: 30px;
            border-radius: 6px;
        }

        .legende-label {
            color: var(--primary-color);
            font-weight: bold;
        }

        .control-panel {
            background: var(--white);
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .control-panel h5 {
            color: var(--primary-color);
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: bold;
        }

        .btn-primary:hover {
            background-color: #162d52;
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: bold;
        }

        .btn-secondary:hover {
            background-color: #e0a800;
        }

        .btn-danger {
            background-color: #dc3545;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            font-weight: bold;
        }

        .selected-info {
            background: #e7f3ff;
            border-left: 3px solid var(--primary-color);
            padding: 0.8rem;
            border-radius: 4px;
            margin-top: 0.8rem;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <h1 class="salle-title">
                        <i class="bi bi-grid-3x3"></i> Plan Interactif - ${salle.nom}
                    </h1>
                    <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Retour aux Détails
                    </a>
                </div>
            </div>

            <!-- Panel de contrôle -->
            <div class="control-panel">
                <h5><i class="bi bi-gear"></i> Modifier les Sièges Sélectionnés</h5>
                <div class="row align-items-end">
                    <div class="col-md-4">
                        <label class="form-label" style="color: var(--primary-color); font-weight: bold;">
                            Changer le Statut
                        </label>
                        <select class="form-select" id="newStatut">
                            <option value="">-- Sélectionnez --</option>
                            <option value="DISPONIBLE">Disponible</option>
                            <option value="HORS_SERVICE">Hors Service</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" style="color: var(--primary-color); font-weight: bold;">
                            Changer le Type
                        </label>
                        <select class="form-select" id="newTypeSiege">
                            <option value="">-- Sélectionnez --</option>
                            <c:forEach items="${typesSiege}" var="type">
                                <option value="${type.id}">${type.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-primary w-100" onclick="applyChanges()">
                            <i class="bi bi-check-circle"></i> Appliquer
                        </button>
                    </div>
                </div>
                <div class="selected-info" id="selectedInfo" style="display: none;">
                    <strong><i class="bi bi-info-circle"></i> Sièges sélectionnés:</strong> 
                    <span id="selectedCount">0</span> siège(s)
                </div>
            </div>

            <!-- Plan de la salle -->
            <div class="plan-container">
                <!-- Écran -->
                <div class="ecran">
                    <i class="bi bi-tv"></i> ÉCRAN
                </div>

                <!-- Grille des sièges -->
                <div class="sieges-grid">
                    <c:set var="currentRangee" value="" />
                    <c:forEach items="${sieges}" var="siege" varStatus="status">
                        <c:choose>
                            <c:when test="${siege.rangee != currentRangee}">
                                <c:if test="${!status.first}">
                                    </div></div> <!-- Fermer rangee précédente -->
                                </c:if>
                                <div class="rangee-container">
                                    <div class="rangee-label">${siege.rangee}</div>
                                    <div class="sieges-row">
                                <c:set var="currentRangee" value="${siege.rangee}" />
                            </c:when>
                        </c:choose>
                        
                        <c:set var="siegeClass" value="siege-disponible" />
                        <c:set var="siegeLabel" value="${siege.position}" />
                        
                        <c:if test="${siege.statut == 'HORS_SERVICE'}">
                            <c:set var="siegeClass" value="siege-hors-service" />
                            <c:set var="siegeLabel" value="<i class='bi bi-x'></i>" />
                        </c:if>
                        <c:if test="${fn:toLowerCase(siege.typeSiege.nom) == 'vip'}">
                            <c:set var="siegeClass" value="siege-vip" />
                        </c:if>
                        <c:if test="${fn:toLowerCase(siege.typeSiege.nom) == 'prenium'}">
                            <c:set var="siegeClass" value="siege-premium" />
                        </c:if>
                        
                        <div class="siege ${siegeClass}" 
                             data-id="${siege.idSiege}"
                             data-position="${siege.position}"
                             data-statut="${siege.statut}"
                             data-type="${siege.typeSiege.nom}"
                             onclick="toggleSiege(this)"
                             title="${siege.position} - ${siege.typeSiege.nom} - ${siege.statut}">
                            <c:out value="${siegeLabel}" escapeXml="false" />
                        </div>
                        
                        <c:if test="${status.last}">
                            </div></div> <!-- Fermer dernière rangée -->
                        </c:if>
                    </c:forEach>
                </div>

                <!-- Légende -->
                <div class="legende">
                    <div class="legende-item">
                        <div class="legende-box siege-disponible"></div>
                        <span class="legende-label">Standard</span>
                    </div>
                    <div class="legende-item">
                        <div class="legende-box siege-vip"></div>
                        <span class="legende-label">VIP</span>
                    </div>
                    <div class="legende-item">
                        <div class="legende-box siege-premium"></div>
                        <span class="legende-label">Prenium</span>
                    </div>
                    <div class="legende-item">
                        <div class="legende-box siege-hors-service"></div>
                        <span class="legende-label">Hors Service</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let selectedSeats = new Set();

        function toggleSiege(element) {
            const siegeId = element.dataset.id;
            
            if (selectedSeats.has(siegeId)) {
                selectedSeats.delete(siegeId);
                element.classList.remove('selected');
            } else {
                selectedSeats.add(siegeId);
                element.classList.add('selected');
            }
            
            updateSelectedInfo();
        }

        function updateSelectedInfo() {
            const infoDiv = document.getElementById('selectedInfo');
            const countSpan = document.getElementById('selectedCount');
            
            if (selectedSeats.size > 0) {
                infoDiv.style.display = 'block';
                countSpan.textContent = selectedSeats.size;
            } else {
                infoDiv.style.display = 'none';
            }
        }

        function applyChanges() {
            if (selectedSeats.size === 0) {
                alert('Veuillez sélectionner au moins un siège');
                return;
            }

            const newStatut = document.getElementById('newStatut').value;
            const newTypeSiege = document.getElementById('newTypeSiege').value;

            if (!newStatut && !newTypeSiege) {
                alert('Veuillez sélectionner un statut ou un type à appliquer');
                return;
            }

            if (!confirm(`Appliquer les modifications à ${selectedSeats.size} siège(s) ?`)) {
                return;
            }

            // Appliquer les changements pour chaque siège sélectionné
            let promises = [];
            selectedSeats.forEach(siegeId => {
                const formData = new FormData();
                if (newStatut) formData.append('statut', newStatut);
                if (newTypeSiege) formData.append('idTypeSiege', newTypeSiege);

                const promise = fetch('${pageContext.request.contextPath}/salles/siege/' + siegeId + '/update', {
                    method: 'POST',
                    body: formData
                }).then(response => response.json());
                
                promises.push(promise);
            });

            Promise.all(promises)
                .then(results => {
                    alert('Modifications appliquées avec succès !');
                    location.reload();
                })
                .catch(error => {
                    alert('Erreur lors de l\'application des modifications');
                    console.error(error);
                });
        }
    </script>
</body>
</html>
