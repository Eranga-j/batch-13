<%@ page import="jakarta.json.*" %>
<%@ include file="/common/header.jspf" %>
<h2>Customers</h2>
<div class="grid">
  <div class="card">
    <h3>Add / Edit Customer</h3>
    <form method="post" action="${pageContext.request.contextPath}/customers">
      <input type="hidden" name="id" id="custId"/>
      <label>Account No</label><input name="accountNumber" id="accNo" required/>
      <label>Name</label><input name="name" id="name" required/>
      <label>Address</label><input name="address" id="address"/>
      <label>Phone</label><input name="phone" id="phone"/>
      <button class="btn" name="action" value="create">Save</button>
      <button class="btn secondary" name="action" value="update">Update</button>
    </form>
  </div>
  <div class="card">
    <h3>All Customers</h3>
    <table><tr><th>ID</th><th>Account No</th><th>Name</th><th>Phone</th><th>Actions</th></tr>
    <%
      JsonArray arr = (JsonArray) request.getAttribute("customers");
      for (int i=0; i<arr.size(); i++) {
        JsonObject c = arr.getJsonObject(i);
    %>
      <tr>
        <td><%= c.getInt("id") %></td>
        <td><%= c.getString("accountNumber") %></td>
        <td><%= c.getString("name") %></td>
        <td><%= c.isNull("phone") ? "" : c.getString("phone") %></td>
        <td>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/customers">
            <input type="hidden" name="id" value="<%= c.getInt("id") %>"/>
            <button class="btn secondary" name="action" value="delete" onclick="return confirm('Delete?')">Delete</button>
          </form>
        </td>
      </tr>
    <% } %>
    </table>
  </div>
</div>
<%@ include file="/common/footer.jspf" %>
