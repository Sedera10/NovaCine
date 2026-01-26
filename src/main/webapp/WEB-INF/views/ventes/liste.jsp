<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Liste des Ventes</title>
    
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
        }
        
        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            color: white;
        }
        
        .table-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 1rem;
        }
        
        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }
        
        .badge-paye {
            background-color: #28a745;
        }
        
        .badge-encours {
            background-color: #ffc107;
            color: #000;
        }
        
        .badge-annule {
            background-color: #dc3545;
        }
        
        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            color: #6c757d;
            text-transform: uppercase;
            font-size: 0.8rem;
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
                            <i class="bi bi-receipt me-2"></i>Ventes
                        </h1>
                        <p class="mb-0 text-muted">Historique des ventes de billets</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/achats/nouveau" class="btn btn-primary-custom btn-lg">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle vente
                    </a>
                </div>
            </div>
            
            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Statistiques rapides -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">${achats.size()}</div>
                        <div class="stat-label">Total ventes</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">
                            <fmt:formatNumber value="${chiffreAffaires}" pattern="#,##0"/> Ar
                        </div>
                        <div class="stat-label">Chiffre d'affaires</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">${totalBillets}</div>
                        <div class="stat-label">Billets vendus</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <c:set var="ventesAujourdhui" value="0"/>
                        <div class="stat-value">${ventesAujourdhui}</div>
                        <div class="stat-label">Ventes aujourd'hui</div>
                    </div>
                </div>
            </div>
            
            <!-- Tableau des ventes -->
            <div class="table-card">
                <c:choose>
                    <c:when test="${empty achats}">
                        <div class="text-center py-5">
                            <i class="bi bi-inbox display-1 text-muted"></i>
                            <h4 class="mt-3 text-muted">Aucune vente enregistrée</h4>
                            <p class="text-muted">Commencez par créer une nouvelle vente</p>
                            <a href="${pageContext.request.contextPath}/achats/nouveau" class="btn btn-primary-custom">
                                <i class="bi bi-plus-circle me-2"></i>Nouvelle vente
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Date/Heure</th>
                                    <th>Client</th>
                                    <th>Film</th>
                                    <th>Séance</th>
                                    <th>Nb Billets</th>
                                    <th>Montant</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="achat" items="${achats}">
                                    <tr>
                                        <td><strong>#${achat.idAchat}</strong></td>
                                        <td>
                                            <fmt:parseDate value="${achat.dtAchat}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDt" type="both"/>
                                            <fmt:formatDate value="${parsedDt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>${empty achat.nomClient ? 'Anonyme' : achat.nomClient}</td>
                                        <td>${achat.seance.film.titre}</td>
                                        <td>
                                            <fmt:parseDate value="${achat.seance.dateSeance}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM"/> 
                                            à ${achat.seance.heureSeance}
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary">${nbBilletsAchats[achat.idAchat]}</span>
                                        </td>
                                        <td>
                                            <strong>
                                                <fmt:formatNumber value="${totauxAchats[achat.idAchat]}" pattern="#,##0"/> Ar
                                            </strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${achat.statut == 'PAYE'}">
                                                    <span class="badge badge-paye">Payé</span>
                                                </c:when>
                                                <c:when test="${achat.statut == 'EN_COURS'}">
                                                    <span class="badge badge-encours">En cours</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-annule">Annulé</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/achats/${achat.idAchat}" 
                                               class="btn btn-sm btn-outline-primary" title="Voir détails">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
