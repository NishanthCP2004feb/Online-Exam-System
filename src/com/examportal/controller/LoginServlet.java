package com.examportal.controller;

import com.examportal.dao.UserDAO;
import com.examportal.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/admin/login", "/student/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
            return;
        }
        
        if ("true".equals(request.getParameter("registered"))) {
            if ("student".equals(getExpectedRole(request))) {
                request.setAttribute("success", "Registration successful! Please login.");
            } else {
                request.setAttribute("success", "Registration successful! Continue with student login.");
            }
        }

        forwardToLoginPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String expectedRole = getExpectedRole(request);
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (expectedRole == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required!");
            forwardToLoginPage(request, response);
            return;
        }

        User user;
        try {
            user = userDAO.login(username.trim(), password);
        } catch (IllegalStateException ex) {
            request.setAttribute("error", "Database connection failed. Verify Render database environment variables.");
            forwardToLoginPage(request, response);
            return;
        }

        if (user != null) {
            if (!expectedRole.equalsIgnoreCase(user.getRole())) {
                request.setAttribute("error", "This account does not have " + expectedRole + " access. Please use the correct login page.");
                forwardToLoginPage(request, response);
                return;
            }

            HttpSession existingSession = request.getSession(false);
            if (existingSession != null) {
                existingSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid username or password!");
            forwardToLoginPage(request, response);
        }
    }

    private void forwardToLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String expectedRole = getExpectedRole(request);
        if (expectedRole != null) {
            request.setAttribute("loginRole", expectedRole);
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private String getExpectedRole(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        if ("/admin/login".equals(servletPath)) {
            return "admin";
        }
        if ("/student/login".equals(servletPath)) {
            return "student";
        }
        return null;
    }
}
