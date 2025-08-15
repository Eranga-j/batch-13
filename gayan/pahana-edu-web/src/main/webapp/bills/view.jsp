<%@ page import="jakarta.json.*" %>
<%@ include file="/common/header.jspf" %>
<%
  JsonObject bill = (JsonObject) request.getAttribute("bill");
%>
<div class="card">
  <h2>Invoice <%= bill.getString("billNo") %></h2>
  <p><strong>Customer:</strong> <%= bill.getString("customerName", "#"+bill.getInt("customerId")) %></p>
  <p><strong>Date:</strong> <%= bill.getString("createdAt", "") %></p>
  <table>
    <tr><th>Item</th><th>Qty</th><th>Unit Price</th><th>Line Total</th></tr>
    <%
      JsonArray lines = bill.getJsonArray("items");
      for (int i=0; i<lines.size(); i++) {
        JsonObject l = lines.getJsonObject(i);
    %>
      <tr>
        <td><%= l.getString("itemName","Item #"+l.getInt("itemId")) %></td>
        <td><%= l.getInt("qty") %></td>
        <td>LKR <%= l.getJsonNumber("unitPrice") %></td>
        <td>LKR <%= l.getJsonNumber("lineTotal") %></td>
      </tr>
    <% } %>
    <tr><th colspan="3" style="text-align:right">Total</th><th>LKR <%= bill.getJsonNumber("totalAmount") %></th></tr>
  </table>
  <div style="margin-top:12px">
    <button class="btn" onclick="window.print()">Print</button>
    <a class="btn secondary" href="${pageContext.request.contextPath}/billing">New Bill</a>
  </div>
</div>
<%@ include file="/common/footer.jspf" %>
