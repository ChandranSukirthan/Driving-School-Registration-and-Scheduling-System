<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.model.Student" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>View Feedback - DriveWise Academy</title>

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
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
      --rating-star: #fbbf24;
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
      --rating-star: #fbbf24;
    }

    body {
      font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
      background-color: var(--bg-color);
      color: var(--text-color);
      min-height: 100vh;
      margin: 0;
      transition: background-color 0.3s ease;
    }

    .container {
      max-width: 64rem;
      margin: 3rem auto;
      padding: 0 1rem;
    }

    .dashboard-card {
      background: var(--card-bg);
      backdrop-filter: blur(10px);
      padding: 2rem;
      border-radius: 1.5rem;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
      border: 1px solid var(--border-color);
      transition: transform 0.3s ease;
    }

    .dashboard-card:hover {
      transform: translateY(-5px);
    }

    .dashboard-card h2 {
      font-size: 1.75rem;
      font-weight: 600;
      color: var(--text-color);
      text-align: center;
      margin-bottom: 2rem;
    }

    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      color: var(--text-color);
      background-color: var(--table-bg);
    }

    th, td {
      padding: 1rem;
      text-align: left;
      border-bottom: 1px solid var(--border-color);
    }

    th {
      background-color: var(--primary-color);
      color: var(--bg-color);
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.9rem;
      letter-spacing: 0.05rem;
    }

    tr {
      transition: background-color 0.3s ease;
    }

    tr:hover {
      background-color: var(--table-hover);
    }

    .rating {
      display: flex;
      gap: 0.25rem;
    }

    .star {
      color: var(--rating-star);
    }

    .btn-back {
      display: inline-flex;
      align-items: center;
      padding: 0.75rem 1.5rem;
      background-color: var(--primary-color);
      color: var(--bg-color);
      font-weight: 500;
      border-radius: 0.75rem;
      margin-top: 2rem;
      transition: all 0.3s ease;
    }

    .btn-back:hover {
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
<button class="theme-switch" id="themeSwitch">
    <i class="fas fa-sun"></i>
    <span>Light Mode</span>
</button>

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-800 to-yellow-500 shadow-md glass">
  <div class="max-w-7xl mx-auto px-4 flex justify-between h-16 items-center">
    <div class="text-white text-2xl font-bold tracking-wide flex items-center space-x-2">
      <span>Drive Wish Academy</span>
    </div>
    <div class="hidden md:flex space-x-6 text-white font-medium">
      <a href="adminDashboard.jsp" class="hover:text-yellow-300 transition">Home</a>
      <a href="manageUsers.jsp" class="hover:text-yellow-300 transition">Manage Users</a>
      <a href="addInstructor.jsp" class="hover:text-yellow-300 transition">Add Instructor</a>
      <a href="viewInstructors.jsp" class="hover:text-yellow-300 transition">View Instructors</a>
      <a href="viewLessonRequests.jsp" class="hover:text-yellow-300 transition">Lesson Requests</a>
      <a href="viewFeedback.jsp" class="text-yellow-300 font-semibold">View Feedback</a>
      <a href="adminLogoutServlet" class="hover:text-yellow-300 transition">Logout</a>
    </div>
  </div>
</nav>

<!-- Main Content -->
<main class="flex-grow py-10 px-4 sm:px-6 lg:px-8">
  <div class="max-w-6xl mx-auto p-6 rounded-xl shadow-2xl glass">
    <h2 class="text-3xl font-bold mb-6 border-b border-yellow-400 pb-2 text-yellow-300">User Feedback</h2>

    <% if(request.getParameter("success") != null) { %>
    <div class="bg-green-600 text-white p-4 rounded mb-4 flex items-center justify-between">
      <span>Feedback deleted successfully!</span>
      <button onclick="this.parentElement.remove()" class="text-white hover:text-gray-200">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
    <div class="bg-red-600 text-white p-4 rounded mb-4 flex items-center justify-between">
      <span>Error: <%= request.getParameter("error") %></span>
      <button onclick="this.parentElement.remove()" class="text-white hover:text-gray-200">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <% } %>

    <!-- Search Form -->
    <form method="get" class="mb-6 flex flex-col sm:flex-row sm:items-center gap-4">
      <input type="text" name="search" placeholder="Search by username"
             value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
             class="px-4 py-2 rounded bg-white/10 border border-white/30 text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-yellow-300 w-full sm:w-1/3">
      <button type="submit"
              class="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 text-white font-semibold rounded transition">
        Search
      </button>
    </form>

    <div class="overflow-x-auto">
      <table class="min-w-full bg-transparent text-white border border-blue-300 rounded-lg">
        <thead class="bg-blue-800 bg-opacity-90">
        <tr>
          <th class="py-3 px-6 text-left">Username</th>
          <th class="py-3 px-6 text-left">Name</th>
          <th class="py-3 px-6 text-left">Email</th>
          <th class="py-3 px-6 text-left">Type</th>
          <th class="py-3 px-6 text-left">Rating</th>
          <th class="py-3 px-6 text-left">Date</th>
          <th class="py-3 px-6 text-left">Message</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-blue-500 bg-white/5">
        <%
          // Check if user is logged in and get role
          String username = (String) session.getAttribute("username");
          String userRole = (String) session.getAttribute("role");
          boolean isAdmin = "admin".equals(userRole);
          
          if (username == null) {
              response.sendRedirect("login.jsp");
              return;
          }

          FileUtil fileUtil = new FileUtil(application);
          List<String[]> feedbackList = fileUtil.readFeedback();
          String searchQuery = request.getParameter("search");

          // If not admin, only show feedback for the current user
          if (!isAdmin) {
              List<String[]> userFeedback = new java.util.ArrayList<>();
              for (String[] feedback : feedbackList) {
                  if (feedback[0].equals(username)) {
                      userFeedback.add(feedback);
                  }
              }
              feedbackList = userFeedback;
          }
        %>
        <%
          for (String[] feedback : feedbackList) {
            if (searchQuery != null && !searchQuery.trim().isEmpty() &&
                    !feedback[0].toLowerCase().contains(searchQuery.trim().toLowerCase())) {
              continue;
            }
            String stars = "★".repeat(Integer.parseInt(feedback[4])) + "☆".repeat(5 - Integer.parseInt(feedback[4]));
        %>
        <tr class="hover:bg-blue-900/30 transition duration-200">
          <td class="py-3 px-6"><%= feedback[0] %></td>
          <td class="py-3 px-6"><%= feedback[1] %></td>
          <td class="py-3 px-6"><%= feedback[2] %></td>
          <td class="py-3 px-6"><%= feedback[3] %></td>
          <td class="py-3 px-6"><span class="stars"><%= stars %></span></td>
          <td class="py-3 px-6"><%= feedback[5] %></td>
          <td class="py-3 px-6"><%= feedback[6] %></td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>
</main>

<!-- Footer -->
<footer class="bg-gradient-to-r from-blue-800 to-yellow-500 text-white text-center py-6 mt-10 glass">
  <p class="text-lg font-semibold tracking-wider">🚗 DriveWise Academy — Speed Meets Safety</p>
  <p class="text-sm text-yellow-100">© 2025 All rights reserved. Built with care and innovation.</p>
</footer>

<!-- Remove Edit Feedback Modal and Delete Confirmation Modal -->

<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<script>
    // Auto-close success/error messages after 5 seconds
    window.addEventListener('load', () => {
        const messages = document.querySelectorAll('#successMessage, #errorMessage');
        messages.forEach(message => {
            setTimeout(() => {
                message.remove();
            }, 5000);
        });
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
