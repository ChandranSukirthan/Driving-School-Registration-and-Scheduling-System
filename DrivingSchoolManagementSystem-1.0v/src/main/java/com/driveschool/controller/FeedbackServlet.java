package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters
            String username = request.getParameter("username");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String type = request.getParameter("type");
            String rating = request.getParameter("rating");
            String message = request.getParameter("message");

            // Validate required fields
            if (username == null || name == null || email == null || type == null || rating == null || message == null ||
                    username.trim().isEmpty() || name.trim().isEmpty() || email.trim().isEmpty() ||
                    type.trim().isEmpty() || rating.trim().isEmpty() || message.trim().isEmpty()) {
                response.sendRedirect("Feedback.jsp?error=All fields are required");
                return;
            }

            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                response.sendRedirect("Feedback.jsp?error=Invalid email format");
                return;
            }

            // Validate rating
            try {
                int ratingValue = Integer.parseInt(rating);
                if (ratingValue < 1 || ratingValue > 5) {
                    response.sendRedirect("Feedback.jsp?error=Rating must be between 1 and 5");
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("Feedback.jsp?error=Invalid rating value");
                return;
            }

            // Save feedback
            FileUtil fileUtil = new FileUtil(getServletContext());
            fileUtil.saveFeedback(username, name, email, type, rating, message);

            // Redirect to the feedback review page with success message
            response.sendRedirect("userFeedback.jsp?success=true");

        } catch (Exception e) {
            // Log the error (you should implement proper logging)
            e.printStackTrace();
            response.sendRedirect("Feedback.jsp?error=An unexpected error occurred. Please try again.");
        }
    }
}