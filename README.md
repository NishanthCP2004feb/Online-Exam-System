# Online Exam Portal

Java Servlet/JSP web application for creating exams, attempting timed assessments, and viewing results.

## Features

- Student registration and login
- Admin dashboard with exam and result management
- Timed exams with automatic submission
- Instant result generation with score breakdown
- Question management with add, edit, and delete flows
- Protection against changing exam/question content after attempts exist

## Project Structure

- `src/`: Java source files
- `web/`: JSP pages, static assets, and deployable web resources
- `sql/schema.sql`: database schema and sample seed data
- `build.ps1`: local compilation script for `web/WEB-INF/classes`
- `run.ps1`: build, deploy, and start helper for the local XAMPP setup

## Requirements

- Java 17+ (tested locally with Java 25)
- MySQL 8+
- Servlet container compatible with `javax.servlet` 3.1+, such as Tomcat 8.5 or 9

## Database Setup

1. Create the database objects by running [`sql/schema.sql`](C:/N_VsCode/N_projects/Advance Java Project 2/sql/schema.sql).
2. Update database settings if needed using either environment variables or JVM system properties.

Environment variables:

- `EXAM_PORTAL_DB_URL`
- `EXAM_PORTAL_DB_USERNAME`
- `EXAM_PORTAL_DB_PASSWORD`

Equivalent JVM properties:

- `-Dexam.portal.db.url=...`
- `-Dexam.portal.db.username=...`
- `-Dexam.portal.db.password=...`

Default connection values are:

- URL: `jdbc:mysql://localhost:3306/online_exam_portal?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC`
- Username: `root`
- Password: empty

## Build

Run from the project root:

```powershell
.\build.ps1
```

This compiles all Java sources into `web/WEB-INF/classes`.

## Run Locally

For the XAMPP layout available on this machine:

```powershell
.\run.ps1
```

This script:

- compiles the source
- deploys `web/` into `C:\xampp\tomcat\webapps\examportal`
- starts MySQL if port `3306` is not already listening
- starts Tomcat if port `8080` is not already listening
- verifies `http://localhost:8080/examportal/`

Optional database initialization:

```powershell
.\run.ps1 -InitDb
```

## Deploy

1. Copy the `web/` folder contents into your servlet container webapp directory, or package them as a WAR in your preferred IDE.
2. Ensure `web/WEB-INF/lib/mysql-connector-j-8.4.0.jar` is included in the deployed app.
3. Start Tomcat and open the application context in a browser.

## Sample Accounts

- Admin: `admin` / `admin123`
- Student: `student1` / `student123`

## Notes

- The application stores passwords with PBKDF2 hashes and transparently upgrades legacy plain-text rows on successful login.
- The application now stores detailed answer correctness in `user_answers`.
- Once students attempt an exam, the app locks edits/deletions for that exam's questions and exam definition to preserve result integrity.
- The repository does not include an IDE project file or Maven/Gradle build; `build.ps1` covers local compilation in this workspace.
