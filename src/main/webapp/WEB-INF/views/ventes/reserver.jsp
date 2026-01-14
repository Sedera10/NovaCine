<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Réservation</title>
    
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
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .seance-info-card {
            background: linear-gradient(135deg, var(--primary-color), #164a7a);
            color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .seance-info-card h4 {
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .cinema-screen {
            background: linear-gradient(to bottom, #ddd, #fff);
            border: 2px solid #999;
            border-radius: 50% 50% 0 0;
            height: 40px;
            margin: 0 auto 30px;
            width: 80%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
        }
        
        .seat-map-container {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            margin-bottom: 1.5rem;
        }
        
        .seat-grid {
            display: grid;
            gap: 10px;
            justify-content: center;
            margin-bottom: 2rem;
        }
        
        .seat-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .row-label {
            font-weight: 700;
            color: var(--primary-color);
            width: 40px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .seat {
            width: 45px;
            height: 45px;
            border: 2px solid #ddd;
            border-radius: 8px 8px 0 0;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 600;
            transition: all 0.2s;
            position: relative;
        }
        
        .seat.disponible {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
        }
        
        .seat.disponible:hover {
            background-color: #218838;
            transform: scale(1.1);
        }
        
        .seat.selectionne {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            border-color: var(--secondary-color);
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(255, 193, 7, 0.4);
        }
        
        .seat.vendu {
            background-color: #dc3545;
            color: white;
            border-color: #dc3545;
            cursor: not-allowed;
        }
        
        .seat.hors-service {
            background-color: #6c757d;
            color: white;
            border-color: #6c757d;
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        .seat-legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .legend-box {
            width: 30px;
            height: 30px;
            border-radius: 6px 6px 0 0;
            border: 2px solid currentColor;
        }
        
        .sidebar-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            position: sticky;
            top: 20px;
        }
        
        .selection-summary {
            margin-bottom: 1.5rem;
        }
        
        .selected-seats-list {
            max-height: 200px;
            overflow-y: auto;
            margin-bottom: 1rem;
        }
        
        .selected-seat-badge {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
            margin: 3px;
        }
        
        .total-price {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
        }
        
        .total-price h3 {
            color: var(--primary-color);
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
        }
        
        .btn-valider {
            background: linear-gradient(135deg, var(--secondary-color), #ffb300);
            border: none;
            color: var(--primary-color);
            font-weight: 700;
            padding: 15px;
            font-size: 1.1rem;
            width: 100%;
            border-radius: 8px;
        }
        
        .btn-valider:hover {
            transform: scale(1.02);
            box-shadow: 0 6px 16px rgba(255, 193, 7, 0.5);
        }
        
        .btn-valider:disabled {
            background: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
        }
        
        .client-section {
            border-top: 2px solid #f0f0f0;
            padding-top: 1rem;
            margin-top: 1rem;
        }
        
        #newClientFields {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 6px;
            margin-top: 1rem;
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
                        <h1 class="mb-2"><i class="bi bi-ticket-perforated me-2"></i>Réservation de Places</h1>
                        <p class="mb-0 text-muted">Sélectionnez vos sièges</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour
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
            
            <!-- Info Séance -->
            <div class="seance-info-card">
                <div class="row">
                    <div class="col-md-8">
                        <h4><i class="bi bi-film me-2"></i>${seance.film.titre}</h4>
                        <div class="d-flex gap-4 flex-wrap">
                            <span><i class="bi bi-calendar-event me-2"></i><fmt:formatDate value="${seance.dtSeance}" pattern="EEEE d MMMM yyyy" /></span>
                            <span><i class="bi bi-clock me-2"></i><fmt:formatDate value="${seance.heureDebut}" pattern="HH:mm" /></span>
                            <span><i class="bi bi-door-open me-2"></i>${seance.salle.nom}</span>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="h5 mb-0">Prix unitaire</div>
                        <div class="h2 mb-0 fw-bold"><fmt:formatNumber value="${seance.prixBase}" type="currency" currencySymbol="Ar" /></div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Plan de salle -->
                <div class="col-lg-8">
                    <div class="seat-map-container">
                        <div class="cinema-screen">
                            <i class="bi bi-badge-3d me-2"></i>ÉCRAN
                        </div>
                        
                        <div class="seat-grid" id="seatMap">
                            <!-- Les sièges seront générés par JavaScript -->
                        </div>
                        
                        <div class="seat-legend">
                            <div class="legend-item">
                                <div class="legend-box" style="background-color: #28a745; border-color: #28a745;"></div>
                                <span>Disponible</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box" style="background-color: #FFC107; border-color: #FFC107;"></div>
                                <span>Sélectionné</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box" style="background-color: #dc3545; border-color: #dc3545;"></div>
                                <span>Vendu</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box" style="background-color: #6c757d; border-color: #6c757d;"></div>
                                <span>Hors service</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Récapitulatif -->
                <div class="col-lg-4">
                    <div class="sidebar-card">
                        <h5 class="mb-3"><i class="bi bi-cart3 me-2"></i>Récapitulatif</h5>
                        
                        <div class="selection-summary">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Places sélectionnées:</span>
                                <strong id="nbPlaces">0</strong>
                            </div>
                            <div class="selected-seats-list" id="selectedSeatsList">
                                <small class="text-muted">Cliquez sur les sièges pour sélectionner</small>
                            </div>
                        </div>
                        
                        <div class="total-price text-center">
                            <div class="text-muted mb-1">Total à payer</div>
                            <h3 id="totalPrice">0 Ar</h3>
                        </div>
                        
                        <!-- Formulaire -->
                        <form action="${pageContext.request.contextPath}/ventes/creer" method="post" id="reservationForm">
                            <input type="hidden" name="idSeance" value="${seance.idSeance}">
                            <input type="hidden" name="prixUnitaire" value="${seance.prixBase}">
                            <input type="hidden" name="canalVente" value="GUICHET">
                            <input type="hidden" name="idsSieges" id="idsSiegesInput" value="">
                            
                            <div class="client-section">
                                <label class="form-label fw-bold">Client</label>
                                <select class="form-select mb-2" name="idClient" id="clientSelect">
                                    <option value="">-- Nouveau client --</option>
                                    <c:forEach var="client" items="${clients}">
                                        <option value="${client.idClient}">
                                            ${client.nom} ${client.prenom} - ${client.email}
                                        </option>
                                    </c:forEach>
                                </select>
                                
                                <div id="newClientFields" style="display: none;">
                                    <h6 class="mb-2">Nouveau client</h6>
                                    <input type="text" class="form-control form-control-sm mb-2" name="nomClient" placeholder="Nom">
                                    <input type="text" class="form-control form-control-sm mb-2" name="prenomClient" placeholder="Prénom">
                                    <input type="email" class="form-control form-control-sm mb-2" name="emailClient" placeholder="Email">
                                    <input type="tel" class="form-control form-control-sm" name="telephoneClient" placeholder="Téléphone">
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-valider mt-3" id="btnValider" disabled>
                                <i class="bi bi-check-circle me-2"></i>Valider la réservation
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Données
        const sieges = ${siegesJson};
        const siegesVendus = ${siegesVendusJson};
        const prixBase = ${seance.prixBase};
        
        let selectedSeats = [];
        
        // Organiser les sièges par rangée
        const siegesByRow = {};
        sieges.forEach(siege => {
            if (!siegesByRow[siege.rangee]) {
                siegesByRow[siege.rangee] = [];
            }
            siegesByRow[siege.rangee].push(siege);
        });
        
        // Générer le plan de salle
        const seatMap = document.getElementById('seatMap');
        Object.keys(siegesByRow).sort().forEach(rangee => {
            const rowDiv = document.createElement('div');
            rowDiv.className = 'seat-row';
            
            const label = document.createElement('div');
            label.className = 'row-label';
            label.textContent = rangee;
            rowDiv.appendChild(label);
            
            siegesByRow[rangee].sort((a, b) => a.numero - b.numero).forEach(siege => {
                const seatDiv = document.createElement('div');
                seatDiv.className = 'seat';
                seatDiv.dataset.idSiege = siege.idSiege;
                seatDiv.textContent = siege.numero;
                
                if (siege.statut === 'HORS_SERVICE') {
                    seatDiv.classList.add('hors-service');
                } else if (siegesVendus.includes(siege.idSiege)) {
                    seatDiv.classList.add('vendu');
                } else {
                    seatDiv.classList.add('disponible');
                    seatDiv.addEventListener('click', () => toggleSeat(siege.idSiege, rangee + siege.numero));
                }
                
                rowDiv.appendChild(seatDiv);
            });
            
            seatMap.appendChild(rowDiv);
        });
        
        // Toggle siège
        function toggleSeat(idSiege, label) {
            const seatDiv = document.querySelector(`.seat[data-id-siege="${idSiege}"]`);
            
            if (selectedSeats.includes(idSiege)) {
                selectedSeats = selectedSeats.filter(id => id !== idSiege);
                seatDiv.classList.remove('selectionne');
                seatDiv.classList.add('disponible');
            } else {
                selectedSeats.push(idSiege);
                seatDiv.classList.remove('disponible');
                seatDiv.classList.add('selectionne');
            }
            
            updateSummary();
        }
        
        // Mettre à jour le récapitulatif
        function updateSummary() {
            const nbPlaces = selectedSeats.length;
            const total = nbPlaces * prixBase;
            
            document.getElementById('nbPlaces').textContent = nbPlaces;
            document.getElementById('totalPrice').textContent = total.toLocaleString('fr-FR') + ' Ar';
            
            const seatsList = document.getElementById('selectedSeatsList');
            if (nbPlaces === 0) {
                seatsList.innerHTML = '<small class="text-muted">Cliquez sur les sièges pour sélectionner</small>';
            } else {
                seatsList.innerHTML = selectedSeats.map((id, idx) => {
                    const siege = sieges.find(s => s.idSiege === id);
                    return `<span class="selected-seat-badge">${siege.rangee}${siege.numero}</span>`;
                }).join('');
            }
            
            document.getElementById('idsSiegesInput').value = selectedSeats.join(',');
            document.getElementById('btnValider').disabled = nbPlaces === 0;
        }
        
        // Client select
        document.getElementById('clientSelect').addEventListener('change', function() {
            const newClientFields = document.getElementById('newClientFields');
            if (this.value === '') {
                newClientFields.style.display = 'block';
                newClientFields.querySelectorAll('input').forEach(input => input.required = true);
            } else {
                newClientFields.style.display = 'none';
                newClientFields.querySelectorAll('input').forEach(input => input.required = false);
            }
        });
        
        // Validation formulaire
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            if (selectedSeats.length === 0) {
                alert('Veuillez sélectionner au moins une place');
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
