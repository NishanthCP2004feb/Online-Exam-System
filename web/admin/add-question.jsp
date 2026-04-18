<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.model.*" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Question - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>

    <% Exam exam = (Exam) request.getAttribute("exam"); %>
    <% Question question = (Question) request.getAttribute("question"); %>
    
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
            <h1><%= question != null ? "&#9998; Edit Question" : "&#10133; Add Question" %></h1>
            <p><%= question != null ? "Updating question for:" : "Adding question to:" %> <strong><%= HtmlUtils.escape(exam.getTitle()) %></strong> (<%= HtmlUtils.escape(exam.getSubject()) %>)</p>
        </div>

        <%
            String flashError = (String) session.getAttribute("flashError");
            if (flashError != null) {
                session.removeAttribute("flashError");
        %>
            <div class="alert alert-danger">&#9888; <%= HtmlUtils.escape(flashError) %></div>
        <% } %>

        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/questions" method="post">
                <input type="hidden" name="examId" value="<%= exam.getId() %>">
                <% if (question != null) { %>
                    <input type="hidden" name="id" value="<%= question.getId() %>">
                <% } %>

                <div class="form-group">
                    <label for="questionText">Question Text *</label>
                    <textarea id="questionText" name="questionText" class="form-control" 
                              placeholder="Enter the question..." required><%= HtmlUtils.escape(question != null ? question.getQuestionText() : "") %></textarea>
                </div>

                <div class="form-group">
                    <label for="optionA">Option A *</label>
                    <input type="text" id="optionA" name="optionA" class="form-control" 
                           placeholder="Enter option A" value="<%= HtmlUtils.escape(question != null ? question.getOptionA() : "") %>" required>
                </div>

                <div class="form-group">
                    <label for="optionB">Option B *</label>
                    <input type="text" id="optionB" name="optionB" class="form-control" 
                           placeholder="Enter option B" value="<%= HtmlUtils.escape(question != null ? question.getOptionB() : "") %>" required>
                </div>

                <div class="form-group">
                    <label for="optionC">Option C *</label>
                    <input type="text" id="optionC" name="optionC" class="form-control" 
                           placeholder="Enter option C" value="<%= HtmlUtils.escape(question != null ? question.getOptionC() : "") %>" required>
                </div>

                <div class="form-group">
                    <label for="optionD">Option D *</label>
                    <input type="text" id="optionD" name="optionD" class="form-control" 
                           placeholder="Enter option D" value="<%= HtmlUtils.escape(question != null ? question.getOptionD() : "") %>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="correctOption">Correct Option *</label>
                        <select id="correctOption" name="correctOption" class="form-control" required>
                            <option value="">-- Select Correct Option --</option>
                            <option value="A" <%= question != null && "A".equals(question.getCorrectOption()) ? "selected" : "" %>>Option A</option>
                            <option value="B" <%= question != null && "B".equals(question.getCorrectOption()) ? "selected" : "" %>>Option B</option>
                            <option value="C" <%= question != null && "C".equals(question.getCorrectOption()) ? "selected" : "" %>>Option C</option>
                            <option value="D" <%= question != null && "D".equals(question.getCorrectOption()) ? "selected" : "" %>>Option D</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="marks">Marks *</label>
                        <input type="number" id="marks" name="marks" class="form-control" 
                               placeholder="e.g., 5" min="1" value="<%= question != null ? question.getMarks() : 5 %>" required>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn btn-primary btn-lg"><%= question != null ? "Update Question" : "Add Question" %> &#10003;</button>
                    <a href="${pageContext.request.contextPath}/admin/questions?examId=<%= exam.getId() %>" class="btn btn-outline btn-lg">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
