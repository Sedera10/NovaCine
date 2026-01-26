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
        
        .seance-info-card {
            background: linear-gradient(135deg, var(--primary-color) 0%, #1a3a5c 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .plan-container {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 1.5rem;
        }
        
        .ecran {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 40px;
            margin: 0 auto 30px;
            width: 70%;
            text-align: center;
            border-radius: 8px;
            font-weight: 600;
            letter-spacing: 2px;
        }
        
        .section-places {
            margin-bottom: 2rem;
            padding: 1rem;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }
        
        .section-title {
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid;
        }
        
        .section-title.standard { border-color: #28a745; }
        .section-title.premium { border-color: #ffc107; }
        .section-title.vip { border-color: #dc3545; }
        
        .places-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
        }
        
        .place {
            width: 45px;
            height: 45px;
            border: 2px solid #dee2e6;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        /* Standard */
        .place.standard.disponible {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }
        .place.standard.disponible:hover {
            background-color: #28a745;
            color: white;
            transform: scale(1.1);
        }
        
        /* Premium */
        .place.premium.disponible {
            background-color: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }
        .place.premium.disponible:hover {
            background-color: #ffc107;
            color: #212529;
            transform: scale(1.1);
        }
        
        /* VIP */
        .place.vip.disponible {
            background-color: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }
        .place.vip.disponible:hover {
            background-color: #dc3545;
            color: white;
            transform: scale(1.1);
        }
        
        /* Occupée */
        .place.occupee {
            background-color: #e9ecef;
            border-color: #adb5bd;
            color: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        /* Sélectionnée */
        .place.selectionnee {
            background-color: var(--secondary-color) !important;
            border-color: var(--primary-color) !important;
            color: var(--primary-color) !important;
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        
        .legende {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin: 1.5rem 0;
            flex-wrap: wrap;
        }
        
        .legende-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        
        .legende-box {
            width: 25px;
            height: 25px;
            border-radius: 4px;
            border: 2px solid;
        }
        
        .panier-card {
            background: white;
            border: 2px solid var(--primary-color);
            border-radius: 8px;
            padding: 1.5rem;
            position: sticky;
            top: 20px;
        }
        
        .panier-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            margin-bottom: 8px;
            background: #f8f9fa;
            border-radius: 6px;
            border-left: 4px solid var(--secondary-color);
        }
        
        .panier-item .place-badge {
            background: var(--secondary-color);
            color: var(--primary-color);
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 700;
        }
        
        .panier-item .prix-badge {
            margin-left: auto;
            font-weight: 600;
            color: #28a745;
        }
        
        .total-section {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #e0a800 100%);
            color: var(--primary-color);
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            margin-top: 1rem;
        }
        
        .total-amount {
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            font-weight: 600;
            padding: 12px 30px;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            color: white;
        }
        
        .empty-panier {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
        
        .stats-mini {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
        }
        
        .stats-mini span {
            font-size: 0.85rem;
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
                            <i class="bi bi-ticket-perforated me-2"></i>Achat de Billets
                        </h1>
                        <p class="mb-0 text-muted">Sélectionnez vos places sur le plan de salle</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances/${seance.idSeance}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour à la séance
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
            
            <!-- Info séance -->
            <div class="seance-info-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="mb-2">${seance.film.titre}</h3>
                        <p class="mb-0 opacity-75">
                            <i class="bi bi-geo-alt me-2"></i>${salle.nom} |
                            <i class="bi bi-calendar me-2"></i>
                            <fmt:parseDate value="${seance.dateSeance}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                            <fmt:formatDate value="${parsedDate}" pattern="EEEE dd MMMM yyyy"/> |
                            <i class="bi bi-clock me-2"></i>${seance.heureSeance}
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <span class="badge bg-success fs-6">
                            <i class="bi bi-people me-1"></i>
                            <span id="placesRestantes">--</span> places disponibles
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Plan de salle -->
                <div class="col-lg-8">
                    <div class="plan-container">
                        <!-- Écran -->
                        <div class="ecran">
                            <i class="bi bi-display me-2"></i>ÉCRAN
                        </div>
                        
                        <!-- Légende -->
                        <div class="legende">
                            <c:forEach var="config" items="${configSalle}">
                                <c:set var="typeClass" value="standard"/>
                                <c:if test="${config.typePlace.nom == 'Premium'}"><c:set var="typeClass" value="premium"/></c:if>
                                <c:if test="${config.typePlace.nom == 'VIP'}"><c:set var="typeClass" value="vip"/></c:if>
                                
                                <div class="legende-item">
                                    <div class="legende-box ${typeClass}" 
                                         style="background-color: ${typeClass == 'standard' ? '#d4edda' : (typeClass == 'premium' ? '#fff3cd' : '#f8d7da')};
                                                border-color: ${typeClass == 'standard' ? '#28a745' : (typeClass == 'premium' ? '#ffc107' : '#dc3545')};"></div>
                                    <span>${config.typePlace.nom}</span>
                                </div>
                            </c:forEach>
                            <div class="legende-item">
                                <div class="legende-box" style="background-color: #e9ecef; border-color: #adb5bd;"></div>
                                <span>Occupée</span>
                            </div>
                            <div class="legende-item">
                                <div class="legende-box" style="background-color: var(--secondary-color); border-color: var(--primary-color);"></div>
                                <span>Sélectionnée</span>
                            </div>
                        </div>
                        
                        <!-- Sections par type de place -->
                        <c:forEach var="config" items="${configSalle}">
                            <c:set var="typeClass" value="standard"/>
                            <c:if test="${config.typePlace.nom == 'Premium'}"><c:set var="typeClass" value="premium"/></c:if>
                            <c:if test="${config.typePlace.nom == 'VIP'}"><c:set var="typeClass" value="vip"/></c:if>
                            
                            <c:set var="capacite" value="${config.nombre}"/>
                            <c:set var="vendus" value="${vendusParTypePlace[config.typePlace.id] != null ? vendusParTypePlace[config.typePlace.id] : 0}"/>
                            <c:set var="disponibles" value="${capacite - vendus}"/>
                            
                            <div class="section-places">
                                <div class="section-title ${typeClass}">
                                    <i class="bi bi-grid-3x3-gap me-2"></i>${config.typePlace.nom}
                                    <div class="stats-mini">
                                        <span class="badge bg-secondary">${capacite} places</span>
                                        <span class="badge bg-success">${disponibles} disponibles</span>
                                        <span class="badge bg-warning text-dark">${vendus} vendues</span>
                                    </div>
                                </div>
                                
                                <div class="places-grid">
                                    <c:forEach var="i" begin="1" end="${config.nombre}">
                                        <c:set var="estOccupee" value="${i <= vendus}"/>
                                        <c:set var="codePlace" value="${config.typePlace.nom.substring(0,1)}${i}"/>
                                        
                                        <div class="place ${typeClass} ${estOccupee ? 'occupee' : 'disponible'}"
                                             data-id-type-place="${config.typePlace.id}"
                                             data-type-place-nom="${config.typePlace.nom}"
                                             data-code="${codePlace}"
                                             data-numero="${i}"
                                             ${!estOccupee ? 'onclick="togglePlace(this)"' : ''}>
                                            ${codePlace}
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Panier -->
                <div class="col-lg-4">
                    <div class="panier-card">
                        <h4 class="mb-3">
                            <i class="bi bi-cart3 me-2"></i>Votre sélection
                            <span class="badge bg-secondary" id="nbPlaces">0</span>
                        </h4>
                        
                        <form action="${pageContext.request.contextPath}/achats/seance/${seance.idSeance}" 
                              method="post" id="achatForm">
                            
                            <div class="mb-3">
                                <label for="nomClient" class="form-label">Nom du client</label>
                                <input type="text" class="form-control" id="nomClient" name="nomClient" 
                                       placeholder="Optionnel">
                            </div>
                            
                            <hr>
                            
                            <!-- Liste des places sélectionnées -->
                            <div id="panierListe">
                                <div class="empty-panier" id="emptyPanier">
                                    <i class="bi bi-cart-x display-4"></i>
                                    <p class="mt-2">Cliquez sur les places pour les sélectionner</p>
                                </div>
                            </div>
                            
                            <!-- Inputs cachés pour le formulaire -->
                            <div id="hiddenInputs"></div>
                            
                            <!-- Total -->
                            <div class="total-section" id="totalSection" style="display: none;">
                                <div class="text-uppercase small fw-bold">Total à payer</div>
                                <div class="total-amount" id="totalAmount">0 Ar</div>
                            </div>
                            
                            <!-- Boutons -->
                            <div class="d-grid gap-2 mt-3" id="btnsSection" style="display: none;">
                                <button type="submit" class="btn btn-primary-custom btn-lg">
                                    <i class="bi bi-check-circle me-2"></i>Valider l'achat
                                </button>
                                <button type="button" class="btn btn-outline-danger" onclick="clearSelection()">
                                    <i class="bi bi-trash me-2"></i>Vider la sélection
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Données depuis le serveur
        const contextPath = '${pageContext.request.contextPath}';
        const idSeance = ${seance.idSeance};
        
        // Types de clients en JSON
        const typeClients = [
            <c:forEach var="tc" items="${typeClients}" varStatus="st">
                { id: ${tc.idTypeClient}, nom: '<c:out value="${tc.nom}"/>' }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        
        // Tarifs: Map<"idTypePlace_idTypeClient", valeur>
        const tarifs = {
            <c:forEach var="entry" items="${tarifMap}" varStatus="st">
                '${entry.key}': ${entry.value}<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        };
        
        console.log('Tarifs:', tarifs);
        console.log('Type clients:', typeClients);
        
        // État local
        let selections = []; // [{element, idTypePlace, typePlaceNom, code, idTypeClient, prix}]
        let selectionCounter = 0;
        
        // Calculer places disponibles totales
        function updatePlacesRestantes() {
            const disponibles = document.querySelectorAll('.place.disponible:not(.selectionnee)').length;
            document.getElementById('placesRestantes').textContent = disponibles;
        }
        
        // Toggle sélection d'une place
        function togglePlace(element) {
            const code = element.dataset.code;
            const index = selections.findIndex(s => s.code === code);
            
            if (index > -1) {
                // Désélectionner
                element.classList.remove('selectionnee');
                removeFromPanier(code);
                selections.splice(index, 1);
            } else {
                // Sélectionner
                element.classList.add('selectionnee');
                const idTypePlace = element.dataset.idTypePlace;
                const typePlaceNom = element.dataset.typePlaceNom;
                
                const selection = {
                    element: element,
                    idTypePlace: idTypePlace,
                    typePlaceNom: typePlaceNom,
                    code: code,
                    idTypeClient: typeClients.length > 0 ? typeClients[0].id : null,
                    prix: 0
                };
                
                // Calculer le prix initial
                selection.prix = getPrix(idTypePlace, selection.idTypeClient);
                
                selections.push(selection);
                addToPanier(selection);
            }
            
            updateUI();
        }
        
        // Obtenir le prix pour une combinaison typePlace/typeClient
        function getPrix(idTypePlace, idTypeClient) {
            const key = idTypePlace + '_' + idTypeClient;
            return tarifs[key] || 0;
        }
        
        // Ajouter au panier
        function addToPanier(selection) {
            const liste = document.getElementById('panierListe');
            const emptyMsg = document.getElementById('emptyPanier');
            if (emptyMsg) emptyMsg.style.display = 'none';
            
            const div = document.createElement('div');
            div.className = 'panier-item';
            div.id = 'panier-' + selection.code;
            
            // Options type client
            let optionsHtml = '';
            typeClients.forEach(tc => {
                const prix = getPrix(selection.idTypePlace, tc.id);
                const selected = tc.id == selection.idTypeClient ? 'selected' : '';
                optionsHtml += '<option value="' + tc.id + '" ' + selected + '>' + tc.nom + ' (' + formatNumber(prix) + ' Ar)</option>';
            });
            
            div.innerHTML = 
                '<span class="place-badge">' + selection.code + '</span>' +
                '<small class="text-muted">' + selection.typePlaceNom + '</small>' +
                '<select class="form-select form-select-sm" style="width: auto; flex: 1;" ' +
                        'onchange="onTypeClientChange(\'' + selection.code + '\', this.value)">' +
                    optionsHtml +
                '</select>' +
                '<span class="prix-badge" id="prix-' + selection.code + '">' + formatNumber(selection.prix) + ' Ar</span>' +
                '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removeSelection(\'' + selection.code + '\')">' +
                    '<i class="bi bi-x"></i>' +
                '</button>';
            
            liste.appendChild(div);
        }
        
        // Supprimer du panier
        function removeFromPanier(code) {
            const item = document.getElementById('panier-' + code);
            if (item) item.remove();
            
            // Montrer message vide si plus rien
            if (selections.length <= 1) {
                document.getElementById('emptyPanier').style.display = 'block';
            }
        }
        
        // Supprimer une sélection
        function removeSelection(code) {
            const index = selections.findIndex(s => s.code === code);
            if (index > -1) {
                selections[index].element.classList.remove('selectionnee');
                removeFromPanier(code);
                selections.splice(index, 1);
                updateUI();
            }
        }
        
        // Changement de type de client
        function onTypeClientChange(code, idTypeClient) {
            const selection = selections.find(s => s.code === code);
            if (selection) {
                selection.idTypeClient = idTypeClient;
                selection.prix = getPrix(selection.idTypePlace, idTypeClient);
                
                // Mettre à jour l'affichage du prix
                document.getElementById('prix-' + code).textContent = formatNumber(selection.prix) + ' Ar';
                
                updateUI();
            }
        }
        
        // Vider la sélection
        function clearSelection() {
            selections.forEach(s => {
                s.element.classList.remove('selectionnee');
            });
            selections = [];
            
            // Vider le panier
            const liste = document.getElementById('panierListe');
            liste.innerHTML = '<div class="empty-panier" id="emptyPanier">' +
                '<i class="bi bi-cart-x display-4"></i>' +
                '<p class="mt-2">Cliquez sur les places pour les sélectionner</p>' +
            '</div>';
            
            updateUI();
        }
        
        // Mettre à jour l'interface
        function updateUI() {
            const nbPlaces = selections.length;
            document.getElementById('nbPlaces').textContent = nbPlaces;
            
            // Calculer le total
            let total = 0;
            selections.forEach(s => {
                total += s.prix;
            });
            document.getElementById('totalAmount').textContent = formatNumber(total) + ' Ar';
            
            // Afficher/masquer sections
            const hasSelection = nbPlaces > 0;
            document.getElementById('totalSection').style.display = hasSelection ? 'block' : 'none';
            document.getElementById('btnsSection').style.display = hasSelection ? 'grid' : 'none';
            
            // Générer les inputs cachés pour le formuquantite>
            const grouped = {};
            selections.forEach(s => {
                const key = s.idTypePlace + '_' + s.idTypeClient;
                if (!grouped[key]) {
                    grouped[key] = {
                        idTypePlace: s.idTypePlace,
                        idTypeClient: s.idTypeClient,
                        quantite: 0
                    };
                }
                grouped[key].quantite++;
            });
            
            // Créer les inputs
            let index = 0;
            for (const key in grouped) {
                const g = grouped[key];
                container.innerHTML += 
                    '<input type="hidden" name="ligne_' + index + '_typePlace" value="' + g.idTypePlace + '">' +
                    '<input type="hidden" name="ligne_' + index + '_typeClient" value="' + g.idTypeClient + '">' +
                    '<input type="hidden" name="ligne_' + index + '_quantite" value="' + g.quantite
                grouped[key].codes.push(s.code);
            });
            
            // Créer les inputs
            let index = 0;
            for (const key in grouped) {
                const g = grouped[key];
                container.innerHTML += 
                    '<input type="hidden" name="ligne_' + index + '_typePlace" value="' + g.idTypePlace + '">' +
                    '<input type="hidden" name="ligne_' + index + '_typeClient" value="' + g.idTypeClient + '">' +
                    '<input type="hidden" name="ligne_' + index + '_quantite" value="' + g.quantite + '">' +
                    '<input type="hidden" name="ligne_' + index + '_places" value="' + g.codes.join(',') + '">';
                index++;
            }
        }
        
        // Formater nombre
        function formatNumber(num) {
            return new Intl.NumberFormat('fr-FR').format(num);
        }
        
        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            // Générer les places pour chaque section
            generatePlaces();
            updatePlacesRestantes();
        });updatePlacesRestantes();
        });ocument.getElementById('achatForm').addEventListener('submit', function(e) {
            if (selections.length === 0) {
                alert('Veuillez sélectionner au moins une place');
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
