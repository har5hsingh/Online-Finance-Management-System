
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%!
private String esc(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Expenses | FinanceFlow</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
<style>
.page-intro { margin:12px 0 25px; color:#586b82; font-size:16px; max-width:780px; }
.info-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(210px,1fr)); gap:15px; margin:20px 0; }
.info-box { padding:18px; background:#e8f3fb; border:1px solid #d2e5f4; border-radius:12px; }
.info-box h3 { margin:0 0 7px; color:#173e62; }
.info-box p { margin:0; font-size:14px; }
.tip { padding:17px 20px; border-left:4px solid #087f78; border-radius:8px; background:#e4f5f0; margin:20px 0; }
.tip strong { color:#075e58; }
@media(max-width:600px) { .info-grid { grid-template-columns:1fr; } }
</style>
</head>
<body>

<nav>
<a class="brand" href="<%=request.getContextPath()%>/dashboard">FinanceFlow</a>
<a href="<%=request.getContextPath()%>/dashboard">Dashboard</a>
<a href="<%=request.getContextPath()%>/budgets">Budgets</a>
<a href="<%=request.getContextPath()%>/goals">Goals</a>
<form class="inline" action="<%=request.getContextPath()%>/logout" method="post">
<button type="submit" class="secondary">Log out</button>
</form>
</nav>

<main class="container">
<h1>Expense Tracker</h1>
<p class="page-intro">Understand where your money goes. Record your daily spending to build better habits, identify unnecessary expenses, and make informed financial decisions.</p>

<div class="info-grid">
<section class="info-box">
<h3>🧾 Record every expense</h3>
<p>Add purchases, food bills, travel costs, shopping, subscriptions, and other payments.</p>
</section>
<section class="info-box">
<h3>🏷️ Use categories</h3>
<p>Choose consistent names such as Food, Travel, Bills, Shopping, and Education to understand your spending patterns.</p>
</section>
<section class="info-box">
<h3>🔎 Review your habits</h3>
<p>Check your expense history regularly to spot frequent purchases and areas where you could save.</p>
</section>
</div>

<div class="tip">
<strong>💡 Smart money tip:</strong>
Track small purchases too. Several small expenses can add up over a month. Record expenses promptly so your history stays accurate.
</div>

<% if(request.getAttribute("error") != null) { %>
<p class="error"><%=esc(String.valueOf(request.getAttribute("error")))%></p>
<% } %>

<section class="card">
<h2>+ Record a new expense</h2>
<p>Enter the details below to add a payment to your personal expense history.</p>

<form action="<%=request.getContextPath()%>/expenses" method="post">
<label for="title">What did you spend money on?</label>
<input id="title" name="title" maxlength="100" placeholder="e.g. Lunch, bus ticket, electricity bill" required>

<label for="category">Category</label>
<input id="category" name="category" maxlength="50" placeholder="e.g. Food, Travel, Bills, Shopping" required>

<label for="amount">Amount (₹)</label>
<input id="amount" type="number" name="amount" min="0.01" step="0.01" placeholder="e.g. 250" required>

<label for="date">Date of expense</label>
<input id="date" type="date" name="date" required>

<button type="submit">Add expense</button>
</form>
</section>

<h2>Your expense history</h2>
<p>Review recorded payments below. Remove an entry if it was added by mistake.</p>

<div class="table-wrap">
<table>
<thead>
<tr><th>Title</th><th>Category</th><th>Amount</th><th>Date</th><th>Action</th></tr>
</thead>
<tbody>
<%
List<Map<String,Object>> expenseList =
    (List<Map<String,Object>>)request.getAttribute("expenses");

if(expenseList != null && !expenseList.isEmpty()) {
    for(Map<String,Object> e : expenseList) {
%>
<tr>
<td><%=esc(String.valueOf(e.get("title")))%></td>
<td><%=esc(String.valueOf(e.get("category")))%></td>
<td>₹ <%=e.get("amount")%></td>
<td><%=esc(String.valueOf(e.get("date")))%></td>
<td>
<form class="inline" action="<%=request.getContextPath()%>/expenses" method="post">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="id" value="<%=e.get("id")%>">
<button class="danger" type="submit">Delete</button>
</form>
</td>
</tr>
<%
    }
} else {
%>
<tr><td colspan="5">No expenses recorded yet. Add your first expense above to start tracking your spending.</td></tr>
<% } %>
</tbody>
</table>
</div>

</main>
</body>
</html>