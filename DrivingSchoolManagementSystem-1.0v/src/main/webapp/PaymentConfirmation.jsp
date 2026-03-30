<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Receipt - DriveWise Academy</title>
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
            --success-color: #38b000;
        }

        body {
            background-color: var(--secondary-color);
            color: var(--text-color);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-height: 100vh;
            line-height: 1.6;
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

        .receipt-container {
            padding: 2rem;
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
            padding: 2rem;
            text-align: center;
        }

        .success-icon {
            font-size: 3rem;
            color: var(--success-color);
            margin-bottom: 1rem;
        }

        .receipt-details {
            border: 2px dashed rgba(255, 255, 255, 0.1);
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            background: rgba(255, 255, 255, 0.05);
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px dotted rgba(255, 255, 255, 0.1);
        }

        .receipt-row:last-child {
            border-bottom: none;
        }

        .receipt-label {
            color: var(--text-muted);
            font-weight: 500;
        }

        .receipt-value {
            color: var(--text-color);
            font-weight: 600;
            text-align: right;
        }

        .receipt-total {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid rgba(255, 255, 255, 0.1);
            font-size: 1.2rem;
        }

        .receipt-footer {
            text-align: center;
            margin-top: 2rem;
            color: var(--text-muted);
        }

        .btn-print {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: var(--secondary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 1rem;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        @media print {
            body {
                background: white;
                color: black;
            }
            .card {
                box-shadow: none;
                border: 1px solid #ddd;
            }
            .btn-print {
                display: none;
            }
            .receipt-details {
                border: 2px dashed #ddd;
            }
            .receipt-row {
                border-bottom: 1px dotted #ddd;
            }
            .receipt-total {
                border-top: 2px solid #ddd;
            }
        }
    </style>
</head>
<body>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
    String currentDate = sdf.format(new Date());
    String transactionId = String.format("TXN%d", System.currentTimeMillis());
%>

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
            <a href="aboutyou.jsp" class="nav-link">About You</a>
            <a href="dashboard.jsp" class="nav-link">Back</a>
        </div>
    </div>
</nav>

<div class="container receipt-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card" data-aos="fade-up">
                <div class="card-header">
                    <i class="fas fa-check-circle success-icon"></i>
                    <h2 class="mb-2">Payment Successful</h2>
                    <p class="mb-0">Thank you for choosing our driving school!</p>
                </div>

                <div class="card-body p-4">
                    <div class="receipt-details" data-aos="fade-up" data-aos-delay="100">
                        <div class="receipt-row">
                            <span class="receipt-label">Transaction ID:</span>
                            <span class="receipt-value"><%= transactionId %></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Date & Time:</span>
                            <span class="receipt-value"><%= currentDate %></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Student Name:</span>
                            <span class="receipt-value"><%= session.getAttribute("studentName") != null ? session.getAttribute("studentName") : "Not provided" %></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Course Package:</span>
                            <span class="receipt-value"><%= session.getAttribute("vehicleType") != null ? session.getAttribute("vehicleType") : "Not selected" %></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Payment Plan:</span>
                            <span class="receipt-value"><%= session.getAttribute("paymentPlan") != null ? session.getAttribute("paymentPlan") : "Full Payment" %></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Payment Method:</span>
                            <span class="receipt-value"><%= session.getAttribute("paymentMethod") != null ? session.getAttribute("paymentMethod").toString().substring(0, 1).toUpperCase() + session.getAttribute("paymentMethod").toString().substring(1) : "Not specified" %></span>
                        </div>
                        <div class="receipt-row receipt-total">
                            <span class="receipt-label">Total Amount:</span>
                            <span class="receipt-value">Rs. <%= session.getAttribute("amount") != null ? session.getAttribute("amount") : "0" %></span>
                        </div>
                    </div>

                    <div class="receipt-footer" data-aos="fade-up" data-aos-delay="200">
                        <p class="mb-2">A copy of this receipt has been saved as: <%= session.getAttribute("receiptFileName") != null ? session.getAttribute("receiptFileName") : "Not generated" %></p>
                        <p class="mb-3">For any queries, please contact our support team.</p>
                        <button onclick="window.print()" class="btn-print">
                            <i class="fas fa-print me-2"></i>Print Receipt
                        </button>
                    </div>
                </div>
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