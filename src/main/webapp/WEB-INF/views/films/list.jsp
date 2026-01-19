<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Films</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-color: #0B1D3A;
            --secondary-color: #FFC107;
            --grad: linear-gradient(135deg, #0B1D3A 75%, #FFC107 25%);
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
            background: var(--white);
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .page-header h1 {
            color: var(--primary-color);
        }
        
        .page-header p {
            color: #6c757d;
        }
        
        .filter-card {
            background: white;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .film-card {
            background: white;
            border-radius: 4px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            height: 100%;
        }
        
        .film-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .film-poster {
            width: 100%;
            height: 280px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
        }
        
        .film-body {
            padding: 1.2rem;
        }
        
        .film-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
            min-height: 48px;
        }
        
        .film-info {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .film-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-right: 5px;
            margin-bottom: 5px;
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
        
        .btn-primary-custom {
            background: var(--grad);
            color: white;
        }
        
        .btn-primary-custom:hover {
            font-size: 1.05em;
            transition: 150ms;
            color: white;
        }
        
        .btn-secondary-custom {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .btn-secondary-custom:hover {
            background-color: #e0a800;
            border-color: #e0a800;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="../includes/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid p-4">
            
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="mb-2"><i class="bi bi-film me-2"></i>Gestion des Films</h1>
                        <p class="mb-0 opacity-75">Catalogue complet des films</p>
                    </div>
                        <a href="${pageContext.request.contextPath}/films/nouveau" class="btn btn-secondary-custom btn-lg">
                            <i class="bi bi-plus-circle me-2"></i>Nouveau Film
                        </a>
              
                </div>
            </div>
            
            <!-- Messages -->
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
            
            <!-- Filtres -->
            <div class="filter-card">
                <form action="${pageContext.request.contextPath}/films" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-search me-2"></i>Recherche</label>
                        <input type="text" name="search" class="form-control" placeholder="Titre du film..." value="${search}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-funnel me-2"></i>Statut</label>
                        <select name="statut" class="form-select">
                            <option value="">Tous les statuts</option>
                            <option value="EN_SALLE" ${statut == 'EN_SALLE' ? 'selected' : ''}>En salle</option>
                            <option value="A_VENIR" ${statut == 'A_VENIR' ? 'selected' : ''}>À venir</option>
                            <option value="ARCHIVE" ${statut == 'ARCHIVE' ? 'selected' : ''}>Archivés</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-tag me-2"></i>Catégorie</label>
                        <select name="idCategorie" class="form-select">
                            <option value="">Toutes</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.idCategorie}" ${idCategorie == cat.idCategorie ? 'selected' : ''}>${cat.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-globe me-2"></i>Pays</label>
                        <select name="idPays" class="form-select">
                            <option value="">Tous</option>
                            <c:forEach var="p" items="${pays}">
                                <option value="${p.idPays}" ${idPays == p.idPays ? 'selected' : ''}>${p.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-shield me-2"></i>Classification</label>
                        <select name="idClassification" class="form-select">
                            <option value="">Toutes</option>
                            <c:forEach var="cls" items="${classifications}">
                                <option value="${cls.idClassification}" ${idClassification == cls.idClassification ? 'selected' : ''}>${cls.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-12 d-flex gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="bi bi-search me-2"></i>Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/films" class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-2"></i>Réinitialiser
                        </a>
                    </div>
                </form>
            </div>
            
            <!-- Liste des Films -->
            <c:choose>
                <c:when test="${empty films}">
                    <div class="empty-state">
                        <i class="bi bi-film"></i>
                        <h3>Aucun film trouvé</h3>
                        <p>Aucun film ne correspond à vos critères de recherche.</p>
                        <c:if test="${user.role.nomRole eq 'Admin' or user.role.nomRole eq 'Manager'}">
                            <a href="${pageContext.request.contextPath}/films/nouveau" class="btn btn-primary-custom mt-3">
                                <i class="bi bi-plus-circle me-2"></i>Ajouter un film
                            </a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="film" items="${films}">
                            <div class="col-md-6 col-lg-4 col-xl-3">
                                <div class="film-card">
                                    <!-- Poster -->
                                    <c:choose>
                                        <c:when test="${not empty film.posterPath}">
                                            <img src="<c:url value='/images/films/${film.posterPath}'/>" 
                                                 alt="${film.titre}" class="film-poster" 
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="film-poster" style="display: none;">
                                                <i class="bi bi-film"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="film-poster">
                                                <i class="bi bi-film"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Body -->
                                    <div class="film-body">
                                        <h5 class="film-title">${film.titre}</h5>
                                        
                                        <div class="film-info">
                                            <i class="bi bi-clock me-1"></i>${film.duree} min
                                        </div>
                                        
                                        <c:if test="${not empty film.dtSortie}">
                                            <div class="film-info">
                                                <i class="bi bi-calendar-event me-1"></i>${film.dtSortie}
                                            </div>
                                        </c:if>
                                        
                                        <div class="mt-3 d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/films/${film.idFilm}" 
                                               class="btn btn-sm btn-primary-custom flex-grow-1">
                                                <i class="bi bi-eye me-1"></i>Voir
                                            </a>
                                            <c:if test="${user.role.nomRole eq 'Admin' or user.role.nomRole eq 'Manager'}">
                                                <a href="${pageContext.request.contextPath}/films/${film.idFilm}/modifier" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Statistiques -->
                    <div class="mt-4 text-muted text-center">
                        <i class="bi bi-info-circle me-2"></i>
                        Total: <strong>${films.size()}</strong> film(s)
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
