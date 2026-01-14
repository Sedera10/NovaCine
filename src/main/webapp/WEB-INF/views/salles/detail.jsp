<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<% DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${salle.nom} - Détails - NovaCine</title>
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

        .salle-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 2rem;
            margin: 0;
        }

        .info-card {
            background: var(--white);
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .info-card h5 {
            color: var(--primary-color);
            font-weight: bold;
            border-bottom: 2px solid rgba(11, 29, 58, 0.1);
            padding-bottom: 0.5rem;
            margin-bottom: 1rem;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem;
            border-bottom: 1px solid #e9ecef;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: var(--primary-color);
            font-weight: bold;
        }

        .info-value {
            color: var(--primary-color);
        }

        .badge-statut {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: bold;
        }

        .badge-active {
            background-color: #28a745;
            color: white;
        }

        .badge-maintenance {
            background-color: #ffc107;
            color: var(--primary-color);
        }

        .badge-fermee {
            background-color: #dc3545;
            color: white;
        }

        .stat-box {
            background: linear-gradient(135deg, var(--primary-color), #162d52);
            color: white;
            padding: 1.2rem;
            border-radius: 4px;
            text-align: center;
            margin-bottom: 1.2rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: white;
        }

        .stat-label {
            font-size: 0.9rem;
            color: white;
            margin-top: 0.5rem;
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
            padding: 0.8rem;
            text-align: center;
            border-radius: 8px 8px 50% 50%;
            margin-bottom: 1.5rem;
            font-weight: bold;
            font-size: 1rem;
        }

        .sieges-grid {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            align-items: center;
        }

        .rangee-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .rangee-label {
            color: var(--primary-color);
            font-weight: bold;
            font-size: 1.1rem;
            width: 30px;
            text-align: center;
        }

        .sieges-row {
            display: flex;
            gap: 0.3rem;
        }

        .siege {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.65rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }

        .siege:hover {
            transform: scale(1.08);
            border-color: var(--primary-color);
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

        .siege-handicape {
            background-color: #17a2b8;
            color: white;
        }

        .legende {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .legende-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .legende-box {
            width: 30px;
            height: 30px;
            border-radius: 5px;
        }

        .legende-label {
            color: var(--primary-color);
            font-weight: bold;
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
                    <div>
                        <h1 class="salle-title">
                            <i class="bi bi-door-open"></i> ${salle.nom}
                        </h1>
                        <c:choose>
                            <c:when test="${salle.statut == 'ACTIVE'}">
                                <span class="badge-statut badge-active mt-2">Active</span>
                            </c:when>
                            <c:when test="${salle.statut == 'MAINTENANCE'}">
                                <span class="badge-statut badge-maintenance mt-2">Maintenance</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-statut badge-fermee mt-2">Fermée</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="d-flex gap-2 mt-3 mt-md-0">
                        <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Retour
                        </a>
                        <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}/modifier" class="btn btn-primary">
                            <i class="bi bi-pencil"></i> Modifier
                        </a>
                        <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}/plan" class="btn btn-primary">
                            <i class="bi bi-grid"></i> Plan Interactif
                        </a>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Informations générales -->
                <div class="col-lg-4">
                    <div class="info-card">
                        <h5><i class="bi bi-info-circle"></i> Informations Générales</h5>
                        <div class="info-item">
                            <span class="info-label">Type:</span>
                            <span class="info-value">${salle.typeSalle.nom}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Prix de base:</span>
                            <span class="info-value">${salle.typeSalle.prixBase} Ar</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Capacité totale:</span>
                            <span class="info-value">${salle.capaciteTotale} places</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Configuration:</span>
                            <span class="info-value">${salle.nbRangees} × ${salle.nbColonnes}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Date de création:</span>
                            <span class="info-value">
                                ${salle.dtCreation.format(dateFormatter)}
                            </span>
                        </div>
                    </div>

                    <!-- Statistiques -->
                    <div class="info-card">
                        <h5><i class="bi bi-bar-chart"></i> Statistiques des Sièges</h5>
                        <div class="stat-box">
                            <div class="stat-value">${stats.nbDisponibles}</div>
                            <div class="stat-label">Sièges Disponibles</div>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Standard:</span>
                            <span class="info-value">${stats.nbStandard}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">VIP:</span>
                            <span class="info-value">${stats.nbVip}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Handicapé:</span>
                            <span class="info-value">${stats.nbHandicape}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Hors Service:</span>
                            <span class="info-value">${stats.nbHorsService}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Taux de disponibilité:</span>
                            <span class="info-value">${String.format("%.1f", stats.tauxDisponibilite)}%</span>
                        </div>
                    </div>
                </div>

                <!-- Plan de la salle -->
                <div class="col-lg-8">
                    <div class="plan-container">
                        <h5 style="color: var(--primary-color); font-weight: bold; margin-bottom: 1.5rem;">
                            <i class="bi bi-grid-3x3"></i> Plan de la Salle
                        </h5>
                        
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
                                
                                <c:choose>
                                    <c:when test="${siege.statut == 'HORS_SERVICE'}">
                                        <div class="siege siege-hors-service" title="${siege.position} - Hors Service">
                                            <i class="bi bi-x"></i>
                                        </div>
                                    </c:when>
                                    <c:when test="${siege.typeSiege.nom == 'VIP'}">
                                        <div class="siege siege-vip" title="${siege.position} - VIP">
                                            <i class="bi bi-star-fill"></i>
                                        </div>
                                    </c:when>
                                    <c:when test="${siege.typeSiege.nom == 'HANDICAPE'}">
                                        <div class="siege siege-handicape" title="${siege.position} - Handicapé">
                                            <i class="bi bi-universal-access"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="siege siege-disponible" title="${siege.position} - Disponible">
                                            ${siege.numero}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
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
                                <div class="legende-box siege-handicape"></div>
                                <span class="legende-label">Handicapé</span>
                            </div>
                            <div class="legende-item">
                                <div class="legende-box siege-hors-service"></div>
                                <span class="legende-label">Hors Service</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
