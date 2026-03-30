<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="com.driveschool.model.Instructor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Instructor List - DriveWise Academy</title>
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

        .nav-link {
            color: var(--text-color) !important;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
        }

        .nav-link.active {
            color: var(--primary-color) !important;
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

        .table {
            color: var(--text-color);
            margin-bottom: 0;
        }

        .table thead th {
            background-color: rgba(0, 0, 0, 0.2);
            color: var(--primary-color);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--primary-color);
        }

        .table tbody tr {
            transition: background-color 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        .table td, .table th {
            border-color: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            vertical-align: middle;
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
            <a href="scheduleLesson.jsp" class="nav-link">Schedule Lesson</a>
            <a href="viewInstructors01.jsp" class="nav-link active">Instructors</a>
            <a href="viewStudentLessons.jsp" class="nav-link">My Lessons</a>
            <a href="aboutyou.jsp" class="nav-link">About You</a>
            <a href="dashboard.jsp" class="nav-link">Back</a>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="card" data-aos="fade-up">
        <div class="card-header">
            <h2 class="m-0">Instructor List</h2>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Contact</th>
                        <th>Availability</th>
                        <th>Experience (Years)</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        FileUtil fileUtil = new FileUtil(application);
                        List<Instructor> instructors = new ArrayList<>(fileUtil.readInstructors());
                        for (int i = 0; i < instructors.size() - 1; i++) {
                            for (int j = 0; j < instructors.size() - i - 1; j++) {
                                if (instructors.get(j).getExperience() < instructors.get(j + 1).getExperience()) {
                                    Instructor temp = instructors.get(j);
                                    instructors.set(j, instructors.get(j + 1));
                                    instructors.set(j + 1, temp);
                                }
                            }
                        }
                        for (Instructor instructor : instructors) {
                    %>
                    <tr data-aos="fade-up" data-aos-delay="100">
                        <td><%= instructor.getName() %></td>
                        <td><%= instructor.getContact() %></td>
                        <td><%= instructor.getAvailability() %></td>
                        <td><%= instructor.getExperience() %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
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
