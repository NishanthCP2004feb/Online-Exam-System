package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.model.Exam;
import com.examportal.model.User;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/exams")
public class AdminExamServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        
        if ("add".equals(action)) {
            request.getRequestDispatcher("/admin/add-exam.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            if (examId == null) {
                session.setAttribute("flashError", "Invalid exam selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            if (examDAO.hasAttempts(examId)) {
                session.setAttribute("flashError", "Exam details cannot be changed after students have attempted it.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                session.setAttribute("flashError", "Exam not found.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            request.setAttribute("exam", exam);
            request.getRequestDispatcher("/admin/add-exam.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            if (examId == null) {
                session.setAttribute("flashError", "Invalid exam selected.");
            } else if (examDAO.hasAttempts(examId)) {
                session.setAttribute("flashError", "Exam cannot be deleted after students have attempted it.");
            } else if (examDAO.deleteExam(examId)) {
                session.setAttribute("flashSuccess", "Exam deleted successfully.");
            } else {
                session.setAttribute("flashError", "Unable to delete the exam.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/exams");
        } else if ("toggle".equals(action)) {
            if (examId == null) {
                session.setAttribute("flashError", "Invalid exam selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            Exam exam = examDAO.getExamById(examId);
            if (exam != null) {
                exam.setActive(!exam.isActive());
                if (examDAO.updateExam(exam)) {
                    session.setAttribute("flashSuccess", exam.isActive() ? "Exam activated." : "Exam deactivated.");
                } else {
                    session.setAttribute("flashError", "Unable to update exam status.");
                }
            } else {
                session.setAttribute("flashError", "Exam not found.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/exams");
        } else {
            List<Exam> exams = examDAO.getAllExams();
            request.setAttribute("exams", exams);
            request.getRequestDispatcher("/admin/manage-exams.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        HttpSession session = request.getSession();

        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("id"));
        String title = RequestUtils.trimToNull(request.getParameter("title"));
        String subject = RequestUtils.trimToNull(request.getParameter("subject"));
        String description = RequestUtils.trimToNull(request.getParameter("description"));
        Integer totalMarks = RequestUtils.parsePositiveInt(request.getParameter("totalMarks"));
        Integer passingMarks = RequestUtils.parsePositiveInt(request.getParameter("passingMarks"));
        Integer timeLimit = RequestUtils.parsePositiveInt(request.getParameter("timeLimit"));
        boolean isActive = request.getParameter("isActive") != null;

        if (user == null || title == null || subject == null || totalMarks == null || passingMarks == null || timeLimit == null) {
            session.setAttribute("flashError", "Please fill in all required exam fields with valid values.");
            response.sendRedirect(request.getContextPath() + (examId != null ? "/admin/exams?action=edit&id=" + examId : "/admin/exams?action=add"));
            return;
        }

        if (passingMarks > totalMarks) {
            session.setAttribute("flashError", "Passing marks cannot be greater than total marks.");
            response.sendRedirect(request.getContextPath() + (examId != null ? "/admin/exams?action=edit&id=" + examId : "/admin/exams?action=add"));
            return;
        }

        if (examId != null) {
            if (examDAO.hasAttempts(examId)) {
                session.setAttribute("flashError", "Exam details cannot be changed after students have attempted it.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            // Update existing exam
            Exam exam = new Exam();
            exam.setId(examId);
            exam.setTitle(title);
            exam.setSubject(subject);
            exam.setDescription(description);
            exam.setTotalMarks(totalMarks);
            exam.setPassingMarks(passingMarks);
            exam.setTimeLimitMinutes(timeLimit);
            exam.setActive(isActive);
            if (examDAO.updateExam(exam)) {
                session.setAttribute("flashSuccess", "Exam updated successfully.");
            } else {
                session.setAttribute("flashError", "Unable to update the exam.");
            }
        } else {
            // Add new exam
            Exam exam = new Exam(title, subject, description, totalMarks, passingMarks, timeLimit);
            exam.setActive(isActive);
            exam.setCreatedBy(user.getId());
            if (examDAO.addExam(exam)) {
                session.setAttribute("flashSuccess", "Exam created successfully.");
            } else {
                session.setAttribute("flashError", "Unable to create the exam.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/exams");
    }
}
