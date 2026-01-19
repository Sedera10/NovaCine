<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Types de Places</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root { --primary-color: #0B1D3A; --secondary-color: #FFC107; }
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .page-header { background: white; border: 1px solid var(--primary-color); border-radius: 4px; padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
        .page-header h1 { color: var(--primary-color); }
        .card-panel { background: white; border-radius: 8px; padding: 1.2rem; margin-bottom: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
        .btn-primary-custom { background-color: var(--primary-color); border-color: var(--primary-color); color: white; }
        .btn-secondary-custom { background-color: var(--secondary-color); border-color: var(--secondary-color); color: var(--primary-color); font-weight: 600; }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-0"><i class="bi bi-tags me-2"></i>Types de Places</h1>
                    <p class="mb-0 opacity-75">Gérer les types de places et leurs prix</p>
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

            <!-- Liste -->
            <div class="card-panel">
                <h5 class="mb-3">Liste des types de places</h5>
                <p class="text-muted small">Note: Les prix sont définis par séance dans la configuration des séances.</p>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nom</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tp" items="${typesPlaces}">
                            <tr>
                                <td>${tp.id_type_place}</td>
                                <td>${tp.nom}</td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/salles/types?editId=${tp.id_type_place}" class="btn btn-sm btn-outline-secondary me-1">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/salles/types/${tp.id_type_place}/supprimer" method="post" class="d-inline" onsubmit="return confirm('Supprimer ce type de place ?');">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Formulaire (création / modification) -->
            <div class="card-panel">
                <h5 class="mb-3">${editingType != null && editingType.id_type_place != null ? 'Modifier' : 'Créer'} un type de place</h5>
                <c:choose>
                    <c:when test="${editingType != null && editingType.id_type_place != null}">
                        <form action="${pageContext.request.contextPath}/salles/types/${editingType.id_type_place}/modifier" method="post" class="row g-3">
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/salles/types" method="post" class="row g-3">
                    </c:otherwise>
                </c:choose>

                    <div class="col-md-10">
                        <label class="form-label">Nom</label>
                        <input name="nom" value="${editingType.nom}" required class="form-control" />
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary-custom w-100">
                            <i class="bi bi-save me-1"></i>
                            <c:choose>
                                <c:when test="${editingType != null && editingType.id_type_place != null}">Mettre à jour</c:when>
                                <c:otherwise>Créer</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>

            <div class="mt-4 text-muted text-center">
                <i class="bi bi-info-circle me-2"></i>
                Total: <strong>${typesPlaces.size()}</strong> type(s)
            </div>

        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>