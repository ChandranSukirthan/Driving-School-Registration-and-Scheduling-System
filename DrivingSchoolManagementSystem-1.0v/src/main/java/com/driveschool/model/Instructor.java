package com.driveschool.model;

public class Instructor extends User {
    private String name;
    private String contact;
    private String availability;
    private int experience;

    public Instructor(String name, String contact, String availability, int experience) {
        super(name);
        this.name = name;
        this.contact = contact;
        this.availability = availability;
        this.experience = experience;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        setId(name);
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    public int getExperience() {
        return experience;
    }

    public void setExperience(int experience) {
        this.experience = experience;
    }

    @Override
    public String toFileString() {
        return name + "," + contact + "," + availability + "," + experience;
    }

    @Override
    public void fromFileString(String fileString) {
        String[] data = fileString.split(",");
        if (data.length == 4) {
            this.name = data[0];
            this.contact = data[1];
            this.availability = data[2];
            this.experience = Integer.parseInt(data[3]);
            setId(name);
        }
    }
}