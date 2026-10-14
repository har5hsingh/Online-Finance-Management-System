
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
<title>Budgets | FinanceFlow</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
<style>
.page-intro { margin:12px 0 25px; color:#586b82; font-size:16px; max-width:780px; }
.info-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(210px,1fr)); gap:15px; margin:20px 0; }
.info-box { padding:18px; background:#edf1fc; border:1px solid #dbe3f8; border-radius:12px; }
.info-box h3 { margin:0 0 7px; color:#283e78; }
.info-box p { margin:0; font-size:14px; }
.tip { padding:17px 20px; border-left:4px solid #4f72c4; border-radius:8px; background:#edf1fc; margin:20px 0; }
.tip strong { color:#283e78; }
@media(max-width:600px) { .info-grid { grid-template-columns:1fr; } }
</style>
</head>
<body>

<nav>
<a class="brand" href="<%=request.getContextPath()%>/dashboard">FinanceFlow</a>
<a href="<%=request.getContextPath()%>/dashboard">Dashboard</a>
<a href="<%=request.getContextPath()%>/expenses">Expenses</a>
<a href="<%=request.getContextPath()%>/goals">Goals</a>
<form class="inline" action="<%=request.getContextPath()%>/logout" method="post">
<button type="submit" class="secondary">Log out</button>
</form>
</nav>

<main class="container">
<h1>Monthly Budget Planner</h1>
<p class="page-intro">A budget gives every rupee a purpose. Set spending limits for different categories so you can cover essential costs, control unnecessary spending, and work towards your savings goals.</p>

<div class="info-grid">
<section class="info-box">
<h3>🎯 Set realistic limits</h3>
<p>Decide how much you can spend on food, transport, shopping, bills, and other categories within your available income.</p>
</section>
<section class="info-box">
<h3>📊 Compare spending</h3>
<p>Use your expense history to understand your usual spending before deciding on a budget limit.</p>
</section>
<section class="info-box">
<h3>💰 Leave room to save</h3>
<p>Plan for savings and unexpected costs instead of allocating your entire income to everyday spending.</p>
</section>
</div>

<div class="tip">
<strong>💡 Smart budgeting tip:</strong>
Start with necessary expenses such as rent, bills, food, and transport. Then set limits for non-essential spending. Review your limits regularly and adjust them when your circumstances change.
</div>

<% if(request.getAttribute("error") != null) { %>
<p class="error"><%=esc(String.valueOf(request.getAttribute("error")))%></p>
<% } %>

<section class="card">
<h2>+ Create a budget</h2>
<p>Choose a category and enter the maximum amount you want to allocate to it.</p>

<form action="<%=request.getContextPath()%>/budgets" method="post">
<label for="category">Budget category</label>
<input id="category" name="category" maxlength="50" placeholder="e.g. Food, Travel, Bills" required>

<label for="amount">Budget limit (₹)</label>
<input id="amount" type="number" name="amount" min="0.01" step="0.01" placeholder="e.g. 5000" required>

<button type="submit">Save budget</button>
</form>
</section>

<h2>Your budgets</h2>
<p>Your current budget allocations are listed below. Keep category names consistent with those used in your expense records.</p>

<div class="table-wrap">
<table>
<thead><tr><th>Category</th><th>Budget limit</th><th>Period</th></tr></thead>
<tbody>
<%
List<Map<String,Object>> budgetList =
    (List<Map<String,Object>>)request.getAttribute("budgets");

if(budgetList != null && !budgetList.isEmpty()) {
    for(Map<String,Object> b : budgetList) {
%>
<tr>
<td><%=esc(String.valueOf(b.get("category")))%></td>
<td>₹ <%=b.get("amount")%></td>
<td><%=esc(String.valueOf(b.get("period")))%></td>
</tr>
<%
    }
} else {
%>
<tr><td colspan="3">No budgets created yet. Create your first budget above to start planning your spending.</td></tr>
<% } %>
</tbody>
</table>
</div>

</main>
</body>
</html>