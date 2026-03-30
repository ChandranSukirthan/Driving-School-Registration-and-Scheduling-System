<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Porsche Style Registration - DriveWise</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #D4AF37; /* Gold */
            --bg-color: #1e1f22;      /* Black */
            --text-light: #ffffff;
        }

        body {
            margin: 0;
            background-color: var(--bg-color); /* Solid black background */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-light);
        }

        .navbar {
            background-color: rgba(0, 0, 0, 0.95);
            padding: 1rem 2rem;
            display: flex;
            justify-content: center;
        }

        .navbar a {
            color: var(--text-light);
            margin: 0 15px;
            font-weight: bold;
            text-decoration: none;
        }

        .navbar a:hover {
            color: var(--primary-color);
        }

        .auth-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .auth-card {
            background: rgba(0, 0, 0, 0.8); /* Black background with slight transparency */
            border-radius: 20px;
            padding: 3rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.8);
            max-width: 450px;
            width: 100%;
        }

        .auth-card h2 {
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 2rem;
            font-weight: bold;
        }

        .form-group {
            position: relative;
            margin-bottom: 1.8rem;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid #444;
            border-radius: 12px;
            padding: 1rem;
            color: var(--text-light);
            font-size: 1rem;
            width: 100%;
        }

        .form-control:focus {
            background: rgba(0, 0, 0, 0.4);
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 8px rgba(212, 175, 55, 0.4);
        }

        .form-label {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background-color: transparent;
            padding: 0 5px;
            transition: 0.3s ease;
            color: #aaa;
            pointer-events: none;
        }

        .form-control:focus + .form-label,
        .form-control.filled + .form-label {
            top: -0.6rem;
            left: 0.9rem;
            background-color: var(--bg-color);
            font-size: 0.8rem;
            color: var(--primary-color);
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: #000;
            font-weight: bold;
            border: none;
            border-radius: 30px;
            padding: 0.9rem 2rem;
            width: 100%;
            font-size: 1rem;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background-color: #ffd700;
            transform: scale(1.02);
        }

        .auth-footer {
            margin-top: 1.5rem;
            text-align: center;
        }

        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 576px) {
            .auth-card {
                padding: 2rem;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="login.jsp">Login</a>
    <a href="register.jsp">Register</a>
</div>

<div class="auth-container">
    <div class="auth-card">
        <h2>Student Registration</h2>
        <form class="auth-form" action="RegisterServlet" method="post">
            <div class="form-group">
                <input type="text" class="form-control" id="username" name="username" required>
                <label for="username" class="form-label">Username</label>
            </div>

            <div class="form-group">
                <input type="password" class="form-control" id="password" name="password" required>
                <label for="password" class="form-label">Password</label>
            </div>

            <div class="form-group">
                <select class="form-control" id="userType" name="userType" required>
                    <option value="" disabled selected hidden></option>
                    <option value="basic">Basic</option>
                    <option value="standard">Standard</option>
                    <option value="premium">Premium</option>
                </select>
                <label for="userType" class="form-label">User Type</label>
            </div>

            <button type="submit" class="btn btn-primary">Register</button>

            <div class="auth-footer">
                Already registered? <a href="login.jsp">Login here</a>
            </div>
        </form>
    </div>
</div>

<!-- JS for floating label fix -->
<script>
    document.querySelectorAll('.form-control').forEach(input => {
        const label = input.nextElementSibling;
        function toggleLabel() {
            if (input.value) {
                input.classList.add('filled');
                label.classList.add('floating');
            } else {
                input.classList.remove('filled');
                label.classList.remove('floating');
            }
        }

        input.addEventListener('input', toggleLabel);
        input.addEventListener('change', toggleLabel);
        toggleLabel(); // On load
    });
</script>

</body>
</html>
