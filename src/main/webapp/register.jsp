
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register | FinanceFlow</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="auth-card">
    <h1>Create Account</h1>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="<%=request.getContextPath()%>/register" method="post">
        <label>Full name</label>
        <input type="text" name="name" maxlength="100" required>
        <label>Email</label>
        <input type="email" name="email" maxlength="150" required>
        <label>Password (8–72 characters)</label>
        <input type="password" name="password" minlength="8" maxlength="72" required>
        <button type="submit">Register</button>
    </form>
    <p>Already registered? <a href="<%=request.getContextPath()%>/login.jsp">Log in</a></p>
</div>
</body>
</html>
