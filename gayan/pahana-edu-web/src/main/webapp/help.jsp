<%@ include file="/common/header.jspf" %>
<h2>Help</h2>
<div class="card">
  <ol>
    <li>Login with your username and password.</li>
    <li>Admins can manage customers and items (CRUD) via the respective pages.</li>
    <li>Cashiers can create bills and view customers.</li>
    <li>Use the Billing page to add line items and create invoices. Then click <em>Print</em>.</li>
  </ol>
  <p>This system implements a 3-tier architecture with DAO + Service + REST, and MVC on the web client. Sessions secure each role-based panel.</p>
</div>
<%@ include file="/common/footer.jspf" %>
