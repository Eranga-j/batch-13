package edu.pahana.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Very simple login:
 *  - username: admin
 *  - password: admin123   (change as needed or hook to DB)
 */
@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String u = req.getParameter("username");
    String p = req.getParameter("password");

    try {
      if ("admin".equalsIgnoreCase(u) && "admin123".equals(p)) {
        HttpSession s = req.getSession(true);
        s.setAttribute("user", u);
        // 30 minutes session
        s.setMaxInactiveInterval(30 * 60);
        resp.sendRedirect("dashboard.jsp");
      } else {
        resp.sendRedirect("index.jsp?err=bad");
      }
    } catch (Exception e) {
      resp.sendRedirect("index.jsp?err=server");
    }
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    // Prevent GET on /login; redirect to form
    resp.sendRedirect("index.jsp");
  }
}

