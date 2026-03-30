package com.driveschool.controller;

import com.driveschool.model.Payment;
import com.driveschool.util.FileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@jakarta.servlet.annotation.MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5,   // 5 MB
        maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class PaymentServlet extends HttpServlet {

    private FileUtil fileUtil;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        this.fileUtil = new FileUtil(context);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentName = request.getParameter("studentName") != null ? request.getParameter("studentName").trim() : "";
        String vehicleType = request.getParameter("vehicleType") != null ? request.getParameter("vehicleType").trim() : "";
        String paymentPlan = request.getParameter("paymentPlan") != null ? request.getParameter("paymentPlan").trim() : "full";
        String amountStr = request.getParameter("amount") != null ? request.getParameter("amount").trim() : "0";
        String paymentMethod = request.getParameter("paymentMethod") != null ? request.getParameter("paymentMethod").trim() : "card";

        System.out.println("Received - Student Name: " + studentName);
        System.out.println("Received - Vehicle Type: " + vehicleType);
        System.out.println("Received - Payment Plan: " + paymentPlan);
        System.out.println("Received - Amount: " + amountStr);
        System.out.println("Received - Payment Method: " + paymentMethod);

        // Validate studentName and vehicleType
        if (studentName.isEmpty() || vehicleType.isEmpty()) {
            throw new ServletException("Student name and vehicle type are required");
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
            if (amount <= 0) {
                throw new NumberFormatException("Amount must be positive");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid amount format: " + amountStr);
        }

        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Payment payment = null;

        if ("card".equals(paymentMethod)) {
            try {
                String cardHolder = request.getParameter("cardHolder");
                String cardNumber = request.getParameter("cardNumber");
                String expiryDate = request.getParameter("expiryDate");
                String cvv = request.getParameter("cvv");

                // Validate required fields
                if (cardHolder == null || cardHolder.trim().isEmpty() ||
                        cardNumber == null || cardNumber.trim().isEmpty() ||
                        expiryDate == null || expiryDate.trim().isEmpty() ||
                        cvv == null || cvv.trim().isEmpty()) {
                    throw new ServletException("All payment fields are required");
                }

                // Basic card number validation (16 digits)
                if (!cardNumber.replaceAll("\\s+", "").matches("\\d{16}")) {
                    throw new ServletException("Invalid card number format");
                }

                // Basic CVV validation (3-4 digits)
                if (!cvv.matches("\\d{3,4}")) {
                    throw new ServletException("Invalid CVV format");
                }

                // Create and save payment
                payment = new Payment();
                payment.setCardHolder(cardHolder);
                payment.setCardNumber(cardNumber.replaceAll("\\s+", ""));
                payment.setExpiry(expiryDate);
                payment.setCvv(cvv);
                payment.setTimestamp(timestamp);
                payment.setAmount(String.valueOf(amount));
                payment.setStatus("Completed");
                fileUtil.savePayment(payment);

            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            }
        } else if ("deposit".equals(paymentMethod)) {
            try {
                Part filePart = request.getPart("depositReceipt");
                if (filePart == null || filePart.getSize() == 0) {
                    throw new ServletException("Bank deposit receipt is required");
                }

                // Validate file size (5MB limit)
                if (filePart.getSize() > 5 * 1024 * 1024) {
                    throw new ServletException("File size must be less than 5MB");
                }

                // Get original filename and create unique filename
                String originalFileName = filePart.getSubmittedFileName();
                if (originalFileName == null || originalFileName.isEmpty()) {
                    throw new ServletException("Invalid deposit receipt file");
                }
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String uniqueFileName = System.currentTimeMillis() + "_" + studentName.replaceAll("\\s+", "_") + fileExtension;

                // Create upload directory if it doesn't exist
                String uploadPath = getServletContext().getRealPath("/data/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Save the file
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Get transaction reference if provided
                String transactionRef = request.getParameter("transactionRef") != null ? request.getParameter("transactionRef").trim() : "No Reference";

                // Create payment record
                payment = new Payment();
                payment.setCardHolder(studentName);
                payment.setCardNumber("Bank Deposit: " + uniqueFileName);
                payment.setExpiry(transactionRef);
                payment.setCvv("");
                payment.setTimestamp(timestamp);
                payment.setAmount(String.valueOf(amount));
                payment.setStatus("Deposit");
                fileUtil.savePayment(payment);

            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            }
        } else {
            throw new ServletException("Invalid payment method: " + paymentMethod);
        }

        // Generate and save receipt
        String receiptContent = generateReceipt(studentName, vehicleType, paymentPlan, amountStr, paymentMethod);
        String receiptFileName = "receipt_" + System.currentTimeMillis() + ".txt";
        String receiptPath = getServletContext().getRealPath("/data/receipts") + File.separator + receiptFileName;
        File receiptDir = new File(getServletContext().getRealPath("/data/receipts"));
        if (!receiptDir.exists()) {
            receiptDir.mkdirs();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(receiptPath))) {
            writer.write(receiptContent);
        } catch (IOException e) {
            System.err.println("Error writing receipt file: " + receiptPath + " - " + e.getMessage());
            throw new IOException("Failed to save receipt: " + e.getMessage(), e);
        }

        // Set session attributes for confirmation page
        HttpSession session = request.getSession();
        session.setAttribute("studentName", studentName);
        session.setAttribute("vehicleType", vehicleType);
        session.setAttribute("paymentPlan", paymentPlan);
        session.setAttribute("amount", amountStr);
        session.setAttribute("paymentMethod", paymentMethod);
        session.setAttribute("receiptFileName", receiptFileName);

        response.sendRedirect("PaymentConfirmation.jsp");
    }

    private String generateReceipt(String studentName, String vehicleType, String paymentPlan, String amount, String paymentMethod) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String timestamp = sdf.format(new Date());
        StringBuilder receipt = new StringBuilder();
        receipt.append("===== Payment Receipt =====\n");
        receipt.append("Date: ").append(timestamp).append("\n");
        receipt.append("Student Name: ").append(studentName).append("\n");
        receipt.append("Package: ").append(vehicleType).append("\n");
        receipt.append("Payment Plan: ").append(paymentPlan).append("\n");
        receipt.append("Amount: Rs. ").append(amount).append("\n");
        receipt.append("Payment Method: ").append(paymentMethod).append("\n");
        receipt.append("==========================\n");
        return receipt.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Payment> payments = fileUtil.readPayments();
        response.setContentType("application/json");
        response.getWriter().write(convertToJson(payments));
    }

    private String convertToJson(List<Payment> payments) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < payments.size(); i++) {
            Payment payment = payments.get(i);
            json.append("{");
            json.append("\"id\":\"").append(payment.getId() != null ? payment.getId() : "").append("\",");
            json.append("\"cardHolder\":\"").append(payment.getCardHolder() != null ? payment.getCardHolder() : "").append("\",");
            json.append("\"cardNumber\":\"").append(payment.getCardNumber() != null ? payment.getCardNumber() : "").append("\",");
            json.append("\"expiry\":\"").append(payment.getExpiry() != null ? payment.getExpiry() : "").append("\",");
            json.append("\"cvv\":\"").append(payment.getCvv() != null ? payment.getCvv() : "").append("\",");
          //  json.append("\"amount\":\"").append(payment.getAmount() != null ? payment.getAmount() : "0").append("\",");
            json.append("\"timestamp\":\"").append(payment.getTimestamp() != null ? payment.getTimestamp() : "").append("\",");
            json.append("\"status\":\"").append(payment.getStatus() != null ? payment.getStatus() : "Completed").append("\"");
            json.append("}");
            if (i < payments.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }
}