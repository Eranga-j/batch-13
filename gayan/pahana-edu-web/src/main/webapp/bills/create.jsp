<%@ page import="jakarta.json.*" %>
<%@ include file="/common/header.jspf" %>
<h2>Create Bill</h2>
<div class="card">
  <form method="post" action="${pageContext.request.contextPath}/billing">
    <label>Customer</label>
    <select name="customerId" required>
      <option value="">-- Select --</option>
      <%
        JsonArray customers = (JsonArray) request.getAttribute("customers");
        for (int i=0; i<customers.size(); i++) {
          JsonObject c = customers.getJsonObject(i);
      %>
      <option value="<%= c.getInt("id") %>"><%= c.getString("accountNumber") %> — <%= c.getString("name") %></option>
      <% } %>
    </select>
    <h3>Items</h3>
    <div id="lines"></div>
    <button type="button" class="btn secondary" onclick="addLine()">+ Add Line</button>
    <div style="margin-top:12px"><button class="btn">Create Bill</button></div>
  </form>
</div>
<script>
  const items = <%
    jakarta.json.JsonArray items = (jakarta.json.JsonArray) request.getAttribute("items");
    out.print(items.toString());
  %>;
  function addLine(){
    const div = document.createElement('div');
    div.className='line';
    div.innerHTML = `
      <div class="grid">
        <div><label>Item</label>
          <select name="itemId">
            <option value="">--</option>
            ${items.map(it => `<option value="${it.id}">${it.sku} — ${it.name}</option>`).join('')}
          </select>
        </div>
        <div><label>Qty</label><input name="qty" type="number" value="1" min="1"/></div>
        <div><label>Unit Price</label><input name="unitPrice" type="number" step="0.01"/></div>
      </div>`;
    document.getElementById('lines').appendChild(div);
  }
  addLine();
</script>
<%@ include file="/common/footer.jspf" %>
