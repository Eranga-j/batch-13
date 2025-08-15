/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hd
 */
public class Utils {
    
    static final String DB_URL = "jdbc:mysql://localhost/batch13";
    static final String USER = "root";
    static final String PASS = "";
      
    public List<Student> getStudents() {
        List<Student> students = new ArrayList<>();
        
// For Java 8 following need to be uncommented and handle error
//         DriverManager.registerDriver(new com.mysql.jdbc.Driver());
        
        try(Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students");
        ) {		      
                while(rs.next()){
                Student st = new Student();
                st.setId(rs.getInt("id"));
                st.setName(rs.getString("name"));
                students.add(st);
         }
        } catch (SQLException e) {
            e.printStackTrace();
        }   
        return students;
    }
}
