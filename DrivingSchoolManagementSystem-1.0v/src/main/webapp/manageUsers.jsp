<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.util.FileUtil, com.driveschool.model.Student, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - Driving School</title>

    <!-- Prevent theme flash -->
    <script>
        // Immediately set theme before page renders
        (function() {
            const savedTheme = localStorage.getItem('theme') ||
                (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', savedTheme);
            document.documentElement.style.backgroundColor = savedTheme === 'dark' ? '#000000' : '#ffffff';
        })();
    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Light Mode Variables */
            --primary-color: #0071e3;
            --secondary-color: #f5f5f7;
            --text-color: #1d1d1f;
            --text-muted: #86868b;
            --border-color: #d2d2d7;
            --bg-color: #fff;
            --card-bg: rgba(255, 255, 255, 0.9);
            --table-bg: rgba(255, 255, 255, 0.9);
            --table-text: #1d1d1f;
            --table-hover: rgba(0, 0, 0, 0.05);
            --modal-bg: #ffffff;
            --input-bg: #ffffff;
            --input-text: #1d1d1f;
            --btn-text: #ffffff;
        }

        /* Dark Mode Variables */
        [data-theme="dark"] {
            --primary-color: #2997ff;
            --secondary-color: #1d1d1f;
            --text-color: #f5f5f7;
            --text-muted: #86868b;
            --border-color: #38383a;
            --bg-color: #000000;
            --card-bg: rgba(28, 28, 30, 0.9);
            --table-bg: #1d1d1f;
            --table-text: #ffffff;
            --table-hover: rgba(255, 255, 255, 0.1);
            --modal-bg: #1d1d1f;
            --input-bg: #2d2d2f;
            --input-text: #f5f5f7;
            --btn-text: #ffffff;
        }

        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            transition: all 0.3s ease;
            min-height: 100vh;
        }

        .container {
            background-color: var(--card-bg);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin: 2rem auto;
            border: 1px solid var(--border-color);
            backdrop-filter: blur(10px);
        }

        .page-title {
            color: var(--text-color);
            text-align: center;
            margin-bottom: 2rem;
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-color), #2997ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .btn-add-user {
            background: var(--primary-color);
            color: var(--btn-text);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn-add-user:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
            background: #2997ff;
            color: var(--btn-text);
        }

        .search-box {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--input-text);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .search-box:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(41, 151, 255, 0.25);
            outline: none;
        }

        .table-custom {
            width: 100%;
            background-color: var(--table-bg);
            color: var(--table-text) !important;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            margin-bottom: 2rem;
        }

        .table-custom thead {
            background-color: var(--primary-color);
            border-bottom: 2px solid var(--border-color);
        }

        .table-custom thead tr {
            background-color: var(--primary-color);
        }

        .table-custom thead th {
            background-color: var(--primary-color);
            color: #ffffff !important;
            font-weight: 600;
            padding: 1.2rem 1rem;
            border: none;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table-custom tbody tr {
            border-bottom: 1px solid var(--border-color);
            transition: all 0.3s ease;
            color: var(--table-text) !important;
        }

        .table-custom tbody tr td {
            color: var(--table-text) !important;
            font-size: 1rem;
            padding: 1rem;
        }

        .table-custom tbody tr:hover {
            background-color: var(--table-hover);
            transform: scale(1.01);
        }

        .table-custom td {
            padding: 1rem;
            color: var(--table-text) !important;
            vertical-align: middle;
        }

        /* Update table section */
        .table-responsive {
            background-color: var(--table-bg);
            border-radius: 12px;
            padding: 1rem;
            border: 1px solid var(--border-color);
            margin-top: 1rem;
        }

        /* Override Bootstrap table styles */
        .table {
            color: var(--table-text) !important;
            margin-bottom: 0;
        }

        .table > :not(caption) > * > * {
            background-color: transparent;
            color: var(--table-text) !important;
        }

        .table > thead {
            background-color: var(--primary-color);
            color: #ffffff !important;
        }

        /* Modal Styling */
        .modal-content {
            background-color: var(--modal-bg);
            border-radius: 20px;
            border: 1px solid var(--border-color);
            color: var(--text-color);
        }

        .modal-header {
            border-bottom: 1px solid var(--border-color);
            padding: 1.5rem;
        }

        .modal-title {
            color: var(--text-color);
            font-weight: 600;
            font-size: 1.5rem;
        }

        .auth-card {
            padding: 2rem;
        }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--input-text);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(41, 151, 255, 0.25);
            outline: none;
        }

        .form-label {
            color: var(--text-color);
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-warning {
            background-color: #ff9500;
            border: none;
            color: #ffffff !important;
        }

        .btn-danger-custom {
            background-color: #ff3b30;
            border: none;
            color: #ffffff !important;
        }

        .btn-warning:hover, .btn-danger-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        /* Navigation Links */
        .nav-link-custom {
            color: var(--text-color);
            background-color: var(--card-bg);
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            text-decoration: none;
            border: 1px solid var(--border-color);
            font-weight: 500;
        }

        .nav-link-custom:hover {
            background-color: var(--primary-color);
            color: var(--btn-text);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        /* Theme Switch */
        .theme-switch {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 10px;
            border-radius: 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            z-index: 1000;
        }

        .theme-switch i {
            color: var(--text-color);
        }

        .theme-switch span {
            color: var(--text-color);
            font-size: 14px;
        }

        /* Fix search button */
        .btn-primary-custom {
            background-color: var(--primary-color);
            border: none;
            color: #ffffff !important;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            background-color: #2997ff;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<!-- Theme Switch Button -->
<button class="theme-switch" id="themeSwitch">
    <i class="fas fa-sun"></i>
    <span>Light Mode</span>
</button>

<div class="container">
    <!-- Page Header -->
    <header class="mb-5">
        <h2 class="text-center page-title">Manage Users</h2>
    </header>

    <!-- Add User Button -->
    <div class="text-end mb-4">
        <button type="button" class="btn btn-add-user" data-bs-toggle="modal" data-bs-target="#addUserModal">
            <i class="fas fa-user-plus"></i> Add New User
        </button>
    </div>

    <!-- Search Section -->
    <section class="mb-5">
        <form action="SearchUserServlet" method="get" class="row g-3">
            <div class="col-md-9">
                <input type="text" name="username" class="form-control search-box"
                       placeholder="Search by username" required>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary-custom w-100">Search</button>
            </div>
        </form>
    </section>

    <!-- Messages Section -->
    <section class="mb-4">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty notFound}">
            <div class="alert alert-warning">${notFound}</div>
        </c:if>
    </section>

    <!-- Search Results Section -->
    <c:if test="${not empty foundStudent}">
        <section class="mb-5">
            <div class="card search-result-card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Search Result</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Username:</strong> ${foundStudent.username}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>User Type:</strong> ${foundStudent.userType}</p>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="DeleteUserServlet?username=${foundStudent.username}"
                           class="btn btn-danger-custom"
                           onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

    <!-- Users Table Section -->
    <section class="mb-5">
        <div class="table-responsive">
            <table class="table table-custom">
                <thead>
                <tr>
                    <th scope="col">Username</th>
                    <th scope="col">User Type</th>
                    <th scope="col">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    FileUtil fileUtil = new FileUtil(application);
                    List<Student> students = fileUtil.readStudents();
                    for (Student student : students) {
                %>
                <tr>
                    <td><%= student.getUsername() %></td>
                    <td><%= student.getUserType() %></td>
                    <td>
                        <a href="DeleteUserServlet?username=<%= student.getUsername() %>"
                           class="btn btn-sm btn-danger-custom"
                           onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Navigation Section -->
    <nav class="d-flex flex-wrap justify-content-center">
        <a href="viewInstructors.jsp" class="nav-link-custom m-2">Instructors</a>
        <a href="manageUsers.jsp" class="nav-link-custom m-2">Manage Users</a>
        <a href="addInstructor.jsp" class="nav-link-custom m-2">Add Instructor</a>
        <a href="viewLessonRequests.jsp" class="nav-link-custom m-2">Lesson Requests</a>
        <a href="adminDashboard.jsp" class="nav-link-custom m-2">Dashboard</a>
    </nav>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="auth-form" action="AddUser" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>

                    <div class="mb-3">
                        <label for="userType" class="form-label">User Type</label>
                        <select class="form-control" id="userType" name="userType" required>
                            <option value="" disabled selected>Select user type</option>
                            <option value="basic">Basic</option>
                            <option value="standard">Standard</option>
                            <option value="premium">Premium</option>
                        </select>
                    </div>

                    <div class="text-end mt-4">
                        <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Font Awesome for icons -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Theme Switcher
    const themeSwitch = document.getElementById('themeSwitch');
    const htmlElement = document.documentElement;
    const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');

    // Function to toggle theme
    function toggleTheme() {
        const currentTheme = htmlElement.getAttribute('data-theme');
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

        htmlElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);

        // Update button icon and text
        const icon = themeSwitch.querySelector('i');
        const text = themeSwitch.querySelector('span');

        if (newTheme === 'dark') {
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
            text.textContent = 'Dark Mode';
        } else {
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
            text.textContent = 'Light Mode';
        }
    }

    // Set initial theme
    const savedTheme = localStorage.getItem('theme') ||
        (prefersDarkScheme.matches ? 'dark' : 'light');
    htmlElement.setAttribute('data-theme', savedTheme);

    // Update initial button state
    if (savedTheme === 'dark') {
        themeSwitch.querySelector('i').classList.remove('fa-sun');
        themeSwitch.querySelector('i').classList.add('fa-moon');
        themeSwitch.querySelector('span').textContent = 'Dark Mode';
    }

    // Add click event listener
    themeSwitch.addEventListener('click', toggleTheme);

    // Listen for system theme changes
    prefersDarkScheme.addEventListener('change', (e) => {
        const newTheme = e.matches ? 'dark' : 'light';
        htmlElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
    });
</script>
</body>
</html>
