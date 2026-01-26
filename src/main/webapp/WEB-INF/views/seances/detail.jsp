<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Détails Séance</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-color: #0B1D3A;
            --secondary-color: #FFC107;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-content {
            margin-left: 240px;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        
        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .detail-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        
        .film-poster {
            width: 100%;
            max-width: 280px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .film-poster-placeholder {
            width: 100%;
            max-width: 280px;
            height: 400px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
        }
        
        .section-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 3px solid var(--secondary-color);
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 0.5rem;
        }
        
        .info-row {
            display: flex;
            padding: 0.8rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 150px;
            display: flex;
            align-items: center;
        }
        
        .info-label i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
        
        .info-value {
            color: #212529;
            flex: 1;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-a-venir {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-en-cours {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-terminee {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .tarif-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .tarif-table th {
            background-color: var(--primary-color);
            color: white;
            padding: 12px;
            text-align: center;
            font-weight: 600;
        }
        
        .tarif-table td {
            padding: 10px 12px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;
        }
        
        .tarif-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .tarif-table tr:hover {
            background-color: #e9ecef;
        }
        
        .tarif-value {
            font-weight: 600;
            color: #28a745;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            font-weight: 600;
            padding: 10px 25px;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            color: white;
        }
        
        .btn-warning-custom {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 600;
            padding: 10px 25px;
        }
        
        .btn-warning-custom:hover {
            background-color: #e0a800;
            color: var(--primary-color);
        }
        
        .gain-potentiel-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            padding: 2rem;
            border-radius: 8px;
        }
        
        .gain-potentiel-card h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .film-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
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
                            <i class="bi bi-calendar-event me-2"></i>Détails de la Séance
                        </h1>
                        <p class="mb-0 text-muted">
                            Séance #${seance.idSeance} - ${seance.film.titre}
                        </p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/achats/seance/${seance.idSeance}" 
                           class="btn btn-warning-custom">
                            <i class="bi bi-ticket-perforated me-2"></i>Acheter Billet
                        </a>
                        <a href="${pageContext.request.contextPath}/seances" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Retour
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <div class="row">
                <!-- Colonne gauche: Poster + Infos générales -->
                <div class="col-lg-4">
                    <!-- Poster du film -->
                    <div class="detail-card text-center">
                        <c:choose>
                            <c:when test="${not empty seance.film.poster}">
                                <img src="${pageContext.request.contextPath}/images/films/${seance.film.poster}" 
                                     alt="${seance.film.titre}" 
                                     class="film-poster"
                                     onerror="this.outerHTML='<div class=\'film-poster-placeholder\'><i class=\'bi bi-film\'></i></div>'">
                            </c:when>
                            <c:otherwise>
                                <div class="film-poster-placeholder">
                                    <i class="bi bi-film"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <h3 class="mt-3 film-title">${seance.film.titre}</h3>
                    </div>
                    
                    <!-- Statut -->
                    <div class="detail-card text-center">
                        <h5 class="section-title justify-content-center">
                            <i class="bi bi-info-circle"></i>Statut
                        </h5>
                        <c:choose>
                            <c:when test="${statut == 'A_VENIR'}">
                                <span class="status-badge status-a-venir">
                                    <i class="bi bi-clock me-2"></i>À venir
                                </span>
                            </c:when>
                            <c:when test="${statut == 'EN_COURS'}">
                                <span class="status-badge status-en-cours">
                                    <i class="bi bi-play-circle me-2"></i>En cours
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-terminee">
                                    <i class="bi bi-check-circle me-2"></i>Terminée
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Gain Potentiel (à implémenter plus tard) -->
                    <div class="gain-potentiel-card">
                        <p class="mb-1"><i class="bi bi-cash-coin me-2"></i>Gain Potentiel</p>
                        <h2><fmt:formatNumber value="${gainsPotentiel}" type="number" groupingUsed="true" /> MGA</h2>
                        <small class="opacity-75">Par defaut : par rapport au tarif "Adulte"</small>
                        </small>
                    </div>
                </div>
                
                <!-- Colonne droite: Détails -->
                <div class="col-lg-8">
                    <!-- Informations de la séance -->
                    <div class="detail-card">
                        <h5 class="section-title">
                            <i class="bi bi-calendar-check"></i>Informations de la Séance
                        </h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-door-open"></i>Salle
                                    </div>
                                    <div class="info-value">
                                        <strong>${seance.salle.nom}</strong>
                                        <small class="text-muted">(${seance.salle.capacite} places)</small>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-calendar3"></i>Date
                                    </div>
                                    <div class="info-value">
                                        <strong>${seance.dateSeance}</strong>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-hourglass-split"></i>Durée film
                                    </div>
                                    <div class="info-value">${seance.film.duree} minutes</div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-clock"></i>Début
                                    </div>
                                    <div class="info-value">
                                        <strong class="text-success">${seance.heureSeance}</strong>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-clock-history"></i>Fin estimée
                                    </div>
                                    <div class="info-value">
                                        <strong class="text-danger">${heureFin}</strong>
                                        <small class="text-muted">(+15 min nettoyage)</small>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-calendar-plus"></i>Créée le
                                    </div>
                                    <div class="info-value">
                                        ${seance.dtCreation}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Tableau des Tarifs -->
                    <div class="detail-card">
                        <h5 class="section-title">
                            <i class="bi bi-currency-exchange"></i>Grille Tarifaire
                        </h5>
                        
                        <c:choose>
                            <c:when test="${not empty typePlaces and not empty typeClients}">
                                <div class="table-responsive">
                                    <table class="tarif-table">
                                        <thead>
                                            <tr>
                                                <th>Type de Place</th>
                                                <c:forEach var="typeClient" items="${typeClients}">
                                                    <th>${typeClient.nom}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="typePlace" items="${typePlaces}">
                                                <tr>
                                                    <td><strong>${typePlace.nom}</strong></td>
                                                    <c:forEach var="typeClient" items="${typeClients}">
                                                        <td>
                                                            <c:set var="prix" value="${tarifMap[typePlace.id][typeClient.idTypeClient]}" />
                                                            <c:choose>
                                                                <c:when test="${not empty prix}">
                                                                    <span class="tarif-value">
                                                                        <fmt:formatNumber value="${prix}" type="number" groupingUsed="true" /> Ar
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">--</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </c:forEach>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Aucun tarif défini pour cette séance.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Actions -->
                    <div class="detail-card">
                        <h5 class="section-title">
                            <i class="bi bi-lightning"></i>Actions
                        </h5>
                        
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${pageContext.request.contextPath}/achats/seance/${seance.idSeance}" 
                               class="btn btn-warning-custom">
                                <i class="bi bi-ticket-perforated me-2"></i>Acheter un Billet
                            </a>
                            <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}/ventes" 
                               class="btn btn-primary-custom">
                                <i class="bi bi-cash-stack me-2"></i>Voir les Ventes
                            </a>
                            <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}/modifier" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-pencil me-2"></i>Modifier
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
