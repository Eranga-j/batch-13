<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, java.math.BigDecimal" %>
<%@ include file="/common/header.jspf" %>

<h2>Items</h2>
<div class="grid">
  <div class="card">
    <h3>Add / Edit Item</h3>
    <form id="itemForm" method="post" action="${pageContext.request.contextPath}/items">
      <input type="hidden" name="id" id="itemId"/>
      <label>SKU</label><input name="sku" id="sku" required/>
      <label>Name</label><input name="name" id="name" required/>
      <label>Unit Price (LKR)</label><input name="unitPrice" id="unitPrice" type="number" step="0.01" required/>
      <div style="display:flex;gap:8px;margin-top:8px">
        <button class="btn" name="action" value="create">Save</button>
        <button class="btn secondary" name="action" value="update">Update</button>
        <button class="btn secondary" type="button" onclick="clearForm()">Clear</button>
      </div>
    </form>
  </div>

  <div class="card">
    <h3>All Items</h3>
    <table>
      <tr>
        <th>ID</th><th>SKU</th><th>Name</th><th>Unit Price</th>
        <th style="width:200px">Actions</th>
      </tr>
      <%
        List<Map<String,Object>> arr = (List<Map<String,Object>>) request.getAttribute("items");
        DecimalFormat money = new DecimalFormat("#,##0.00");
        if (arr != null) {
          for (Map<String,Object> it : arr) {
            Number idNum = (Number) it.get("id");
            String sku = (String) it.get("sku");
            String nm  = (String) it.get("name");
            BigDecimal price = (BigDecimal) it.get("unitPrice");
      %>
      <tr>
        <td class="item-id"><%= idNum == null ? "" : idNum.intValue() %></td>
        <td class="item-sku"><%= sku %></td>
        <td class="item-name"><%= nm %></td>
        <td class="item-price">LKR <%= price == null ? "0.00" : money.format(price) %></td>
        <!-- keep raw price hidden for precise editing -->
        <td class="item-price-raw" style="display:none"><%= price == null ? "0.00" : price %></td>
        <td>
          <button type="button" class="btn secondary" onclick="editRow(this)">Edit</button>
          <form class="inline" method="post" action="${pageContext.request.contextPath}/items" style="display:inline">
            <input type="hidden" name="id" value="<%= idNum == null ? "" : idNum.intValue() %>"/>
            <button class="btn secondary" name="action" value="delete"
                    onclick="return confirm('Delete this item?')">Delete</button>
          </form>
        </td>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
</div>

<script>
  function editRow(btn){
    const tr = btn.closest('tr');
    document.getElementById('itemId').value  = tr.querySelector('.item-id').textContent.trim();
    document.getElementById('sku').value     = tr.querySelector('.item-sku').textContent.trim();
    document.getElementById('name').value    = tr.querySelector('.item-name').textContent.trim();
    // use raw (unformatted) price for the input
    const raw = tr.querySelector('.item-price-raw')?.textContent.trim() || '0.00';
    document.getElementById('unitPrice').value = raw;
    document.getElementById('sku').focus();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
  function clearForm(){
    ['itemId','sku','name','unitPrice'].forEach(id => document.getElementById(id).value = '');
  }
</script>

<%@ include file="/common/footer.jspf" %>
