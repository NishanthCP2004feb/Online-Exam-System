package com.examportal.dao;

import com.examportal.model.User;
import com.examportal.util.DBConnection;
import com.examportal.util.PasswordUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static final String DEFAULT_ADMIN_PASSWORD_HASH = "pbkdf2$65536$35wlarOHDdjk791ouO8rsg==$JE4+lkOoI6yk8vHUY6mK9RoqrfNr2IwC5pb+gAnNidg=";
    private static final String DEFAULT_STUDENT_PASSWORD_HASH = "pbkdf2$65536$CTZ5H/9dyqGFv8I67zSeGA==$WZtFr0dzQPZwg5UxiBb0LRTI3ee42Hl2dqBdG6bfLPI=";

    public boolean register(User user) {
        String sql = "INSERT INTO users (username, full_name, email, password, role) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ensureUsersTableAndDefaults(conn);
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, PasswordUtils.hashPassword(user.getPassword()));
            ps.setString(5, user.getRole() != null ? user.getRole() : "student");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ensureUsersTableAndDefaults(conn);
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                User user = extractUser(rs);
                if (PasswordUtils.verifyPassword(password, user.getPassword())) {
                    if (PasswordUtils.needsRehash(user.getPassword())) {
                        updatePasswordHash(conn, user.getId(), PasswordUtils.hashPassword(password));
                    }
                    user.setPassword(null);
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new IllegalStateException("Database connection failed.", e);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    public boolean isUsernameTaken(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean isEmailTaken(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public int getTotalStudents() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'student'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    public List<User> getAllStudents() {
        List<User> students = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'student' ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                students.add(extractUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return students;
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    private void updatePasswordHash(Connection conn, int userId, String passwordHash) throws SQLException {
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?");
            ps.setString(1, passwordHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    private void ensureUsersTableAndDefaults(Connection conn) throws SQLException {
        Statement statement = null;
        try {
            statement = conn.createStatement();
            statement.execute(
                "CREATE TABLE IF NOT EXISTS users ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "username VARCHAR(50) UNIQUE NOT NULL,"
                    + "full_name VARCHAR(100) NOT NULL,"
                    + "email VARCHAR(100) UNIQUE NOT NULL,"
                    + "password VARCHAR(255) NOT NULL,"
                    + "role ENUM('student', 'admin') DEFAULT 'student',"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                + ")"
            );

            statement.executeUpdate(
                "INSERT INTO users (username, full_name, email, password, role) VALUES "
                    + "('admin', 'System Administrator', 'admin@examportal.com', '" + DEFAULT_ADMIN_PASSWORD_HASH + "', 'admin'),"
                    + "('student1', 'Rahul Sharma', 'rahul@student.com', '" + DEFAULT_STUDENT_PASSWORD_HASH + "', 'student') "
                    + "ON DUPLICATE KEY UPDATE "
                    + "full_name = VALUES(full_name), "
                    + "password = VALUES(password), "
                    + "role = VALUES(role)"
            );
        } finally {
            try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
