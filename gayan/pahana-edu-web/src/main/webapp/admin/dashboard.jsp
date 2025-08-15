<%@ include file="/common/header.jspf" %>
<div class="grid">
  <div class="card"><h3>Admin Panel</h3>
    <p>Full CRUD: Customers, Items. View reports, manage billing.</p>
    <p><a class="btn" href="${pageContext.request.contextPath}/customers">Manage Customers</a></p>
    <p><a class="btn" href="${pageContext.request.contextPath}/items">Manage Items</a></p>
    <p><a class="btn secondary" href="${pageContext.request.contextPath}/admin/reports">Sales Reports</a></p>
  </div>
  <div class="card"><h3>Quick Stats</h3>
    <p>Use the Billing page to create invoices.</p>
  </div>
</div>
<%@ include file="/common/footer.jspf" %>
