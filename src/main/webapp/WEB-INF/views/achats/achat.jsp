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
    </style>
    <script>
        let placesSelectionnees = [];
        let prixPlaces = {}; // Stocker le prix de chaque place sélectionnée
        
        function togglePlace(idBillet, codePlace, prix) {
            const index = placesSelectionnees.indexOf(idBillet);
            const placeElement = document.getElementById('place-' + idBillet);
            
            if (index > -1) {
                placesSelectionnees.splice(index, 1);
                delete prixPlaces[idBillet];
                placeElement.classList.remove('selectionnee');
            } else {
                placesSelectionnees.push(idBillet);
                prixPlaces[idBillet] = prix;
                placeElement.classList.add('selectionnee');
            }
            
            updateSelection();
        }
        
        function updateSelection() {
            document.getElementById('places-count').textContent = placesSelectionnees.length;
            document.getElementById('ids-billets').value = placesSelectionnees.join(',');
            
            // Calculer le total en additionnant les prix de chaque place sélectionnée
            let total = 0;
            for (let idBillet in prixPlaces) {
                total += parseFloat(prixPlaces[idBillet]);
            }
            document.getElementById('total-amount').textContent = total.toLocaleString('fr-FR');
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
    .main-content {
            margin-left: 240px;
            min-height: 100vh;
            background-color: #f8f9fa;
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
                        <c:otherwise>
                            <span class="legende-box" style="background-color: #d4edda; border-color: #28a745;"></span>
                        </c:otherwise>
                    </c:choose>
                    ${typePlace.nom} (<fmt:formatNumber value="${typePlace.prix}" type="number" groupingUsed="true"/> Ar)
                </div>
            </c:forEach>
            <div class="legende-item">
                <span class="legende-box occupee"></span> Occupée
            </div>
            <div class="legende-item">
                <span class="legende-box selectionnee"></span> Sélectionnée
            </div>
        </div>
        
        <!-- Écran -->
        <div class="ecran">ÉCRAN</div>
        
        <!-- Plan de salle -->
        <div class="plan-salle">
            <c:set var="currentRangee" value=""/>
            <c:forEach items="${billets}" var="billet">
                <c:set var="rangee" value="${billet.place.codePlace.substring(0,1)}"/>
                <c:if test="${currentRangee != rangee}">
                    <c:if test="${not empty currentRangee}">
                        </div>
                    </c:if>
                    <div class="rangee">
                    <c:set var="currentRangee" value="${rangee}"/>
                </c:if>
                
                <c:set var="estDisponible" value="${billetsDisponibles.contains(billet)}"/>
                <%-- Déterminer le type de place selon le prix - Premium a un prix plus élevé --%>
                <c:set var="typeClass" value="standard"/>
                <c:set var="prixBillet" value="${billet.prix}"/>
                <c:forEach var="tp" items="${typesPlaces}">
                    <c:if test="${tp.nom eq 'Premium'}">
                        <c:set var="prixPremium" value="${tp.prix}"/>
                    </c:if>
                </c:forEach>
                <%-- Si le prix du billet >= prix Premium, c'est une place Premium --%>
                <c:if test="${not empty prixPremium && prixBillet >= prixPremium}">
                    <c:set var="typeClass" value="premium"/>
                </c:if>
                
                <div id="place-${billet.idBillet}" 
                     class="place ${typeClass} ${estDisponible ? 'disponible' : 'occupee'}"
                     data-prix="${billet.prix}"
                     onclick="${estDisponible ? 'togglePlace(' += billet.idBillet += ', \'' += billet.place.codePlace += '\', ' += billet.prix += ')' : ''}">
                    ${billet.place.codePlace}
                </div>
            </c:forEach>
            </div>
        </div>
        
        <!-- Formulaire d'achat -->
        <div class="selection-info">
            <form method="post" action="<c:url value='/achats/confirmer'/>" onsubmit="return validerAchat()">
                <input type="hidden" id="ids-billets" name="idsBillets" value="">
                
                <div class="form-group mb-3">
                    <label for="nom-acheteur" class="form-label"><strong>Nom de l'acheteur:</strong></label>
                    <input type="text" id="nom-acheteur" name="nomAcheteur" 
                           class="form-control" required>
                </div>
                
                <div class="form-group mb-3">
                    <h5>Récapitulatif</h5>
                    <p><strong>Places sélectionnées:</strong> <span id="places-count">0</span></p>
                    <c:forEach var="typePlace" items="${typesPlaces}">
                        <p class="mb-1">
                            <span class="badge" style="background-color: ${typePlace.nom == 'Premium' ? '#ffc107' : '#28a745'}; color: ${typePlace.nom == 'Premium' ? '#212529' : 'white'}">
                                ${typePlace.nom}
                            </span>
                            <fmt:formatNumber value="${typePlace.prix}" type="number" groupingUsed="true"/> Ar / place
                        </p>
                    </c:forEach>
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
</body>
</html>
