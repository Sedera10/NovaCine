<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - ${film.titre}</title>
    
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
        
        .film-header {
            background: white;
            border: 1px solid var(--primary-color);
            padding: 1.5rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .film-header h1 {
            color: var(--primary-color);
        }
        
        .film-poster-large {
            width: 100%;
            max-width: 350px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            aspect-ratio: 2/3;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
        }
        
        .info-card {
            background: white;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .info-label {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-value {
            color: #495057;
            margin-bottom: 15px;
        }
        
        .badge-custom {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-right: 8px;
        }
        
        .badge-en-salle {
            background-color: #28a745;
            color: white;
        }
        
        .badge-a-venir {
            background-color: #17a2b8;
            color: white;
        }
        
        .badge-archive {
            background-color: #6c757d;
            color: white;
        }
        
        .acteur-card {
            background: white;
            border-radius: 4px;
            padding: 1rem;
            text-align: center;
            transition: transform 0.3s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            height: 100%;
        }
        
        .acteur-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .acteur-photo {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            border-color: #164a7a;
        }
        
        .section-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.2rem;
            padding-bottom: 0.6rem;
            border-bottom: 2px solid rgba(11, 29, 58, 0.1);
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="../includes/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid p-4">
            
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/films">Films</a></li>
                    <li class="breadcrumb-item active">${film.titre}</li>
                </ol>
            </nav>
            
            <!-- Film Header -->
            <div class="film-header">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <c:choose>
                            <c:when test="${not empty film.poster}">
                                <img src="<c:url value='/images/films/${film.poster}'/>"
                                     alt="${film.titre}" class="film-poster-large" 
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="film-poster-large" style="display: none;">
                                    <i class="bi bi-film"></i>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="film-poster-large">
                                    <i class="bi bi-film"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col">
                        <h1 class="display-4 mb-3">${film.titre}</h1>
                        
                        <div class="mb-3">
                            <span class="badge-custom badge-en-salle">
                                <i class="bi bi-play-circle me-1"></i>En Salle
                            </span>
                            
                            <span class="badge-custom" style="background-color: var(--secondary-color); color: var(--primary-color);">
                                Classification : (inconnu)
                            </span>
                        </div>
                        
                        <div class="lead mb-3">
                            <i class="bi bi-clock me-2"></i>${film.duree} minutes
                            <c:if test="${not empty film.dtSortie}">
                                | <i class="bi bi-calendar-event me-2"></i>${film.dtSortie}
                            </c:if>
                        </div>
                        
                        <c:if test="${user.role.nomRole eq 'Admin' or user.role.nomRole eq 'Manager'}">
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/films/${film.idFilm}/modifier" 
                                   class="btn btn-warning btn-lg me-2">
                                    <i class="bi bi-pencil me-2"></i>Modifier
                                </a>
                                <c:if test="${user.role.nomRole eq 'Admin'}">
                                    <a href="${pageContext.request.contextPath}/films/${film.idFilm}/supprimer" 
                                       class="btn btn-danger btn-lg"
                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce film ?');">
                                        <i class="bi bi-trash me-2"></i>Supprimer
                                    </a>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Colonne principale -->
                <div class="col-lg-8">
                    <!-- Synopsis -->
                    <div class="info-card">
                        <h3 class="section-title"><i class="bi bi-file-text me-2"></i>Synopsis</h3>
                        <c:choose>
                            <c:when test="${not empty film.synopsis}">
                                <p class="lead">${film.synopsis}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted"><em>Aucun synopsis disponible.</em></p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Acteurs -->
                     <!-- A venir -->
                </div>
                
                <!-- Colonne infos -->
                <div class="col-lg-4">
                    <!-- Informations techniques -->
                    <div class="info-card">
                        <h3 class="section-title"><i class="bi bi-info-circle me-2"></i>Informations</h3>
                        
                        <div class="info-label">
                            <i class="bi bi-person-video2"></i>Réalisateur
                        </div>
                        <div class="info-value">Realisateur default</div>
                        
                        <div class="info-label">
                            <i class="bi bi-globe"></i>Pays d'origine
                        </div>
                        <div class="info-value">Pays default</div>
                        
                        <div class="info-label">
                            <i class="bi bi-translate"></i>Langue originale
                        </div>
                        <div class="info-value">Anglais</div>
                        
                        <div class="info-label">
                            <i class="bi bi-soundwave"></i>Doublage
                        </div>
                        <div class="info-value">Français</div>
                        
                        <div class="info-label">
                            <i class="bi bi-shield-check"></i>Classification
                        </div>
                        <div class="info-value">
                            G
                            <br><small class="text-muted">Tous publics - General Audiences</small>
                        </div>
                    
                        <div class="info-label">
                            <i class="bi bi-tags"></i>Genres
                        </div>
                        <div class="info-value">
                            <span class="badge bg-secondary">Action</span>
                            <span class="badge bg-secondary">Comedie</span>
                        </div>
                        
                        <div class="info-label">
                            <i class="bi bi-calendar-plus"></i>Ajouté le
                        </div>
                        <div class="info-value">${film.dtCreation}</div>
                        
                    </div>
                    
                    <!-- Actions rapides -->
                    <div class="info-card">
                        <h3 class="section-title"><i class="bi bi-lightning me-2"></i>Actions</h3>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/seances?film=${film.idFilm}" 
                               class="btn btn-primary-custom">
                                <i class="bi bi-calendar-event me-2"></i>Voir les séances
                            </a>
                            <a href="${pageContext.request.contextPath}/films" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
