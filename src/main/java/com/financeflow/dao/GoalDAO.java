
package com.financeflow.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.financeflow.config.Database;

public class GoalDAO {
    public void add(int userId, String description, BigDecimal target,
                    LocalDate deadline) throws SQLException {
        String sql = "INSERT INTO goals(user_id,description,target_amount,deadline) VALUES(?,?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            p.setString(2, description);
            p.setBigDecimal(3, target);
            if (deadline == null) p.setNull(4, Types.DATE);
            else p.setDate(4, java.sql.Date.valueOf(deadline));
            p.executeUpdate();
        }
    }

    public List<Map<String,Object>> getByUser(int userId) throws SQLException {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM goals WHERE user_id=? ORDER BY id DESC";
        try (Connection c = Database.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Map<String,Object> m = new LinkedHashMap<>();
                    m.put("id", r.getInt("id"));
                    m.put("description", r.getString("description"));
                    m.put("target", r.getBigDecimal("target_amount"));
                    m.put("saved", r.getBigDecimal("saved_amount"));
                    m.put("deadline", r.getDate("deadline"));
                    list.add(m);
                }
            }
        }
        return list;
    }
}
