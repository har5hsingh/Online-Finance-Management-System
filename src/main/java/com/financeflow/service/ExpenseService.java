
package com.financeflow.service;

import com.financeflow.dao.ExpenseDAO;
import java.math.BigDecimal;
import java.time.LocalDate;

public class ExpenseService {
    private final ExpenseDAO dao = new ExpenseDAO();

    public void addExpense(int userId, String title, String category,
                           String amountText, String dateText) throws Exception {
        if (title == null || title.trim().isEmpty() || title.length() > 100)
            throw new IllegalArgumentException("Enter a valid title (max 100 characters).");
        if (category == null || category.trim().isEmpty() || category.length() > 50)
            throw new IllegalArgumentException("Enter a valid category (max 50 characters).");

        BigDecimal amount;
        LocalDate date;
        try {
            amount = new BigDecimal(amountText);
            date = LocalDate.parse(dateText);
        } catch (Exception e) {
            throw new IllegalArgumentException("Enter a valid amount and date.");
        }

        if (amount.compareTo(BigDecimal.ZERO) <= 0)
            throw new IllegalArgumentException("Amount must be greater than zero.");

        dao.add(userId, title.trim(), category.trim(), amount, date);
    }
}
