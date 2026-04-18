package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.dao.ResultDAO;
import com.examportal.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();
    private UserDAO userDAO = new UserDAO();
    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int totalExams = examDAO.getTotalExams();
        int totalStudents = userDAO.getTotalStudents();
        int totalAttempts = resultDAO.getTotalAttempts();
        double avgScore = resultDAO.getAverageScore();
        
        request.setAttribute("totalExams", totalExams);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalAttempts", totalAttempts);
        request.setAttribute("avgScore", avgScore);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
