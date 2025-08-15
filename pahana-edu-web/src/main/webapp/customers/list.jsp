<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/common/header.jspf" %>

<h2>Customers</h2>
<div class="grid">
  <%-- Admin-only: Add/Edit form --%>
  <% if (isAdmin) { %>
  <div class="card">
    <h3>Add / Edit Customer</h3>
    <form id="custForm" method="post" action="${pageContext.request.contextPath}/customers">
      <input type="hidden" name="id" id="custId"/>
      <label>Account No</label><input name="accountNumber" id="accNo" required/>
      <label>Name</label><input name="name" id="name" required/>
      <label>Address</label><input name="address" id="address"/>
      <label>Phone</label><input name="phone" id="phone"/>
      <div style="display:flex;gap:8px;margin-top:8px">
        <button class="btn" name="action" value="create">Save</button>
        <button class="btn secondary" name="action" value="update">Update</button>
        <button class="btn secondary" type="button" onclick="clearForm()">Clear</button>
      </div>
    </form>
  </div>
  <% } %>

  <div class="card">
    <h3>All Customers</h3>
    <table>
      <tr>
        <th>ID</th><th>Account No</th><th>Name</th><th>Phone</th>
        <% if (isAdmin) { %><th style="width:200px">Actions</th><% } %>
      </tr>
      <%
        List<Map<String,Object>> arr = (List<Map<String,Object>>) request.getAttribute("customers");
        if (arr != null) {
          for (Map<String,Object> c : arr) {
            Number idNum = (Number) c.get("id");
            String acc = (String) c.get("accountNumber");
            String nm  = (String) c.get("name");
            String ph  = (String) c.get("phone");
            String ad  = (String) c.get("address");
      %>
      <tr>
        <td class="cust-id"><%= idNum == null ? "" : idNum.intValue() %></td>
        <td class="cust-acc"><%= acc %></td>
        <td class="cust-name"><%= nm %></td>
        <td class="cust-phone"><%= ph == null ? "" : ph %></td>

        <% if (isAdmin) { %>
          <!-- keep address hidden in the row so Edit can fill it -->
          <td class="cust-address" style="display:none"><%= ad == null ? "" : ad %></td>
          <td>
            <button type="button" class="btn secondary" onclick="editRow(this)">Edit</button>
            <form class="inline" method="post" action="${pageContext.request.contextPath}/customers" style="display:inline">
              <input type="hidden" name="id" value="<%= idNum == null ? "" : idNum.intValue() %>"/>
              <button class="btn secondary" name="action" value="delete"
                      onclick="return confirm('Delete?')">Delete</button>
            </form>
          </td>
        <% } %>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
</div>

<% if (isAdmin) { %>
<script>
  function editRow(btn){
    const tr = btn.closest('tr');
    document.getElementById('custId').value = tr.querySelector('.cust-id').textContent.trim();
    document.getElementById('accNo').value  = tr.querySelector('.cust-acc').textContent.trim();
    document.getElementById('name').value   = tr.querySelector('.cust-name').textContent.trim();
    document.getElementById('phone').value  = tr.querySelector('.cust-phone').textContent.trim();
    const addrCell = tr.querySelector('.cust-address');
    document.getElementById('address').value = addrCell ? addrCell.textContent.trim() : '';
    document.getElementById('accNo').focus();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
  function clearForm(){
    ['custId','accNo','name','address','phone'].forEach(id => document.getElementById(id).value = '');
  }
</script>
<% } %>

<%@ include file="/common/footer.jspf" %>
