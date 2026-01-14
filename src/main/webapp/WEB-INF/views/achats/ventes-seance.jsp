<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Ventes de la Séance</title>
    
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
            margin: 0;
        }
        
        .stats-card {
            background: white;
            border: 1px solid var(--primary-color);
            padding: 1.5rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .stats-card h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .stats-card p {
            color: #495057;
            margin: 0;
        }
        
        .stats-card strong {
            color: var(--primary-color);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 1.5rem;
        }
        
        .stat-item {
            background: white;
            border: 1px solid #dee2e6;
            padding: 15px;
            border-radius: 4px;
            text-align: center;
            transition: border-color 0.3s;
        }
        
        .stat-item:hover {
            border-color: var(--primary-color);
        }
        
        .stat-value {
            font-size: 2em;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            color: #6c757d;
            margin-top: 5px;
            font-size: 0.9rem;
        }
        
        .section-title {
            color: var(--primary-color);
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-color);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            overflow: hidden;
        }
        
        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        
        table th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
        }
        
        table tr:hover {
            background-color: #f8f9fa;
        }
        
        table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .total-ventes {
            background: var(--secondary-color);
            color: var(--primary-color);
            padding: 1.5rem;
            border-radius: 4px;
            text-align: center;
            margin: 1.5rem 0;
            font-size: 1.5em;
            font-weight: 700;
            border: 2px solid var(--primary-color);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
        }
        
        .btn-primary-custom:hover {
            background-color: #164a7a;
            color: white;
        }
        
        .btn-secondary-custom {
            background-color: white;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            padding: 0.6rem 1.5rem;
            border-radius: 4px;
            font-weight: 600;
            text-decoration: none;
        }
        
        .btn-secondary-custom:hover {
            background-color: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="page-header">
                <h1><i class="bi bi-receipt"></i> Ventes de la Séance</h1>
            </div>
        
            <!-- Infos séance -->
            <div class="stats-card">
                <h3><i class="bi bi-film"></i> ${seance.film.titre}</h3>
                <p>
                    <strong>Date:</strong> ${seance.daty} |
                    <strong>Heure:</strong> ${seance.heure} |
                    <strong>Salle:</strong> ${seance.salle.nom}
                </p>
            </div>
        
            <!-- Statistiques -->
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-value">${stats.capaciteTotale}</div>
                    <div class="stat-label">Capacité Totale</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${stats.billetsVendus}</div>
                    <div class="stat-label">Places Vendues</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${stats.billetsDisponibles}</div>
                    <div class="stat-label">Places Restantes</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <fmt:formatNumber value="${stats.tauxRemplissage}" pattern="#0.0"/>%
                    </div>
                    <div class="stat-label">Taux de Remplissage</div>
                </div>
            </div>
        
            <!-- Liste des ventes -->
            <h3 class="section-title"><i class="bi bi-list-ul"></i> Liste des Ventes</h3>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Date/Heure</th>
                        <th>Acheteur</th>
                        <th>Places</th>
                        <th>Nb Billets</th>
                        <th>Montant</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${achats}" var="achat">
                        <tr>
                            <td>#${achat.idAchat}</td>
                            <td>
                                ${achat.dtAchat}
                            </td>
                            <td>${achat.nomAcheteur}</td>
                            <td>
                                <c:forEach items="${achat.billets}" var="billet" varStatus="status">
                                    ${billet.place.codePlace}<c:if test="${not status.last}">, </c:if>
                                </c:forEach>
                            </td>
                            <td>${achat.billets.size()}</td>
                            <td><strong>${achat.total} Ar</strong></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        
            <c:if test="${empty achats}">
                <div style="background: white; border: 1px solid #dee2e6; padding: 1rem; border-radius: 4px; color: #6c757d;">
                    <i class="bi bi-info-circle"></i> Aucune vente enregistrée pour cette séance.
                </div>
            </c:if>
        
            <!-- Total des ventes -->
            <div class="total-ventes">
                <i class="bi bi-cash-stack"></i> TOTAL DES VENTES: ${totalVentes} Ar
            </div>
        
            <div class="text-center" style="margin-top: 2rem;">
                <a href="<c:url value='/seances'/>" class="btn-primary-custom"><i class="bi bi-arrow-left"></i> Retour aux séances</a>
                <a href="<c:url value='/achats/liste'/>" class="btn-secondary-custom"><i class="bi bi-receipt-cutoff"></i> Toutes les ventes</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
