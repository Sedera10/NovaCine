<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% 
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    pageContext.setAttribute("dateFormatter", dateFormatter);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${salle.nom} - Détails - NovaCine</title>
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
            background: white;
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

        .config-card {
            background: white;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            transition: transform 0.2s;
        }

        .config-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .config-card.standard {
            border-left: 5px solid #28a745;
        }

        .config-card.premium {
            border-left: 5px solid #ffc107;
        }

        .config-nombre {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .config-type {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-top: 0.5rem;
        }

        .config-prix {
            font-size: 0.95rem;
            color: #666;
            margin-top: 0.3rem;
        }

        .gain-potentiel {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
        }

        .gain-potentiel .montant {
            font-size: 1.8rem;
            font-weight: bold;
        }

        .gain-potentiel .label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid p-4">
            <!-- Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <div>
                        <h1 class="salle-title">
                            <i class="bi bi-door-open"></i> ${salle.nom}
                        </h1>
                    </div>
                    <div class="d-flex gap-2 mt-3 mt-md-0">
                        <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Retour
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
                            <span class="info-label">Capacité totale:</span>
                            <span class="info-value">${salle.capacite} places</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Configuration:</span>
                            <span class="info-value">${not empty configurations ? configurations.size() : 0} types — ${salle.capacite} places</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Date de création:</span>
                            <span class="info-value">
                                ${salle.dtCreation.format(dateFormatter)}
                            </span>
                        </div>
                    </div>

                    <!-- Gain potentiel -->
                    <div class="gain-potentiel">
                        <div class="label"><i class="bi bi-cash-stack"></i> Gain potentiel par séance</div>
                        <div class="montant">
                            <fmt:formatNumber value="${gainPotentiel}" pattern="#,##0"/> Ar
                        </div>
                    </div>
                </div>

                <!-- Configuration des places -->
                <div class="col-lg-8">
                    <div class="info-card">
                        <h5><i class="bi bi-grid-3x3-gap"></i> Configuration des Places</h5>
                        
                        <c:choose>
                            <c:when test="${not empty configurations}">
                                <div class="row g-3">
                                    <c:forEach items="${configurations}" var="config">
                                        <div class="col-md-6">
                                            <c:set var="typeClass" value="${config.typePlace.nom.toLowerCase().contains('premium') ? 'premium' : 'standard'}" />
                                            <div class="config-card ${typeClass}">
                                                <div class="config-nombre">${config.nombre}</div>
                                                <div class="config-type">
                                                    <c:choose>
                                                        <c:when test="${typeClass == 'premium'}">
                                                            <i class="bi bi-star-fill text-warning"></i>
                                                        </c:when>
                                                        <c:when test="${typeClass == 'vip'}">
                                                            <i class="bi bi-gem text-danger"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-check-circle-fill text-success"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ${config.typePlace.nom}
                                                </div>
                                                <div class="config-prix text-muted">
                                                    <small><i class="bi bi-info-circle"></i> Prix configuré par séance</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> 
                                    Aucune configuration de places définie pour cette salle.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Résumé visuel -->
                    <c:if test="${not empty configurations}">
                        <div class="info-card">
                            <h5><i class="bi bi-bar-chart"></i> Répartition des Places</h5>
                            <c:forEach items="${configurations}" var="config">
                                <c:set var="pourcentage" value="${(config.nombre * 100) / salle.capacite}" />
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="info-label">${config.typePlace.nom}</span>
                                        <span>${config.nombre} places (${String.format("%.0f", pourcentage)}%)</span>
                                    </div>
                                    <div class="progress" style="height: 20px;">
                                        <c:set var="barColor" value="${config.typePlace.nom.toLowerCase().contains('premium') ? 'bg-warning' : 'bg-success'}" />
                                        <div class="progress-bar ${barColor}" role="progressbar" 
                                             style="width: ${pourcentage}%;" 
                                             aria-valuenow="${pourcentage}" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
