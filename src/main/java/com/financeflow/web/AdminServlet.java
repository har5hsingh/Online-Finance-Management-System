
package com.financeflow.web;

import com.financeflow.model.Account;
import com.financeflow.dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private boolean authorized(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession s = req.getSession(false);
        Object o = s == null ? null : s.getAttribute("account");
        if (o instanceof Account &&
                "ADMIN".equals(((Account)o).getAccountType())) return true;
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!authorized(req, resp)) return;
        try {
            req.setAttribute("users", new UserDAO().getAllUsers());
            req.getRequestDispatcher("/admin.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!authorized(req, resp)) return;
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status");
            new UserDAO().setUserStatus(id, status);
            resp.sendRedirect(req.getContextPath() + "/admin");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
