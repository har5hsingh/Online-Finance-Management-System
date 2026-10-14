
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%!
private String esc(String s) {
 if(s==null)return "";
 return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
 .replace("\"","&quot;").replace("'","&#39;");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin | FinanceFlow</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<nav>
<a class="brand" href="<%=request.getContextPath()%>/admin">FinanceFlow Admin</a>
<form class="inline" action="<%=request.getContextPath()%>/logout" method="post">
<button class="secondary">Log out</button></form>
</nav>
<main class="container">
<h1>User management</h1>
<div class="table-wrap"><table>
<tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Action</th></tr>
<% for(String[] u:(List<String[]>)request.getAttribute("users")){ %>
<tr>
<td><%=u[0]%></td><td><%=esc(u[1])%></td><td><%=esc(u[2])%></td>
<td><%=esc(u[3])%></td><td><%=esc(u[4])%></td>
<td>
<% if("USER".equals(u[3])){ %>
<form action="<%=request.getContextPath()%>/admin" method="post">
<input type="hidden" name="id" value="<%=u[0]%>">
<input type="hidden" name="status" value="<%="ACTIVE".equals(u[4])?"DISABLED":"ACTIVE"%>">
<button class="<%="ACTIVE".equals(u[4])?"danger":"secondary"%>" type="submit">
<%="ACTIVE".equals(u[4])?"Disable":"Enable"%>
</button>
</form>
<% } %>
</td>
</tr>
<% } %>
</table></div>
</main>
</body>
</html>
