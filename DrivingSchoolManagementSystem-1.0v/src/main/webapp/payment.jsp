<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment - DriveWise Academy</title>
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

        .payment-container {
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
            padding: 1.5rem;
            text-align: center;
        }

        .card-header h2 {
            margin: 0;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .card-body {
            padding: 2rem;
        }

        .form-label {
            color: var(--text-muted);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--text-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
        }

        .form-control:focus, .form-select:focus {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: var(--primary-color);
            color: var(--text-color);
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.25);
        }

        .form-select option {
            background-color: var(--card-bg);
            color: var(--text-color);
        }

        .price-box {
            background: rgba(56, 176, 0, 0.1);
            border-left: 4px solid var(--success-color);
            padding: 1rem;
            border-radius: 8px;
            font-weight: 600;
            color: var(--success-color);
            margin: 1.5rem 0;
        }

        .payment-methods {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-check-input {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            color: var(--text-color);
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: var(--secondary-color);
            border: none;
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1.5rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .alert {
            background-color: rgba(228, 62, 49, 0.1);
            border: 1px solid var(--accent-color);
            color: var(--accent-color);
            border-radius: 8px;
            margin: 1rem 0;
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
            <a href="aboutyou.jsp" class="nav-link">About You</a>
            <a href="dashboard.jsp" class="nav-link">Back</a>
        </div>
    </div>
</nav>

<div class="container payment-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card" data-aos="fade-up">
                <div class="card-header">
                    <h2><i class="fas fa-lock me-2"></i>Secure Payment</h2>
                    <p class="mb-0">Complete your driving course registration</p>
                </div>

                <div class="card-body">
                    <form action="payment" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                        <div class="mb-4" data-aos="fade-up" data-aos-delay="100">
                            <label for="studentName" class="form-label">Full Name</label>
                            <input type="text" id="studentName" name="studentName" class="form-control" required>
                        </div>

                        <div class="mb-4" data-aos="fade-up" data-aos-delay="200">
                            <label for="vehicleType" class="form-label">Package</label>
                            <select class="form-select" id="vehicleType" name="vehicleType" onchange="updatePrice()" required>
                                <option value="">-- Select Package --</option>
                                <option value="Basic">Basic (Rs. 8000)</option>
                                <option value="Standard">Standard (Rs. 12000)</option>
                                <option value="Premium">Premium (Rs. 20000)</option>
                            </select>
                        </div>

                        <div class="mb-4" id="installmentDiv" style="display: none;" data-aos="fade-up" data-aos-delay="300">
                            <label for="paymentPlan" class="form-label">Payment Plan</label>
                            <select class="form-select" id="paymentPlan" name="paymentPlan" onchange="updateDisplayedAmount()">
                                <option value="full">Full Payment</option>
                                <option value="installment">Installments (2 months)</option>
                            </select>
                        </div>

                        <div class="price-box" id="priceDisplay" data-aos="fade-up" data-aos-delay="400">
                            Amount to Pay Now: Rs. 0
                        </div>
                        <input type="hidden" id="amount" name="amount" value="0">

                        <div class="payment-methods" data-aos="fade-up" data-aos-delay="500">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="cardPayment" value="card" checked>
                                <label class="form-check-label" for="cardPayment">
                                    <i class="fas fa-credit-card me-2"></i>Credit/Debit Card
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="depositPayment" value="deposit">
                                <label class="form-check-label" for="depositPayment">
                                    <i class="fas fa-university me-2"></i>Bank Deposit
                                </label>
                            </div>
                        </div>

                        <div id="cardDetails" style="display: none;" data-aos="fade-up" data-aos-delay="600">
                            <div class="mb-3">
                                <label for="cardHolder" class="form-label">Card Holder Name</label>
                                <input type="text" class="form-control" id="cardHolder" name="cardHolder" placeholder="John Doe">
                            </div>
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number</label>
                                <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456">
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="expiryDate" class="form-label">Expiry Date</label>
                                    <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="password" class="form-control" id="cvv" name="cvv" placeholder="123">
                                </div>
                            </div>
                        </div>

                        <div id="depositProof" style="display: none;" data-aos="fade-up" data-aos-delay="600">
                            <div class="mb-3">
                                <label for="depositReceipt" class="form-label">Upload Bank Deposit Receipt</label>
                                <input type="file" id="depositReceipt" name="depositReceipt" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                                <div class="form-text text-muted">Supported formats: PDF, JPG, JPEG, PNG (Max size: 5MB)</div>
                            </div>
                            <div class="mb-3">
                                <label for="transactionRef" class="form-label">Bank Transaction Reference</label>
                                <input type="text" id="transactionRef" name="transactionRef" class="form-control" placeholder="Enter bank transaction reference">
                            </div>
                        </div>

                        <button type="submit" class="btn-submit" data-aos="fade-up" data-aos-delay="700">
                            <i class="fas fa-paper-plane me-2"></i>Submit Payment
                        </button>
                    </form>
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

    let basePrice = 0;

    function updatePrice() {
        const vehicleType = document.getElementById("vehicleType").value;
        console.log("Selected package:", vehicleType);

        switch (vehicleType) {
            case "Basic":
                basePrice = 8000;
                break;
            case "Standard":
                basePrice = 12000;
                break;
            case "Premium":
                basePrice = 20000;
                break;
            default:
                basePrice = 0;
        }

        console.log("Base price set to:", basePrice);
        document.getElementById("installmentDiv").style.display = basePrice > 15000 ? "block" : "none";
        if (basePrice <= 15000) {
            document.getElementById("paymentPlan").value = "full";
        }
        updateDisplayedAmount();
    }

    function updateDisplayedAmount() {
        const plan = document.getElementById("paymentPlan").value;
        const finalAmount = (plan === "installment") ? basePrice / 2 : basePrice;
        console.log("Payment plan:", plan, "Final amount:", finalAmount);
        document.getElementById("priceDisplay").innerText = "Amount to Pay Now: Rs. " + finalAmount.toLocaleString();
        document.getElementById("amount").value = finalAmount.toString();
    }

    // Handle payment method toggle
    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.getElementById('cardDetails').style.display = this.value === 'card' ? 'block' : 'none';
            document.getElementById('depositProof').style.display = this.value === 'deposit' ? 'block' : 'none';

            // Toggle required fields
            const cardFields = ['cardHolder', 'cardNumber', 'expiryDate', 'cvv'];
            cardFields.forEach(field => {
                document.getElementById(field).required = this.value === 'card';
            });
            document.getElementById('depositReceipt').required = this.value === 'deposit';
        });
    });

    // Card number formatting
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
        if (value.length > 16) value = value.substr(0, 16);
        const parts = [];
        for (let i = 0; i < value.length; i += 4) {
            parts.push(value.substr(i, 4));
        }
        e.target.value = parts.join(' ');
    });

    // Expiry date formatting
    document.getElementById('expiryDate').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 4) value = value.substr(0, 4);
        if (value.length >= 2) {
            let month = parseInt(value.substr(0, 2));
            if (month > 12) month = 12;
            if (month < 1) month = 1;
            month = month.toString().padStart(2, '0');
            value = month + (value.length > 2 ? '/' + value.substr(2) : '');
        }
        e.target.value = value;
    });

    // Initialize form state
    window.addEventListener('load', function() {
        const cardPayment = document.getElementById('cardPayment');
        if (cardPayment.checked) {
            cardPayment.dispatchEvent(new Event('change'));
        }
    });

    // Form validation
    function validateForm() {
        const name = document.getElementById("studentName").value.trim();
        const package = document.getElementById("vehicleType").value;
        const method = document.querySelector('input[name="paymentMethod"]:checked').value;

        if (!name || !package) {
            alert("Please fill in all required fields.");
            return false;
        }

        if (method === "card") {
            const cardFields = ['cardHolder', 'cardNumber', 'expiryDate', 'cvv'];
            for (const field of cardFields) {
                if (!document.getElementById(field).value.trim()) {
                    alert("Please fill in all card details.");
                    return false;
                }
            }
        } else if (method === "deposit") {
            const receipt = document.getElementById("depositReceipt");
            if (!receipt.files.length) {
                alert("Please upload a bank deposit receipt.");
                return false;
            }

            const file = receipt.files[0];
            const fileSize = file.size / 1024 / 1024; // Convert to MB
            if (fileSize > 5) {
                alert("File size must be less than 5MB");
                return false;
            }

            const validTypes = ['application/pdf', 'image/jpeg', 'image/png'];
            if (!validTypes.includes(file.type)) {
                alert("Please upload a valid file (PDF, JPG, or PNG)");
                return false;
            }
        }

        return true;
    }
</script>
</body>
</html>