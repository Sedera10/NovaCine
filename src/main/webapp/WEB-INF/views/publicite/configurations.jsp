<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Configurations Publicité</title>
    
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
        
        .config-section {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            margin-bottom: 2rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .table th {
            background-color: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp"/>
    
    <div class="main-content">
        <div class="page-header">
            <h1><i class="bi bi-gear me-2"></i>Configurations Publicité</h1>
            <p class="text-muted mb-0">Gestion des sociétés, prix et contrats</p>
        </div>
        
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Sociétés -->
        <div class="config-section">
            <h3 class="mb-3">Sociétés</h3>
            <form action="${pageContext.request.contextPath}/publicite/configurations/societes/create" method="post" class="row g-3 mb-3">
                <div class="col-md-8">
                    <input type="text" name="nom" class="form-control" placeholder="Nom de la société" required>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-plus-circle me-2"></i>Ajouter
                    </button>
                </div>
            </form>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${societes}" var="s">
                        <tr>
                            <td>${s.idSociete}</td>
                            <td>${s.nom}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/publicite/configurations/societes/${s.idSociete}/delete" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer?')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Prix -->
        <div class="config-section">
            <h3 class="mb-3">Tarifs Publicité</h3>
            <form action="${pageContext.request.contextPath}/publicite/configurations/prix/create" method="post" class="row g-3 mb-3">
                <div class="col-md-8">
                    <input type="number" name="valeur" class="form-control" placeholder="Prix" step="0.01" required>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-plus-circle me-2"></i>Ajouter
                    </button>
                </div>
            </form>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Valeur</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${prixList}" var="p">
                        <tr>
                            <td>${p.idPrix}</td>
                            <td><fmt:formatNumber value="${p.valeur}" type="number" minFractionDigits="2"/> Ar</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/publicite/configurations/prix/${p.idPrix}/delete" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer?')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Contrats -->
        <div class="config-section">
            <h3 class="mb-3">Contrats</h3>
            <form action="${pageContext.request.contextPath}/publicite/configurations/contrats/create" method="post" class="row g-3 mb-3">
                <div class="col-md-3">
                    <select name="idSociete" class="form-select" required>
                        <option value="">Société...</option>
                        <c:forEach items="${societes}" var="s">
                            <option value="${s.idSociete}">${s.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="idPrix" class="form-select" required>
                        <option value="">Prix...</option>
                        <c:forEach items="${prixList}" var="p">
                            <option value="${p.idPrix}">
                                <fmt:formatNumber value="${p.valeur}" type="number" minFractionDigits="2"/> Ar
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="date" name="dtContrat" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <input type="number" name="quota" class="form-control" placeholder="Quota" required>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-plus-circle me-2"></i>Créer
                    </button>
                </div>
            </form>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Société</th>
                        <th>Date</th>
                        <th>Quota</th>
                        <th>Prix</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${contrats}" var="c">
                        <tr>
                            <td>${c.societe.nom}</td>
                            <td>${c.dtContrat}</td>
                            <td>${c.quota}</td>
                            <td><fmt:formatNumber value="${c.prix.valeur}" type="number" minFractionDigits="2"/> Ar</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/publicite/configurations/contrats/${c.idContrat}/delete" method="post" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer?')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
