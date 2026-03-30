package com.driveschool.controller;

import com.driveschool.model.Student;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/SearchUserServlet")
public class SearchUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username cannot be empty");
            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
            return;
        }

        // Search for student
        FileUtil fileUtil = new FileUtil(getServletContext());
        List<Student> students = fileUtil.readStudents();
        Student foundStudent = null;

        for (Student student : students) {
            if (student.getUsername().equalsIgnoreCase(username.trim())) {
                foundStudent = student;
                break;
            }
        }

        // Set results for JSP
        if (foundStudent != null) {
            request.setAttribute("foundStudent", foundStudent);
        } else {
            request.setAttribute("notFound", "No student found with username: " + username);
        }

        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }
}