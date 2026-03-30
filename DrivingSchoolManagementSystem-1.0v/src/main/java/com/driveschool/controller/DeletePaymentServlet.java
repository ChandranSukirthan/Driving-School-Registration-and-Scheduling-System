package com.driveschool.controller;

import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/DeletePaymentServlet")
public class DeletePaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String paymentId = req.getParameter("paymentId");

        if (paymentId == null || paymentId.trim().isEmpty()) {
            System.err.println("DeletePaymentServlet: Invalid or missing paymentId");
            resp.sendRedirect(req.getContextPath() + "/viewPayments.jsp?error=" + URLEncoder.encode("Payment ID is required.", StandardCharsets.UTF_8));
            return;
        }

        FileUtil fileUtil = new FileUtil(getServletContext());
        try {
            fileUtil.deletePayment(paymentId);
            System.err.println("DeletePaymentServlet: Successfully deleted payment: " + paymentId);
            resp.sendRedirect(req.getContextPath() + "/viewPayment.jsp?success=" + URLEncoder.encode("Payment deleted successfully!", StandardCharsets.UTF_8));
        } catch (IOException e) {
            System.err.println("DeletePaymentServlet: Error deleting payment: " + paymentId + " - " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/viewPayment.jsp?error=" + URLEncoder.encode("Failed to delete payment: " + e.getMessage(), StandardCharsets.UTF_8));
        } catch (Exception e) {
            System.err.println("DeletePaymentServlet: Unexpected error deleting payment: " + paymentId + " - " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/viewPayment.jsp?error=" + URLEncoder.encode("Unexpected error: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}