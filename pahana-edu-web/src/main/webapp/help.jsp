<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("user") == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Help</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
</head>
<body>
  <h2>Help</h2>
  <nav><a href="dashboard.jsp">Back</a></nav>
  <details open>
    <summary><b>How to add a customer</b></summary>
    <p>Dashboard → <i>Customer</i> → fill the form → <b>Add</b>. Account # must be unique. Phone must start with 07 and be 10 digits.</p>
  </details>
  <details>
    <summary><b>Edit or delete a customer</b></summary>
    <p>Customer list → click <b>Edit</b> to modify, or <b>Delete</b> to remove.</p>
  </details>
  <details>
    <summary><b>Create a bill</b></summary>
    <p>Dashboard → <i>Create Bill</i> → select customer and items → <b>Save</b>.</p>
  </details>
  <details>
    <summary><b>Troubleshooting</b></summary>
    <ul>
      <li>Start XAMPP MySQL and confirm <code>db.properties</code> has the right credentials.</li>
      <li>Service URL: launch <code>/pahana-edu-service/api/health</code> (should show <b>OK</b>).</li>
      <li>Web → Service base URL can be overridden with VM option:  
        <code>-Dservice.base=http://localhost:8080/pahana-edu-service/api/</code></li>
    </ul>
  </details>
</body>
</html>
