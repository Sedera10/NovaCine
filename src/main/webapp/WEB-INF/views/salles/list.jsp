<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Salles - NovaCine</title>
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

        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            margin: 0;
        }

        .filter-section {
            background: white;
            padding: 1.2rem;
            border-radius: 4px;
            border: 1px solid #dee2e6;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .salle-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            transition: all 0.3s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .salle-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 2px 6px rgba(11, 29, 58, 0.1);
        }

        .salle-name {
            color: var(--primary-color);
            font-size: 1.4rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .salle-info {
            color: var(--primary-color);
            margin-bottom: 0.3rem;
        }

        .salle-info i {
            color: var(--primary-color);
            opacity: 0.7;
            width: 20px;
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

        .btn-action {
            padding: 0.4rem 0.8rem;
            border-radius: 5px;
            font-size: 0.9rem;
            margin-right: 0.5rem;
        }

        .form-control, .form-select {
            border: 2px solid var(--primary-color);
            border-radius: 8px;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
        }

        .type-badge {
            background-color: rgba(11, 29, 58, 0.08);
            color: var(--primary-color);
            padding: 0.25rem 0.7rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="page-title">
                        <i class="bi bi-door-open"></i> Gestion des Salles
                    </h1>
                    <a href="${pageContext.request.contextPath}/salles/nouveau" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Nouvelle Salle
                    </a>
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Filtres -->
            <div class="filter-section">
                <form method="get" action="${pageContext.request.contextPath}/salles">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label" style="color: var(--primary-color); font-weight: bold;">
                                <i class="bi bi-search"></i> Recherche
                            </label>
                            <input type="text" class="form-control" name="search" 
                                   placeholder="Nom de la salle..." value="${search}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" style="color: var(--primary-color); font-weight: bold;">
                                <i class="bi bi-toggle-on"></i> Statut
                            </label>
                            <select class="form-select" name="statut">
                                <option value="">Tous les statuts</option>
                                <option value="ACTIVE" ${statut == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                <option value="MAINTENANCE" ${statut == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                <option value="FERMEE" ${statut == 'FERMEE' ? 'selected' : ''}>Fermée</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" style="color: var(--primary-color); font-weight: bold;">
                                <i class="bi bi-tag"></i> Type de Salle
                            </label>
                            <select class="form-select" name="idTypeSalle">
                                <option value="">Tous les types</option>
                                <c:forEach items="${typesSalle}" var="type">
                                    <option value="${type.idTypeSalle}" ${idTypeSalle == type.idTypeSalle ? 'selected' : ''}>
                                        ${type.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="text-end mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-funnel"></i> Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Réinitialiser
                        </a>
                    </div>
                </form>
            </div>

            <!-- Liste des Salles -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty salles}">
                        <div class="col-12">
                            <div class="alert alert-info text-center">
                                <i class="bi bi-info-circle"></i> Aucune salle trouvée.
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${salles}" var="salle">
                            <div class="col-md-6 col-lg-4">
                                <div class="salle-card">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="salle-name">${salle.nom}</div>
                                        <span class="badge-statut badge-active">Active</span>
                                    </div>
                                    
                                    <div class="salle-info">
                                        <i class="bi bi-people-fill"></i>
                                        Capacité: <strong>${salle.capacite} places</strong>
                                    </div>
                                    
                                    <div class="salle-info">
                                        <i class="bi bi-calendar-event"></i>
                                        Créée le: <strong><c:out value="${salle.dtCreation.toLocalDate()}" /></strong>
                                    </div>
                                    
                                    <div class="mt-3 d-flex flex-wrap gap-2">
                                        <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}" 
                                           class="btn btn-sm btn-primary btn-action">
                                            <i class="bi bi-eye"></i> Détails
                                        </a>
                                        <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}/plan" 
                                           class="btn btn-sm btn-secondary btn-action">
                                            <i class="bi bi-grid"></i> Plan
                                        </a>
                                        <a href="${pageContext.request.contextPath}/salles/${salle.idSalle}/modifier" 
                                           class="btn btn-sm btn-warning btn-action">
                                            <i class="bi bi-pencil"></i> Modifier
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
