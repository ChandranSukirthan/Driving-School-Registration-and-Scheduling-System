package com.driveschool.model;

public class Lesson {
    private String studentUsername;
    private String instructorName;
    private String date;

    public Lesson(String studentUsername, String instructorName, String date) {
        this.studentUsername = studentUsername;
        this.instructorName = instructorName;
        this.date = date;
    }

    public String getStudentUsername() {
        return studentUsername;
    }

    public void setStudentUsername(String studentUsername) {
        this.studentUsername = studentUsername;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String toFileString() {
        return studentUsername + "," + instructorName + "," + date;
    }

    public static Lesson fromFileString(String fileString) {
        String[] data = fileString.split(",");
        if (data.length == 3) {
            return new Lesson(data[0], data[1], data[2]);
        }
        return null;
    }
}