package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/DeleteLessonServlet")
public class DeleteLessonServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get lesson parameters (assuming student username, instructor name, and lesson date)
        String studentUsername = request.getParameter("studentUsername");
        String instructorName = request.getParameter("instructorName");
        String lessonDate = request.getParameter("lessonDate");

        // Check if the lesson parameters are valid
        if (studentUsername != null && !studentUsername.trim().isEmpty() &&
                instructorName != null && !instructorName.trim().isEmpty() &&
                lessonDate != null && !lessonDate.trim().isEmpty()) {

            FileUtil fileUtil = new FileUtil(getServletContext());

            try {
                // Try deleting the lesson
                fileUtil.deleteLesson(studentUsername, instructorName, lessonDate);
                // Redirect with success message
                response.sendRedirect("viewStudentLessons.jsp?success=true");
            } catch (IOException e) {
                // Log the error and send a failure message
                e.printStackTrace();
                response.sendRedirect("viewStudentLessons.jsp?error=deletionFailed");
            }
        } else {
            // If the lesson parameters are invalid, redirect with error message
            response.sendRedirect("viewStudentLessons.jsp?error=invalidParameters");
        }
    }
}
