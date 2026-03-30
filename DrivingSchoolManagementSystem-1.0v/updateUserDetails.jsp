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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Details - Driving School</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ffc107;
            --secondary-color: #1e1f22;
            --text-color: #f1f1f1;
            --input-bg: rgba(255, 255, 255, 0.08);
            --input-border: rgba(255, 255, 255, 0.2);
            --label-color: #bbb;
        }

        body {
            background-color: var(--secondary-color);
            min-height: 100vh;
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

        .update-container {
            min-height: calc(100vh - 60px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .update-card {
            background: rgba(30, 30, 30, 0.95);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            border: 1px solid var(--input-border);
            max-width: 400px;
            width: 100%;
        }

        .update-card h2 {
            color: var(--primary-color);
            font-size: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            font-weight: 700;
        }

        .update-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            position: relative;
        }

        .form-control {
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 10px;
            padding: 1rem;
            font-size: 1rem;
            color: var(--text-color);
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.12);
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.2);
        }

        .form-control:disabled {
            background: rgba(255, 255, 255, 0.05);
            color: #888;
        }

        .form-label {
            position: absolute;
            top: 1rem;
            left: 1rem;
            color: var(--label-color);
            transition: all 0.3s ease;
            pointer-events: none;
        }

        .form-control:focus + .form-label,
        .form-control.filled + .form-label {
            top: -0.5rem;
            left: 1rem;
            font-size: 0.8rem;
            color: var(--primary-color);
            background: var(--secondary-color);
            padding: 0 5px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            color: #000;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }

        .btn-secondary {
            background-color: transparent;
            border: 1px solid var(--primary-color);
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: var(--primary-color);
            color: #000;
            transform: translateY(-2px);
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 1rem;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">DriveWise Academy</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="dashboard.jsp">🏠 Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="logoutServlet">🚪 Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Update Form -->
<div class="update-container">
    <div class="update-card">
        <h2>Update Details</h2>
        <form class="update-form" action="UpdateUserDetailsServlet" method="post">
            <div class="form-group">
                <input type="text" class="form-control" id="username" name="username" value="<%= student.getUsername() %>" placeholder=" " required>
                <label for="username" class="form-label">Username</label>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="password" name="password" value="<%= student.getPassword() %>" placeholder=" " required>
                <label for="password" class="form-label">Password</label>
            </div>
            <div class="form-group">
                <input type="text" class="form-control" id="userType" value="<%= student.getUserType() %>" placeholder=" " disabled>
                <label for="userType" class="form-label">Package Type</label>
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="aboutYou.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</div>

<!-- JavaScript for floating label effect -->
<script>
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('input', function () {
            if (this.value) {
                this.classList.add('filled');
            } else {
                this.classList.remove('filled');
            }
        });

        if (input.value) {
            input.classList.add('filled');
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>