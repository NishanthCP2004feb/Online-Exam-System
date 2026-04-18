<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.examportal.util.HtmlUtils" %>
<%
    String loginRole = (String) request.getAttribute("loginRole");
    boolean roleSelected = loginRole != null;
    boolean adminLogin = "admin".equals(loginRole);
    String pageTitle = roleSelected ? (adminLogin ? "Admin Login" : "Student Login") : "Choose Login";
    String heading = roleSelected ? pageTitle : "Choose Login Type";
    String subtitle = roleSelected
            ? (adminLogin ? "Sign in with an administrator account" : "Sign in with your student account to continue")
            : "Use separate login pages for administrators and students.";
    String formAction = adminLogin
            ? request.getContextPath() + "/admin/login"
            : request.getContextPath() + "/student/login";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlUtils.escape(pageTitle) %> - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    
    <div class="auth-container">
        <div class="auth-card">
            <div class="logo">
                <div class="logo-icon">&#128218;</div>
                <h1><%= HtmlUtils.escape(heading) %></h1>
                <p class="subtitle"><%= HtmlUtils.escape(subtitle) %></p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    &#9888; <%= HtmlUtils.escape(String.valueOf(request.getAttribute("error"))) %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    &#9989; <%= HtmlUtils.escape(String.valueOf(request.getAttribute("success"))) %>
                </div>
            <% } %>

            <% if (roleSelected) { %>
                <div class="role-badge <%= adminLogin ? "admin" : "student" %>">
                    <%= adminLogin ? "Administrator Access" : "Student Access" %>
                </div>

                <form action="<%= HtmlUtils.escape(formAction) %>" method="post">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" class="form-control" 
                               placeholder="Enter your username" required autofocus>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Enter your password" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">
                        Sign In &#8594;
                    </button>
                </form>

                <div class="auth-footer">
                    <% if (adminLogin) { %>
                        Need a student account? <a href="${pageContext.request.contextPath}/student/login">Student login</a>
                    <% } else { %>
                        Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
                    <% } %>
                </div>

                <div class="auth-footer secondary-link">
                    <a href="${pageContext.request.contextPath}/login">Back to login options</a>
                    <% if (!adminLogin) { %>
                        <span class="separator">|</span>
                        <a href="${pageContext.request.contextPath}/admin/login">Admin login</a>
                    <% } %>
                </div>
            <% } else { %>
                <div class="auth-choice-list">
                    <a href="${pageContext.request.contextPath}/student/login" class="btn btn-primary btn-block btn-lg">Student Login &#8594;</a>
                    <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-outline btn-block btn-lg">Admin Login &#8594;</a>
                </div>

                <div class="auth-footer">
                    New student? <a href="${pageContext.request.contextPath}/register">Create an account</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
