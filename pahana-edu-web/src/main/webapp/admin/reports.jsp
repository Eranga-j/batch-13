<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
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
    <tr><th>Bill No</th><th>Customer</th><th>Date/Time</th><th style="text-align:right">Total (LKR)</th></tr>
    <%
      List<Map<String,Object>> arr = (List<Map<String,Object>>) request.getAttribute("bills");
      BigDecimal grand = BigDecimal.ZERO;
      DecimalFormat money = new DecimalFormat("#,##0.00");

      if (arr != null) {
        for (Map<String,Object> b : arr) {
          String billNo = (String) b.get("billNo");
          String customerName = (String) b.get("customerName");
          String createdAt = (String) b.get("createdAt");
          BigDecimal totalAmount = (BigDecimal) b.get("totalAmount");
          if (totalAmount != null) grand = grand.add(totalAmount);
    %>
      <tr>
        <td><%= billNo %></td>
        <td><%= customerName %></td>
        <td><%= createdAt == null ? "" : createdAt %></td>
        <td style="text-align:right"><%= totalAmount == null ? "0.00" : money.format(totalAmount) %></td>
      </tr>
    <%
        }
      }
    %>
    <tr>
      <th colspan="3" style="text-align:right">Grand Total</th>
      <th style="text-align:right"><%= money.format(grand) %></th>
    </tr>
  </table>
</div>

<%@ include file="/common/footer.jspf" %>
