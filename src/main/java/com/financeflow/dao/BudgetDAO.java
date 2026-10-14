
package com.financeflow.dao;

import com.financeflow.config.Database;
import java.sql.*;
import java.math.BigDecimal;
import java.util.*;

public class BudgetDAO {
    public void add(int userId, String category, BigDecimal amount)
            throws SQLException {
        String sql = "INSERT INTO budgets(user_id,category,limit_amount) VALUES(?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            p.setString(2, category);
            p.setBigDecimal(3, amount);
            p.executeUpdate();
        }
    }

    public List<Map<String,Object>> getByUser(int userId) throws SQLException {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM budgets WHERE user_id=? ORDER BY id DESC";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Map<String,Object> m = new LinkedHashMap<>();
                    m.put("id", r.getInt("id"));
                    m.put("category", r.getString("category"));
                    m.put("amount", r.getBigDecimal("limit_amount"));
                    m.put("period", r.getString("period_name"));
                    list.add(m);
                }
            }
        }
        return list;
    }
}
