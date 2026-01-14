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
        
        function togglePlace(idBillet, codePlace) {
            const index = placesSelectionnees.indexOf(idBillet);
            const placeElement = document.getElementById('place-' + idBillet);
            
            if (index > -1) {
                placesSelectionnees.splice(index, 1);
                placeElement.classList.remove('selectionnee');
            } else {
                placesSelectionnees.push(idBillet);
                placeElement.classList.add('selectionnee');
            }
            
            updateSelection();
        }
        
        function updateSelection() {
            document.getElementById('places-count').textContent = placesSelectionnees.length;
            document.getElementById('ids-billets').value = placesSelectionnees.join(',');
            
            // Calculer le total (prix * nombre de places)
            const prixUnitaire = parseFloat(document.getElementById('prix-unitaire').value);
            const total = placesSelectionnees.length * prixUnitaire;
            document.getElementById('total-amount').textContent = total.toFixed(2);
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
            <div class="legende-item">
                <span class="legende-box disponible"></span> Disponible
            </div>
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
                <div id="place-${billet.idBillet}" 
                     class="place ${estDisponible ? 'disponible' : 'occupee'}"
                     onclick="${estDisponible ? 'togglePlace(' += billet.idBillet += ', \'' += billet.place.codePlace += '\')' : ''}">
                    ${billet.place.codePlace}
                </div>
            </c:forEach>
            </div>
        </div>
        
        <!-- Formulaire d'achat -->
        <div class="selection-info">
            <form method="post" action="<c:url value='/achats/confirmer'/>" onsubmit="return validerAchat()">
                <input type="hidden" id="ids-billets" name="idsBillets" value="">
                <input type="hidden" id="prix-unitaire" value="${billets[0].prix}">
                
                <div class="form-group">
                    <label for="nom-acheteur">Nom de l'acheteur:</label>
                    <input type="text" id="nom-acheteur" name="nomAcheteur" 
                           class="form-control" required>
                </div>
                
                <div class="form-group">
                    <p><strong>Places sélectionnées:</strong> <span id="places-count">0</span></p>
                    <p><strong>Prix unitaire:</strong> ${billets[0].prix} Ar</p>
                    <p><strong>Total:</strong> <span id="total-amount">0</span> Ar</p>
                </div>
                
                <button type="submit" class="btn btn-success">Confirmer l'achat</button>
                <a href="<c:url value='/seances'/>" class="btn">Annuler</a>
            </form>
        </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
