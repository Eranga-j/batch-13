<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ include file="/common/header.jspf" %>

<%
  Map<String,Object> bill = (Map<String,Object>) request.getAttribute("bill");
  if (bill == null) {
%>
  <div class="card"><p>No bill to display.</p></div>
<%
  } else {
    String billNo = (String) bill.get("billNo");
    String customerName = (String) bill.get("customerName");
    Number customerIdNum = (Number) bill.get("customerId");
    Integer customerId = customerIdNum == null ? null : customerIdNum.intValue();
    String createdAt = (String) bill.get("createdAt");
    BigDecimal totalAmount = (BigDecimal) bill.get("totalAmount");
    List<Map<String,Object>> lines = (List<Map<String,Object>>) bill.get("items");
    DecimalFormat money = new DecimalFormat("#,##0.00");
%>

<div class="card">
  <h2>Invoice <%= billNo %></h2>
  <p><strong>Customer:</strong>
    <%= (customerName != null && !customerName.isEmpty())
          ? customerName
          : ("#" + (customerId == null ? "" : customerId)) %>
  </p>
  <p><strong>Date:</strong> <%= createdAt == null ? "" : createdAt %></p>

  <table>
    <tr><th>Item</th><th>Qty</th><th>Unit Price</th><th>Line Total</th></tr>
    <%
      if (lines != null) {
        for (Map<String,Object> l : lines) {
          String itemName = (String) l.get("itemName");
          Number qtyNum = (Number) l.get("qty");
          int qty = qtyNum == null ? 0 : qtyNum.intValue();
          BigDecimal unitPrice = (BigDecimal) l.get("unitPrice");
          BigDecimal lineTotal = (BigDecimal) l.get("lineTotal");
    %>
      <tr>
        <td><%= (itemName != null && !itemName.isEmpty())
                 ? itemName
                 : ("Item #" + ((Number) l.get("itemId")).intValue()) %></td>
        <td><%= qty %></td>
        <td>LKR <%= unitPrice == null ? "0.00" : money.format(unitPrice) %></td>
        <td>LKR <%= lineTotal == null ? "0.00" : money.format(lineTotal) %></td>
      </tr>
    <%
        }
      }
    %>
    <tr>
      <th colspan="3" style="text-align:right">Total</th>
      <th>LKR <%= totalAmount == null ? "0.00" : money.format(totalAmount) %></th>
    </tr>
  </table>

  <div style="margin-top:12px">
    <button class="btn" onclick="window.print()">Print</button>
    <a class="btn secondary" href="${pageContext.request.contextPath}/billing">New Bill</a>
  </div>
</div>

<%
  } // end else
%>

<%@ include file="/common/footer.jspf" %>
