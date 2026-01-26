<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Séances</title>
    
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
        
        .page-header h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .seance-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            margin-bottom: 1.2rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .seance-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .seance-poster {
            width: 150px;
            height: 220px;
            object-fit: cover;
            border-radius: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .seance-titre {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.8rem;
        }
        
        .seance-details {
            font-size: 0.95rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .seance-details i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            font-weight: 600;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            border-color: #164a7a;
            color: white;
        }
        
        .btn-warning-custom {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .btn-warning-custom:hover {
            background-color: #e0a800;
            border-color: #e0a800;
            text-decoration: none;
            font-weight: 500;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .filters {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .seance-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            display: flex;
            gap: 1.5rem;
            transition: box-shadow 0.3s ease;
        }
        
        .seance-card:hover {
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .seance-poster {
            width: 150px;
            height: 220px;
            object-fit: cover;
            border-radius: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            flex-shrink: 0;
        }
        
        .seance-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .seance-titre {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .seance-infos {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }
        
        .seance-info-item {
            display: flex;
            align-items: center;
            color: #495057;
            font-size: 1rem;
        }
        
        .seance-info-item i {
            color: var(--primary-color);
            margin-right: 0.5rem;
            font-size: 1.1rem;
        }
        
        .seance-info-item strong {
            color: var(--primary-color);
            margin-right: 0.3rem;
        }
        
        .seance-actions {
            margin-top: auto;
            display: flex;
            gap: 0.8rem;
            justify-content: flex-end;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            color: white;
        }
        
        .btn-success-custom {
            background-color: #28a745;
            border-color: #28a745;
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }
        
        .btn-success-custom:hover {
            background-color: #218838;
            color: white;
        }
        
        .btn-warning-custom {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--primary-color);
            padding: 0.5rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }
        
        .btn-warning-custom:hover {
            background-color: #e0a800;
            color: var(--primary-color);
        }
        
        .page-header {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .page-header h1 {
            color: var(--primary-color);
            margin: 0;
        }
        
        .filter-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 1.2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .filters select, .filters input {
            padding: 8px;
            margin: 0 10px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }
        
        .date-filters {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .date-filter-btn {
            padding: 10px 24px;
            background: white;
            color: var(--primary-color);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .date-filter-btn:hover {
            border: 2px solid var(--primary-color);
            border-radius: 4px;
        }
        
        .date-filter-btn.active {
            border: 2px solid var(--primary-color);
            border-radius: 4px;
        }
        
        .seances-grid {
            display: grid;
            width: 500px;
            gap: 1.0rem;
            margin-top: 1.5rem;
        }
        
        .seance-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: row;
            height: 240px; /* Hauteur du card - augmenter/diminuer ici */
        }
        
        .seance-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .seance-poster {
            width: 145px;  /* Largeur de l'image - augmenter/diminuer ici */
            height: 190px; /* Hauteur de l'image (même que card) */
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            flex-shrink: 0;
        }
        
        .seance-content {
            padding: 1rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .seance-titre {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.6rem;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .seance-infos {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
            margin-bottom: 0.8rem;
        }
        
        .seance-info-item {
            display: flex;
            align-items: center;
            color: #495057;
            font-size: 0.85rem;
        }
        
        .seance-info-item i {
            color: var(--primary-color);
            margin-right: 0.5rem;
            font-size: 0.9rem;
            width: 16px;
        }
        
        .seance-actions {
            display: flex;
            flex-direction: row;
            gap: 0.3rem;
            margin-top: auto;
        }
        
        .btn-action {
            padding: 0.4rem 0.6rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.3rem;
            transition: all 0.3s;
            border: none;
            font-size: 0.9rem;
            flex: 1;
        }
        
        .btn-action i {
            font-size: 0.6rem;
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
                        <h1 class="mb-2"><i class="bi bi-film me-2"></i>Séances de Cinéma</h1>
                        <p class="mb-0 opacity-75">Liste des Séances Completes</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/seances/nouveau" class="btn-warning-custom">
                        <i class="bi bi-plus-circle me-2"></i>Nouveau séance
                    </a>
                    
                </div>
                <!-- <h1><i class="bi bi-calendar-event me-2"></i>Séances de Cinéma</h1> -->
            </div>
        
        <!-- Filtres -->
        <div class="filter-card">
            <form method="get" action="<c:url value='/seances'/>" class="row g-3" id="filterForm">
                <input type="hidden" name="periode" id="periodeInput" value="${periodeActive}">
                
                <div class="col-md-4">
                    <label class="form-label">Film:</label>
                    <select name="filmId" class="form-select">
                        <option value="">Tous les films</option>
                        <c:forEach items="${films}" var="film">
                            <option value="${film.idFilm}" ${filmId == film.idFilm ? 'selected' : ''}>
                                ${film.titre}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="col-md-3">
                    <label class="form-label">Salle:</label>
                    <select name="salleId" class="form-select">
                        <option value="">Toutes les salles</option>
                        <c:forEach items="${salles}" var="salle">
                            <option value="${salle.idSalle}" ${salleId == salle.idSalle ? 'selected' : ''}>
                                ${salle.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="col-md-3">
                    <label class="form-label">Date spécifique:</label>
                    <input type="date" name="date" value="${date}" class="form-control">
                </div>
                
                <div class="col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary-custom flex-grow-1">
                        <i class="bi bi-search"></i> Filtrer
                    </button>
                    <a href="<c:url value='/seances'/>" class="btn btn-outline-secondary">
                        <i class="bi bi-x-circle"></i>
                    </a>
                </div>
            </form>
            
            <!-- Filtres de date rapides -->
            <div class="date-filters">
                <a href="?periode=aujourd_hui<c:if test='${not empty filmId}'>&filmId=${filmId}</c:if><c:if test='${not empty salleId}'>&salleId=${salleId}</c:if>" 
                   class="date-filter-btn ${periodeActive == 'aujourd_hui' ? 'active' : ''}">
                    <i class="bi bi-calendar-day me-1"></i>Aujourd'hui
                </a>
                <a href="?periode=demain<c:if test='${not empty filmId}'>&filmId=${filmId}</c:if><c:if test='${not empty salleId}'>&salleId=${salleId}</c:if>" 
                   class="date-filter-btn ${periodeActive == 'demain' ? 'active' : ''}">
                    <i class="bi bi-calendar-plus me-1"></i>Demain
                </a>
                <a href="?periode=semaine<c:if test='${not empty filmId}'>&filmId=${filmId}</c:if><c:if test='${not empty salleId}'>&salleId=${salleId}</c:if>" 
                   class="date-filter-btn ${periodeActive == 'semaine' ? 'active' : ''}">
                    <i class="bi bi-calendar-week me-1"></i>Cette semaine
                </a>
                <a href="?periode=semaine_prochaine<c:if test='${not empty filmId}'>&filmId=${filmId}</c:if><c:if test='${not empty salleId}'>&salleId=${salleId}</c:if>" 
                   class="date-filter-btn ${periodeActive == 'semaine_prochaine' ? 'active' : ''}">
                    <i class="bi bi-calendar-range me-1"></i>Semaine prochaine
                </a>
                <a href="?periode=tous<c:if test='${not empty filmId}'>&filmId=${filmId}</c:if><c:if test='${not empty salleId}'>&salleId=${salleId}</c:if>" 
                   class="date-filter-btn ${periodeActive == 'tous' ? 'active' : ''}">
                    <i class="bi bi-calendar3 me-1"></i>Tous
                </a>
            </div>
        </div>
        
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- Grille des séances -->
        <div class="seances-grid">
            <c:forEach items="${seances}" var="seance">
                <div class="seance-card">
                    <!-- Poster en haut -->
                    <img src="<c:url value='/images/films/${seance.film.poster}'/>" 
                         alt="${seance.film.titre}" 
                         class="seance-poster"
                         onerror="this.style.background='linear-gradient(135deg, #667eea 0%, #764ba2 100%)'; this.style.display='flex'; this.style.alignItems='center'; this.style.justifyContent='center'; this.innerHTML='<i class=&quot;bi bi-film&quot; style=&quot;font-size: 3rem; color: white;&quot;></i>'">
                    
                    <!-- Contenu -->
                    <div class="seance-content">
                        <!-- Titre -->
                        <div class="seance-titre">${seance.film.titre}</div>
                        
                        <!-- Infos -->
                        <div class="seance-infos">
                            <div class="seance-info-item">
                                <i class="bi bi-calendar-event"></i>
                                <fmt:parseDate value="${seance.dateSeance}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
                            </div>
                            <div class="seance-info-item">
                                <i class="bi bi-clock"></i>
                                ${seance.heureSeance}
                            </div>
                            <div class="seance-info-item">
                                <i class="bi bi-door-open"></i>
                                ${seance.salle.nom}
                            </div>
                        </div>
                        
                        <!-- Boutons d'action -->
                        <div class="seance-actions">
                            <a href="<c:url value='/seances/${seance.idSeance}'/>" class="btn-action btn-primary-custom">
                                <i class="bi bi-eye"></i> Détails
                            </a>
                            <a href="<c:url value='/achats/seance/${seance.idSeance}'/>" class="btn-action btn-success-custom">
                                <i class="bi bi-ticket-perforated"></i> Acheter
                            </a>
                            <a href="<c:url value='/seances/${seance.idSeance}/ventes'/>" class="btn-action btn-warning-custom">
                                <i class="bi bi-cash-stack"></i> Ventes
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty seances}">
            <div class="alert alert-info mt-4">
                <i class="bi bi-info-circle me-2"></i>Aucune séance trouvée pour cette période.
            </div>
        </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
