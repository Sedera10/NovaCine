<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Confirmation d'Achat</title>
    
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
        
        .confirmation {
            background: white;
            border: 2px solid var(--secondary-color);
            padding: 30px;
            border-radius: 4px;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            margin: 20px 0;
        }
        .confirmation h2 {
            color: #155724;
            margin-bottom: 20px;
        }
        .recap {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: left;
        }
        .recap-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .recap-item:last-child {
            border-bottom: none;
        }
    </style>
.main-content {
            margin-left: 240px;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
        <div class="confirmation">
            <h2>✓ Achat confirmé avec succès !</h2>
            <p>Merci pour votre achat. Voici le récapitulatif de votre commande.</p>
        </div>
        
        <div class="recap">
            <h3>Récapitulatif de l'achat</h3>
            
            <div class="recap-item">
                <strong>Numéro d'achat:</strong> #${achat.idAchat}
            </div>
            
            <div class="recap-item">
                <strong>Date d'achat:</strong> 
                ${achat.dtAchat}
            </div>
            
            <div class="recap-item">
                <strong>Nom de l'acheteur:</strong> ${achat.nomAcheteur}
            </div>
            
            <div class="recap-item">
                <strong>Nombre de billets:</strong> ${achat.billets.size()}
            </div>
            
            <div class="recap-item">
                <strong>Places:</strong>
                <c:forEach items="${achat.billets}" var="billet" varStatus="status">
                    ${billet.place.codePlace}<c:if test="${not status.last}">, </c:if>
                </c:forEach>
            </div>
            
            <div class="recap-item">
                <strong>Séance:</strong> ${achat.billets[0].seance.film.titre}<br>
                <fmt:formatDate value="${achat.billets[0].seance.daty}" pattern="dd/MM/yyyy"/> à 
                <fmt:formatDate value="${achat.billets[0].seance.heure}" pattern="HH:mm"/><br>
                Salle: ${achat.billets[0].seance.salle.nom}
            </div>
            
            <div class="recap-item" style="font-size: 1.2em; font-weight: bold;">
                <strong>Total:</strong> ${achat.total} Ar
            </div>
        </div>
        
        <div class="text-center">
            <a href="<c:url value='/seances'/>" class="btn btn-primary">Retour aux séances</a>
            <button onclick="window.print()" class="btn btn-info">Imprimer</button>
        </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
