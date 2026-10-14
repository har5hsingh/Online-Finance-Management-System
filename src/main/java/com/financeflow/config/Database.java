
package com.financeflow.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {

    private static final String URL = getDatabaseUrl();
    private static final String USERNAME =
            requiredEnvironmentVariable("FINANCEFLOW_DB_USER");
    private static final String PASSWORD =
            requiredEnvironmentVariable("FINANCEFLOW_DB_PASSWORD");

    private static String getDatabaseUrl() {
        String url = System.getenv("FINANCEFLOW_DB_URL");

        if (url == null || url.isBlank()) {
            return "jdbc:mysql://localhost:3306/financeflow";
        }

        return url;
    }

    private static String requiredEnvironmentVariable(String name) {
        String value = System.getenv(name);

        if (value == null || value.isBlank()) {
            throw new IllegalStateException(
                    "Missing required environment variable: " + name
            );
        }

        return value;
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}