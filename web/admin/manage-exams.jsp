<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*, java.util.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Exams - Online Exam Portal</title>
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
        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1>&#128196; Manage Exams</h1>
                <p>Create, edit, and manage all examinations</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/exams?action=add" class="btn btn-primary">&#10133; Create Exam</a>
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

        <% 
            List<Exam> exams = (List<Exam>) request.getAttribute("exams");
            if (exams != null && !exams.isEmpty()) {
        %>
            <div class="card">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Subject</th>
                                <th>Questions</th>
                                <th>Total Marks</th>
                                <th>Pass Marks</th>
                                <th>Time (min)</th>
                                <th>Attempts</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Exam exam : exams) { %>
                            <tr>
                                <td><%= exam.getId() %></td>
                                <td><strong><%= HtmlUtils.escape(exam.getTitle()) %></strong></td>
                                <td><span class="badge badge-purple"><%= HtmlUtils.escape(exam.getSubject()) %></span></td>
                                <td><%= exam.getQuestionCount() %></td>
                                <td><%= exam.getTotalMarks() %></td>
                                <td><%= exam.getPassingMarks() %></td>
                                <td><%= exam.getTimeLimitMinutes() %></td>
                                <td><%= exam.getAttemptCount() %></td>
                                <td>
                                    <% if (exam.isActive()) { %>
                                        <span class="badge badge-success">Active</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">Inactive</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/questions?examId=<%= exam.getId() %>" class="btn btn-sm btn-outline" title="Manage Questions">&#128221;</a>
                                        <% if (exam.getAttemptCount() == 0) { %>
                                            <a href="${pageContext.request.contextPath}/admin/exams?action=edit&id=<%= exam.getId() %>" class="btn btn-sm btn-warning" title="Edit">&#9998;</a>
                                        <% } else { %>
                                            <span class="btn btn-sm btn-outline" title="Locked after attempts">Locked</span>
                                        <% } %>
                                        <a href="${pageContext.request.contextPath}/admin/exams?action=toggle&id=<%= exam.getId() %>" class="btn btn-sm btn-outline" title="Toggle Status">
                                            <%= exam.isActive() ? "&#128308;" : "&#128994;" %>
                                        </a>
                                        <% if (exam.getAttemptCount() == 0) { %>
                                            <a href="${pageContext.request.contextPath}/admin/exams?action=delete&id=<%= exam.getId() %>" class="btn btn-sm btn-danger" title="Delete"
                                               onclick="return confirm('Are you sure? This will delete the exam and all its questions.');">&#128465;</a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="icon">&#128196;</div>
                <h3>No exams created yet</h3>
                <p>Create your first exam to get started</p>
                <a href="${pageContext.request.contextPath}/admin/exams?action=add" class="btn btn-primary" style="margin-top: 1rem;">&#10133; Create Exam</a>
            </div>
        <% } %>
    </div>
</body>
</html>
