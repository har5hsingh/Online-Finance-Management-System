
package com.financeflow.web;

import java.io.IOException;

import com.financeflow.dao.BudgetDAO;
import com.financeflow.dao.ExpenseDAO;
import com.financeflow.dao.GoalDAO;
import com.financeflow.model.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Object obj = session == null
                ? null
                : session.getAttribute("account");

        if (!(obj instanceof Account)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Account account = (Account) obj;

        if (!"USER".equals(account.getAccountType())) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        try {
            int id = account.getId();
            ExpenseDAO expenseDAO = new ExpenseDAO();

            req.setAttribute("account", account);
            req.setAttribute("totalExpenses", expenseDAO.getTotal(id));
            req.setAttribute("expenses", expenseDAO.getByUser(id));
            req.setAttribute("budgets", new BudgetDAO().getByUser(id));
            req.setAttribute("goals", new GoalDAO().getByUser(id));

            // Data used by the dashboard charts.
            req.setAttribute("categoryTotals",
                    expenseDAO.getCategoryTotals(id));

            req.setAttribute("monthlyTotals",
                    expenseDAO.getMonthlyTotals(id));

            req.getRequestDispatcher("/dashboard.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load dashboard.", e);
        }
    }
}