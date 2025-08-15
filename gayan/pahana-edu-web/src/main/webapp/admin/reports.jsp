<%@ page import="jakarta.json.*" %>
<%@ include file="/common/header.jspf" %>
<h2>Sales Reports</h2>
<div class="card">
  <form method="get" action="${pageContext.request.contextPath}/admin/reports" class="grid">
    <div>
      <label>From</label>
      <input type="date" name="from" value="<%= request.getParameter("from")!=null?request.getParameter("from"):"" %>" required/>
    </div>
    <div>
      <label>To</label>
      <input type="date" name="to" value="<%= request.getParameter("to")!=null?request.getParameter("to"):"" %>" required/>
    </div>
    <div style="align-self:end"><button class="btn">Run</button></div>
  </form>
</div>
<div class="card">
  <h3>Results</h3>
  <table>
    <tr><th>Bill No</th><th>Customer</th><th>Date/Time</th><th>Total (LKR)</th></tr>
    <%
      JsonArray arr = (JsonArray) request.getAttribute("bills");
      java.math.BigDecimal total = java.math.BigDecimal.ZERO;
      for (int i=0; i<arr.size(); i++) {
        JsonObject b = arr.getJsonObject(i);
        total = total.add(b.getJsonNumber("totalAmount").bigDecimalValue());
    %>
      <tr>
        <td><%= b.getString("billNo") %></td>
        <td><%= b.getString("customerName") %></td>
        <td><%= b.getString("createdAt") %></td>
        <td style="text-align:right"><%= b.getJsonNumber("totalAmount") %></td>
      </tr>
    <% } %>
    <tr><th colspan="3" style="text-align:right">Grand Total</th><th style="text-align:right"><%= total %></th></tr>
  </table>
</div>
<%@ include file="/common/footer.jspf" %>
