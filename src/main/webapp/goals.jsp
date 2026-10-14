```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
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
<%
List<Map<String, Object>> goalList =
    (List<Map<String, Object>>) request.getAttribute("goals");

if (goalList == null) {
    goalList = java.util.Collections.emptyList();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Savings Goals | FinanceFlow</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>
        .page-intro {
            margin: 12px 0 25px;
            color: #586b82;
            font-size: 16px;
            max-width: 780px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .info-box {
            padding: 18px;
            background: #e8f6ee;
            border: 1px solid #cfeada;
            border-radius: 12px;
        }

        .info-box h3 {
            margin: 0 0 7px;
            color: #17653f;
        }

        .info-box p {
            margin: 0;
            font-size: 14px;
        }

        .tip {
            padding: 17px 20px;
            border-left: 4px solid #218653;
            border-radius: 8px;
            background: #e8f6ee;
            margin: 20px 0;
        }

        .tip strong {
            color: #17653f;
        }

        .progress-track {
            height: 10px;
            background: #e8edf3;
            border-radius: 10px;
            overflow: hidden;
            min-width: 90px;
        }

        .progress-fill {
            height: 100%;
            width: var(--progress, 0%);
            background: #218653;
            border-radius: 10px;
        }

        @media (max-width: 600px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<nav>
    <a class="brand" href="<%= request.getContextPath() %>/dashboard">
        FinanceFlow
    </a>

    <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    <a href="<%= request.getContextPath() %>/expenses">Expenses</a>
    <a href="<%= request.getContextPath() %>/budgets">Budgets</a>

    <form class="inline"
          action="<%= request.getContextPath() %>/logout"
          method="post">
        <button type="submit" class="secondary">Log out</button>
    </form>
</nav>

<main class="container">
    <h1>Your Financial Goals</h1>

    <p class="page-intro">
        Give your savings a clear purpose. Set a target, choose a deadline,
        and track your progress towards important purchases and future needs.
    </p>

    <div class="info-grid">
        <section class="info-box">
            <h3>Plan something important</h3>
            <p>
                Save towards a holiday, laptop, education, vehicle,
                or another purchase.
            </p>
        </section>

        <section class="info-box">
            <h3>Prepare for emergencies</h3>
            <p>
                Consider saving money for unexpected repairs,
                bills, and other expenses.
            </p>
        </section>

        <section class="info-box">
            <h3>Make steady progress</h3>
            <p>
                Choose a realistic target and deadline.
                Regular savings can help you reach your goal.
            </p>
        </section>
    </div>

    <div class="tip">
        <strong>Smart savings tip:</strong>
        Saving ₹1,000 per month for 12 months gives you ₹12,000
        before interest.
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error">
            <%= esc(String.valueOf(request.getAttribute("error"))) %>
        </p>
    <% } %>

    <section class="card">
        <h2>Create a savings goal</h2>
        <p>Enter what you want to save for and your target amount.</p>

        <form action="<%= request.getContextPath() %>/goals" method="post">
            <label for="description">Goal description</label>
            <input id="description"
                   name="description"
                   maxlength="200"
                   placeholder="e.g. Emergency fund or new laptop"
                   required>

            <label for="target">Target amount (₹)</label>
            <input id="target"
                   type="number"
                   name="target"
                   min="0.01"
                   step="0.01"
                   placeholder="e.g. 25000"
                   required>

            <label for="deadline">Deadline (optional)</label>
            <input id="deadline" type="date" name="deadline">

            <button type="submit">Save goal</button>
        </form>
    </section>

    <h2>Your savings goals</h2>
    <p>Review your targets and recorded savings below.</p>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Goal</th>
                    <th>Target</th>
                    <th>Saved</th>
                    <th>Deadline</th>
                    <th>Progress</th>
                </tr>
            </thead>

            <tbody>
            <% if (goalList.isEmpty()) { %>
                <tr>
                    <td colspan="5">
                        No savings goals yet. Create your first goal above.
                    </td>
                </tr>
            <% } else {
                for (Map<String, Object> g : goalList) {
                    double targetAmount = 0.0;
                    double savedAmount = 0.0;

                    try {
                        targetAmount = Double.parseDouble(
                            String.valueOf(g.get("target")));
                    } catch (NumberFormatException ignored) {
                        targetAmount = 0.0;
                    }

                    try {
                        savedAmount = Double.parseDouble(
                            String.valueOf(g.get("saved")));
                    } catch (NumberFormatException ignored) {
                        savedAmount = 0.0;
                    }

                    int progress = targetAmount > 0
                        ? (int) Math.min(100,
                            Math.max(0, savedAmount * 100.0 / targetAmount))
                        : 0;
            %>
                <tr>
                    <td><%= esc(String.valueOf(g.get("description"))) %></td>

                    <td>₹ <%= esc(String.valueOf(g.get("target"))) %></td>

                    <td>₹ <%= esc(String.valueOf(g.get("saved"))) %></td>

                    <td>
                        <%= g.get("deadline") == null
                            ? "Not set"
                            : esc(String.valueOf(g.get("deadline"))) %>
                    </td>

                    <td>
                        <div style="min-width: 100px;">
                            <div style="font-size: 12px; margin-bottom: 5px;">
                                <strong><%= progress %>%</strong>
                            </div>

                            <div class="progress-track">
                                <div class="progress-fill"
                                     style="--progress: <%= progress %>%;">
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            <%  }
               } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
```
