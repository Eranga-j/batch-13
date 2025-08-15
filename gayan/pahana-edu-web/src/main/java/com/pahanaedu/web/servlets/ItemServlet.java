package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ItemServlet", urlPatterns={"/items"})
public class ItemServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ApiClient api = new ApiClient(apiBase);
        JsonStructure res = api.getJson("/items");
        req.setAttribute("items", res);
        req.getRequestDispatcher("/items/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        ApiClient api = new ApiClient(apiBase);
        if ("create".equals(action)) {
            JsonObject json = Json.createObjectBuilder()
                    .add("sku", req.getParameter("sku"))
                    .add("name", req.getParameter("name"))
                    .add("unitPrice", new java.math.BigDecimal(req.getParameter("unitPrice")))
                    .build();
            api.sendJson("POST","/items", json.toString());
        } else if ("update".equals(action)) {
            String id = req.getParameter("id");
            JsonObject json = Json.createObjectBuilder()
                    .add("sku", req.getParameter("sku"))
                    .add("name", req.getParameter("name"))
                    .add("unitPrice", new java.math.BigDecimal(req.getParameter("unitPrice"))).build();
            api.sendJson("PUT", "/items/" + id, json.toString());
        } else if ("delete".equals(action)) {
            String id = req.getParameter("id");
            api.sendJson("DELETE", "/items/" + id, "{}");
        }
        resp.sendRedirect(req.getContextPath() + "/items");
    }
}
