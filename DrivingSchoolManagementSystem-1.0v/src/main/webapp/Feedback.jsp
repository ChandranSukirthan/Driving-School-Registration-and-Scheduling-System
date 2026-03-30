<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.model.Student" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    FileUtil fileUtil = new FileUtil(application);
    List<Student> students = fileUtil.readStudents();
    Student student = null;
    for (Student s : students) {
        if (s.getUsername().equals(username)) {
            student = s;
            break;
        }
    }
    if (student == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback - DriveWise Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ffc107;
            --secondary-color: #1e1f22;
            --text-color: #f1f1f1;
        }
        body {
            background-color: var(--secondary-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            margin: 0;
        }
        .navbar {
            background-color: var(--secondary-color);
            padding: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .navbar a {
            color: var(--text-color);
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
        }
        .navbar a:hover {
            color: var(--primary-color);
        }
        .feedback-container {
            min-height: calc(100vh - 60px);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 2rem;
        }
        .feedback-card {
            background: rgba(30, 30, 30, 0.95);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            max-width: 600px;
            width: 100%;
            margin-bottom: 2rem;
        }
        .feedback-card h2 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .feedback-form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            color: var(--text-color);
            font-size: 1rem;
        }
        .form-group textarea {
            resize: vertical;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.2);
        }
        .star-rating {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            font-size: 1.5rem;
            color: #ccc;
            cursor: pointer;
        }
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: var(--primary-color);
        }
        .btn-primary {
            background-color: var(--primary-color);
            padding: 0.75rem;
            border-radius: 25px;
            font-weight: 600;
            border: none;
            color: #000;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }
        .alert {
            width: 100%;
            max-width: 600px;
            margin-bottom: 1rem;
            border-radius: 10px;
            padding: 1rem;
        }
        .alert-success {
            background-color: rgba(25, 135, 84, 0.9);
            color: white;
        }
        .alert-danger {
            background-color: rgba(220, 53, 69, 0.9);
            color: white;
        }
        .feedback-type-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .feedback-type-option {
            position: relative;
            cursor: pointer;
        }

        .feedback-type-option input[type="radio"] {
            display: none;
        }

        .feedback-type-label {
            display: block;
            padding: 1rem;
            text-align: center;
            border-radius: 10px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            background: rgba(255, 255, 255, 0.05);
        }

        .feedback-type-label i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .feedback-type-option input[type="radio"]:checked + .feedback-type-label {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        /* Type-specific styles */
        .type-general .feedback-type-label {
            color: #3498db;
        }
        .type-general input[type="radio"]:checked + .feedback-type-label {
            background: rgba(52, 152, 219, 0.2);
            border-color: #3498db;
        }

        .type-instructor .feedback-type-label {
            color: #e74c3c;
        }
        .type-instructor input[type="radio"]:checked + .feedback-type-label {
            background: rgba(231, 76, 60, 0.2);
            border-color: #e74c3c;
        }

        .type-lesson .feedback-type-label {
            color: #2ecc71;
        }
        .type-lesson input[type="radio"]:checked + .feedback-type-label {
            background: rgba(46, 204, 113, 0.2);
            border-color: #2ecc71;
        }

        .type-website .feedback-type-label {
            color: #f1c40f;
        }
        .type-website input[type="radio"]:checked + .feedback-type-label {
            background: rgba(241, 196, 15, 0.2);
            border-color: #f1c40f;
        }

        .type-other .feedback-type-label {
            color: #9b59b6;
        }
        .type-other input[type="radio"]:checked + .feedback-type-label {
            background: rgba(155, 89, 182, 0.2);
            border-color: #9b59b6;
        }

        .feedback-type-label:hover {
            transform: translateY(-2px);
            background: rgba(255, 255, 255, 0.1);
        }

        .star-rating-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 1rem;
        }
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            font-size: 2em;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
            color: #ccc;
            transition: color 0.2s ease-in-out;
            padding: 0 5px;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #ffc107;
        }
        .star-rating:hover label:hover,
        .star-rating:hover label:hover ~ label {
            color: #ffd700;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">DriveWise Academy</a>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="aboutyou.jsp">👤 About You</a></li>
                <li class="nav-item"><a class="nav-link" href="userFeedback.jsp">📋 View My Feedback</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp">🚪 Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Feedback Content -->
<div class="feedback-container">
    <% if(request.getParameter("success") != null) { %>
    <div class="alert alert-success">
        Feedback submitted successfully! Thank you for your feedback.
    </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getParameter("error") %>
    </div>
    <% } %>

    <div class="feedback-card">
        <h2>Welcome, <%= student.getUsername() %>!</h2>
        <p>Provide your feedback below.</p>
    </div>

    <div class="feedback-card">
        <h2>Submit Feedback</h2>
        <form class="feedback-form" id="feedbackForm" action="FeedbackServlet" method="post">
            <div class="form-group">
                <input type="text" name="name" value="<%= student.getUsername() %>" placeholder="Your Name" readonly required>
            </div>
            <div class="form-group">
                <input type="email" name="email" placeholder="Your Email" required>
            </div>
            <div class="form-group">
                <label class="d-block text-center mb-3">Select Feedback Type</label>
                <div class="feedback-type-grid">
                    <div class="feedback-type-option type-general">
                        <input type="radio" id="type-general" name="type" value="General" required>
                        <label for="type-general" class="feedback-type-label">
                            <i class="fas fa-comment-dots"></i>
                            General
                        </label>
                    </div>
                    <div class="feedback-type-option type-instructor">
                        <input type="radio" id="type-instructor" name="type" value="Instructor">
                        <label for="type-instructor" class="feedback-type-label">
                            <i class="fas fa-chalkboard-teacher"></i>
                            Instructor
                        </label>
                    </div>
                    <div class="feedback-type-option type-lesson">
                        <input type="radio" id="type-lesson" name="type" value="Lesson">
                        <label for="type-lesson" class="feedback-type-label">
                            <i class="fas fa-car"></i>
                            Lesson
                        </label>
                    </div>
                    <div class="feedback-type-option type-website">
                        <input type="radio" id="type-website" name="type" value="Website">
                        <label for="type-website" class="feedback-type-label">
                            <i class="fas fa-globe"></i>
                            Website
                        </label>
                    </div>
                    <div class="feedback-type-option type-other">
                        <input type="radio" id="type-other" name="type" value="Other">
                        <label for="type-other" class="feedback-type-label">
                            <i class="fas fa-ellipsis-h"></i>
                            Other
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="d-block text-center mb-3">Rating</label>
                <div class="star-rating-container">
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5" required>
                        <label for="star5" title="5 stars">★</label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" title="4 stars">★</label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" title="3 stars">★</label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" title="2 stars">★</label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" title="1 star">★</label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <textarea name="message" rows="4" placeholder="Your Feedback Message..." required></textarea>
            </div>
            <input type="hidden" name="username" value="<%= username %>">
            <button type="submit" class="btn btn-primary">Submit Feedback</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
