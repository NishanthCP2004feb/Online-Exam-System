<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Results - Online Exam Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/exams">&#128196; Exams</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/results" class="active">&#128202; Results</a></li>
        </ul>
        <div class="navbar-user">
            <div class="user-avatar" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">A</div>
            <span class="user-name"><%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="page-header">
            <h1>&#128202; All Exam Results</h1>
            <p>View all student exam attempts and performance</p>
        </div>

        <% 
            List<Result> results = (List<Result>) request.getAttribute("results");
            if (results != null && !results.isEmpty()) {
        %>
            <div class="card">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student</th>
                                <th>Exam</th>
                                <th>Subject</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>Correct</th>
                                <th>Wrong</th>
                                <th>Unanswered</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int count = 1; %>
                            <% for (Result r : results) { %>
                            <tr>
                                <td><%= count++ %></td>
                                <td>
                                    <strong><%= HtmlUtils.escape(r.getStudentName()) %></strong>
                                    <br><span style="font-size: 0.8rem; color: var(--text-muted);">@<%= HtmlUtils.escape(r.getStudentUsername()) %></span>
                                </td>
                                <td><strong><%= HtmlUtils.escape(r.getExamTitle()) %></strong></td>
                                <td><span class="badge badge-purple"><%= HtmlUtils.escape(r.getExamSubject()) %></span></td>
                                <td><%= r.getScore() %>/<%= r.getTotalMarks() %></td>
                                <td><%= r.getPercentage() %>%</td>
                                <td style="color: var(--success);"><%= r.getCorrectAnswers() %></td>
                                <td style="color: var(--danger);"><%= r.getWrongAnswers() %></td>
                                <td style="color: var(--warning);"><%= r.getUnanswered() %></td>
                                <td><%= r.getTimeTakenFormatted() %></td>
                                <td>
                                    <% if (r.isPassed()) { %>
                                        <span class="badge badge-success">PASSED</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">FAILED</span>
                                    <% } %>
                                </td>
                                <td><%= r.getAttemptedAt() != null ? r.getAttemptedAt().toString().substring(0, 16) : "N/A" %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="icon">&#128202;</div>
                <h3>No results yet</h3>
                <p>No students have attempted any exams yet.</p>
            </div>
        <% } %>
    </div>
</body>
</html>
