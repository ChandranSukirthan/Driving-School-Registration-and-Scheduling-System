<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login - Driving School</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #ffc107; /* Porsche Yellow */
            --secondary-color: #1e1f22; /* Charcoal Dark */
            --text-color: #f1f1f1; /* Soft white */
            --input-bg: rgba(255, 255, 255, 0.08);
            --input-border: rgba(255, 255, 255, 0.2);
            --label-color: #bbb;
        }

        body {
            background-color: var(--secondary-color);
            background-size: cover;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            margin: 0;
        }

        .navbar {
            background-color: var(--secondary-color);
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .navbar a {
            color: var(--text-color);
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
        }

        .navbar a:hover {
            text-decoration: underline;
            color: var(--primary-color);
        }

        .nav-link.active {
            color: var(--primary-color) !important;
        }

        .auth-container {
            min-height: calc(100vh - 60px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .auth-card {
            background: rgba(30, 30, 30, 0.95);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            border: 1px solid var(--input-border);
            max-width: 400px;
            width: 100%;
        }

        .auth-card h2 {
            color: var(--primary-color);
            font-size: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            font-weight: 700;
        }

        .auth-form {
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
            transition: all 0.3s ease;
            color: #000;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 1rem;
        }

        .auth-footer {
            text-align: center;
            margin-top: 2rem;
        }

        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .auth-card {
                padding: 2rem;
            }

            .auth-card h2 {
                font-size: 1.75rem;
            }

            .form-control {
                padding: 0.75rem;
            }

            .btn-primary {
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
            }
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
                <li class="nav-item"><a class="nav-link" href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li class="nav-item"><a class="nav-link" href="aboutus.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
                <li class="nav-item"><a class="nav-link" href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a></li>
                <li class="nav-item"><a class="nav-link active" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Register/Login</a></li>
                <li class="nav-item"><a class="nav-link" href="admin.jsp"><i class="fas fa-user-shield"></i> Admin</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Login Form -->
<div class="auth-container">
    <div class="auth-card">
        <h2>Student Login</h2>
        <form class="auth-form" action="LoginServlet" method="post">
            <div class="form-group">
                <input type="text" class="form-control" id="username" name="username" placeholder=" " required>
                <label for="username" class="form-label">Username</label>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="password" name="password" placeholder=" " required>
                <label for="password" class="form-label">Password</label>
            </div>
            <button type="submit" class="btn btn-primary">Login</button>

            <% if (request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <div class="auth-footer">
                New user? <a href="register.jsp">Register here</a>
            </div>
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

        // Check on page load for autofill or value
        if (input.value) {
            input.classList.add('filled');
        }
    });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
