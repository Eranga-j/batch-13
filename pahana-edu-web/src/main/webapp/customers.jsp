<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*, java.util.*" %>
<%
  if (session.getAttribute("user") == null) { response.sendRedirect("index.jsp"); return; }
  String listJson = (String) request.getAttribute("json");
  if (listJson == null) listJson = "[]";

  String editJson = (String) request.getAttribute("edit"); // when editing a single record
  JsonObject edit = null;
  try {
    if (editJson != null && !editJson.isBlank()) {
      edit = JsonParser.parseString(editJson).getAsJsonObject();
    }
  } catch (Exception ignore) {}

  String msg = request.getParameter("msg");
  String err = request.getParameter("err");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Customers</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
  <style>
    .banner { padding:.6rem .8rem; border-radius:.5rem; margin:.6rem 0; }
    .success { background:#eefbf1; border:1px solid #b8e6c1; }
    .error   { background:#fff2f2; border:1px solid #ffc7c7; }
    table { width:100%; border-collapse: collapse; }
    th, td { border-bottom:1px solid #eee; padding:.45rem .5rem; text-align:left; }
    .actions { white-space:nowrap; }
    .row { display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:.5rem .8rem; }
  </style>
  <script>
    function confirmDelete(id){
      if(confirm('Delete customer #' + id + '? This cannot be undone.')){
        document.getElementById('del-' + id).submit();
      }
    }
    window.addEventListener('load', () => {
      const b = document.querySelector('.banner'); if(b){ setTimeout(()=> b.style.display='none', 3200); }
    });
  </script>
</head>
<body>
  <h2>Customers</h2>
  <nav><a href="dashboard.jsp">Back</a></nav>

  <% if ("created".equals(msg)) { %>
    <div class="banner success">Customer added successfully.</div>
  <% } else if ("deleted".equals(msg)) { %>
    <div class="banner success">Customer deleted.</div>
  <% } else if ("updated".equals(msg)) { %>
    <div class="banner success">Customer updated.</div>
  <% } %>

  <%-- Error banners (account / phone / generic) --%>
  <% if ("dup_phone".equals(err)) { %>
    <div class="banner error">Phone already registered. Please use a different phone number.</div>
  <% } else if ("dup_acc".equals(err)) { %>
    <div class="banner error">Account number already exists. Please use a different account #.</div>
  <% } else if ("duplicate".equals(err)) { %>
    <div class="banner error">Customer already registered (duplicate details).</div>
  <% } else if ("server".equals(err)) { %>
    <div class="banner error">Server error. Please try again.</div>
  <% } %>

  <!-- Add / Edit form -->
  <h3><%= (edit == null) ? "Add Customer" : "Edit Customer #"+edit.get("id").getAsInt() %></h3>
  <form method="post" action="customers" style="margin-top:.5rem">
    <input type="hidden" name="action" value="<%= (edit==null) ? "create" : "update" %>">
    <% if (edit != null) { %>
      <input type="hidden" name="id" value="<%= edit.get("id").getAsInt() %>">
    <% } %>
    <div class="row">
      <label>Account #
        <input name="accountNumber" required
               value="<%= (edit==null) ? "" : edit.get("accountNumber").getAsString() %>">
      </label>
      <label>Name
        <input name="name" required
               value="<%= (edit==null) ? "" : edit.get("name").getAsString() %>">
      </label>
      <label>Address
        <input name="address" required
               value="<%= (edit==null) ? "" : edit.get("address").getAsString() %>">
      </label>
      <label>Phone
        <input name="phone" required pattern="07[0-9]{8}"
               title="Enter a valid Sri Lankan mobile number starting with 07 (e.g., 0771234567)"
               value="<%= (edit==null) ? "" : edit.get("phone").getAsString() %>">
      </label>
    </div>
    <div style="margin-top:.5rem">
      <button type="submit"><%= (edit==null) ? "Add" : "Update" %></button>
      <% if (edit != null) { %>
        <a class="button" href="customers" style="margin-left:.5rem">Cancel</a>
      <% } %>
    </div>
  </form>

  <hr/>

  <!-- List -->
  <h3>All Customers</h3>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Account #</th>
        <th>Name</th>
        <th>Address</th>
        <th>Phone</th>
        <th class="actions">Actions</th>
      </tr>
    </thead>
    <tbody>
    <%
      try {
        JsonArray arr = JsonParser.parseString(listJson).getAsJsonArray();
        if (arr.size() == 0) {
    %>
        <tr><td colspan="6"><em>No customers yet.</em></td></tr>
    <%
        } else {
          for (JsonElement el : arr) {
            JsonObject o = el.getAsJsonObject();
            int id = o.get("id").getAsInt();
            String acc = o.get("accountNumber").getAsString();
            String name = o.get("name").getAsString();
            String addr = o.get("address").getAsString();
            String phone = o.get("phone").getAsString();
    %>
        <tr>
          <td><%= id %></td>
          <td><%= acc %></td>
          <td><%= name %></td>
          <td><%= addr %></td>
          <td><%= phone %></td>
          <td class="actions">
            <form id="del-<%= id %>" method="post" action="customers" style="display:inline;">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<%= id %>">
              <button type="button" onclick="confirmDelete(<%= id %>)">Delete</button>
            </form>
            <a href="customers?editId=<%= id %>" style="margin-left:.4rem">Edit</a>
          </td>
        </tr>
    <%
          }
        }
      } catch (Exception ex) {
    %>
        <tr><td colspan="6"><em>Failed to load customers.</em></td></tr>
    <%
      }
    %>
    </tbody>
  </table>
</body>
</html>
