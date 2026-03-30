package com.driveschool.controller;

import com.driveschool.model.Vehicle;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/AddVehicleServlet")
public class AddVehicleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("vehicleId");
        String vehicleType = req.getParameter("vehicleType");
        String model = req.getParameter("model");
        String year = req.getParameter("year");
        String plate = req.getParameter("plateNumber");
        String status = req.getParameter("maintenanceStatus");

        // Validate inputs
        if (id == null || id.trim().isEmpty() ||
                vehicleType == null || vehicleType.trim().isEmpty() ||
                model == null || model.trim().isEmpty() ||
                year == null || year.trim().isEmpty() ||
                plate == null || plate.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
            return;
        }

        // Validate year
        try {
            int yearNum = Integer.parseInt(year);
            if (yearNum < 1902) {
                req.setAttribute("error", "Year must be 1902 or later.");
                req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Year must be a valid number.");
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
            return;
        }

        // Validate vehicleType and maintenanceStatus
        String[] validTypes = {"Car", "Bike", "Van", "Three-Wheeler", "Tractor", "Bus"};
        String[] validStatuses = {"Good", "Needs Repair", "Under Maintenance", "Out of Service"};
        boolean validType = false;
        boolean validStatus = false;
        for (String type : validTypes) {
            if (type.equals(vehicleType)) {
                validType = true;
                break;
            }
        }
        for (String stat : validStatuses) {
            if (stat.equals(status)) {
                validStatus = true;
                break;
            }
        }
        if (!validType) {
            req.setAttribute("error", "Invalid vehicle type selected.");
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
            return;
        }
        if (!validStatus) {
            req.setAttribute("error", "Invalid maintenance status selected.");
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
            return;
        }

        // Add vehicle
        FileUtil util = new FileUtil(getServletContext());
        try {
            Vehicle vehicle = new Vehicle(id, vehicleType, model, year, plate, status);
            util.addVehicle(vehicle);
            resp.sendRedirect("viewvehicle.jsp");
        } catch (IOException e) {
            System.err.println("Error in AddVehicleServlet: " + e.getMessage());
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("Unexpected error in AddVehicleServlet: " + e.getMessage());
            req.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            req.getRequestDispatcher("addvehicle.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported.");
    }
}