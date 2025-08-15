/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package utils;

import java.util.List;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author hd
 */
public class UtilsTest {
    
    public UtilsTest() {
    }
    
    @BeforeAll
    public static void setUpClass() {
    }
    
    @AfterAll
    public static void tearDownClass() {
    }
    
    @BeforeEach
    public void setUp() {
    }
    
    @AfterEach
    public void tearDown() {
    }

    /**
     * Test of getStudents method, of class Utils.
     */
//    @Test
//    public void testGetStudents() {
//        System.out.println("getStudents");
//        Utils instance = new Utils();
//        List<Student> expResult = null;
//        List<Student> result = instance.getStudents();
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }

    /**
     * Test of getStudentById method, of class Utils.
     */
    @Test
    public void testGetStudentById() {
        System.out.println("getStudentById");
        int id = 3;
        Utils instance = new Utils();
        Student expResult = new Student(3, "Max Verstapan");
        Student result = instance.getStudentById(id);
        
        assertEquals(expResult.getId(), result.getId());
         assertEquals(expResult.getName(), result.getName());
        
 
    }

    /**
     * Test of createStudent method, of class Utils.
     */
//    @Test
//    public void testCreateStudent() {
//        System.out.println("createStudent");
//        Student student = null;
//        Utils instance = new Utils();
//        boolean expResult = false;
//        boolean result = instance.createStudent(student);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of updateStudent method, of class Utils.
//     */
//    @Test
//    public void testUpdateStudent() {
//        System.out.println("updateStudent");
//        Student student = null;
//        Utils instance = new Utils();
//        boolean expResult = false;
//        boolean result = instance.updateStudent(student);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of deleteStudent method, of class Utils.
//     */
//    @Test
//    public void testDeleteStudent() {
//        System.out.println("deleteStudent");
//        int id = 0;
//        Utils instance = new Utils();
//        boolean expResult = false;
//        boolean result = instance.deleteStudent(id);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
    
}
