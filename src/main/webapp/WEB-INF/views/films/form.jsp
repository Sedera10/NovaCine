<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - ${mode == 'edit' ? 'Modifier' : 'Nouveau'} Film</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
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
            color: var(--primary-color);
            padding: 1.5rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .form-card {
            background: white;
            border-radius: 4px;
            padding: 1.5rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .section-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 1.2rem;
            padding-bottom: 0.6rem;
            border-bottom: 2px solid rgba(11, 29, 58, 0.1);
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
        
        .select2-container--default .select2-selection--multiple {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            min-height: 38px;
        }
        
        .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
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
                    <li class="breadcrumb-item active">${mode == 'edit' ? 'Modifier' : 'Nouveau'}</li>
                </ol>
            </nav>
            
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="mb-0">
                    <i class="bi ${mode == 'edit' ? 'bi-pencil-square' : 'bi-plus-circle'} me-2"></i>
                    ${mode == 'edit' ? 'Modifier le film' : 'Nouveau film'}
                </h1>
            </div>
            
            <!-- Formulaire -->
            <form action="${pageContext.request.contextPath}/films/save" method="post">
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="idFilm" value="${film.idFilm}">
                </c:if>
                
                <!-- Informations principales -->
                <div class="form-card">
                    <h3 class="section-title"><i class="bi bi-info-circle me-2"></i>Informations principales</h3>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label for="titre" class="form-label">Titre <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="titre" name="titre" 
                                       value="${film.titre}" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="synopsis" class="form-label">Synopsis</label>
                        <textarea class="form-control" id="synopsis" name="synopsis" 
                                  rows="5">${film.synopsis}</textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="duree" class="form-label">Durée (minutes) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="duree" name="duree" 
                                       value="${film.duree}" min="1" required>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="dtSortie" class="form-label">Date de sortie</label>
                                <input type="date" class="form-control" id="dtSortie" name="dtSortie" 
                                       value="${film.dtSortie}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="poster" class="form-label">URL de l'affiche</label>
                        <input type="text" class="form-control" id="poster" name="poster" 
                               value="${film.posterPath}" placeholder="/ifilm.jpg">
                        <small class="text-muted">Nom de l'image (film.jpg)</small>
                    </div>
                </div>
                
                <!-- Informations techniques -->
                <div class="form-card">
                    <h3 class="section-title"><i class="bi bi-gear me-2"></i>Informations techniques</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="idPaysOrigine" class="form-label">Pays d'origine <span class="text-danger">*</span></label>
                                <select class="form-select" id="idPaysOrigine" name="idPaysOrigine">
                                    <option value="">-- Sélectionner --</option>
                                    
                                </select>
                            </div>
                        </div>
                        
                        <%-- <div class="col-md-6">
                            <div class="mb-3">
                                <label for="idClassification" class="form-label">Classification <span class="text-danger">*</span></label>
                                <select class="form-select" id="idClassification" name="idClassification">
                                    <option value="">-- Sélectionner (A venir) --</option>
                                    
                                </select>
                            </div>
                        </div> --%>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="idLangueOriginale" class="form-label">Langue originale <span class="text-danger">*</span></label>
                                <select class="form-select" id="idLangueOriginale" name="idLangueOriginale">
                                    <option value="">-- Sélectionner --</option>
                                    <option value="">English</option>
                                    <option value="">English</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="idLangueDoublage" class="form-label">Langue de doublage</label>
                                <select class="form-select" id="idLangueDoublage" name="idLangueDoublage">
                                    <option value="">-- Aucun --</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Catégories et Acteurs -->
                <div class="form-card">
                    <h3 class="section-title"><i class="bi bi-tags me-2"></i>Genres et Distribution</h3>
                    
                    <div class="mb-3">
                        <label for="categoriesIds" class="form-label">Genres</label>
                        <select class="form-select" id="categoriesIds" name="categoriesIds">
                            <option value="">Action</option>
                            <option value="">Comedie</option>
                            <option value="">Drame</option>
                        </select>
                        <small class="text-muted">Maintenez Ctrl (Cmd sur Mac) pour sélectionner plusieurs genres</small>
                    </div>
                    
                    <div class="mb-3">
                        <label for="acteursIds" class="form-label">Acteurs</label>
                        <select class="form-select" id="acteursIds" name="acteursIds" multiple>
                            <option value="">A venirr</option>
                        </select>
                        <small class="text-muted">Maintenez Ctrl (Cmd sur Mac) pour sélectionner plusieurs acteurs</small>
                    </div>
                </div>
                
                <!-- Boutons -->
                <div class="form-card">
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/films" class="btn btn-secondary btn-lg">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-primary-custom btn-lg">
                            <i class="bi bi-check-circle me-2"></i>
                            ${mode == 'edit' ? 'Mettre à jour' : 'Créer'}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialise Select2 pour les sélections multiples
            $('#categoriesIds').select2({
                placeholder: 'Sélectionnez les genres',
                allowClear: true
            });
            
            $('#acteursIds').select2({
                placeholder: 'Sélectionnez les acteurs',
                allowClear: true
            });
        });
    </script>
</body>
</html>
