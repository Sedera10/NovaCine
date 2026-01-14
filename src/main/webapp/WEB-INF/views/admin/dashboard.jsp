<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Dashboard</title>

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
        
        .welcome-card {
            background: white;
            border: 1px solid var(--primary-color);
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        
        .welcome-card h1 {
            color: var(--primary-color);
        }
        
        .welcome-card .lead {
            color: #495057;
        }
        
        .welcome-card .lead strong {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .stat-card {
            background: white;
            border-radius: 4px;
            padding: 18px;
            margin-bottom: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 12px;
        }
        
        .stat-icon.admin {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .stat-icon.manager {
            background-color: #dfe6e9;
            color: #636e72;
        }
        
        .stat-icon.caissier {
            background-color: #a29bfe;
            color: #6c5ce7;
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="../includes/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid p-4">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h1 class="mb-3">
                <i class="bi bi-stars me-2"></i>Bienvenue, ${user.prenom} !
            </h1>
            <p class="lead mb-0">
                Vous êtes connecté en tant que <strong>${user.role.nomRole}</strong>
                <c:choose>
                    <c:when test="${user.role.nomRole == 'Admin'}">
                        - Vous avez un accès complet au système
                    </c:when>
                    <c:when test="${user.role.nomRole == 'Manager'}">
                        - Gérez les séances et consultez les rapports
                    </c:when>
                    <c:when test="${user.role.nomRole == 'Caissier'}">
                        - Effectuez les ventes de billets
                    </c:when>
                </c:choose>
            </p>
        </div>
        
        <!-- Statistics Cards -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <c:choose>
                        <c:when test="${user.role.nomRole == 'Admin'}">
                            <div class="stat-icon admin">
                        </c:when>
                        <c:when test="${user.role.nomRole == 'Manager'}">
                            <div class="stat-icon manager">
                        </c:when>
                        <c:otherwise>
                            <div class="stat-icon caissier">
                        </c:otherwise>
                    </c:choose>
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <h5>Votre Rôle</h5>
                    <h3 class="text-primary">${user.role.nomRole}</h3>
                    <p class="text-muted mb-0">Niveau d'accès: ${user.role.capacite}</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #e3f2fd; color: #2196F3;">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <h5>Dernière Connexion</h5>
                    <h6 class="text-primary">Aujourd'hui</h6>
                    <p class="text-muted mb-0">Session active</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #fff3e0; color: #ff9800;">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5>Statut du Compte</h5>
                    <h6 class="text-success">Actif</h6>
                    <p class="text-muted mb-0">Membre depuis <c:out value="${user.dateCreation.toLocalDate()}" default="N/A" /></p>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-md-3 mb-3">
                <div class="stat-card text-center">
                    <i class="bi bi-ticket-perforated" style="font-size: 2.2rem; color: var(--primary-color);"></i>
                    <h5 class="mt-3">Vente Billets</h5>
                    <p class="text-muted small">Point de vente</p>
                    <button class="btn btn-sm btn-outline-primary">Accéder</button>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="stat-card text-center">
                    <i class="bi bi-film" style="font-size: 2.2rem; color: var(--primary-color);"></i>
                    <h5 class="mt-3">Gestion Films</h5>
                    <p class="text-muted small">Catalogue et séances</p>
                    <button class="btn btn-sm btn-outline-primary">Accéder</button>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="stat-card text-center">
                    <i class="bi bi-building" style="font-size: 2.2rem; color: var(--primary-color);"></i>
                    <h5 class="mt-3">Gestion Salles</h5>
                    <p class="text-muted small">Salles et sièges</p>
                    <button class="btn btn-sm btn-outline-primary">Accéder</button>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="stat-card text-center">
                    <i class="bi bi-graph-up" style="font-size: 2.2rem; color: var(--primary-color);"></i>
                    <h5 class="mt-3">Statistiques</h5>
                    <p class="text-muted small">Rapports et analyses</p>
                    <button class="btn btn-sm btn-outline-primary">Accéder</button>
                </div>
            </div>
            
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    </div>
    