package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.model.Exam;
import com.examportal.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/exams")
public class ExamListServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        List<Exam> exams = examDAO.getAllActiveExams();
        
        // Check which exams user has already attempted
        for (Exam exam : exams) {
            boolean attempted = examDAO.hasUserAttemptedExam(user.getId(), exam.getId());
            if (attempted) {
                exam.setAttemptCount(1); // Flag as attempted
            }
        }
        
        request.setAttribute("exams", exams);
        request.getRequestDispatcher("/student/exam-list.jsp").forward(request, response);
    }
}
