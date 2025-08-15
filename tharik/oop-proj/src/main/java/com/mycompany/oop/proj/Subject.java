/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.oop.proj;

/**
 *
 * @author hd
 */
public class Subject {
    private int id;
    private String name;
    private double marks;

    public Subject() {
        this.id = 0;
        this.name = "";
        this.marks = 0;
    }

    public Subject(int id, String name, double marks) {
        this.id = id;
        this.name = name;
        this.marks = marks;
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getMarks() {
        return marks;
    }

    public void setMarks(double marks) {
        this.marks = marks;
    }
    
    
}
