<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    :root {
        --sidebar-width: 240px;
        --sidebar-collapsed-width: 65px;
        --primary-color: #0B1D3A;
        --secondary-color: #FFC107;
        --hover-bg: rgba(11, 29, 58, 0.05);
    }
    
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        width: var(--sidebar-width);
        background-color: white;
        color: var(--primary-color);
        transition: all 0.3s ease;
        z-index: 1000;
        overflow-x: hidden;
        overflow-y: auto;
        box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    }
    
    .sidebar.collapsed {
        width: var(--sidebar-collapsed-width);
    }
    
    .sidebar-header {
        padding: 16px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        min-height: 65px;
    }
    
    .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 10px;
        white-space: nowrap;
        transition: opacity 0.3s ease;
    }
    
    .sidebar-logo img {
        height: 120px;
        width: 180px;
    }
    
    .sidebar-logo-text {
        font-size: 1.2rem;
        font-weight: 700;
        color: var(--primary-color);
    }
    
    .sidebar.collapsed .sidebar-logo-text {
        display: none;
    }
    
    .sidebar-toggle {
        background: none;
        border: none;
        color: var(--primary-color);
        font-size: 1.3rem;
        cursor: pointer;
        padding: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: color 0.3s ease;
    }
    
    .sidebar-toggle:hover {
        color: var(--secondary-color);
    }
    
    .sidebar-menu {
        padding: 16px 0;
        list-style: none;
        margin: 0;
    }
    
    .sidebar-menu-item {
        margin-bottom: 5px;
    }
    
    .sidebar-menu-link {
        display: flex;
        align-items: center;
        padding: 11px 16px;
        color: var(--primary-color);
        text-decoration: none;
        transition: all 0.3s ease;
        white-space: nowrap;
        position: relative;
    }
    
    .sidebar-menu-link:hover {
        background-color: var(--hover-bg);
        color: var(--primary-color);
        padding-left: 20px;
    }
    
    .sidebar-menu-link.active {
        background-color: rgba(11, 29, 58, 0.08);
        color: var(--primary-color);
        font-weight: 600;
        border-left: 3px solid var(--primary-color);
    }
    
    .sidebar-menu-link.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        height: 100%;
        width: 0px;
        background-color: white;
    }
    
    .sidebar-menu-icon {
        font-size: 1.1rem;
        min-width: 26px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .sidebar-menu-text {
        margin-left: 12px;
        transition: opacity 0.3s ease;
    }
    
    .sidebar.collapsed .sidebar-menu-text {
        opacity: 0;
        display: none;
    }
    
    .sidebar-section-title {
        padding: 0px 0px 10px 20px;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--primary-color);
        font-weight: 750;
        transition: opacity 0.3s ease;
    }
    
    .sidebar.collapsed .sidebar-section-title {
        opacity: 0;
        display: none;
    }
    
    .sidebar-divider {
        height: 1px;
        background-color: rgba(255,255,255,0.1);
        margin: 15px 20px;
    }
    
    .sidebar-footer {
        position: relative;
        bottom: 0;
        width: 100%;
        padding: 12px 16px;
        border-top: 1px solid rgba(11, 29, 58, 0.1);
        background-color: rgba(0,0,0,0.02);
    }
    
    .sidebar-footer-title {
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--primary-color);
        font-weight: 600;
        margin-bottom: 8px;
        transition: opacity 0.3s ease;
        opacity: 0.7;
    }
    
    .sidebar.collapsed .sidebar-footer-title {
        display: none;
    }
    
    .sidebar-user {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .sidebar-user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background-color: var(--primary-color);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 0.95rem;
    }
    
    .sidebar-user-info {
        flex: 1;
        min-width: 0;
        transition: opacity 0.3s ease;
    }
    
    .sidebar.collapsed .sidebar-user-info {
        display: none;
    }
    
    .sidebar-user-name {
        font-weight: 600;
        font-size: 0.85rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    
    .sidebar-user-role {
        font-size: 0.7rem;
        color: var(--primary-color);
        opacity: 0.6;
        text-transform: uppercase;
    }
    
    .main-content {
        margin-left: var(--sidebar-width);
        transition: margin-left 0.3s ease;
        min-height: 100vh;
    }
    
    .main-content.expanded {
        margin-left: var(--sidebar-collapsed-width);
    }
    
    /* Toggle button when sidebar is collapsed */
    .sidebar-toggle-btn {
        position: fixed;
        top: 16px;
        left: 16px;
        z-index: 1001;
        background-color: var(--primary-color);
        color: white;
        border: none;
        width: 44px;
        height: 44px;
        border-radius: 50%;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 1.3rem;
        cursor: pointer;
        box-shadow: 0 1px 4px rgba(0,0,0,0.15);
        transition: all 0.3s ease;
    }
    
    .sidebar-toggle-btn:hover {
        background-color: var(--primary-color);
        color: white;
        transform: scale(1.05);
        box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    }
    
    .sidebar-toggle-btn.show {
        display: flex;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
        }
        
        .sidebar.mobile-open {
            transform: translateX(0);
        }
        
        .main-content {
            margin-left: 0;
        }
        
        .mobile-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 999;
            display: none;
        }
        
        .mobile-overlay.active {
            display: block;
        }
    }
    
    /* Badge for notifications */
    .menu-badge {
        background-color: #dc3545;
        color: white;
        border-radius: 10px;
        padding: 2px 8px;
        font-size: 0.7rem;
        font-weight: 600;
        margin-left: auto;
    }
    
    /* Scrollbar styling */
    .sidebar::-webkit-scrollbar {
        width: 6px;
    }
    
    .sidebar::-webkit-scrollbar-track {
        background: rgba(255,255,255,0.05);
    }
    
    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(255,255,255,0.2);
        border-radius: 3px;
    }
    
    .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(255,255,255,0.3);
    }
</style>

<!-- Mobile Overlay -->
<div class="mobile-overlay" id="mobileOverlay"></div>

<!-- Toggle Button (visible when sidebar collapsed) -->
<button class="sidebar-toggle-btn" id="sidebarToggleBtn">
    <i class="bi bi-list"></i>
</button>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <!-- Header -->
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/images/NovaCine.png" alt="NovaCine Logo">
        </div>
        <button class="sidebar-toggle" id="sidebarToggle">
            <i class="bi bi-list"></i>
        </button>
    </div>
    
    <!-- Navigation Menu -->
    <ul class="sidebar-menu">
        <!-- Dashboard -->
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-menu-link active">
                <span class="sidebar-menu-icon"><i class="bi bi-speedometer2"></i></span>
                <span class="sidebar-menu-text">Dashboard</span>
            </a>
        </li>
        
        <div class="sidebar-divider"></div>
        
        <!-- Section: Vente -->
        <div class="sidebar-section-title">Vente</div>
        
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/achats/liste" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-ticket-perforated"></i></span>
                <span class="sidebar-menu-text">Vente Billets</span>
            </a>
        </li>
        
        <!-- Section: Gestion (Admin & Manager) -->
        <div class="sidebar-divider"></div>
        <div class="sidebar-section-title">Gestion</div>
        
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/films" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-film"></i></span>
                <span class="sidebar-menu-text">Films</span>
            </a>
        </li>
        
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/seances" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-camera-reels"></i></span>
                <span class="sidebar-menu-text">Séances</span>
            </a>
        </li>
        
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/salles" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-door-open"></i></span>
                <span class="sidebar-menu-text">Salles</span>
            </a>
        </li>

        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/salles/types" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-door-open"></i></span>
                <span class="sidebar-menu-text">Types places</span>
            </a>
        </li>
        
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/concessions" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-cup-straw"></i></span>
                <span class="sidebar-menu-text">Concessions</span>
            </a>
        </li>
        
        <!-- Section: Rapports (Admin & Manager) -->
        <c:if test="${user.role.nomRole eq 'Admin' or user.role.nomRole eq 'Manager'}">
            <div class="sidebar-divider"></div>
            <div class="sidebar-section-title">Rapports</div>
            
            <li class="sidebar-menu-item">
                <a href="${pageContext.request.contextPath}/statistiques" class="sidebar-menu-link">
                    <span class="sidebar-menu-icon"><i class="bi bi-graph-up"></i></span>
                    <span class="sidebar-menu-text">Statistiques</span>
                </a>
            </li>
            
            <li class="sidebar-menu-item">
                <a href="${pageContext.request.contextPath}/rapports" class="sidebar-menu-link">
                    <span class="sidebar-menu-icon"><i class="bi bi-file-earmark-bar-graph"></i></span>
                    <span class="sidebar-menu-text">Rapports</span>
                </a>
            </li>
        </c:if>
        
        <!-- Section: Administration (Admin only) -->
        <div class="sidebar-divider"></div>
        <div class="sidebar-section-title">Administration</div>
            
        <div class="sidebar-footer">
            <div class="sidebar-footer-title"><i class="bi bi-person-circle me-1"></i>UTILISATEUR</div>
            <div class="sidebar-user">
                <div class="sidebar-user-avatar">
                    ${user.prenom.substring(0,1)}${user.nom.substring(0,1)}
                </div>
                <div class="sidebar-user-info">
                    <div class="sidebar-user-name">${user.prenom} ${user.nom}</div>
                    <div class="sidebar-user-role">${user.role.nomRole}</div>
                </div>
            </div>
        </div>
        
        <div class="sidebar-divider"></div>
        
        <!-- Logout -->
        <li class="sidebar-menu-item">
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-menu-link">
                <span class="sidebar-menu-icon"><i class="bi bi-box-arrow-right"></i></span>
                <span class="sidebar-menu-text">Déconnexion</span>
            </a>
        </li>
    </ul>
    
</aside>

<!-- Sidebar Toggle Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
        const mainContent = document.querySelector('.main-content');
        const mobileOverlay = document.getElementById('mobileOverlay');
        
        // Function to toggle sidebar
        function toggleSidebar() {
            if (window.innerWidth <= 768) {
                // Mobile: show/hide sidebar with overlay
                sidebar.classList.toggle('mobile-open');
                mobileOverlay.classList.toggle('active');
            } else {
                // Desktop: collapse/expand sidebar
                sidebar.classList.toggle('collapsed');
                if (mainContent) {
                    mainContent.classList.toggle('expanded');
                }
                // Toggle external button visibility
                sidebarToggleBtn.classList.toggle('show');
            }
        }
        
        // Toggle sidebar from header button
        sidebarToggle.addEventListener('click', toggleSidebar);
        
        // Toggle sidebar from external button
        sidebarToggleBtn.addEventListener('click', toggleSidebar);
        
        // Close sidebar on mobile when clicking overlay
        mobileOverlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-open');
            mobileOverlay.classList.remove('active');
        });
        
        // Close sidebar on mobile when clicking a link
        const menuLinks = document.querySelectorAll('.sidebar-menu-link');
        menuLinks.forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth <= 768) {
                    sidebar.classList.remove('mobile-open');
                    mobileOverlay.classList.remove('active');
                }
            });
        });
        
        // Handle window resize
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                sidebar.classList.remove('mobile-open');
                mobileOverlay.classList.remove('active');
            }
        });
        
        // Highlight active menu item based on current URL
        const currentPath = window.location.pathname;
        menuLinks.forEach(link => {
            if (link.getAttribute('href') === currentPath || 
                (currentPath.includes(link.getAttribute('href')) && link.getAttribute('href') !== '${pageContext.request.contextPath}/dashboard')) {
                // Remove active class from all links
                menuLinks.forEach(l => l.classList.remove('active'));
                // Add active class to current link
                link.classList.add('active');
            }
        });
    });
</script>
