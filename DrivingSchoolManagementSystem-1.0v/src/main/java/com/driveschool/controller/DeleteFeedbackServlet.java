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
import java.util.List;
import java.util.ArrayList;

@WebServlet("/DeleteFeedbackServlet")
    
public class DeleteFeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String currentUser = (String) request.getSession().getAttribute("username");

        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Username is required.", StandardCharsets.UTF_8));
            return;
        }

        // Security check: ensure users can only delete their own feedback
        if (!username.equals(currentUser)) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("You can only delete your own feedback.", StandardCharsets.UTF_8));
            return;
        }

        try {
            FileUtil fileUtil = new FileUtil(getServletContext());
            List<String[]> feedbackList = fileUtil.readFeedback();
            List<String[]> updatedList = new ArrayList<>();
            boolean found = false;

            for (String[] feedback : feedbackList) {
                if (!feedback[0].equals(username)) {
                    updatedList.add(feedback);
                } else {
                    found = true;
                }
            }

            if (!found) {
                response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Feedback not found.", StandardCharsets.UTF_8));
                return;
            }

            fileUtil.writeFeedback(updatedList);
            response.sendRedirect("userFeedback.jsp?success=" + URLEncoder.encode("Feedback deleted successfully!", StandardCharsets.UTF_8));

        } catch (Exception e) {
            response.sendRedirect("userFeedback.jsp?error=" + URLEncoder.encode("Error deleting feedback: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
