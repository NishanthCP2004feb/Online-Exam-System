<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Exams - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="navbar-brand">
            <div class="logo-icon">&#128218;</div>
            ExamPortal
        </a>
        <ul class="navbar-nav">
            <li><a href="${pageContext.request.contextPath}/student/dashboard">&#127968; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/student/exams" class="active">&#128196; Exams</a></li>
            <li><a href="${pageContext.request.contextPath}/student/result">&#128202; My Results</a></li>
        </ul>
        <div class="navbar-user">
            <div class="user-avatar"><%= HtmlUtils.escape(String.valueOf(((User)session.getAttribute("user")).getFullName().charAt(0))) %></div>
            <span class="user-name"><%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="page-header">
            <h1>&#128196; Available Exams</h1>
            <p>Choose an exam to start your assessment</p>
        </div>

        <%
            String flashSuccess = (String) session.getAttribute("flashSuccess");
            if (flashSuccess != null) {
                session.removeAttribute("flashSuccess");
        %>
            <div class="alert alert-success">&#9989; <%= HtmlUtils.escape(flashSuccess) %></div>
        <% } %>

        <% 
            String examError = (String) session.getAttribute("examError");
            if (examError != null) {
                session.removeAttribute("examError");
        %>
            <div class="alert alert-warning">&#9888; <%= HtmlUtils.escape(examError) %></div>
        <% } %>

        <% 
            List<Exam> exams = (List<Exam>) request.getAttribute("exams");
            if (exams != null && !exams.isEmpty()) {
        %>
            <div class="exam-grid">
                <% for (Exam exam : exams) { %>
                    <div class="exam-card">
                        <div class="exam-subject"><%= HtmlUtils.escape(exam.getSubject()) %></div>
                        <h3><%= HtmlUtils.escape(exam.getTitle()) %></h3>
                        <p class="exam-desc"><%= HtmlUtils.escape(exam.getDescription() != null ? exam.getDescription() : "No description available.") %></p>
                        
                        <div class="exam-meta">
                            <div class="exam-meta-item">
                                <span class="icon">&#128221;</span>
                                <%= exam.getQuestionCount() %> Questions
                            </div>
                            <div class="exam-meta-item">
                                <span class="icon">&#9200;</span>
                                <%= exam.getTimeLimitMinutes() %> Minutes
                            </div>
                            <div class="exam-meta-item">
                                <span class="icon">&#127942;</span>
                                <%= exam.getTotalMarks() %> Marks
                            </div>
                            <div class="exam-meta-item">
                                <span class="icon">&#9989;</span>
                                Pass: <%= exam.getPassingMarks() %> Marks
                            </div>
                        </div>
                        
                        <% if (exam.getAttemptCount() > 0) { %>
                            <span class="badge badge-success" style="padding: 0.5rem 1rem; width: 100%; justify-content: center;">&#9989; Already Attempted</span>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/student/take-exam?id=<%= exam.getId() %>" 
                               class="btn btn-primary btn-block"
                               onclick="return confirm('Are you ready to start this exam? You will have <%= exam.getTimeLimitMinutes() %> minutes to complete it.');">
                                Start Exam &#8594;
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="icon">&#128196;</div>
                <h3>No exams available</h3>
                <p>Check back later for new exams</p>
            </div>
        <% } %>
    </div>
</body>
</html>
