<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Détail Achat #${achat.idAchat}</title>
    
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
        
        .ticket-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .ticket-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #1a3a5c 100%);
            color: white;
            padding: 2rem;
        }
        
        .ticket-body {
            padding: 2rem;
        }
        
        .ticket-footer {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #e0a800 100%);
            padding: 1.5rem 2rem;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px dashed #dee2e6;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .info-value {
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .ligne-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.75rem;
        }
        
        .total-amount {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .badge-paye {
            background-color: #28a745;
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        
        .badge-encours {
            background-color: #ffc107;
            color: #000;
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        
        .badge-annule {
            background-color: #dc3545;
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        
        .btn-print {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-print:hover {
            background-color: #164a7a;
            color: white;
        }
        
        @media print {
            .main-content {
                margin-left: 0;
            }
            .sidebar, .page-header, .btn {
                display: none !important;
            }
            .ticket-card {
                box-shadow: none;
                border: 1px solid #000;
            }
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
                            <i class="bi bi-receipt me-2"></i>Achat #${achat.idAchat}
                        </h1>
                        <p class="mb-0 text-muted">
                            <fmt:parseDate value="${achat.dtAchat}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDt" type="both"/>
                            Effectué le <fmt:formatDate value="${parsedDt}" pattern="dd/MM/yyyy à HH:mm"/>
                        </p>
                    </div>
                    <div class="d-flex gap-2">
                        <button onclick="window.print()" class="btn btn-print">
                            <i class="bi bi-printer me-2"></i>Imprimer
                        </button>
                        <a href="${pageContext.request.contextPath}/achats" class="btn btn-outline-secondary">
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
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <!-- Ticket -->
                    <div class="ticket-card">
                        <!-- Header -->
                        <div class="ticket-header">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-1">${achat.seance.film.titre}</h2>
                                    <p class="mb-0 opacity-75">
                                        <i class="bi bi-geo-alt me-1"></i>${achat.seance.salle.nom}
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <c:choose>
                                        <c:when test="${achat.statut == 'PAYE'}">
                                            <span class="badge badge-paye"><i class="bi bi-check-circle me-1"></i>Payé</span>
                                        </c:when>
                                        <c:when test="${achat.statut == 'EN_COURS'}">
                                            <span class="badge badge-encours"><i class="bi bi-hourglass me-1"></i>En cours</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-annule"><i class="bi bi-x-circle me-1"></i>Annulé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Body -->
                        <div class="ticket-body">
                            <!-- Infos séance -->
                            <div class="mb-4">
                                <h5 class="text-muted mb-3"><i class="bi bi-info-circle me-2"></i>Informations</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-row">
                                            <span class="info-label">Date de la séance</span>
                                            <span class="info-value">
                                                <fmt:parseDate value="${achat.seance.dateSeance}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="EEEE dd MMMM yyyy"/>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Heure</span>
                                            <span class="info-value">${achat.seance.heureSeance}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-row">
                                            <span class="info-label">Client</span>
                                            <span class="info-value">${empty achat.nomClient ? 'Anonyme' : achat.nomClient}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">N° Achat</span>
                                            <span class="info-value">#${achat.idAchat}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Lignes d'achat -->
                            <div class="mb-4">
                                <h5 class="text-muted mb-3"><i class="bi bi-ticket-perforated me-2"></i>Billets</h5>
                                
                                <c:forEach var="ligne" items="${achat.lignes}">
                                    <c:set var="ligneDetails" value="${detailsLignes[ligne.idAchatLigne]}"/>
                                    <div class="ligne-item">
                                        <div class="row align-items-center">
                                            <div class="col-md-4">
                                                <strong>${ligne.typePlace.nom}</strong>
                                                <br>
                                                <small class="text-muted">${ligne.typeClient.nom}</small>
                                            </div>
                                            <div class="col-md-2 text-center">
                                                <span class="badge bg-secondary fs-6">x${ligne.quantite}</span>
                                            </div>
                                            <div class="col-md-3 text-center">
                                                <small class="text-muted">
                                                    <fmt:formatNumber value="${ligneDetails.prixUnitaire}" pattern="#,##0"/> Ar/unité
                                                </small>
                                            </div>
                                            <div class="col-md-3 text-end">
                                                <strong class="text-success">
                                                    <fmt:formatNumber value="${ligneDetails.sousTotal}" pattern="#,##0"/> Ar
                                                </strong>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <!-- Footer - Total -->
                        <div class="ticket-footer">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-0">${nbBillets} billet(s)</h5>
                                    <small class="opacity-75">
                                        <c:choose>
                                            <c:when test="${achat.statut == 'PAYE'}">Statut : Payé</c:when>
                                            <c:when test="${achat.statut == 'EN_COURS'}">Statut : En attente de paiement</c:when>
                                            <c:otherwise>Statut : Annulé</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                                <div class="col-md-6 text-end">
                                    <div class="text-uppercase small fw-bold">Total à payer</div>
                                    <div class="total-amount">
                                        <fmt:formatNumber value="${totalCalcule}" pattern="#,##0"/> Ar
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Actions supplémentaires -->
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/achats/nouveau" class="btn btn-outline-primary btn-lg">
                            <i class="bi bi-plus-circle me-2"></i>Nouvelle vente
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
