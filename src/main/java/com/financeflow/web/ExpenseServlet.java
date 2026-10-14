
package com.financeflow.web;

import com.financeflow.model.Account;
import com.financeflow.dao.ExpenseDAO;
import com.financeflow.service.ExpenseService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {
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
            req.setAttribute("expenses", new ExpenseDAO().getByUser(a.getId()));
            req.getRequestDispatcher("/expenses.jsp").forward(req, resp);
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
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                new ExpenseDAO().delete(id, a.getId());
            } else {
                new ExpenseService().addExpense(
                    a.getId(), req.getParameter("title"),
                    req.getParameter("category"), req.getParameter("amount"),
                    req.getParameter("date")
                );
            }
            resp.sendRedirect(req.getContextPath() + "/expenses");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        } catch (Exception e) {
            throw new ServletException("Expense operation failed.", e);
        }
    }
}
