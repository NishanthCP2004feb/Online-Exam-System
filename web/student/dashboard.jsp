<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Online Exam Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/student/dashboard" class="active">&#127968; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/student/exams">&#128196; Exams</a></li>
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
            <h1>Welcome back, <%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %> &#128075;</h1>
            <p>Here's an overview of your exam activity</p>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple">&#128196;</div>
                <div class="stat-info">
                    <h3>${totalExams}</h3>
                    <p>Available Exams</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">&#9989;</div>
                <div class="stat-info">
                    <h3>${attemptedExams}</h3>
                    <p>Exams Attempted</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">&#128202;</div>
                <div class="stat-info">
                    <h3>${avgScore}%</h3>
                    <p>Average Score</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">&#127942;</div>
                <div class="stat-info">
                    <h3>${passedCount}</h3>
                    <p>Exams Passed</p>
                </div>
            </div>
        </div>

        <!-- Recent Results -->
        <div class="card">
            <div class="card-header">
                <h2>&#128203; Recent Exam Results</h2>
                <a href="${pageContext.request.contextPath}/student/result" class="btn btn-sm btn-outline">View All</a>
            </div>
            
            <% 
                List<Result> results = (List<Result>) request.getAttribute("recentResults");
                if (results != null && !results.isEmpty()) {
            %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Exam</th>
                                <th>Subject</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < Math.min(5, results.size()); i++) { 
                                Result r = results.get(i);
                            %>
                            <tr>
                                <td><strong><%= HtmlUtils.escape(r.getExamTitle()) %></strong></td>
                                <td><span class="badge badge-purple"><%= HtmlUtils.escape(r.getExamSubject()) %></span></td>
                                <td><%= r.getScore() %>/<%= r.getTotalMarks() %></td>
                                <td><%= r.getPercentage() %>%</td>
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
            <% } else { %>
                <div class="empty-state">
                    <div class="icon">&#128221;</div>
                    <h3>No exams attempted yet</h3>
                    <p>Start by browsing available exams</p>
                    <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-primary" style="margin-top: 1rem;">Browse Exams &#8594;</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
