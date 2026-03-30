package com.driveschool.util;

import com.driveschool.model.*;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class FileUtil {
    private final String STUDENT_FILE_PATH;
    private final String INSTRUCTOR_FILE_PATH;
    private final String LESSON_REQUEST_FILE_PATH;
    private final String SCHEDULED_LESSONS_FILE_PATH;
    private final String PAYMENT_FILE_PATH;
    private final String FEEDBACK_FILE_PATH;
    private final String VEHICLE_FILE_PATH;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public FileUtil(ServletContext context) {
        String dataDir = "C:/Users/LENOVO/Desktop/data/";
        this.STUDENT_FILE_PATH = dataDir + "students.txt";
        this.INSTRUCTOR_FILE_PATH = dataDir + "instructors.txt";
        this.LESSON_REQUEST_FILE_PATH = dataDir + "lessonRequests.txt";
        this.SCHEDULED_LESSONS_FILE_PATH = dataDir + "scheduledLessons.txt";
        this.PAYMENT_FILE_PATH = dataDir + "payments.txt";
        this.FEEDBACK_FILE_PATH = dataDir + "feedback.txt";
        this.VEHICLE_FILE_PATH = dataDir + "vehicles.txt";

        initializeFile(STUDENT_FILE_PATH);
        initializeFile(INSTRUCTOR_FILE_PATH);
        initializeFile(LESSON_REQUEST_FILE_PATH);
        initializeFile(SCHEDULED_LESSONS_FILE_PATH);
        initializeFile(PAYMENT_FILE_PATH);
        initializeFile(FEEDBACK_FILE_PATH);
        initializeFile(VEHICLE_FILE_PATH);
    }

    private void initializeFile(String filePath) {
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to create file: " + filePath, e);
        }
    }

    // Feedback Methods
    public synchronized void writeFeedback(List<String[]> feedbackList) throws IOException {
        // Create a backup of the current file
        File originalFile = new File(FEEDBACK_FILE_PATH);
        File backupFile = new File(FEEDBACK_FILE_PATH + ".bak");
        if (originalFile.exists()) {
            Files.copy(originalFile.toPath(), backupFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        try {
            // Write the updated content
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(FEEDBACK_FILE_PATH))) {
                for (String[] feedback : feedbackList) {
                    String sanitizedMessage = feedback[6].replace(",", ";").replace("\n", " ");
                    String feedbackEntry = String.join(",", 
                        feedback[0], // username
                        feedback[1], // name
                        feedback[2], // email
                        feedback[3], // type
                        feedback[4], // rating
                        feedback[5], // timestamp
                        sanitizedMessage // message
                    );
                    writer.write(feedbackEntry);
                    writer.newLine();
                }
            }
            // If write successful, delete the backup
            backupFile.delete();
        } catch (IOException e) {
            // If write fails, restore from backup
            if (backupFile.exists()) {
                Files.copy(backupFile.toPath(), originalFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            throw e;
        }
    }

    public synchronized void saveFeedback(String username, String name, String email, String type, String rating, String message) throws IOException {
        // Validate input
        if (username == null || name == null || email == null || type == null || rating == null || message == null ||
            username.trim().isEmpty() || name.trim().isEmpty() || email.trim().isEmpty() || 
            type.trim().isEmpty() || rating.trim().isEmpty() || message.trim().isEmpty()) {
            throw new IllegalArgumentException("All fields are required");
        }

        // Validate rating
        try {
            int ratingValue = Integer.parseInt(rating);
            if (ratingValue < 1 || ratingValue > 5) {
                throw new IllegalArgumentException("Rating must be between 1 and 5");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid rating value");
        }

        String timestamp = DATE_FORMAT.format(new Date());
        String sanitizedMessage = message.replace(",", ";").replace("\n", " ");
        String feedbackEntry = String.join(",", username, name, email, type, rating, timestamp, sanitizedMessage);

        // Create directory if it doesn't exist
        File directory = new File(FEEDBACK_FILE_PATH).getParentFile();
        if (!directory.exists()) {
            directory.mkdirs();
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FEEDBACK_FILE_PATH, true))) {
            writer.write(feedbackEntry);
            writer.newLine();
        }
    }

    public synchronized List<String[]> readFeedback() throws IOException {
        List<String[]> feedbackList = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FEEDBACK_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] feedbackData = line.split(",", 7);
                    if (feedbackData.length == 7) {
                        feedbackData[6] = feedbackData[6].replace(";", ",");
                        feedbackList.add(feedbackData);
                    }
                }
            }
        }
        return feedbackList;
    }

    public synchronized void deleteFeedback(String username) throws IOException {
        List<String> feedbacks = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(FEEDBACK_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",", 7);
                    if (!parts[0].equals(username)) {
                        feedbacks.add(line);
                    } else {
                        found = true;
                    }
                }
            }
        }

        if (!found) {
            throw new IOException("Feedback not found for username: " + username);
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FEEDBACK_FILE_PATH))) {
            for (String feedback : feedbacks) {
                writer.write(feedback);
                writer.newLine();
            }
        }
    }

    // Existing Methods (unchanged)
    public void createStudent(Student student) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(STUDENT_FILE_PATH, true))) {
            System.out.println("Creating student: " + student.toFileString());
            writer.write(student.toFileString());
            writer.newLine();
        }
    }

    public List<Student> readStudents() throws IOException {
        List<Student> students = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(STUDENT_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Student student = new Student("", "", "");
                    student.fromFileString(line);
                    students.add(student);
                }
            }
        }
        return students;
    }

    public synchronized void savePayment(Payment payment) throws IOException {
        // Generate a unique ID based on timestamp if not set
        if (payment.getId() == null || payment.getId().trim().isEmpty()) {
            payment.setId(String.valueOf(System.currentTimeMillis()));
        }

        // If timestamp is not set, set it to current time
        if (payment.getTimestamp() == null || payment.getTimestamp().trim().isEmpty()) {
            payment.setTimestamp(DATE_FORMAT.format(new Date()));
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE_PATH, true))) {
            // Format: id,cardHolder,cardNumber,expiryDate,cvv,amount,timestamp,status
            writer.write(String.format("%s,%s,%s,%s,%s,%.2f,%s,%s",
                payment.getId(),
                payment.getCardHolder(),
                payment.getCardNumber(),
                payment.getExpiry(),
                payment.getCvv(),
                payment.getAmount(),
                payment.getTimestamp(),
                payment.getStatus()
            ));
            writer.newLine();
        }
    }

    public List<Payment> getAllPayments() throws IOException {
        List<Payment> payments = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(PAYMENT_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 5) {
                    Payment payment = new Payment();
                    payment.setCardHolder(parts[0]);
                    payment.setCardNumber(parts[1]);
                    payment.setExpiry(parts[2]);
                    payment.setCvv(parts[3]);
                    payment.setTimestamp(parts[4]);
                    if (parts.length > 5) {
                        payment.setAmount(parts[5]);
                    }
                    payments.add(payment);
                }
            }
        }
        return payments;
    }

    public List<Payment> readPayments() throws IOException {
        List<Payment> payments = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(PAYMENT_FILE_PATH))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (!line.trim().isEmpty()) {
                    try {
                        String[] parts = line.split(",", -1);
                        if (parts.length >= 8) {
                            Payment payment = new Payment(
                                parts[0].trim(), // id
                                parts[1].trim(), // cardHolder
                                parts[2].trim(), // cardNumber
                                parts[3].trim(), // expiryDate
                                parts[4].trim(), // cvv
                                Double.parseDouble(parts[5].trim()), // amount
                                parts[6].trim(), // timestamp
                                parts[7].trim()  // status
                            );
                            payments.add(payment);
                        } else if (parts.length >= 6) {
                            // Handle older format
                            Payment payment = new Payment(
                                String.valueOf(lineNumber),
                                parts[0].trim(), // cardHolder
                                parts[1].trim(), // cardNumber
                                parts[2].trim(), // expiryDate
                                parts[3].trim(), // cvv
                                Double.parseDouble(parts[4].trim()), // amount
                                parts.length > 5 ? parts[5].trim() : DATE_FORMAT.format(new Date()), // timestamp
                                "Completed" // default status
                            );
                            payments.add(payment);
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing payment at line " + lineNumber + ": " + e.getMessage());
                    }
                }
            }
        }
        return payments;
    }

    public synchronized void deletePayment(String paymentId) throws IOException {
        if (paymentId == null || paymentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment ID cannot be null or empty");
        }

        List<Payment> payments = readPayments();
        List<Payment> updatedPayments = new ArrayList<>();
        boolean found = false;

        for (Payment payment : payments) {
            if (!paymentId.equals(payment.getId())) {
                updatedPayments.add(payment);
            } else {
                found = true;
            }
        }

        if (!found) {
            throw new IOException("Payment not found: " + paymentId);
        }

        // Write back the updated payments
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE_PATH))) {
            for (Payment payment : updatedPayments) {
                writer.write(String.format("%s,%s,%s,%s,%s,%.2f,%s,%s",
                    payment.getId(),
                    payment.getCardHolder(),
                    payment.getCardNumber(),
                    payment.getExpiry(),
                    payment.getCvv(),
                    payment.getAmount(),
                    payment.getTimestamp(),
                    payment.getStatus()
                ));
                writer.newLine();
            }
        }
    }

    public synchronized boolean deletePaymentByCardHolder(String cardHolder) throws IOException {
        if (cardHolder == null || cardHolder.trim().isEmpty()) {
            throw new IllegalArgumentException("Card holder name cannot be null or empty");
        }

        List<Payment> payments = readPayments();
        List<Payment> updatedPayments = new ArrayList<>();
        boolean found = false;

        for (Payment payment : payments) {
            if (!cardHolder.equals(payment.getCardHolder())) {
                updatedPayments.add(payment);
            } else {
                found = true;
            }
        }

        if (!found) {
            return false;
        }

        // Write back the updated payments
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE_PATH))) {
            for (Payment payment : updatedPayments) {
                writer.write(String.format("%s,%s,%s,%s,%s,%.2f,%s,%s",
                    payment.getId(),
                    payment.getCardHolder(),
                    payment.getCardNumber(),
                    payment.getExpiry(),
                    payment.getCvv(),
                    payment.getAmount(),
                    payment.getTimestamp(),
                    payment.getStatus()
                ));
                writer.newLine();
            }
        }
        return true;
    }

    public void updateStudent(Student updatedStudent) throws IOException {
        List<Student> students = readStudents();
        List<Student> updatedList = new ArrayList<>();
        for (Student student : students) {
            if (student.getId().equals(updatedStudent.getId())) {
                updatedList.add(updatedStudent);
            } else {
                updatedList.add(student);
            }
        }
        rewriteFile(STUDENT_FILE_PATH, updatedList);
    }

    public void deleteStudent(String username) throws IOException {
        List<Student> students = readStudents();
        students.removeIf(student -> student.getId().equals(username));
        rewriteFile(STUDENT_FILE_PATH, students);
    }

    public void createInstructor(Instructor instructor) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(INSTRUCTOR_FILE_PATH, true))) {
            writer.write(instructor.toFileString());
            writer.newLine();
        }
    }

    public List<Instructor> readInstructors() throws IOException {
        List<Instructor> instructors = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(INSTRUCTOR_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Instructor instructor = new Instructor("", "", "", 0);
                    instructor.fromFileString(line);
                    instructors.add(instructor);
                }
            }
        }
        return instructors;
    }

    public void updateInstructor(Instructor updatedInstructor) throws IOException {
        List<Instructor> instructors = readInstructors();
        List<Instructor> updatedList = new ArrayList<>();
        boolean updated = false;

        for (Instructor instructor : instructors) {
            if (instructor.getName().equals(updatedInstructor.getName())) {
                instructor.setAvailability(updatedInstructor.getAvailability());
                instructor.setExperience(updatedInstructor.getExperience());
                updatedList.add(instructor);
                updated = true;
            } else {
                updatedList.add(instructor);
            }
        }

        if (updated) {
            rewriteInstructorFile(INSTRUCTOR_FILE_PATH, updatedList);
        } else {
            throw new IOException("Instructor not found: " + updatedInstructor.getName());
        }
    }

    public void addLessonRequest(String request) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(LESSON_REQUEST_FILE_PATH, true))) {
            writer.write(request);
            writer.newLine();
        }
    }

    public List<String> readLessonRequests() throws IOException {
        List<String> requests = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(LESSON_REQUEST_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    requests.add(line);
                }
            }
        }
        return requests;
    }

    public void removeLessonRequest(String request) throws IOException {
        List<String> requests = readLessonRequests();
        requests.removeIf(req -> req.trim().equals(request.trim()));

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(LESSON_REQUEST_FILE_PATH))) {
            for (String req : requests) {
                writer.write(req);
                writer.newLine();
            }
        }
    }

    public void scheduleLesson(Lesson lesson) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(SCHEDULED_LESSONS_FILE_PATH, true))) {
            writer.write(lesson.toFileString());
            writer.newLine();
        }
    }

    public List<Lesson> readScheduledLessons() throws IOException {
        List<Lesson> lessons = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(SCHEDULED_LESSONS_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Lesson lesson = Lesson.fromFileString(line);
                    if (lesson != null) {
                        lessons.add(lesson);
                    }
                }
            }
        }
        return lessons;
    }

    private void rewriteFile(String filePath, List<Student> students) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Student student : students) {
                writer.write(student.toFileString());
                writer.newLine();
            }
        }
    }

    public void deleteLesson(String studentUsername, String instructorName, String lessonDate) throws IOException {
        List<Lesson> lessons = readScheduledLessons();
        lessons.removeIf(lesson -> lesson.getStudentUsername().equals(studentUsername)
                && lesson.getInstructorName().equals(instructorName)
                && lesson.getDate().equals(lessonDate));
        rewriteScheduledLessonsFile(SCHEDULED_LESSONS_FILE_PATH, lessons);
    }

    private void rewriteScheduledLessonsFile(String filePath, List<Lesson> lessons) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Lesson lesson : lessons) {
                writer.write(lesson.toFileString());
                writer.newLine();
            }
        }
    }

    public void deleteInstructor(String name) throws IOException {
        List<Instructor> instructors = readInstructors();
        instructors.removeIf(instructor -> instructor.getName().equalsIgnoreCase(name));
        rewriteInstructorFile(INSTRUCTOR_FILE_PATH, instructors);
    }

    private void rewriteInstructorFile(String filePath, List<Instructor> instructors) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Instructor instructor : instructors) {
                writer.write(instructor.toFileString());
                writer.newLine();
            }
        }
    }

    // Vehicle Methods
    public synchronized void addVehicle(Vehicle vehicle) throws IOException {
        if (vehicle == null) {
            System.err.println("Attempted to add null vehicle");
            throw new IllegalArgumentException("Vehicle cannot be null");
        }
        // Check for duplicate vehicle ID
        List<Vehicle> vehicles = readVehicles();
        if (vehicles.stream().anyMatch(v -> v.getVehicleId().equals(vehicle.getVehicleId()))) {
            throw new IOException("Vehicle ID already exists: " + vehicle.getVehicleId());
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(VEHICLE_FILE_PATH, true))) {
            writer.write(vehicle.toFileString());
            writer.newLine();
        } catch (IOException e) {
            System.err.println("Error adding vehicle: " + vehicle.getVehicleId() + " - " + e.getMessage());
            throw new IOException("Failed to add vehicle: " + e.getMessage(), e);
        }
    }

    public List<Vehicle> readVehicles() throws IOException {
        List<Vehicle> vehicles = new ArrayList<>();
        File file = new File(VEHICLE_FILE_PATH);
        if (!file.exists()) {
            return vehicles; // Return empty list if file doesn't exist
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (!line.trim().isEmpty()) {
                    try {
                        Vehicle vehicle = new Vehicle("", "", "", "", "", "");
                        vehicle.fromFileString(line);
                        vehicles.add(vehicle);
                    } catch (IllegalArgumentException e) {
                        System.err.println("Invalid vehicle data at line " + lineNumber + ": " + line + " - " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading vehicles from: " + VEHICLE_FILE_PATH + " - " + e.getMessage());
            throw new IOException("Failed to read vehicles: " + e.getMessage(), e);
        }
        return vehicles;
    }

    public synchronized void updateVehicle(Vehicle updatedVehicle) throws IOException {
        if (updatedVehicle == null) {
            System.err.println("Attempted to update null vehicle");
            throw new IllegalArgumentException("Vehicle cannot be null");
        }
        List<Vehicle> vehicles = readVehicles();
        boolean found = false;
        File originalFile = new File(VEHICLE_FILE_PATH);
        File tempFile = new File(VEHICLE_FILE_PATH + ".tmp");

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {
            for (Vehicle v : vehicles) {
                if (v.getVehicleId().equals(updatedVehicle.getVehicleId())) {
                    writer.write(updatedVehicle.toFileString());
                    found = true;
                } else {
                    writer.write(v.toFileString());
                }
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing temporary vehicle file for update: " + updatedVehicle.getVehicleId() + " - " + e.getMessage());
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Failed to update vehicle: " + e.getMessage(), e);
        }

        if (!found) {
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Vehicle not found: " + updatedVehicle.getVehicleId());
        }

        if (originalFile.exists() && !originalFile.delete()) {
            System.err.println("Failed to delete original file: " + VEHICLE_FILE_PATH);
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Failed to delete original file: " + VEHICLE_FILE_PATH);
        }

        if (!tempFile.renameTo(originalFile)) {
            System.err.println("Failed to rename temporary file to: " + VEHICLE_FILE_PATH);
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Failed to rename temporary file to " + VEHICLE_FILE_PATH);
        }
    }

    public synchronized boolean deleteVehicle(String vehicleId) throws IOException {
        if (vehicleId == null || vehicleId.trim().isEmpty()) {
            System.err.println("Attempted to delete vehicle with null or empty ID");
            throw new IllegalArgumentException("Vehicle ID cannot be null or empty");
        }
        List<Vehicle> vehicles = readVehicles();
        boolean found = false;
        File tempFile = new File(VEHICLE_FILE_PATH + ".tmp");
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {
            for (Vehicle v : vehicles) {
                if (!v.getVehicleId().equals(vehicleId)) {
                    writer.write(v.toFileString());
                    writer.newLine();
                } else {
                    found = true;
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing temporary vehicle file for deletion: " + vehicleId + " - " + e.getMessage());
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Failed to delete vehicle: " + e.getMessage(), e);
        }
        if (!found) {
            if (tempFile.exists()) tempFile.delete();
            return false;
        }
        try {
            File originalFile = new File(VEHICLE_FILE_PATH);
            if (originalFile.exists() && !originalFile.delete()) {
                System.err.println("Failed to delete original file: " + VEHICLE_FILE_PATH);
                if (tempFile.exists()) tempFile.delete();
                throw new IOException("Failed to delete original file: " + VEHICLE_FILE_PATH);
            }
            if (!tempFile.renameTo(originalFile)) {
                System.err.println("Failed to rename temporary file to: " + VEHICLE_FILE_PATH);
                if (tempFile.exists()) tempFile.delete();
                throw new IOException("Failed to rename temporary file to " + VEHICLE_FILE_PATH);
            }
        } catch (IOException e) {
            System.err.println("Error renaming temporary vehicle file for deletion: " + vehicleId + " - " + e.getMessage());
            if (tempFile.exists()) tempFile.delete();
            throw new IOException("Failed to delete vehicle: " + e.getMessage(), e);
        }
        return true;
    }

    public synchronized Vehicle getVehicleById(String vehicleId) throws IOException {
        if (vehicleId == null || vehicleId.trim().isEmpty()) {
            throw new IllegalArgumentException("Vehicle ID cannot be null or empty");
        }
        return readVehicles().stream()
                .filter(v -> vehicleId.equals(v.getVehicleId()))
                .findFirst()
                .orElse(null);
    }
}