
package com.financeflow.web;

import com.financeflow.dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (name == null || name.trim().isEmpty() || name.length() > 100
                || email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || password == null || password.length() < 8
                || password.length() > 72) {
            req.setAttribute("error", "Enter a valid name, email, and password (8–72 characters).");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            new UserDAO().register(name, email, password);
            resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=1");
        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                req.setAttribute("error", "That email address is already registered.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            } else {
                throw new ServletException("Registration failed.", e);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/register.jsp");
    }
}
