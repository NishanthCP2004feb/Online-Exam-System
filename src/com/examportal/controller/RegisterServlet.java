package com.examportal.controller;

import com.examportal.dao.UserDAO;
import com.examportal.model.User;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = RequestUtils.trimToNull(request.getParameter("username"));
        String fullName = RequestUtils.trimToNull(request.getParameter("fullName"));
        String email = RequestUtils.trimToNull(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (username == null || fullName == null || email == null || password == null || password.isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isUsernameTaken(username)) {
            request.setAttribute("error", "Username already taken!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailTaken(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User(username, fullName, email, password, "student");
        boolean success = userDAO.register(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/login?registered=true");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
