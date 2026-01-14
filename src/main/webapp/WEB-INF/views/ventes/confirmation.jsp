<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Confirmation Réservation</title>
    
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
        
        .success-header {
            text-align: center;
            padding: 3rem 0;
        }
        
        .success-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            animation: scaleIn 0.5s ease-out;
        }
        
        .success-icon i {
            font-size: 4rem;
            color: white;
        }
        
        @keyframes scaleIn {
            0% {
                transform: scale(0);
            }
            100% {
                transform: scale(1);
            }
        }
        
        .confirmation-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        
        .transaction-id-box {
            background: linear-gradient(135deg, var(--primary-color), #164a7a);
            color: white;
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .transaction-id-box h4 {
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .transaction-id-box h2 {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            letter-spacing: 2px;
        }
        
        .ticket-item {
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background-color: #f8f9fa;
        }
        
        .ticket-item:last-child {
            margin-bottom: 0;
        }
        
        .ticket-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .seat-badge {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .ticket-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }
        
        .info-item i {
            color: var(--primary-color);
            margin-right: 0.5rem;
            font-size: 1.1rem;
        }
        
        .total-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
        }
        
        .total-box h3 {
            color: var(--primary-color);
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }
        
        .total-box p {
            margin: 0;
            color: #6c757d;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 2rem;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 12px 30px;
            font-weight: 600;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
        }
        
        .qr-placeholder {
            width: 150px;
            height: 150px;
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }
        
        .qr-placeholder i {
            font-size: 3rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            
            <!-- Success Header -->
            <div class="success-header">
                <div class="success-icon">
                    <i class="bi bi-check-lg"></i>
                </div>
                <h1 class="mb-2">Réservation Confirmée !</h1>
                <p class="text-muted">Vos billets ont été réservés avec succès</p>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    
                    <!-- Transaction ID -->
                    <div class="transaction-id-box">
                        <h4>Numéro de Transaction</h4>
                        <h2>${transaction}</h2>
                    </div>
                    
                    <!-- Billets -->
                    <div class="confirmation-card">
                        <h5 class="mb-3"><i class="bi bi-ticket-perforated me-2"></i>Vos Billets</h5>
                        
                        <c:forEach var="vente" items="${ventes}">
                            <div class="ticket-item">
                                <div class="ticket-header">
                                    <div>
                                        <h5 class="mb-1">${vente.seance.film.titre}</h5>
                                        <small class="text-muted">Billet #${vente.idVente}</small>
                                    </div>
                                    <div class="seat-badge">
                                        ${vente.siege.rangee}${vente.siege.numero}
                                    </div>
                                </div>
                                
                                <div class="ticket-info">
                                    <div class="info-item">
                                        <i class="bi bi-calendar-event"></i>
                                        <span><fmt:formatDate value="${vente.seance.dtSeance}" pattern="d MMM yyyy" /></span>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-clock"></i>
                                        <span><fmt:formatDate value="${vente.seance.heureDebut}" pattern="HH:mm" /></span>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-door-open"></i>
                                        <span>${vente.seance.salle.nom}</span>
                                    </div>
                                    <div class="info-item">
                                        <i class="bi bi-tag"></i>
                                        <span><fmt:formatNumber value="${vente.prixUnitaire}" type="currency" currencySymbol="Ar" /></span>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty vente.client}">
                                    <div class="mt-3 pt-3 border-top">
                                        <small class="text-muted">
                                            <i class="bi bi-person me-1"></i>
                                            ${vente.client.nom} ${vente.client.prenom}
                                        </small>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Total -->
                    <div class="confirmation-card">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="total-box">
                                    <p class="mb-2">Montant Total</p>
                                    <h3>
                                        <fmt:formatNumber value="${ventes.stream().map(v -> v.prixUnitaire).reduce(0, (a,b) -> a.add(b))}" 
                                                         type="currency" currencySymbol="Ar" />
                                    </h3>
                                    <small class="text-muted">${ventes.size()} billet(s)</small>
                                </div>
                            </div>
                            <div class="col-md-6 text-center">
                                <div class="qr-placeholder">
                                    <i class="bi bi-qr-code"></i>
                                </div>
                                <small class="text-muted d-block mt-2">Code QR de vérification</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Informations Importantes -->
                    <div class="confirmation-card">
                        <h5 class="mb-3"><i class="bi bi-info-circle me-2"></i>Informations Importantes</h5>
                        <ul class="mb-0">
                            <li>Présentez-vous 15 minutes avant le début de la séance</li>
                            <li>Munissez-vous de votre numéro de transaction: <strong>${transaction}</strong></li>
                            <li>Les billets peuvent être annulés jusqu'à 2 heures avant la séance</li>
                            <li>Conservez ce numéro pour tout échange ou remboursement</li>
                        </ul>
                    </div>
                    
                    <!-- Actions -->
                    <div class="action-buttons">
                        <button onclick="window.print()" class="btn btn-primary-custom">
                            <i class="bi bi-printer me-2"></i>Imprimer les billets
                        </button>
                        <a href="${pageContext.request.contextPath}/seances" class="btn btn-outline-primary">
                            <i class="bi bi-calendar-event me-2"></i>Voir les séances
                        </a>
                        <a href="${pageContext.request.contextPath}/ventes" class="btn btn-outline-secondary">
                            <i class="bi bi-ticket-perforated me-2"></i>Mes ventes
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animation des billets
        document.querySelectorAll('.ticket-item').forEach((ticket, index) => {
            setTimeout(() => {
                ticket.style.animation = 'slideIn 0.5s ease-out';
            }, index * 100);
        });
    </script>
</body>
</html>
