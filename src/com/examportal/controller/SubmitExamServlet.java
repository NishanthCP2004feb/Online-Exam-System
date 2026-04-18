package com.examportal.controller;

import com.examportal.dao.ExamDAO;
import com.examportal.dao.QuestionDAO;
import com.examportal.dao.ResultDAO;
import com.examportal.model.Exam;
import com.examportal.model.Question;
import com.examportal.model.Result;
import com.examportal.model.User;
import com.examportal.util.RequestUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/submit-exam")
public class SubmitExamServlet extends HttpServlet {

    private ExamDAO examDAO = new ExamDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Integer examId = RequestUtils.parsePositiveInt(request.getParameter("examId"));
        Integer currentExamId = (Integer) session.getAttribute("currentExamId");

        if (user == null || examId == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        if (currentExamId == null || currentExamId.intValue() != examId.intValue()) {
            session.setAttribute("examError", "Your exam session expired. Please start the exam again.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        Exam exam = examDAO.getExamById(examId);
        
        if (exam == null) {
            session.setAttribute("examError", "Exam not found.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        if (!exam.isActive()) {
            session.setAttribute("examError", "This exam is no longer available.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        if (examDAO.hasUserAttemptedExam(user.getId(), examId)) {
            session.removeAttribute("examStartTime");
            session.removeAttribute("currentExamId");
            session.setAttribute("examError", "You have already attempted this exam.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        // Calculate time taken
        Long startTime = (Long) session.getAttribute("examStartTime");
        int timeTakenSeconds = 0;
        if (startTime != null) {
            timeTakenSeconds = (int) ((System.currentTimeMillis() - startTime) / 1000);
        }
        timeTakenSeconds = Math.max(0, Math.min(timeTakenSeconds, exam.getTimeLimitMinutes() * 60));
        
        // Get questions and calculate score
        List<Question> questions = questionDAO.getQuestionsByExamId(examId);
        if (questions.isEmpty()) {
            session.removeAttribute("examStartTime");
            session.removeAttribute("currentExamId");
            session.setAttribute("examError", "This exam does not have any questions.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        int score = 0;
        int correctAnswers = 0;
        int wrongAnswers = 0;
        int unanswered = 0;
        Map<Integer, String> userAnswers = new HashMap<>();
        
        for (Question question : questions) {
            String selectedOption = request.getParameter("q_" + question.getId());
            
            if (selectedOption != null && !selectedOption.isEmpty()) {
                userAnswers.put(question.getId(), selectedOption);
                
                if (selectedOption.equalsIgnoreCase(question.getCorrectOption())) {
                    score += question.getMarks();
                    correctAnswers++;
                } else {
                    wrongAnswers++;
                }
            } else {
                unanswered++;
                userAnswers.put(question.getId(), null);
            }
        }
        
        // Create result
        Result result = new Result();
        result.setUserId(user.getId());
        result.setExamId(examId);
        result.setScore(score);
        result.setTotalMarks(exam.getTotalMarks());
        result.setTotalQuestions(questions.size());
        result.setCorrectAnswers(correctAnswers);
        result.setWrongAnswers(wrongAnswers);
        result.setUnanswered(unanswered);
        result.setPassed(score >= exam.getPassingMarks());
        result.setTimeTakenSeconds(timeTakenSeconds);
        
        // Save result with transaction
        int resultId = resultDAO.saveResult(result, userAnswers);
        
        // Clean up session
        session.removeAttribute("examStartTime");
        session.removeAttribute("currentExamId");
        
        if (resultId > 0) {
            result.setId(resultId);
            result.setExamTitle(exam.getTitle());
            result.setExamSubject(exam.getSubject());
            session.setAttribute("lastResult", result);
            response.sendRedirect(request.getContextPath() + "/student/result?id=" + resultId);
        } else {
            session.setAttribute("examError", "Failed to save your result. Please contact the admin.");
            response.sendRedirect(request.getContextPath() + "/student/exams");
        }
    }
}
