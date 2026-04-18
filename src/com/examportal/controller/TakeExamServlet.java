package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.dao.QuestionDAO;
import com.examportal.model.Exam;
import com.examportal.model.Question;
import com.examportal.model.User;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/take-exam")
public class TakeExamServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();
    private QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("id"));

        if (examId == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        Exam exam = examDAO.getExamById(examId);
        if (exam == null || !exam.isActive()) {
            request.getSession().setAttribute("examError", "Exam not found or not available.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        // Check if already attempted
        if (examDAO.hasUserAttemptedExam(user.getId(), examId)) {
            request.getSession().setAttribute("examError", "You have already attempted this exam!");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        List<Question> questions = questionDAO.getQuestionsByExamId(examId);
        
        if (questions.isEmpty()) {
            request.getSession().setAttribute("examError", "This exam has no questions yet!");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        // Store exam start time in session
        HttpSession session = request.getSession();
        session.setAttribute("examStartTime", System.currentTimeMillis());
        session.setAttribute("currentExamId", examId);
        
        request.setAttribute("exam", exam);
        request.setAttribute("questions", questions);
        request.setAttribute("totalQuestions", questions.size());
        
        request.getRequestDispatcher("/student/take-exam.jsp").forward(request, response);
    }
}
