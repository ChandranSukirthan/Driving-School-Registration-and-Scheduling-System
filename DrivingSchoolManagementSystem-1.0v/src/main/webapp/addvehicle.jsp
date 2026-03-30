<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Vehicle - Driving School</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007BFF, #FFC107);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(10px);
        }

        .navbar .nav-link, .navbar-brand {
            color: #fff !important;
        }

        .form-container {
            max-width: 600px;
            margin: 60px auto;
            background-color: rgba(255, 255, 255, 0.2);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #fff;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #FFC107;
        }

        label {
            color: #fff;
        }

        .form-control,
        .form-select {
            background-color: rgb(204, 206, 212);
            border: 1px solid #2b2d30;
            color: #2b2d30;
        }

        .form-control::placeholder {
            color: #eee;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #ffc107;
            box-shadow: 0 0 5px #ffc107;
        }

        .btn-custom {
            background-color: #FFC107;
            color: #000;
            font-weight: bold;
            border: none;
        }

        .btn-custom:hover {
            background-color: #e0a800;
        }

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .form-footer {
            margin-top: 30px;
            text-align: center;
        }

        .form-footer a {
            margin: 0 10px;
            color: #fff;
            text-decoration: underline;
        }

        .form-footer a:hover {
            color: #ffc107;
        }

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.3);
            border: 1px solid #fff;
            color: #fff;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg px-3">
    <a class="navbar-brand" href="adminDashboard.jsp">Driving School Admin</a>
    <div class="collapse navbar-collapse">
        <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link" href="adminDashboard.jsp">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="LogoutServlet">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="form-container">
    <h2>Add New Vehicle</h2>

    <!-- Display Success/Error Message -->
    <%
        String message = (String) request.getAttribute("message");
        String messageType = (String) request.getAttribute("messageType");
        if (message != null) {
    %>
    <div class="message <%= messageType %>">
        <%= message %>
    </div>
    <% } %>

    <form action="AddVehicleServlet" method="post" onsubmit="formatVehicleId()">
        <div class="mb-3">
            <label for="vehicleIdNumber" class="form-label">Vehicle ID</label>
            <div class="input-group">
                <span class="input-group-text">ID</span>
                <input type="number" id="vehicleIdNumber" name="vehicleIdNumber" class="form-control" placeholder="Enter number" required min="1" step="1" oninput="validateVehicleId()">
                <input type="hidden" id="vehicleId" name="vehicleId">
            </div>
            <div id="vehicleIdError" class="text-danger mt-1" style="display: none;">Please enter a valid number.</div>
        </div>
        <div class="mb-3">
            <label for="vehicleType" class="form-label">Vehicle Type</label>
            <select id="vehicleType" name="vehicleType" class="form-select" required>
                <option value="" disabled selected>Select Vehicle Type</option>
                <option value="Car">Car</option>
                <option value="Bike">Bike</option>
                <option value="Van">Van</option>
                <option value="Three-Wheeler">Three-Wheeler</option>
                <option value="Tractor">Tractor</option>
                <option value="Bus">Bus</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="model" class="form-label">Model</label>
            <input type="text" id="model" name="model" class="form-control" placeholder="Enter model" required>
        </div>
        <div class="mb-3">
            <label for="year" class="form-label">Year</label>
            <input type="number" id="year" name="year" class="form-control" placeholder="Enter year" required min="1902" step="1" oninput="validateYear()">
            <div id="yearError" class="text-danger mt-1" style="display: none;">Year must be 1902 or later.</div>
        </div>
        <div class="mb-3">
            <label for="plateNumber" class="form-label">Plate Number</label>
            <input type="text" id="plateNumber" name="plateNumber" class="form-control" placeholder="Enter plate number" required>
        </div>
        <div class="mb-3">
            <label for="maintenanceStatus" class="form-label">Maintenance Status</label>
            <select id="maintenanceStatus" name="maintenanceStatus" class="form-select" required>
                <option value="" disabled selected>Select Maintenance Status</option>
                <option value="Good">Good</option>
                <option value="Needs Repair">Needs Repair</option>
                <option value="Under Maintenance">Under Maintenance</option>
                <option value="Out of Service">Out of Service</option>
            </select>
        </div>
        <button type="submit" class="btn btn-custom w-100">Add Vehicle</button>
        <a href="viewvehicle.jsp" class="btn btn-secondary w-100 mt-2">Cancel</a>
    </form>

    <div class="form-footer mt-4">
        <a href="adminDashboard.jsp">Home</a>
        <a href="manageUsers.jsp">Manage Users</a>
        <a href="viewInstructors.jsp">View Instructors</a>
        <a href="viewLessonRequests.jsp">Lesson Requests</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateYear() {
        const yearInput = document.getElementById('year');
        const yearError = document.getElementById('yearError');
        const year = parseInt(yearInput.value, 10);
        if (year < 1902 || isNaN(year)) {
            yearInput.setCustomValidity('Year must be 1902 or later.');
            yearError.style.display = 'block';
        } else {
            yearInput.setCustomValidity('');
            yearError.style.display = 'none';
        }
    }

    function validateVehicleId() {
        const vehicleIdInput = document.getElementById('vehicleIdNumber');
        const vehicleIdError = document.getElementById('vehicleIdError');
        const value = vehicleIdInput.value;
        if (!/^\d+$/.test(value) || parseInt(value) < 1) {
            vehicleIdInput.setCustomValidity('Please enter a valid number.');
            vehicleIdError.style.display = 'block';
        } else {
            vehicleIdInput.setCustomValidity('');
            vehicleIdError.style.display = 'none';
        }
    }

    function formatVehicleId() {
        const vehicleIdNumber = document.getElementById('vehicleIdNumber').value;
        const vehicleIdInput = document.getElementById('vehicleId');
        if (vehicleIdNumber && /^\d+$/.test(vehicleIdNumber)) {
            vehicleIdInput.value = 'ID' + vehicleIdNumber.padStart(3, '0');
        }
    }
</script>
</body>
</html>