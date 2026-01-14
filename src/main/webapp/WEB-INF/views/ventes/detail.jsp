<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Détails Vente</title>
    
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
        }
        
        .page-header {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .ticket-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 2px dashed #dee2e6;
        }
        
        .ticket-header {
            text-align: center;
            padding: 2rem 0;
            border-bottom: 2px dashed #dee2e6;
            margin-bottom: 2rem;
        }
        
        .ticket-id {
            font-family: 'Courier New', monospace;
            font-size: 1.2rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .ticket-film {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .seat-display {
            background: linear-gradient(135deg, var(--secondary-color), #ffb300);
            color: var(--primary-color);
            padding: 1rem 2rem;
            border-radius: 10px;
            font-size: 2.5rem;
            font-weight: 700;
            display: inline-block;
        }
        
        .detail-section {
            margin-bottom: 2rem;
        }
        
        .detail-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 0.5rem;
        }
        
        .info-row {
            display: flex;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 200px;
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
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .status-vendu {
            background-color: #28a745;
            color: white;
        }
        
        .status-utilise {
            background-color: #17a2b8;
            color: white;
        }
        
        .status-annule {
            background-color: #dc3545;
            color: white;
        }
        
        .status-rembourse {
            background-color: #6c757d;
            color: white;
        }
        
        .qr-display {
            width: 200px;
            height: 200px;
            background: white;
            border: 3px solid #dee2e6;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }
        
        .qr-display i {
            font-size: 5rem;
            color: #6c757d;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 40px;
            padding-bottom: 1.5rem;
        }
        
        .timeline-item:last-child {
            padding-bottom: 0;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: 12px;
            top: 0;
            bottom: -1.5rem;
            width: 2px;
            background-color: #dee2e6;
        }
        
        .timeline-item:last-child::before {
            display: none;
        }
        
        .timeline-icon {
            position: absolute;
            left: 0;
            width: 26px;
            height: 26px;
            background-color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
        }
        
        .timeline-content {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 6px;
        }
        
        .transaction-group-card {
            background: linear-gradient(135deg, #fff3cd, #ffe69c);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .other-ticket {
            background: white;
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 0.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 12px 30px;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
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
                        <h1 class="mb-2"><i class="bi bi-ticket-detailed me-2"></i>Détails du Billet</h1>
                        <p class="mb-0 text-muted">Informations complètes de la vente</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/ventes" class="btn btn-outline-secondary">
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
                <!-- Colonne principale -->
                <div class="col-lg-8">
                    
                    <!-- Billet -->
                    <div class="ticket-card">
                        <div class="ticket-header">
                            <div class="ticket-id">Billet #{vente.idVente}</div>
                            <div class="ticket-film">${vente.seance.film.titre}</div>
                            <div class="seat-display">${vente.siege.rangee}${vente.siege.numero}</div>
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${vente.statut == 'VENDU'}">
                                        <span class="status-badge status-vendu">
                                            <i class="bi bi-check-circle me-2"></i>Vendu
                                        </span>
                                    </c:when>
                                    <c:when test="${vente.statut == 'UTILISE'}">
                                        <span class="status-badge status-utilise">
                                            <i class="bi bi-ticket-perforated me-2"></i>Utilisé
                                        </span>
                                    </c:when>
                                    <c:when test="${vente.statut == 'ANNULE'}">
                                        <span class="status-badge status-annule">
                                            <i class="bi bi-x-circle me-2"></i>Annulé
                                        </span>
                                    </c:when>
                                    <c:when test="${vente.statut == 'REMBOURSE'}">
                                        <span class="status-badge status-rembourse">
                                            <i class="bi bi-cash me-2"></i>Remboursé
                                        </span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Détails Séance -->
                        <div class="detail-section">
                            <h5><i class="bi bi-calendar-event me-2"></i>Séance</h5>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-calendar3"></i>Date</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${vente.seance.dtSeance}" pattern="EEEE d MMMM yyyy" />
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-clock"></i>Horaire</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${vente.seance.heureDebut}" pattern="HH:mm" /> - 
                                    <fmt:formatDate value="${vente.seance.heureFin}" pattern="HH:mm" />
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-door-open"></i>Salle</div>
                                <div class="info-value">${vente.seance.salle.nom}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-hourglass-split"></i>Durée</div>
                                <div class="info-value">${vente.seance.film.duree} minutes</div>
                            </div>
                        </div>
                        
                        <!-- Détails Vente -->
                        <div class="detail-section">
                            <h5><i class="bi bi-receipt me-2"></i>Transaction</h5>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-tag"></i>Prix</div>
                                <div class="info-value">
                                    <strong class="text-primary" style="font-size: 1.5rem;">
                                        <fmt:formatNumber value="${vente.prixUnitaire}" type="currency" currencySymbol="Ar" />
                                    </strong>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label"><i class="bi bi-shop"></i>Canal</div>
                                <div class="info-value">${vente.canalVente}</div>
                            </div>
                            <c:if test="${not empty vente.idTransaction}">
                                <div class="info-row">
                                    <div class="info-label"><i class="bi bi-link"></i>Transaction</div>
                                    <div class="info-value">
                                        <code>${vente.idTransaction}</code>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Client -->
                        <c:if test="${not empty vente.client}">
                            <div class="detail-section">
                                <h5><i class="bi bi-person me-2"></i>Client</h5>
                                <div class="info-row">
                                    <div class="info-label"><i class="bi bi-person-badge"></i>Nom</div>
                                    <div class="info-value">${vente.client.nom} ${vente.client.prenom}</div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label"><i class="bi bi-envelope"></i>Email</div>
                                    <div class="info-value">${vente.client.email}</div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label"><i class="bi bi-telephone"></i>Téléphone</div>
                                    <div class="info-value">${vente.client.telephone}</div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label"><i class="bi bi-star"></i>Type</div>
                                    <div class="info-value">${vente.client.typeClient}</div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Historique -->
                        <div class="detail-section">
                            <h5><i class="bi bi-clock-history me-2"></i>Historique</h5>
                            
                            <div class="timeline-item">
                                <div class="timeline-icon"><i class="bi bi-cart-plus"></i></div>
                                <div class="timeline-content">
                                    <strong>Vente effectuée</strong>
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${vente.dtVente}" pattern="d MMMM yyyy à HH:mm" />
                                    </div>
                                    <c:if test="${not empty vente.userVendeur}">
                                        <div class="small">Par: ${vente.userVendeur.nom}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <c:if test="${not empty vente.dtUtilisation}">
                                <div class="timeline-item">
                                    <div class="timeline-icon"><i class="bi bi-check2"></i></div>
                                    <div class="timeline-content">
                                        <strong>Billet scanné/utilisé</strong>
                                        <div class="text-muted small">
                                            <fmt:formatDate value="${vente.dtUtilisation}" pattern="d MMMM yyyy à HH:mm" />
                                        </div>
                                        <c:if test="${not empty vente.userControleur}">
                                            <div class="small">Par: ${vente.userControleur.nom}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty vente.dtAnnulation}">
                                <div class="timeline-item">
                                    <div class="timeline-icon"><i class="bi bi-x"></i></div>
                                    <div class="timeline-content">
                                        <strong>Billet annulé</strong>
                                        <div class="text-muted small">
                                            <fmt:formatDate value="${vente.dtAnnulation}" pattern="d MMMM yyyy à HH:mm" />
                                        </div>
                                        <c:if test="${not empty vente.userAnnuleur}">
                                            <div class="small">Par: ${vente.userAnnuleur.nom}</div>
                                        </c:if>
                                        <c:if test="${not empty vente.motifAnnulation}">
                                            <div class="alert alert-warning small mt-2 mb-0">
                                                <strong>Motif:</strong> ${vente.motifAnnulation}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Billets de la même transaction -->
                    <c:if test="${not empty ventesTransaction and ventesTransaction.size() > 1}">
                        <div class="transaction-group-card">
                            <h5 class="mb-3">
                                <i class="bi bi-link me-2"></i>
                                Billets de la même réservation (${ventesTransaction.size()} billets)
                            </h5>
                            <c:forEach var="autre" items="${ventesTransaction}">
                                <c:if test="${autre.idVente != vente.idVente}">
                                    <div class="other-ticket">
                                        <div>
                                            <strong>Siège ${autre.siege.rangee}${autre.siege.numero}</strong>
                                            <small class="text-muted ms-2">#${autre.idVente}</small>
                                        </div>
                                        <div>
                                            <span class="badge bg-secondary">${autre.statut}</span>
                                            <a href="${pageContext.request.contextPath}/ventes/${autre.idVente}" 
                                               class="btn btn-sm btn-outline-primary ms-2">Voir</a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
                
                <!-- Colonne droite -->
                <div class="col-lg-4">
                    <!-- QR Code -->
                    <div class="ticket-card text-center">
                        <h5 class="mb-3">Code de Vérification</h5>
                        <div class="qr-display">
                            <i class="bi bi-qr-code"></i>
                        </div>
                        <small class="text-muted d-block mt-3">
                            Scannez ce code à l'entrée
                        </small>
                    </div>
                    
                    <!-- Actions -->
                    <div class="d-grid gap-2">
                        <button onclick="window.print()" class="btn btn-primary-custom">
                            <i class="bi bi-printer me-2"></i>Imprimer
                        </button>
                        
                        <c:if test="${vente.statut == 'VENDU'}">
                            <form action="${pageContext.request.contextPath}/ventes/${vente.idVente}/utiliser" 
                                  method="post">
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="bi bi-check-circle me-2"></i>Scanner le billet
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${(vente.statut == 'VENDU' or vente.statut == 'UTILISE') and (userDetail.admin or userDetail.manager)}">
                            <button type="button" class="btn btn-outline-danger" 
                                    onclick="$('#annulationModal').modal('show')">
                                <i class="bi bi-x-circle me-2"></i>Annuler la vente
                            </button>
                        </c:if>
                        
                        <a href="${pageContext.request.contextPath}/seances/${vente.seance.idSeance}" 
                           class="btn btn-outline-secondary">
                            <i class="bi bi-calendar-event me-2"></i>Voir la séance
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Annulation -->
    <div class="modal fade" id="annulationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Annuler la vente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/ventes/${vente.idVente}/annuler" method="post">
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Cette action est irréversible. Le client sera remboursé.
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Motif d'annulation <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="motif" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                        <button type="submit" class="btn btn-danger">Confirmer l'annulation</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
