
package com.financeflow.web;

import com.financeflow.model.Account;
import com.financeflow.dao.BudgetDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/budgets")
public class BudgetServlet extends HttpServlet {
    private Account user(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession s = req.getSession(false);
        Object o = s == null ? null : s.getAttribute("account");
        if (!(o instanceof Account) ||
                !"USER".equals(((Account)o).getAccountType())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        return (Account)o;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account a = user(req, resp);
        if (a == null) return;
        try {
            req.setAttribute("budgets", new BudgetDAO().getByUser(a.getId()));
            req.getRequestDispatcher("/budgets.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account a = user(req, resp);
        if (a == null) return;
        try {
            String category = req.getParameter("category");
            BigDecimal amount = new BigDecimal(req.getParameter("amount"));
            if (category == null || category.trim().isEmpty()
                    || category.length() > 50
                    || amount.compareTo(BigDecimal.ZERO) <= 0)
                throw new IllegalArgumentException("Enter a category and positive amount.");
            new BudgetDAO().add(a.getId(), category.trim(), amount);
            resp.sendRedirect(req.getContextPath() + "/budgets");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Enter a valid category and positive amount.");
            doGet(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
