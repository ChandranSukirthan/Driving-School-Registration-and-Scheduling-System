<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="com.driveschool.model.Instructor" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Update Instructor - Driving School</title>

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
      --input-bg: rgba(255, 255, 255, 0.1);
      --input-border: rgba(255, 255, 255, 0.2);
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
      --input-bg: rgba(255, 255, 255, 0.05);
      --input-border: rgba(255, 255, 255, 0.1);
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

    .nav-link {
      color: var(--text-color) !important;
      transition: color 0.3s ease;
    }

    .nav-link:hover {
      color: var(--primary-color) !important;
    }

    input, select {
      background-color: var(--input-bg) !important;
      border-color: var(--input-border) !important;
      color: var(--text-color) !important;
    }

    input:focus, select:focus {
      border-color: var(--primary-color) !important;
      box-shadow: 0 0 0 2px rgba(41, 151, 255, 0.25) !important;
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
    <h2 class="text-3xl font-bold mb-6 border-b border-primary-color pb-2" data-aos="fade-right" data-aos-delay="200">Update Instructor</h2>

    <%
      String name = request.getParameter("name");
      FileUtil fileUtil = new FileUtil(application);
      List<Instructor> instructors = fileUtil.readInstructors();
      Instructor instructorToUpdate = null;
      for (Instructor instructor : instructors) {
        if (instructor.getName().equals(name)) {
          instructorToUpdate = instructor;
          break;
        }
      }
      if (instructorToUpdate != null) {
    %>
    <form action="UpdateInstructorServlet" method="post" class="space-y-6" data-aos="fade-up" data-aos-delay="400">
      <input type="hidden" name="name" value="<%= instructorToUpdate.getName() %>">
      <input type="hidden" name="contact" value="<%= instructorToUpdate.getContact() %>">

      <div class="mb-4" data-aos="fade-right" data-aos-delay="600">
        <label class="block text-lg font-semibold mb-2" for="availability">Availability</label>
        <select id="availability" name="availability" class="w-full p-3 rounded-lg focus:outline-none transition-all duration-300" required>
          <option value="Available" <%= "Available".equals(instructorToUpdate.getAvailability()) ? "selected" : "" %>>Available</option>
          <option value="Unavailable" <%= "Unavailable".equals(instructorToUpdate.getAvailability()) ? "selected" : "" %>>Unavailable</option>
        </select>
      </div>

      <div class="mb-4" data-aos="fade-right" data-aos-delay="800">
        <label class="block text-lg font-semibold mb-2" for="experience">Experience (years)</label>
        <input type="number" id="experience" name="experience" value="<%= instructorToUpdate.getExperience() %>" 
               class="w-full p-3 rounded-lg focus:outline-none transition-all duration-300" required min="0">
      </div>

      <button type="submit" class="w-full bg-primary-color hover:opacity-90 text-white font-bold py-3 px-6 rounded-lg transition duration-300 flex items-center justify-center gap-2" data-aos="zoom-in" data-aos-delay="1000">
        <i class="fas fa-save"></i>
        <span>Update Instructor</span>
      </button>
    </form>
    <% } else { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert" data-aos="fade-up" data-aos-delay="200">
      <strong class="font-bold">Error!</strong>
      <span class="block sm:inline"> Instructor not found!</span>
    </div>
    <% } %>
    <a href="viewInstructors.jsp" class="block text-center mt-6 text-primary-color hover:opacity-80 font-semibold transition flex items-center justify-center gap-2" data-aos="fade-up" data-aos-delay="1200">
      <i class="fas fa-arrow-left"></i>
      <span>Back to Instructors</span>
    </a>
  </div>
</main>

<!-- Footer -->
<footer class="glass text-center py-6 mt-10" data-aos="fade-up" data-aos-duration="1000">
  <p class="text-lg font-semibold tracking-wider" data-aos="fade-up" data-aos-delay="200">🚗 Driving School — Speed Meets Safety</p>
  <p class="text-sm opacity-75" data-aos="fade-up" data-aos-delay="400">© 2025 All rights reserved. Built with care and innovation.</p>
</footer>

<!-- Add AOS JS -->
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
  // Initialize AOS
  AOS.init({
    once: true, // whether animation should happen only once - while scrolling down
    mirror: false, // whether elements should animate out while scrolling past them
    duration: 800, // values from 0 to 3000, with step 50ms
    easing: 'ease-in-out', // default easing for AOS animations
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