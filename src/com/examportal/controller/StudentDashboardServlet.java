package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.dao.ResultDAO;
import com.examportal.model.Exam;
import com.examportal.model.Result;
import com.examportal.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();
    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        
        // Get available exams
        List<Exam> availableExams = examDAO.getAllActiveExams();
        
        // Get recent results
        List<Result> recentResults = resultDAO.getResultsByUserId(user.getId());
        
        // Stats
        int totalExams = availableExams.size();
        int attemptedExams = recentResults.size();
        double avgScore = 0;
        int passedCount = 0;
        
        if (!recentResults.isEmpty()) {
            double totalPercentage = 0;
            for (Result r : recentResults) {
                totalPercentage += r.getPercentage();
                if (r.isPassed()) passedCount++;
            }
            avgScore = Math.round(totalPercentage / recentResults.size() * 100.0) / 100.0;
        }
        
        request.setAttribute("availableExams", availableExams);
        request.setAttribute("recentResults", recentResults);
        request.setAttribute("totalExams", totalExams);
        request.setAttribute("attemptedExams", attemptedExams);
        request.setAttribute("avgScore", avgScore);
        request.setAttribute("passedCount", passedCount);
        
        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}
