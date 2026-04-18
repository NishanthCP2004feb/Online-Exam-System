<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Online Exam Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    <div class="auth-container">
        <div class="auth-card" style="text-align: center;">
            <div class="logo-icon" style="background: rgba(239,68,68,0.15); color: #f87171; width: 60px; height: 60px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.8rem; margin-bottom: 1rem;">&#9888;</div>
            <h1 style="margin-bottom: 0.5rem;">Oops! Something went wrong</h1>
            <p class="subtitle">The page you're looking for doesn't exist or an error occurred.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">&#8592; Go Home</a>
        </div>
    </div>
</body>
</html>
