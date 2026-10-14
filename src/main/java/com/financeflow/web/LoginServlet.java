
package com.financeflow.web;

import com.financeflow.dao.UserDAO;
import com.financeflow.model.Account;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Account account = new UserDAO().login(
                email == null ? "" : email,
                password == null ? "" : password
            );

            if (account == null) {
                req.setAttribute("error", "Invalid credentials or disabled account.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            req.changeSessionId();
            session.setAttribute("account", account);

            if ("ADMIN".equals(account.getAccountType()))
                resp.sendRedirect(req.getContextPath() + "/admin");
            else
                resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (Exception e) {
            throw new ServletException("Login failed.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
