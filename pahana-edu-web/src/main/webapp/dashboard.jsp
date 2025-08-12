<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("user") == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
  <style>
    body { max-width: 1050px; }
    .dash { display:grid; grid-template-columns: repeat(auto-fit, minmax(160px,1fr)); gap:1.2rem; margin-top:1rem; }
    .card { display:flex; flex-direction:column; align-items:center; justify-content:center;
            padding:1.2rem; border:1px solid #e5e7eb; border-radius:14px; text-decoration:none; }
    .card:hover { box-shadow: 0 6px 22px rgba(0,0,0,.08); transform: translateY(-2px); transition:.18s; }
    .icon { width:74px; height:74px; margin-bottom:.6rem; stroke:#31455a; }
    .label { font-size:1.1rem; color:inherit; }
    .top { display:flex; align-items:center; justify-content:space-between; }
  </style>
</head>
<body>
  <div class="top">
    <h2>Dashboard</h2>
    <small>Signed in as <b><%= session.getAttribute("user") %></b></small>
  </div>

  <div class="dash">
    <!-- Customer -->
    <a class="card" href="customers" aria-label="Customers">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0z"/>
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 14c-4.418 0-8 2.239-8 5v1h16v-1c0-2.761-3.582-5-8-5z"/>
      </svg>
      <span class="label">Customer</span>
    </a>
    <%
  if (session.getAttribute("user") == null) { 
    response.sendRedirect("index.jsp"); 
    return; 
  }
%>


    <!-- Item -->
    <a class="card" href="items" aria-label="Items">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 7l9-4 9 4-9 4-9-4z"/>
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 7v10l9 4 9-4V7"/>
      </svg>
      <span class="label">Item</span>
    </a>

    <!-- Create Bill -->
    <a class="card" href="bill" aria-label="Create Bill">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M8 3h8a2 2 0 012 2v14l-6-3-6 3V5a2 2 0 012-2z"/>
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v6m3-3H9"/>
      </svg>
      <span class="label">Create Bill</span>
    </a>

    <!-- Reports -->
    <a class="card" href="reports" aria-label="Reports">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M4 19h16M6 17V9m6 8V5m6 14v-8"/>
      </svg>
      <span class="label">Reports</span>
    </a>

    <!-- Help -->
    <a class="card" href="help.jsp" aria-label="Help">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 18h.01M8.5 9a3.5 3.5 0 117 0c0 1.657-1.343 2.5-2.5 3.25-.8.5-1 1-1 1.75V15"/>
        <circle cx="12" cy="12" r="9" />
      </svg>
      <span class="label">Help</span>
    </a>

    <!-- Logout -->
    <a class="card" href="logout" aria-label="Logout">
      <svg class="icon" fill="none" viewBox="0 0 24 24" stroke-width="1.8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12H3m6-6l-6 6 6 6M16 3h3a2 2 0 012 2v14a2 2 0 01-2 2h-3"/>
      </svg>
      <span class="label">Logout</span>
    </a>
  </div>
</body>
</html>
