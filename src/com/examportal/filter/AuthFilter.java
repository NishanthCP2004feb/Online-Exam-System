package com.examportal.filter;

import com.examportal.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/student/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        
        HttpSession session = request.getSession(false);
        String requestURI = request.getRequestURI();

        if (requestURI.endsWith("/admin/login") || requestURI.endsWith("/student/login")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            if (requestURI.contains("/admin/")) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/login");
            }
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Check admin access
        if (requestURI.contains("/admin/") && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }
        
        // Check student access (prevent admin from accessing student pages if needed)
        if (requestURI.contains("/student/") && user.isAdmin()) {
            // Allow admin to access student pages or redirect
            // For flexibility, let admin access student pages too
        }
        
        // Prevent browser caching of protected pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
