<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Statistiques Séances</title>
    
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
            white-space: nowrap;
        }
        
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0,0,0,0.02);
        }
        
        .table tbody tr:hover {
            background-color: rgba(11, 29, 58, 0.05);
        }
        
        .badge-success {
            background-color: #28a745;
            padding: 0.4rem 0.8rem;
        }
        
        .badge-warning {
            background-color: #ffc107;
            color: #000;
            padding: 0.4rem 0.8rem;
        }
        
        .badge-info {
            background-color: #17a2b8;
            padding: 0.4rem 0.8rem;
        }
        
        .text-success {
            color: #28a745 !important;
            font-weight: 600;
        }
        
        .text-warning {
            color: #ffc107 !important;
            font-weight: 600;
        }
        
        .text-primary-custom {
            color: var(--primary-color) !important;
            font-weight: 700;
        }
        
        .text-danger {
            color: #dc3545 !important;
            font-weight: 600;
        }
        
        .text-info {
            color: #17a2b8 !important;
            font-weight: 600;
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
                    <h1><i class="bi bi-graph-up me-2"></i>Statistiques par Séance</h1>
                    <p class="text-muted mb-0">Résultats financiers détaillés de chaque séance</p>
                </div>
            </div>
        </div>
        
        <!-- Table Container -->
        <div class="table-container">
            <h3 class="mb-3">Toutes les séances</h3>
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Film</th>
                            <th>Salle</th>
                            <th>Date</th>
                            <th>Heure</th>
                            <th class="text-end">Nb Billets</th>
                            <th class="text-end">CA Ventes</th>
                            <th class="text-end">CA Publicité</th>
                            <th class="text-end">Total Payé</th>
                            <th class="text-end">Reste à Payer</th>
                            <th class="text-end">% Payé</th>
                            <th class="text-end">CA Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${seances}" var="seance">
                            <tr>
                                <td><strong>${seance.idSeance}</strong></td>
                                <td>
                                    <strong>${seance.film.titre}</strong>
                                
                                </td>
                                <td>
                                    <span class="badge badge-info">${seance.salle.nom}</span>
                                </td>
                                <td>${seance.dateSeance}</td>
                                <td>${seance.heureSeance}</td>
                                <td class="text-end">
                                    <strong>${nbBilletsParSeance[seance.idSeance]}</strong>
                                </td>
                                <td class="text-end text-success">
                                    <fmt:formatNumber value="${caVentesParSeance[seance.idSeance]}" 
                                                      type="number" 
                                                      minFractionDigits="2" 
                                                      maxFractionDigits="2"/> Ar
                                </td>
                                <td class="text-end text-warning">
                                    <fmt:formatNumber value="${caPubliciteParSeance[seance.idSeance]}" 
                                                      type="number" 
                                                      minFractionDigits="2" 
                                                      maxFractionDigits="2"/> Ar
                                </td>
                                <td class="text-end text-info">
                                    <fmt:formatNumber value="${totalPayeParSeance[seance.idSeance]}" 
                                                      type="number" 
                                                      minFractionDigits="2" 
                                                      maxFractionDigits="2"/> Ar
                                </td>
                                <td class="text-end text-danger">
                                    <fmt:formatNumber value="${resteAPayerParSeance[seance.idSeance]}" 
                                                      type="number" 
                                                      minFractionDigits="2" 
                                                      maxFractionDigits="2"/> Ar
                                </td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${pourcentagePayeParSeance[seance.idSeance] >= 100}">
                                            <span class="badge bg-success">
                                                <fmt:formatNumber value="${pourcentagePayeParSeance[seance.idSeance]}" 
                                                                  type="number" 
                                                                  maxFractionDigits="2"/>%
                                            </span>
                                        </c:when>
                                        <c:when test="${pourcentagePayeParSeance[seance.idSeance] >= 50}">
                                            <span class="badge bg-warning text-dark">
                                                <fmt:formatNumber value="${pourcentagePayeParSeance[seance.idSeance]}" 
                                                                  type="number" 
                                                                  maxFractionDigits="2"/>%
                                            </span>
                                        </c:when>
                                        <c:when test="${pourcentagePayeParSeance[seance.idSeance] > 0}">
                                            <span class="badge bg-danger">
                                                <fmt:formatNumber value="${pourcentagePayeParSeance[seance.idSeance]}" 
                                                                  type="number" 
                                                                  maxFractionDigits="2"/>%
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">0%</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end text-primary-custom">
                                    <fmt:formatNumber value="${caTotalParSeance[seance.idSeance]}" 
                                                      type="number" 
                                                      minFractionDigits="2" 
                                                      maxFractionDigits="2"/> Ar
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty seances}">
                            <tr>
                                <td colspan="12" class="text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    Aucune séance trouvée
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                    
                    <!-- Total Footer -->
                    <c:if test="${not empty seances}">
                        <tfoot>
                            <tr class="table-secondary">
                                <th colspan="5" class="text-end">TOTAL</th>
                                <th class="text-end">
                                    <c:set var="totalBillets" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalBillets" value="${totalBillets + nbBilletsParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    ${totalBillets}
                                </th>
                                <th class="text-end text-success">
                                    <c:set var="totalVentes" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalVentes" value="${totalVentes + caVentesParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalVentes}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </th>
                                <th class="text-end text-warning">
                                    <c:set var="totalPub" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalPub" value="${totalPub + caPubliciteParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalPub}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </th>
                                <th class="text-end text-info">
                                    <c:set var="totalGlobalPaye" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalGlobalPaye" value="${totalGlobalPaye + totalPayeParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalGlobalPaye}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </th>
                                <th class="text-end text-danger">
                                    <c:set var="totalResteAPayer" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalResteAPayer" value="${totalResteAPayer + resteAPayerParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalResteAPayer}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </th>
                                <th class="text-end">
                                    <c:set var="sommePub" value="0"/>
                                    <c:set var="sommeRestePub" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="sommePub" value="${sommePub + caPubliciteParSeance[s.idSeance]}"/>
                                        <c:set var="sommeRestePub" value="${sommeRestePub + resteAPayerParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <c:choose>
                                        <c:when test="${sommePub > 0}">
                                            <c:set var="pourcentageGlobal" value="${(sommePub - sommeRestePub) / sommePub * 100}"/>
                                            <c:choose>
                                                <c:when test="${pourcentageGlobal >= 100}">
                                                    <span class="badge bg-success"><fmt:formatNumber value="${pourcentageGlobal}" maxFractionDigits="2"/>%</span>
                                                </c:when>
                                                <c:when test="${pourcentageGlobal >= 50}">
                                                    <span class="badge bg-warning text-dark"><fmt:formatNumber value="${pourcentageGlobal}" maxFractionDigits="2"/>%</span>
                                                </c:when>
                                                <c:when test="${pourcentageGlobal > 0}">
                                                    <span class="badge bg-danger"><fmt:formatNumber value="${pourcentageGlobal}" maxFractionDigits="2"/>%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">0%</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">0%</span>
                                        </c:otherwise>
                                    </c:choose>
                                </th>
                                <th class="text-end text-primary-custom">
                                    <c:set var="totalGeneral" value="0"/>
                                    <c:forEach items="${seances}" var="s">
                                        <c:set var="totalGeneral" value="${totalGeneral + caTotalParSeance[s.idSeance]}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalGeneral}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                                </th>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
            </div>
            
            <!-- Détails par Société -->
            <c:if test="${not empty societes}">
                <h4 class="mt-4 mb-3">Détails par Société</h4>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Société</th>
                                <th class="text-end">Total à Payer</th>
                                <th class="text-end">Total Payé</th>
                                <th class="text-end">Reste à Payer</th>
                                <th class="text-end">% Payé</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${societes}" var="soc">
                                <tr>
                                    <td><strong>${soc.nom}</strong></td>
                                    <td class="text-end text-warning">
                                        <fmt:formatNumber value="${totalAPayerParSociete[soc.nom]}" 
                                                          type="number" 
                                                          minFractionDigits="2" 
                                                          maxFractionDigits="2"/> Ar
                                    </td>
                                    <td class="text-end text-info">
                                        <fmt:formatNumber value="${totalPayeParSociete[soc.nom]}" 
                                                          type="number" 
                                                          minFractionDigits="2" 
                                                          maxFractionDigits="2"/> Ar
                                    </td>
                                    <td class="text-end text-danger">
                                        <fmt:formatNumber value="${resteAPayerParSociete[soc.nom]}" 
                                                          type="number" 
                                                          minFractionDigits="2" 
                                                          maxFractionDigits="2"/> Ar
                                    </td>
                                    <td class="text-end">
                                        <c:set var="totalAPayer" value="${totalAPayerParSociete[soc.nom]}"/>
                                        <c:set var="totalPaye" value="${totalPayeParSociete[soc.nom]}"/>
                                        <c:choose>
                                            <c:when test="${totalAPayer > 0}">
                                                <c:set var="pourcentage" value="${totalPaye / totalAPayer * 100}"/>
                                                <c:choose>
                                                    <c:when test="${pourcentage >= 100}">
                                                        <span class="badge bg-success">
                                                            <fmt:formatNumber value="${pourcentage}" maxFractionDigits="2"/>%
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pourcentage >= 50}">
                                                        <span class="badge bg-warning text-dark">
                                                            <fmt:formatNumber value="${pourcentage}" maxFractionDigits="2"/>%
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pourcentage > 0}">
                                                        <span class="badge bg-danger">
                                                            <fmt:formatNumber value="${pourcentage}" maxFractionDigits="2"/>%
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">0%</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
