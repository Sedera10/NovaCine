<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Diffusion Publicité</title>
    
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
            padding: 2rem;
        }
        
        .page-header {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
        }
        
        .page-header h1 {
            color: var(--primary-color);
            margin: 0 0 0.5rem 0;
        }
        
        .form-container {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            max-width: 800px;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid #e9ecef;
            padding: 0.75rem;
            border-radius: 6px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(11, 29, 58, 0.15);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 6px;
        }
        
        .btn-primary:hover {
            background-color: #081527;
            border-color: #081527;
        }
        
        .alert {
            border-radius: 6px;
            border: none;
        }
        
        .info-card {
            background: #f8f9fa;
            border-left: 4px solid var(--primary-color);
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }
        
        .info-card h6 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .seance-info {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp"/>
    
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="bi bi-play-circle me-2"></i>Diffusion Publicité</h1>
                    <p class="text-muted mb-0">Enregistrer les diffusions publicitaires par séance</p>
                </div>
            </div>
        </div>
        
        <!-- Alerts -->
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
        
        <!-- Form Container -->
        <div class="form-container">
            <div class="info-card">
                <h6><i class="bi bi-info-circle me-2"></i>Information</h6>
                <p class="mb-0">Sélectionnez une séance et une société pour enregistrer le nombre de diffusions publicitaires. Le système vérifiera automatiquement le quota disponible.</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/publicite/diffusions/enregistrer" method="post" id="diffusionForm">
                <div class="row">
                    <!-- Séance -->
                    <div class="col-md-6 mb-3">
                        <label for="idSeance" class="form-label">
                            <i class="bi bi-camera-reels me-1"></i>Séance *
                        </label>
                        <select class="form-select" id="idSeance" name="idSeance" required onchange="updateSeanceInfo()">
                            <option value="">-- Sélectionner une séance --</option>
                            <c:forEach items="${seances}" var="seance">
                                <option value="${seance.idSeance}" 
                                        data-film="${seance.film.titre}"
                                        data-salle="${seance.salle.nom}"
                                        data-date="${seance.dateSeance}"
                                        data-heure="${seance.heureSeance}">
                                    ${seance.film.titre} - ${seance.salle.nom} - ${seance.dateSeance} ${seance.heureSeance}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Société -->
                    <div class="col-md-6 mb-3">
                        <label for="idSociete" class="form-label">
                            <i class="bi bi-building me-1"></i>Société *
                        </label>
                        <select class="form-select" id="idSociete" name="idSociete" required onchange="updateQuotaInfo()">
                            <option value="">-- Sélectionner une société --</option>
                            <c:forEach items="${societes}" var="societe">
                                <option value="${societe.idSociete}">
                                    ${societe.nom}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Nombre de diffusions -->
                    <div class="col-md-12 mb-3">
                        <label for="nombreDiffusions" class="form-label">
                            <i class="bi bi-123 me-1"></i>Nombre de diffusions *
                        </label>
                        <input type="number" 
                               class="form-control" 
                               id="nombreDiffusions" 
                               name="nombreDiffusions" 
                               min="1" 
                               required
                               placeholder="Entrez le nombre de diffusions">
                        <div class="form-text">Le nombre doit respecter le quota mensuel du contrat</div>
                    </div>
                </div>
                
                <!-- Seance Info Display -->
                <div id="seanceInfoDisplay" class="info-card" style="display: none;">
                    <h6><i class="bi bi-film me-2"></i>Détails de la séance</h6>
                    <div class="seance-info">
                        <div><strong>Film:</strong> <span id="infoFilm"></span></div>
                        <div><strong>Salle:</strong> <span id="infoSalle"></span></div>
                        <div><strong>Date:</strong> <span id="infoDate"></span></div>
                        <div><strong>Heure:</strong> <span id="infoHeure"></span></div>
                    </div>
                </div>
                
                <!-- Submit Buttons -->
                <div class="d-flex gap-2 justify-content-end mt-4">
                    <a href="${pageContext.request.contextPath}/publicite/rapport" class="btn btn-secondary">
                        <i class="bi bi-x-circle me-1"></i>Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-1"></i>Enregistrer la diffusion
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateSeanceInfo() {
            const select = document.getElementById('idSeance');
            const selectedOption = select.options[select.selectedIndex];
            const infoDisplay = document.getElementById('seanceInfoDisplay');
            
            if (select.value) {
                document.getElementById('infoFilm').textContent = selectedOption.dataset.film;
                document.getElementById('infoSalle').textContent = selectedOption.dataset.salle;
                document.getElementById('infoDate').textContent = selectedOption.dataset.date;
                document.getElementById('infoHeure').textContent = selectedOption.dataset.heure;
                infoDisplay.style.display = 'block';
            } else {
                infoDisplay.style.display = 'none';
            }
        }
        
        function updateQuotaInfo() {
            // Placeholder for future quota check via AJAX
            const societeId = document.getElementById('idSociete').value;
            if (societeId) {
                // Future: fetch quota info from API
            }
        }
        
        // Form validation
        document.getElementById('diffusionForm').addEventListener('submit', function(e) {
            const seance = document.getElementById('idSeance').value;
            const societe = document.getElementById('idSociete').value;
            const nombre = document.getElementById('nombreDiffusions').value;
            
            if (!seance || !societe || !nombre || nombre < 1) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs correctement');
                return false;
            }
        });
    </script>
</body>
</html>
