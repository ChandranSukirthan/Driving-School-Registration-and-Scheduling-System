package com.driveschool.model;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Feedback {
    private String username;
    private String name;
    private String email;
    private String type;
    private int rating;
    private String timestamp;
    private String message;

    public Feedback(String username, String name, String email, String type, int rating, String message) {
        setUsername(username);
        setName(name);
        setEmail(email);
        setType(type);
        setRating(rating);
        setMessage(message);
        this.timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
    }


    public Feedback(String username, String name, String email, String type, int rating, String timestamp, String message) {
        setUsername(username);
        setName(name);
        setEmail(email);
        setType(type);
        setRating(rating);
        setTimestamp(timestamp);
        setMessage(message);
    }

    public Feedback() {}

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        this.username = username.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        this.name = name.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }
        this.email = email.trim();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        if (type == null || type.trim().isEmpty()) {
            throw new IllegalArgumentException("Feedback type cannot be null or empty");
        }
        if (!type.matches("General|Instructor|Lesson|Website|Other")) {
            throw new IllegalArgumentException("Invalid feedback type");
        }
        this.type = type.trim();
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        if (timestamp == null || timestamp.trim().isEmpty()) {
            throw new IllegalArgumentException("Timestamp cannot be null or empty");
        }
        // Validate timestamp format
        try {
            new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid timestamp format");
        }
        this.timestamp = timestamp;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException("Message cannot be null or empty");
        }
        this.message = message.trim();
    }

    // Convert to file format
    public String toFileString() {
        String sanitizedMessage = message.replace(",", ";").replace("\n", " ");
        return String.join(",", username, name, email, type, String.valueOf(rating), timestamp, sanitizedMessage);
    }

    // Parse from file string
    public void fromFileString(String fileString) {
        String[] parts = fileString.split(",", 7);
        if (parts.length != 7) {
            throw new IllegalArgumentException("Invalid feedback data format");
        }
        setUsername(parts[0]);
        setName(parts[1]);
        setEmail(parts[2]);
        setType(parts[3]);
        setRating(Integer.parseInt(parts[4]));
        setTimestamp(parts[5]);
        setMessage(parts[6].replace(";", ","));
    }
}
