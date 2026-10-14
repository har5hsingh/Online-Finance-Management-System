# FinanceFlow — Online Finance Management System

FinanceFlow is a Java-based web application for managing personal finances. It allows users to track expenses, manage budgets, monitor savings goals, and view spending summaries. Administrators can manage user accounts through a separate admin panel.

## Features

* User registration and login
* Secure password hashing using BCrypt
* Role-based access for users and administrators
* Expense management
* Expense summaries and spending charts
* Budget creation and management
* Savings goal creation and tracking
* Admin dashboard and user management
* Account activation and disabling
* MySQL database connectivity

## Technology Stack

* Java 17
* Maven
* JSP and Jakarta Servlets
* Apache Tomcat 10.1
* MySQL 8.x
* JDBC and MySQL Connector/J
* HTML and CSS
* BCrypt password hashing

## Prerequisites

Install the following software before running the project:

1. JDK 17
2. Apache Maven
3. MySQL Server 8.x
4. Apache Tomcat 10.1
5. Git

Verify Java and Maven are available:

```bash
java -version
mvn -version
```

## Project Structure

```text
Online Finance Management System/
├── database/
│   └── schema.sql
├── src/
│   └── main/
│       ├── java/
│       └── webapp/
├── pom.xml
└── README.md
```

The application source code, JSP pages, configuration files, and other resources are maintained under `src/main/`. The database schema is provided in `database/schema.sql`.

## 1. Clone the Repository

Clone the repository from GitHub:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate to the project directory:

```bash
cd "YOUR_PROJECT_FOLDER"
```

Replace the example repository URL and folder name with the actual values.

## 2. Configure MySQL

Start MySQL and log in using an account with permission to create databases and users:

```bash
mysql -u root -p
```

Create the database and application account. Replace `CHOOSE_A_STRONG_LOCAL_PASSWORD` with a password of your choice.

```sql
CREATE DATABASE IF NOT EXISTS financeflow;

CREATE USER 'financeflow_app'@'localhost'
IDENTIFIED BY 'CHOOSE_A_STRONG_LOCAL_PASSWORD';

GRANT SELECT, INSERT, UPDATE, DELETE
ON financeflow.*
TO 'financeflow_app'@'localhost';
```

If the application account already exists, update its password instead of running `CREATE USER` again.

Exit the MySQL prompt:

```sql
EXIT;
```

Import the database schema from the project root:

```bash
mysql -u root -p < database/schema.sql
```

The schema creates the tables required by the application.

## 3. Configure Database Credentials

Configure the following environment variables before starting Tomcat:

* `FINANCEFLOW_DB_URL`: `jdbc:mysql://localhost:3306/financeflow`
* `FINANCEFLOW_DB_USER`: `financeflow_app`
* `FINANCEFLOW_DB_PASSWORD`: the local MySQL application-account password

On macOS or Linux, open a terminal and run:

```bash
export FINANCEFLOW_DB_URL='jdbc:mysql://localhost:3306/financeflow'
export FINANCEFLOW_DB_USER='financeflow_app'
export FINANCEFLOW_DB_PASSWORD='YOUR_LOCAL_DATABASE_PASSWORD'
```

Replace the password placeholder with the password chosen in Step 2.

These variables must be available to the Tomcat process. If Tomcat is launched from another terminal or through an IDE, configure the variables in that launch environment too.

Do not commit real database passwords or private configuration files to GitHub.

## 4. Build the Application

From the project root, run:

```bash
mvn clean package
```

After a successful build, Maven creates the WAR file:

```text
target/FinanceFlow.war
```

If the build fails, review the Maven error message and verify the Java and Maven installations.

## 5. Deploy to Apache Tomcat

Copy the generated WAR file into the Tomcat `webapps` directory:

```bash
cp target/FinanceFlow.war /PATH/TO/TOMCAT/webapps/
```

Replace `/PATH/TO/TOMCAT` with the actual Tomcat installation directory.

Start Tomcat:

```bash
/PATH/TO/TOMCAT/bin/startup.sh
```

On Windows, use the corresponding `bin\startup.bat` script.

Open the application in a browser:

http://localhost:8080/FinanceFlow/

If the application does not load, check the Tomcat logs and verify that the WAR file was deployed successfully.

## 6. Create an Administrator Account

For a fresh database, register a user through the application's registration page.

Then log in to MySQL and promote that account to administrator:

```sql
USE financeflow;

UPDATE users
SET role = 'ADMIN'
WHERE email = 'your_registered_email@example.com';
```

Use the exact email address of the registered account. Verify that one row was updated and that the account is active:

```sql
SELECT id, full_name, email, role, status
FROM users;
```

Log in using that account. The application should redirect administrators to the admin panel and regular users to the user dashboard.

Never share administrator credentials publicly.

## Troubleshooting

**MySQL access denied**

* Verify the database username and password.
* Confirm the environment variables are available to Tomcat.
* Check that the MySQL user has the required privileges.

**Unknown database or missing table**

* Confirm that `financeflow` exists.
* Import `database/schema.sql`.
* Verify the table names against the application's DAO queries.

**HTTP 404**

* Confirm that Tomcat is running.
* Verify that `FinanceFlow.war` deployed successfully.
* Check that the URL uses the correct application context path.

**HTTP 500**

* Inspect the Tomcat logs for the underlying exception.
* Check the database configuration and schema.
* Verify that all Maven dependencies are included in the WAR.

**Admin login fails**

* Confirm that the account has `role = 'ADMIN'` and `status = 'ACTIVE'`.
* Verify that the account password was created through the application's registration process.

## Security Notes

* Do not commit passwords, database credentials, or personal data.
* Use a separate local MySQL account for the application.
* Use test data when demonstrating the project.
* Use strong passwords and restrict administrator access.
* Configure production credentials securely before any public deployment.

## License

This project was developed for academic purposes. Add a license if you intend to distribute it under specific reuse terms.
