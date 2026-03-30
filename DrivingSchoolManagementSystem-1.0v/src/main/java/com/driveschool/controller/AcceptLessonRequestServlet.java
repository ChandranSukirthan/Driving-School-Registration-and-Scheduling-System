package com.driveschool.controller;

import com.driveschool.model.Lesson;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AcceptLessonRequestServlet")
public class AcceptLessonRequestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestString = request.getParameter("request");
        FileUtil fileUtil = new FileUtil(getServletContext());

        // Parse the request string and schedule the lesson
        String[] data = requestString.split(",");
        if (data.length == 3) {
            Lesson lesson = new Lesson(data[0], data[1], data[2]);
            fileUtil.scheduleLesson(lesson);
        }

        // Remove the request from the queue
        fileUtil.removeLessonRequest(requestString);

        response.sendRedirect("viewLessonRequests.jsp");
    }
}