<%@ page import="com.driveschool.model.Student" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="java.util.List" %>

<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
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
  <title>About You - DriveWise Academy</title>
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

    .profile-info {
      padding: 2rem;
    }

    .profile-item {
      margin-bottom: 1.5rem;
      padding-bottom: 1.5rem;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .profile-item:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }

    .profile-label {
      color: var(--text-muted);
      font-size: 0.9rem;
      margin-bottom: 0.5rem;
    }

    .profile-value {
      color: var(--text-color);
      font-size: 1.1rem;
      font-weight: 500;
    }

    .btn-back, .btn-update {
      background-color: var(--primary-color);
      color: var(--secondary-color);
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: 25px;
      font-weight: 600;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
    }

    .btn-back:hover, .btn-update:hover {
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
      <a href="scheduleLesson.jsp" class="nav-link">Schedule Lesson</a>
      <a href="viewInstructors01.jsp" class="nav-link">Instructors</a>
      <a href="viewStudentLessons.jsp" class="nav-link">My Lessons</a>
      <a href="aboutyou.jsp" class="nav-link active">About You</a>
      <a href="dashboard.jsp" class="nav-link">Back</a>
    </div>
  </div>
</nav>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card" data-aos="fade-up">
        <div class="card-header">
          <h2 class="m-0">About You</h2>
        </div>
        <div class="profile-info">
          <div class="profile-item" data-aos="fade-up" data-aos-delay="100">
            <div class="profile-label">Username</div>
            <div class="profile-value"><%= student.getUsername() %></div>
          </div>
          <div class="profile-item" data-aos="fade-up" data-aos-delay="200">
            <div class="profile-label">Package Type</div>
            <div class="profile-value"><%= student.getUserType() %></div>
          </div>
          <div class="text-center mt-4" data-aos="fade-up" data-aos-delay="300">
            <a href="updateUserDetails.jsp?username=<%= student.getUsername() %>" class="btn-update">
              <i class="fas fa-edit me-2"></i>Update Profile
            </a>
          </div>
        </div>
      </div>

      <div class="text-center mt-4" data-aos="fade-up" data-aos-delay="300">
        <a href="dashboard.jsp" class="btn-back">
          <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
        </a>
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
