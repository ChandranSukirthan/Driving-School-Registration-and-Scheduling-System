package com.driveschool.controller;

import com.driveschool.model.Student;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        Student student = new Student(username, password, userType);
        FileUtil fileUtil = new FileUtil(getServletContext());
        fileUtil.createStudent(student);

        response.sendRedirect("login.jsp");
    }
}