<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Rapport Publicité</title>
    
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
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .summary-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            border-left: 4px solid var(--primary-color);
        }
        
        .summary-card.success {
            border-left-color: #28a745;
        }
        
        .summary-card.warning {
            border-left-color: #ffc107;
        }
        
        .summary-card.danger {
            border-left-color: #dc3545;
        }
        
        .summary-label {
            font-size: 0.85rem;
            color: #6c757d;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        
        .summary-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .table-container {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
        }
        
        .table th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            border: none;
        }
        
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0,0,0,0.02);
        }
        
        .badge-success {
            background-color: #28a745;
        }
        
        .badge-warning {
            background-color: #ffc107;
        }
        
        .badge-danger {
            background-color: #dc3545;
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
                    <h1><i class="bi bi-file-earmark-bar-graph me-2"></i>Rapport Publicité</h1>
                    <p class="text-muted mb-0">Détails des diffusions et paiements publicitaires</p>
                </div>
                <div class="d-flex gap-2">
                    <select id="moisSelect" class="form-select">
                        <option value="1" ${mois == 1 ? 'selected' : ''}>Janvier</option>
                        <option value="2" ${mois == 2 ? 'selected' : ''}>Février</option>
                        <option value="3" ${mois == 3 ? 'selected' : ''}>Mars</option>
                        <option value="4" ${mois == 4 ? 'selected' : ''}>Avril</option>
                        <option value="5" ${mois == 5 ? 'selected' : ''}>Mai</option>
                        <option value="6" ${mois == 6 ? 'selected' : ''}>Juin</option>
                        <option value="7" ${mois == 7 ? 'selected' : ''}>Juillet</option>
                        <option value="8" ${mois == 8 ? 'selected' : ''}>Août</option>
                        <option value="9" ${mois == 9 ? 'selected' : ''}>Septembre</option>
                        <option value="10" ${mois == 10 ? 'selected' : ''}>Octobre</option>
                        <option value="11" ${mois == 11 ? 'selected' : ''}>Novembre</option>
                        <option value="12" ${mois == 12 ? 'selected' : ''}>Décembre</option>
                    </select>
                    <select id="anneeSelect" class="form-select">
                        <option value="2024" ${annee == 2024 ? 'selected' : ''}>2024</option>
                        <option value="2025" ${annee == 2025 ? 'selected' : ''}>2025</option>
                        <option value="2026" ${annee == 2026 ? 'selected' : ''}>2026</option>
                    </select>
                </div>
            </div>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card success">
                <div class="summary-label">CA Réel</div>
                <div class="summary-value">
                    <fmt:formatNumber value="${rapport.caReel}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
            <div class="summary-card warning">
                <div class="summary-label">CA Maximum</div>
                <div class="summary-value">
                    <fmt:formatNumber value="${rapport.caMaximum}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Total Payé</div>
                <div class="summary-value">
                    <fmt:formatNumber value="${rapport.totalPaye}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
            <div class="summary-card danger">
                <div class="summary-label">Reste à Payer</div>
                <div class="summary-value">
                    <fmt:formatNumber value="${rapport.resteAPayer}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
        </div>
        
        <!-- Sociétés Table -->
        <div class="table-container">
            <h3 class="mb-3">Détails par Société</h3>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Société</th>
                            <th>Quota</th>
                            <th>Diffusions</th>
                            <th>Montant Contrat</th>
                            <th>Total Payé</th>
                            <th>Reste à Payer</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${rapport.societes}" var="soc">
                            <tr>
                                <td><strong>${soc.societe}</strong></td>
                                <td>${soc.quota}</td>
                                <td>${soc.nombreDiffusions}</td>
                                <td>
                                    <fmt:formatNumber value="${soc.montantContrat}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </td>
                                <td>
                                    <fmt:formatNumber value="${soc.totalPaye}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </td>
                                <td>
                                    <fmt:formatNumber value="${soc.resteAPayer}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${soc.resteAPayer <= 0}">
                                            <span class="badge badge-success">Payé</span>
                                        </c:when>
                                        <c:when test="${soc.totalPaye > 0}">
                                            <span class="badge badge-warning">Partiel</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Impayé</span>
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
    <script>
        document.getElementById('moisSelect').addEventListener('change', updateRapport);
        document.getElementById('anneeSelect').addEventListener('change', updateRapport);
        
        function updateRapport() {
            const mois = document.getElementById('moisSelect').value;
            const annee = document.getElementById('anneeSelect').value;
            window.location.href = '${pageContext.request.contextPath}/publicite/rapport?annee=' + annee + '&mois=' + mois;
        }
    </script>
</body>
</html>
