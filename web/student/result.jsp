<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Result - Online Exam Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/student/exams">&#128196; Exams</a></li>
            <li><a href="${pageContext.request.contextPath}/student/result" class="active">&#128202; My Results</a></li>
        </ul>
        <div class="navbar-user">
            <div class="user-avatar"><%= HtmlUtils.escape(String.valueOf(((User)session.getAttribute("user")).getFullName().charAt(0))) %></div>
            <span class="user-name"><%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="main-content" style="max-width: 700px;">
        <% 
            Result result = (Result) request.getAttribute("result");
            if (result != null) {
        %>
            <div class="result-card">
                <% if (result.isPassed()) { %>
                    <div class="result-icon passed">&#127881;</div>
                    <h1>Congratulations!</h1>
                    <div class="result-status passed">You PASSED the exam</div>
                <% } else { %>
                    <div class="result-icon failed">&#128532;</div>
                    <h1>Better Luck Next Time</h1>
                    <div class="result-status failed">You did not pass the exam</div>
                <% } %>

                <div class="score-circle <%= result.isPassed() ? "passed" : "failed" %>">
                    <span class="score-value"><%= result.getScore() %></span>
                    <span class="score-label">out of <%= result.getTotalMarks() %></span>
                </div>

                <div class="result-stats">
                    <div class="result-stat">
                        <div class="value" style="color: var(--success);"><%= result.getCorrectAnswers() %></div>
                        <div class="label">Correct Answers</div>
                    </div>
                    <div class="result-stat">
                        <div class="value" style="color: var(--danger);"><%= result.getWrongAnswers() %></div>
                        <div class="label">Wrong Answers</div>
                    </div>
                    <div class="result-stat">
                        <div class="value" style="color: var(--warning);"><%= result.getUnanswered() %></div>
                        <div class="label">Unanswered</div>
                    </div>
                    <div class="result-stat">
                        <div class="value" style="color: var(--info);"><%= result.getTimeTakenFormatted() %></div>
                        <div class="label">Time Taken</div>
                    </div>
                </div>

                <div style="display: flex; flex-direction: column; gap: 0.75rem; align-items: center;">
                    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; width: 100%;">
                        <div style="padding: 0.5rem 1rem; background: var(--bg-input); border-radius: var(--radius-sm); font-size: 0.85rem;">
                            <strong>Percentage: </strong><%= result.getPercentage() %>%
                        </div>
                        <div style="padding: 0.5rem 1rem; background: var(--bg-input); border-radius: var(--radius-sm); font-size: 0.85rem;">
                            <strong>Passing Marks: </strong><%= result.getTotalMarks() > 0 ? (result.isPassed() ? "Achieved" : "Not Achieved") : "N/A" %>
                        </div>
                    </div>
                </div>

                <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-primary">Browse More Exams</a>
                    <a href="${pageContext.request.contextPath}/student/result" class="btn btn-outline">All My Results</a>
                </div>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="icon">&#128202;</div>
                <h3>Result not found</h3>
                <p>The result you're looking for doesn't exist.</p>
                <a href="${pageContext.request.contextPath}/student/result" class="btn btn-primary" style="margin-top: 1rem;">View All Results</a>
            </div>
        <% } %>
    </div>
</body>
</html>
