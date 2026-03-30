<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DriveWise Academy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #000;
            color: #fff;
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
            background: linear-gradient(to bottom right, rgba(0,0,0,0.6), rgba(0,0,0,0.4)),
            url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D') no-repeat center center/cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            flex-direction: column;
            padding: 0 15px;
            box-shadow: inset 0 0 50px rgba(0,0,0,0.4);
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 900;
            color: #fff;
            font-family: 'Courier New', Courier, monospace;
            white-space: nowrap;
            overflow: hidden;
            border-right: 4px solid;
            width: 0;
            animation: typing 3s steps(30) 1s forwards, blink 0.75s step-end infinite;
        }

        .hero p {
            font-size: 1.25rem;
            margin-bottom: 30px;
            color: #fff;
        }

        .btn-primary {
            background-color: #e43e31;
            border: none;
            color: #fff;
            padding: 12px 28px;
            font-weight: 600;
            border-radius: 50px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #f7c645;
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

        /* Features Section */
        .features {
            padding: 80px 0;
            background: #1a1a1a;
        }

        .features h2 {
            font-size: 2.5rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 40px;
            color: #fff;
        }

        .feature-card {
            background: #2b2d30;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .feature-card svg {
            width: 40px;
            height: 40px;
            fill: #fff;
            background: #e43e31;
            padding: 8px;
            border-radius: 50%;
            margin-bottom: 20px;
        }

        .feature-card h5 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #fff;
        }

        .feature-card p {
            font-size: 1rem;
            color: #aaa;
        }

        /* Testimonials Section */
        .testimonials {
            padding: 80px 0;
            background: #000;
        }

        .testimonials h2 {
            font-size: 2.5rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 40px;
        }

        .testimonial-card {
            background: #2b2d30;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            color: #aaa;
            height: 100%;
        }

        .testimonial-card p {
            font-style: italic;
            margin-bottom: 20px;
        }

        .testimonial-card h6 {
            font-size: 1.2rem;
            color: #fff;
            margin: 0;
        }

        /* Instructors Section */
        .instructors {
            padding: 80px 0;
            background: #1a1a1a;
        }

        .instructors h2 {
            font-size: 2.5rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 40px;
        }

        .instructor-card {
            background: #2b2d30;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease;
            height: 100%;
        }

        .instructor-card:hover {
            transform: translateY(-10px);
        }

        .instructor-card img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-bottom: 20px;
            object-fit: cover;
        }

        .instructor-card h5 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #fff;
        }

        .instructor-card p {
            font-size: 1rem;
            color: #aaa;
        }

        /* CTA Section */
        .cta {
            padding: 60px 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.8), rgba(0,0,0,0.9));
            text-align: center;
        }

        .cta h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .cta p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #aaa;
        }

        /* Footer */
        .footer {
            padding: 40px 0;
            background: #2b2d30;
            text-align: center;
        }

        .footer a {
            color: #e43e31;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer a:hover {
            color: #f7c645;
        }

        .footer .social a {
            font-size: 1.8rem;
            margin: 0 10px;
            color: #fff;
        }

        .footer .social a:hover {
            color: #e43e31;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.5rem;
            }
            .hero p {
                font-size: 1.1rem;
            }
            .features h2, .testimonials h2, .instructors h2, .cta h2 {
                font-size: 2rem;
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
                <li class="nav-item"><a class="nav-link active" href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li class="nav-item"><a class="nav-link" href="aboutus.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
                <li class="nav-item"><a class="nav-link" href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Register/Login</a></li>

            </ul>
        </div>
    </div>
</nav>

<div class="hero" data-aos="zoom-out" data-aos-delay="200">
    <h1 data-aos="fade-up" data-aos-delay="500">Start Your Driving Journey Today</h1>
    <p data-aos="fade-up" data-aos-delay="700">Professional instructors, flexible schedules, and comprehensive learning packages</p>
    <a href="login.jsp" class="btn btn-primary btn-lg" data-aos="fade-up" data-aos-delay="900">Get Started</a>
</div>

<div class="features" data-aos="fade-up">
    <h2>Why Choose Us?</h2>
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-card">
                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-person-check-fill" viewBox="0 0 16 16">
                        <path d="M15.854 5.146a.5.5 0 0 0-.708-.708l-3 3-.647-.646a.5.5 0 0 0-.708.708l1 1a.5.5 0 0 0 .708 0l3.5-3.5z"/>
                        <path d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                    </svg>
                    <h5>Expert Instructors</h5>
                    <p>Learn from certified professionals with years of experience.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-card">
                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-clock-fill" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM7.5 4a.5.5 0 0 0-1 0v4a.5.5 0 0 0 .25.43l3 1.5a.5.5 0 0 0 .5-.86L7.5 7.7V4z"/>
                    </svg>
                    <h5>Flexible Schedule</h5>
                    <p>Book lessons at your convenience.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-card">
                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-box-seam-fill" viewBox="0 0 16 16">
                        <path d="M0.5 3.5v8.661l6.857 3.429V6.95L0.5 3.5zM8.643 15.59 15.5 12.16V3.5l-6.857 3.45v8.64zM1.07 2.788 8 6.5l6.93-3.712L8 0 .07 2.788z"/>
                    </svg>
                    <h5>Custom Packages</h5>
                    <p>Choose from Basic, Standard, or Premium packages.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="testimonials" data-aos="fade-up">
    <h2>What Our Students Say</h2>
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4" data-aos="fade-left" data-aos-delay="100">
                <div class="testimonial-card">
                    <p>"DriveWise made learning to drive so easy! The instructors are patient and professional."</p>
                    <h6>Sarah M.</h6>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                <div class="testimonial-card">
                    <p>"Flexible scheduling was a game-changer for me. Highly recommend their premium package!"</p>
                    <h6>James T.</h6>
                </div>
            </div>
            <div class="col-md-4" data-aos="fade-right" data-aos-delay="300">
                <div class="testimonial-card">
                    <p>"I passed my driving test on the first try thanks to DriveWise's expert guidance."</p>
                    <h6>Emily R.</h6>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="instructors" data-aos="fade-up">
    <h2>Meet Our Expert Instructors</h2>
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4" data-aos="zoom-in" data-aos-delay="100">
                <div class="instructor-card">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e" alt="Instructor">
                    <h5>John Doe</h5>
                    <p>10+ years of teaching experience, specializing in beginner drivers.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="zoom-in" data-aos-delay="200">
                <div class="instructor-card">
                    <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330" alt="Instructor">
                    <h5>Jane Smith</h5>
                    <p>Expert in defensive driving techniques with a 95% pass rate.</p>
                </div>
            </div>
            <div class="col-md-4" data-aos="zoom-in" data-aos-delay="300">
                <div class="instructor-card">
                    <img src="https://demo-source.imgix.net/bucket_hat.jpg" alt="Instructor">
                    <h5>Mike Brown</h5>
                    <p>Certified instructor with a focus on advanced driving skills.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="cta" data-aos="fade-up">
    <h2>Ready to Hit the Road?</h2>
    <p>Join DriveWise Academy today and start your driving journey with confidence.</p>
    <a href="login.jsp" class="btn btn-primary btn-lg" data-aos="zoom-in" data-aos-delay="200">Sign Up Now</a>
</div>

<div class="footer" data-aos="fade-up">
    <p><a href="mailto:info@drivewiseacademy.com">info@drivewiseacademy.com</a> | <a href="tel:+1234567890">+1 (234) 567-890</a></p>
    <p>123 Driving Lane, Auto City, AC 12345</p>
    <div class="social">
        <a href="https://facebook.com" target="_blank"><i class="bi bi-facebook"></i></a>
        <a href="https://twitter.com" target="_blank"><i class="bi bi-twitter-x"></i></a>
        <a href="https://instagram.com" target="_blank"><i class="bi bi-instagram"></i></a>
        <a href="https://linkedin.com" target="_blank"><i class="bi bi-linkedin"></i></a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
<script>
    AOS.init({ duration: 1000, once: true });

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