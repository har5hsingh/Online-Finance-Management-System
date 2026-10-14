
package com.financeflow.web;

import com.financeflow.model.Account;
import com.financeflow.dao.GoalDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/goals")
public class GoalServlet extends HttpServlet {
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
            req.setAttribute("goals", new GoalDAO().getByUser(a.getId()));
            req.getRequestDispatcher("/goals.jsp").forward(req, resp);
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
            String description = req.getParameter("description");
            String amountText = req.getParameter("target");
            String dateText = req.getParameter("deadline");
            if (description == null || description.trim().isEmpty()
                    || description.length() > 200)
                throw new IllegalArgumentException();
            BigDecimal target = new BigDecimal(amountText);
            if (target.compareTo(BigDecimal.ZERO) <= 0)
                throw new IllegalArgumentException();
            LocalDate deadline = (dateText == null || dateText.isBlank())
                ? null : LocalDate.parse(dateText);
            new GoalDAO().add(a.getId(), description.trim(), target, deadline);
            resp.sendRedirect(req.getContextPath() + "/goals");
        } catch (Exception e) {
            req.setAttribute("error", "Enter a valid description, target, and deadline.");
            doGet(req, resp);
        }
    }
}
