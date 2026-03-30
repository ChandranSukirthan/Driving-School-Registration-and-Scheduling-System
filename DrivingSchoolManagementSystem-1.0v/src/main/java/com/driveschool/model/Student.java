package com.driveschool.model;

public class Student extends User {
    private String username;
    private String password;
    private String userType;

    public Student(String username, String password, String userType) {
        super(username);
        this.username = username;
        this.password = password;
        this.userType = userType;
    }

    // Getters and Setters (Encapsulation)
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
        setId(username);
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    @Override
    public String toFileString() {
        return username + "," + password + "," + userType;
    }

    @Override
    public void fromFileString(String fileString) {
        String[] data = fileString.split(",");
        if (data.length == 3) {
            this.username = data[0];
            this.password = data[1];
            this.userType = data[2];
            setId(username);
        }
    }
}