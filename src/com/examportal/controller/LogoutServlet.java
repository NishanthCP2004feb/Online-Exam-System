package com.examportal.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String redirectPath = "/login";
        if (session != null) {
            Object role = session.getAttribute("role");
            if ("admin".equals(role)) {
                redirectPath = "/admin/login";
            } else if ("student".equals(role)) {
                redirectPath = "/student/login";
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + redirectPath);
    }
}
