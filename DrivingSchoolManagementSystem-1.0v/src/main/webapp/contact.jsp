<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact Us - DriveWise Academy</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #2b2d30;
      color: #fff;
      overflow-x: hidden;
      padding-top: 70px; /* Offset for fixed navbar */
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
      color: #fff !important;
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
      height: 60vh;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      flex-direction: column;
      background: linear-gradient(to bottom, rgba(0,0,0,0.4), rgba(0,0,0,0.6)),
      url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D') no-repeat center center/cover;
      overflow: hidden;
    }

    .hero h1 {
      font-size: 3.5rem;
      font-weight: 900;
      margin-bottom: 15px;
    }

    .hero p {
      font-size: 1.3rem;
      max-width: 600px;
    }

    /* Map and Contact Section */
    .map-contact-section {
      padding: 80px 0;
      background: #1a1a1a;
    }

    #map {
      height: 400px;
      border-radius: 16px;
      border: 2px solid #e43e31;
    }

    .contact-card .card {
      background: #2b2d30;
      border: none;
      border-radius: 16px;
      padding: 30px;
      text-align: center;
      height: 100%;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .contact-card .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
    }

    .contact-card h3 {
      color: #fff;
      margin-bottom: 20px;
    }

    .contact-card p {
      margin: 10px 0;
      font-size: 1.1rem;
      color: #fff;
    }

    .contact-card a {
      color: #e43e31 !important;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .contact-card a:hover {
      color: #f7c645 !important;
    }

    .contact-card strong {
      color: #fff;
    }

    /* Social Media */
    .social-media {
      text-align: center;
      padding: 60px 0;
      background: #2b2d30;
    }

    .social-media a {
      color: #fff;
      font-size: 2rem;
      margin: 0 15px;
      transition: color 0.3s ease, transform 0.3s ease;
    }

    .social-media a:hover {
      color: #e43e31;
      transform: scale(1.2);
    }

    /* FAQ Section */
    .faq-section {
      padding: 80px 0;
      background: #2b2d30;
      text-align: center;
    }

    .faq-section h2 {
      font-size: 2.5rem;
      font-weight: 800;
      margin-bottom: 40px;
    }

    .faq-section .accordion {
      max-width: 800px;
      margin: 0 auto;
    }

    .accordion-item {
      background: #2b2d30;
      border: none;
      margin-bottom: 15px;
      border-radius: 8px;
    }

    .accordion-button {
      background: #2b2d30;
      color: #fff;
      font-weight: 600;
      border-radius: 8px;
      text-align: left;
      transition: background-color 0.3s ease;
    }

    .accordion-button:not(.collapsed) {
      background: #e43e31;
      color: #fff;
    }

    .accordion-body {
      color: #aaa;
      text-align: left;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .hero h1 {
        font-size: 2.5rem;
      }
      .hero p {
        font-size: 1.1rem;
        padding: 0 20px;
      }
      #map {
        height: 300px;
      }
      .contact-card .card {
        padding: 20px;
      }
      .map-contact-section, .social-media, .faq-section {
        padding: 40px 0;
      }
      body {
        padding-top: 60px; /* Smaller offset for mobile */
      }
    }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="#">DriveWise Academy</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
        <li class="nav-item"><a class="nav-link" href="aboutus.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
        <li class="nav-item"><a class="nav-link active" href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a></li>
        <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Register/Login</a></li>

      </ul>
    </div>
  </div>
</nav>

<div class="hero" data-aos="fade-down" data-aos-delay="200">
  <h1 data-aos="fade-up" data-aos-delay="400">Get in Touch</h1>
  <p data-aos="fade-up" data-aos-delay="600">We're here to answer your questions and help you start your driving journey.</p>
</div>

<div class="map-contact-section" data-aos="fade-up">
  <div class="container">
    <div class="row g-4">
      <div class="col-md-6" data-aos="fade-left" data-aos-delay="100">
        <div id="map"></div>
      </div>
      <div class="col-md-6 contact-card" data-aos="fade-right" data-aos-delay="200">
        <div class="card">
          <h3 data-aos="fade-up" data-aos-delay="300">Contact Details</h3>
          <p data-aos="fade-up" data-aos-delay="400"><strong>Email:</strong> <a href="mailto:info@drivewiseacademy.com">info@drivewiseacademy.com</a></p>
          <p data-aos="fade-up" data-aos-delay="500"><strong>Phone:</strong> <a href="tel:+1234567890">+1 (234) 567-890</a></p>
          <p data-aos="fade-up" data-aos-delay="600"><strong>Address:</strong> 123 Driving Lane, Auto City, AC 12345</p>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="social-media" data-aos="fade-up">
  <h3 data-aos="fade-up" data-aos-delay="100">Follow Us</h3>
  <div data-aos="zoom-in" data-aos-delay="200">
    <a href="https://facebook.com" target="_blank"><i class="bi bi-facebook"></i></a>
    <a href="https://twitter.com" target="_blank"><i class="bi bi-twitter-x"></i></a>
    <a href="https://instagram.com" target="_blank"><i class="bi bi-instagram"></i></a>
    <a href="https://linkedin.com" target="_blank"><i class="bi bi-linkedin"></i></a>
  </div>
</div>

<div class="faq-section" data-aos="fade-up">
  <h2 data-aos="fade-up" data-aos-delay="100">Frequently Asked Questions</h2>
  <div class="accordion" id="faqAccordion">
    <div class="accordion-item" data-aos="fade-up" data-aos-delay="200">
      <h2 class="accordion-header" id="faq1">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapse1" aria-expanded="true" aria-controls="collapse1">
          How do I book a driving lesson?
        </button>
      </h2>
      <div id="collapse1" class="accordion-collapse collapse show" aria-labelledby="faq1" data-bs-parent="#faqAccordion">
        <div class="accordion-body">
          You can book a lesson by registering on our website and selecting a time slot that suits you. Our flexible scheduling system allows you to choose from available instructors.
        </div>
      </div>
    </div>
    <div class="accordion-item" data-aos="fade-up" data-aos-delay="300">
      <h2 class="accordion-header" id="faq2">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse2" aria-expanded="false" aria-controls="collapse2">
          What are the payment options?
        </button>
      </h2>
      <div id="collapse2" class="accordion-collapse collapse" aria-labelledby="faq2" data-bs-parent="#faqAccordion">
        <div class="accordion-body">
          We accept credit/debit cards, PayPal, and bank transfers. Payment plans are available for our comprehensive packages.
        </div>
      </div>
    </div>
    <div class="accordion-item" data-aos="fade-up" data-aos-delay="400">
      <h2 class="accordion-header" id="faq3">
        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse3" aria-expanded="false" aria-controls="collapse3">
          Do you offer lessons for beginners?
        </button>
      </h2>
      <div id="collapse3" class="accordion-collapse collapse" aria-labelledby="faq3" data-bs-parent="#faqAccordion">
        <div class="accordion-body">
          Yes, we specialize in beginner-friendly lessons with patient, certified instructors to help you build confidence behind the wheel.
        </div>
      </div>
    </div>
  </div>
</div>

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