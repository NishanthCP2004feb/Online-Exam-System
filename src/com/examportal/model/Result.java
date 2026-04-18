package com.examportal.model;

import java.sql.Timestamp;

public class Result {
    private int id;
    private int userId;
    private int examId;
    private int score;
    private int totalMarks;
    private int totalQuestions;
    private int correctAnswers;
    private int wrongAnswers;
    private int unanswered;
    private boolean passed;
    private int timeTakenSeconds;
    private Timestamp attemptedAt;

    // Transient fields for display
    private String examTitle;
    private String examSubject;
    private String studentName;
    private String studentUsername;

    public Result() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }

    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }

    public int getCorrectAnswers() { return correctAnswers; }
    public void setCorrectAnswers(int correctAnswers) { this.correctAnswers = correctAnswers; }

    public int getWrongAnswers() { return wrongAnswers; }
    public void setWrongAnswers(int wrongAnswers) { this.wrongAnswers = wrongAnswers; }

    public int getUnanswered() { return unanswered; }
    public void setUnanswered(int unanswered) { this.unanswered = unanswered; }

    public boolean isPassed() { return passed; }
    public void setPassed(boolean passed) { this.passed = passed; }

    public int getTimeTakenSeconds() { return timeTakenSeconds; }
    public void setTimeTakenSeconds(int timeTakenSeconds) { this.timeTakenSeconds = timeTakenSeconds; }

    public Timestamp getAttemptedAt() { return attemptedAt; }
    public void setAttemptedAt(Timestamp attemptedAt) { this.attemptedAt = attemptedAt; }

    public String getExamTitle() { return examTitle; }
    public void setExamTitle(String examTitle) { this.examTitle = examTitle; }

    public String getExamSubject() { return examSubject; }
    public void setExamSubject(String examSubject) { this.examSubject = examSubject; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentUsername() { return studentUsername; }
    public void setStudentUsername(String studentUsername) { this.studentUsername = studentUsername; }

    public double getPercentage() {
        if (totalMarks == 0) return 0;
        return Math.round((score * 100.0 / totalMarks) * 100.0) / 100.0;
    }

    public String getTimeTakenFormatted() {
        int mins = timeTakenSeconds / 60;
        int secs = timeTakenSeconds % 60;
        return String.format("%02d:%02d", mins, secs);
    }
}
