<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCine - Connexion</title>

    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/NovaCine.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-color: #0B1D3A;
            --secondary-color: #FFC107;
            --white: #FFFFFF;
        }
        
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--white);
        }
        
        .login-container {
            height: 100vh;
            display: flex;
        }
        
        .login-left {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            background-color: var(--white);
        }
        
        .login-right {
            flex: 1;
            background-image: url('${pageContext.request.contextPath}/images/RightBG.jpg');
            background-size: cover;
            background-position: center;
            position: relative;
        }
        
        .login-right::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(11, 29, 58, 0.7), rgba(255, 193, 7, 0.3));
        }
        
        .logo-container {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .logo-container img {
            max-width: 150px;
            height: auto;
            margin-bottom: 20px;
        }
        
        .logo-container h2 {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .logo-container p {
            color: #6c757d;
            font-size: 0.95rem;
        }
        
        .login-form {
            width: 100%;
            max-width: 400px;
        }
        
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
        }
        
        .input-group-text {
            background-color: var(--white);
            border: 2px solid #e0e0e0;
            border-right: none;
            border-radius: 8px 0 0 8px;
            color: var(--primary-color);
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 8px 8px 0;
        }
        
        .input-group:focus-within .input-group-text {
            border-color: var(--secondary-color);
        }
        
        .btn-login {
            background-color: var(--primary-color);
            color: var(--white);
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-login:hover {
            background-color: #0a1629;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(11, 29, 58, 0.3);
        }
        
        .forgot-password {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }
        
        .forgot-password:hover {
            color: var(--secondary-color);
        }
        
        .form-check-input:checked {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        @media (max-width: 768px) {
            .login-right {
                display: none;
            }
            
            .login-left {
                flex: 1;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!--Login Form -->
        <div class="login-left">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/images/NovaCine.png" alt="NovaCine Logo">
                <h2>NovaCine</h2>
                <p><strong>La nouvelle ère du cinéma</strong></p>
                <p>Connectez-vous à votre espace</p>
            </div>
            
            <form class="login-form" action="${pageContext.request.contextPath}/login" method="POST">
                <!-- Message d'erreur -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <!-- Username Field -->
                <div class="mb-3">
                    <label for="username" class="form-label fw-semibold" style="color: var(--primary-color);">
                        <i class="bi bi-person-circle me-1"></i>Nom d'utilisateur
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-person"></i>
                        </span>
                        <input type="text" 
                               class="form-control" 
                               id="username" 
                               name="username" 
                               value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "admin" %>"
                               placeholder="Entrez votre nom d'utilisateur" 
                               required>
                    </div>
                </div>
                
                <!-- Password Field -->
                <div class="mb-3">
                    <label for="password" class="form-label fw-semibold" style="color: var(--primary-color);">
                        <i class="bi bi-lock-fill me-1"></i>Mot de passe
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-shield-lock"></i>
                        </span>
                        <input type="password" 
                               class="form-control" 
                               id="password" 
                               name="password" 
                               placeholder="Entrez votre mot de passe" 
                               value="admin"
                               required>
                    </div>
                </div>
                
                <!-- Remember Me & Forgot Password -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe" style="font-size: 0.9rem;">
                            Se souvenir de moi
                        </label>
                    </div>
                    <a href="#" class="forgot-password">Mot de passe oublié?</a>
                </div>
                
                <!-- Login Button -->
                <button type="submit" class="btn btn-login">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
                </button>
                
                <!-- Optional: Sign Up Link -->
                <div class="text-center mt-4">
                    <span class="text-muted" style="font-size: 0.9rem;">Pas encore de compte?</span>
                    <a href="#" class="forgot-password ms-1">S'inscrire</a>
                </div>
            </form>
        </div>
        
        <!-- Right Side - Background Image -->
        <div class="login-right"></div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>