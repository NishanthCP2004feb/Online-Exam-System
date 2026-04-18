package com.examportal.dao;

import com.examportal.model.Result;
import com.examportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResultDAO {

    public int saveResult(Result result, Map<Integer, String> userAnswers) {
        String resultSql = "INSERT INTO results (user_id, exam_id, score, total_marks, total_questions, correct_answers, wrong_answers, unanswered, passed, time_taken_seconds) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String answerSql = "INSERT INTO user_answers (result_id, question_id, selected_option, is_correct) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement psResult = null;
        PreparedStatement psAnswer = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transaction start
            
            // Save result
            psResult = conn.prepareStatement(resultSql, Statement.RETURN_GENERATED_KEYS);
            psResult.setInt(1, result.getUserId());
            psResult.setInt(2, result.getExamId());
            psResult.setInt(3, result.getScore());
            psResult.setInt(4, result.getTotalMarks());
            psResult.setInt(5, result.getTotalQuestions());
            psResult.setInt(6, result.getCorrectAnswers());
            psResult.setInt(7, result.getWrongAnswers());
            psResult.setInt(8, result.getUnanswered());
            psResult.setBoolean(9, result.isPassed());
            psResult.setInt(10, result.getTimeTakenSeconds());
            psResult.executeUpdate();
            
            // Get generated result ID
            generatedKeys = psResult.getGeneratedKeys();
            int resultId = 0;
            if (generatedKeys.next()) {
                resultId = generatedKeys.getInt(1);
            }
            
            // Save user answers
            if (resultId > 0 && userAnswers != null) {
                Map<Integer, String> correctOptions = getCorrectOptions(conn, userAnswers.keySet());
                psAnswer = conn.prepareStatement(answerSql);
                for (Map.Entry<Integer, String> entry : userAnswers.entrySet()) {
                    String selectedOption = entry.getValue();
                    String correctOption = correctOptions.get(entry.getKey());
                    psAnswer.setInt(1, resultId);
                    psAnswer.setInt(2, entry.getKey()); // question_id
                    if (selectedOption == null) {
                        psAnswer.setNull(3, Types.CHAR);
                    } else {
                        psAnswer.setString(3, selectedOption);
                    }
                    psAnswer.setBoolean(4, selectedOption != null && selectedOption.equalsIgnoreCase(correctOption));
                    psAnswer.addBatch();
                }
                psAnswer.executeBatch();
            }
            
            conn.commit(); // Transaction commit
            return resultId;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return 0;
        } finally {
            try { if (generatedKeys != null) generatedKeys.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psAnswer != null) psAnswer.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psResult != null) psResult.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            }
            DBConnection.closeConnection(conn);
        }
    }

    public List<Result> getResultsByUserId(int userId) {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT r.*, e.title as exam_title, e.subject as exam_subject " +
                     "FROM results r JOIN exams e ON r.exam_id = e.id " +
                     "WHERE r.user_id = ? ORDER BY r.attempted_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Result result = extractResult(rs);
                result.setExamTitle(rs.getString("exam_title"));
                result.setExamSubject(rs.getString("exam_subject"));
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return results;
    }

    public List<Result> getAllResults() {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT r.*, e.title as exam_title, e.subject as exam_subject, u.full_name as student_name, u.username as student_username " +
                     "FROM results r " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "ORDER BY r.attempted_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Result result = extractResult(rs);
                result.setExamTitle(rs.getString("exam_title"));
                result.setExamSubject(rs.getString("exam_subject"));
                result.setStudentName(rs.getString("student_name"));
                result.setStudentUsername(rs.getString("student_username"));
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return results;
    }

    public Result getResultById(int id) {
        String sql = "SELECT r.*, e.title as exam_title, e.subject as exam_subject, u.full_name as student_name, u.username as student_username " +
                     "FROM results r " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Result result = extractResult(rs);
                result.setExamTitle(rs.getString("exam_title"));
                result.setExamSubject(rs.getString("exam_subject"));
                result.setStudentName(rs.getString("student_name"));
                result.setStudentUsername(rs.getString("student_username"));
                return result;
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

    public int getTotalAttempts() {
        String sql = "SELECT COUNT(*) FROM results";
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

    public double getAverageScore() {
        String sql = "SELECT AVG(score * 100.0 / total_marks) FROM results";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return Math.round(rs.getDouble(1) * 100.0) / 100.0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    private Result extractResult(ResultSet rs) throws SQLException {
        Result result = new Result();
        result.setId(rs.getInt("id"));
        result.setUserId(rs.getInt("user_id"));
        result.setExamId(rs.getInt("exam_id"));
        result.setScore(rs.getInt("score"));
        result.setTotalMarks(rs.getInt("total_marks"));
        result.setTotalQuestions(rs.getInt("total_questions"));
        result.setCorrectAnswers(rs.getInt("correct_answers"));
        result.setWrongAnswers(rs.getInt("wrong_answers"));
        result.setUnanswered(rs.getInt("unanswered"));
        result.setPassed(rs.getBoolean("passed"));
        result.setTimeTakenSeconds(rs.getInt("time_taken_seconds"));
        result.setAttemptedAt(rs.getTimestamp("attempted_at"));
        return result;
    }

    private Map<Integer, String> getCorrectOptions(Connection conn, java.util.Set<Integer> questionIds) throws SQLException {
        Map<Integer, String> correctOptions = new HashMap<>();
        if (questionIds == null || questionIds.isEmpty()) {
            return correctOptions;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < questionIds.size(); i++) {
            if (i > 0) {
                placeholders.append(", ");
            }
            placeholders.append("?");
        }

        String sql = "SELECT id, correct_option FROM questions WHERE id IN (" + placeholders + ")";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            int index = 1;
            for (Integer questionId : questionIds) {
                ps.setInt(index++, questionId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                correctOptions.put(rs.getInt("id"), rs.getString("correct_option"));
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return correctOptions;
    }
}
