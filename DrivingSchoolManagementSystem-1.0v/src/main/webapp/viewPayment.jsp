<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="com.driveschool.model.Payment" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Payments - Driving School</title>

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

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Add AOS CSS -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
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
            --success-bg: rgba(52, 211, 153, 0.1);
            --error-bg: rgba(248, 113, 113, 0.1);
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
            --success-bg: rgba(52, 211, 153, 0.05);
            --error-bg: rgba(248, 113, 113, 0.05);
        }

        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .nav-link.active {
            color: var(--primary-color) !important;
            font-weight: 600;
        }

        .search-box {
            background-color: var(--bg-color);
            border: 1px solid var(--border-color);
            color: var(--text-color);
        }

        .search-box:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(41, 151, 255, 0.25);
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

        /* Modal Styling */
        .modal {
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: var(--card-bg);
            color: var(--text-color);
            border: 1px solid var(--border-color);
        }

        .modal-header {
            border-bottom: 1px solid var(--border-color);
        }

        .modal-footer {
            border-top: 1px solid var(--border-color);
        }

        /* Success/Error Messages */
        .alert-success {
            background-color: var(--success-bg);
            color: #34D399;
            border: 1px solid #34D399;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background-color: var(--error-bg);
            color: #F87171;
            border: 1px solid #F87171;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
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
            <a href="viewInstructors.jsp" class="nav-link">View Instructors</a>
            <a href="viewLessonRequests.jsp" class="nav-link">Lesson Requests</a>
            <a href="viewFeedback.jsp" class="nav-link">View Feedback</a>
            <a href="viewPayment.jsp" class="nav-link active">View Payments</a>
            <a href="viewvehicle.jsp" class="nav-link">View Vehicles</a>
            <a href="adminLogoutServlet" class="nav-link">Logout</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="flex-grow py-10 px-4 sm:px-6 lg:px-8">
    <div class="max-w-6xl mx-auto p-6 rounded-xl shadow-2xl glass" data-aos="zoom-in" data-aos-duration="1000">
        <h2 class="text-3xl font-bold mb-6 border-b pb-2" data-aos="fade-right" data-aos-delay="200">User Payments</h2>

        <!-- Success/Error Message -->
        <%
            String success = request.getParameter("success");
            if(success != null) {
        %>
        <div id="successMessage" class="alert-success flex items-center justify-between" data-aos="fade-down" data-aos-delay="400">
            <span>Payment deleted successfully!</span>
            <button onclick="closeMessage('successMessage')" class="hover:opacity-75">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <% }
            String error = request.getParameter("error");
            if(error != null) {
        %>
        <div id="errorMessage" class="alert-danger flex items-center justify-between" data-aos="fade-down" data-aos-delay="400">
            <span>Error: <%= error %></span>
            <button onclick="closeMessage('errorMessage')" class="hover:opacity-75">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <% }
        %>

        <!-- Search Form -->
        <form method="get" class="mb-6 flex flex-col sm:flex-row sm:items-center gap-4" data-aos="fade-up" data-aos-delay="600">
            <input type="text" name="search" placeholder="Search by username"
                   value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                   class="search-box px-4 py-2 rounded w-full sm:w-1/3">
            <button type="submit"
                    class="px-4 py-2 bg-primary-color hover:opacity-90 text-white font-semibold rounded transition">
                Search
            </button>
        </form>

        <div class="overflow-x-auto" data-aos="fade-up" data-aos-delay="800">
            <table class="min-w-full rounded-lg">
                <thead data-aos="fade-down" data-aos-delay="1000">
                <tr>
                    <th class="py-3 px-6 text-left">Username</th>
                    <th class="py-3 px-6 text-left">Payment Amount</th>
                    <th class="py-3 px-6 text-left">Payment Date</th>
                    <th class="py-3 px-6 text-left">Payment Method</th>
                    <th class="py-3 px-6 text-left">Status</th>
                    <th class="py-3 px-6 text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    FileUtil fileUtil = new FileUtil(application);
                    List<Payment> paymentList = fileUtil.readPayments();
                    String searchQuery = request.getParameter("search");
                    int delay = 1200;
                    for (Payment payment : paymentList) {
                        if (searchQuery != null && !searchQuery.trim().isEmpty() &&
                                !payment.getCardHolder().toLowerCase().contains(searchQuery.trim().toLowerCase())) {
                            continue;
                        }
                %>
                <tr data-aos="fade-up" data-aos-delay="<%= delay %>">
                    <td class="py-3 px-6"><%= payment.getCardHolder() %></td>
                    <td class="py-3 px-6"><%= payment.getAmount() %></td>
                    <td class="py-3 px-6"><%= payment.getTimestamp() %></td>
                    <td class="py-3 px-6"><%= payment.getStatus() %></td>
                    <td class="py-3 px-6"><%= payment.getStatus() %></td>
                    <td class="py-3 px-6 text-center">
                        <button onclick="confirmDelete('<%= payment.getCardHolder() %>')" 
                                class="btn-action btn-delete px-3 py-1 rounded-full text-sm">
                            <i class="fas fa-trash-alt mr-1"></i>Delete
                        </button>
                    </td>
                </tr>
                <% 
                    delay += 200;
                } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="glass text-center py-6 mt-10" data-aos="fade-up" data-aos-duration="1000">
    <p class="text-lg font-semibold tracking-wider" data-aos="fade-up" data-aos-delay="200">🚗 Driving School — Speed Meets Safety</p>
    <p class="text-sm opacity-75" data-aos="fade-up" data-aos-delay="400">© 2025 All rights reserved. Built with care and innovation.</p>
</footer>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal fixed inset-0 hidden items-center justify-center">
    <div class="modal-content p-6 rounded-lg shadow-xl max-w-md w-full mx-4" data-aos="zoom-in" data-aos-duration="300">
        <h3 class="text-xl font-bold mb-4">Confirm Deletion</h3>
        <p class="mb-6">Are you sure you want to delete this payment record? This action cannot be undone.</p>
        <div class="flex justify-end space-x-4">
            <button onclick="closeDeleteModal()" 
                    class="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                Cancel
            </button>
            <form id="deleteForm" action="DeletePaymentServlet" method="POST" class="inline">
                <input type="hidden" id="cardHolder" name="cardHolder" value="">
                <button type="submit" 
                        class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors">
                    Delete
                </button>
            </form>
        </div>
    </div>
</div>

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

    function confirmDelete(cardHolder) {
        document.getElementById('cardHolder').value = cardHolder;
        document.getElementById('deleteModal').style.display = 'flex';
        // Refresh AOS for modal content
        AOS.refresh();
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }

    function closeMessage(messageId) {
        document.getElementById(messageId).remove();
    }

    // Auto-close success message after 5 seconds
    window.onload = function() {
        const successMessage = document.getElementById('successMessage');
        if (successMessage) {
            setTimeout(() => {
                successMessage.remove();
            }, 5000);
        }
    };

    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeDeleteModal();
        }
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