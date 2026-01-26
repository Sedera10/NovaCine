<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Nouvelle Vente</title>
    
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
        
        .form-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .form-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.5rem;
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
            color: white;
        }
        
        .ligne-achat {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            position: relative;
        }
        
        .ligne-achat:hover {
            border-color: var(--primary-color);
        }
        
        .btn-remove-ligne {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        
        .seance-info {
            background: linear-gradient(135deg, var(--primary-color) 0%, #1a3a5c 100%);
            color: white;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
            display: none;
        }
        
        .seance-info.visible {
            display: block;
        }
        
        .total-section {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #e0a800 100%);
            color: var(--primary-color);
            padding: 1.5rem;
            border-radius: 8px;
            text-align: right;
        }
        
        .total-amount {
            font-size: 2rem;
            font-weight: 700;
        }
        
        .sous-total {
            color: #28a745;
            font-weight: 600;
        }
        
        .prix-unitaire {
            color: #6c757d;
            font-size: 0.9rem;
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
                            <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                        </h1>
                        <p class="mb-0 text-muted">Mode rapide - Vente de plusieurs billets</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/achats" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour à la liste
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
            
            <!-- Formulaire -->
            <div class="form-card">
                <form action="${pageContext.request.contextPath}/achats/nouveau" method="post" id="achatForm">
                    
                    <!-- Section Séance -->
                    <div class="form-section">
                        <h5><i class="bi bi-camera-reels me-2"></i>Séance</h5>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <label for="idSeance" class="form-label">
                                    Sélectionner une séance <span class="text-danger">*</span>
                                </label>
                                <select class="form-select form-select-lg" id="idSeance" name="idSeance" required>
                                    <option value="">-- Choisir une séance --</option>
                                    <c:forEach var="seance" items="${seances}">
                                        <option value="${seance.idSeance}" 
                                                data-film="${seance.film.titre}"
                                                data-salle="${seance.salle.nom}"
                                                data-date="${seance.dateSeance}"
                                                data-heure="${seance.heureSeance}">
                                            ${seance.film.titre} - ${seance.salle.nom} | 
                                            <fmt:parseDate value="${seance.dateSeance}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/> 
                                            à ${seance.heureSeance}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="nomClient" class="form-label">Nom du client</label>
                                <input type="text" class="form-control form-control-lg" id="nomClient" 
                                       name="nomClient" placeholder="Optionnel">
                            </div>
                        </div>
                        
                        <!-- Info séance sélectionnée -->
                        <div class="seance-info" id="seanceInfo">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h5 class="mb-1" id="seanceFilm"></h5>
                                    <p class="mb-0">
                                        <i class="bi bi-geo-alt me-1"></i><span id="seanceSalle"></span> |
                                        <i class="bi bi-calendar me-1"></i><span id="seanceDate"></span> |
                                        <i class="bi bi-clock me-1"></i><span id="seanceHeure"></span>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <span class="badge bg-success fs-6">Séance sélectionnée</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section Lignes d'achat -->
                    <div class="form-section" id="sectionLignes" style="display: none;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0"><i class="bi bi-ticket-perforated me-2"></i>Billets</h5>
                            <button type="button" class="btn btn-outline-primary" id="btnAddLigne">
                                <i class="bi bi-plus-circle me-1"></i>Ajouter une ligne
                            </button>
                        </div>
                        
                        <div id="lignesContainer">
                            <!-- Ligne par défaut -->
                            <div class="ligne-achat" data-index="0">
                                <button type="button" class="btn btn-outline-danger btn-sm btn-remove-ligne" 
                                        onclick="removeLigne(this)" style="display: none;">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                                <div class="row align-items-end">
                                    <div class="col-md-3">
                                        <label class="form-label">Type de place</label>
                                        <select class="form-select typePlace-select" name="ligne_0_typePlace" required>
                                            <option value="">-- Type --</option>
                                            <c:forEach var="tp" items="${typePlaces}">
                                                <option value="${tp.id}">${tp.nom}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Type de client</label>
                                        <select class="form-select typeClient-select" name="ligne_0_typeClient" required>
                                            <option value="">-- Client --</option>
                                            <c:forEach var="tc" items="${typeClients}">
                                                <option value="${tc.idTypeClient}">${tc.nom}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">Quantité</label>
                                        <input type="number" class="form-control quantite-input" 
                                               name="ligne_0_quantite" min="1" value="1" required>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">Prix unit.</label>
                                        <div class="prix-unitaire-display fw-bold">-- Ar</div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">Sous-total</label>
                                        <div class="sous-total-display fw-bold text-success">-- Ar</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section Total -->
                    <div class="form-section" id="sectionTotal" style="display: none;">
                        <div class="total-section">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-0"><i class="bi bi-receipt me-2"></i>Récapitulatif</h5>
                                    <p class="mb-0" id="nbBillets">0 billet(s)</p>
                                </div>
                                <div class="col-md-6 text-end">
                                    <div class="text-uppercase small">Total à payer</div>
                                    <div class="total-amount" id="totalAmount">0 Ar</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Boutons d'action -->
                    <div class="d-flex gap-2 justify-content-end mt-4" id="sectionBoutons" style="display: none;">
                        <a href="${pageContext.request.contextPath}/achats" class="btn btn-outline-secondary btn-lg">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-primary-custom btn-lg">
                            <i class="bi bi-check-circle me-2"></i>Valider la vente
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ========== Données ==========
        const contextPath = '${pageContext.request.contextPath}';
        let ligneIndex = 1;
        let tarifsCache = {}; // Cache des tarifs pour la séance sélectionnée
        
        // Types de places et clients en JSON (généré côté serveur)
        const typePlaces = [
            <c:forEach var="tp" items="${typePlaces}" varStatus="st">{ id: ${tp.id}, nom: '<c:out value="${tp.nom}"/>' }<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        
        const typeClients = [
            <c:forEach var="tc" items="${typeClients}" varStatus="st">{ id: ${tc.idTypeClient}, nom: '<c:out value="${tc.nom}"/>' }<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        
        console.log('Types de places:', typePlaces);
        console.log('Types de clients:', typeClients);
        
        // Génère les options HTML pour les select
        function getTypePlacesOptions() {
            let html = '<option value="">-- Type de place --</option>';
            typePlaces.forEach(tp => {
                html += '<option value="' + tp.id + '">' + tp.nom + '</option>';
            });
            return html;
        }
        
        function getTypeClientsOptions() {
            let html = '<option value="">-- Type de client --</option>';
            typeClients.forEach(tc => {
                html += '<option value="' + tc.id + '">' + tc.nom + '</option>';
            });
            return html;
        }
        
        // ========== Gestion de la séance ==========
        document.getElementById('idSeance').addEventListener('change', function() {
            console.log('Séance sélectionnée:', this.value);
            
            const option = this.options[this.selectedIndex];
            const seanceInfo = document.getElementById('seanceInfo');
            const sectionLignes = document.getElementById('sectionLignes');
            const sectionTotal = document.getElementById('sectionTotal');
            const sectionBoutons = document.getElementById('sectionBoutons');
            
            console.log('Elements trouvés:', {seanceInfo, sectionLignes, sectionTotal, sectionBoutons});
            
            if (this.value) {
                // Afficher les infos de la séance
                document.getElementById('seanceFilm').textContent = option.dataset.film;
                document.getElementById('seanceSalle').textContent = option.dataset.salle;
                document.getElementById('seanceDate').textContent = formatDate(option.dataset.date);
                document.getElementById('seanceHeure').textContent = option.dataset.heure;
                seanceInfo.classList.add('visible');
                
                // Charger les tarifs de la séance
                loadTarifs(this.value);
                
                // Afficher les sections
                sectionLignes.style.display = 'block';
                sectionTotal.style.display = 'block';
                sectionBoutons.style.display = 'flex';
                
                console.log('Sections affichées');
            } else {
                seanceInfo.classList.remove('visible');
                sectionLignes.style.display = 'none';
                sectionTotal.style.display = 'none';
                sectionBoutons.style.display = 'none';
            }
        });
        
        function formatDate(dateStr) {
            const parts = dateStr.split('-');
            return parts[2] + '/' + parts[1] + '/' + parts[0];
        }
        
        // ========== Chargement des tarifs ==========
        function loadTarifs(idSeance) {
            fetch(contextPath + '/achats/api/tarifs-seance/' + idSeance)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        tarifsCache = data.tarifs;
                        console.log('Tarifs chargés:', tarifsCache);
                        // Recalculer les prix existants
                        updateAllPrices();
                    } else {
                        console.error('Erreur chargement tarifs:', data.error);
                    }
                })
                .catch(error => console.error('Erreur:', error));
        }
        
        // ========== Gestion des lignes ==========
        document.getElementById('btnAddLigne').addEventListener('click', function() {
            addLigne();
        });
        
        function addLigne() {
            const container = document.getElementById('lignesContainer');
            const newLigne = document.createElement('div');
            newLigne.className = 'ligne-achat';
            newLigne.dataset.index = ligneIndex;
            
            newLigne.innerHTML = 
                '<button type="button" class="btn btn-outline-danger btn-sm btn-remove-ligne" onclick="removeLigne(this)">' +
                    '<i class="bi bi-x-lg"></i>' +
                '</button>' +
                '<div class="row align-items-end">' +
                    '<div class="col-md-3">' +
                        '<label class="form-label">Type de place</label>' +
                        '<select class="form-select typePlace-select" name="ligne_' + ligneIndex + '_typePlace" required>' +
                            getTypePlacesOptions() +
                        '</select>' +
                    '</div>' +
                    '<div class="col-md-3">' +
                        '<label class="form-label">Type de client</label>' +
                        '<select class="form-select typeClient-select" name="ligne_' + ligneIndex + '_typeClient" required>' +
                            getTypeClientsOptions() +
                        '</select>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<label class="form-label">Quantité</label>' +
                        '<input type="number" class="form-control quantite-input" name="ligne_' + ligneIndex + '_quantite" min="1" value="1" required>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<label class="form-label">Prix unit.</label>' +
                        '<div class="prix-unitaire-display fw-bold">-- Ar</div>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<label class="form-label">Sous-total</label>' +
                        '<div class="sous-total-display fw-bold text-success">-- Ar</div>' +
                    '</div>' +
                '</div>';
            
            container.appendChild(newLigne);
            ligneIndex++;
            
            // Attacher les événements
            attachEvents(newLigne);
            
            // Montrer les boutons de suppression s'il y a plus d'une ligne
            updateRemoveButtons();
        }
        
        function removeLigne(button) {
            const ligne = button.closest('.ligne-achat');
            ligne.remove();
            updateRemoveButtons();
            calculateTotal();
        }
        
        function updateRemoveButtons() {
            const lignes = document.querySelectorAll('.ligne-achat');
            lignes.forEach((ligne, index) => {
                const btn = ligne.querySelector('.btn-remove-ligne');
                if (btn) {
                    btn.style.display = lignes.length > 1 ? 'block' : 'none';
                }
            });
        }
        
        // ========== Calcul des prix ==========
        function attachEvents(container) {
            const typePlaceSelect = container.querySelector('.typePlace-select');
            const typeClientSelect = container.querySelector('.typeClient-select');
            const quantiteInput = container.querySelector('.quantite-input');
            
            typePlaceSelect.addEventListener('change', () => updateLignePrice(container));
            typeClientSelect.addEventListener('change', () => updateLignePrice(container));
            quantiteInput.addEventListener('input', () => updateLignePrice(container));
        }
        
        function updateLignePrice(container) {
            const typePlaceSelect = container.querySelector('.typePlace-select');
            const typeClientSelect = container.querySelector('.typeClient-select');
            const quantiteInput = container.querySelector('.quantite-input');
            const prixDisplay = container.querySelector('.prix-unitaire-display');
            const soustotalDisplay = container.querySelector('.sous-total-display');
            
            const idTypePlace = typePlaceSelect.value;
            const idTypeClient = typeClientSelect.value;
            const quantite = parseInt(quantiteInput.value) || 0;
            
            if (idTypePlace && idTypeClient && tarifsCache) {
                const key = idTypePlace + '_' + idTypeClient;
                const prix = tarifsCache[key];
                
                if (prix) {
                    prixDisplay.textContent = formatNumber(prix) + ' Ar';
                    prixDisplay.classList.remove('text-danger');
                    
                    const sousTotal = prix * quantite;
                    soustotalDisplay.textContent = formatNumber(sousTotal) + ' Ar';
                } else {
                    prixDisplay.textContent = 'Non configuré';
                    prixDisplay.classList.add('text-danger');
                    soustotalDisplay.textContent = '-- Ar';
                }
            } else {
                prixDisplay.textContent = '-- Ar';
                soustotalDisplay.textContent = '-- Ar';
            }
            
            calculateTotal();
        }
        
        function updateAllPrices() {
            document.querySelectorAll('.ligne-achat').forEach(ligne => {
                updateLignePrice(ligne);
            });
        }
        
        function calculateTotal() {
            let total = 0;
            let nbBillets = 0;
            
            document.querySelectorAll('.ligne-achat').forEach(ligne => {
                const typePlaceSelect = ligne.querySelector('.typePlace-select');
                const typeClientSelect = ligne.querySelector('.typeClient-select');
                const quantiteInput = ligne.querySelector('.quantite-input');
                
                const idTypePlace = typePlaceSelect.value;
                const idTypeClient = typeClientSelect.value;
                const quantite = parseInt(quantiteInput.value) || 0;
                
                if (idTypePlace && idTypeClient && quantite > 0 && tarifsCache) {
                    const key = idTypePlace + '_' + idTypeClient;
                    const prix = tarifsCache[key];
                    if (prix) {
                        total += prix * quantite;
                        nbBillets += quantite;
                    }
                }
            });
            
            document.getElementById('totalAmount').textContent = formatNumber(total) + ' Ar';
            document.getElementById('nbBillets').textContent = nbBillets + ' billet(s)';
        }
        
        function formatNumber(num) {
            return new Intl.NumberFormat('fr-FR').format(num);
        }
        
        // ========== Initialisation ==========
        document.addEventListener('DOMContentLoaded', function() {
            // Attacher les événements à la première ligne
            const firstLigne = document.querySelector('.ligne-achat');
            if (firstLigne) {
                attachEvents(firstLigne);
            }
        });
        
        // ========== Validation du formulaire ==========
        document.getElementById('achatForm').addEventListener('submit', function(e) {
            const idSeance = document.getElementById('idSeance').value;
            if (!idSeance) {
                alert('Veuillez sélectionner une séance');
                e.preventDefault();
                return false;
            }
            
            // Vérifier qu'il y a au moins une ligne valide
            let hasValidLine = false;
            document.querySelectorAll('.ligne-achat').forEach(ligne => {
                const typePlace = ligne.querySelector('.typePlace-select').value;
                const typeClient = ligne.querySelector('.typeClient-select').value;
                const quantite = parseInt(ligne.querySelector('.quantite-input').value) || 0;
                
                if (typePlace && typeClient && quantite > 0) {
                    hasValidLine = true;
                }
            });
            
            if (!hasValidLine) {
                alert('Veuillez ajouter au moins un billet valide');
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
