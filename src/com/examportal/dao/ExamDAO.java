package com.examportal.dao;

import com.examportal.model.Exam;
import com.examportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public List<Exam> getAllActiveExams() {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT e.*, (SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) as question_count " +
                     "FROM exams e WHERE e.is_active = TRUE ORDER BY e.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = extractExam(rs);
                exam.setQuestionCount(rs.getInt("question_count"));
                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return exams;
    }

    public List<Exam> getAllExams() {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT e.*, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) as question_count, " +
                     "(SELECT COUNT(*) FROM results r WHERE r.exam_id = e.id) as attempt_count " +
                     "FROM exams e ORDER BY e.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = extractExam(rs);
                exam.setQuestionCount(rs.getInt("question_count"));
                exam.setAttemptCount(rs.getInt("attempt_count"));
                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return exams;
    }

    public Exam getExamById(int id) {
        String sql = "SELECT e.*, (SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) as question_count " +
                     "FROM exams e WHERE e.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Exam exam = extractExam(rs);
                exam.setQuestionCount(rs.getInt("question_count"));
                return exam;
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

    public boolean addExam(Exam exam) {
        String sql = "INSERT INTO exams (title, subject, description, total_marks, passing_marks, time_limit_minutes, is_active, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, exam.getTitle());
            ps.setString(2, exam.getSubject());
            ps.setString(3, exam.getDescription());
            ps.setInt(4, exam.getTotalMarks());
            ps.setInt(5, exam.getPassingMarks());
            ps.setInt(6, exam.getTimeLimitMinutes());
            ps.setBoolean(7, exam.isActive());
            ps.setInt(8, exam.getCreatedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
    }

    public boolean updateExam(Exam exam) {
        String sql = "UPDATE exams SET title=?, subject=?, description=?, total_marks=?, passing_marks=?, time_limit_minutes=?, is_active=? WHERE id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, exam.getTitle());
            ps.setString(2, exam.getSubject());
            ps.setString(3, exam.getDescription());
            ps.setInt(4, exam.getTotalMarks());
            ps.setInt(5, exam.getPassingMarks());
            ps.setInt(6, exam.getTimeLimitMinutes());
            ps.setBoolean(7, exam.isActive());
            ps.setInt(8, exam.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
    }

    public boolean deleteExam(int id) {
        String sql = "DELETE FROM exams WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
    }

    public boolean hasAttempts(int examId) {
        String sql = "SELECT COUNT(*) FROM results WHERE exam_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, examId);
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

    public int getTotalExams() {
        String sql = "SELECT COUNT(*) FROM exams";
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

    public boolean hasUserAttemptedExam(int userId, int examId) {
        String sql = "SELECT COUNT(*) FROM results WHERE user_id = ? AND exam_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    private Exam extractExam(ResultSet rs) throws SQLException {
        Exam exam = new Exam();
        exam.setId(rs.getInt("id"));
        exam.setTitle(rs.getString("title"));
        exam.setSubject(rs.getString("subject"));
        exam.setDescription(rs.getString("description"));
        exam.setTotalMarks(rs.getInt("total_marks"));
        exam.setPassingMarks(rs.getInt("passing_marks"));
        exam.setTimeLimitMinutes(rs.getInt("time_limit_minutes"));
        exam.setActive(rs.getBoolean("is_active"));
        exam.setCreatedBy(rs.getInt("created_by"));
        exam.setCreatedAt(rs.getTimestamp("created_at"));
        return exam;
    }
}
