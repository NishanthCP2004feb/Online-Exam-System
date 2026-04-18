-- ============================================
-- Online Exam Portal - Database Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS online_exam_portal;
USE online_exam_portal;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin') DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Exams Table
CREATE TABLE IF NOT EXISTS exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    description TEXT,
    total_marks INT NOT NULL DEFAULT 100,
    passing_marks INT NOT NULL DEFAULT 40,
    time_limit_minutes INT NOT NULL DEFAULT 30,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 3. Questions Table (MCQ with 4 options)
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    marks INT NOT NULL DEFAULT 1,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- 4. Results Table
CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    exam_id INT NOT NULL,
    score INT NOT NULL,
    total_marks INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    wrong_answers INT NOT NULL,
    unanswered INT NOT NULL DEFAULT 0,
    passed BOOLEAN NOT NULL,
    time_taken_seconds INT,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

-- 5. User Answers Table (for detailed review)
CREATE TABLE IF NOT EXISTS user_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    result_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option CHAR(1),
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (result_id) REFERENCES results(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- ============================================
-- Sample Data
-- ============================================

-- Admin user (password: admin123)
INSERT INTO users (username, full_name, email, password, role) VALUES 
('admin', 'System Administrator', 'admin@examportal.com', 'pbkdf2$65536$35wlarOHDdjk791ouO8rsg==$JE4+lkOoI6yk8vHUY6mK9RoqrfNr2IwC5pb+gAnNidg=', 'admin');

-- Sample student (password: student123)
INSERT INTO users (username, full_name, email, password, role) VALUES 
('student1', 'Rahul Sharma', 'rahul@student.com', 'pbkdf2$65536$CTZ5H/9dyqGFv8I67zSeGA==$WZtFr0dzQPZwg5UxiBb0LRTI3ee42Hl2dqBdG6bfLPI=', 'student');

-- Sample Exam 1: Java Programming
INSERT INTO exams (title, subject, description, total_marks, passing_marks, time_limit_minutes, is_active, created_by) VALUES
('Java Programming Fundamentals', 'Java', 'Test your knowledge of core Java concepts including OOP, collections, and exception handling.', 50, 20, 15, TRUE, 1);

-- Questions for Java Exam
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(1, 'Which of the following is NOT a primitive data type in Java?', 'int', 'boolean', 'String', 'char', 'C', 5),
(1, 'What is the default value of a boolean variable in Java?', 'true', 'false', 'null', '0', 'B', 5),
(1, 'Which keyword is used to inherit a class in Java?', 'implements', 'extends', 'inherits', 'super', 'B', 5),
(1, 'Which collection class allows duplicate elements?', 'HashSet', 'TreeSet', 'ArrayList', 'LinkedHashSet', 'C', 5),
(1, 'What is the size of int data type in Java?', '2 bytes', '4 bytes', '8 bytes', '16 bytes', 'B', 5),
(1, 'Which method is called when an object is created?', 'main()', 'start()', 'constructor', 'init()', 'C', 5),
(1, 'What does JVM stand for?', 'Java Variable Machine', 'Java Virtual Machine', 'Java Visual Machine', 'Java Verified Machine', 'B', 5),
(1, 'Which of these is a checked exception?', 'ArithmeticException', 'NullPointerException', 'IOException', 'ArrayIndexOutOfBoundsException', 'C', 5),
(1, 'What is the parent class of all classes in Java?', 'Main', 'Base', 'Object', 'Class', 'C', 5),
(1, 'Which access modifier makes a member accessible only within the same class?', 'public', 'protected', 'default', 'private', 'D', 5);

-- Sample Exam 2: DBMS
INSERT INTO exams (title, subject, description, total_marks, passing_marks, time_limit_minutes, is_active, created_by) VALUES
('Database Management Systems', 'DBMS', 'Evaluate your understanding of database concepts, SQL, normalization, and transactions.', 40, 16, 10, TRUE, 1);

-- Questions for DBMS Exam
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(2, 'Which SQL command is used to retrieve data from a database?', 'GET', 'SELECT', 'RETRIEVE', 'FETCH', 'B', 5),
(2, 'What does ACID stand for in database transactions?', 'Atomicity, Consistency, Isolation, Durability', 'Addition, Consistency, Isolation, Data', 'Atomicity, Concurrency, Isolation, Durability', 'Atomicity, Consistency, Integration, Durability', 'A', 5),
(2, 'Which normal form eliminates transitive dependency?', 'First Normal Form', 'Second Normal Form', 'Third Normal Form', 'BCNF', 'C', 5),
(2, 'What is a primary key?', 'A key that can have NULL values', 'A key that uniquely identifies each record', 'A foreign reference key', 'An index key', 'B', 5),
(2, 'Which JOIN returns all rows from both tables?', 'INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN', 'D', 5),
(2, 'What is normalization?', 'Adding redundancy', 'Removing redundancy', 'Creating indexes', 'Joining tables', 'B', 5),
(2, 'Which command is used to delete a table?', 'DELETE', 'REMOVE', 'DROP', 'TRUNCATE', 'C', 5),
(2, 'What is a foreign key?', 'Primary key of the same table', 'A key that references the primary key of another table', 'A unique key', 'An auto-increment key', 'B', 5);

-- Sample Exam 3: Computer Networks
INSERT INTO exams (title, subject, description, total_marks, passing_marks, time_limit_minutes, is_active, created_by) VALUES
('Computer Networks Basics', 'Networking', 'Assessment covering OSI model, TCP/IP, protocols, and network fundamentals.', 30, 12, 8, TRUE, 1);

-- Questions for Networking Exam
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES
(3, 'How many layers are in the OSI model?', '5', '6', '7', '4', 'C', 5),
(3, 'Which protocol is used to send email?', 'FTP', 'SMTP', 'HTTP', 'SNMP', 'B', 5),
(3, 'What is the full form of TCP?', 'Transfer Control Protocol', 'Transmission Control Protocol', 'Transport Control Protocol', 'Total Control Protocol', 'B', 5),
(3, 'Which device operates at the Network layer?', 'Hub', 'Switch', 'Router', 'Repeater', 'C', 5),
(3, 'What is the default port number for HTTP?', '21', '25', '80', '443', 'C', 5),
(3, 'Which IP address class supports the maximum number of hosts?', 'Class A', 'Class B', 'Class C', 'Class D', 'A', 5);
