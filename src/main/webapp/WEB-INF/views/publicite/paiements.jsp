<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Paiements Publicité</title>
    
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
        
        .form-card, .table-container {
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
        
        .btn-primary:hover {
            background-color: #0a1629;
            border-color: #0a1629;
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
            <h1><i class="bi bi-cash-coin me-2"></i>Gestion des Paiements</h1>
            <p class="text-muted mb-0">Enregistrer les paiements des sociétés de publicité</p>
        </div>
        
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Form -->
        <div class="form-card">
            <h3 class="mb-3">Nouveau Paiement</h3>
            <form action="${pageContext.request.contextPath}/publicite/paiements/enregistrer" method="post">
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Société</label>
                        <select name="idSociete" class="form-select" required>
                            <option value="">Sélectionner...</option>
                            <c:forEach items="${societes}" var="soc">
                                <option value="${soc.idSociete}">${soc.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Montant (Ar)</label>
                        <input type="number" name="montant" class="form-control" step="0.01" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date Paiement</label>
                        <input type="date" name="dtPaiement" class="form-control" required>
                    </div>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-2"></i>Enregistrer
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Table -->
        <div class="table-container">
            <h3 class="mb-3">Historique des Paiements</h3>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Société</th>
                            <th>Montant</th>
                            <th>Pourcentage</th>
                            <th>Nb Détails</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${paiements}" var="p">
                            <tr>
                                <td>${p.dtPaiement}</td>
                                <td>${p.societe.nom}</td>
                                <td><fmt:formatNumber value="${p.montant}" type="number" minFractionDigits="2"/> Ar</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.pourcentage != null}">
                                            <span class="badge bg-info">
                                                <fmt:formatNumber value="${p.pourcentage}" type="number" maxFractionDigits="2"/>%
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.details != null}">
                                            <span class="badge bg-secondary">${p.details.size()}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">0</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
