<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*" %>
<%
  if (session.getAttribute("user") == null) { response.sendRedirect("index.jsp"); return; }

  String listJson = (String) request.getAttribute("json");
  if (listJson == null) listJson = "[]";

  String editJson = (String) request.getAttribute("edit");
  JsonObject edit = null;
  try { if (editJson != null && !editJson.isBlank()) edit = JsonParser.parseString(editJson).getAsJsonObject(); } catch(Exception ignore){}

  String msg = request.getParameter("msg");
  String err = request.getParameter("err");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Items</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
  <style>
    .banner { padding:.6rem .8rem; border-radius:.5rem; margin:.6rem 0; }
    .success { background:#eefbf1; border:1px solid #b8e6c1; }
    .error   { background:#fff2f2; border:1px solid #ffc7c7; }
    .row { display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:.6rem .8rem; }
    table { width:100%; border-collapse: collapse; }
    th,td { border-bottom:1px solid #e9eef4; padding:.45rem .5rem; text-align:left; }
    .actions { white-space:nowrap; }
  </style>
  <script>
    function confirmDelete(id){
      if (confirm('Delete item #' + id + '? This cannot be undone.')) {
        document.getElementById('del-' + id).submit();
      }
    }
    window.addEventListener('load', () => {
      const b = document.querySelector('.banner'); if(b) setTimeout(()=> b.style.display='none', 3200);
    });
  </script>
</head>
<body>
  <h2>Items</h2>
  <nav><a href="dashboard.jsp">Back</a></nav>

  <% if ("created".equals(msg)) { %>
    <div class="banner success">Item added.</div>
  <% } else if ("updated".equals(msg)) { %>
    <div class="banner success">Item updated.</div>
  <% } else if ("deleted".equals(msg)) { %>
    <div class="banner success">Item deleted.</div>
  <% } %>

  <% if ("dup_code".equals(err)) { %>
    <div class="banner error">Item code already exists.</div>
  <% } else if ("server".equals(err)) { %>
    <div class="banner error">Server error. Please try again.</div>
  <% } %>

  <h3><%= (edit == null) ? "Add Item" : "Edit Item #"+edit.get("id").getAsInt() %></h3>
  <form method="post" action="items" style="margin-top:.5rem">
    <input type="hidden" name="action" value="<%= (edit==null) ? "create" : "update" %>">
    <% if (edit != null) { %>
      <input type="hidden" name="id" value="<%= edit.get("id").getAsInt() %>">
    <% } %>
    <div class="row">
      <label>Item Code
        <input name="itemCode" required
               value="<%= (edit==null) ? "" : (edit.has("sku") ? edit.get("sku").getAsString() : "") %>">
      </label>
      <label>Item Name
        <input name="name" required
               value="<%= (edit==null) ? "" : edit.get("name").getAsString() %>">
      </label>
      <label>Unit Price
        <input name="unitPrice" type="number" step="0.01" min="0" required
               value="<%= (edit==null) ? "" : edit.get("unitPrice").getAsString() %>">
      </label>
    </div>
    <div style="margin-top:.5rem">
      <button type="submit"><%= (edit==null) ? "Add" : "Update" %></button>
      <% if (edit != null) { %>
        <a class="button" href="items" style="margin-left:.5rem">Cancel</a>
      <% } %>
    </div>
  </form>

  <hr/>
  <h3>All Items</h3>
  <table>
    <thead>
      <tr>
        <th style="width:10%">ID</th>
        <th style="width:20%">Item Code</th>
        <th style="width:40%">Item Name</th>
        <th style="width:20%">Unit Price</th>
        <th class="actions" style="width:10%">Actions</th>
      </tr>
    </thead>
    <tbody>
    <%
      try {
        JsonArray arr = JsonParser.parseString(listJson).getAsJsonArray();
        if (arr.size() == 0) {
    %>
        <tr><td colspan="5"><em>No items yet.</em></td></tr>
    <%
        } else {
          for (JsonElement el : arr) {
            JsonObject o = el.getAsJsonObject();
            int id = o.get("id").getAsInt();
            String code = o.has("sku") ? o.get("sku").getAsString() : "";
            String name = o.get("name").getAsString();
            String price = o.get("unitPrice").getAsString();
    %>
        <tr>
          <td><%= id %></td>
          <td><%= code %></td>
          <td><%= name %></td>
          <td><%= price %></td>
          <td class="actions">
            <form id="del-<%= id %>" method="post" action="items" style="display:inline;">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<%= id %>">
              <button type="button" onclick="confirmDelete(<%= id %>)">Delete</button>
            </form>
            <a href="items?editId=<%= id %>" style="margin-left:.4rem">Edit</a>
          </td>
        </tr>
    <%
          }
        }
      } catch (Exception ex) {
    %>
        <tr><td colspan="5"><em>Failed to load items.</em></td></tr>
    <%
      }
    %>
    </tbody>
  </table>
</body>
</html>
