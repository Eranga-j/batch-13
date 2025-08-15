package com.pahanaedu.service.db;

import javax.sql.DataSource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;

public class Database {

    private static DataSource lookup() throws SQLException {
        try {
            InitialContext ctx = new InitialContext();
            try { return (DataSource) ctx.lookup("jdbc/pahanaedu"); } catch (NamingException e1) { return (DataSource) ctx.lookup("java:comp/env/jdbc/pahanaedu"); }
        } catch (NamingException e) {
            throw new SQLException("JNDI lookup failed for jdbc/pahanaedu: " + e.getMessage(), e);
        }
    }
    public static Connection getConnection() throws SQLException {
        return lookup().getConnection();
    }
}
