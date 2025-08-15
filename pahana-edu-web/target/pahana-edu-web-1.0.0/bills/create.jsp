<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/common/header.jspf" %>

<h2>Create Bill</h2>
<div class="card">
  <form method="post" action="${pageContext.request.contextPath}/billing">
    <label>Customer</label>
    <select name="customerId" required>
      <option value="">-- Select --</option>
      <%
        List<Map<String,Object>> customers =
            (List<Map<String,Object>>) request.getAttribute("customers");
        if (customers != null) {
          for (Map<String,Object> c : customers) {
      %>
        <option value="<%= (Integer)c.get("id") %>">
          <%= (String)c.get("accountNumber") %> — <%= (String)c.get("name") %>
        </option>
      <%
          }
        }
      %>
    </select>

    <h3>Items</h3>
    <div id="lines"></div>
    <button type="button" class="btn secondary" onclick="addLine()">+ Add Line</button>
    <div style="margin-top:12px"><button class="btn">Create Bill</button></div>
  </form>
</div>

<script>
  // Items JSON provided by servlet; fallback to [] if missing
  const items = <%= request.getAttribute("itemsJson") == null
                   ? "[]"
                   : (String)request.getAttribute("itemsJson") %>;

  function addLine(){
    const options = items.map(it =>
      `<option value="${it.id}">${it.sku} — ${it.name}</option>`
    ).join('');

    const div = document.createElement('div');
    div.className = 'line';
    div.innerHTML = `
      <div class="grid">
        <div>
          <label>Item</label>
          <select name="itemId" required>
            <option value="">--</option>
            ${options}
          </select>
        </div>
        <div>
          <label>Qty</label>
          <input name="qty" type="number" value="1" min="1" required/>
        </div>
        <div>
          <label>Unit Price</label>
          <input name="unitPrice" type="number" step="0.01" required/>
        </div>
      </div>
    `;
    document.getElementById('lines').appendChild(div);
  }
  addLine();
</script>

<%@ include file="/common/footer.jspf" %>
