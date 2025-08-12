<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("user") == null) { response.sendRedirect("index.jsp"); return; }

  String customersJson = (String) request.getAttribute("customers");
  String itemsJson     = (String) request.getAttribute("items");
  if (customersJson == null) customersJson = "[]";
  if (itemsJson == null)     itemsJson     = "[]";

  String orderJson = (String) request.getAttribute("json");
  String err       = (String) request.getAttribute("err");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Create Bill</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
  <style>
    .row{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:.8rem}
    .warn{background:#fff6f2;border:1px solid #ffc9a8;padding:.5rem .7rem;border-radius:.5rem;margin:.6rem 0}
    table{width:100%;border-collapse:collapse}
    th,td{border-bottom:1px solid #e9eef4;padding:.45rem .5rem}
    .right{text-align:right}
    .print-area{background:#fff;padding:1rem;border-radius:10px;border:1px solid #e6e6e6}
    nav a{margin-right:.6rem}
  </style>
</head>
<body>
  <h2>Create Bill</h2>
  <nav>
    <a href="dashboard.jsp">Back</a>
    <!-- quick links you asked for -->
    <a href="customers">Customers</a>
    <a href="items">Items</a>
  </nav>

  <% if (err != null) { %>
    <div class="warn"><%= err %></div>
  <% } %>

  <form id="billForm" method="post" action="bill">
    <div class="row">
      <label>Customer phone
        <input id="phone" name="phone" pattern="07[0-9]{8}" placeholder="e.g., 0771234567" required>
      </label>
      <label>Customer ID
        <input id="customerIdView" placeholder="—" readonly>
        <input type="hidden" id="customerId" name="customerId">
      </label>
      <label>Customer name
        <input id="customerName" placeholder="—" readonly>
      </label>
    </div>

    <h3 style="margin-top:1rem">Items</h3>
    <table id="itemsTable">
      <thead>
        <tr>
          <th style="width:40%">Item</th>
          <th class="right" style="width:15%">Price</th>
          <th class="right" style="width:15%">Qty</th>
          <th class="right" style="width:20%">Line Total</th>
          <th style="width:10%"></th>
        </tr>
      </thead>
      <tbody></tbody>
      <tfoot>
        <tr><td colspan="5">
          <button type="button" id="addRow">+ Add item</button>
        </td></tr>
      </tfoot>
    </table>

    <div class="row" style="margin-top:.8rem">
      <div></div>
      <div>
        <div class="right">Subtotal: <b id="subTotal">0.00</b></div>
        <div class="right">Tax (8%): <b id="tax">0.00</b></div>
        <div class="right">Grand Total: <b id="grand">0.00</b></div>
      </div>
    </div>

    <input type="hidden" name="items" id="itemsJson"/>
    <div style="margin-top:1rem">
      <button type="button" id="calcSave">Calculate &amp; Save</button>
    </div>
  </form>

  <% if (orderJson != null && !orderJson.isBlank()) { %>
    <hr/>
    <h3>Invoice</h3>
    <div class="print-area" id="invoice">
      <pre style="white-space:pre-wrap"><%= orderJson %></pre>
    </div>
    <button onclick="window.print()">Print</button>
  <% } %>

<script>
  // Data from servlet
  const CUSTOMERS = JSON.parse('<%= customersJson.replace("\\","\\\\").replace("'","\\'") %>');
  const ITEMS     = JSON.parse('<%= itemsJson.replace("\\","\\\\").replace("'","\\'") %>');

  const phoneInput   = document.getElementById('phone');
  const custIdHidden = document.getElementById('customerId');
  const custIdView   = document.getElementById('customerIdView');
  const custNameView = document.getElementById('customerName');

  const itemsTBody   = document.querySelector('#itemsTable tbody');
  const itemsJsonInp = document.getElementById('itemsJson');

  /* ============ Customer lookup by phone ============ */
  function populateCustomerFromPhone() {
    const p = (phoneInput.value || '').replace(/\s+/g,'');
    const c = CUSTOMERS.find(x => (String(x.phone||'').replace(/\s+/g,'')) === p);
    if (c) {
      custIdHidden.value = c.id;
      custIdView.value   = c.id;
      custNameView.value = c.name || '';
    } else {
      custIdHidden.value = '';
      custIdView.value   = '';
      custNameView.value = 'Not found';
    }
  }
  phoneInput.addEventListener('blur', populateCustomerFromPhone);
  phoneInput.addEventListener('change', populateCustomerFromPhone);
  phoneInput.addEventListener('input', () => { custNameView.value = ''; });

  /* ============ Item rows ============ */
  function addRow(selectedId='', qty=1) {
    const tr = document.createElement('tr');

    // Item selector
    const tdItem = document.createElement('td');
    const sel = document.createElement('select');

    ITEMS.forEach(it => {
      const op = document.createElement('option');
      // label: Item Code – Item Name (backend field is usually 'sku')
      const code = it.sku || it.code || '';
      const label = [code, it.name].filter(Boolean).join(' – ') || `Item #${it.id}`;
      op.value = it.id;
      op.textContent = label;
      if (String(it.id) === String(selectedId)) op.selected = true;
      sel.appendChild(op);
    });
    tdItem.appendChild(sel);

    // Price (readonly text cell)
    const tdPrice = document.createElement('td'); tdPrice.className='right';

    // Quantity input
    const tdQty   = document.createElement('td'); tdQty.className='right';
    const qtyInput = document.createElement('input');
    qtyInput.type='number'; qtyInput.min='1'; qtyInput.value=qty; qtyInput.style.width='90px';
    tdQty.appendChild(qtyInput);

    // Line total
    const tdLine  = document.createElement('td'); tdLine.className='right';

    // Remove button
    const tdDel   = document.createElement('td');
    const btnDel  = document.createElement('button'); btnDel.type='button'; btnDel.textContent='Remove';
    btnDel.addEventListener('click', () => { tr.remove(); calcTotals(); });
    tdDel.appendChild(btnDel);

    function updatePriceAndLine() {
      const it = ITEMS.find(x => String(x.id) === String(sel.value));
      const price = it ? Number(it.unitPrice || it.price || 0) : 0;
      const q = Math.max(1, Number(qtyInput.value || 1));
      tdPrice.textContent = price.toFixed(2);
      tdLine.textContent  = (price*q).toFixed(2);
      calcTotals();
    }
    sel.addEventListener('change', updatePriceAndLine);
    qtyInput.addEventListener('input', updatePriceAndLine);

    tr.append(tdItem, tdPrice, tdQty, tdLine, tdDel);
    itemsTBody.appendChild(tr);
    updatePriceAndLine();
  }

  function calcTotals(){
    let sub = 0;
    [...itemsTBody.querySelectorAll('tr')].forEach(tr=>{
      const line = parseFloat(tr.children[3].textContent || '0');
      sub += isNaN(line) ? 0 : line;
    });
    const tax = sub * 0.08;
    document.getElementById('subTotal').textContent = sub.toFixed(2);
    document.getElementById('tax').textContent      = tax.toFixed(2);
    document.getElementById('grand').textContent    = (sub+tax).toFixed(2);
  }

  function onCalcSave(){
    populateCustomerFromPhone();
    if (!custIdHidden.value) { alert('Customer not found for the given phone'); return; }
    if (itemsTBody.children.length === 0) { alert('Add at least one item'); return; }

    const out = [];
    [...itemsTBody.querySelectorAll('tr')].forEach(tr=>{
      const itemId = tr.querySelector('select').value;
      const qty    = Math.max(1, Number(tr.querySelector('input[type=number]').value || 1));
      out.push({ itemId: Number(itemId), quantity: qty });
    });
    itemsJsonInp.value = JSON.stringify(out);
    document.getElementById('billForm').submit();
  }

  // init
  document.getElementById('addRow').addEventListener('click', ()=> addRow());
  document.getElementById('calcSave').addEventListener('click', onCalcSave);
  addRow();
</script>
</body>
</html>
