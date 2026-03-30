package com.driveschool.controller;

import com.driveschool.model.Instructor;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/AddInstructorServlet")
public class AddInstructorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String availability = request.getParameter("availability");
        int experience;

        try {
            experience = Integer.parseInt(request.getParameter("experience"));
        } catch (NumberFormatException e) {
            System.out.println("Invalid experience value: " + request.getParameter("experience"));
            response.sendRedirect("addInstructor.jsp?error=invalid_experience");
            return;
        }

        Instructor instructor = new Instructor(name, contact, availability, experience);
        FileUtil fileUtil = new FileUtil(getServletContext());

        try {
            fileUtil.createInstructor(instructor);
            System.out.println("Instructor added: " + name);
            response.sendRedirect("viewInstructors.jsp");
        } catch (Exception e) {
            System.out.println("Error adding instructor: " + e.getMessage());
            response.sendRedirect("addInstructor.jsp?error=creation_failed");
        }
    }
}