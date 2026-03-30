package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/EditFeedbackServlet")
public class EditFeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String currentUser = (String) request.getSession().getAttribute("username");
        String type = request.getParameter("type");
        String rating = request.getParameter("rating");
        String message = request.getParameter("message");

        // Security check: ensure users can only edit their own feedback
        if (!username.equals(currentUser)) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("You can only edit your own feedback.", StandardCharsets.UTF_8));
            return;
        }

        // Validate input
        if (username == null || username.trim().isEmpty() ||
            type == null || type.trim().isEmpty() ||
            rating == null || rating.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("All fields are required.", StandardCharsets.UTF_8));
            return;
        }

        // Validate rating
        try {
            int ratingValue = Integer.parseInt(rating);
            if (ratingValue < 1 || ratingValue > 5) {
                response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Rating must be between 1 and 5", StandardCharsets.UTF_8));
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Invalid rating value", StandardCharsets.UTF_8));
            return;
        }

        try {
            FileUtil fileUtil = new FileUtil(getServletContext());
            List<String[]> feedbackList = fileUtil.readFeedback();
            boolean found = false;

            // Find and update the feedback
            for (int i = 0; i < feedbackList.size(); i++) {
                String[] feedback = feedbackList.get(i);
                if (feedback[0].equals(username)) {
                    // Update the feedback while preserving name and email
                    String[] updatedFeedback = new String[7];
                    updatedFeedback[0] = feedback[0]; // username
                    updatedFeedback[1] = feedback[1]; // name
                    updatedFeedback[2] = feedback[2]; // email
                    updatedFeedback[3] = type;
                    updatedFeedback[4] = rating;
                    updatedFeedback[5] = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
                    updatedFeedback[6] = message.replace(",", ";");
                    feedbackList.set(i, updatedFeedback);
                    found = true;
                    break;
                }
            }

            if (!found) {
                response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Feedback not found.", StandardCharsets.UTF_8));
                return;
            }

            // Save the updated feedback list
            fileUtil.writeFeedback(feedbackList);
            response.sendRedirect("userFeedback.jsp?success=" + URLEncoder.encode("Feedback updated successfully!", StandardCharsets.UTF_8));

        } catch (Exception e) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Error updating feedback: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
