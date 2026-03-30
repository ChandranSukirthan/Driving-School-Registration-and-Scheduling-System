<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="com.driveschool.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize FileUtil
    FileUtil fileUtil = new FileUtil(application);

    // Get current data
    List<Instructor> instructors = fileUtil.readInstructors();
    List<Vehicle> vehicles = fileUtil.readVehicles();
    List<String[]> feedbacks = fileUtil.readFeedback();

    // Calculate statistics
    int totalInstructors = instructors.size();
    int totalVehicles = vehicles.size();

    // Calculate operational vehicles
    long operationalVehicles = vehicles.stream()
            .filter(v -> "Good".equals(v.getMaintenanceStatus()))
            .count();

    // Calculate average rating
    double totalRating = 0;
    int ratingCount = 0;
    for (String[] feedback : feedbacks) {
        try {
            totalRating += Double.parseDouble(feedback[4]);
            ratingCount++;
        } catch (NumberFormatException e) {
            // Skip invalid ratings
        }
    }
    double averageRating = ratingCount > 0 ? Math.round((totalRating / ratingCount) * 10.0) / 10.0 : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DriveWise Academy</title>
    
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

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            /* Light Mode Variables */
            --primary-color: #0071e3;
            --secondary-color: #f5f5f7;
            --text-color: #1d1d1f;
            --text-muted: #86868b;
            --sidebar-width: 240px;
            --header-height: 44px;
            --border-color: #d2d2d7;
            --bg-color: #fff;
            --card-bg: rgba(255, 255, 255, 0.9);
            --modal-bg: #ffffff;
            --gradient-overlay: rgba(255, 255, 255, 0.97);
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
            --modal-bg: #1c1c1e;
            --gradient-overlay: rgba(0, 0, 0, 0.97);
        }

        * {
            transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
        }

        body {
            background-color: var(--bg-color);
            min-height: 100vh;
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text-color);
            margin: 0;
            padding: 0;
            display: flex;
            -webkit-font-smoothing: antialiased;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--secondary-color);
            position: fixed;
            left: 0;
            top: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            z-index: 1000;
            border-right: 1px solid var(--border-color);
        }

        .sidebar-header {
            height: var(--header-height);
            display: flex;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-header h1 {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .nav-menu {
            list-style: none;
            padding: 8px 0;
            margin: 0;
            overflow-y: auto;
        }

        .nav-section {
            padding: 0 8px;
            margin-bottom: 24px;
        }

        .nav-section-title {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            padding: 0 12px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .nav-item {
            margin: 2px 0;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 4px 12px;
            color: var(--text-color);
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.2s ease;
            font-size: 13px;
            font-weight: 400;
            height: 32px;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        [data-theme="light"] .nav-link:hover {
            background: rgba(0, 0, 0, 0.05);
        }

        .nav-link i {
            width: 16px;
            margin-right: 8px;
            font-size: 16px;
            color: var(--text-muted);
        }

        .nav-link.active {
            background: rgba(0, 113, 227, 0.1);
            color: var(--primary-color);
        }

        .nav-link.active i {
            color: var(--primary-color);
        }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 40px;
            width: calc(100% - var(--sidebar-width));
            background-color: var(--bg-color);
            background-image: linear-gradient(var(--gradient-overlay), var(--gradient-overlay)), 
                            url('https://img.freepik.com/free-photo/driving-school-concept_23-2149410733.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: var(--text-color);
            transition: background-color 0.3s ease;
        }

        .welcome-header {
            text-align: center;
            margin-bottom: 60px;
            position: relative;
        }

        .welcome-header h1 {
            font-size: 48px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary-color), #2997ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 16px;
            position: relative;
            display: inline-block;
        }

        .welcome-header h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 60%;
            height: 3px;
            background: linear-gradient(135deg, var(--primary-color), #2997ff);
            border-radius: 2px;
        }

        .welcome-header p {
            font-size: 18px;
            color: var(--text-muted);
            max-width: 600px;
            margin: 0 auto;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-top: 40px;
        }

        .dashboard-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-color);
        }

        .dashboard-icon {
            width: 72px;
            height: 72px;
            border-radius: 24px;
            background: linear-gradient(135deg, var(--primary-color), #2997ff);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            position: relative;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .dashboard-icon::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255,255,255,0.1), rgba(255,255,255,0));
            border-radius: inherit;
        }

        .dashboard-icon::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: linear-gradient(transparent, rgba(255,255,255,0.1));
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .dashboard-card:hover .dashboard-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 8px 16px rgba(0, 113, 227, 0.3);
        }

        .dashboard-card:hover .dashboard-icon::after {
            transform: translateY(0);
        }

        .dashboard-icon i {
            font-size: 28px;
            color: white;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }

        /* Custom icon styles */
        .icon-instructors {
            background: linear-gradient(135deg, #4ECDC4, #45B7AF);
        }

        .icon-vehicles {
            background: linear-gradient(135deg, #6C5CE7, #8A7CE8);
        }

        .icon-satisfaction {
            background: linear-gradient(135deg, #FF9A9E, #FAD0C4);
        }

        .icon-ring {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: inherit;
            border: 2px solid rgba(255, 255, 255, 0.1);
            animation: iconRing 2s linear infinite;
        }

        @keyframes iconRing {
            0% {
                transform: scale(0.8);
                opacity: 0;
            }
            50% {
                opacity: 0.5;
            }
            100% {
                transform: scale(1.2);
                opacity: 0;
            }
        }

        .dashboard-card h3 {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 8px;
        }

        .dashboard-stat {
            font-size: 32px;
            font-weight: 700;
            color: var(--primary-color);
            margin: 8px 0;
        }

        .dashboard-label {
            font-size: 14px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .stat-trend {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 14px;
            margin-top: 8px;
        }

        .trend-up {
            color: #34c759;
        }

        .trend-down {
            color: #ff3b30;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .mobile-toggle {
                display: flex;
                align-items: center;
                justify-content: center;
                position: fixed;
                top: 8px;
                left: 8px;
                z-index: 1001;
                width: 32px;
                height: 32px;
                background: rgba(255, 255, 255, 0.9);
                border: 1px solid var(--border-color);
                border-radius: 6px;
                color: var(--text-color);
                backdrop-filter: blur(20px);
            }

            .welcome-header h1 {
                font-size: 24px;
            }

            .dashboard-card {
                padding: 20px;
            }
        }

        /* Modal Styles */
        .modal-content {
            background-color: var(--modal-bg);
            color: var(--text-color);
            border: 1px solid var(--border-color);
        }

        .modal-header {
            border-bottom: 1px solid var(--border-color);
            background-color: var(--modal-bg);
        }

        .modal-footer {
            border-top: 1px solid var(--border-color);
            background-color: var(--modal-bg);
        }

        .btn-close {
            filter: invert(0);
        }

        [data-theme="dark"] .btn-close {
            filter: invert(1);
        }

        /* Theme Switch Refinements */
        .theme-switch {
            display: flex;
            align-items: center;
            padding: 8px 12px;
            margin: 16px;
            background: var(--card-bg);
            border-radius: 20px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .theme-switch i {
            font-size: 16px;
            color: var(--text-color);
            margin-right: 8px;
        }

        .theme-switch span {
            font-size: 14px;
            color: var(--text-color);
        }

        .theme-switch:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        [data-theme="light"] .theme-switch:hover {
            background: rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <h1>DriveWise</h1>
        </div>
        
        <!-- Theme Switch -->
        <button class="theme-switch" id="themeSwitch">
            <i class="fas fa-sun"></i>
            <span>Light Mode</span>
        </button>

        <ul class="nav-menu">
            <div class="nav-section">
                <div class="nav-section-title">Overview</div>
                <li class="nav-item">
                    <a href="#" class="nav-link active">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
            </div>
            
            <div class="nav-section">
                <div class="nav-section-title">Management</div>
                <li class="nav-item">
                    <a href="manageUsers.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Students</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="viewInstructors.jsp" class="nav-link">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Instructors</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="viewvehicle.jsp" class="nav-link">
                        <i class="fas fa-car"></i>
                        <span>Vehicles</span>
                    </a>
                </li>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Activities</div>
                <li class="nav-item">
                    <a href="viewLessonRequests.jsp" class="nav-link">
                        <i class="fas fa-calendar"></i>
                        <span>Lessons</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="viewPayment.jsp" class="nav-link">
                        <i class="fas fa-credit-card"></i>
                        <span>Payments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="viewFeedback.jsp" class="nav-link">
                        <i class="fas fa-comment"></i>
                        <span>Feedback</span>
                    </a>
                </li>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">About</div>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-bs-toggle="modal" data-bs-target="#visionMissionModal">
                        <i class="fas fa-bullseye"></i>
                        <span>Vision & Mission</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-bs-toggle="modal" data-bs-target="#aboutModal">
                        <i class="fas fa-info-circle"></i>
                        <span>About Us</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="LogoutServlet" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Sign Out</span>
                    </a>
                </li>
            </div>
        </ul>
    </nav>

    <!-- Vision & Mission Modal -->
    <div class="modal fade" id="visionMissionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Vision & Mission</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="vision-section mb-4">
                        <h6 class="fw-bold"><i class="fas fa-eye me-2"></i>Our Vision</h6>
                        <p>To be the leading driving school, creating safe and confident drivers who contribute to safer roads worldwide.</p>
                    </div>
                    <div class="mission-section">
                        <h6 class="fw-bold"><i class="fas fa-flag me-2"></i>Our Mission</h6>
                        <p>To provide exceptional driver education through:</p>
                        <ul>
                            <li>Professional instruction</li>
                            <li>Modern teaching methods</li>
                            <li>Comprehensive safety training</li>
                            <li>Personalized learning experiences</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- About Modal -->
    <div class="modal fade" id="aboutModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">About DriveWise Academy</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-3">DriveWise Academy is a premier driving school committed to excellence in driver education since 2023.</p>
                    <div class="about-section mb-3">
                        <h6 class="fw-bold"><i class="fas fa-star me-2"></i>What Sets Us Apart</h6>
                        <ul>
                            <li>Experienced instructors</li>
                            <li>Modern vehicle fleet</li>
                            <li>Comprehensive curriculum</li>
                            <li>Focus on safety</li>
                        </ul>
                    </div>
                    <div class="values-section">
                        <h6 class="fw-bold"><i class="fas fa-heart me-2"></i>Our Values</h6>
                        <ul>
                            <li>Safety First</li>
                            <li>Quality Education</li>
                            <li>Student Success</li>
                            <li>Community Impact</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Mobile Toggle Button -->
    <button class="mobile-toggle d-md-none">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Main Content -->
    <main class="main-content">
        <div class="welcome-header" data-aos="fade-up" data-aos-delay="100">
            <h1>Welcome, <%= username %>!</h1>
            <p>Monitor and manage your driving school's performance with real-time insights</p>
        </div>

        <div class="dashboard-grid">
            <!-- Instructors Card -->
            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="300">
                <div class="dashboard-icon icon-instructors">
                    <div class="icon-ring"></div>
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <h3>Instructors</h3>
                <div class="dashboard-stat"><%= totalInstructors %></div>
                <div class="dashboard-label">Certified Teachers</div>
                <div class="stat-trend trend-up">
                    <i class="fas fa-check-circle"></i>
                    <span>Professional Staff</span>
                </div>
            </div>

            <!-- Vehicle Fleet Card -->
            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="500">
                <div class="dashboard-icon icon-vehicles">
                    <div class="icon-ring"></div>
                    <i class="fas fa-car-alt"></i>
                </div>
                <h3>Vehicle Fleet</h3>
                <div class="dashboard-stat"><%= totalVehicles %></div>
                <div class="dashboard-label">Total Vehicles</div>
                <div class="stat-trend <%= operationalVehicles == totalVehicles ? "trend-up" : "" %>">
                    <i class="fas fa-tools"></i>
                    <span><%= operationalVehicles %> operational</span>
                </div>
            </div>

            <!-- Student Satisfaction Card -->
            <div class="dashboard-card" data-aos="fade-up" data-aos-delay="700">
                <div class="dashboard-icon icon-satisfaction">
                    <div class="icon-ring"></div>
                    <i class="fas fa-smile-beam"></i>
                </div>
                <h3>Student Satisfaction</h3>
                <div class="dashboard-stat"><%= averageRating %></div>
                <div class="dashboard-label">Average Rating</div>
                <div class="stat-trend <%= averageRating >= 4.0 ? "trend-up" : "" %>">
                    <i class="fas fa-star"></i>
                    <span>Based on <%= ratingCount %> reviews</span>
                </div>
            </div>
        </div>
    </main>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
    <script>
        // Initialize AOS
        AOS.init({
            duration: 1000,
            once: true,
            easing: 'ease-in-out'
        });

        // Mobile menu toggle
        document.querySelector('.mobile-toggle')?.addEventListener('click', () => {
            document.querySelector('.sidebar').classList.toggle('show');
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
