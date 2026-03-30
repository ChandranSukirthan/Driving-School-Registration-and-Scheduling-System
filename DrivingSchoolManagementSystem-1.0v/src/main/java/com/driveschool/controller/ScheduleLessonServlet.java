package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ScheduleLessonServlet")
public class ScheduleLessonServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentUsername = (String) request.getSession().getAttribute("username");
        String instructorName = request.getParameter("instructorName");
        String date = request.getParameter("date");

        // Create lesson request string
        String requestData = studentUsername + "," + instructorName + "," + date;

        FileUtil fileUtil = new FileUtil(getServletContext());
        fileUtil.addLessonRequest(requestData); // Store as request instead of scheduling directly

        response.sendRedirect("viewStudentLessons.jsp?message=Lesson+request+submitted");
    }
}