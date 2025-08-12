<%@ page contentType="text/html;charset=UTF-8" %>
<%
  // If already logged in, go straight to dashboard
  if (session.getAttribute("user") != null) {
    response.sendRedirect("dashboard.jsp"); return;
  }
  String err = request.getParameter("err");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Pahana • Admin Login</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <style>
    :root {
      --brand:#2f4a66;
      --brand-2:#587798;
      --bg:#eaf2fb;
      --card:#ffffff;
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      display:grid;
      place-items:center;
      background:
        radial-gradient(ellipse at top, rgba(88,119,152,.18), transparent 60%),
        radial-gradient(ellipse at bottom, rgba(47,74,102,.12), transparent 60%),
        var(--bg);
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      color:#203040;
    }
    .wrap{width:100%; max-width:420px; padding:28px}
    .logo{
      display:flex; align-items:center; justify-content:center; gap:12px; margin-bottom:4px;
      color:var(--brand);
    }
    .logo svg{width:52px;height:52px}
    h1{margin:0; font-size:38px; letter-spacing:.5px}
    .sub{margin-top:2px; color:#8799ad; font-weight:600; letter-spacing:.25em; text-align:center}
    .card{
      margin-top:18px;
      background:var(--card);
      border-radius:18px;
      box-shadow:0 18px 45px rgba(0,0,0,.08);
      padding:22px 22px 26px;
    }
    .heading{margin:0 0 8px 0; font-size:18px; letter-spacing:.06em; color:#3b4e64; text-align:center}
    .field{position:relative; margin-top:12px}
    .field input{
      width:100%; padding:14px 14px 14px 46px; border-radius:14px; border:1px solid #d9e3ef;
      font-size:16px; outline:none; transition:border .18s, box-shadow .18s;
      background:#f8fbff;
    }
    .field input:focus{border-color:#b9cbe0; box-shadow:0 0 0 4px rgba(47,74,102,.10)}
    .field svg{
      position:absolute; left:14px; top:50%; transform:translateY(-50%);
      width:20px;height:20px; stroke:#7a90a7;
    }
    .btn{
      width:100%; margin-top:16px; padding:14px; border:0; border-radius:14px;
      background:linear-gradient(180deg, var(--brand), var(--brand-2));
      color:#fff; font-weight:700; font-size:18px; cursor:pointer;
      box-shadow:0 10px 24px rgba(47,74,102,.25);
    }
    .btn:hover{filter:brightness(1.02)}
    .err{
      margin-top:10px; padding:10px 12px; border-radius:12px; background:#fff1f1; border:1px solid #ffc9c9;
      color:#a33; font-size:14px; text-align:center;
    }
    .foot{margin-top:10px; text-align:center; color:#7c8fa6; font-size:12px}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="logo">
      <!-- mortarboard icon -->
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
        <path d="M12 3l10 5-10 5L2 8l10-5z"/>
        <path d="M6 10v4c0 2 6 4 6 4s6-2 6-4v-4"/>
      </svg>
      <h1>PAHANA</h1>
    </div>
    <div class="sub">ADMIN LOGIN</div>

    <form class="card" method="post" action="login">
      <h3 class="heading">Sign in to continue</h3>

      <% if ("bad".equals(err)) { %>
        <div class="err">Invalid username or password.</div>
      <% } else if ("server".equals(err)) { %>
        <div class="err">Server error. Please try again.</div>
      <% } %>

      <div class="field">
        <svg viewBox="0 0 24 24" fill="none"><path stroke-linecap="round" stroke-linejoin="round" d="M12 12a5 5 0 100-10 5 5 0 000 10zm7 9a7 7 0 10-14 0"/></svg>
        <input type="text" name="username" placeholder="Username" required autocomplete="username">
      </div>

      <div class="field">
        <svg viewBox="0 0 24 24" fill="none"><path stroke-linecap="round" stroke-linejoin="round" d="M12 11c-1.657 0-3 1.343-3 3v3h6v-3c0-1.657-1.343-3-3-3z"/><path stroke-linecap="round" stroke-linejoin="round" d="M7 11V8a5 5 0 1110 0v3"/></svg>
        <input type="password" name="password" placeholder="Password" required autocomplete="current-password" minlength="4">
      </div>

      <button class="btn" type="submit">Log In</button>
      <div class="foot">© <%= java.time.Year.now() %> Pahana</div>
    </form>
  </div>
</body>
</html>
