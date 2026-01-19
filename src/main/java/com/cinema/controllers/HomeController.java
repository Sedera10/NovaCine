package com.cinema.controllers;

import com.cinema.models.User;
import com.cinema.services.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {
    
    @Autowired
    private AuthService authService;
    
    /**
     * Injecte automatiquement l'utilisateur dans toutes les vues de ce contrôleur
     */
    @ModelAttribute("user")
    public User getUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }
    
    /**
     * Page de login (GET)
     */
    @GetMapping("/")
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return "redirect:/seances";
        }
        
        return "index";
    }
    
    // Traitment connexion
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam(value = "rememberMe", required = false) String rememberMe,
            HttpSession session,
            Model model) {
        
        User user = authService.authenticate(username, password);
        
        return "redirect:/seances";
    }
    
    // Deconnexion
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    //DashBoard
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
        return "admin/dashboard";
    }
}
