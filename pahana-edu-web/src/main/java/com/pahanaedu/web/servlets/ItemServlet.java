package com.pahanaedu.web.servlets;

import com.pahanaedu.web.api.ApiClient;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.json.Json;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet(name = "ItemServlet", urlPatterns = {"/items"})
public class ItemServlet extends HttpServlet {

    private String apiBase;

    @Override
    public void init() {
        this.apiBase = getServletContext().getInitParameter("apiBase");
        if (this.apiBase == null) this.apiBase = "http://localhost:8080/pahana-edu-service/api";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        ApiClient api = new ApiClient(apiBase);
        JsonStructure res = api.getJson("/items");
        JsonArray arr = res.asJsonArray();

        // Convert JSON -> List<Map<String,Object>> using plain Java types
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i = 0; i < arr.size(); i++) {
            JsonObject o = arr.getJsonObject(i);
            Map<String, Object> m = new HashMap<>();
            m.put("id", Integer.valueOf(o.getInt("id"))); // force Integer
            m.put("sku", o.getString("sku", ""));
            m.put("name", o.getString("name", ""));
            BigDecimal price = o.isNull("unitPrice")
                    ? BigDecimal.ZERO
                    : o.getJsonNumber("unitPrice").bigDecimalValue();
            m.put("unitPrice", price);                    // BigDecimal
            list.add(m);
        }

        req.setAttribute("items", list);
        req.getRequestDispatcher("/items/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        ApiClient api = new ApiClient(apiBase);

        if ("create".equals(action)) {
            BigDecimal unitPrice = new BigDecimal(req.getParameter("unitPrice"));
            JsonObject json = Json.createObjectBuilder()
                    .add("sku", req.getParameter("sku"))
                    .add("name", req.getParameter("name"))
                    .add("unitPrice", unitPrice)
                    .build();
            api.sendJson("POST", "/items", json.toString());

        } else if ("update".equals(action)) {
            String id = req.getParameter("id");
            BigDecimal unitPrice = new BigDecimal(req.getParameter("unitPrice"));
            JsonObject json = Json.createObjectBuilder()
                    .add("sku", req.getParameter("sku"))
                    .add("name", req.getParameter("name"))
                    .add("unitPrice", unitPrice)
                    .build();
            api.sendJson("PUT", "/items/" + id, json.toString());

        } else if ("delete".equals(action)) {
            String id = req.getParameter("id");
            api.sendJson("DELETE", "/items/" + id, "{}");
        }

        resp.sendRedirect(req.getContextPath() + "/items");
    }
}
