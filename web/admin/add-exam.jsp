<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("exam") != null ? "Edit Exam" : "Add Exam" %> - Online Exam Portal</title>
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

    <div class="main-content" style="max-width: 700px;">
        <div class="page-header">
            <h1><%= request.getAttribute("exam") != null ? "&#9998; Edit Exam" : "&#10133; Create New Exam" %></h1>
            <p><%= request.getAttribute("exam") != null ? "Update the exam details below" : "Fill in the details to create a new exam" %></p>
        </div>

        <% Exam exam = (Exam) request.getAttribute("exam"); %>

        <%
            String flashError = (String) session.getAttribute("flashError");
            if (flashError != null) {
                session.removeAttribute("flashError");
        %>
            <div class="alert alert-danger">&#9888; <%= HtmlUtils.escape(flashError) %></div>
        <% } %>

        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/exams" method="post">
                <% if (exam != null) { %>
                    <input type="hidden" name="id" value="<%= exam.getId() %>">
                <% } %>

                <div class="form-group">
                    <label for="title">Exam Title *</label>
                    <input type="text" id="title" name="title" class="form-control" 
                           placeholder="e.g., Java Programming Fundamentals"
                           value="<%= HtmlUtils.escape(exam != null ? exam.getTitle() : "") %>" required>
                </div>

                <div class="form-group">
                    <label for="subject">Subject *</label>
                    <input type="text" id="subject" name="subject" class="form-control" 
                           placeholder="e.g., Java, DBMS, Networking"
                           value="<%= HtmlUtils.escape(exam != null ? exam.getSubject() : "") %>" required>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control" 
                              placeholder="Brief description of the exam..."><%= HtmlUtils.escape(exam != null && exam.getDescription() != null ? exam.getDescription() : "") %></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="totalMarks">Total Marks *</label>
                        <input type="number" id="totalMarks" name="totalMarks" class="form-control" 
                               placeholder="e.g., 100" min="1"
                               value="<%= exam != null ? exam.getTotalMarks() : 50 %>" required>
                    </div>
                    <div class="form-group">
                        <label for="passingMarks">Passing Marks *</label>
                        <input type="number" id="passingMarks" name="passingMarks" class="form-control" 
                               placeholder="e.g., 40" min="1"
                               value="<%= exam != null ? exam.getPassingMarks() : 20 %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="timeLimit">Time Limit (minutes) *</label>
                        <input type="number" id="timeLimit" name="timeLimit" class="form-control" 
                               placeholder="e.g., 30" min="1"
                               value="<%= exam != null ? exam.getTimeLimitMinutes() : 30 %>" required>
                    </div>
                    <div class="form-group" style="display: flex; align-items: flex-end; padding-bottom: 0.25rem;">
                        <label class="form-check">
                            <input type="checkbox" name="isActive" 
                                   <%= exam == null || exam.isActive() ? "checked" : "" %>>
                            <span>Active (visible to students)</span>
                        </label>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <%= exam != null ? "Update Exam" : "Create Exam" %> &#10003;
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/exams" class="btn btn-outline btn-lg">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
