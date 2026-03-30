package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import com.driveschool.model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/view-payments")
public class ViewPaymentsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FileUtil fileUtil = new FileUtil(getServletContext());
        List<Payment> payments = fileUtil.readPayments();

        request.setAttribute("payments", payments);
        request.getRequestDispatcher("viewPayment.jsp").forward(request, response);
    }
}
