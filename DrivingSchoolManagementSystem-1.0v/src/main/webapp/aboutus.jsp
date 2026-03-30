<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About Us - DriveWise Academy</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body {
      background-color: #0b0b0b;
      color: #fff;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
    }

    /* Navbar */
    .navbar {
      background: transparent;
      transition: background 0.3s ease;
      position: fixed;
      width: 100%;
      z-index: 1000;
    }

    .navbar.scrolled {
      background: rgba(0, 0, 0, 0.9);
      backdrop-filter: blur(10px);
    }

    .navbar-brand {
      font-weight: bold;
      font-size: clamp(1.2rem, 3vw, 1.5rem);
      color: #f9c846 !important;
      letter-spacing: 1px;
      transition: color 0.3s ease;
    }

    .nav-link {
      color: #fff !important;
      font-size: clamp(0.9rem, 2.5vw, 1rem);
      font-weight: 500;
      transition: color 0.3s ease;
    }

    .nav-link:hover, .navbar-brand:hover {
      color: #e43e31 !important;
    }

    .nav-link.active {
      color: #e43e31 !important;
    }

    /* Hero Section */
    .hero {
      background: linear-gradient(to bottom right, rgba(0,0,0,0.6), rgba(0,0,0,0.4)),
      url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D') no-repeat center center/cover;
      min-height: 50vh;
      height: 100vh;
      max-height: 700px;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      flex-direction: column;
      padding: clamp(10px, 3vw, 15px);
      background-color: #333; /* Fallback */
    }

    .hero h1 {
      font-size: clamp(1.8rem, 5vw, 3rem);
      font-weight: 700;
      margin-bottom: 1rem;
      font-family: 'Courier New', Courier, monospace;
      white-space: nowrap;
      overflow: hidden;
      border-right: 3px solid;
      width: 0;
      animation: typing 2.5s steps(30) 1s forwards, blink 0.75s step-end infinite;
      max-width: 90%;
    }

    .hero p {
      font-size: clamp(0.9rem, 2.5vw, 1.1rem);
      margin-bottom: 1.5rem;
    }

    .btn-primary {
      background-color: #f9c846;
      border: none;
      color: #212529;
      padding: clamp(8px, 2vw, 10px) clamp(20px, 4vw, 24px);
      font-size: clamp(0.9rem, 2.5vw, 1rem);
      font-weight: 600;
      border-radius: 50px;
      transition: background-color 0.3s ease, transform 0.3s ease;
    }

    .btn-primary:hover {
      background-color: #e0ae30;
      color: #fff;
      transform: translateY(-2px);
    }

    /* Animations */
    @keyframes typing {
      from { width: 0; }
      to { width: 100%; }
    }

    @keyframes blink {
      50% { border-color: transparent; }
    }

    /* Section Styling */
    .section-title {
      font-size: clamp(1.5rem, 4vw, 2rem);
      font-weight: 700;
      letter-spacing: 1px;
      color: #f9c846;
      text-align: center;
      margin-bottom: 40px;
    }

    .card {
      background: #1a1a1a;
      color: #fff;
      border: 1px solid #2c2c2c;
      border-radius: 12px;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      height: 100%;
    }

    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
    }

    .card-title {
      font-size: clamp(1.1rem, 2.5vw, 1.3rem);
      font-weight: bold;
      color: #f9c846;
    }

    .card h6 {
      font-size: clamp(0.9rem, 2vw, 1rem);
      color: #e0e0e0;
    }

    .card ul {
      font-size: clamp(0.8rem, 2vw, 0.9rem);
      color: #ccc;
      padding-left: 20px;
    }

    .btn-outline-primary {
      border-color: #f9c846;
      color: #f9c846;
      font-size: clamp(0.8rem, 2vw, 0.9rem);
      border-radius: 50px;
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .btn-outline-primary:hover {
      background-color: #f9c846;
      color: #212529;
    }

    .btn-outline-success {
      border-color: #28a745;
      color: #28a745;
      font-size: clamp(0.8rem, 2vw, 0.9rem);
      border-radius: 50px;
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .btn-outline-success:hover {
      background-color: #28a745;
      color: #fff;
    }

    .btn-outline-danger {
      border-color: #e43e31;
      color: #e43e31;
      font-size: clamp(0.8rem, 2vw, 0.9rem);
      border-radius: 50px;
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .btn-outline-danger:hover {
      background-color: #e43e31;
      color: #fff;
    }

    /* About Section */
    .about-section {
      padding: 80px 0;
      background: #0b0b0b;
    }

    .about-section p {
      font-size: clamp(0.9rem, 2.5vw, 1.1rem);
      color: #ccc;
      max-width: 800px;
      margin: 0 auto;
    }

    /* Packages Section */
    .packages-section {
      padding: 80px 0;
      background: #111;
    }

    /* Map Section */
    .map-section {
      padding: 80px 0;
      background: #1a1a1a;
    }

    #map {
      height: clamp(200px, 40vw, 300px);
      width: 100%;
      border-radius: 10px;
      border: 2px solid #f9c846;
    }

    /* Media Queries */
    @media (max-width: 576px) {
      .hero {
        min-height: 40vh;
        padding: 10px;
      }
      .hero h1 {
        font-size: clamp(1.5rem, 6vw, 2rem);
      }
      .hero p {
        font-size: clamp(0.8rem, 3vw, 0.9rem);
      }
      .section-title {
        font-size: clamp(1.2rem, 4vw, 1.5rem);
      }
      .card-body {
        padding: 15px;
      }
      .about-section, .packages-section, .map-section {
        padding: 40px 10px;
      }
    }

    @media (min-width: 1200px) {
      .hero h1 {
        font-size: 3.5rem;
      }
      .hero p {
        font-size: 1.25rem;
      }
      .section-title {
        font-size: 2.5rem;
      }
    }
  </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg fixed-top">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">DriveWise Academy</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
        <li class="nav-item"><a class="nav-link active" href="aboutus.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a></li>
        <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Register/Login</a></li>

      </ul>
    </div>
  </div>
</nav>

<!-- Hero Section -->
<div class="hero" data-aos="fade-up" data-aos-delay="200">
  <h1 class="display-4 animate-typing" data-aos="fade-up" data-aos-delay="400">Welcome to DriveWise Academy</h1>
  <p class="lead" data-aos="fade-up" data-aos-delay="600">Your premium partner in mastering the road with confidence and precision.</p>
  <a href="login.jsp" class="btn btn-primary btn-lg" data-aos="fade-up" data-aos-delay="800">Get Started</a>
</div>

<!-- About Section -->
<section class="about-section text-center" data-aos="fade-up">
  <div class="container">
    <h2 class="section-title text-uppercase">About DriveWise Academy</h2>
    <p data-aos="fade-up" data-aos-delay="200">At DriveWise Academy, we are committed to providing top-tier driver education with a focus on safety, confidence, and precision. Our certified instructors bring years of experience to guide learners at every level, from beginners to advanced drivers. With flexible schedules, comprehensive packages, and a passion for road safety, we empower our students to navigate the roads with ease.</p>
  </div>
</section>

<!-- Packages Section -->
<section class="packages-section" data-aos="fade-up">
  <div class="container">
    <h2 class="section-title">Choose Your Package</h2>
    <div class="row g-4">
      <!-- Basic -->
      <div class="col-12 col-md-4" data-aos="fade-up" data-aos-delay="100">
        <div class="card h-100">
          <div class="card-body d-flex flex-column justify-content-between">
            <div>
              <h5 class="card-title">Basic Package</h5>
              <h6 class="mb-3">RS.8000</h6>
              <ul class="mb-4">
                <li>10 Hours of Driving Lessons</li>
                <li>Basic Theory Classes</li>
                <li>Learning Materials</li>
                <li>Practice Tests</li>
              </ul>
            </div>
            <a href="login.jsp" class="btn btn-outline-primary w-100">Book Now</a>
          </div>
        </div>
      </div>
      <!-- Standard -->
      <div class="col-12 col-md-4" data-aos="fade-up" data-aos-delay="200">
        <div class="card h-100">
          <div class="card-body d-flex flex-column justify-content-between">
            <div>
              <h5 class="card-title">Standard Package</h5>
              <h6 class="mb-3">RS.12000</h6>
              <ul class="mb-4">
                <li>20 Hours of Driving Lessons</li>
                <li>Comprehensive Theory Classes</li>
                <li>Premium Learning Materials</li>
                <li>Unlimited Practice Tests</li>
                <li>Mock Driving Test</li>
              </ul>
            </div>
            <a href="login.jsp" class="btn btn-outline-success w-100">Book Now</a>
          </div>
        </div>
      </div>
      <!-- Premium -->
      <div class="col-12 col-md-4" data-aos="fade-up" data-aos-delay="300">
        <div class="card h-100">
          <div class="card-body d-flex flex-column justify-content-between">
            <div>
              <h5 class="card-title">Premium Package</h5>
              <h6 class="mb-3">RS.20000</h6>
              <ul class="mb-4">
                <li>30 Hours of Driving Lessons</li>
                <li>Advanced Theory Classes</li>
                <li>Unlimited Practice Tests</li>
                <li>2 Mock Tests</li>
                <li>Flexible Scheduling</li>
              </ul>
            </div>
            <a href="login.jsp" class="btn btn-outline-danger w-100">Book Now</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Map Section -->
<section class="map-section" data-aos="fade-up">
  <div class="container">
    <h3 class="section-title mb-4">Find Us On The Map</h3>
    <div id="map" data-aos="zoom-in" data-aos-delay="200"></div>
  </div>
</section>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
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

  // Initialize Leaflet map
  var map = L.map('map').setView([6.9271, 79.8612], 15);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  L.marker([6.9271, 79.8612]).addTo(map)
          .bindPopup('DriveWise Academy')
          .openPopup();
</script>
</body>
</html>