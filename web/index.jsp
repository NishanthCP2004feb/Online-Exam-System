<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Online Exam Portal - Take exams online with timed assessments and instant results">
    <title>Online Exam Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="bg-pattern"></div>
    
    <!-- Simple Navbar -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <div class="logo-icon">&#128218;</div>
            ExamPortal
        </a>
        <ul class="navbar-nav">
            <li><a href="${pageContext.request.contextPath}/student/login" class="btn btn-outline btn-sm">Student Login</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/login" class="btn btn-outline btn-sm">Admin Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a></li>
        </ul>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <h1>Your Gateway to Online Examinations</h1>
        <p>A modern platform for conducting timed online exams with instant scoring, detailed analytics, and comprehensive result tracking.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">Get Started &#8594;</a>
            <a href="${pageContext.request.contextPath}/student/login" class="btn btn-outline btn-lg">Student Login</a>
            <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-outline btn-lg">Admin Login</a>
        </div>
    </section>

    <!-- Features -->
    <section class="features-grid">
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(99, 102, 241, 0.15); color: #818cf8;">&#9200;</div>
            <h3>Timed Examinations</h3>
            <p>Real-time countdown timer with auto-submission ensures fair and timed assessments for all students.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(16, 185, 129, 0.15); color: #34d399;">&#9989;</div>
            <h3>Instant Results</h3>
            <p>Get your exam results immediately after submission with detailed score breakdown and pass/fail status.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(245, 158, 11, 0.15); color: #fbbf24;">&#128202;</div>
            <h3>Performance Analytics</h3>
            <p>Track your progress across multiple exams with comprehensive performance analytics and history.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(239, 68, 68, 0.15); color: #f87171;">&#128274;</div>
            <h3>Secure & Reliable</h3>
            <p>Session-based authentication, role-based access control, and secure data handling throughout.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(139, 92, 246, 0.15); color: #a78bfa;">&#128187;</div>
            <h3>Admin Panel</h3>
            <p>Powerful admin dashboard to create exams, manage questions, and monitor student performance.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon" style="background: rgba(59, 130, 246, 0.15); color: #60a5fa;">&#128241;</div>
            <h3>Responsive Design</h3>
            <p>Take exams from any device — desktop, tablet, or mobile — with a fully responsive interface.</p>
        </div>
    </section>

</body>
</html>
