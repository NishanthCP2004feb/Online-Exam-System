package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.dao.QuestionDAO;
import com.examportal.model.Exam;
import com.examportal.model.Question;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/questions")
public class AdminQuestionServlet extends HttpServlet {

    private QuestionDAO questionDAO = new QuestionDAO();
    private ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("examId"));
        Integer questionId = RequestUtils.parsePositiveInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        
        if ("add".equals(action)) {
            if (examId == null) {
                session.setAttribute("flashError", "Invalid exam selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                session.setAttribute("flashError", "Exam not found.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            if (examDAO.hasAttempts(examId)) {
                session.setAttribute("flashError", "Questions cannot be changed after students have attempted this exam.");
                response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
                return;
            }
            request.setAttribute("exam", exam);
            request.getRequestDispatcher("/admin/add-question.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            if (examId == null || questionId == null) {
                session.setAttribute("flashError", "Invalid question selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            Exam exam = examDAO.getExamById(examId);
            Question question = questionDAO.getQuestionById(questionId);
            if (exam == null || question == null || question.getExamId() != examId) {
                session.setAttribute("flashError", "Question not found.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            if (examDAO.hasAttempts(examId) || questionDAO.hasAnswers(questionId)) {
                session.setAttribute("flashError", "Questions cannot be changed after students have attempted this exam.");
                response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
                return;
            }
            request.setAttribute("exam", exam);
            request.setAttribute("question", question);
            request.getRequestDispatcher("/admin/add-question.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            if (examId == null || questionId == null) {
                session.setAttribute("flashError", "Invalid question selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            if (examDAO.hasAttempts(examId) || questionDAO.hasAnswers(questionId)) {
                session.setAttribute("flashError", "Question cannot be deleted after the exam has attempts.");
            } else if (questionDAO.deleteQuestion(questionId)) {
                session.setAttribute("flashSuccess", "Question deleted successfully.");
            } else {
                session.setAttribute("flashError", "Unable to delete the question.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
        } else {
            if (examId == null) {
                session.setAttribute("flashError", "Invalid exam selected.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                session.setAttribute("flashError", "Exam not found.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            List<Question> questions = questionDAO.getQuestionsByExamId(examId);
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.setAttribute("examLocked", examDAO.hasAttempts(examId));
            request.getRequestDispatcher("/admin/manage-questions.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("examId"));
        Integer questionId = RequestUtils.parsePositiveInt(request.getParameter("id"));
        String questionText = RequestUtils.trimToNull(request.getParameter("questionText"));
        String optionA = RequestUtils.trimToNull(request.getParameter("optionA"));
        String optionB = RequestUtils.trimToNull(request.getParameter("optionB"));
        String optionC = RequestUtils.trimToNull(request.getParameter("optionC"));
        String optionD = RequestUtils.trimToNull(request.getParameter("optionD"));
        String correctOption = RequestUtils.trimToNull(request.getParameter("correctOption"));
        Integer marks = RequestUtils.parsePositiveInt(request.getParameter("marks"));
        String invalidFormRedirect = examId != null
                ? request.getContextPath() + (questionId != null
                    ? "/admin/questions?action=edit&examId=" + examId + "&id=" + questionId
                    : "/admin/questions?action=add&examId=" + examId)
                : request.getContextPath() + "/admin/exams";

        if (examId == null || questionText == null || optionA == null || optionB == null || optionC == null || optionD == null
                || correctOption == null || marks == null) {
            session.setAttribute("flashError", "Please complete all question fields with valid values.");
            response.sendRedirect(invalidFormRedirect);
            return;
        }

        correctOption = correctOption.toUpperCase();

        if (!"A".equals(correctOption) && !"B".equals(correctOption) && !"C".equals(correctOption) && !"D".equals(correctOption)) {
            session.setAttribute("flashError", "Correct option must be A, B, C, or D.");
            response.sendRedirect(invalidFormRedirect);
            return;
        }

        Exam exam = examDAO.getExamById(examId);
        if (exam == null) {
            session.setAttribute("flashError", "Exam not found.");
            response.sendRedirect(request.getContextPath() + "/admin/exams");
            return;
        }

        if (examDAO.hasAttempts(examId)) {
            session.setAttribute("flashError", "Questions cannot be changed after students have attempted this exam.");
            response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
            return;
        }

        Question question = new Question(examId, questionText, optionA, optionB, optionC, optionD, correctOption, marks);

        if (questionId != null) {
            Question existingQuestion = questionDAO.getQuestionById(questionId);
            if (existingQuestion == null || existingQuestion.getExamId() != examId) {
                session.setAttribute("flashError", "Question not found.");
                response.sendRedirect(request.getContextPath() + "/admin/exams");
                return;
            }
            if (questionDAO.hasAnswers(questionId)) {
                session.setAttribute("flashError", "This question cannot be edited because students have already answered it.");
                response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
                return;
            }
            question.setId(questionId);
            if (questionDAO.updateQuestion(question)) {
                session.setAttribute("flashSuccess", "Question updated successfully.");
            } else {
                session.setAttribute("flashError", "Unable to update the question.");
            }
        } else if (questionDAO.addQuestion(question)) {
            session.setAttribute("flashSuccess", "Question added successfully.");
        } else {
            session.setAttribute("flashError", "Unable to add the question.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/questions?examId=" + examId);
    }
}
