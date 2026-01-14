<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Ventes</title>
    
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
        
        .filter-card {
            background: white;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .vente-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            transition: transform 0.2s;
            border-left: 4px solid #dee2e6;
        }
        
        .vente-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.12);
        }
        
        .vente-card.vendu {
            border-left-color: #28a745;
        }
        
        .vente-card.utilise {
            border-left-color: #17a2b8;
        }
        
        .vente-card.annule {
            border-left-color: #dc3545;
            opacity: 0.7;
        }
        
        .vente-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .vente-id {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .vente-film {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .vente-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .vente-info-item {
            display: flex;
            align-items: center;
            color: #495057;
            font-size: 0.95rem;
        }
        
        .vente-info-item i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
        
        .seat-badge {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            padding: 6px 14px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .badge-statut {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-vendu {
            background-color: #28a745;
            color: white;
        }
        
        .badge-utilise {
            background-color: #17a2b8;
            color: white;
        }
        
        .badge-annule {
            background-color: #dc3545;
            color: white;
        }
        
        .badge-rembourse {
            background-color: #6c757d;
            color: white;
        }
        
        .badge-canal {
            background-color: #e9ecef;
            color: #495057;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.75rem;
        }
        
        .transaction-group {
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 4px;
            padding: 0.5rem 1rem;
            margin-bottom: 1rem;
            display: inline-block;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
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
                        <h1 class="mb-2"><i class="bi bi-ticket-perforated me-2"></i>Gestion des Ventes</h1>
                        <p class="mb-0 opacity-75">Historique et suivi des billets vendus</p>
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
            
            <!-- Filtres -->
            <div class="filter-card">
                <form action="${pageContext.request.contextPath}/achats/liste" method="get" class="row g-3">
                    <div class="col-md-12">
                        <p class="text-muted mb-0">
                            <i class="bi bi-info-circle me-2"></i>
                            Liste de tous les achats effectués
                        </p>
                    </div>
                </form>
            </div>
            
            <!-- Liste des Ventes -->
            <c:choose>
                <c:when test="${empty achats}">
                    <div class="empty-state">
                        <i class="bi bi-ticket"></i>
                        <h3>Aucune vente trouvée</h3>
                        <p>Il n'y a aucune vente correspondant aux critères sélectionnés.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach var="vente" items="${achats}">
                            <div class="col-12">
                                <div class="vente-card">
                                    <div class="vente-header">
                                        <div class="flex-grow-1">
                                            <div class="vente-id mb-1">
                                                Achat #${vente.idAchat}
                                            </div>
                                            <div class="vente-film mb-2">
                                                <i class="bi bi-film me-2"></i>${vente.billets[0].seance.film.titre}
                                            </div>
                                            <div class="d-flex gap-2 align-items-center">
                                                <span class="seat-badge">${vente.billets[0].place.rangee}${vente.billets[0].place.numero}</span>
                                                <span class="badge bg-success">Confirmé</span>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="h4 mb-0 text-primary">
                                                ${vente.total} Ar
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="vente-info-grid">
                                        <div class="vente-info-item">
                                            <i class="bi bi-calendar-event"></i>
                                            <span>${vente.billets[0].seance.daty}</span>
                                        </div>
                                        <div class="vente-info-item">
                                            <i class="bi bi-clock"></i>
                                            <span>${vente.billets[0].seance.heure}</span>
                                        </div>
                                        <div class="vente-info-item">
                                            <i class="bi bi-door-open"></i>
                                            <span>${vente.billets[0].seance.salle.nom}</span>
                                        </div>
                                        <div class="vente-info-item">
                                            <i class="bi bi-person"></i>
                                            <span>${vente.nomAcheteur}</span>
                                        </div>
                                        <div class="vente-info-item">
                                            <i class="bi bi-clock-history"></i>
                                            <span>${vente.dtAchat}</span>
                                        </div>
                                        <div class="vente-info-item">
                                            <i class="bi bi-ticket-detailed"></i>
                                            <span>${vente.billets.size()} billet(s)</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="d-flex gap-2 mt-2">
                                        <a href="${pageContext.request.contextPath}/achats/confirmation/${vente.idAchat}" 
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye me-1"></i>Détails
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Statistiques -->
                    <div class="mt-4 text-muted text-center">
                        <i class="bi bi-info-circle me-2"></i>
                        Total: <strong>${achats.size()}</strong> achat(s)
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
