
package com.financeflow.dao;

import com.financeflow.config.Database;
import com.financeflow.model.Account;
import com.financeflow.model.AdminAccount;
import com.financeflow.model.UserAccount;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.*;

public class UserDAO {
    public void register(String name, String email, String password)
            throws SQLException {
        String sql = "INSERT INTO users(full_name,email,password_hash) VALUES(?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, name.trim());
            p.setString(2, email.trim().toLowerCase());
            p.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
            p.executeUpdate();
        }
    }

    public Account login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, email.trim().toLowerCase());
            try (ResultSet r = p.executeQuery()) {
                if (!r.next() || !"ACTIVE".equals(r.getString("status"))
                    || !BCrypt.checkpw(password, r.getString("password_hash"))) {
                    return null;
                }
                int id = r.getInt("id");
                String name = r.getString("full_name");
                String mail = r.getString("email");
                return "ADMIN".equals(r.getString("role"))
                    ? new AdminAccount(id, name, mail)
                    : new UserAccount(id, name, mail);
            }
        }
    }

    public List<String[]> getAllUsers() throws SQLException {
        List<String[]> users = new ArrayList<>();
        String sql = "SELECT id,full_name,email,role,status FROM users ORDER BY id";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet r = p.executeQuery()) {
            while (r.next()) {
                users.add(new String[]{
                    r.getString("id"), r.getString("full_name"),
                    r.getString("email"), r.getString("role"),
                    r.getString("status")
                });
            }
        }
        return users;
    }

    public void setUserStatus(int id, String status) throws SQLException {
        if (!status.equals("ACTIVE") && !status.equals("DISABLED"))
            throw new IllegalArgumentException("Invalid status");
        String sql = "UPDATE users SET status=? WHERE id=? AND role='USER'";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, status);
            p.setInt(2, id);
            p.executeUpdate();
        }
    }

    public void promoteToAdmin(String email) throws SQLException {
        String sql = "UPDATE users SET role='ADMIN' WHERE email=?";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, email.trim().toLowerCase());
            p.executeUpdate();
        }
    }
}
