package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/DeleteInstructorServlet")
public class DeleteInstructorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve instructor name from the request
        String instructorName = request.getParameter("name");

        // Check if the instructor name is valid
        if (instructorName != null && !instructorName.trim().isEmpty()) {
            FileUtil fileUtil = new FileUtil(getServletContext());

            try {
                // Attempt to delete the instructor
                fileUtil.deleteInstructor(instructorName);

                // Redirect with success message
                response.sendRedirect("viewInstructors.jsp?success=true");
            } catch (IOException e) {
                // Log the error (you could use a logging framework)
                e.printStackTrace();

                // Redirect with error message
                response.sendRedirect("viewInstructors.jsp?error=deletionFailed");
            }
        } else {
            // If name is invalid, redirect with error
            response.sendRedirect("viewInstructors.jsp?error=invalidName");
        }
    }
}
