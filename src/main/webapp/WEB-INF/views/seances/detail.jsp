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
        
        .detail-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .detail-section {
            margin-bottom: 2rem;
        }
        
        .detail-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 0.5rem;
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
            min-width: 180px;
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
        
        .big-stat {
            text-align: center;
            padding: 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        
        .big-stat h2 {
            font-size: 3rem;
            font-weight: 700;
            margin: 0;
        }
        
        .big-stat p {
            margin: 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .progress-custom {
            height: 30px;
            border-radius: 15px;
            background-color: #e9ecef;
        }
        
        .progress-bar-custom {
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
        }
        
        .btn-reserve-big {
            background: linear-gradient(135deg, var(--secondary-color), #ffb300);
            border: none;
            color: var(--primary-color);
            font-weight: 700;
            padding: 15px 40px;
            font-size: 1.2rem;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .btn-reserve-big:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(255, 193, 7, 0.5);
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
                        <h1 class="mb-2"><i class="bi bi-calendar-event me-2"></i>Détails de la Séance</h1>
                        <p class="mb-0 text-muted">Informations complètes</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour
                    </a>
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
                <!-- Colonne gauche -->
                <div class="col-md-8">
                    <!-- Informations Film -->
                    <div class="detail-card">
                        <div class="detail-section">
                            <h5><i class="bi bi-film me-2"></i>Film</h5>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-camera-reels"></i>Titre</div>
                                <div class="info-value"><strong>${seance.film.titre}</strong></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-hourglass-split"></i>Durée</div>
                                <div class="info-value">${seance.film.duree} minutes</div>
                            </div>
                            <%-- <div class="info-row">
                                <div class="info-label"><i class="bi bi-shield-check"></i>Classification</div>
                                <div class="info-value">${seance.film.classification.nom}</div>
                            </div> --%>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-cash-coin"></i>Argent générable</div>
                                <div class="info-value">
                                    <strong class="text-success">
                                        <fmt:formatNumber value="${totalargent}" type="number" groupingUsed="true" /> Ar
                                    </strong>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Informations Séance -->
                        <div class="detail-section">
                            <h5><i class="bi bi-calendar-check me-2"></i>Programmation</h5>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-calendar3"></i>Date</div>
                                <div class="info-value">
                                    ${seance.daty}
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-clock"></i>Horaires</div>
                                <div class="info-value">
                                    ${seance.heure}
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-door-open"></i>Salle</div>
                                <div class="info-value">
                                    ${seance.salle.nom} 
                                    <small class="text-muted">(${seance.salle.capacite} places)</small>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-info-circle"></i>Statut</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${seance.statut == 'PROGRAMMEE'}">
                                            <span class="badge bg-success">Programmée</span>
                                        </c:when>
                                        <c:when test="${seance.statut == 'EN_COURS'}">
                                            <span class="badge bg-info">En Cours</span>
                                        </c:when>
                                        <c:when test="${seance.statut == 'TERMINEE'}">
                                            <span class="badge bg-secondary">Terminée</span>
                                        </c:when>
                                        <c:when test="${seance.statut == 'ANNULEE'}">
                                            <span class="badge bg-danger">Annulée</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Colonne droite -->
                <div class="col-md-4">
                    <!-- Disponibilité -->
                    <div class="big-stat">
                        <h2>${seance.placesDisponibles}</h2>
                        <p>Places Disponibles</p>
                    </div>
                    
                    <div class="detail-card">
                        <h6 class="text-center mb-3">Occupation</h6>
                        <div class="progress progress-custom mb-3">
                            <c:set var="tauxRemplissage" value="${seance.tauxRemplissage}" />
                            <c:choose>
                                <c:when test="${tauxRemplissage < 50}">
                                    <div class="progress-bar bg-success progress-bar-custom" 
                                         style="width: ${tauxRemplissage}%">
                                        ${tauxRemplissage}%
                                    </div>
                                </c:when>
                                <c:when test="${tauxRemplissage < 85}">
                                    <div class="progress-bar bg-warning progress-bar-custom" 
                                         style="width: ${tauxRemplissage}%">
                                        ${tauxRemplissage}%
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="progress-bar bg-danger progress-bar-custom" 
                                         style="width: ${tauxRemplissage}%">
                                        ${tauxRemplissage}%
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="d-grid gap-2">
                        <c:if test="${seance.disponible and not seance.complet}">
                            <a href="${pageContext.request.contextPath}/ventes/seance/${seance.idSeance}/reserver" 
                               class="btn btn-reserve-big">
                                <i class="bi bi-ticket-perforated me-2"></i>Réserver
                            </a>
                        </c:if>
                        
                        <c:if test="${seance.complet}">
                            <button class="btn btn-danger btn-lg" disabled>
                                <i class="bi bi-x-circle me-2"></i>Complet
                            </button>
                        </c:if>
                        
                        <c:if test="${userDetail.admin or userDetail.manager}">
                            <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}/modifier" 
                               class="btn btn-outline-primary">
                                <i class="bi bi-pencil me-2"></i>Modifier
                            </a>
                            
                            <c:if test="${seance.placesVendues == 0}">
                                <form action="${pageContext.request.contextPath}/seances/${seance.idSeance}/annuler" 
                                      method="post"
                                      onsubmit="return confirm('Confirmer l\'annulation ?');">
                                    <button type="submit" class="btn btn-outline-danger w-100">
                                        <i class="bi bi-x-circle me-2"></i>Annuler la séance
                                    </button>
                                </form>
                            </c:if>
                            
                            <c:if test="${userDetail.admin}">
                                <form action="${pageContext.request.contextPath}/seances/${seance.idSeance}/supprimer" 
                                      method="post"
                                      onsubmit="return confirm('ATTENTION: Supprimer définitivement ?');">
                                    <button type="submit" class="btn btn-outline-dark w-100">
                                        <i class="bi bi-trash me-2"></i>Supprimer
                                    </button>
                                </form>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
