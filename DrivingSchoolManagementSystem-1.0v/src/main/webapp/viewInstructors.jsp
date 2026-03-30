<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="com.driveschool.model.Instructor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Instructors - Driving School</title>

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

    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Add AOS CSS -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            --table-hover: rgba(0, 0, 0, 0.05);
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
            --table-bg: rgba(28, 28, 30, 0.9);
            --table-hover: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            transition: background-color 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        main {
            flex: 1 0 auto;
        }

        footer {
            flex-shrink: 0;
            width: 100%;
            background: var(--card-bg);
            border-top: 1px solid var(--border-color);
            padding: 1.5rem 0;
            margin-top: auto;
        }

        .glass {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
        }

        nav {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
        }

        .nav-link {
            color: var(--text-color) !important;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
        }

        .nav-link.active {
            color: var(--primary-color) !important;
            font-weight: 600;
        }

        .dashboard-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-color);
        }

        table {
            background-color: var(--table-bg);
            color: var(--text-color);
        }

        th {
            background-color: var(--primary-color);
            color: var(--bg-color) !important;
            font-weight: 600;
        }

        tr {
            border-bottom: 1px solid var(--border-color);
        }

        tr:hover {
            background-color: var(--table-hover);
        }

        td {
            color: var(--text-color);
        }

        .btn-action {
            transition: all 0.3s ease;
        }

        .btn-delete {
            background-color: #ff3b30;
            color: var(--bg-color);
        }

        .btn-delete:hover {
            background-color: #ff2d55;
            transform: translateY(-2px);
        }

        .btn-update {
            background-color: var(--primary-color);
            color: var(--bg-color);
        }

        .btn-update:hover {
            background-color: #2997ff;
            transform: translateY(-2px);
        }

        .btn-add {
            background-color: var(--primary-color);
            color: var(--bg-color);
            transition: all 0.3s ease;
        }

        .btn-add:hover {
            background-color: #2997ff;
            transform: translateY(-2px);
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
    </style>
</head>
<body>
<!-- Theme Switch Button -->
<button class="theme-switch" id="themeSwitch" data-aos="fade-left" data-aos-duration="1000">
    <i class="fas fa-sun"></i>
    <span>Light Mode</span>
</button>

<!-- Navbar -->
<nav class="glass" data-aos="fade-down" data-aos-duration="1000">
    <div class="max-w-7xl mx-auto px-4 flex justify-between h-16 items-center">
        <div class="text-2xl font-bold tracking-wide flex items-center space-x-2" data-aos="fade-right" data-aos-delay="200">
            <span>Drive Wish Academy</span>
        </div>
        <div class="hidden md:flex space-x-6 font-medium" data-aos="fade-left" data-aos-delay="200">
            <a href="adminDashboard.jsp" class="nav-link">Home</a>
            <a href="manageUsers.jsp" class="nav-link">Manage Users</a>
            <a href="addInstructor.jsp" class="nav-link">Add Instructor</a>
            <a href="viewInstructors.jsp" class="nav-link active">View Instructors</a>
            <a href="viewLessonRequests.jsp" class="nav-link">Lesson Requests</a>
            <a href="viewFeedback.jsp" class="nav-link">View Feedback</a>
            <a href="viewPayment.jsp" class="nav-link">View Payments</a>
            <a href="viewvehicle.jsp" class="nav-link">View Vehicles</a>
            <a href="adminLogoutServlet" class="nav-link">Logout</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="flex-grow py-10 px-4 sm:px-6 lg:px-8">
    <div class="max-w-6xl mx-auto p-6 rounded-xl shadow-2xl glass" data-aos="zoom-in" data-aos-duration="1000">
        <h2 class="text-3xl font-bold mb-6 border-b border-primary-color pb-2" data-aos="fade-right" data-aos-delay="200">Instructors</h2>

        <!-- Success/Error Messages -->
        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert" data-aos="fade-down" data-aos-delay="400">
            <strong class="font-bold">Success!</strong>
            <span class="block sm:inline">Instructor updated successfully!</span>
        </div>
        <% }
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert" data-aos="fade-down" data-aos-delay="400">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline"><%= error %></span>
        </div>
        <% } %>

        <div class="overflow-x-auto" data-aos="fade-up" data-aos-delay="600">
            <table class="min-w-full bg-transparent border border-primary-color rounded-lg">
                <thead class="bg-primary-color bg-opacity-90">
                <tr>
                    <th class="py-3 px-6 text-left">Name</th>
                    <th class="py-3 px-6 text-left">Contact</th>
                    <th class="py-3 px-6 text-left">Availability</th>
                    <th class="py-3 px-6 text-left">Experience</th>
                    <th class="py-3 px-6 text-left">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-primary-color bg-white/5">
                <%
                    FileUtil fileUtil = new FileUtil(application);
                    List<Instructor> instructors = new ArrayList<>(fileUtil.readInstructors());

                    // Bubble sort descending by experience
                    for (int i = 0; i < instructors.size() - 1; i++) {
                        for (int j = 0; j < instructors.size() - i - 1; j++) {
                            if (instructors.get(j).getExperience() < instructors.get(j + 1).getExperience()) {
                                Instructor temp = instructors.get(j);
                                instructors.set(j, instructors.get(j + 1));
                                instructors.set(j + 1, temp);
                            }
                        }
                    }

                    int delay = 800;
                    for (Instructor instructor : instructors) {
                %>
                <tr class="hover:bg-primary-color/10 transition duration-200" data-aos="fade-up" data-aos-delay="<%= delay %>">
                    <td class="py-3 px-6"><%= instructor.getName() %></td>
                    <td class="py-3 px-6"><%= instructor.getContact() %></td>
                    <td class="py-3 px-6"><%= instructor.getAvailability() %></td>
                    <td class="py-3 px-6"><%= instructor.getExperience() %> yrs</td>
                    <td class="py-3 px-6 flex space-x-2">
                        <form method="post" action="DeleteInstructorServlet" onsubmit="return confirm('Are you sure you want to delete this instructor?');">
                            <input type="hidden" name="name" value="<%= instructor.getName() %>">
                            <button type="submit" class="btn-action btn-delete px-3 py-1 rounded-full text-sm">
                                <i class="fas fa-trash-alt mr-1"></i>Delete
                            </button>
                        </form>
                        <a href="updateInstructor.jsp?name=<%= instructor.getName() %>" class="btn-action btn-update px-3 py-1 rounded-full text-sm">
                            <i class="fas fa-edit mr-1"></i>Update
                        </a>
                    </td>
                </tr>
                <% 
                    delay += 200;
                } %>
                </tbody>
            </table>
        </div>

        <!-- Buttons -->
        <div class="mt-8 flex justify-center gap-6" data-aos="fade-up" data-aos-delay="<%= delay + 200 %>">
            <a href="addInstructor.jsp" class="btn-add px-6 py-2 rounded-full flex items-center gap-2 hover:scale-105 transition-transform">
                <i class="fas fa-plus-circle"></i>
                <span>Add Instructor</span>
            </a>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="glass" data-aos="fade-up" data-aos-duration="1000">
    <div class="container mx-auto px-4 text-center">
        <p class="text-lg font-semibold tracking-wider mb-2" data-aos="fade-up" data-aos-delay="200">🚗 DriveWise Academy — Speed Meets Safety</p>
        <p class="text-sm opacity-75" data-aos="fade-up" data-aos-delay="400">© 2025 All rights reserved. Built with care and innovation.</p>
    </div>
</footer>

<!-- Add AOS JS -->
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({
        once: true,
        mirror: false,
        duration: 800,
        easing: 'ease-in-out',
    });

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