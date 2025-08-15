<%@ page import="jakarta.json.*" %>
<%@ include file="/common/header.jspf" %>
<h2>Items</h2>
<div class="grid">
  <div class="card">
    <h3>Add / Edit Item</h3>
    <form method="post" action="${pageContext.request.contextPath}/items">
      <input type="hidden" name="id" id="itemId"/>
      <label>SKU</label><input name="sku" required/>
      <label>Name</label><input name="name" required/>
      <label>Unit Price (LKR)</label><input name="unitPrice" type="number" step="0.01" required/>
      <button class="btn" name="action" value="create">Save</button>
      <button class="btn secondary" name="action" value="update">Update</button>
    </form>
  </div>
  <div class="card">
    <h3>All Items</h3>
    <table><tr><th>ID</th><th>SKU</th><th>Name</th><th>Unit Price</th><th>Actions</th></tr>
    <%
      JsonArray arr = (JsonArray) request.getAttribute("items");
      for (int i=0; i<arr.size(); i++) {
        JsonObject it = arr.getJsonObject(i);
    %>
      <tr>
        <td><%= it.getInt("id") %></td>
        <td><%= it.getString("sku") %></td>
        <td><%= it.getString("name") %></td>
        <td>LKR <%= it.getJsonNumber("unitPrice") %></td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/items">
            <input type="hidden" name="id" value="<%= it.getInt("id") %>"/>
            <button class="btn secondary" name="action" value="delete" onclick="return confirm('Delete?')">Delete</button>
          </form>
        </td>
      </tr>
    <% } %>
    </table>
  </div>
</div>
<%@ include file="/common/footer.jspf" %>
