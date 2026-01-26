<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Dashboard</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
            font-size: 2rem;
            font-weight: 600;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            border-left: 4px solid var(--primary-color);
            transition: transform 0.2s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .stat-card.ventes {
            border-left-color: #28a745;
        }
        
        .stat-card.publicite {
            border-left-color: #ffc107;
        }
        
        .stat-card.total {
            border-left-color: #0B1D3A;
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .stat-icon {
            font-size: 2rem;
            opacity: 0.3;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            margin-bottom: 2rem;
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 0;
        }
        
        .date-selector {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .date-selector select {
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }
        
        .rapport-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .rapport-link:hover {
            background: #0a1629;
            color: white;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="../includes/sidebar.jsp"/>
    
    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="bi bi-speedometer2 me-2"></i>Dashboard</h1>
            <p class="text-muted mb-0">Vue d'ensemble du chiffre d'affaires</p>
        </div>
        
        <!-- Date Selector -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="date-selector">
                <label class="fw-semibold">Période :</label>
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
            <a href="${pageContext.request.contextPath}/publicite/rapport?annee=${annee}&mois=${mois}" class="rapport-link">
                <i class="bi bi-file-earmark-text"></i>
                Voir rapport détaillé
            </a>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <!-- CA Ventes -->
            <div class="stat-card ventes">
                <div class="stat-header">
                    <span class="stat-label">CA Ventes Billets</span>
                    <i class="bi bi-ticket-perforated stat-icon" style="color: #28a745;"></i>
                </div>
                <div class="stat-value">
                    <fmt:formatNumber value="${caVentes}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
            
            <!-- CA Publicité -->
            <div class="stat-card publicite">
                <div class="stat-header">
                    <span class="stat-label">CA Publicité</span>
                    <i class="bi bi-megaphone stat-icon" style="color: #ffc107;"></i>
                </div>
                <div class="stat-value">
                    <fmt:formatNumber value="${caPublicite}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
            
            <!-- CA Total -->
            <div class="stat-card total">
                <div class="stat-header">
                    <span class="stat-label">Chiffre d'Affaires Total</span>
                    <i class="bi bi-cash-stack stat-icon"></i>
                </div>
                <div class="stat-value">
                    <fmt:formatNumber value="${caTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> Ar
                </div>
            </div>
        </div>
        
        <!-- Chart Container -->
        <div class="chart-container">
            <div class="chart-header">
                <h3 class="chart-title">Évolution du CA sur l'année ${annee}</h3>
            </div>
            <canvas id="caChart" height="80"></canvas>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Change mois/annee
        document.getElementById('moisSelect').addEventListener('change', updateDashboard);
        document.getElementById('anneeSelect').addEventListener('change', updateDashboard);
        
        function updateDashboard() {
            const mois = document.getElementById('moisSelect').value;
            const annee = document.getElementById('anneeSelect').value;
            window.location.href = '${pageContext.request.contextPath}/dashboard?annee=' + annee + '&mois=' + mois;
        }
        
        // Load chart data
        const annee = ${annee};
        fetch('${pageContext.request.contextPath}/dashboard/api/annee/' + annee)
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('caChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.mois,
                        datasets: [
                            {
                                label: 'CA Ventes',
                                data: data.caVentes,
                                borderColor: '#28a745',
                                backgroundColor: 'rgba(40, 167, 69, 0.1)',
                                tension: 0.4,
                                fill: true
                            },
                            {
                                label: 'CA Publicité',
                                data: data.caPublicite,
                                borderColor: '#ffc107',
                                backgroundColor: 'rgba(255, 193, 7, 0.1)',
                                tension: 0.4,
                                fill: true
                            },
                            {
                                label: 'CA Total',
                                data: data.caTotal,
                                borderColor: '#0B1D3A',
                                backgroundColor: 'rgba(11, 29, 58, 0.1)',
                                tension: 0.4,
                                fill: true,
                                borderWidth: 3
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: true,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top'
                            },
                            tooltip: {
                                mode: 'index',
                                intersect: false,
                                callbacks: {
                                    label: function(context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        label += new Intl.NumberFormat('fr-FR', {
                                            minimumFractionDigits: 2,
                                            maximumFractionDigits: 2
                                        }).format(context.parsed.y) + ' Ar';
                                        return label;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return new Intl.NumberFormat('fr-FR').format(value) + ' Ar';
                                    }
                                }
                            }
                        }
                    }
                });
            });
    </script>
</body>
</html>
