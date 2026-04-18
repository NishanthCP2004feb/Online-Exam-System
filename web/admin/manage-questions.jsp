<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Questions - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
            <div class="logo-icon">&#128218;</div>
            ExamPortal <span class="badge badge-warning" style="margin-left: 8px;">Admin</span>
        </a>
        <ul class="navbar-nav">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#127968; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/exams" class="active">&#128196; Exams</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/results">&#128202; Results</a></li>
        </ul>
        <div class="navbar-user">
            <div class="user-avatar" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">A</div>
            <span class="user-name"><%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="main-content">
        <% Exam exam = (Exam) request.getAttribute("exam"); %>
        <% Boolean examLocked = (Boolean) request.getAttribute("examLocked"); %>
        
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1>&#128221; Questions: <%= HtmlUtils.escape(exam.getTitle()) %></h1>
                <p><%= HtmlUtils.escape(exam.getSubject()) %> &bull; <%= exam.getQuestionCount() %> questions &bull; <%= exam.getTotalMarks() %> total marks</p>
            </div>
            <div class="actions">
                <% if (Boolean.TRUE.equals(examLocked)) { %>
                    <span class="btn btn-outline" title="Locked after exam attempts">Questions Locked</span>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/admin/questions?action=add&examId=<%= exam.getId() %>" class="btn btn-primary">&#10133; Add Question</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/admin/exams" class="btn btn-outline">&#8592; Back to Exams</a>
            </div>
        </div>

        <%
            String flashSuccess = (String) session.getAttribute("flashSuccess");
            String flashError = (String) session.getAttribute("flashError");
            if (flashSuccess != null) {
                session.removeAttribute("flashSuccess");
        %>
            <div class="alert alert-success">&#9989; <%= HtmlUtils.escape(flashSuccess) %></div>
        <% } %>
        <%
            if (flashError != null) {
                session.removeAttribute("flashError");
        %>
            <div class="alert alert-danger">&#9888; <%= HtmlUtils.escape(flashError) %></div>
        <% } %>

        <% if (Boolean.TRUE.equals(examLocked)) { %>
            <div class="alert alert-warning">&#9888; This exam already has attempts, so its questions are locked to protect result history.</div>
        <% } %>

        <% 
            List<Question> questions = (List<Question>) request.getAttribute("questions");
            if (questions != null && !questions.isEmpty()) {
        %>
            <% int qNum = 1; %>
            <% for (Question q : questions) { %>
                <div class="question-card">
                    <div class="question-text">
                        <span class="question-number"><%= qNum %></span>
                        <span><%= HtmlUtils.escape(q.getQuestionText()) %></span>
                        <span class="question-marks">[<%= q.getMarks() %> marks]</span>
                    </div>
                    <div class="options-list" style="padding-left: 42px;">
                        <div class="option-item <%= "A".equals(q.getCorrectOption()) ? "selected" : "" %>" style="cursor: default;">
                            <span><strong>A.</strong> <%= HtmlUtils.escape(q.getOptionA()) %> 
                                <% if ("A".equals(q.getCorrectOption())) { %><span style="color: var(--success); margin-left: 8px;">&#9989; Correct</span><% } %>
                            </span>
                        </div>
                        <div class="option-item <%= "B".equals(q.getCorrectOption()) ? "selected" : "" %>" style="cursor: default;">
                            <span><strong>B.</strong> <%= HtmlUtils.escape(q.getOptionB()) %>
                                <% if ("B".equals(q.getCorrectOption())) { %><span style="color: var(--success); margin-left: 8px;">&#9989; Correct</span><% } %>
                            </span>
                        </div>
                        <div class="option-item <%= "C".equals(q.getCorrectOption()) ? "selected" : "" %>" style="cursor: default;">
                            <span><strong>C.</strong> <%= HtmlUtils.escape(q.getOptionC()) %>
                                <% if ("C".equals(q.getCorrectOption())) { %><span style="color: var(--success); margin-left: 8px;">&#9989; Correct</span><% } %>
                            </span>
                        </div>
                        <div class="option-item <%= "D".equals(q.getCorrectOption()) ? "selected" : "" %>" style="cursor: default;">
                            <span><strong>D.</strong> <%= HtmlUtils.escape(q.getOptionD()) %>
                                <% if ("D".equals(q.getCorrectOption())) { %><span style="color: var(--success); margin-left: 8px;">&#9989; Correct</span><% } %>
                            </span>
                        </div>
                    </div>
                    <div style="margin-top: 1rem; padding-left: 42px;">
                        <% if (!Boolean.TRUE.equals(examLocked)) { %>
                            <a href="${pageContext.request.contextPath}/admin/questions?action=edit&id=<%= q.getId() %>&examId=<%= exam.getId() %>"
                               class="btn btn-sm btn-warning">&#9998; Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/questions?action=delete&id=<%= q.getId() %>&examId=<%= exam.getId() %>" 
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Delete this question?');">&#128465; Delete</a>
                        <% } else { %>
                            <span class="badge badge-warning">Locked</span>
                        <% } %>
                    </div>
                </div>
            <% qNum++; %>
            <% } %>
        <% } else { %>
            <div class="empty-state">
                <div class="icon">&#128221;</div>
                <h3>No questions added yet</h3>
                <p>Add questions to this exam</p>
                <% if (!Boolean.TRUE.equals(examLocked)) { %>
                    <a href="${pageContext.request.contextPath}/admin/questions?action=add&examId=<%= exam.getId() %>" class="btn btn-primary" style="margin-top: 1rem;">&#10133; Add Question</a>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
