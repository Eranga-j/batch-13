<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*, java.util.*" %>
<%
  if (session.getAttribute("user") == null) { 
      response.sendRedirect("index.jsp"); 
      return; 
  }

  String json = (String) request.getAttribute("json");
  if (json == null) json = "[]";
%>
<!DOCTYPE html>
<html>
<head>
  <title>Reports</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
  <style>
    table { width:100%; border-collapse: collapse; }
    th, td { border-bottom:1px solid #eee; padding:.45rem .5rem; text-align:left; }
  </style>
</head>
<%
  if (session.getAttribute("user") == null) { 
    response.sendRedirect("index.jsp"); 
    return; 
  }
%>

<body>
  <h2>Reports</h2>
  <nav>
    <a href="dashboard.jsp">Back</a>
  </nav>

  <ul>
    <li><a href="reports?type=sales-today">Sales Today</a></li>
    <li><a href="reports?type=top-items">Top Items</a></li>
  </ul>

  <hr/>

  <h3>Report Data</h3>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Account #</th>
        <th>Name</th>
        <th>Address</th>
        <th>Phone</th>
      </tr>
    </thead>
    <tbody>
    <%
      try {
        JsonElement parsed = JsonParser.parseString(json);
        JsonArray arr = parsed.isJsonArray() ? parsed.getAsJsonArray() : new JsonArray();
        if (arr.size() == 0) {
    %>
        <tr><td colspan="5"><em>No data available.</em></td></tr>
    <%
        } else {
          for (JsonElement el : arr) {
            JsonObject o = el.getAsJsonObject();
    %>
        <tr>
          <td><%= o.has("id") ? o.get("id").getAsInt() : "" %></td>
          <td><%= o.has("accountNumber") ? o.get("accountNumber").getAsString() : "" %></td>
          <td><%= o.has("name") ? o.get("name").getAsString() : "" %></td>
          <td><%= o.has("address") ? o.get("address").getAsString() : "" %></td>
          <td><%= o.has("phone") ? o.get("phone").getAsString() : "" %></td>
        </tr>
    <%
          }
        }
      } catch (Exception ex) {
    %>
        <tr><td colspan="5"><em>Failed to load report data.</em></td></tr>
    <%
      }
    %>
    </tbody>
  </table>
</body>
</html>
