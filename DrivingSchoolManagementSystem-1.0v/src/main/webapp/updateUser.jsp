<%@ page import="com.driveschool.model.Student" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%
    String username = request.getParameter("username");
    if (username == null || username.isEmpty()) {
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
    <title>Update Profile - DriveWise Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ffc107;
            --secondary-color: #1e1f22;
            --accent-color: #e43e31;
            --text-color: #ffffff;
            --text-muted: #ccc;
            --card-bg: rgb(30, 31, 34);
        }
        body {
            background-color: var(--secondary-color);
            color: var(--text-color);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
        }
        .card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: var(--secondary-color);
            padding: 1.5rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .form-control {
            background-color: var(--card-bg);
            border: 1px solid var(--text-muted);
            color: var(--text-color);
            border-radius: 8px;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.25);
            background-color: var(--card-bg);
            color: var(--text-color);
        }
        .form-label {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        .btn-submit, .btn-back {
            background-color: var(--primary-color);
            color: var(--secondary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-submit:hover, .btn-back:hover {
            background-color: #ffca2c;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a href="#" class="navbar-brand d-flex align-items-center">
            <i class="fas fa-car me-2"></i>
            DriveWise Academy
        </a>
        <div class="navbar-nav ms-auto">
            <a href="aboutyou.jsp" class="nav-link">Back to Profile</a>
        </div>
    </div>
</nav>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card" data-aos="fade-up">
                <div class="card-header">
                    <h2 class="m-0">Update Profile</h2>
                </div>
                <div class="card-body p-4">
                    <form action="UpdateUserServlet" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username"
                                   value="<%= student.getUsername() %>" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password"
                                   value="<%= student.getPassword() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="userType" class="form-label">Package Type</label>
                            <select class="form-control" id="userType" name="userType" required>
                                <option value="basic" <%= "basic".equals(student.getUserType()) ? "selected" : "" %>>Basic</option>
                                <option value="standard" <%= "standard".equals(student.getUserType()) ? "selected" : "" %>>Standard</option>
                                <option value="premium" <%= "premium".equals(student.getUserType()) ? "selected" : "" %>>Premium</option>
                            </select>
                        </div>
                        <div class="text-end">
                            <a href="aboutyou.jsp" class="btn btn-back me-2">
                                <i class="fas fa-arrow-left me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true,
        easing: 'ease-in-out'
    });
</script>
</body>
</html>
