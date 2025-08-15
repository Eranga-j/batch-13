package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        ApiClient api = new ApiClient(apiBase);
        JsonObject json = Json.createObjectBuilder()
                .add("username", username == null ? "" : username)
                .add("password", password == null ? "" : password).build();
        JsonStructure result = api.sendJson("POST", "/auth/login", json.toString());
        if (result.asJsonObject().containsKey("error")) {
            req.setAttribute("error", result.asJsonObject().getString("error"));
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }
        var user = result.asJsonObject();
        HttpSession session = req.getSession(true);
        session.setAttribute("userId", user.getInt("id"));
        session.setAttribute("username", user.getString("username"));
        session.setAttribute("role", user.getString("role"));
        if ("ADMIN".equals(user.getString("role"))) resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        else resp.sendRedirect(req.getContextPath() + "/cashier/dashboard.jsp");
    }
}
