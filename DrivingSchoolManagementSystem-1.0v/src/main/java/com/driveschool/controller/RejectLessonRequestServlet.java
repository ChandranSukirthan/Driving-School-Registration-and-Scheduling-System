package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RejectLessonRequestServlet")
public class RejectLessonRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestDetails = request.getParameter("request");

        if (requestDetails != null && !requestDetails.trim().isEmpty()) {
            FileUtil fileUtil = new FileUtil(getServletContext());

            try {
                // Remove the lesson request
                fileUtil.removeLessonRequest(requestDetails);

                // Redirect with success status
                response.sendRedirect("viewLessonRequests.jsp?status=rejected");
            } catch (IOException e) {
                e.printStackTrace();
                response.sendRedirect("viewLessonRequests.jsp?error=rejectFailed");
            }
        } else {
            response.sendRedirect("viewLessonRequests.jsp?error=invalidRequest");
        }
    }
}
