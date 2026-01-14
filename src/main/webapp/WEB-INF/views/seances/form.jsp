<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - ${empty seanceDTO.idSeance ? 'Nouvelle' : 'Modifier'} Séance</title>
    
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
        
        .form-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        .btn btn-outline-secondary {
            background-color: #e0a800;
        }
        
        .form-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(11, 29, 58, 0.15);
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 12px 30px;
            font-weight: 600;
        }
        .retour {
            background-color: #e0a800;
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
        }
        
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #0066cc;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }
        
        .info-box i {
            color: #0066cc;
        }
        
        .required-star {
            color: #dc3545;
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
                            <i class="bi bi-calendar-plus me-2"></i>
                            ${empty seanceDTO.idSeance ? 'Nouvelle Séance' : 'Modifier Séance'}
                        </h1>
                        <p class="mb-0 text-muted">Programmation d'une projection</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances" class="btn btn-outline-secondary retour">
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
            
            <!-- Info Box -->
            <div class="info-box">
                <i class="bi bi-info-circle me-2"></i>
                <strong>Note:</strong> L'heure de fin sera automatiquement calculée en fonction de la durée du film (+ 15 minutes de nettoyage).
                Le système vérifie également les conflits d'horaires dans la même salle.
            </div>
            
            <!-- Formulaire -->
            <div class="form-card">
                <c:set var="formAction" value="${empty seanceDTO.idSeance ? pageContext.request.contextPath.concat('/seances/nouveau') : pageContext.request.contextPath.concat('/seances/').concat(seanceDTO.idSeance).concat('/modifier')}" />
                <form action="${formAction}" 
                      method="post" id="seanceForm">
                    
                    <!-- Section Film & Salle -->
                    <div class="form-section">
                        <h5><i class="bi bi-film me-2"></i>Film & Salle</h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="idFilm" class="form-label">
                                        Film <span class="required-star">*</span>
                                    </label>
                                    <select class="form-select" id="idFilm" name="idFilm" required 
                                            ${not empty seanceDTO.idSeance ? 'disabled' : ''}>
                                        <option value="">-- Sélectionner un film --</option>
                                        <c:forEach var="film" items="${films}">
                                            <option value="${film.idFilm}" 
                                                    data-duree="${film.duree}"
                                                    ${seanceDTO.idFilm == film.idFilm ? 'selected' : ''}>
                                                ${film.titre} (${film.duree} min)
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty seanceDTO.idSeance}">
                                        <input type="hidden" name="idFilm" value="${seanceDTO.idFilm}">
                                        <small class="text-muted">Le film ne peut pas être modifié après création</small>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="idSalle" class="form-label">
                                        Salle <span class="required-star">*</span>
                                    </label>
                                    <select class="form-select" id="idSalle" name="idSalle" required
                                            ${not empty seanceDTO.idSeance ? 'disabled' : ''}>
                                        <option value="">-- Sélectionner une salle --</option>
                                        <c:forEach var="salle" items="${salles}">
                                            <option value="${salle.idSalle}"
                                                    ${seanceDTO.idSalle == salle.idSalle ? 'selected' : ''}>
                                                ${salle.nom} (${salle.capacite} places)
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty seanceDTO.idSeance}">
                                        <input type="hidden" name="idSalle" value="${seanceDTO.idSalle}">
                                        <small class="text-muted">La salle ne peut pas être modifiée après création</small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Section Date & Horaire -->
                    <div class="form-section">
                        <h5><i class="bi bi-calendar-check me-2"></i>Date & Horaire</h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dtSeance" class="form-label">
                                        Date de la séance <span class="required-star">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="dtSeance" name="dtSeance" 
                                           value="${defaultDate}" required>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="heureDebut" class="form-label">
                                        Heure de début <span class="required-star">*</span>
                                    </label>
                                    <input type="time" class="form-control" id="heureDebut" name="heureDebut" 
                                           value="${defaultTime}" required>
                                    <small class="text-muted">Format 24h (ex: 14:30)</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-info" id="heureFinPreview" style="display: none;">
                            <i class="bi bi-clock me-2"></i>
                            <strong>Heure de fin calculée:</strong> <span id="heureFinText"></span>
                        </div>
                    </div>
                    
                    <!-- Section Prix -->
                    <div class="form-section">
                        <h5><i class="bi bi-tag me-2"></i>Tarification</h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="prixBase" class="form-label">
                                        Prix de base (Ar) <span class="required-star">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="prixBase" name="prixBase" 
                                           value="${seanceDTO.prixBase}" step="100" min="0" required>
                                    <small class="text-muted">Prix par place en Ariary</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Boutons d'action -->
                    <div class="d-flex gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/seances" class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="bi bi-check-circle me-2"></i>
                            ${empty seanceDTO.idSeance ? 'Créer la séance' : 'Enregistrer les modifications'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calculer l'heure de fin en temps réel
        const filmSelect = document.getElementById('idFilm');
        const heureDebutInput = document.getElementById('heureDebut');
        const heureFinPreview = document.getElementById('heureFinPreview');
        const heureFinText = document.getElementById('heureFinText');
        
        function calculateHeureFin() {
            const selectedFilm = filmSelect.options[filmSelect.selectedIndex];
            const duree = parseInt(selectedFilm.dataset.duree);
            const heureDebut = heureDebutInput.value;
            
            if (duree && heureDebut) {
                const [hours, minutes] = heureDebut.split(':').map(Number);
                const totalMinutes = hours * 60 + minutes + duree + 15; // +15 min nettoyage
                
                const heureFinHours = Math.floor(totalMinutes / 60) % 24;
                const heureFinMinutes = totalMinutes % 60;
                
                const heureFinFormatted = 
                    String(heureFinHours).padStart(2, '0') + ':' + 
                    String(heureFinMinutes).padStart(2, '0');
                
                heureFinText.textContent = heureFinFormatted;
                heureFinPreview.style.display = 'block';
            } else {
                heureFinPreview.style.display = 'none';
            }
        }
        
        filmSelect.addEventListener('change', calculateHeureFin);
        heureDebutInput.addEventListener('input', calculateHeureFin);
        
        // Calculer au chargement si modification
        <c:if test="${not empty seanceDTO.idSeance}">
            calculateHeureFin();
        </c:if>
        
        // Validation du formulaire
        document.getElementById('seanceForm').addEventListener('submit', function(e) {
            const dtSeance = new Date(document.getElementById('dtSeance').value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (dtSeance < today) {
                alert('La date de la séance ne peut pas être dans le passé');
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
