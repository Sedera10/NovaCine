<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Achat de Billets</title>
    
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
        
        .plan-salle {
            margin: 20px 0;
            text-align: center;
        }
        .rangee {
            margin: 5px 0;
        }
        .place {
            display: inline-block;
            width: 40px;
            height: 40px;
            margin: 2px;
            border: 2px solid #dee2e6;
            border-radius: 4px;
            line-height: 40px;
            text-align: center;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
        }
        .place.disponible {
            background-color: white;
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .place.disponible:hover {
            background-color: var(--primary-color);
            color: white;
        }
        /* Style pour places Standard */
        .place.standard {
            border-color: #28a745;
        }
        .place.standard.disponible {
            background-color: #d4edda;
            color: #155724;
            border-color: #28a745;
        }
        .place.standard.disponible:hover {
            background-color: #28a745;
            color: white;
        }
        /* Style pour places Premium */
        .place.premium {
            border-color: #ffc107;
        }
        .place.premium.disponible {
            background-color: #fff3cd;
            color: #856404;
            border-color: #ffc107;
        }
        .place.premium.disponible:hover {
            background-color: #ffc107;
            color: #212529;
        }
        /* Style pour places VIP */
        .place.vip {
            border-color: #dc3545;
        }
        .place.vip.disponible {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #dc3545;
        }
        .place.vip.disponible:hover {
            background-color: #dc3545;
            color: white;
        }
        .place.occupee {
            background-color: #dee2e6;
            color: #6c757d;
            border-color: #dee2e6;
            cursor: not-allowed;
        }
        .place.selectionnee {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            border-color: var(--secondary-color);
        }
        .legende {
            margin: 20px 0;
            text-align: center;
        }
        .legende-item {
            display: inline-block;
            margin: 0 15px;
        }
        .legende-box {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 5px;
            border: 1px solid #dee2e6;
            vertical-align: middle;
        }
        .ecran {
            background-color: var(--primary-color);
            color: white;
            padding: 10px;
            margin: 20px auto;
            width: 80%;
            text-align: center;
            border-radius: 4px;
        }
        .selection-info {
            background: white;
            border: 1px solid #dee2e6;
            padding: 20px;
            border-radius: 4px;
            margin: 20px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .selected-seat-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px;
            margin: 5px 0;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .selected-seat-badge {
            background: var(--secondary-color);
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            <h1>Achat de Billets</h1>
            
            <!-- Infos séance -->
            <div class="selection-info">
                <h3>${seance.film.titre}</h3>
                <p>
                    <strong>Date:</strong> ${seance.daty} |
                    <strong>Heure:</strong> ${seance.heure} |
                    <strong>Salle:</strong> ${seance.salle.nom}
                </p>
            </div>
            
            <!-- Légende -->
            <div class="legende">
                <c:forEach var="typePlace" items="${typesPlaces}">
                    <div class="legende-item">
                        <c:choose>
                            <c:when test="${typePlace.nom == 'Premium'}">
                                <span class="legende-box" style="background-color: #fff3cd; border-color: #ffc107;"></span>
                            </c:when>
                            <c:when test="${typePlace.nom == 'VIP'}">
                                <span class="legende-box" style="background-color: #f8d7da; border-color: #dc3545;"></span>
                            </c:when>
                            <c:otherwise>
                                <span class="legende-box" style="background-color: #d4edda; border-color: #28a745;"></span>
                            </c:otherwise>
                        </c:choose>
                        ${typePlace.nom} - ${prixParTypePlace[typePlace.id_type_place] != null ? prixParTypePlace[typePlace.id_type_place] : 0} Ar
                    </div>
                </c:forEach>
                <div class="legende-item">
                    <span class="legende-box" style="background-color: #dee2e6;"></span> Occupée
                </div>
                <div class="legende-item">
                    <span class="legende-box" style="background-color: #FFC107;"></span> Sélectionnée
                </div>
            </div>
            
            <!-- Remises disponibles -->
            <c:if test="${not empty typePersonnes}">
                <div class="alert alert-info mt-3">
                    <strong><i class="fas fa-info-circle"></i> Tarifs réduits disponibles :</strong>
                    <ul class="mb-0 mt-2">
                        <c:forEach var="tp" items="${typePersonnes}">
                            <c:if test="${remiseParTypePersonne[tp.idTypePersonne] != null && remiseParTypePersonne[tp.idTypePersonne] > 0}">
                                <li><strong>${tp.nom}</strong> : -${remiseParTypePersonne[tp.idTypePersonne]}% sur le prix</li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
            
            <!-- Écran -->
            <div class="ecran">ÉCRAN</div>
            
            <!-- Plan de salle -->
            <div class="plan-salle">
                <c:set var="currentRangee" value=""/>
                <c:forEach items="${places}" var="place">
                    <c:set var="rangee" value="${place.codePlace.substring(0,1)}"/>
                    <c:if test="${currentRangee != rangee}">
                        <c:if test="${not empty currentRangee}">
                            </div>
                        </c:if>
                        <div class="rangee">
                        <c:set var="currentRangee" value="${rangee}"/>
                    </c:if>
                    
                    <c:set var="estOccupee" value="${placesOccupees[place.idPlace] == true}"/>
                    <c:set var="typeClass" value="standard"/>
                    <c:if test="${place.typePlace.nom == 'Premium'}">
                        <c:set var="typeClass" value="premium"/>
                    </c:if>
                    <c:if test="${place.typePlace.nom == 'VIP'}">
                        <c:set var="typeClass" value="vip"/>
                    </c:if>
                    <c:set var="prixPlace" value="${prixParTypePlace[place.typePlace.id_type_place]}"/>
                    <c:if test="${empty prixPlace}">
                        <c:set var="prixPlace" value="0"/>
                    </c:if>
                    
                    <div id="place-${place.idPlace}" 
                         class="place ${typeClass} ${estOccupee ? 'occupee' : 'disponible'}"
                         data-prix="${prixPlace}"
                         data-code="${place.codePlace}"
                         data-type-place-id="${place.typePlace.id}"
                         onclick="${!estOccupee ? 'togglePlace('.concat(place.idPlace).concat(')') : ''}">
                        ${place.codePlace}
                    </div>
                </c:forEach>
                </div>
            </div>
            
            <!-- Formulaire d'achat -->
            <div class="selection-info">
                <form method="post" action="<c:url value='/achats/confirmer'/>" onsubmit="return validerAchat()">
                    <input type="hidden" name="idSeance" value="${seance.idSeance}">
                    <input type="hidden" id="ids-places" name="idsPlaces" value="">
                    <input type="hidden" id="type-personne-ids" name="typePersonneIds" value="">
                    
                    <div class="form-group mb-3">
                        <label for="nom-acheteur" class="form-label"><strong>Nom de l'acheteur:</strong></label>
                        <input type="text" id="nom-acheteur" name="nomAcheteur" 
                               class="form-control" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <h5>Récapitulatif</h5>
                        <p><strong>Places sélectionnées:</strong> <span id="places-count">0</span></p>
                        <div id="selectedSeatsListContainer">
                            <small class="text-muted">Cliquez sur une place pour sélectionner, puis choisissez le type de personne.</small>
                            <div id="selectedSeatsList"></div>
                        </div>
                        <hr>
                        <p><strong style="font-size: 1.2rem;">Total: <span id="total-amount" class="text-success">0</span> Ar</strong></p>
                    </div>
                    
                    <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i> Confirmer l'achat</button>
                    <a href="<c:url value='/seances'/>" class="btn btn-outline-secondary"><i class="bi bi-x-circle"></i> Annuler</a>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const idSeance = ${seance.idSeance};
        let placesSelectionnees = [];
        let prixPlaces = {};
        let typePersonnePerPlace = {};
        
        // Types de personnes disponibles avec leurs remises
        const typePersonnes = [
            <c:forEach var="tp" items="${typePersonnes}" varStatus="loop">
                {id: ${tp.idTypePersonne}, nom: '${tp.nom}', remise: ${remiseParTypePersonne[tp.idTypePersonne] != null ? remiseParTypePersonne[tp.idTypePersonne] : 0}}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        
        // Map des remises par type de personne
        const remiseParTypePersonne = {};
        typePersonnes.forEach(tp => {
            remiseParTypePersonne[tp.id] = tp.remise;
        });
        
        function togglePlace(idPlace) {
            const index = placesSelectionnees.indexOf(idPlace);
            const placeElement = document.getElementById('place-' + idPlace);
            const codePlace = placeElement.dataset.code;
            const prix = parseFloat(placeElement.dataset.prix) || 0;
            
            if (index > -1) {
                // Désélectionner
                placesSelectionnees.splice(index, 1);
                delete prixPlaces[idPlace];
                delete prixBasePlaces[idPlace];
                delete typePersonnePerPlace[idPlace];
                placeElement.classList.remove('selectionnee');
                
                const selDiv = document.getElementById('selected-seat-' + idPlace);
                if (selDiv) selDiv.remove();
            } else {
                // Sélectionner
                placesSelectionnees.push(idPlace);
                prixPlaces[idPlace] = prix;
                prixBasePlaces[idPlace] = prix; // Stocker le prix de base
                typePersonnePerPlace[idPlace] = null;
                placeElement.classList.add('selectionnee');
                
                // Ajouter l'élément de sélection de type de personne
                const seatsList = document.getElementById('selectedSeatsList');
                const div = document.createElement('div');
                div.id = 'selected-seat-' + idPlace;
                div.className = 'selected-seat-item';
                
                let optionsHtml = '<option value="">Adulte (par défaut)</option>';
                typePersonnes.forEach(tp => {
                    const remiseText = tp.remise > 0 ? ' (-' + tp.remise + '%)' : '';
                    optionsHtml += '<option value="' + tp.id + '">' + tp.nom + remiseText + '</option>';
                });
                
                div.innerHTML = '<span class="selected-seat-badge">' + codePlace + '</span> ' +
                    '<select class="form-select form-select-sm" style="width: auto;" onchange="onTypePersonneChange(' + idPlace + ', this.value)">' +
                    optionsHtml +
                    '</select>' +
                    '<span id="prix-' + idPlace + '" class="badge bg-success">' + prix.toLocaleString('fr-FR') + ' Ar</span>';
                seatsList.appendChild(div);
            }
            
            updateSelection();
        }
        
        function updateSelection() {
            document.getElementById('places-count').textContent = placesSelectionnees.length;
            document.getElementById('ids-places').value = placesSelectionnees.join(',');
            
            // Calculer le total
            let total = 0;
            for (let idPlace in prixPlaces) {
                total += parseFloat(prixPlaces[idPlace]) || 0;
            }
            document.getElementById('total-amount').textContent = total.toLocaleString('fr-FR');
            
            // Mettre à jour les IDs de type de personne
            const typeIds = placesSelectionnees.map(id => typePersonnePerPlace[id] || '');
            document.getElementById('type-personne-ids').value = typeIds.join(',');
        }
        
        // Stocker les prix de base par place
        let prixBasePlaces = {};
        
        function onTypePersonneChange(idPlace, idTypePersonne) {
            typePersonnePerPlace[idPlace] = idTypePersonne || null;
            
            const placeElement = document.getElementById('place-' + idPlace);
            const prixBase = prixBasePlaces[idPlace] || parseFloat(placeElement.dataset.prix) || 0;
            
            // Calculer le prix avec la remise côté client
            let prixFinal = prixBase;
            if (idTypePersonne && remiseParTypePersonne[idTypePersonne]) {
                const remise = remiseParTypePersonne[idTypePersonne];
                prixFinal = prixBase * (1 - remise / 100);
            }
            
            prixPlaces[idPlace] = prixFinal;
            
            // Mettre à jour l'affichage du prix
            const prixBadge = document.getElementById('prix-' + idPlace);
            if (prixBadge) {
                prixBadge.textContent = prixFinal.toLocaleString('fr-FR') + ' Ar';
                
                // Ajouter indication de la remise si applicable
                if (idTypePersonne && remiseParTypePersonne[idTypePersonne]) {
                    prixBadge.innerHTML = prixFinal.toLocaleString('fr-FR') + ' Ar <small class="text-warning">(-' + remiseParTypePersonne[idTypePersonne] + '%)</small>';
                }
            }
            
            updateSelection();
        }
        
        function validerAchat() {
            if (placesSelectionnees.length === 0) {
                alert('Veuillez sélectionner au moins une place');
                return false;
            }
            
            const nomAcheteur = document.getElementById('nom-acheteur').value.trim();
            if (!nomAcheteur) {
                alert('Veuillez saisir le nom de l\'acheteur');
                return false;
            }
            
            return confirm('Confirmer l\'achat de ' + placesSelectionnees.length + ' billet(s) ?');
        }
    </script>
</body>
</html>
