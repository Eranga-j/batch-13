/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.oop.proj;

import java.util.ArrayList;

/**
 *
 * @author hd
 */
public class Student {
    private int id;
    private String name;
    private ArrayList<Subject> subjects;

    public Student() {
        this.id = 0;
        this.name = "";
        this.subjects = new ArrayList<>();
    }
    
    public Student(int id, String name) {
        this.id = id;
        this.name = name;
        this.subjects = new ArrayList<>();
    }

    public Student(int id, String name, ArrayList<Subject> subjects) {
        this.id = id;
        this.name = name;
        this.subjects = subjects;
    }
    
    public double getSubjectAverage() {
        return subjects.stream()
                    .mapToDouble(Subject::getMarks)
                    .average()
                    .orElse(0.0);
    }
    
      public double getSubjectAverage() { 
        return 0.0;  
      }

    
    public void addSubject(Subject subject) {
        this.subjects.add(subject);
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

    public ArrayList<Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(ArrayList<Subject> subjects) {
        this.subjects = subjects;
    }
    
    
}
