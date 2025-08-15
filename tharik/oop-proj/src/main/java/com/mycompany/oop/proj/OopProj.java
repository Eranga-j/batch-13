/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.oop.proj;

import java.util.ArrayList;

/**
 *
 * @author hd
 */
public class OopProj {

    public static void main(String[] args) {
        
        ArrayList<Student> students = new ArrayList<>();
        
        Student st1 = new Student(1, "Lewis Hamilton");
        st1.addSubject(new Subject(1, "Software Engineering", 71));
        st1.addSubject(new Subject(2, "Network Engineering", 84));
        st1.addSubject(new Subject(3, "Database Management", 77));
        st1.addSubject(new Subject(4, "Aritificial Intelligence", 84));
        st1.addSubject(new Subject(5, "Business Management", 84));
        
        Student st2 = new Student(2, "Charles Leclerc");
        st2.addSubject(new Subject(1, "Software Engineering", 70));
        st2.addSubject(new Subject(2, "Network Engineering", 83));
        st2.addSubject(new Subject(3, "Database Management", 78));
        st2.addSubject(new Subject(4, "Aritificial Intelligence", 80));
        st2.addSubject(new Subject(5, "Business Management", 82));
        
        
        Student st3 = new Student(3, "Marc Marquez");
        st3.addSubject(new Subject(1, "Software Engineering", 77));
        st3.addSubject(new Subject(2, "Network Engineering", 84));
        st3.addSubject(new Subject(3, "Database Management", 80));
        st3.addSubject(new Subject(4, "Aritificial Intelligence", 82));
        st3.addSubject(new Subject(5, "Business Management", 83));
        
        students.add(st1);
        students.add(st2);
        students.add(st3);
        
        System.out.println("----------------------------------");
        System.out.print("Name \t\t\t");
        System.out.print("Average \n");
        System.out.println("----------------------------------");
        
        double total = 0;
        for(Student st : students) {
            double average = st.getSubjectAverage();
            total = total + average;
            System.out.print(st.getName() + "\t\t");
            System.out.print(average);
            System.out.println();
        }
        System.out.println("----------------------------------");
        System.out.print("Average of all the student  : " + Math.round(total / students.size()));
   
    }
}
