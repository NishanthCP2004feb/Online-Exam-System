<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Exam Portal</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">&#127968; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/exams">&#128196; Exams</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/results">&#128202; Results</a></li>
        </ul>
        <div class="navbar-user">
            <div class="user-avatar" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">A</div>
            <span class="user-name"><%= HtmlUtils.escape(((User)session.getAttribute("user")).getFullName()) %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="page-header">
            <h1>Admin Dashboard &#128736;</h1>
            <p>Overview of the entire exam portal</p>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple">&#128196;</div>
                <div class="stat-info">
                    <h3>${totalExams}</h3>
                    <p>Total Exams</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">&#128101;</div>
                <div class="stat-info">
                    <h3>${totalStudents}</h3>
                    <p>Registered Students</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">&#128203;</div>
                <div class="stat-info">
                    <h3>${totalAttempts}</h3>
                    <p>Total Attempts</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">&#128202;</div>
                <div class="stat-info">
                    <h3>${avgScore}%</h3>
                    <p>Average Score</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card">
            <div class="card-header">
                <h2>&#9889; Quick Actions</h2>
            </div>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap; padding: 0.5rem 0;">
                <a href="${pageContext.request.contextPath}/admin/exams?action=add" class="btn btn-primary">&#10133; Create New Exam</a>
                <a href="${pageContext.request.contextPath}/admin/exams" class="btn btn-outline">&#128196; Manage Exams</a>
                <a href="${pageContext.request.contextPath}/admin/results" class="btn btn-outline">&#128202; View All Results</a>
            </div>
        </div>
    </div>
</body>
</html>
