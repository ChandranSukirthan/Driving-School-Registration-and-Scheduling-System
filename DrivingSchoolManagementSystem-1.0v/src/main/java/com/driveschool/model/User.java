package com.driveschool.model;

public abstract class User {
    private String id; // Unique identifier (e.g., username for students)

    public User(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    // Abstract methods for polymorphism
    public abstract String toFileString();
    public abstract void fromFileString(String fileString);
}