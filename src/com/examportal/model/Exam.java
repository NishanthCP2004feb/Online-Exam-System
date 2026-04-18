package com.examportal.model;

import java.sql.Timestamp;

public class Exam {
    private int id;
    private String title;
    private String subject;
    private String description;
    private int totalMarks;
    private int passingMarks;
    private int timeLimitMinutes;
    private boolean isActive;
    private int createdBy;
    private Timestamp createdAt;
    
    // Transient fields (not directly in DB)
    private int questionCount;
    private int attemptCount;

    public Exam() {}

    public Exam(String title, String subject, String description, int totalMarks, 
                int passingMarks, int timeLimitMinutes) {
        this.title = title;
        this.subject = subject;
        this.description = description;
        this.totalMarks = totalMarks;
        this.passingMarks = passingMarks;
        this.timeLimitMinutes = timeLimitMinutes;
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }

    public int getPassingMarks() { return passingMarks; }
    public void setPassingMarks(int passingMarks) { this.passingMarks = passingMarks; }

    public int getTimeLimitMinutes() { return timeLimitMinutes; }
    public void setTimeLimitMinutes(int timeLimitMinutes) { this.timeLimitMinutes = timeLimitMinutes; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }
}
