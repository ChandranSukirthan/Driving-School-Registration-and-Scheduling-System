<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - DriveWise Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ffc107; /* Porsche Yellow */
            --secondary-color: #2b2d30; /* Charcoal Dark */
            --accent-color: #e43e31; /* Red accent */
            --text-color: #ffffff; /* White */
            --text-muted: #ccc; /* Muted text */
            --card-bg: rgba(43, 45, 48, 0.95); /* Dark card with transparency */
        }

        body {
            background-color: var(--secondary-color);
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: var(--text-color);
            margin: 0;
            padding-top: 70px; /* Offset for fixed navbar */
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            background: transparent;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            transition: background 0.3s ease;
        }

        .navbar.scrolled {
            background: rgba(43, 45, 48, 0.9);
            backdrop-filter: blur(10px);
        }

        .navbar-brand, .nav-link {
            color: var(--text-color) !important;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-link:hover, .navbar-brand:hover {
            color: var(--accent-color) !important;
        }

        .nav-link.active {
            color: var(--primary-color) !important;
        }

        .nav-link.home-link {
            color: var(--primary-color) !important;
            font-weight: 600;
        }

        .nav-link.home-link:hover {
            color: #ffca2c !important;
            transform: translateY(-1px);
        }

        .nav-link i {
            margin-right: 5px;
        }

        /* Zoom-out animation */
        @keyframes zoom-out {
            from {
                transform: scale(1.5);
                opacity: 0.7;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .dashboard-content {
            animation: zoom-out 0.5s ease-in-out forwards;
        }

        /* Welcome Section */
        .welcome-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .welcome-header {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 2rem;
        }

        .welcome-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 1.5rem;
        }

        /* Dashboard Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
        }

        .card-body {
            padding: 1.5rem;
            text-align: center;
        }

        .card-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(255, 193, 7, 0.2);
            color: var(--primary-color);
            font-size: 1.5rem;
            margin: 0 auto 1rem;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 1rem;
        }

        .card-link {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            background: var(--primary-color);
            color: #000;
            font-weight: 600;
            border-radius: 25px;
            text-decoration: none;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .card-link:hover {
            background: #ffca2c;
            transform: translateY(-2px);
        }

        .card-link.logout {
            background: var(--accent-color);
            color: var(--text-color);
        }

        .card-link.logout:hover {
            background: #ff5733;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding-top: 60px;
            }
            .welcome-section h1 {
                font-size: 2rem;
            }
            .card-body {
                padding: 1rem;
            }
            .card-link {
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark" data-aos="fade-down">
    <div class="container-fluid">
        <a class="navbar-brand" href="#" data-aos="fade-right">DriveWise Academy</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link home-link" href="dashboard.jsp" data-aos="fade-left" data-aos-delay="100">
                        <i class="fas fa-home"></i>Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet" data-aos="fade-left" data-aos-delay="500">
                        <i class="fas fa-sign-out-alt"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Dashboard Content -->
<div class="dashboard-content">
    <section class="welcome-section" data-aos="fade-up">
        <div class="welcome-header">
            <h1 data-aos="fade-up" data-aos-delay="100">Welcome, <%= username %>!</h1>
        </div>
        <div class="dashboard-grid">
            <div class="card" data-aos="zoom-in" data-aos-delay="200">
                <div class="card-body">
                    <div class="card-icon">📅</div>
                    <h5 class="card-title">Schedule a Lesson</h5>
                    <a href="scheduleLesson.jsp" class="card-link">Book Now →</a>
                </div>
            </div>
            <div class="card" data-aos="zoom-in" data-aos-delay="300">
                <div class="card-body">
                    <div class="card-icon">📖</div>
                    <h5 class="card-title">View My Lessons</h5>
                    <a href="viewStudentLessons.jsp" class="card-link">View Lessons →</a>
                </div>
            </div>
            <div class="card" data-aos="zoom-in" data-aos-delay="400">
                <div class="card-body">
                    <div class="card-icon">📊</div>
                    <h5 class="card-title">Instructor Chart</h5>
                    <a href="viewInstructors01.jsp" class="card-link">View Chart →</a>
                </div>
            </div>
            <div class="card" data-aos="zoom-in" data-aos-delay="500">
                <div class="card-body">
                    <div class="card-icon">👤</div>
                    <h5 class="card-title">About You</h5>
                    <a href="aboutyou.jsp" class="card-link">View Profile →</a>
                </div>
            </div>
            <div class="card" data-aos="zoom-in" data-aos-delay="600">
                <div class="card-body">
                    <div class="card-icon">📝</div>
                    <h5 class="card-title">Feedback</h5>
                    <a href="Feedback.jsp" class="card-link">Give Feedback →</a>
                </div>
            </div>
            <div class="card" data-aos="zoom-in" data-aos-delay="700">
                <div class="card-body">
                    <div class="card-icon">💳</div>
                    <h5 class="card-title">Payment</h5>
                    <a href="payment.jsp" class="card-link">Make Payment →</a>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({ duration: 1000, once: true, easing: 'ease-in-out' });

    // Navbar scroll effect
    window.addEventListener('scroll', () => {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
</script>
</body>
</html>