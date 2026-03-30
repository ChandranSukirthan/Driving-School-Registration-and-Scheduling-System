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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        FileUtil fileUtil = new FileUtil(getServletContext());
        List<Student> students = fileUtil.readStudents();
        for (Student student : students) {
            if (student.getUsername().equals(username) && student.getPassword().equals(password)) {
                System.out.println("Login successful for user: " + username);
                request.getSession().setAttribute("username", username);
                response.sendRedirect("dashboard.jsp");
                return;
            }
        }

        System.out.println("Login failed for user: " + username);
        response.sendRedirect("login.jsp?error=Invalid credentials");
    }
}