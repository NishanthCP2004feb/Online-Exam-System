<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam In Progress - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    
    <% 
        Exam exam = (Exam) request.getAttribute("exam");
        List<Question> questions = (List<Question>) request.getAttribute("questions");
        int totalQuestions = (Integer) request.getAttribute("totalQuestions");
    %>

    <!-- Sticky Exam Header with Timer -->
    <div class="main-content" style="max-width: 900px;">
        <div class="exam-header">
            <div class="exam-info">
                <h2><%= HtmlUtils.escape(exam.getTitle()) %></h2>
                <p><%= HtmlUtils.escape(exam.getSubject()) %> &bull; <%= totalQuestions %> Questions &bull; <%= exam.getTotalMarks() %> Marks</p>
            </div>
            <div class="timer-display" id="timerContainer">
                &#9200; <span id="timerDisplay">00:00</span>
            </div>
        </div>

        <!-- Question Navigation -->
        <div class="card" style="margin-bottom: 1.5rem; padding: 1rem 1.5rem;">
            <div style="display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;">
                <span style="font-size: 0.85rem; color: var(--text-secondary); font-weight: 500;">Questions:</span>
                <div class="question-nav">
                    <% for (int i = 1; i <= totalQuestions; i++) { %>
                        <a href="javascript:scrollToQuestion(<%= i %>)" class="q-dot" id="qdot_<%= i %>"><%= i %></a>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Exam Form -->
        <form id="examForm" action="${pageContext.request.contextPath}/student/submit-exam" method="post">
            <input type="hidden" name="examId" value="<%= exam.getId() %>">
            
            <% int qNum = 1; %>
            <% for (Question q : questions) { %>
                <div class="question-card" id="question_<%= qNum %>">
                    <div class="question-text">
                        <span class="question-number"><%= qNum %></span>
                        <span><%= HtmlUtils.escape(q.getQuestionText()) %></span>
                        <span class="question-marks">[<%= q.getMarks() %> marks]</span>
                    </div>
                    <div class="options-list">
                        <label class="option-item" onclick="selectOption(this)">
                            <input type="radio" name="q_<%= q.getId() %>" value="A">
                            <span><strong>A.</strong> <%= HtmlUtils.escape(q.getOptionA()) %></span>
                        </label>
                        <label class="option-item" onclick="selectOption(this)">
                            <input type="radio" name="q_<%= q.getId() %>" value="B">
                            <span><strong>B.</strong> <%= HtmlUtils.escape(q.getOptionB()) %></span>
                        </label>
                        <label class="option-item" onclick="selectOption(this)">
                            <input type="radio" name="q_<%= q.getId() %>" value="C">
                            <span><strong>C.</strong> <%= HtmlUtils.escape(q.getOptionC()) %></span>
                        </label>
                        <label class="option-item" onclick="selectOption(this)">
                            <input type="radio" name="q_<%= q.getId() %>" value="D">
                            <span><strong>D.</strong> <%= HtmlUtils.escape(q.getOptionD()) %></span>
                        </label>
                    </div>
                </div>
            <% qNum++; %>
            <% } %>

            <!-- Submit Actions -->
            <div class="exam-actions">
                <div>
                    <span style="color: var(--text-secondary); font-size: 0.9rem;">
                        Total: <%= totalQuestions %> questions &bull; <%= exam.getTotalMarks() %> marks &bull; Passing: <%= exam.getPassingMarks() %> marks
                    </span>
                </div>
                <button type="button" onclick="confirmSubmit()" class="btn btn-primary btn-lg">
                    Submit Exam &#10003;
                </button>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/timer.js"></script>
    <script>
        // Initialize timer with exam time limit
        initTimer(<%= exam.getTimeLimitMinutes() %>);
    </script>
</body>
</html>
