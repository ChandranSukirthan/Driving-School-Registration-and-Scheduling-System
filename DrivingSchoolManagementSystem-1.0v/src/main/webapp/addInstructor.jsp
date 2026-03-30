<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Instructor - Driving School</title>

    <!-- Prevent theme flash -->
    <script>
        // Immediately set theme before page renders
        (function() {
            const savedTheme = localStorage.getItem('theme') || 
                (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', savedTheme);
            // Add a class to body to prevent any white flash
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
            --input-bg: rgba(255, 255, 255, 0.7);
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
            --input-bg: rgba(28, 28, 30, 0.7);
        }

        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            transition: background-color 0.3s ease;
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

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--text-color);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px var(--primary-color);
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--text-color);
        }

        .btn-submit {
            background-color: var(--primary-color);
            color: var(--bg-color);
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .message {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
        }

        .success {
            border-color: #34D399;
            color: #34D399;
        }

        .error {
            border-color: #F87171;
            color: #F87171;
        }
    </style>
</head>
<body>

<!-- Theme Switch Button -->
<button class="theme-switch fixed top-5 right-5 glass p-3 rounded-full cursor-pointer flex items-center gap-2 z-50" id="themeSwitch" data-aos="fade-left" data-aos-duration="1000">
    <i class="fas fa-sun"></i>
    <span>Light Mode</span>
</button>

<!-- Navbar -->
<nav class="glass" data-aos="fade-down" data-aos-duration="1000">
    <div class="max-w-7xl mx-auto px-4 flex justify-between h-16 items-center">
        <div class="text-2xl font-bold tracking-wide flex items-center space-x-2" data-aos="fade-right" data-aos-delay="200">
            <i class="fas fa-car-side mr-2"></i>
            <span>Drive Wish Academy</span>
        </div>
        <div class="hidden md:flex space-x-6 font-medium" data-aos="fade-left" data-aos-delay="200">
            <a href="adminDashboard.jsp" class="nav-link">
                <i class="fas fa-home mr-1"></i>Home
            </a>
            <a href="manageUsers.jsp" class="nav-link">
                <i class="fas fa-users mr-1"></i>Manage Users
            </a>
            <a href="viewInstructors.jsp" class="nav-link">
                <i class="fas fa-chalkboard-teacher mr-1"></i>View Instructors
            </a>
            <a href="LogoutServlet" class="nav-link">
                <i class="fas fa-sign-out-alt mr-1"></i>Logout
            </a>
        </div>
    </div>
</nav>

<div class="min-h-screen py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md mx-auto glass rounded-2xl shadow-xl" data-aos="zoom-in" data-aos-duration="1000">
        <div class="px-8 py-6">
            <h2 class="text-2xl font-bold text-center mb-8" data-aos="fade-up" data-aos-delay="200">
                <i class="fas fa-user-plus mr-2"></i>Add New Instructor
            </h2>

            <!-- Display Success/Error Message -->
            <%
                String message = (String) request.getAttribute("message");
                String messageType = (String) request.getAttribute("messageType");
                if (message != null) {
            %>
            <div class="message <%= messageType %> p-4 rounded-lg mb-6" data-aos="fade-up" data-aos-delay="400">
                <%= message %>
            </div>
            <% } %>

            <form action="AddInstructorServlet" method="post" onsubmit="return validateForm()">
                <div class="space-y-6">
                    <div data-aos="fade-up" data-aos-delay="600">
                        <label class="block text-sm font-medium mb-2">
                            <i class="fas fa-user mr-2"></i>Instructor Name
                        </label>
                        <input type="text" name="name" class="form-control w-full px-4 py-2 rounded-lg" 
                               placeholder="Enter instructor name" required pattern="[A-Za-z\s]+" 
                               title="Please enter a valid name (letters and spaces only)">
                    </div>

                    <div data-aos="fade-up" data-aos-delay="800">
                        <label class="block text-sm font-medium mb-2">
                            <i class="fas fa-phone mr-2"></i>Contact Number
                        </label>
                        <input type="tel" name="contact" class="form-control w-full px-4 py-2 rounded-lg" 
                               placeholder="Enter contact number" required pattern="[0-9]{10}" 
                               title="Please enter a valid 10-digit phone number">
                    </div>

                    <div data-aos="fade-up" data-aos-delay="1000">
                        <label class="block text-sm font-medium mb-2">
                            <i class="fas fa-calendar-check mr-2"></i>Availability
                        </label>
                        <select name="availability" class="form-select w-full px-4 py-2 rounded-lg" required>
                            <option value="Available">Available</option>
                            <option value="Unavailable">Unavailable</option>
                        </select>
                    </div>

                    <div data-aos="fade-up" data-aos-delay="1200">
                        <label class="block text-sm font-medium mb-2">
                            <i class="fas fa-briefcase mr-2"></i>Experience (Years)
                        </label>
                        <input type="number" name="experience" class="form-control w-full px-4 py-2 rounded-lg" 
                               placeholder="Enter years of experience" required min="0" max="50">
                    </div>

                    <div data-aos="fade-up" data-aos-delay="1400">
                        <button type="submit" class="btn-submit w-full py-2 px-4 rounded-lg font-medium">
                            <i class="fas fa-user-plus mr-2"></i>Add Instructor
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="glass text-center py-6" data-aos="fade-up" data-aos-duration="1000">
    <p class="text-lg font-semibold tracking-wider" data-aos="fade-up" data-aos-delay="200">
        <i class="fas fa-car mr-2"></i>Driving School — Speed Meets Safety
    </p>
    <p class="text-sm opacity-75" data-aos="fade-up" data-aos-delay="400">© 2025 All rights reserved.</p>
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

    // Form validation
    function validateForm() {
        const name = document.querySelector('input[name="name"]').value.trim();
        const contact = document.querySelector('input[name="contact"]').value.trim();
        const experience = document.querySelector('input[name="experience"]').value;

        const namePattern = /^[A-Za-z\s]+$/;
        const contactPattern = /^[0-9]{10}$/;

        if (!namePattern.test(name)) {
            alert('Please enter a valid name (letters and spaces only)');
            return false;
        }

        if (!contactPattern.test(contact)) {
            alert('Please enter a valid 10-digit contact number');
            return false;
        }

        if (experience < 0 || experience > 50) {
            alert('Please enter a valid experience between 0 and 50 years');
            return false;
        }

        return true;
    }
</script>
</body>
</html>