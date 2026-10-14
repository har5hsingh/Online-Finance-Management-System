
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,java.math.BigDecimal,com.financeflow.model.Account" %>

<%!
private String escape(String s) {
    if (s == null) return "";

    return s.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}
%>

<%
Account account = (Account) request.getAttribute("account");

if (account == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

List<Map<String,Object>> expenses =
    (List<Map<String,Object>>) request.getAttribute("expenses");

List<Map<String,Object>> budgets =
    (List<Map<String,Object>>) request.getAttribute("budgets");

List<Map<String,Object>> goals =
    (List<Map<String,Object>>) request.getAttribute("goals");

List<Map<String,Object>> categoryTotals =
    (List<Map<String,Object>>) request.getAttribute("categoryTotals");

List<Map<String,Object>> monthlyTotals =
    (List<Map<String,Object>>) request.getAttribute("monthlyTotals");

double maxCategory = 0;
for (Map<String,Object> item : categoryTotals) {
    double value = ((BigDecimal)item.get("total")).doubleValue();
    if (value > maxCategory) maxCategory = value;
}

double maxMonth = 0;
for (Map<String,Object> item : monthlyTotals) {
    double value = ((BigDecimal)item.get("total")).doubleValue();
    if (value > maxMonth) maxMonth = value;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Dashboard | FinanceFlow</title>

<link rel="stylesheet"
      href="<%=request.getContextPath()%>/css/style.css">

<style>
.dashboard-welcome {
    background: linear-gradient(120deg, #142b4a, #216b78);
    color: white;
    padding: 30px;
    border-radius: 16px;
    margin-bottom: 26px;
}

.dashboard-welcome h1 {
    color: white;
    margin-bottom: 8px;
}

.dashboard-welcome p {
    color: #e1edf4;
    margin-bottom: 0;
}

.stat-card {
    border-top: 4px solid #168c85;
}

.chart-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 22px;
    margin: 22px 0;
}

.chart-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 5px 22px rgba(29, 52, 83, 0.06);
    min-width: 0;
}

.chart-card h2 {
    margin-bottom: 6px;
}

.chart-description {
    font-size: 13px;
    color: #758399;
    margin-top: 0;
    margin-bottom: 24px;
}

.bar-row {
    margin: 19px 0;
}

.bar-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 7px;
    font-size: 13px;
}

.bar-heading strong {
    color: #263449;
    overflow-wrap: anywhere;
}

.bar-track {
    height: 12px;
    width: 100%;
    background: #edf2f7;
    border-radius: 20px;
    overflow: hidden;
}

.bar-fill {
    height: 100%;
    min-width: 3px;
    background: linear-gradient(90deg, #168c85, #39b8a8);
    border-radius: 20px;
}

.monthly-fill {
    background: linear-gradient(90deg, #315c91, #6797d0);
}

.chart-empty {
    background: #f4f7fb;
    color: #758399;
    padding: 20px;
    border-radius: 10px;
    font-size: 14px;
}

.section-intro {
    margin-top: -5px;
    margin-bottom: 20px;
}

@media (max-width: 760px) {
    .chart-grid {
        grid-template-columns: 1fr;
    }

    .dashboard-welcome {
        padding: 23px;
    }
}
</style>
</head>

<body>

<nav>
    <a class="brand" href="<%=request.getContextPath()%>/dashboard">
        FinanceFlow
    </a>

    <a href="<%=request.getContextPath()%>/dashboard">Dashboard</a>
    <a href="<%=request.getContextPath()%>/expenses">Expenses</a>
    <a href="<%=request.getContextPath()%>/budgets">Budgets</a>
    <a href="<%=request.getContextPath()%>/goals">Goals</a>

    <form class="inline"
          action="<%=request.getContextPath()%>/logout"
          method="post">
        <button type="submit" class="secondary">Log out</button>
    </form>
</nav>

<main class="container">

    <section class="dashboard-welcome">
        <h1>Welcome, <%=escape(account.getFullName())%>!</h1>
        <p>
            Keep track of your spending, stay within your budget,
            and take small steps towards your savings goals.
        </p>
    </section>

    <div class="cards">

        <section class="card stat-card">
            <p>Total recorded expenses</p>
            <h2>₹ <%=request.getAttribute("totalExpenses")%></h2>
            <small>All expenses recorded in your account</small>
        </section>

        <section class="card stat-card">
            <p>Expense records</p>
            <h2><%=expenses.size()%></h2>
            <small>Individual expenses entered</small>
        </section>

        <section class="card stat-card">
            <p>Budgets</p>
            <h2><%=budgets.size()%></h2>
            <small>Budgets you have created</small>
        </section>

        <section class="card stat-card">
            <p>Savings goals</p>
            <h2><%=goals.size()%></h2>
            <small>Goals you are working towards</small>
        </section>

    </div>

    <h2>Your spending overview</h2>
    <p class="section-intro">
        These charts use the expenses you have recorded.
        Add or remove an expense to see the updated figures.
    </p>

    <div class="chart-grid">

        <section class="chart-card">
            <h2>Expenses by category</h2>
            <p class="chart-description">
                Compare how much you spend in different categories.
            </p>

            <% if (categoryTotals.isEmpty()) { %>

                <div class="chart-empty">
                    No expense data yet. Add your first expense to
                    see your category chart here.
                </div>

            <% } else { %>

                <% for (Map<String,Object> item : categoryTotals) {
                    double amount =
                        ((BigDecimal)item.get("total")).doubleValue();

                    int width = maxCategory > 0
                        ? (int)Math.round(amount / maxCategory * 100)
                        : 0;
                %>

                    <div class="bar-row">
                        <div class="bar-heading">
                            <strong>
                                <%=escape(String.valueOf(item.get("category")))%>
                            </strong>
                            <span>₹ <%=item.get("total")%></span>
                        </div>

                        <div class="bar-track">
                            <div class="bar-fill"
                                 style="width:<%=width%>%"></div>
                        </div>
                    </div>

                <% } %>

            <% } %>
        </section>

        <section class="chart-card">
            <h2>Monthly expenses</h2>
            <p class="chart-description">
                See your spending totals for the last six months.
            </p>

            <% if (monthlyTotals.isEmpty()) { %>

                <div class="chart-empty">
                    No monthly expense data yet. Once you record
                    expenses, your monthly summary will appear here.
                </div>

            <% } else { %>

                <% for (Map<String,Object> item : monthlyTotals) {
                    double amount =
                        ((BigDecimal)item.get("total")).doubleValue();

                    int width = maxMonth > 0
                        ? (int)Math.round(amount / maxMonth * 100)
                        : 0;
                %>

                    <div class="bar-row">
                        <div class="bar-heading">
                            <strong>
                                <%=escape(String.valueOf(item.get("month")))%>
                            </strong>
                            <span>₹ <%=item.get("total")%></span>
                        </div>

                        <div class="bar-track">
                            <div class="bar-fill monthly-fill"
                                 style="width:<%=width%>%"></div>
                        </div>
                    </div>

                <% } %>

            <% } %>
        </section>

    </div>

    <h2>Recent expenses</h2>
    <p class="section-intro">
        Review your latest entries and check that they are recorded correctly.
    </p>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>

            <tbody>
                <% if (expenses.isEmpty()) { %>
                    <tr>
                        <td colspan="4">
                            No expenses recorded yet.
                            <a href="<%=request.getContextPath()%>/expenses">
                                Add your first expense
                            </a>.
                        </td>
                    </tr>
                <% } else {
                    int count = 0;
                    for (Map<String,Object> e : expenses) {
                        if (count++ >= 5) break;
                %>
                    <tr>
                        <td><%=escape(String.valueOf(e.get("title")))%></td>
                        <td><%=escape(String.valueOf(e.get("category")))%></td>
                        <td>₹ <%=e.get("amount")%></td>
                        <td><%=e.get("date")%></td>
                    </tr>
                <%  }
                   }
                %>
            </tbody>
        </table>
    </div>

    <section class="card">
        <h2>A small money tip</h2>
        <p>
            Try recording every expense, even small purchases.
            Review your category chart regularly to find areas where
            you could save money.
        </p>
        <a class="button"
           href="<%=request.getContextPath()%>/expenses">
            Add an expense
        </a>
    </section>

</main>

</body>
</html>