package com.examportal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/online_exam_portal?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        String url = getConfig("exam.portal.db.url", "EXAM_PORTAL_DB_URL", DEFAULT_URL);
        String username = getConfig("exam.portal.db.username", "EXAM_PORTAL_DB_USERNAME", DEFAULT_USERNAME);
        String password = getConfig("exam.portal.db.password", "EXAM_PORTAL_DB_PASSWORD", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, username, password);
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static String getConfig(String systemProperty, String envVariable, String defaultValue) {
        String value = System.getProperty(systemProperty);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(envVariable);
        }
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        return value.trim();
    }
}
