package com.driveschool.controller;

import com.driveschool.model.Instructor;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/UpdateInstructorServlet")
public class UpdateInstructorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("viewInstructors.jsp?error=" + 
                URLEncoder.encode("Instructor name is required.", StandardCharsets.UTF_8));
            return;
        }

        FileUtil fileUtil = new FileUtil(getServletContext());
        Instructor instructor = findInstructorByName(fileUtil.readInstructors(), name);
        
        if (instructor == null) {
            response.sendRedirect("viewInstructors.jsp?error=" + 
                URLEncoder.encode("Instructor not found.", StandardCharsets.UTF_8));
            return;
        }

        request.setAttribute("instructor", instructor);
        request.getRequestDispatcher("updateInstructor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters
            String name = request.getParameter("name");
            String contact = request.getParameter("contact");
            String availability = request.getParameter("availability");
            String experienceStr = request.getParameter("experience");

            // Validate required fields
            if (isNullOrEmpty(name, availability, experienceStr)) {
                sendError(response, "Name, availability and experience are required.");
                return;
            }

            // Validate experience
            int experience;
            try {
                experience = Integer.parseInt(experienceStr);
                if (experience < 0 || experience > 50) {
                    sendError(response, "Experience must be between 0 and 50 years.");
                    return;
                }
            } catch (NumberFormatException e) {
                sendError(response, "Invalid experience format.");
                return;
            }

            FileUtil fileUtil = new FileUtil(getServletContext());
            List<Instructor> instructors = fileUtil.readInstructors();
            Instructor existingInstructor = findInstructorByName(instructors, name);

            if (existingInstructor == null) {
                sendError(response, "Instructor not found: " + name);
                return;
            }

            // Update instructor
            existingInstructor.setContact(contact);
            existingInstructor.setAvailability(availability);
            existingInstructor.setExperience(experience);

            fileUtil.updateInstructor(existingInstructor);
            
            response.sendRedirect("viewInstructors.jsp?success=" + 
                URLEncoder.encode("Instructor updated successfully!", StandardCharsets.UTF_8));

        } catch (Exception e) {
            log("Error updating instructor", e);
            sendError(response, "System error: " + e.getMessage());
        }
    }

    private boolean isNullOrEmpty(String... values) {
        for (String value : values) {
            if (value == null || value.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.sendRedirect("viewInstructors.jsp?error=" + 
            URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private Instructor findInstructorByName(List<Instructor> instructors, String name) {
        if (instructors == null || name == null) {
            return null;
        }
        return instructors.stream()
                .filter(i -> name.equals(i.getName()))
                .findFirst()
                .orElse(null);
    }
}