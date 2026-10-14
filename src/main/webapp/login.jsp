
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login | FinanceFlow</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="auth-card">
    <h1>FinanceFlow</h1>
    <p>Manage your money with confidence.</p>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if ("1".equals(request.getParameter("registered"))) { %>
        <p class="success">Registration successful. Please log in.</p>
    <% } %>

    <form action="<%=request.getContextPath()%>/login" method="post">
        <label>Email</label>
        <input type="email" name="email" required>
        <label>Password</label>
        <input type="password" name="password" required>
        <button type="submit">Log In</button>
    </form>
    <p>New here? <a href="<%=request.getContextPath()%>/register.jsp">Create an account</a></p>
</div>
</body>
</html>
