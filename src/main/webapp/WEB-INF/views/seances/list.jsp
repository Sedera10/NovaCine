<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Séances</title>
    
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
        
        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .page-header h1 {
            color: var(--primary-color);
        }
        
        .filter-card {
            background: white;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .seance-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            border-left: 4px solid var(--primary-color);
        }
        
        .seance-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.12);
        }
        
        .seance-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .seance-film-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .seance-datetime {
            font-size: 1.1rem;
            color: #495057;
            font-weight: 600;
        }
        
        .seance-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .seance-info-item {
            display: flex;
            align-items: center;
            color: #6c757d;
            font-size: 0.95rem;
        }
        
        .seance-info-item i {
            font-size: 1.2rem;
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
        
        .availability-bar {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }
        
        .availability-fill {
            height: 100%;
            transition: width 0.3s ease;
        }
        
        .availability-fill.low {
            background: linear-gradient(90deg, #28a745, #20c997);
        }
        
        .availability-fill.medium {
            background: linear-gradient(90deg, #ffc107, #fd7e14);
        }
        
        .availability-fill.high {
            background: linear-gradient(90deg, #dc3545, #c82333);
        }
        
        .availability-text {
            font-size: 0.85rem;
            color: #6c757d;
            display: flex;
            justify-content: space-between;
        }
        
        .badge-status {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-programmee {
            background-color: #28a745;
            color: white;
        }
        
        .badge-en-cours {
            background-color: #17a2b8;
            color: white;
        }
        
        .badge-terminee {
            background-color: #6c757d;
            color: white;
        }
        
        .badge-annulee {
            background-color: #dc3545;
            color: white;
        }
        
        .badge-complet {
            background-color: #dc3545;
            color: white;
        }
        
        .badge-disponible {
            background-color: #28a745;
            color: white;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            border-color: #164a7a;
        }
        
        .btn-secondary-custom {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .btn-secondary-custom:hover {
            background-color: #e0a800;
            border-color: #e0a800;
        }
        
        .btn-reserve {
            background: linear-gradient(135deg, var(--secondary-color), #ffb300);
            border: none;
            color: var(--primary-color);
            font-weight: 700;
            padding: 10px 24px;
            border-radius: 6px;
            transition: all 0.3s;
        }
        
        .btn-reserve:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .date-badge {
            background: var(--primary-color);
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            margin-bottom: 1rem;
            display: inline-block;
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="../includes/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid p-4">
            
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="mb-2"><i class="bi bi-calendar-event me-2"></i>Séances de Cinéma</h1>
                        <p class="mb-0 opacity-75">Programmation et réservations</p>
                    </div>
                    <c:if test="${userDetail.admin or userDetail.manager}">
                        <a href="${pageContext.request.contextPath}/seances/nouveau" class="btn btn-secondary-custom btn-lg">
                            <i class="bi bi-plus-circle me-2"></i>Nouvelle Séance
                        </a>
                    </c:if>
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
            
            <!-- Filtres -->
            <div class="filter-card">
                <form action="${pageContext.request.contextPath}/seances" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-calendar me-2"></i>Date</label>
                        <input type="date" name="date" class="form-control" value="${selectedDate}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="bi bi-film me-2"></i>Film</label>
                        <select name="film" class="form-select">
                            <option value="">Tous les films</option>
                            <c:forEach var="f" items="${films}">
                                <option value="${f.idFilm}" ${selectedFilm == f.idFilm ? 'selected' : ''}>${f.titre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-door-open me-2"></i>Salle</label>
                        <select name="salle" class="form-select">
                            <option value="">Toutes les salles</option>
                            <c:forEach var="s" items="${salles}">
                                <option value="${s.idSalle}" ${selectedSalle == s.idSalle ? 'selected' : ''}>${s.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label d-block">&nbsp;</label>
                        <button type="submit" class="btn btn-primary-custom w-100">
                            <i class="bi bi-search me-2"></i>Filtrer
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Date Badge -->
            <div class="date-badge">
                <i class="bi bi-calendar-check me-2"></i>
                <fmt:formatDate value="${selectedDate}" pattern="EEEE d MMMM yyyy" />
            </div>
            
            <!-- Liste des Séances -->
            <c:choose>
                <c:when test="${empty seances}">
                    <div class="empty-state">
                        <i class="bi bi-calendar-x"></i>
                        <h3>Aucune séance programmée</h3>
                        <p>Il n'y a aucune séance pour les critères sélectionnés.</p>
                        <c:if test="${userDetail.admin or userDetail.manager}">
                            <a href="${pageContext.request.contextPath}/seances/nouveau" class="btn btn-primary-custom mt-3">
                                <i class="bi bi-plus-circle me-2"></i>Programmer une séance
                            </a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach var="seance" items="${seances}">
                            <div class="col-12">
                                <div class="seance-card">
                                    <div class="seance-header">
                                        <div class="flex-grow-1">
                                            <div class="seance-film-title">
                                                <i class="bi bi-film me-2"></i>${seance.film.titre}
                                            </div>
                                            <div class="seance-datetime">
                                                <i class="bi bi-clock me-2"></i>
                                                <fmt:formatDate value="${seance.heureDebut}" pattern="HH:mm" /> - 
                                                <fmt:formatDate value="${seance.heureFin}" pattern="HH:mm" />
                                                <span class="ms-3">
                                                    <i class="bi bi-door-open me-1"></i>${seance.salle.nom}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <c:choose>
                                                <c:when test="${seance.statut == 'PROGRAMMEE'}">
                                                    <span class="badge-status badge-programmee">Programmée</span>
                                                </c:when>
                                                <c:when test="${seance.statut == 'EN_COURS'}">
                                                    <span class="badge-status badge-en-cours">En Cours</span>
                                                </c:when>
                                                <c:when test="${seance.statut == 'TERMINEE'}">
                                                    <span class="badge-status badge-terminee">Terminée</span>
                                                </c:when>
                                                <c:when test="${seance.statut == 'ANNULEE'}">
                                                    <span class="badge-status badge-annulee">Annulée</span>
                                                </c:when>
                                            </c:choose>
                                            <br>
                                            <c:choose>
                                                <c:when test="${seance.complet}">
                                                    <span class="badge-status badge-complet mt-2">Complet</span>
                                                </c:when>
                                                <c:when test="${seance.disponible}">
                                                    <span class="badge-status badge-disponible mt-2">Disponible</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="seance-info-grid">
                                        <div class="seance-info-item">
                                            <i class="bi bi-hourglass-split"></i>
                                            <span>${seance.film.duree} minutes</span>
                                        </div>
                                        <div class="seance-info-item">
                                            <i class="bi bi-tag"></i>
                                            <span><fmt:formatNumber value="${seance.prixBase}" type="currency" currencySymbol="Ar" /></span>
                                        </div>
                                        <div class="seance-info-item">
                                            <i class="bi bi-people"></i>
                                            <span>${seance.placesVendues} / ${seance.placesTotales} places</span>
                                        </div>
                                        <div class="seance-info-item">
                                            <i class="bi bi-shield-check"></i>
                                            <%-- <span>${seance.film.classification.nom}</span> --%>
                                        </div>
                                    </div>
                                    
                                    <!-- Barre de disponibilité -->
                                    <div class="availability-bar">
                                        <c:set var="tauxRemplissage" value="${seance.tauxRemplissage}" />
                                        <c:choose>
                                            <c:when test="${tauxRemplissage < 50}">
                                                <div class="availability-fill low" style="width: ${tauxRemplissage}%"></div>
                                            </c:when>
                                            <c:when test="${tauxRemplissage < 85}">
                                                <div class="availability-fill medium" style="width: ${tauxRemplissage}%"></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="availability-fill high" style="width: ${tauxRemplissage}%"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="availability-text">
                                        <span><strong>${seance.placesDisponibles}</strong> places restantes</span>
                                        <span>Taux de remplissage: <strong>${tauxRemplissage}%</strong></span>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="d-flex gap-2 mt-3">
                                        <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}" 
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye me-1"></i>Détails
                                        </a>
                                        
                                        <c:if test="${seance.disponible and not seance.complet}">
                                            <a href="${pageContext.request.contextPath}/ventes/seance/${seance.idSeance}/reserver" 
                                               class="btn btn-sm btn-reserve">
                                                <i class="bi bi-ticket-perforated me-1"></i>Réserver
                                            </a>
                                        </c:if>
                                        
                                        <c:if test="${userDetail.admin or userDetail.manager}">
                                            <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}/modifier" 
                                               class="btn btn-sm btn-outline-secondary">
                                                <i class="bi bi-pencil me-1"></i>Modifier
                                            </a>
                                            
                                            <c:if test="${seance.placesVendues == 0}">
                                                <form action="${pageContext.request.contextPath}/seances/${seance.idSeance}/annuler" 
                                                      method="post" class="d-inline"
                                                      onsubmit="return confirm('Confirmer l\'annulation de cette séance ?');">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="bi bi-x-circle me-1"></i>Annuler
                                                    </button>
                                                </form>
                                            </c:if>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Statistiques -->
                    <div class="mt-4 text-muted text-center">
                        <i class="bi bi-info-circle me-2"></i>
                        Total: <strong>${seances.size()}</strong> séance(s) programmée(s)
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
